#!/usr/bin/env bash
# Save/restore open Hyprland windows (app, workspace, geometry, floating,
# fullscreen) via hyprctl + jq. See hyprland.lua (restore on start) and
# keybindings.lua (manual save keybind) for how this gets wired in.
set -euo pipefail

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/session.json"
MAP_FILE="$HOME/.config/hypr/scripts/hypr-session-apps.conf"
DELAY=1.2
WARMUP=3
DRY_RUN=0
FORCE=0

usage() {
	cat <<'EOF'
Usage: hypr-session.sh <save|restore|list> [options]

Commands:
  save                     Snapshot currently open windows
  restore                  Relaunch windows from a saved snapshot
  list                     Print the saved snapshot as a table

Options (save/restore):
  -f, --file PATH          State file (default: ~/.local/state/hypr/session.json)
  -m, --map PATH           Class->command override map
                           (default: ~/.config/hypr/scripts/hypr-session-apps.conf)

Options (restore only):
  -d, --delay SECONDS      Delay between launching each window (default: 1.2)
  -w, --warmup SECONDS     Delay before the first launch (default: 3)
  -n, --dry-run            Print what would be launched, don't run it
      --force              Relaunch even if a matching window is already open
  -h, --help               Show this help
EOF
}

need() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "hypr-session.sh: '$1' is required but not found (try: sudo pacman -S $1)" >&2
		exit 1
	fi
}

regex_escape() {
	printf '%s' "$1" | sed -e 's/[.[\*^$()+?{|]/\\&/g'
}

# Resolves how to relaunch a window's app: an exact override in the map file
# wins (including the SKIP sentinel to exclude a class entirely), else a
# best-effort guess from /proc/<pid>/cmdline, else the lowercased class name.
resolve_launch_cmd() {
	local class="$1" pid="$2"
	if [[ -f "$MAP_FILE" ]]; then
		local override
		override="$(awk -F= -v c="$class" '
			/^[[:space:]]*#/ {next}
			/^[[:space:]]*$/ {next}
			$1==c {sub(/^[^=]*=/,""); print; exit}
		' "$MAP_FILE")"
		if [[ -n "$override" ]]; then
			printf '%s' "$override"
			return
		fi
	fi
	if [[ -r "/proc/$pid/cmdline" ]]; then
		local args=() arg
		while IFS= read -r -d '' arg; do
			args+=("$(printf '%q' "$arg")")
		done <"/proc/$pid/cmdline"
		if ((${#args[@]} > 0)); then
			printf '%s' "${args[*]}"
			return
		fi
	fi
	printf '%s' "${class,,}"
}

cmd_save() {
	need jq
	need hyprctl
	mkdir -p "$(dirname "$STATE_FILE")"

	local entries=()
	# process substitution (not a pipe) so `entries` survives past the loop
	while IFS= read -r entry; do
		local class pid launch_cmd
		class="$(jq -r '.class' <<<"$entry")"
		pid="$(jq -r '.pid' <<<"$entry")"
		launch_cmd="$(resolve_launch_cmd "$class" "$pid")"
		if [[ "$launch_cmd" == "SKIP" ]]; then
			continue
		fi
		entries+=("$(jq --arg cmd "$launch_cmd" '. + {cmd: $cmd}' <<<"$entry")")
	done < <(hyprctl clients -j | jq -c '[.[] | select(.mapped == true) | {
		class: (.initialClass // .class),
		title: .title,
		workspace: .workspace.id,
		at: .at,
		size: .size,
		floating: .floating,
		fullscreen: ((.fullscreen // 0) != 0),
		pid: .pid
	}] | .[]')

	if ((${#entries[@]} == 0)); then
		printf '[]\n' >"$STATE_FILE"
	else
		printf '%s\n' "${entries[@]}" | jq -s '.' >"$STATE_FILE"
	fi
	echo "hypr-session: saved ${#entries[@]} window(s) to $STATE_FILE"
}

cmd_restore() {
	need jq
	need hyprctl

	if [[ ! -f "$STATE_FILE" ]]; then
		echo "hypr-session: no saved session at $STATE_FILE, nothing to restore."
		exit 0
	fi

	sleep "$WARMUP"

	declare -A open_count
	while IFS= read -r class; do
		if [[ -z "$class" ]]; then
			continue
		fi
		open_count["$class"]=$((${open_count["$class"]:-0} + 1))
	done < <(hyprctl clients -j | jq -r '.[] | select(.mapped==true) | (.initialClass // .class)')

	local launched=0
	while IFS= read -r entry; do
		local class ws floating fullscreen cmd rules dispatch_cmd
		class="$(jq -r '.class' <<<"$entry")"
		ws="$(jq -r '.workspace' <<<"$entry")"
		floating="$(jq -r '.floating' <<<"$entry")"
		fullscreen="$(jq -r '.fullscreen' <<<"$entry")"
		cmd="$(jq -r '.cmd' <<<"$entry")"

		if [[ "$FORCE" != "1" && "${open_count[$class]:-0}" -gt 0 ]]; then
			open_count["$class"]=$((open_count["$class"] - 1))
			continue
		fi

		rules="workspace $ws silent"
		if [[ "$floating" == "true" ]]; then
			local x y w h
			x="$(jq -r '.at[0]' <<<"$entry")"
			y="$(jq -r '.at[1]' <<<"$entry")"
			w="$(jq -r '.size[0]' <<<"$entry")"
			h="$(jq -r '.size[1]' <<<"$entry")"
			rules="$rules;float;move $x $y;size $w $h"
		fi
		dispatch_cmd="[$rules] $cmd"

		if [[ "$DRY_RUN" == "1" ]]; then
			echo "hyprctl dispatch exec -- \"$dispatch_cmd\""
		else
			hyprctl dispatch exec -- "$dispatch_cmd"
		fi
		launched=$((launched + 1))
		sleep "$DELAY"

		if [[ "$fullscreen" == "true" ]]; then
			# Best-effort only: targets the first window matching this class,
			# so this misfires if multiple same-class windows were fullscreen.
			local selector="class:^$(regex_escape "$class")\$"
			if [[ "$DRY_RUN" == "1" ]]; then
				echo "hyprctl dispatch focuswindow \"$selector\" && hyprctl dispatch fullscreen 1"
			else
				hyprctl dispatch focuswindow "$selector" || true
				hyprctl dispatch fullscreen 1 || true
			fi
		fi
	done < <(jq -c '.[]' "$STATE_FILE")

	echo "hypr-session: restore complete ($launched window(s) launched)"
}

cmd_list() {
	need jq
	if [[ ! -f "$STATE_FILE" ]]; then
		echo "hypr-session: no saved session at $STATE_FILE"
		exit 0
	fi
	{
		printf 'WORKSPACE\tCLASS\tFLOATING\tPOS\tSIZE\tCMD\n'
		jq -r '.[] | [.workspace, .class, .floating, (.at|tostring), (.size|tostring), .cmd] | @tsv' "$STATE_FILE"
	} | column -t -s $'\t'
}

main() {
	local sub="${1:-}"
	if [[ $# -gt 0 ]]; then
		shift
	fi

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-f | --file)
			STATE_FILE="$2"
			shift 2
			;;
		-m | --map)
			MAP_FILE="$2"
			shift 2
			;;
		-d | --delay)
			DELAY="$2"
			shift 2
			;;
		-w | --warmup)
			WARMUP="$2"
			shift 2
			;;
		-n | --dry-run)
			DRY_RUN=1
			shift
			;;
		--force)
			FORCE=1
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			echo "hypr-session.sh: unknown option: $1" >&2
			usage >&2
			exit 1
			;;
		esac
	done

	case "$sub" in
	save) cmd_save ;;
	restore) cmd_restore ;;
	list) cmd_list ;;
	-h | --help | "") usage ;;
	*)
		echo "hypr-session.sh: unknown command: $sub" >&2
		usage >&2
		exit 1
		;;
	esac
}

main "$@"

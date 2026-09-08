#!/usr/bin/env bash
# Thin CLI wrapper for testing session.lua's save/restore from a terminal.
# All the actual logic lives in session.lua; this just shells out to hyprctl
# using the same lua-eval dispatch bridge Noctalia's [hooks] use.
set -euo pipefail

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/session.lua"

usage() {
	cat <<'EOF'
Usage: hypr-session.sh <save|restore|list>

  save     Snapshot currently open windows (same call Noctalia's logout/
           reboot/shutdown hooks make)
  restore  Relaunch windows from the saved snapshot (same call hyprland.lua
           makes on startup)
  list     Print the saved snapshot (it's a plain Lua table literal)
EOF
}

need_hyprctl() {
	if ! command -v hyprctl >/dev/null 2>&1; then
		echo "hypr-session.sh: 'hyprctl' not found — this only works inside a running Hyprland session" >&2
		exit 1
	fi
}

case "${1:-}" in
save)
	need_hyprctl
	hyprctl dispatch 'function() require("session").save() end'
	echo "hypr-session: save dispatched"
	;;
restore)
	need_hyprctl
	hyprctl dispatch 'function() require("session").restore() end'
	echo "hypr-session: restore dispatched"
	;;
list)
	if [[ -f "$STATE_FILE" ]]; then
		cat "$STATE_FILE"
	else
		echo "hypr-session: no saved session at $STATE_FILE"
	fi
	;;
-h | --help | "")
	usage
	;;
*)
	echo "hypr-session.sh: unknown command: $1" >&2
	usage >&2
	exit 1
	;;
esac

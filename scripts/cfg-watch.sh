#!/bin/zsh
# ~/.config/scripts/cfg-watch.sh
CONFIG_DIR="$HOME/.config"
LOCKFILE="/tmp/cfg-watch.lock"
DEBOUNCE_SECONDS=3

echo "👀 Watching ~/.config for changes..."

typeset -A pending # relpath -> 1; dedupes repeat writes within one batch

flush() {
	(( ${#pending} == 0 )) && return

	local -a files=("${(@k)pending}")
	pending=()

	echo ""
	echo "📝 Changed (batch of ${#files}): ${files[*]}"

	exec {lock_fd}>"$LOCKFILE"
	flock -w 10 "$lock_fd" || {
		echo "   ⚠️  Could not acquire lock, skipping batch of ${#files} file(s)"
		exec {lock_fd}>&-
		return 1
	}

	# Retry add a few times in case gitstatusd is holding index.lock
	for i in 1 2 3 4 5; do
		if git -C "$CONFIG_DIR" add -- "${files[@]}" 2>/tmp/gitadd.err; then
			break
		fi
		grep -q "index.lock" /tmp/gitadd.err && sleep 0.5 || break
	done

	if git -C "$CONFIG_DIR" diff --cached --quiet; then
		echo "   (staged but no actual content changes, skipping commit)"
		exec {lock_fd}>&-
		return 0
	fi

	local msg
	if (( ${#files} == 1 )); then
		msg="cfg-watch: update ${files[1]} ($(date '+%Y-%m-%d %H:%M:%S'))"
	else
		msg="cfg-watch: update ${#files} files ($(date '+%Y-%m-%d %H:%M:%S'))"
	fi
	git -C "$CONFIG_DIR" commit -m "$msg"

	# Retry push with rebase in case remote moved under us
	for i in 1 2 3; do
		if git -C "$CONFIG_DIR" push; then
			break
		fi
		echo "   ↻ Push rejected, fetching + rebasing and retrying..."
		git -C "$CONFIG_DIR" fetch
		git -C "$CONFIG_DIR" rebase "@{u}" || {
			echo "   ⚠️ Rebase conflict, resolve manually"
			break
		}
	done

	exec {lock_fd}>&-
}

inotifywait -m -r -e close_write,moved_to,create \
	--exclude '(\.git/|\.swp$|~$|/4913$)' \
	--format '%w%f' \
	"$CONFIG_DIR" | while true; do
	if read -r -t "$DEBOUNCE_SECONDS" filepath; then
		relpath="${filepath#$CONFIG_DIR/}"

		# Skip if the file is already gone (vim temp files, editor swap churn, etc.)
		[[ ! -e "$filepath" ]] && continue

		# Skip gitignored files
		git -C "$CONFIG_DIR" check-ignore -q "$relpath" 2>/dev/null && continue
		[[ "$relpath" == .git/* ]] && continue

		pending[$relpath]=1
	else
		flush
	fi
done

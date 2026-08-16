#!/bin/zsh
# ~/.config/scripts/cfg-watch.sh
CONFIG_DIR="$HOME/.config"
LOCKFILE="/tmp/cfg-watch.lock"

echo "👀 Watching ~/.config for changes..."
inotifywait -m -r -e close_write,moved_to,create \
  --exclude '(\.git/|\.swp$|~$|/4913$)' \
  --format '%w%f' \
  "$CONFIG_DIR" | while read -r filepath; do

  relpath="${filepath#$CONFIG_DIR/}"

  # Skip if the file is already gone (vim temp files, editor swap churn, etc.)
  [[ ! -e "$filepath" ]] && continue

  # Skip gitignored files
  git -C "$CONFIG_DIR" check-ignore -q "$relpath" 2>/dev/null && continue
  [[ "$relpath" == .git/* ]] && continue

  echo ""
  echo "📝 Changed: $relpath"
  msg="cfg-watch: update $relpath ($(date '+%Y-%m-%d %H:%M:%S'))"

  (
    exec {lock_fd}>"$LOCKFILE"
    flock -w 10 "$lock_fd" || { echo "   ⚠️  Could not acquire lock, skipping"; exit 1; }

    # Retry add/commit a few times in case gitstatusd is holding index.lock
    for i in 1 2 3 4 5; do
      if git -C "$CONFIG_DIR" add "$filepath" 2>/tmp/gitadd.err; then
        break
      fi
      grep -q "index.lock" /tmp/gitadd.err && sleep 0.5 || break
    done

    git -C "$CONFIG_DIR" commit -m "$msg"

    # Retry push with rebase in case remote moved under us
    for i in 1 2 3; do
      if git -C "$CONFIG_DIR" push; then
        break
      fi
      echo "   ↻ Push rejected, fetching + rebasing and retrying..."
      git -C "$CONFIG_DIR" fetch
      git -C "$CONFIG_DIR" rebase "@{u}" || { echo "   ⚠️ Rebase conflict, resolve manually"; break; }
    done
  )
done

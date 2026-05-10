#!/bin/zsh
# ~/.config/scripts/cfg-watch.sh

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(dirname "$0")"

echo "👀 Watching ~/.config for changes..."

inotifywait -m -r -e close_write,moved_to,create,delete \
  --exclude '\.git' \
  --format '%w%f' \
  "$CONFIG_DIR" | while read -r filepath; do

  # Get relative path
  relpath="${filepath#$CONFIG_DIR/}"

  # Skip gitignored files
  if git -C "$CONFIG_DIR" check-ignore -q "$relpath" 2>/dev/null; then
    continue
  fi

  # Skip .git internals
  [[ "$relpath" == .git/* ]] && continue

  echo ""
  echo "📝 Changed: $relpath"
  read "msg?   Commit message (blank to skip): "

  [[ -z "$msg" ]] && continue

  git -C "$CONFIG_DIR" add "$filepath"
  git -C "$CONFIG_DIR" commit -m "$msg"
  git -C "$CONFIG_DIR" push
done

lsp() {
  local show_full=0
  local show_all=0

  usage() {
    echo "Usage: lsp [-f] [-a] [-h] [path ...]"
    echo "  -f  Show full absolute paths"
    echo "  -a  Include hidden files"
    echo "  -h  Show help"
  }

  while getopts ":fah" opt; do
    case $opt in
      f) show_full=1 ;;
      a) show_all=1 ;;
      h) usage; return 0 ;;
      *) usage >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  # If no path args, use current dir
  [ $# -eq 0 ] && set -- .

  for target in "$@"; do
    if [ -d "$target" ]; then
      # Use globbing to collect files
      if [ "$show_all" -eq 1 ]; then
        files=$(find "$target" -maxdepth 1 -mindepth 1)
      else
        files=$(find "$target" -maxdepth 1 -mindepth 1 ! -name '.*')
      fi
    elif [ -e "$target" ]; then
      files="$target"
    else
      echo "lsp: $target: No such file or directory" >&2
      continue
    fi

    while IFS= read -r file; do
      [ -e "$file" ] || continue
      fullpath=$(realpath "$file")
      if [ "$show_full" -eq 1 ]; then
        echo "$fullpath"
      else
        case "$fullpath" in
          "$HOME"/*) echo "~/${fullpath#"$HOME"/}" ;;
          *)         echo "$fullpath" ;;
        esac
      fi
    done <<< "$files"
  done
}

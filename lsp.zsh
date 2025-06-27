lsp() {
  local show_full=0
  local show_all=0

  usage() {
    echo "Usage: lsp [-f] [-a] [-h]"
    echo "  -f  Show full absolute paths"
    echo "  -a  Include hidden files"
    echo "  -h  Show this help message"
  }

  # Parse flags
  while getopts ":fah" opt; do
    case $opt in
      f) show_full=1 ;;
      a) show_all=1 ;;
      h) usage; return 0 ;;
      *) usage >&2; return 1 ;;
    esac
  done

  shift $((OPTIND - 1))

  # Choose file pattern
  if (( show_all )); then
    files=(*(.D))  # includes hidden files (but not . or ..)
  else
    files=(*)      # visible files only
  fi

  for file in "${files[@]}"; do
    [[ -e "$file" ]] || continue
    filepath=$(realpath "$file")
    (( show_full )) && echo "$filepath" || echo "${filepath/#$HOME/~}"
  done
}

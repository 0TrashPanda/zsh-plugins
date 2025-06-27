toggle-ls-cat() {
  case "$LBUFFER" in
    ls\ *)  LBUFFER="cat ${LBUFFER#ls }" ;;
    cat\ *) LBUFFER="ls ${LBUFFER#cat }" ;;
    *)      LBUFFER="cat $LBUFFER" ;;
  esac
}
zle -N toggle-ls-cat
bindkey '^[u' toggle-ls-cat  # Alt+U

if type -P jq &>/dev/null; then
  function jql() {
    $(type -P jq) -C "$@" | less -R
  }
fi

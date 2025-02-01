if type -P direnv &>/dev/null; then
  source <(direnv hook bash)
  # Modify direnv hook to be less verbose when there are many env vars
  copy_function() {
    test -n "$(declare -f "$1")" || return
    eval "${_/$1/$2}"
  }
  copy_function _direnv_hook _direnv_hook__old
  _direnv_hook() {
    _direnv_hook__old "$@" 2> >(awk '{if (length >= 200) { sub("^direnv: export.*","direnv: exported "NF" environment variables")}}1')
    wait $!
  }
fi

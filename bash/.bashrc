#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend

# Setup prompt
RED=$(printf "\1\e[0;31m\2")
RESET=$(printf "\1\e[m\2")
if [ $(id -u) -gt 0 ]; then
  PS1='$(if [ $? -gt 0 ]; then printf $RED; fi)\$$RESET '
else
  PS1='$(if [ $? -gt 0 ]; then printf $RED; fi)#$RESET '
fi

# Append "$1" to $PATH when not already in
# This function is accessible to fragments in ~/.bashrc.d
append_path () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="${PATH:+$PATH:}$1"
  esac
}

########################################################################
# Aliases
########################################################################
alias less='less -R'
alias grep='grep --colour=auto'
alias df="df -h | awk '!match(\$0, /^\\/dev\\/loop/) {print \$0}'"
alias free='free -h'
alias ls='ls --color=auto -halF'
alias lg='lazygit'
alias sshi='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias pacdiff='sudo -E DIFFPROG="nvim -d" pacdiff'

########################################################################
# Envs
########################################################################
export LC_CTYPE='en_US.UTF-8'
export EDITOR=vi

########################################################################
# Paths
########################################################################
append_path ~/.local/bin

# Load fragments from ~/.bashrc.d
for conf in ~/.bashrc.d/*.sh; do
  if [ -x $conf ]; then
    source $conf
  fi
done

unset -f append_path

########################################################################
# Completion and utilities
########################################################################
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
type -P kubectl &>/dev/null && source <(kubectl completion bash)
type -P helm &>/dev/null && source <(helm completion bash)
type -P zoxide &>/dev/null && source <(zoxide init bash)
type -P tmux-sessionizer &>/dev/null && bind '"\C-f":"tmux-sessionizer\n"'

if [ -x /usr/share/nvm/init-nvm.sh ]; then
  # nvm start is slow, make it available as a function
  function nvmstart() {
    source /usr/share/nvm/init-nvm.sh
  }
fi

export PNPM_HOME=~/.pnpm
append_path $PNPM_HOME

source /home/minhngkh/cachyos-config.zsh

alias "?"="gh copilot suggest"
alias "??"="gh copilot explain"
alias "git?"="gh copilot suggest -t git"

alias "cat"="bat"

alias "ls"="lsd"
alias "ll"="lsd -l"
alias "la"="lsd -a"
alias "lla"="lsd -la"

function lt {
   if [[ "$1" =~ ^[0-9]+$ ]]
   then
      lsd --tree --depth=$1 "${@:2}"
   else
      lsd --tree "$@"
   fi
}
compdef lt=lsd

function mc {
	mkdir "$@" && cd $_ 
}
compdef mc=mkdir

export CHEAT_USE_FZF=true

() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" history-substring-search-up
   done
   for key in $down[@]; do
      bindkey "$key" history-substring-search-down
   done
}

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fly.io
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# local bin
export LOCAL_BIN="$HOME/.local/bin"
export PATH="$LOCAL_BIN:$PATH"

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

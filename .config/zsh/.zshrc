# oh-my-posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/custom.omp.toml)"

## ANTIDOTE
# source $HOME/.antidote/antidote.zsh
# antidote load

fpath=("$HOME/.cache/zsh/completions" $fpath)

zsh_plugins="$ZDOTDIR/.zsh_plugins"

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($HOME/.antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh
##

# Setup fzf shell integration
source $HOME/.cache/fzf-shell-intergration

# Setup fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Setup zoxide
eval "$(zoxide init zsh)"

alias lg="lazygit"
# alias docker="sudo docker"
# alias kubectl="sudo kubectl"
# alias kind="sudo kind"
# alias helm="sudo helm"

alias explain="gh copilot explain"
alias suggest="gh copilot suggest"
alias cat="bat -p"
alias ls="lsd"
alias ll="lsd -l --group-directories-first"
alias la="lsd -la"
alias lla="lsd -la --group-directories-first"

alias -g -- --help='--help 2>&1 | bat --language=help -p'

lt() {
   if [[ "$1" =~ ^[0-9]+$ ]]
   then
      lsd --group-directories-first --tree --depth=$1 "${@:2}"
   else
      lsd --group-directories-first --tree "$@"
   fi
}

mc() {
    mkdir -p "$1" && cd "$1"
}

aws-ctx() {
  export AWS_PROFILE="$(aws configure list-profiles | fzf)"
  echo "Switched to profile ""$AWS_PROFILE""."
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

precmd() {
    precmd() {
        echo
    }
}

zle -N y
zle -N __zoxide_zi

bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down
bindkey "^Z" undo
bindkey "^[y" y
bindkey "^[z" __zoxide_zi

# default aws profile
export AWS_PROFILE="minhngkh"

# pfetch config
export PF_INFO="ascii title os kernel uptime pkgs shell wm"

# bat config
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# fzf config
export FZF_DEFAULT_COMMAND='fd -t f'
t_dirs=(
    "$HOME"
    "/usr/local/share"
    "/usr/share/applications"
)
c_dirs=(
    "$HOME"
    "/opt"
    "/usr/local/share"
    "/usr/share/applications"
    # "/tmp"
)
export FZF_CTRL_T_COMMAND="fd -d 4 -t f -t d -H -E node_modules . $t_dirs | sed \"s|^$HOME|~|\""
# export FZF_CTRL_T_COMMAND="fd -d 4 -t f -t d -H -E node_modules"
# export FZF_CTRL_T_OPTS="
# --walker-root='~'"
export FZF_ALT_C_COMMAND="fd -d 4 -t d -H -E node_modules . $c_dirs | sed \"s|^$HOME|~|\""
export FZF_ALT_C_OPTS="
    --walker-root ~
    --preview 'lsd {} -1 -A --group-directories-first --icon=always --color=always'"

fastfetch
echo

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install



#######################################################################################
#######################################################################################

export LESS='-R --mouse'

# oh-my-posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/custom.omp.toml)"

# # Setup fzf shell integration
source $HOME/.cache/fzf-shell-intergration

# Setup zoxide
eval "$(zoxide init zsh)"

# Setup fnm
eval "$(fnm env --use-on-cd --shell zsh)"

alias lg="lazygit"
alias ldk="lazydocker"
alias tf="terraform"
# # alias docker="sudo docker"
# # alias kubectl="sudo kubectl"
# # alias kind="sudo kind"
# # alias helm="sudo helm"

alias explain="gh copilot explain"
alias suggest="gh copilot suggest"
alias cat="bat -p"
alias ls="lsd"
alias ll="lsd -l --group-directories-first"
alias la="lsd -la"
alias lla="lsd -la --group-directories-first"
alias fzfa="fzf --ansi"
# alias zj="zellij-sessions"

# # alias -g -- --help='--help 2>&1 | bat --language=help -p'

# lt() {
#    if [[ "$1" =~ ^[0-9]+$ ]]
#    then
#       lsd --group-directories-first --tree --depth=$1 "${@:2}"
#    else
#       lsd --group-directories-first --tree "$@"
#    fi
# }

mc() {
    mkdir -p "$1" && cd "$1"
}

# aws-ctx() {
#   export AWS_PROFILE="$(aws configure list-profiles | fzf)"
#   echo "Switched to profile ""$AWS_PROFILE""."
# }

y() {
  local start_action

	if [[ "$1" == --action=* ]]; then
		start_action="${1#--action=}"
		shift
	fi

	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd

  if [[ -n "$start_action" ]]; then 
    YAZI_START_ACTION="zoxide" yazi "$@" --cwd-file="$tmp"
  else
    yazi "$@" --cwd-file="$tmp"
  fi
	
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

_reset_prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  
  zle .reset-prompt
}

_y_widget() {
  y
  _reset_prompt
}

_zi_widget() {
  __zoxide_zi
  _reset_prompt
}

_y_zi_widget() {
    y --action=zoxide
    _reset_prompt
}

_tv_search() {
    emulate -L zsh
    zle -I

    local current_prompt
    current_prompt=$LBUFFER

    local output

    output=$(tv --autocomplete-prompt "$current_prompt" $*)

    zle reset-prompt

    if [[ -n $output ]]; then
        RBUFFER=""
        LBUFFER=$current_prompt$output

        # uncomment this to automatically accept the line
        # (i.e. run the command without having to press enter twice)
        # zle accept-line
    fi
}

precmd() {
    precmd() {
        echo
    }
}

zle -N _y_widget
zle -N _zi_widget
zle -N _y_zi_widget
zle -N tv_search _tv_search

# bindkey "^[[A" history-substring-search-up
# bindkey "^[[B" history-substring-search-down
bindkey "^Z" undo
bindkey "^[y" _y_widget
bindkey "^[z" _zi_widget
# bindkey "^t" tv_search
bindkey "^[o" _y_zi_widget 


# # default aws profile
# export AWS_PROFILE="minhngkh"

# # pfetch config
# export PF_INFO="ascii title os kernel uptime pkgs shell wm"

# # bat config
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# # fzf config
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
# export FZF_ALT_C_OPTS="
	# --walker-root='~'
    # --preview 'lsd {} -1 -A --group-directories-first --icon=always --color=always'"


if (( RANDOM % 2 )); then
  echo -ne '\x1b[38;5;214m'
  # echo '                               ___'
  # echo '    _      ______  ____  ____ <  /'
  # echo '   | | /| / /_  / / __ \/ __ \/ / '
  # echo '  _| |/ |/ / / /_/ /_/ / / / / /  '
  # echo ' (_)__/|__/ /___/ .___/_/ /_/_/   '
  # echo '               /_/                '
  echo '         __                  '
  echo '        / /___  ______  ____ '
  echo ' ______/ __/ / / / __ \/ __ \'
  echo '/_____/ /_/ /_/ / /_/ / / / /'
  echo '      \__/\__, / .___/_/ /_/ '
  echo '         /____/_/            '
  echo
  echo -ne '\x1b[0m'           # Reset colour
else
  fastfetch
fi

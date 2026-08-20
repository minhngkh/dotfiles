########
# ZIM
########
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

source ${ZIM_HOME}/init.zsh

########


########
# Functions
########
_reset_prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  
  zle .reset-prompt
}

precmd() {
    precmd() {
        echo
    }
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

########

########
# Shell integrations
########
int="$ZDOTDIR/integrations"
custom="$ZDOTDIR/custom"

source "$int/_fzf"
source "$int/_wt"
source "$int/_zoxide"

source "$custom/fzf.zsh"
source "$custom/mkdir_and_cd.zsh"
source "$custom/yazi.zsh"
source "$custom/zoxide.zsh"
source "$custom/worktrunk.zsh"
source "$custom/yadm.zsh"

# Vite+ bin (https://viteplus.dev)
source  "$HOME/.vite-plus/env"

# eval "$(fnm env --use-on-cd --shell zsh)"
# source $HOME/.cache/fzf-shell-intergration
########


########
# Prompt
########
# oh-my-posh prompt
# eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/custom.omp.toml)"
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/default.omp.json)"
# nordtron - 
########


########
# env
########

# due to nix import always being first
export PATH="$HOME/.local/bin:$PATH"

export LESS='-R --mouse'
export OPENCODE_DISABLE_CLAUDE_CODE=true
export OPENCODE_EXPERIMENTAL_OXFMT=true
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
# export OPENCODE_EXPERIMENTAL_WORKSPACES=true
# export OPENCODE_ENABLE_EXA=true
# export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export PF_INFO="ascii title os kernel uptime pkgs shell wm"

WT_REPOS=(
  # "sat (be):~/work/sat/repo:src/backend/SAT-Api/:wt"
  "sat:~/work/sat/repo::wt"
  "payroll:~/work/payroll/repo:src/BGSVPayroll/:wt"
  "~/.config/hypr/"
  "~/.config/opencode/"
)

export s="./src/BGSVPayroll"

export OC_SLIM_CONFIG="$HOME/.config/opencode-slim"

export RUNTIME_LAZYGIT_BIN='$HOME/.nix-profile/bin/lazygit'
export RUNTIME_FZF_BIN='$HOME/.nix-profile/bin/fzf'

dpr=(--project PayrollApp.Infrastructure --startup-project PayrollApp.Web)
########


########
# Aliases
########
alias cd="z"
alias lg="lazygit"
alias ldk="lazydocker"
alias opencode="opencode2"
# alias oc="opencode"
# alias ocd="opencode serve"
# alias oci="OH_MY_OPENCODE_SLIM_PRESET=plan opencode"
# alias ocid="OH_MY_OPENCODE_SLIM_PRESET=plan opencode --port 4097 serve"
# alias oc0="opencode attach http://localhost:4096 --dir ."
# alias oc1="opencode attach http://localhost:4097 --dir ."
# alias tf="terraform"
# # alias kind="sudo kind"
# # alias helm="sudo helm"

alias cat="bat -p"
alias ls="lsd"
alias ll="lsd -l --group-directories-first"
alias la="lsd -la"
alias lla="lsd -la --group-directories-first"
alias fzfa="fzf --ansi"
# alias zj="zellij-sessions"

# # alias -g -- --help='--help 2>&1 | bat --language=help -p'
########


########
# Keybinds
########
# bindkey "^[[A" history-substring-search-up
# bindkey "^[[B" history-substring-search-down
bindkey "^Z" undo
########


########
# Configs
########
# man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
########


########
# Misc.
########
if [[ "$TERM" == *"ghostty"* || "$TERM_PROGRAM" == "ghostty" ]]; then
  if (( RANDOM % 2 )); then
    echo -ne '\x1b[38;5;214m'
    # echo '                               ___'
    # echo '    _      ______  ____  ____ <  /'
    # echo '   | | /| / /_  / / __ \/ __ \/ / '
    # echo '  _| |/ |/ / / /_/ / / / / / / /  '
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
    # fastfetch
    # pfetch

    echo -ne '\x1b[38;5;214m'
    echo '                               ___'
    echo '    _      ______  ____  ____ <  /'
    echo '   | | /| / /_  / / __ \/ __ \/ / '
    echo '  _| |/ |/ / / /_/ / / / / / / /  '
    echo ' (_)__/|__/ /___/ .___/_/ /_/_/   '
    echo '               /_/                '
    echo
    echo -ne '\x1b[0m'           # Reset colour
  fi
fi
########

# bun completions
[ -s "/home/gmi4hc/.bun/_bun" ] && source "/home/gmi4hc/.bun/_bun"

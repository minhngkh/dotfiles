# Keep ~ in ctrl-t selections
fzf-file-widget() {
  local selection
  selection="$(__fzf_select)"
  local ret=$?
  selection="${selection//\\~/~}"
  LBUFFER="${LBUFFER}${selection}"
  zle reset-prompt
  return $ret
}

zle -N fzf-file-widget

# Keep ~ in alt-c selections
fzf-cd-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  local quoted_dir="${(q)dir}"
  quoted_dir="${quoted_dir/#\\~/~}"
  BUFFER="builtin cd -- ${quoted_dir}"
  zle accept-line
  local ret=$?
  unset dir
  zle reset-prompt
  return $ret
}

zle -N fzf-cd-widget


export FZF_DEFAULT_COMMAND='fd -t f'
t_dirs=(
    "."
    "$HOME"
    "/usr/local/share"
    "/usr/share/applications"
)
c_dirs=(
    "."
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

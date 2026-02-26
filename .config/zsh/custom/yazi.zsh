# y() {
#   local start_action
# 
# 	if [[ "$1" == --action=* ]]; then
# 		start_action="${1#--action=}"
# 		shift
# 	fi
# 
# 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
# 
#   if [[ -n "$start_action" ]]; then 
#     YAZI_START_ACTION="zoxide" yazi "$@" --cwd-file="$tmp"
#   else
#     yazi "$@" --cwd-file="$tmp"
#   fi
# 	
# 	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
# 		cd -- "$cwd"
# 	fi
# 	rm -f -- "$tmp"
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
	
	IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

_y_widget() {
  y
  _reset_prompt
}

_y_zi_widget() {
    y --action=zoxide
    _reset_prompt
}

zle -N _y_widget
zle -N _y_zi_widget

bindkey "^[y" _y_widget
bindkey "^[o" _y_zi_widget 

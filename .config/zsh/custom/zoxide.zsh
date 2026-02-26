_zi_widget() {
  __zoxide_zi
  _reset_prompt
}

zle -N _zi_widget
bindkey "^[z" _zi_widget

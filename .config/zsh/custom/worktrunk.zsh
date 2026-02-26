_c_wt_select() {
  zle push-line
  BUFFER="wt switch"
  zle accept-line
}

_c_wt_list_full() {
  zle push-line
  BUFFER="wt list --full"
  zle accept-line
}

# Predefined list of repos with optional aliases, cd paths, and worktree flag
# Format: "path" or "alias:path" or "alias:path:cdpath" or "alias:path:cdpath:wt"
# - path: repo path (for wt select if worktree, or just cd target)
# - cdpath: optional path to cd into (relative to repo path or absolute)
# - wt: optional flag, set to "wt" if this is a worktree (will run wt select), omit otherwise
WT_REPOS=(
  # With worktree: "my-alias:$HOME/path/to/repo:src/frontend:wt"
  # Without worktree: "my-alias:$HOME/path/to/non-wt-repo:src"
  # With alias only: "my-alias:$HOME/path/to/repo"
  # Without alias: "$HOME/path/to/repo"
)

# Helper function to parse repo entries and extract base path
_wt_get_repo_path() {
  local entry="$1"
  local parts=("${(@s/:/)entry}")
  
  if [[ ${#parts[@]} -eq 1 ]]; then
    # No colon, return as-is
    echo "$entry"
  elif [[ ${#parts[@]} -eq 2 ]]; then
    # alias:path format
    echo "${parts[2]}"
  else
    # alias:path:cdpath or alias:path:cdpath:wt format
    echo "${parts[2]}"
  fi
}

# Helper function to extract cd path
_wt_get_cd_path() {
  local entry="$1"
  local parts=("${(@s/:/)entry}")
  
  if [[ ${#parts[@]} -ge 3 ]]; then
    # Has cd path at position 3
    # If there's a 4th element and it's "wt", then cdpath is just parts[3]
    # Otherwise, join parts[3] onwards (in case path contains :)
    if [[ ${#parts[@]} -ge 4 && "${parts[-1]}" == "wt" ]]; then
      echo "${parts[3]}"
    elif [[ ${#parts[@]} -ge 3 ]]; then
      echo "${(j/:/)parts[3,-1]}"
    fi
  fi
}

# Helper function to check if entry is a worktree
_wt_is_worktree() {
  local entry="$1"
  local parts=("${(@s/:/)entry}")
  
  # Check if last element is "wt"
  if [[ ${#parts[@]} -ge 2 && "${parts[-1]}" == "wt" ]]; then
    return 0  # true
  fi
  return 1  # false
}

# Helper function to format repo for display
_wt_format_repo() {
  local entry="$1"
  local parts=("${(@s/:/)entry}")
  local is_wt=""
  local orange="\033[38;5;208m"  # Orange color
  local reset="\033[0m"           # Reset color
  
  # Check if it's a worktree
  if _wt_is_worktree "$entry"; then
    is_wt=" [wt]"
  fi
  
  if [[ ${#parts[@]} -eq 1 ]]; then
    # No alias, return path only
    echo "$entry$is_wt"
  elif [[ ${#parts[@]} -eq 2 ]]; then
    # Has alias, format as "alias → path" with colored alias
    echo "${parts[1]} → ${parts[2]}$is_wt"
  else
    # Has alias and possibly cd path
    local cdpath=$(_wt_get_cd_path "$entry")
    if [[ -n "$cdpath" ]]; then
      echo "${parts[1]} → ${parts[2]} (+)$is_wt"
    else
      echo "${parts[1]} → ${parts[2]}$is_wt"
    fi
  fi
}

# Function to select repo and run wt select (or just cd if not a worktree)
_c_wt_repo_select() {
  # Check if WT_REPOS is empty or not set
  if [[ ${#WT_REPOS[@]} -eq 0 ]]; then
    echo "WT_REPOS is empty. Please configure repos in ~/.config/zsh/custom/worktrunk.zsh"
    zle reset-prompt
    return 1
  fi
  
  local selection repo cdpath final_path is_wt
  # Format repos for display and select with fzf
  selection=$(for entry in "${WT_REPOS[@]}"; do _wt_format_repo "$entry"; done | \
    fzf --height=40% --reverse --prompt="Select repo > " --ansi)
  
  if [[ -n "$selection" ]]; then
    # Find the original entry by matching the selection
    for entry in "${WT_REPOS[@]}"; do
      if [[ "$(_wt_format_repo "$entry")" == "$selection" ]]; then
        repo=$(_wt_get_repo_path "$entry")
        cdpath=$(_wt_get_cd_path "$entry")
        _wt_is_worktree "$entry" && is_wt=1 || is_wt=0
        break
      fi
    done
    
    if [[ -n "$repo" ]]; then
      local cmd=""
      
      # Build the command based on worktree flag
      if [[ $is_wt -eq 1 ]]; then
        # It's a worktree, run wt select
        if [[ -n "$cdpath" ]]; then
          if [[ "$cdpath" == /* ]]; then
            # Absolute path
            final_path="$cdpath"
            if [[ -d "$final_path" ]]; then
              cmd="wt switch -C $repo && cd $final_path"
            else
              echo "Warning: cd path does not exist: $final_path"
              cmd="wt switch -C $repo"
            fi
          else
            # Relative path
            cmd="wt switch -C $repo && cd $cdpath"
          fi
        else
          cmd="wt switch -C $repo"
        fi
      else
        # Not a worktree, just cd
        if [[ -n "$cdpath" ]]; then
          if [[ "$cdpath" == /* ]]; then
            # Absolute path
            cmd="cd $cdpath"
          else
            # Relative path
            cmd="cd $repo/$cdpath"
          fi
        else
          cmd="cd $repo"
        fi
      fi
      
      if [[ -n "$cmd" ]]; then
        zle push-line
        BUFFER="$cmd"
        zle accept-line
      fi
    fi
  fi
  zle reset-prompt
}

# Function to select repo and cd to it
_c_wt_repo_cd() {
  # Check if WT_REPOS is empty or not set
  if [[ ${#WT_REPOS[@]} -eq 0 ]]; then
    echo "WT_REPOS is empty. Please configure repos in ~/.config/zsh/custom/worktrunk.zsh"
    zle reset-prompt
    return 1
  fi
  
  local selection repo
  # Format repos for display and select with fzf
  selection=$(for entry in "${WT_REPOS[@]}"; do _wt_format_repo "$entry"; done | \
    fzf --height=40% --reverse --prompt="Select repo to cd > " --ansi)
  
  if [[ -n "$selection" ]]; then
    # Find the original entry by matching the selection
    for entry in "${WT_REPOS[@]}"; do
      if [[ "$(_wt_format_repo "$entry")" == "$selection" ]]; then
        repo=$(_wt_get_repo_path "$entry")
        break
      fi
    done
    
    if [[ -n "$repo" ]]; then
      zle push-line
      BUFFER="cd $repo"
      zle accept-line
    fi
  fi
  zle reset-prompt
}

zle -N c_wt_select _c_wt_select
zle -N c_wt_list_full _c_wt_list_full
zle -N c_wt_repo_select _c_wt_repo_select
zle -N c_wt_repo_cd _c_wt_repo_cd

bindkey "^[s" c_wt_select
bindkey "^[l" c_wt_list_full
bindkey "^[r" c_wt_repo_select  # Alt+r for wt select
bindkey "^[d" c_wt_repo_cd       # Alt+d for cd only

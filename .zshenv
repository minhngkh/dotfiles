skip_global_compinit=1

export EDITOR="micro"
export TERMINAL="ghostty"

export TEST="hello there fine shyt wef 2"

export ZDOTDIR="$HOME/.config/zsh"

# ssh -> gcr
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# dotnet
# export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_SYSTEM_CONSOLE_ALLOW_ANSI_COLOR_REDIRECTION=true
# export PATH="$PATH:$DOTNET_ROOT"

# docker
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# goexport PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

# work
export PATH="$PATH:$HOME/work/payroll"

# zed
export ZED_DEVICE_ID=0xa7a1

# rust
. "$HOME/.cargo/env"

export C_NIX_LOCAL_PROFILE="$HOME/.nix-profile"
export C_NIX_COMPLETIONS="$C_NIX_LOCAL_PROFILE/share/zsh/site-functions"

source $HOME/.env.sh

fpath=($C_NIX_COMPLETIONS ~/.config/zsh/completions $fpath)

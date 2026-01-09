export EDITOR="micro"
export TERMINAL="ghostty"

export TEST="hello there fine shyt wef"

export ZDOTDIR="$HOME/.config/zsh"

# ssh -> gcr
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# bun
# export PATH="$PATH:$HOME/.cache/.bun/bin"

# dotnet
# export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_SYSTEM_CONSOLE_ALLOW_ANSI_COLOR_REDIRECTION=true
export PATH="$PATH:$HOME/.dotnet/tools"

# docker
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# go
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

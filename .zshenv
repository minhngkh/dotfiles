skip_global_compinit=1
. /opt/osd/proxy2/osd-proxy2-start-stop.sh

export EDITOR="micro"
export TERMINAL="ghostty"

export TEST="hello there fine shyt wef 4"

export ZDOTDIR="$HOME/.config/zsh"

# ssh -> gcr
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# dotnet
# export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_SYSTEM_CONSOLE_ALLOW_ANSI_COLOR_REDIRECTION=true
export PATH="$PATH:$HOME/.dotnet/tools"

# docker
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# goexport PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/go/bin"

# work
export PATH="$PATH:$HOME/work/payroll"

# zed
export ZED_DEVICE_ID=0xa7a1
# export PATH="$PATH:$HOME/.local/zed.app/bin"

# go
export PATH="$PATH:$HOME/go"

# rust
. "$HOME/.cargo/env"

# misc
export NODE_USE_ENV_PROXY=1
export T3CODE_TELEMETRY_ENABLED=false

export C_NIX_LOCAL_PROFILE="$HOME/.nix-profile"
export C_NIX_COMPLETIONS="$C_NIX_LOCAL_PROFILE/share/zsh/site-functions"

export PATH="$PATH:/opt/osd/proxy2"

# local bin
# export PATH="$HOME/.local/bin:$PATH"

# export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# export SSL_CERT_DIR=/etc/ssl/certs:/home/gmi4hc/.aspnet/dev-certs/trust

source $HOME/.env.sh

fpath=($C_NIX_COMPLETIONS ~/.config/zsh/completions $fpath)

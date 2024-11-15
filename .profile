# fcitx5
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export QT_IM_MODULES="wayland;fcitx;ibus"
export GTK_IM_MODULE=

# # qt
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="qt6ct"

# java
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-21.0.4.0.7-2.fc40.x86_64/"

# local bin
export PATH="$HOME/.local/bin:$PATH"

# rust
source $HOME/.cargo/env

# golang
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

# fly.io cli
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$PATH:$FLYCTL_INSTALL/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"

# Android (according to Expo)
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Hypr venv
export HYPR_VENV="$HOME/hypr-venv"
export PATH="$PATH:$HYPR_VENV/bin"

# Pulumi
export PATH="$PATH:$HOME/.pulumi/bin"

# Turso
export PATH="$PATH:$HOME/.turso"

# Spicetify
export PATH="$PATH:$HOME/.spicetify"

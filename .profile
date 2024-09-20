# fcitx5
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export QT_IM_MODULES="wayland;fcitx;ibus"
export GTK_IM_MODULE=

# qt
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="qt5ct"

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

# Added by Toolbox App
export PATH="$PATH:/home/minhngkh/.local/share/JetBrains/Toolbox/scripts"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Android (according to Expo)
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

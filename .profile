# # qt
# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_QPA_PLATFORM="wayland"
# # export QT_AUTO_SCREEN_SCALE_FACTOR=1
# # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# 

# gtk
# export GDK_BACKEND="wayland,x11,*"
# 
# # fcitx5
# export XMODIFIERS="@im=fcitx"
# export QT_IM_MODULE="fcitx"
# export QT_IM_MODULES="wayland;fcitx;ibus"
# 
# # vulkan
# export ANV_DEBUG=video-decode,video-encode
# 
# # electron
# export ELECTRON_OZONE_PLATFORM_HINT="auto"
# 
# local bin
# export PATH="$HOME/.local/bin:$PATH"

# docker
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# BEGIN ANSIBLE MANAGED BLOCK
# Handle new user setup and OCS launch
NTUID=$(whoami | cut -d@ -f1)
if [ -e "/home/$NTUID/.new_user" ]; then
  bash "/opt/osd/newuser-setup.sh" 2>/dev/null
fi
# END ANSIBLE MANAGED BLOCK


export PROFILE_USED="yes"

# export http_proxy=
# export https_proxy=
# export HTTP_PROXY=
# export HTTPS_PROXY=

export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_DIR=/etc/ssl/certs:/home/gmi4hc/.aspnet/dev-certs/trust

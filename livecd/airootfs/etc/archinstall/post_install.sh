#!/usr/bin/env bash
set -euxo pipefail

USER="playnix"
HOME="/home/$USER"
SDDM_CONF="/etc/sddm.conf.d/autologin.conf"
ICON_PATH="/etc/archinstall/icon.png"
BG_PATH="/etc/archinstall/desktop.png"
APPLET_FILE="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

# Breeze login theme
mkdir -p /etc/sddm.conf.d
touch "$SDDM_CONF"
cat > "$SDDM_CONF" <<EOF
[Autologin]
Relogin=true
User=$USER
[Theme]
Current=breeze
EOF

# Dark Breeze theme
mkdir -p "$HOME/.config"
echo "[KDE]" >> "$HOME/.config/kdeglobals"
echo "LookAndFeelPackage=org.kde.breezedark.desktop" >> "$HOME/.config/kdeglobals"

echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers.d/99-pacman-nopasswd

# yay (requiere tener go, git y base-devel instalados)
su - "$USER" -c '
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm || true
  cd /
  rm -rf /tmp/yay
  yay -S --noconfirm plymouth-theme-sweet-arch-git || true
'

plymouth-set-default-theme -R sweet-arch || true

# Desktop shortcuts
mkdir -p "$HOME/Desktop"
cp /etc/archinstall/*.desktop "$HOME/Desktop/" || true
chmod +x "$HOME/Desktop/"*.desktop || true

# Permisos finales
chown -R "$USER:$USER" "$HOME"

exit 0
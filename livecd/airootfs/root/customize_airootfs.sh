#!/usr/bin/env bash
set -e -u

echo "Starting customization..."

# Locale
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen || true
sed -i "s/#es_ES.UTF-8/es_ES.UTF-8/" /etc/locale.gen || true
locale-gen || true
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf

# Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# User setup
useradd -m -G wheel,audio,video,storage,network -s /bin/bash liveuser || true
passwd -d liveuser || true
passwd -d root || true
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Enable systemd services, only if service file exists
for service in NetworkManager sddm livecd-loading; do
  if [ -f "/usr/lib/systemd/system/${service}.service" ]; then
    ln -sf "/usr/lib/systemd/system/${service}.service" "/etc/systemd/system/multi-user.target.wants/${service}.service"
  else
    echo "Service ${service} not found, skipping enable."
  fi
done
#
# # SDDM autologin configuration
# mkdir -p /etc/sddm.conf.d
# cat > /etc/sddm.conf.d/autologin.conf << EOF
# [Autologin]
# User=liveuser
# Session=plasma
# [Theme]
# Current=breeze
# EOF

# Hostname
echo "archiso-kde" > /etc/hostname

# Bashrc with welcome message for liveuser
mkdir -p /home/liveuser
cat >> /home/liveuser/.bashrc << EOF
alias ll="ls -la"
clear
echo -e "\033[1;34m=== PlaynixOS KDE Live CD ===\033[0m"
echo -e "\033[1;32mWelcome to the PlaynixOS KDE Live system\033[0m"
echo -e "\033[0;36mCurrent user: liveuser (no password)\033[0m"
echo -e "\033[0;36mTo install: Run the installer from the desktop\033[0m"
echo ""
EOF

chown -R liveuser:liveuser /home/liveuser || true

# Configure Plymouth splash screen if present
if command -v plymouth-set-default-theme &> /dev/null; then
  plymouth-set-default-theme sweet-arch
fi

# Clean pacman cache
pacman -Scc --noconfirm || true

#Init pacman
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
chown -R root:root /etc/pacman.d/gnupg
chmod -R 700 /etc/pacman.d/gnupg

sed -i '/Worldwide/ {n;s/^#Server/Server/}' /etc/pacman.d/mirrorlist
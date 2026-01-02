#!/usr/bin/env bash
iso_name="playnixOS-kde"
iso_label="ARCH_KDE_$(date +%Y%m)"
iso_publisher="PlaynixOS KDE Live"
iso_application="PlaynixOS KDE Live CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=("iso")
bootmodes=("bios.syslinux.mbr" "bios.syslinux.eltorito" "uefi-x64.systemd-boot.esp" "uefi-x64.systemd-boot.eltorito")
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=("-comp" "xz" "-b" "1M")
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/arch-installer"]="0:0:755"
  ["/usr/local/bin/livecd-loading"]="0:0:755"
)

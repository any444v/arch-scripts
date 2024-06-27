#!/bin/bash

read -p "Provide kernel package name(linux/linux-lts/linux-zen): " kernel

read -p "Provide microcode updates package name(amd-ucode/intel-ucode): " ucode

pacstrap -K /mnt base base-devel $kernel linux-firmware $ucode

genfstab -U /mnt >> /mnt/etc/fstab

echo "Now you need to open post-install.sh script"

arch-chroot /mnt

exit 0

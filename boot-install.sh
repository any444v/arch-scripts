#!/bin/bash

# Проверяем, что скрипт выполняется с правами суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен выполняться с правами суперпользователя" 
    exit 1
fi

# Находим root раздел
ROOT_PART=$(findmnt / -o SOURCE -n)

# Проверяем, что root раздел найден
if [[ -z "$ROOT_PART" ]]; then
    echo "Не удалось найти root раздел"
    exit 1
fi

# Извлекаем PARTUUID
PARTUUID=$(blkid -s PARTUUID -o value "$ROOT_PART")

# Проверяем, что PARTUUID найден
if [[ -z "$PARTUUID" ]]; then
    echo "Не удалось найти PARTUUID для раздела $ROOT_PART"
    exit 1
fi

# Устанавливаем systemd-boot
bootctl install

# Создаем загрузочную запись
BOOT_ENTRY="/boot/loader/entries/arch.conf"
mkdir -p /boot/loader/entries
cat <<EOF > "$BOOT_ENTRY"
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$PARTUUID rw
EOF

# Обновляем конфигурацию загрузчика
cat <<EOF > /boot/loader/loader.conf
default  arch
timeout  4
console-mode max
editor   no
EOF

echo "Установка systemd-boot завершена. Конфигурация добавлена в $BOOT_ENTRY"

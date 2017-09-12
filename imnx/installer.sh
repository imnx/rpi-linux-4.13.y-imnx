#!/usr/bin/sudo /bin/bash
cp /usr/src/rpi-linux-4.13.x-imnx/arch/arm64/boot/dts/broadcom/*.dtb /mnt/usb0/boot
cp /usr/src/rpi-linux-4.13.x-imnx/arch/arm64/boot/dts/broadcom/modules.order /mnt/usb0/lib/modules/4.13.0-v8-imnx-aarch64-g56ef4739
cp /usr/src/rpi-linux-4.13.x-imnx/arch/arm64/boot/Image /mnt/usb0/boot/kernel-v8-imnx-aarch64-g56ef4739.img

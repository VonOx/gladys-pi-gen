#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/share/plymouth/themes/gladys"
install -m 644 files/themes/gladys.plymouth "${ROOTFS_DIR}/usr/share/plymouth/themes/gladys/"
install -m 644 files/themes/gladys.script "${ROOTFS_DIR}/usr/share/plymouth/themes/gladys/"
install -m 644 files/themes/gladys.png "${ROOTFS_DIR}/usr/share/plymouth/themes/gladys/"

on_chroot <<EOF
plymouth-set-default-theme gladys
EOF

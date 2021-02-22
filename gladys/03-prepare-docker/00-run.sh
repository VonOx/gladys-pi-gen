#!/bin/bash -e

if [ -f "/files/watchtower.tar" ]; then
    rm ./files/watchtower.tar
fi
if [ -f "/files/gladys.tar" ]; then
    rm ./files/gladys.tar
fi
docker pull containrrr/watchtower:armhf-latest
docker pull gladysassistant/gladys:v4-arm
docker save --output ./files/watchtower.tar containrrr/watchtower:armhf-latest
docker save --output ./files/gladys.tar gladysassistant/gladys:v4-arm

install -m 755 files/watchtower.tar "${ROOTFS_DIR}/tmp/"
install -m 755 files/gladys.tar "${ROOTFS_DIR}/tmp/"
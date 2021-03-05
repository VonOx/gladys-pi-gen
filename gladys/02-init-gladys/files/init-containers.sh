#!/bin/sh

TIMEZONE=$(cat /etc/timezone)

docker_images_watchtower=$(docker images -q containrrr/watchtower)
docker_images_gladys=$(docker images -q gladysassistant/gladys)
docker_images_gladyssetup=$(docker images -q gladysassistant/gladys-setup-in-progress)

# First boot, we need to be sure Landing image / container exist
if [ -n "$docker_images_gladyssetup" ]; then
  logger -t "gladys-init" "Gladys Setup Progress image exist, Cool...."
else
  logger -t "gladys-init" "Gladys Setup Progress image is missing, creating them...."
  docker run -d \
    --name gladys-setup-in-progress \
    --network=host \
    vonox/gladys-setup-in-progress
fi

if [ -n "$docker_images_watchtower" ]; then
  logger -t "gladys-init" "Watchtower container exist, Cool...."
else
  logger -t "gladys-init" "Watchtower container missing, creating them...."
  docker run -d \
    --name watchtower \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower \
    --cleanup --include-restarting
fi

if [ -n "$docker_images_gladys" ]; then
  logger -t "gladys-init" "Gladys container exist, Cool...."
else
  logger -t "gladys-init" "Gladys image is missing, pulling them...."
  docker pull gladysassistant/gladys:v4
  logger -t "gladys-init" "Gladys image is pulled, deleting landing container"
  docker stop gladys-setup-in-progress && docker rm gladys-setup-in-progress
  logger -t "gladys-init" "Gladys container is missing, creating them...."
  docker run -d \
    --restart=always \
    --privileged \
    --network=host \
    --log-opt max-size=10m \
    --name gladys \
    -e NODE_ENV=production \
    -e SERVER_PORT=80 \
    -e TZ=${TIMEZONE} \
    -e SQLITE_FILE_PATH=/var/lib/gladysassistant/gladys-production.db \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/gladysassistant:/var/lib/gladysassistant \
    -v /dev:/dev \
    -v /run/udev:/run/udev:ro \
    gladysassistant/gladys:v4
fi

docker image prune
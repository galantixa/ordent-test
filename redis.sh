#!/bin/bash

# run as root
if [ "$EUID" -ne 0 ]; then
    echo "must be root"
    exit 1
fi

# prompt untuk memasukkan port
read -p "Input PORT: " PORT
PORT=${PORT:-6379}


# download and install
sudo apt update
sudo apt install build-essential
sudo apt install -y redis-server

# create user redis
sudo adduser --system --group --no-create-home redis || true
#  mengganti nilai port
sed -i "s/port 6379/port $PORT/" /etc/redis/redis.conf

chown -R redis:redis /var/lib/redis
# start redis
systemctl restart redis-server

echo "redis succesfully installed"
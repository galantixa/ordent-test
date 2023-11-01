#!/bin/bash

# run as root
if [ "$EUID" -ne 0 ]; then
    echo "must be root"
    exit 1
fi

# prompt untuk memasukkan port
read -p "Input PORT: " PORT
PORT=${PORT:-6379}

sudo apt update
sudo apt install build-essential

# download and install
cd /tmp
wget http://download.redis.io/releases/redis-7.0.0.tar.gz
tar xzf redis-7.0.0.tar.gz
cd redis-7.0.0
make
make install

# create user redis
sudo adduser --system --group --no-create-home redis

# create dir for redis data
mkdir -p /var/lib/redis/$PORT
cp redis.conf /var/lib/redis/$PORT.conf

#  mengganti nilai port
sed -i "s/port 6379/port $PORT/" /var/lib/redis/$PORT.conf
# untuk mengubah direktori tempat redis menyimpan data
sed -i "s|dir ./|dir /var/lib/redis/$PORT/|" /var/lib/redis/$PORT.conf

chown -R redis:redis /var/lib/redis
# start redis
systemctl restart redis@$PORT

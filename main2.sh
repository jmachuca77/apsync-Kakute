#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER

#Remove unused packages
apt autoremove -y

## Ensure the ~/.local/bin is on the system path
echo "PATH=\$PATH:~/.local/bin" >> ~/.profile
source ~/.profile

## Add required packages for general
apt install git screen python3 python3-dev python3-pip python3-matplotlib -y
apt install -y libxml2-dev libxslt1.1 libxslt1-dev libz-dev
#sudo pip3 install --upgrade pip
pip3 install pyserial future pymavlink mavproxy --user

## Install a package that will automatically mount & unmount USB drives
sudo apt install usbmount -y

## Install the various softwares
~/apsync-Kakute/mavlink-router.sh
~/apsync-Kakute/apweb.sh
~/apsync-Kakute/apstreamline.sh
~/apsync-Kakute/use_networkmanager.sh

sudo reboot

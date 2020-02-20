#!/bin/bash
if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

## Update everything
apt update
apt upgrade -y

## Raspi-Config - camera, serial port, ssh
raspi-config nonint do_expand_rootfs
raspi-config nonint do_camera 0
raspi-config nonint do_ssh 0
raspi-config nonint do_serial 0

apt install nano rsync
#    create an apsync user:
useradd -s /bin/bash -m -U -G sudo,netdev,users,dialout,video apsync

# move all of the pi user to apsync:
if [ -d "/home/pi" ]; then
    NORMAL_USER=pi
fi

rsync -aPH --delete /home/$NORMAL_USER/ /home/apsync
chown -R apsync.apsync /home/apsync

echo "apsync:apsync" | chpasswd

# stop systemd starting a getty on ttyS0:
systemctl disable serial-getty@ttyS0.service
perl -pe 's/console=ttyAMA0,115200//' -i /boot/config-5.3.0-1017-raspi2
perl -pe 's/console=ttyAMA0,115200//' -i /boot/config-5.3.0-1018-raspi2

## Change hostname
raspi-config nonint do_hostname apsync
perl -pe 's/raspberrypi/apsync/' -i /etc/hosts

echo >&2 "Finished part 1 of APSync install, please logout and then log back in using apsync user"
reboot

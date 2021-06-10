#!/usr/bin/env bash
apt install git -y
tag="$(curl -s https://raw.githubusercontent.com/NSK-1010/pi-app-manager/master/run/version)"
git clone https://github.com/nsk-1010/pi-app-manager.git -b ${tag}
chmod 755 -R pi-app-manager
cd pi-app-manager
./depends.sh
./pi-app-manager
cd ..
rm -r pi-app-manager

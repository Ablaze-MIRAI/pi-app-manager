#!/usr/bin/env bash
source ./version.bash
apt install git -y
git clone https://github.com/nsk-1010/pi-app-manager.git -b ${tag}
chmod 755 -R pi-app-manager
cd pi-app-manager
./depends.sh
./pi-app-manager
cd ..
rm -r pi-app-manager

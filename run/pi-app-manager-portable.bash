#!/usr/bin/env bash
apt install git
git clone https://github.com/nsk-1010/pi-app-manager.git -b 1.10-2
chmod 755 -R pi-app-manager
cd pi-app-manager
./depends.bash
./pi-app-manager
cd ..
rm -r pi-app-manager
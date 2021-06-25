#!/usr/bin/env bash
piappmanager_version="$(curl -s https://raw.githubusercontent.com/NSK-1010/pi-app-manager/master/run/version)"
curl -sL -o - https://github.com/nsk-1010/pi-app-manager.git/archive/${piappmanager_version}.tar.gz | tar zxfv -C pi-app-manager
chmod 755 -R pi-app-manager
cd pi-app-manager
./depends.sh
./pi-app-manager
cd ..
rm -r pi-app-manager

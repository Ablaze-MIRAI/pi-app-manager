#!/usr/bin/env bash
piappmanager_version="$(curl -s https://raw.githubusercontent.com/NSK-1010/pi-app-manager/main/run/version)"
curl -sL -o - https://github.com/nsk-1010/pi-app-manager.git/archive/${piappmanager_version}.tar.gz | tar zxfv -C pi-app-manager
chmod 755 -R pi-app-manager
cd pi-app-manager
scriptdir=$(pwd)
./depends.sh
./pi-app-manager
echo "今後は 'bash ${scriptdir}/pi-app-manager' というコマンドを実行するとPi-App-Managerが起動します。"
cd ..

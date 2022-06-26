#!/usr/bin/env bash

echo "依存パッケージをインストールします。"
apt install bash jq zenity git curl -y --no-install-recommends

mkdir pacapt-installer
curl -o ./pacapt-installer/installer.bash https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/pacapt-installer.bash
chmod +x ./pacapt-installer/installer.bash
bash ./pacapt-installer/installer.bash 2
rm -r pacapt-installer

echo "インストールが完了しました。"

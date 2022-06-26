#!/usr/bin/env bash

echo "依存パッケージをインストールします。"
apt install bash jq zenity git -y --no-install-recommends

curl -o ./pacapt-installer/installer.bash https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/pacapt-installer.bash
chmod +x ./pacapt-installer/installer.bash
bash ./pacapt-installer/installer.bash

echo "インストールが完了しました。"

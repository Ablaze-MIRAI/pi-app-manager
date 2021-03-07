#!/usr/bin/env bash

echo "依存パッケージをインストールします。"
apt install bash jq zenity -y --no-install-recommends

bash ./pacapt-installer/installer.bash 2

echo "インストールが完了しました。"
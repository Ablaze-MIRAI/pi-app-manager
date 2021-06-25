#!/usr/bin/env bash

echo "依存パッケージをインストールします。"
apt install bash jq zenity git -y --no-install-recommends

bash ./pacapt-installer/installer.bash

echo "インストールが完了しました。"

# 概要
[EG-Installer](https://github.com/Hayao0819/EG-Installer)をSereneLinux（Ubuntu用）に最適化したものを、armhf版Debian用に最適化したものです。  
インストールせずに使えます。

# 使い方
まずは依存関係を解決しましょう。

ターミナル上でこのコマンドを実行してください。Ruotでなければsudoで実行してください。

```sh
./depends.bash
```

完了したらターミナル上でこちらのコマンドを実行してください。
```sh
git clone https://github.com/nsk-1010/pi-app-manager.git -b 1.10-2
chmod 755 -R pi-app-manager
cd pi-app-manager
./pi-app-manager
```

これで実行ができます。

# バージョンについて
[Pi-App-Manager]-[ビルド番号]というようにしていきます。Pi-App-Managerのバージョンが変わるとビルド番号もリセットします。

# softwaresについて
Pi-App-Managerにある`softwares`は[こちら](https://github.com/NSK-1010/pi-app-manager-scripts-buster)で開発を行っています。

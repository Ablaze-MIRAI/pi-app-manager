#!/bin/bash

mkdir pi-app-manager
mv -r usr pi-app-manager
mv -r etc pi-app-manager
mv -r DEBIAN pi-app-manager
dpkg -b ./pi-app-manager

#!/bin/bash

mkdir pi-app-manager
mv -r usr etc DEBIAN pi-app-manager
dpkg -b ./pi-app-manager

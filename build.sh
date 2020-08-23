#!/bin/bash

mkdir pi-app-manager
mv usr etc DEBIAN pi-app-manager
dpkg -b ./pi-app-manager

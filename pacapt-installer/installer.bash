!/usr/bin/env bash
set -e

## Initial function
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    return 0
}

function blue_log () {
    echo -e "\033[0;34m$@\033[0;39m"
    return 0
}

function yellow_log () {
    echo -e "\033[0;33m$@\033[0;39m" >&2
    return 0
}

## Settings
working_directly="./pacapt"
control_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/control"
postinst_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/postinst"
postrm_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/postrm"
pacapt_url="https://github.com/Hayao0819/pacapt/raw/ng/pacapt"
pacapt_path="usr/local/bin/pacapt"
deb_name=./pacapt.deb

## Check root.
if [[ ! $UID = 0 ]]; then
    red_log "You need root permission."
    exit 1
fi
## Initialize
initial_directory=$(pwd)

## Build/Install
function build_deb () {
    blue_log "Start creating a Debian package file."
    if [[ ! -d $working_directly ]]; then 
        echo "Creating working directory."
        mkdir $working_directly
    fi
    cd $working_directly
    blue_log "Creating working directory."
    mkdir -p ./$( echo $pacapt_path | sed -e 's/pacapt//g')
    blue_log "Downloading pacapt."
    sudo wget -O ./$pacapt_path $pacapt_url
    blue_log "Creating DEBIAN directory."
    mkdir DEBIAN
    cd ./DEBIAN
    blue_log "Downloading control."
    wget $control_url
    blue_log "Downloading postinst"
    wget $postinst_url
    blue_log "Downloading postrm"
    wget $postrm_url
    echo -e "$(md5sum ../$pacapt_path | awk '{print $1}')    $pacapt_path" > ./md5sums
    cd ../../
    chmod -R 755 $working_directly
    dpkg -b $working_directly
    return 0
}

function pacapt_to_yay () {
    echo "alias yay='sudo pacapt'" >> /etc/bash.bashrc
    echo "alias yay='sudo pacapt'" >> /etc/skel/.bashrc
    source /etc/bash.bashrc
    return 0
}

build_deb
blue_log "Installing pacapt"
apt install $working_directly.deb
rm -r $working_directly
rm $working_directly.deb
pacapt_to_yay

cd $initial_directory

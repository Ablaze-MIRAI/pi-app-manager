#!/usr/bin/env bash
set -e


## Settings
working_directly="./pacapt"
control_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/control"
postinst_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/postinst"
postrm_url="https://raw.githubusercontent.com/Hayao0819/pacapt-installer/master/postrm"
pacapt_url="https://github.com/Hayao0819/pacapt/raw/ng/pacapt"
pacapt_path="usr/local/bin/pacapt"
deb_name=./pacapt.deb


## pacapt installer for Ubuntu

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

function search_pkg () {
    set +e
    package_exist=$(dpkg --get-selections  | grep -w $1 | awk '{print $1}')
    if [[ -n "$package_exist" ]]; then
        printf 0
        return 0
    else
        printf 1
        return 1
    fi
    set -e
}

function how_to_use () {
cat <<EOS

1: Install pacapt directly in the directory.(Do not use Package Manager.)
2: Install automatically after creating a Debian package.(Debian only)
3: Create a Debian package and do not install it.(Debian only)
4: Remove manually placed pacapt.(It is installed in mode1)
5: Update installed pacapt.(The mode is determined automatically.)
6: Exit.

EOS
}

## Check root.
if [[ ! $UID = 0 ]]; then
    red_log "You need root permission."
    exit 1
fi

## Initialize
mode=0
update_mode=
initial_directory=$(pwd)
if [[ ! $# = 0 ]]; then
    argument="$@"
else
    argument=
fi

## Select mode.
if [[ -z $argument ]]; then

# Old message
<< COMMENT
    echo 
    echo "------pacapt installer------"
    echo
    echo "How do you install pacapt?"
    echo "1: Place pacapt directly. (Do not use Package Manager.)"
    echo "2: After creating the deb file, install it automatically."
    echo "3: After creating the deb file, install it yourself."
    echo "4: Remove manually placed pacapt."
    echo "5: Update installed pacapt."
    echo
    printf "Please enter mode number. : "
    read mode
COMMENT

cat <<EOS

---------Pacapt installer---------

What are you doing to do?

EOS
how_to_use
printf "Please enter mode number. : "
read mode 
else
    mode=$argument
fi

## functions 
function make_link () {
    sudo ln -s /$pacapt_path /usr/local/bin/pacapt-tlmgr
    sudo ln -s /$pacapt_path /usr/local/bin/pacapt-conda
    sudo ln -s /$pacapt_path /usr/local/bin/p-tlmgr
    sudo ln -s /$pacapt_path /usr/local/bin/p-conda
    sudo ln -sv /$pacapt_path /usr/local/bin/pacman || true
    return 0
}

function pacapt_to_yay () {
    echo "alias yay='sudo pacapt'" >> /etc/bash.bashrc
    echo "alias yay='sudo pacapt'" >> /etc/skel/.bashrc
    source /etc/bash.bashrc
    return 0
}

function mode1 () {
    red_log "Downloading pacapt."
    sudo wget  -O /$pacapt_path $pacapt_url
    sudo chmod 755 /$pacapt_path
    if [[ ! $1 == "update" ]]; then
        make_link
    fi
    # pacapt_to_yay
    return 0
}

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

function mode2 {
    build_deb
    if [[ $(search_pkg gdebi) = 1 ]]; then
        blue_log "Installing gdebi..."
        apt-get --yes update > /dev/null
        apt-get --yes install gdebi-core > /dev/null
    fi
    gdebi $working_directly.deb
    if [[ $(search_pkg gdebi) = 1 ]]; then
        blue_log "Uninstalling gdebi..."
        apt-get --yes purge gdebi-core > /dev/null
        apt-get --yes --purge autoremove > /dev/null
        apt-get --yes clean > /dev/null
    fi
    rm -r $working_directly
    rm $working_directly.deb
    pacapt_to_yay
    # pacapt -V
    return 0
}

function mode3 () {
    build_deb
    rm -r $working_directly
    exit 0
}

function mode4 () {
    search_pkg pacapt
    if [[ $? = 0 ]]; then
        echo -e "pacapt is managed by dpkg.\nRemove pacapt from dpkg and apt."
        exit 1
    fi
    if [[ -f /$pacapt_path ]]; then
        red_log "pacapt was not found."
    fi
    rm /$pacapt_path
    sudo unlink /usr/local/bin/pacapt-tlmgr
    sudo unlink /usr/local/bin/pacapt-conda
    sudo unlink /usr/local/bin/p-tlmgr
    sudo unlink /usr/local/bin/p-conda
    sudo unlink /usr/local/bin/pacman
    blue_log "The file has been deleted."
    return 0
}

function mode5 () {
    function update_deb () {
        blue_log "Removing old pacapt"
        dpkg -r pacapt
        mode2
        return 0
    }
    function update_manual () {
        blue_log "Searching pacapt..."
        pacapt_path=$(sudo find  / -name "pacapt" -and -perm 755 -type f 2> /dev/null)
        if [[ -z "$pacapt_path" ]]; then
            red_log "Error! Pacapt is not installed."
            exit 1
        else
            pacapt_path=$(echo $pacapt_path | cut -c 2-${#pacapt_path})
        fi
        rm /$pacapt_path
        mode1 update

    }
    search_pkg pacapt
    if [[ $? = 0 ]]; then
        update_deb
    else
        update_manual
    fi

}

function error () {
    red_log "Enter the correct mode number."
    if [[ -z $argument ]]; then
        $0
    else
        how_to_use
    fi
}

# blue_log $pacapt_path
## run function
case $mode in
    1 ) mode1 ;;
    2 ) mode2 ;;
    3 ) mode3 ;;
    4 ) mode4 ;;
    5 ) mode5 ;;
    6 ) exit 0 ;;
    0 ) error ;;
    * ) error ;;
esac

cd $initial_directory
#!/usr/bin/env sh

echo "Welcome to the Co-op-on-Linux SteamOS installer!
Please be warned that this installer will install some packages to the system (sway and firejail),
the packages may be wiped when a SteamOS update occurs, the installer will leave a flag on the program's directory
to check for this and re-run the installer
"
while true; do
    read -p "Do you wish to to continue [Yn] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
    esac

    if [ -z $yn ]; then
        break
    fi
done

if [[ "$(passwd --status)" =~ "NP" ]]; then
    echo "You have not set a sudo password. This is required for installation"
    while true; do
        read -p "Do you want to setup a sudo password" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        esac

        if [ -z $yn ]; then
            break
        fi
    done

    passwd
fi

sudo steamos-readonly disable

sudo pacman-key --init
sudo pacman-key --populate archlinux holo
sudo pacman -S sway firejail

sudo steamos-readonly enable

echo "1" >> steamos-check

read -p "Installation finished! Press Enter to finish "

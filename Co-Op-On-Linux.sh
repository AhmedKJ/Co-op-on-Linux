#!/bin/bash

SOURCE=${BASH_SOURCE[0]}

# https://stackoverflow.com/a/246128
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR_CO_OP=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR_CO_OP=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

DIR_CO_OP_CONT=$DIR_CO_OP/controller_blacklists
DIR_CO_OP_SWAY=$DIR_CO_OP/sway_configs


### Currently only 2 players is supported

if [ -e steamos-check ]; then
    if ! type "sway" > /dev/null; then
        $DIR_CO_OP/install-steamos.sh
    fi
fi

if [ "$1" = --help ]; then
    echo "
    Co-Op-On-Linux.sh

    Enviroment variables:

    WIDTH: width of total area in pixels
    HEIGHT: height of total area in pixels
    GAMERUN: command to run to start the game
    "
fi


DIALOG="zenity"

### Manage game controllers
if [ "$DIR_CO_OP_CONT" != "/*" ]; then
rm -rf $DIR_CO_OP_CONT
else
    echo "There was a bug were accidentally your system could have been wiped. Please report it"
fi

mkdir $DIR_CO_OP_CONT


function select_controllers() {
    readarray -t CONTROLLERS < <( $DIR_CO_OP/get-devices.py list-zenity )

    zenity_out=$($DIALOG --list --title="Choose controller for player 1" --text="" --column=Controllers --column=devices \ "${CONTROLLERS[@]}" --print-column 2 )

    if [ $? -eq 1 ]; then
        echo "Canceled"
        exit
    fi

    CONTROLLER_1=$(echo $zenity_out | uniq)

    readarray -t CONTROLLERS < <( $DIR_CO_OP/get-devices.py list-zenity-exclude $CONTROLLER_1 )

    zenity_out=$($DIALOG --list --title="Choose controller for player 2" --text="" --column=Controllers --column=devices \ "${CONTROLLERS[@]}" --print-column 2 )

    if [ $? -eq 1 ]; then
        echo "Canceled"
        exit
    fi

    CONTROLLER_2=$(echo $zenity_out | uniq)
    #CONTROLLER_2=$($DIALOG --list --title="Choose controller for player 2" --text="" --column=Controllers --column=devices \ "${CONTROLLERS[@]}" --print-column 2 | uniq)

    # add each device to blacklist
    for dev in $CONTROLLER_1
    do
        printf -- '--blacklist=%s ' $dev >> $DIR_CO_OP_CONT/Player1_Controller_Blacklist
    done

    # add each device to blacklist
    for dev in $CONTROLLER_2
    do
        printf -- '--blacklist=%s ' $dev >> $DIR_CO_OP_CONT/Player2_Controller_Blacklist
    done

    readarray -t CONTROLLERS_REST < <($DIR_CO_OP/get-devices.py list-handlers-exclude $CONTROLLER_1 $CONTROLLER_2)
    echo $CONTROLLERS_REST

    touch $DIR_CO_OP_CONT/Global_Controller_Blacklist
    for dev in $CONTROLLERS_REST
    do
        printf -- '--blacklist=%s ' $dev >> $DIR_CO_OP_CONT/Global_Controller_Blacklist
    done
};

if [ -z $WIDTH ] || [ -z $HEIGHT ] || [ -z $GAMERUN ]; then
    zenity --error --text "Enviroment variables not set (Did you run this without a preset?)"
    exit
fi

select_controllers


exec_command1="WAYLAND_DISPLAY=wayland-2 firejail --noprofile $(cat $DIR_CO_OP_CONT/Player2_Controller_Blacklist ) $(cat $DIR_CO_OP_CONT/Global_Controller_Blacklist) $GAMERUN"
exec_command2="WAYLAND_DISPLAY=wayland-2 firejail --noprofile $(cat $DIR_CO_OP_CONT/Player1_Controller_Blacklist ) $(cat $DIR_CO_OP_CONT/Global_Controller_Blacklist) $GAMERUN"

mkdir $DIR_CO_OP_SWAY
rm $DIR_CO_OP_SWAY/*.conf

echo "default_border none 0" > $DIR_CO_OP_SWAY/sway0.conf
echo "output WL-1 resolution $(($WIDTH))x$HEIGHT" >> $DIR_CO_OP_SWAY/sway0.conf
# Set resolution for X11 and Xwayland compositors (eg. gamescope)
echo "output X11-1 resolution $(($WIDTH))x$HEIGHT" >> $DIR_CO_OP_SWAY/sway0.conf
echo "exec sway -c $DIR_CO_OP_SWAY/sway1.conf" >> $DIR_CO_OP_SWAY/sway0.conf
echo "exec sway -c $DIR_CO_OP_SWAY/sway2.conf" >> $DIR_CO_OP_SWAY/sway0.conf

echo "default_border none 0" > $DIR_CO_OP_SWAY/sway1.conf
echo "output WL-1 resolution $(($WIDTH/2))x$HEIGHT" >> $DIR_CO_OP_SWAY/sway1.conf
echo "exec $exec_command1" >> $DIR_CO_OP_SWAY/sway1.conf

echo "default_border none 0" > $DIR_CO_OP_SWAY/sway2.conf
echo "output WL-1 resolution $(($WIDTH/2))x$HEIGHT" >> $DIR_CO_OP_SWAY/sway2.conf
echo "exec $exec_command2" >> $DIR_CO_OP_SWAY/sway2.conf

### Launching sway sessions

cd $(dirname $GAMERUN)
echo $PWD
sway -c $DIR_CO_OP_SWAY/sway0.conf &

echo "Done~!"

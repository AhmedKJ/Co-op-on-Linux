#!/usr/bin/env sh
#
DIALOG=zenity
DIR_CO_OP=$PWD

if type "kdialog" > /dev/null; then
    GAMERUN=$(kdialog --title="Select game executable/launch script" --getopenfilename)
else
    GAMERUN=$(zenity --title="Select game executable/launch script" --file-selection)
fi

DEFAULT_RES=$(xdpyinfo | awk '/dimensions/{print $2}')
RESOLUTION=$($DIALOG --title="Resolution" --entry --text="Enter Resolution for Weston sessions ( for example: 1280x720 ) " --entry-text=$DEFAULT_RES)

WIDTH=$(printf $RESOLUTION | awk -F "x" '{print $1}')
HEIGHT=$(printf $RESOLUTION | awk -F "x" '{print $2}')

name=$($DIALOG --title="Profile name" --entry --text="Enter a name for the profile" --entry-text="name")
mkdir -p $DIR_CO_OP/profiles
echo "export WIDTH=$WIDTH" > "$DIR_CO_OP/profiles/$name.sh"
echo "export HEIGHT=$HEIGHT" >> "$DIR_CO_OP/profiles/$name.sh"
echo "export GAMERUN='$GAMERUN'" >> "$DIR_CO_OP/profiles/$name.sh"
echo "../Co-Op-On-Linux.sh" >> "$DIR_CO_OP/profiles/$name.sh"
chmod +x "$DIR_CO_OP/profiles/$name.sh"

zenity --info --text "Preset created! To load it go to the preset folder and execute it's script"

#1/usr/bin/env bash 
source ./config.sh
./roscore_manager.bash

selections=$(whiptail --title "ROS Noetic GUI" --menu "Home" 25 78 5 \
    "rostopic" "listing and displaying topics" \
    "my packages" "access and create new packages" \
    "rosjoy" "configuring and managing joystick permissions" \
    "secure shell" "manage secure communications" \
    "package installer" "install packages for ros noetic" \
    3>&1 1>&2 2>&3
    )

if [ "$?" -eq 255 ]; then
    pkill ./master.bash
fi
case $selections in 
    "rostopic")
        ./rostopic_manager.bash
        ./master.bash
        ;;
    "rosjoy")
        ./rosjoy_manager.bash
        ./master.bash
        ;;
    "my packages")
        ./my_packages.bash
        ./master.bash
        ;;
esac



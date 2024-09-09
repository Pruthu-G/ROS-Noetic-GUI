#!/usr/bin/env bash 
source ./config.sh
events=$(ls /dev/input/)
format_event=()
while IFS= read -r event; do    
    format_event+=("$event" "$event")
done <<< $events
selection=$(whiptail --title "Joystick configuration" --menu "select a joystick" 25 78 5 \
    ${format_event[@]} \
    3>&1 1>&2 2>&3
)

if [ "$?" -eq 255 ]; then  
    pkill ./rosjoy_manager.bash
fi
case $selection in 
    "")
        if [ "$?" -eq 1 ]; then 
            whiptail --title "INFO" --msgbox "no selection made, redirecting to main page" 10 60
        fi
        ;;
    *) 
        passwd=$(whiptail --title "password verification" --passwordbox "enter password" 10 60 3>&1 1>&2 2>&3)
        echo "$?"
        if [ "$?" -eq 0 ]; then 
            echo "$passwd" | sudo -S chmod a+rw /dev/input/$selection
            rosparam set joy_node/dev "/dev/input/$selection"
            whiptail --title "INFO" --msgbox "joy_node/dev set to /dev/input/$selection" 10 60 
            gnome-terminal -- bash -c "rosrun joy joy_node"
        else 
            whiptail --title "WARNING" --msgbox "invalid password" 10 60 
        fi
        ;;
    
esac


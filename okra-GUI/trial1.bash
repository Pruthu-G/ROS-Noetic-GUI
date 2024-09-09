#!/usr/bin/env bash

if ! pgrep -x roscore ; then 
    gnome-terminal -- bash -c "roscore ;exec bash"
fi 

selection_rostopic_funcion(){
     topics=$(rostopic list)
        formatted_topics=()
        while IFS= read -r topic; do
            formatted_topics+=("$topic" "$topic")
        done <<< "$topics"
        selection_rostopic=$(whiptail --title "rostopic selection" --menu "choose: " 25 78 5 \
            ${formatted_topics[@]} \
            3>&1 1>&2 2>&3
        )
        case "$selection_rostopic" in 
            *) 
                gnome-terminal --title "$selection_rostopic" -- bash -c "rostopic echo $selection_rostopic; exec bash"
                main
                ;;
        esac
}

selection_rosjoy_function(){
    events=$(ls /dev/input/)
    formatted_events=()
    while IFS= read -r event; do
        formatted_events+=("$event" "$event")
    done <<< "$events"
    selection_rosjoy=$(whiptail --title "rosjoy selection" --menu "choose : " 25 78 5 \
            ${formatted_events[@]} \
            3>&1 1>&2 2>&3
    )

    case "$selection_rosjoy" in 
        *) 
            local passw=$(whiptail --title "password required" --passwordbox "enter password" 10 60 3>&1 1>&2 2>&3)
            echo "$passw" | sudo -S chmod a+rw /dev/input/$selection_rosjoy
            rosparam set joy_node/dev "/dev/input/$selection_rosjoy"
            gnome-terminal --title "joy node" -- bash -c "rosrun joy joy_node ; exec bash"
            whiptail --title "Parameter confirmation" --msgbox "joy_node/dev/ set to $selection_rosjoy" 10 60

            main
            ;;
    esac
}

secure_shell_function() {
    local passw=$(whiptail --title "Verify Identity" --passwordbox "Enter your password:" 10 60 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then 
        IP_ADD=$(whiptail --title "Input IP Address" --inputbox "Enter a valid server IP:" 10 60 3>&1 1>&2 2>&3)
        USR_NAME=$(whiptail --title "Input Username" --inputbox "Enter a valid username:" 10 60 3>&1 1>&2 2>&3)
        local remote_passw=$(whiptail --title "Enter Remote Device Password" --passwordbox "Enter a valid password:" 10 60 3>&1 1>&2 2>&3)
        
        if [ $? -eq 0 ]; then
            gnome-terminal --title "secure shell $USR_NAME" -- bash -c "echo "$remote_passw" | sshpass -p "$remote_passw" ssh "$USR_NAME@$IP_ADD" ;exec bash"
        else
            whiptail --title "Access Denied" --msgbox "Invalid password" 10 60 
            main
        fi 
    else
        whiptail --title "Access Denied" --msgbox "Invalid password" 10 60 
        main
    fi 
}

main()
{
    selection=$(whiptail --title "welcome to ros!" --menu "choose" 25 78 5 \
    "rostopic" "listing and displaying topics" \
    "rosjoy" "configure joystick" \
    "rosserial" "configure hardware" \
    "secure shell" "configure secure shell" \
    3>&1 1>&2 2>&3
)

case $selection in 

    "rostopic")
       selection_rostopic_funcion

       ;;
    "rosjoy")
        selection_rosjoy_function
        ;;
    "secure shell")
        secure_shell_function
        ;;
esac

}

main
#!/usr/bin/env bash 
source ./config.sh 
packages=$(ls ~/catkin_ws/src)

format_pack=()
while IFS= read -r pack ; do 
    format_pack+=("$pack" "$pack")
done <<< $packages

choose_pack=$(whiptail --title "my packages" --menu "pick a package of create a new one" 25 78 5 \
        "new package" "create new package" \
        ${format_pack[@]} \
        3>&1 1>&2 2>&3)

case $choose_pack in
    "new package")
            pkg_name=$(whiptail --title "pick a name" --inputbox "choose a name for the package according to usual naming conventions" 10 60 3>&1 1>&2 2>&3)
            choose_lang=$(whiptail --title "choose language" --menu "pick the programming language to write in" 25 78 5 \
            "roscpp" "uses C++" \
            "rospy" "uses Python" \
            3>&1 1>&2 2>&3)
            
            pack_info=$(cd ~/catkin_ws/src && catkin_create_pkg "$pkg_name" "$choose_lang")
            whiptail --title "INFO" --msgbox "$pack_info" 16 70 
            ;;
    *) 
        files=$(ls ~/catkin_ws/src/$choose_pack/src)
        format_files=()
        while IFS= read -r pack; do 
            format_files=("$pack" "$pack")
        done <<< $files 

        choose_file=$(whiptail --title "File Selector" --menu "choose a file : " 25 78 5 \
            ${format_files[@]} \
            3>&1 1>&2 2>&3
            )
        
        case $choose_file in 
            *)
                run_or_open=$(whiptail --title "choose action" --menu "what do you wanna do with it?" 25 78 5 \
                    "open" "open with vscode" \
                    "run" "run in a seperate terminal" \
                    3>&1 1>&2 2>&3
                     )
                case $run_or_open in 
                    "open") 
                            gnome-terminal -- bash -c "code ~/catkin_ws/src/$choose_pack/src/$choose_file ;exec bash"
                            ;;
                    "run")
                            gnome-terminal -- bash -c "chmod +x ~/catkin_ws/src/$choose_pack/src/$choose_file"
                            gnome-terminal -- bash -c "rosrun $choose_pack $choose_file"
                            ;;
                esac
                ;;
        esac
        ;;
esac
        

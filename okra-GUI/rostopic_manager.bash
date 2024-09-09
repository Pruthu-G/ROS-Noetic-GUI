source ./config.sh 

topics=$(rostopic list)
format_topic=()
while IFS= read -r topic; do 
    format_topic+=("$topic" "   ")
done <<< $topics

choice=$(whiptail --title "topic menu" --menu "select topic to be displayed" 25 78 5 \
    ${format_topic[@]} \
    3>&1 1>&2 2>&3
    )

case $choice in 
    *) 
        gnome-terminal --title "$choice" -- bash -c "rostopic echo $choice ;exec bash"
        ;;
esac
#!/usr/bin/env bash

whiptail --title "CONFIRMATION" --yesno "Should I proceed" 8 78 
if [[ $? -eq 0 ]]; then 
  whiptail --title "MESSAGE" --msgbox "Process completed successfully." 8 78 
elif [[ $? -eq 1 ]]; then 
  whiptail --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 78 
elif [[ $? -eq 255 ]]; then 
  whiptail --title "MESSAGE" --msgbox "User pressed ESC. Exiting the script" 8 78 
fi 
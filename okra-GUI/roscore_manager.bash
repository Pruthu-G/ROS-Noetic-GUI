#!/usr/bin/env bash


source ./config.sh


if ! pgrep -x "roscore" > /dev/null; then
    gnome-terminal --title "roscore terminal" -- bash -c "roscore; exec bash"
fi




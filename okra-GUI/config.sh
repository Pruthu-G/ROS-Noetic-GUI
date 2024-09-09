export WS_DIR="~/catkin_ws"
export END_RUN="yes"
export PASSWORD="pruthu2005"
export joy_node_dev=$(rosparam get joy_node/dev)
chmod +x rostopic_manager.bash
chmod +x rosjoy_manager.bash
chmod +x my_packages.bash
chmod +x package_installer.bash
source ~/catkin_ws/devel/setup.bash

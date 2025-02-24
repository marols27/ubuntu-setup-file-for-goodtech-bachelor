#!/bin/bash
set -x

# Making sure locales are setup corectly
echo "seting up locales..."
locale
apt update
apt install locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale
apt autoremove -y
echo "locales setup done"


# Ros2 setup:
echo "Starting ROS2 setup..."
apt install software-properties-common -y
add-apt-repository universe -y
apt update 
apt install curl gnupg2 lsb-release -y
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update 
apt install ros-dev-tools -y
apt update
apt upgrade -y
apt install ros-jazzy-desktop -y
apt install ros-jazzy-ros-base -y
echo "ROS2 setup done"


# ROS2 source setup:
# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
echo "Source setup..."
if ! grep -Fxq "source /opt/ros/jazzy/setup.bash" "$HOME/.bashrc"; then
    echo "source /opt/ros/jazzy/setup.bash" >> "$HOME/.bashrc"
fi
source ~/.bashrc
echo "Source setup done"


# Gazebo setup:
echo "Installing gazebo..."
apt install ros-jazzy-ros-gz -y
echo 'export LIBGL_ALWAYS_SOFTWARE=1' >> ~/.bashrc
echo 'export QT_QPA_PLATFORM=xcb' >> ~/.bashrc
echo "Gazebo instaled"


# Setup the ros2 workspace:
echo "Creating ROS2 workspace at $HOME/ros2_ws..."
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws/src
git clone https://github.com/ros/ros_tutorials.git -b jazzy
cd ..
rosdep init
rosdep update
rosdep install -i --from-path src --rosdistro jazzy -y
echo "ROS2 workspace created"


# Universal Robot package download:
echo "Setting up UR robot package..."
cd ~/ros2_ws/src
git clone -b ros2 https://github.com/UniversalRobots/Universal_Robots_ROS2_GZ_Simulation.git ~/ros2_ws/src/ur_simulation_gz
rosdep update
rosdep install --from-paths src --ignore-src -r -y
cd ..
echo "UR robot package setup done"


# Universal Robot Driver:
echo "Installing UR robot driver"
apt install ros-jazzy-ur -y
echo "UR robot driver installed"


# Complete prompt:
echo "please run 'source ~/.bashrc' or open a new terminal to apply changes."

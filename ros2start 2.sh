#!/bin/bash
ROS_DISTRO="humble"
THIS_FILE_PATH="$PWD/$0"

sudo apt -y update && sudo apt -y install curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt -y update
sudo apt -y upgrade

sudo apt -y install ros-${ROS_DISTRO}-desktop python3-rosdep

sudo apt -y update && sudo apt install -y \
  build-essential \
  cmake \
  git \
  libbullet-dev \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  wget

python3 -m pip install -U \
  argcomplete \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest

sudo apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

sudo apt install --no-install-recommends -y \
  libcunit1-dev

sudo rosdep init
rosdep update


echo "source  /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
source ~/.bashrc

mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt install cmake pkg-config
sudo apt-get install python3 swig
sudo apt-get install python3-pip

cd ~/ros2_ws/src
git clone https://github.com/YDLIDAR/YDLidar-SDK.git
mkdir YDLidar-SDK/build
cd YDLidar-SDK/build
cmake ..
make
sudo make install

cd ~/ros2_ws/src/YDLidar-SDK/
pip3 install .

sudo gpasswd --add $USER dialout

cd ~/ros2_ws/src/
git clone -b ${ROS_DISTRO} https://github.com/YDLIDAR/ydlidar_ros2_driver.git

cd ${THIS_FILE_PATH%/*}
cp Tmini_launch_view.py ~/ros2_ws/src/ydlidar_ros2_driver/launch

source  /opt/ros/${ROS_DISTRO}/setup.bash
cd ~/ros2_ws
colcon build --symlink-install

source ./install/setup.bash

sudo apt install ros-humble-slam-toolbox

#gazeboのシュミレーション環境をインストールする

sudo apt-get -y install ros-humble-gazebo-*

#sudo apt install ros-humble-navigation2
#sudo apt install ros-humble-nav2-bringup
#sudo apt install ros-humble-xacro
#sudo apt install ignition-fortress
#sudo apt install ros-humble-ros-ign-bridge

echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc

#turtlebot3
sudo apt install ros-humble-dynamixel-sdk
sudo apt install ros-humble-turtlebot3-msgs
sudo apt install ros-humble-turtlebot3

echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc
source ~/.bashrc

#sudo reboot

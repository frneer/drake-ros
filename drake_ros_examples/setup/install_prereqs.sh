#!/bin/bash
set -eux -o pipefail

apt update && apt install locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

apt install software-properties-common
add-apt-repository universe

# Start - ROS Installation
# Install ROS as described in https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
apt update && apt install locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

apt install software-properties-common
add-apt-repository universe

sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
sudo dpkg -i /tmp/ros2-apt-source.deb

sudo apt update && sudo apt install ros-dev-tools

# End - ROS Installation

apt install ros-dev-tools ros-jazzy-rmw-cyclonedds-cpp ros-jazzy-rviz2 ros-jazzy-ros2cli-common-extensions

rosdep init || true
rosdep update

SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIRECTORY/../..
rosdep install --from-paths drake_ros --rosdistro=jazzy
# TODO(eric.cousineau): This currently fails with
# `Cannot locate rosdep definition for [drake_ros]`. Should fix.
# rosdep install --from-paths drake_ros_examples --rosdistro=jazzy

# Required for bazel_ros2_rules
apt install python3 python3-toposort

# Clear apparmor unprivileged user namespace restrictions.
# Required to create network namespaces for ROS isolation.
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
MAINTAINER So Tamura <so.tamura@tier4.jp>
RUN sed -i.bak -e "s%http://tw.archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list

# Develop
RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui \
        libboost-all-dev \
        libflann-dev \
	libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev

# RUN apt-get update && apt-get install -y git curl cmake wget

# Intall ROS2
RUN apt update && apt install -q -y wget curl gnupg2 lsb-release python3-colcon-common-extensions
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
R

RUN apt update && apt install  -q -y ros-dashing-desktop

RUN echo 'source /opt/ros/dashing/setup.bash' >> /root/.bashrc


RUN apt update && apt install -y \
      google-mock \
      libceres-dev \
      liblua5.3-dev \
      libboost-dev \
      libboost-iostreams-dev \
      libprotobuf-dev \
      protobuf-compiler \
      libcairo2-dev \
      libpcl-dev \
      python3-sphinx

RUN curl -sSL http://get.gazebosim.org | sh
RUN apt update && apt install  -q -y ros-dashing-gazebo-* \
    ros-dashing-cartographer \
    ros-dashing-cartographer-ros \
    ros-dashing-navigation2 \
    ros-dashing-nav2-bringup \
    python3-vcstool

RUN mkdir -p /root/turtlebot3_ws/src \
    && cd /root/turtlebot3_ws/src \
    && wget https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/ros2/turtlebot3.repos \
    && vcs import src < turtlebot3.repos \
    && colcon build --symlink-install

RUN echo 'source ~/turtlebot3_ws/install/setup.bash' >> /root/.bashrc
RUN echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> /root/.bashrc

COPY tmp/gazebo-9 /root/gazebo-9
FROM osrf/ros:noetic-desktop-full

RUN apt-get update \
    && apt-get install -y git \
    && apt-get install -y ros-noetic-navigation \
    && apt-get install -y ros-noetic-robot-localization \
    && apt-get install -y ros-noetic-robot-state-publisher \
    && apt-get install -y ros-noetic-imu-complementary-filter \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:borglab/gtsam-release-4.0 \
    && apt-get update \
    && apt install -y libgtsam-dev libgtsam-unstable-dev \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# OUSTER
RUN mkdir -p /root/catkin_ws/src \
    && cd /root/catkin_ws/src \
    && source /opt/ros/noetic/setup.bash \
    && git clone https://github.com/ouster-lidar/ouster_example.git \
    && cd .. \
    && catkin_make -DCMAKE_BUILD_TYPE=Release

# LIO-SAM
COPY . /root/catkin_ws/src/
RUN mkdir -p /root/catkin_ws/src \
    && cd /root/catkin_ws/src \
    #&& git clone https://github.com/jinkunw/LIO-SAM.git \
    && cd .. \
    && source /opt/ros/noetic/setup.bash \
    && catkin_make -DCMAKE_BUILD_TYPE=Release

RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

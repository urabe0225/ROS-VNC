FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
LABEL maintainer Kazuki Urabe <urabe0225@gmail.com>

RUN apt-get update && apt-get install -y dirmngr
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    python-catkin-tools \
    python-rosdep \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
RUN rosdep init && rosdep update

SHELL ["/bin/bash", "-c"]
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws/src
RUN source /opt/ros/melodic/setup.bash && catkin_init_workspace
WORKDIR /root/catkin_ws/
RUN source /opt/ros/melodic/setup.bash && catkin_make

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
RUN echo "source `catkin locate --shell-verbs`" >> /root/.bashrc

#WORKDIR /root/catkin_ws/src
#RUN source /opt/ros/melodic/setup.bash && \
#    catkin_create_pkg beginner_tutorials std_msgs rospy
#WORKDIR /root/catkin_ws/
#RUN source /opt/ros/melodic/setup.bash && catkin_make
#COPY scripts/ /root/catkin_ws/src/beginner_tutorials/scripts/

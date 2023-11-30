FROM kalilinux/kali-last-release
LABEL Purpose:  Kali with XRDP (for CTFs)
LABEL Author:   daemonchild
LABEL Tag:      daemonchild/kali-xrdp
LABEL Version:  v0.2
EXPOSE 8080
ENV    GUACAMOLE_HOME="/etc/guacamole"
ENV    RES "1920x1080"
WORKDIR /etc/guacamole
# Install locale and set
RUN apt-get update &&            \
    apt-get install -y           \
      locales &&                 \
    apt-get clean &&             \
    rm -rf /var/lib/apt/lists/*
# Before installing desktop, set the locale to UTF-8
# see https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-ubuntu-docker-container
RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8
RUN apt-get update &&            \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      # Install remaining dependencies, tools, and XFCE desktop
      bash-completion  \
      openssh-server   \
      sudo             \
#      tomcat8          \
      vim              \
      wget             \
      curl              \
      xfce4            \
#      xfce4-goodies    \
      xauth            \
      xrdp              \
      dbus-x11          \
      # install libvncserver depencies
      libvncserver-dev \
      gtk2.0       &&  \
    apt-get clean &&             \
    rm -rf /var/lib/apt/lists/*
  
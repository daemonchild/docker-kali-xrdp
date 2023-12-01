FROM kalilinux/kali-last-release
LABEL Purpose:  Kali with XRDP (for CTFs)
LABEL Author:   daemonchild
LABEL Tag:      daemonchild/kali-xrdp
LABEL Version:  v0.2
EXPOSE 8080
ENV    GUACAMOLE_HOME="/etc/guacamole"
ENV    RES "1920x1080"

# Install locale and set
RUN apt-get update &&            \
    apt-get install -y           \
      apt-utils locales &&                 \
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
      build-essential \
      # install libvncserver depencies
      libvncserver-dev \
      gtk2.0       &&  \
    apt-get clean &&             \
    rm -rf /var/lib/apt/lists/*
#Install Tomcat8
WORKDIR /root    
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz -O /root/apache-tomcat-8.5.96.tar.gz && \
    mkdir -p /opt/tomcat8/ && \ 
    tar xvzf /root/apache-tomcat*.tar.gz -C /opt/tomcat8/
# Download necessary Guacamole files
WORKDIR /etc/guacamole
RUN rm -rf /opt/tomcat8/webapps/ROOT && \
    wget "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/binary/guacamole-1.0.0.war" -O /opt/tomcat8/webapps/ROOT.war && \
    wget "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz" -O /etc/guacamole/guacamole-server-1.0.0.tar.gz && \
    tar xvf /etc/guacamole/guacamole-server-1.0.0.tar.gz && \
    cd /etc/guacamole/guacamole-server-1.0.0 && \
   ./configure --with-init-dir=/etc/init.d &&   \
    make CC=gcc-6 &&                            \
    make install &&                             \
    ldconfig &&                                 \
    rm -r /etc/guacamole/guacamole-server-1.0.0*
# Create Guacamole configurations
RUN echo "user-mapping: /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties && \
    touch /etc/guacamole/user-mapping.xml
# Create user account with password-less sudo abilities
RUN useradd -s /bin/bash -g 100 -G sudo -m user && \
    /usr/bin/printf '%s\n%s\n' 'password' 'password'| passwd user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Remove keyboard shortcut to allow bash_completion in xfce4-terminal
RUN echo "DISPLAY=:1 xfconf-query -c xfce4-keyboard-shortcuts -p \"/xfwm4/custom/<Super>Tab\" -r" >> /home/user/.bashrc
# Entry point script
COPY scripts/daemonchild-kali-xrdp-container.sh /root/daemonchild-kali-xrdp-container.sh
RUN chmod +x /root/daemonchild-kali-xrdp-container.sh
USER 1000:100
# copy and untar the default xfce4 config so that we don't get an annoying startup dialog
COPY xfce4-default-config.tgz /home/user/xfce4-default-config.tgz
RUN mkdir -p /home/user/.config/xfce4/ && \
    tar -C /home/user/.config/xfce4/ --strip-components=1 -xvzf /home/user/xfce4-default-config.tgz && \
    rm -f /home/user/xfce4-default-config.tgz
ENTRYPOINT ["sudo", "/bin/bash", "/root/daemonchild-kali-xrdp-container.sh"]
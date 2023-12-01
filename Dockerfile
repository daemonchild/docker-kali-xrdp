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
      software-properties-common \
      libcairo2-dev              \
      libossp-uuid-dev           \
      libpng-dev                 \
      libjpeg-dev                 \
      libpango1.0-dev            \
      libssh2-1-dev              \
      libssl-dev                 \
      libtasn1-bin               \
      libvorbis-dev              \
      libwebp-dev                \
      libpulse-dev               \
      # Install remaining dependencies, tools, and XFCE desktop
      bash-completion  \
      openssh-server   \
      sudo             \
#      tomcat8          \
      vim              \
      wget             \
      curl              \
      net-tools     \
      xfce4            \
      xfce4-goodies    \
      xauth            \
      xrdp              \
      dbus-x11          \
      build-essential \ 
      openjdk-17-jdk \ 
      openjdk-17-jre&& \
    apt-get clean &&             \
    rm -rf /var/lib/apt/lists/*
#Install Tomcat8
WORKDIR /root    
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz -O /root/apache-tomcat-8.5.96.tar.gz && \
    tar xvzf /root/apache-tomcat*.tar.gz -C /opt/ && \
    ln -s /opt/apache-tomcat-8.5.96 /opt/tomcat8 
# Download necessary Guacamole files
WORKDIR /etc/guacamole
RUN rm -rf /opt/tomcat8/webapps/ROOT && \
    wget "https://apache.org/dyn/closer.lua/guacamole/1.5.3/binary/guacamole-1.5.3.war?action=download" -O /opt/tomcat8/webapps/ROOT.war && \
    wget "https://apache.org/dyn/closer.lua/guacamole/1.5.3/source/guacamole-server-1.5.3.tar.gz?action=download" -O /etc/guacamole/guacamole-server.tar.gz && \
    tar xvf /etc/guacamole/guacamole-server.tar.gz && \
    cd /etc/guacamole/guacamole-server* && \
   ./configure --with-init-dir=/etc/init.d &&   \
    make CC=gcc &&                            \
    make install &&                             \
    ldconfig &&                                 \
    rm -r /etc/guacamole/guacamole-server*
# Create Guacamole configurations
RUN touch /etc/guacamole/user-mapping.xml && \ 
    echo "user-mapping: /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties && \  
    echo "guacd-hostname: localhost" >> /etc/guacamole/guacamole.properties && \
    echo "guacd-port: 4822" >> /etc/guacamole/guacamole.properties 
# Create user account with password-less sudo abilities
RUN useradd -s /bin/bash -g 100 -G sudo -m user && \
    /usr/bin/printf '%s\n%s\n' 'password' 'password'| passwd user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Remove keyboard shortcut to allow bash_completion in xfce4-terminal
RUN echo "DISPLAY=:1 xfconf-query -c xfce4-keyboard-shortcuts -p \"/xfwm4/custom/<Super>Tab\" -r" >> /home/user/.bashrc
# Entry point script
COPY scripts/daemonchild-kali-xrdp-container.sh /root/daemonchild-kali-xrdp-container.sh
RUN chmod +x /root/daemonchild-kali-xrdp-container.sh
# Install kali tooling packages
#RUN  apt-get update &&            \
#    DEBIAN_FRONTEND=noninteractive apt-get install -y \
#      cowsay \
#      kali-linux-core \
#      kali-linux-wsl \
#      kali-linux-headless \
#      kali-tools-crypto-stego \
#      kali-tools-database \
#      kali-tools-exploitation \
#      kali-tools-information-gathering \
#      kali-tools-passwords \
#      kali-tools-web && \ 
#    apt-get clean &&             \
#    rm -rf /var/lib/apt/lists/*
USER 1000:100
ENTRYPOINT ["sudo", "/bin/bash", "/root/daemonchild-kali-xrdp-container.sh"]
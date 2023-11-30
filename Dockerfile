FROM kalilinux/kali-last-release
LABEL Purpose:  Kali with XRDP (for CTFs)
LABEL Author:   daemonchild
LABEL Tag:      daemonchild/kali-xrdp
LABEL Version:  v0.2
WORKDIR /root
COPY scripts/build-kali-base.sh /root/scripts/
RUN /bin/bash /root/scripts/build-kali-base.sh
COPY scripts/ /root/scripts/
RUN /bin/bash /root/scripts/add-xrdp.sh
RUN /bin/bash /root/scripts/add-user-config.sh
RUN chmod +x /root/scripts/daemonchild-kali-xrdp-container.sh
ENTRYPOINT ["/root/scripts/daemonchild-kali-xrdp-container.sh"]

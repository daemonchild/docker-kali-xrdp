# daemonchild/kali-xrdp

>A container image including a conservative build of Kali.
In addition, xrdp is added and configured, and a number of users added.

Purpose:  Kali with XRDP (for CTFs)

Version:  v0.2

## Building Your Image

To build the image, use:

```docker build -t kali-xrdp .```

And to run this image:

```docker run -d -p 13389:3389 kali-xrdp```

## Prebuilt Container Image

Prebuilt container image:

```docker run -d -p 13389:3389 daemonchild/kali-xrdp:latest```

Then RDP to your Kali container on port 13389.

You might want to set up a permanent volume for data.

Users:
user-a to user-e, password=[the same as the username]

> To do: add ssh daemon to startup.
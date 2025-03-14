# Remote Desktop

This page describes how to enable Remote Desktop on ABCI with VNC (Virtual Network Computing). By using Remote Desktop, you can use the GUI on compute nodes.

## Preparation

* Login to the interactive node, and launch ``vncserver`` for initial settings 

```
[username@login1 ~]$ vncserver
WARNING: vncserver has been replaced by a systemd unit and is now considered deprecated and removed in upstream.
Please read /usr/share/doc/tigervnc/HOWTO.md for more information.

You will require a password to access your desktops.

Password:
Verify:
Would you like to enter a view-only password (y/n)? n
A view-only password is not used

New 'login1:1 (username)' desktop is login1:1

Creating default startup script /home/username/.vnc/xstartup
Creating default config /home/username/.vnc/config
Starting applications specified in /home/username/.vnc/xstartup
Log file is /home/username/.vnc/login1:1.log
```

* Stop VNC server

```
[username@login1 ~]$ vncserver -kill :1
```

* Edit some configuration files

$HOME/.vnc/xstartup:

```
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
#/etc/X11/xinit/xinitrc
# Assume either Gnome will be started by default when installed
# We want to kill the session automatically in this case when user logs out. In case you modify
# /etc/X11/xinit/Xclients or ~/.Xclients yourself to achieve a different result, then you should
# be responsible to modify below code to avoid that your session will be automatically killed
xrdb $HOME/.Xresources
startxfce4 &
if [ -e /usr/bin/gnome-session ]; then
    vncserver -kill $DISPLAY
fi
```

You can change screen size to edit $HOME/.vnc/config if needed.

```
geometry=2000x1200
```

* Login to ABCI

* Login to a compute node which is assigned by AGE with ABCI On-demand service and resource type rt_F.

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1 -l walltime=01:00:00
```

* Launch ``vncserver``

```
[username@hnode001 ~]$ vncserver
WARNING: vncserver has been replaced by a systemd unit and is now considered deprecated and removed in upstream.
Please read /usr/share/doc/tigervnc/HOWTO.md for more information.

New 'hnode001:1 (username)' desktop is hnode001:1

Starting applications specified in /home/username/.vnc/xstartup
Log file is /home/username/.vnc/hnode001:1.log

[username@hnode001 ~]$
```

hnode001:1 is the display name of the VNC server you launched. Port 5901 is assinged to the connection to this server.
In general, you can connect to the VNC server using a port with the display number plus 5900. For example, port 5902 for :2, port 5903 for :3, and so on.

## Start VNC

The following part explains how to start VNC separately for macOS and Windows.

### Using an SSH Client

Your computer most likely has an SSH client installed by default. If your computer is a UNIX-like system such as Linux and macOS, or Windows 10 version 1803 (April 2018 Update) or later, it should have an SSH client. You can also check for an SSH client, just by typing ``ssh`` at the command line.

#### Create an SSH tunnel

To connect to the VNC server by using Port 5901 of your computer, you need to create an SSH tunnel between ``localhost:5901`` and  ``hnode001:5901``.

You can create one with the following command. The port specified with `-p` should be the SSH tunnel port specified when connecting to the access server.

```
[user@localmachine]$ ssh -i C:\path\to\identity_file -p 50022 -N -L 5901:hnode001:5901 -l username localhost
```

#### Launch VNC client

In macOS, VNC client is integrated in Finder. So, you can connect to the VNC server by the following command:

```
[user@localmachine]$ open vnc://localhost:5901/
```

If not using macOS, you need to install a VNC client separately and configure it to connect to the VNC server.

### PuTTY

First, configure an SSH tunnel.

Click [Change Settings...] and click [SSH] - [Tunnels].

| item | value |
|:--|:--|
| sample image | <img src="3vnc_portfw_putty_01.png"  width="480" title="putty:ssh tunnel" > |
| local port | port number which you can use on your system. ex) 15901 |
| remote host:port | hostname of compute node and port number of VNC server ex) hnode001:5901) |

Launch VNC client and connect to localhost and the port number which assigned by SSH port forwarding.
In the example of Tiger VNC client, hostname and port number are connected by "::".

<div align="center">
<img src="3vnc_viewer_01.png" width="480" title="vncviewer"><br>
</div>

Click [Accept] , enter your VNC password, then launch VNC viewer.

## Stop VNC

* stop VNC service and exit compute node.

```
[username@hnode001 ~]$ vncserver -list

TigerVNC server sessions:

X DISPLAY #     PROCESS ID
:1              5081

[username@hnode001 ~]$ vncserver -kill :1
Killing Xvnc process ID XXXXXX
[username@hnode001 ~]$ exit
[username@login1 ~]$
```

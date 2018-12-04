# Appendix2. How To Use Other Services

## Remote desktop

### Overview

This chapter describes using Remote Desktop. By using Remote Desktop, you can use the GUI on compute nodes.

### Preparation

* login the interactive node and launch vncserver for initial settings 

```

[abciuser@esX ~] $ vncserver

You will require a password to access your desktops.

Password:

Verify:

Would you like to enter a view-only password (y/n)? n

New 'esX.abci.local:1 (abciuser)' desktop is esX.abci.local:1

Creating default startup script /home/abciuser/.vnc/xstartup

Creating default config /home/abciuser/.vnc/config

Starting applications specified in /home/abciuser/.vnc/xstartup

Log file is /home/abciuser/.vnc/esX.abci.local:1.log

```

* stop VNC server

```

[user@gXXXX ~] vncserver -kill :1

```

* edit some configuration files.

$HOME/.vnc/xstartup:

```

#!/bin/sh

unset SESSION_MANAGER

unset DBUS_SESSION_BUS_ADDRESS

xrdb $HOME/.Xresources

startxfce4 &

```

you can change screen size to edit $HOME/.vnc/config as needed.

```

geometry=2000x1200

```

* login to ABCI and 

```

[user@localmachine] $ ssh -J %r@as.abci.ai abciuser@es

```

* login to a compute node which is assigned by UGE with ABCI On-demand service and resource type rt_F.

```
[abciuser@esX ~] $ qrsh -g abcigroup -l rt_F=1

```

* launch vncserver

```

[user@gXXXX ~] vncserver

New 'gXXXX.abci.local:1 (abciuser)' desktop is gXXXX.abci.local:1

Starting applications specified in /home/abciuser/.vnc/xstartup

Log file is /home/abciuser/.vnc/gXXXX.abci.local:1.log

```

gXXXX.abci.local:1 is a display name of launched VNC server.A port number 5901 is assinged to this server. A port with 5900 added to the display number is allocated such as: 5902 in case of :2, 5903 in case of :3.


### Start VNC

The following chapter explains how to start VNC separately for macOS and Windows.

#### macOS environment

In macOS, OpenSSH 7.4 or later is installed by default, and the VNC client is integrated in the Finder.

* Configure port forwarding from the local machine.

```

[user@localmachine] $ ssh -N -L 5901:XXX.abci.local:5901 -J %r@as.abci.ai abciuser@es

```

By accessing 5901 on the local machine, you can connect to the VNC server.

* launch VNC client

```

[user@localmachine] $ open vnc://localhost:5901/

```

#### Windows environment

Configure port forwarding.

*   PuTTY

    Click [Change Settings...] and click [SSH] - [Tunnels].

	| item | value |
	|:--|:--|
	| sample image | <img src="/img/apdx2_vnc_portfw_putty_01.png"  width="480" title="putty:ssh tunnel" > |
	| local port | port number which you can use on your system. ex) 15901 |
	| remote host:port | hostname of compute node and port number of VNC server ex) g0123:5901) |

    Launch VNC client and connect to localhost and the port number which assigned by SSH port forwarding.
    In the example of Tiger VNC client, hostname and port number are connected by "::".

<div align="center">
<img src="/img/apdx2_vnc_viewer_01.png" width="480" title="vncviewer"><br>
</div>

    Click [Accept] , enter your VNC password, then launch VNC viewer.

### Stop VNC

* stop VNC service and exit compute node.

```

[user@gXXXX ~]$ vncserver -list

TigerVNC server sessions:

X DISPLAY #     PROCESS ID
:1              5081

[user@gXXXX ~] vncserver -kill :1

[user@gXXXX ~] exit

[user@esX ~] exit

```

## AWS

### Overview

This chapeter describes installation of AWS command line interface (awscli below) and command examples.

### pip for pyenv (reference)

*   installation

```
[username@es1 testdir]$ curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
[username@es1 testdir]$ echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
[username@es1 testdir]$ echo 'eval "$(pyenv init -)"' >> ~/.bashrc
[username@es1 testdir]$ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
```
    After restart your shell, start pyenv 
   
```
[username@es1 testdir]$ pyenv versions
[username@es1 testdir]$ pyenv install 2.7.15
[username@es1 testdir]$ pyenv virtualenv 2.7.15 awscli-test
[username@es1 testdir]$ pyenv global awscli-test 
```

### Installaton of awscli

```
[username@es1 testdir]$ pip install awscli
```

### Register access token

regist your AWS access token
```
[username@es1 testdir]$  aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]:
```

### command example

* Creates an S3 bucket.
```
[username@es1 testdir]$ aws s3 mb s3://abci-access-test
make_bucket: abci-access-test
```

* Copy a local file to S3 bucket (cp)
```
[username@es1 testdir]$ ls -la 1gb.dat 
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  7 11:27 1gb.dat
$ aws s3 cp 1gb.dat s3://abci-access-test # 
upload: ./1gb.dat to s3://abci-access-test/1gb.dat                
```

* List S3 object in the bucket (ls) 
```
[username@es1 testdir]$ aws s3 ls s3://abci-access-test 
2018-11-09 10:13:56 1073741824 1gb.dat
```

* Delet S3 object in the bucket (rm)
```
[username@es1 testdir]$ aws s3 rm s3://abci-access-test/1gb.dat
delete: s3://abci-access-test/1gb.dat
[username@es1 testdir]$ ls -l dir-test/
total 2097152

-rw-r--r-- 1 aaa10003xb gaa50031   1073741824 Nov  9 10:16 1gb.dat.1
-rw-r--r-- 1 aaa10003xb gaa50031   1073741824 Nov  9 10:17 1gb.dat.2
```

* Sync and recursively copy local file to bucket(sync)
```
[username@es1 testdir]$ aws s3 sync dir-test s3://abci-access-test/dir-test
upload: dir-test/1gb.dat.2 to s3://abci-access-test/dir-test/1gb.dat.2
upload: dir-test/1gb.dat.1 to s3://abci-access-test/dir-test/1gb.dat.1
```

* Sync and recursively copy file to bucket(sync)
```
[username@es1 testdir]$ aws s3 sync s3://abci-access-test/dir-test s3://abci-access-test/dir-test2
copy: s3://abci-access-test/dir-test/1gb.dat.1 to s3://abci-access-test/dir-test2/1gb.dat.1
copy: s3://abci-access-test/dir-test/1gb.dat.2 to s3://abci-access-test/dir-test2/1gb.dat.2
[username@es1 testdir]$ aws s3 ls s3://abci-access-test/dir-test2/
2018-11-09 10:20:05 1073741824 1gb.dat.1
2018-11-09 10:20:06 1073741824 1gb.dat.2
```

* Sync directories and recursively copy file to local directory (sync)
```
[username@es1 testdir]$ aws s3 sync s3://abci-access-test/dir-test2 dir-test2
download: s3://abci-access-test/dir-test2/1gb.dat.2 to dir-test2/1gb.dat.2
download: s3://abci-access-test/dir-test2/1gb.dat.1 to dir-test2/1gb.dat.1
[username@es1 testdir]$ ls -l dir-test2
total 2097152
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  9 10:20 1gb.dat.1
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  9 10:20 1gb.dat.2
```

* Deletes an S3 object in the bucket
```
[username@es1 testdir]$ aws s3 rm --recursive s3://abci-access-test/dir-test
delete: s3://abci-access-test/dir-test/1gb.dat.2
delete: s3://abci-access-test/dir-test/1gb.dat.1
[username@es1 testdir]$ aws s3 rm --recursive s3://abci-access-test/dir-test2
delete: s3://abci-access-test/dir-test2/1gb.dat.2
delete: s3://abci-access-test/dir-test2/1gb.dat.1
```

* Deletes an empty S3 bucket. 
```
[username@es1 testdir]$ aws s3 rb s3://abci-access-test
remove_bucket: abci-access-test
```



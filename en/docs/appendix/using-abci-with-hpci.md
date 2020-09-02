# Appendix. Using ABCI with HPCI

!!! note
    This section describes how to login to the interactive node, and to transfer files and so on for HPCI users.

## Login to Interactive Node

To login to the interactive node (*es*) as frontend, you need to login to the access server (*hpci.abci.ai*) with proxy certificate and then to login to the interactive node with the `ssh` command.

### Linux / macOS Environment

Login to the access server for HPCI (*hpci.abci.ai*) with the `gsissh` command.

<div class="codehilite"><pre>
yourpc$ gsissh -p 2222 <i>hpci.abci.ai</i>
[username@hpci1 ~]$
</pre></div>

After login to the access server for HPCI, login to the interactive node with the `ssh` command.

<div class="codehilite"><pre>
[username@hpci1 ~]$ ssh <i>es</i>
[username@es1 ~]$
</pre></div>

### Windows Environment (GSI-SSHTerm)

To login to the interactive node, the following procedure is necessary.

1. Launch the GSI-SSHTerm
2. Enter the access server for HPCI (*hpci.abci.ai*) and login
3. Login to the interactive node with the `ssh` command

After login to the accesss server for HPCI, login to the interactive node with the `ssh` command.

<div class="codehilite"><pre>
[username@hpci1 ~]$ ssh <i>es</i>
[username@es1 ~]$
</pre></div>

## File Transfer to Interactive Node

The home area is not shared on the access server for HPCI.
So, when transferring files between your PC and the ABCI system,
transfer them to the access server (*hpci.abci.ai*) once, and then transfer them to the interactive node with the `scp` (`sftp`) command.

<div class="codehilite"><pre>
[username@hpci1 ~]$ scp local-file username@<i>es</i>:remote-dir
local-file    100% |***********************|  file-size  transfer-time
</pre></div>

To display disk usage and quota about home area on the access server for HPCI,
use the `quota` command.

```
[username@hpci1 ~]$ quota
Disk quotas for user axa01004ti (uid 1004):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
      /dev/sdb2      48  104857600 104857600              10       0       0
```

| Item | Description |
|:--|:--|
| Filesystem | File System   |
| blocks     | Disk usage(KB) |
| files      | Number of files |
| quota      | Upper limit(soft) |
| limit      | Upper limit(hard) |
| grace      | Grace time |

!!! note
    The allocation amount of home area on the access server for HPCI is 100GB.
    Delete unnecessary files as soon as possible.

## Mount HPCI shared storage

To mount the HPCI shared storage on the access server for HPCI, use the `mount.hpci` command.

!!! note
    The HPCI shared storage is not available on the interactive node.

```
[username@hpci1 ~]$ mount.hpci
```

The mount status can be checked with the `df` command.

```
[username@hpci1 ~]$ df -h /gfarm/project-ID/username
```

To unmount the HPCI shared storage, use the `umount.hpci` command.

```
[username@hpci1 ~]$ umount.hpci
```

## Communication between Access Server for HPCI and external services

Some communication between the access server for HPCI and external service/server is permitted.
We will consider permission for a certain period of time on application basis for communication which is not currently permitted.
Please contact us if you have any request.

- Communication from access server for HPCI to ABCI external network
  The following services are permitted.

| Port Number | Service Type |
|:--|:--|
| 443/tcp | https |

!!! note
    HPCI users cannot access to ABCI external HPCI login server from the access server for HPCI.

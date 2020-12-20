# Appendix. SSH Access to Compute Node

By using the SSH access to compute node, you can login to allocated compute node.
To use the SSH access to compute node, you need to submit job with `-l USE_SSH=1` option.
And you need to specify `-l rt_F` option in this case, because compute node must be exclusively allocated to job.

Example) sample of job script (use_ssh.sh)

```bash
#!/bin/bash

#$-l rt_F=2
#$-l USE_SSH=1
#$-v SSH_PORT=2222
#$-cwd

...
```

To change the paramter of SSH access to compute node, define following environment variable.

| Environment Variable | Description |
|:---|:---|
| SSH_PORT | Specify port number of SSH service on compute node (default: 2222). 2200-2299 can be specified. |

When the job starts, check allocated compute nodes by using `qstat` command.

```
[username@es1 ~]$ qstat -j 12345 | grep exec_host_list
exec_host_list        1:    g0001:80, g0002:80
```

Login to the compute node from interactive node with port number specified at job submission.

```
[username@es1 ~]$ ssh -p 2222 g0001
[username@g0001 ~]$ 
```

!!! note
    Only the user who submitted the job can login.

And you can also login between allocated compute nodes.

```
[username@g0001 ~]$ ssh -p 2222 g0002
[username@g0002 ~]$
```

!!! note
    When the job ends, the session to compute node will disconnected.

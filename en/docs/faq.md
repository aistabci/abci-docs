# FAQ

## Q. If I enter Ctrl+S during interactive jobs, I cannot enter keys after that

This is because standard terminal emulators for macOS, Windows, and Linux have Ctrl+S/Ctrl+Q flow control enabled by default. To disable it, execute the following in the terminal emulator of the local PC:

```shell
$ stty -ixon
```

Executing while logged in to the interactive node has the same effect.

## Q. Singularity cannot use container registries that require authentication

SingularityPRO has a function equivalent to ``docker login`` that provides authentication information with environment variables.

```shell
[username@es1 ~]$ export SINGULARITY_DOCKER_USERNAME='username'
[username@es1 ~]$ export SINGULARITY_DOCKER_PASSWORD='password'
[username@es1 ~]$ singularity pull docker://myregistry.azurecr.io/namespace/repo_name:repo_tag
```

For more information on SingularityPRO authentication, refer to the following user guide.

* [SingularityPRO 3.9 User Guide](https://repo.sylabs.io/guides/pro-3.9/user-guide/index.html)
    * [Authentication/Private Containers](https://repo.sylabs.io/guides/pro-3.9/user-guide/singularity_and_docker.html#authentication-private-containers)

## Q. I want to assign multiple compute nodes and have each compute node perform different processing

If you give `-l rt_F=N` or `-l rt_AF=N` option to `qrsh` or `qsub`, you can assign N compute nodes. You can also use MPI if you want to perform different processing on each assigned compute node.

```
$ module load hpcx/2.12
$ mpirun -hostfile $SGE_JOB_HOSTLIST -np 1 command1 : -np 1 command2 : ... : -np1 commandN
```

## Q. I want to avoid to close SSH session unexpectedly

The SSH session may be closed shortly after connecting to ABCI with SSH. In such a case, you may be able to avoid it by performing KeepAlive communication between the SSH client and the server.

To enable KeepAlive, set the option ServerAliveInterval to about 60 seconds in the system ssh configuration file (/etc/ssh/ssh_config) or per-user configuration file (~/.ssh/config) on the user's terminal.
```
[username@yourpc ~]$ vi ~/.ssh/config
[username@yourpc ~]$ cat ~/.ssh/config
(snip)
Host as.abci.ai
   ServerAliveInterval 60
(snip)
[username@userpc ~]$
```

!!! note
    The default value of ServerAliveInterval is 0 (no KeepAlive).

## Q. I want to know how ABCI job execution environment is congested

ABCI operates a web service that visualizes job congestion status as well as utilization of compute nodes, power consumption of the whole datacenter, PUE, cooling facility, etc.
The service runs on an internal server, named `vws1`, on 3000/tcp port.
You can access it by following the procedure below.

You need to set up SSH tunnel.
The following example, written in `$HOME/.ssh/config` on your PC, sets up the SSH tunnel connection to ABCI internal servers through as.abci.ai by using ProxyCommand.
Please also refer to the procedure in [Login using an SSH Client::General method](getting-started.md#general-method) in ABCI System User Environment.

```shell
Host *.abci.local
    User         username
    IdentityFile /path/identity_file
    ProxyCommand ssh -W %h:%p -l username -i /path/identity_file as.abci.ai
```

You can create an SSH tunnel that transfers 3000/tcp on your PC to 3000/tcp on vws1.

```shell
[username@userpc ~]$ ssh -L 3000:vws1:3000 es.abci.local
```

You can access the service by opening `http://localhost:3000/` on your favorite browser.

## Q. Are there any pre-downloaded datasets?

Please see [Datasets](tips/datasets.md).

## Q. Image file creation with Singularity pull fails in batch job

When you try to create an image file with Singularity pull in a batch job, the mksquashfs executable file may not be found and the creation may fail.

```
INFO:    Converting OCI blobs to SIF format
FATAL:   While making image from oci registry: while building SIF from layers: unable to create new build: while searching for mksquashfs: exec: "mksquashfs": executable file not found in $PATH
```

The problem can be avoided by adding `/usr/sbin` to PATH like this:

Example)
```
[username@g0001 ~]$ export PATH="$PATH:/usr/sbin" 
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv docker://caffe2ai/caffe2:latest
```

## Q. I get an error due to insufficient disk space, when I ran the singularity build/pull on the compute node. {#q-insufficient-disk-space-for-singularity-build}

The `singularity build` and `pull` commands use `/tmp` as the location to create temporary files.
When you build a large container on the compute node, it may cause an error due to insufficient space in `/tmp`.

```
FATAL:   While making image from oci registry: error fetching image to cache: 
while building SIF from layers: conveyor failed to get: writing blob: write 
/tmp/0123456789.1.gpu/bundle-temp-0123456789/oci-put-blob0123456789: 
no space left on device
```

If you get an error due to insufficient space, set the `SINGULARITY_TMPDIR` environment variable to use the local storage as shown below:

```
[username@g0001 ~]$ SINGULARITY_TMPDIR=$SGE_LOCALDIR singularity pull docker://nvcr.io/nvidia/tensorflow:20.12-tf1-py3
```


## Q. How can I find the job ID?

When you submit a batch job using the `qsub` command, the command outputs the job ID.

```
[username@es1 ~]$ qsub -g grpname test.sh
Your job 1000001 ("test.sh") has been submitted
```

If you are using `qrsh`, you can get the job ID by retrieving the value of the JOB_ID environment variable.This variable is available for `qsub` (batch job environment) as well.

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ echo $JOB_ID
1000002
[username@g0001 ~]$
```

To find the job ID of your already submitted job, use the `qstat` command.

```
[username@es1 ~]$ qstat
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
   1000003 0.00000 test.sh username   qw    08/01/2020 13:05:30
```

To find the job ID of your completed job, use `qacct -j`. The `-b` and `-e` options are useful for narrowing the search range. See qacct(1) man page (type `man qacct` on an interactive node). The following example lists the completed jobs that started on and after September 1st, 2020. `jobnumber` has the same meaning as `job-ID`.

```
[username@es1 ~]$ qacct -j -b 202009010000
==============================================================
qname        gpu
hostname     g0001
group        grpname
owner        username

:

jobname      QRLOGIN
jobnumber    1000010

:

qsub_time    09/01/2020 16:41:37.736
start_time   09/01/2020 16:41:47.094
end_time     09/01/2020 16:45:46.296

:

==============================================================
qname        gpu
hostname     g0001
group        grpname
owner        username

:

jobname      testjob
jobnumber    1000120

:

qsub_time    09/07/2020 15:35:04.088
start_time   09/07/2020 15:43:11.513
end_time     09/07/2020 15:50:11.534

:
```

## Q. I want to run the Linux command on all allocated compute node

ABCI provides the `ugedsh` command to execute Linux commands in parallel on all allocated compute nodes.
The command specified in the argument of the `ugedsh` command is executed once on each node.

Example)

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2
[username@g0001 ~]$ ugedsh hostname
g0001: g0001.abci.local
g0002: g0002.abci.local
```

## Q. What is the difference between Compute Node (A) and Compute Node (V)

ABCI was upgraded to ABCI 2.0 in May 2021.
In addition to the previously provided Compute Nodes (V) with NVIDIA V100, the Compute Nodes (A) with NVIDIA A100 are currently available.

This section describes the differences between the Compute Node (A) and the Compute Node (V), and points to note when using the Compute Node (A).

### Resource type name

The Resource type name is different between the Compute Node (A) and the Compute Node (V). Compute Node (A) can be used by specifying the following Resource type name when submitting a job.

Resource type | Resource type name | Assigned physical CPU core | Number of assigned GPU | Memory (GiB) |
|:-|:-|:-|:-|:-|
| Full | rt\_AF | 72 | 8 | 480 |
| AG.small | rt\_AG.small | 9 | 1 | 60 |

For more detailed Resource types, see [Available Resource Types](job-execution.md#available-resource-types).

### Accounting

Compute Node (A) and Compute Node (V) have different Resource type charge coefficient, as described at [Available Resource types](job-execution.md#available-resource-types). Therefore, the number of ABCI points used, which are calculated based on [Accounting](job-execution.md#accounting), is also different.

The number of ABCI points used when using the Compute Node (A) is as follows:

| [Resource type name](job-execution.md#available-resource-types)<br>[Execution Priority](job-execution.md#execution-priority) | On-demand or Spot Service<br>Execution Priority: -500 (default)<br>(point/hour) | On-demand or Spot Service<br>Execution Priority: -400<br>(point/hour) | Reserved Service<br>(point/day) |
|:-|:-|:-|:-|
| rt\_AF | 3.0 | 4.5 | 108 |
| rt\_AG.small | 0.5 | 0.75 | N/A |

### Operating System

The Compute Node (A) and the Compute Node (V) use different Operating Systems.

| Node | Operating System |
|:-|:-|
| Compute Node (A) | Red Hat Enterprise Linux 8.2 |
| Compute Node (V) | Rocky Linux 8.6 |

Rocky Linux and Red Hat Enterprise Linux are compatible, but a program built on one is not guaranteed to work on the other.
Please rebuild the program for the Compute Node (A) using the Compute Node (A) or the Interactive Node (A) described later.

### CUDA Version

The NVIDIA A100 installed on the compute node (A) is Compute Capability 8.0 compliant.

CUDA 10 and earlier does not support Compute Capability 8.0. Therefore, Compute Node (A) should use CUDA 11 or later that supports Compute Capability 8.0.

!!! Note
    [Environment Modules](environment-modules.md) makes CUDA 10 available for testing, but its operation is not guaranteed.

### Interactive Node (A)

ABCI provides the Interactive Nodes (A) with the same software configuration as the Compute Node (A) for the convenience of program development for the Compute Node (A). The program built on the Interactive Node (A) does not guarantee the operation on the Compute Node (V).

Please refer to the following for the proper use of Interactive Nodes:

| | Interactive Node (V) | Interactive Node (A) |
|:-|:-:|:-:|
| Can users log in? | Yes | Yes |
| Can users develop programs for Compute Nodes (V)? | Yes | No |
| Can users develop programs for Compute Nodes (A)? | No | Yes |
| Can users submit jobs for Compute Nodes (A)? | Yes | Yes |
| Can users submit jobs for Compute Nodes (A)? | Yes | Yes |

For more information on Interactive Node (A), see [Interactive Node](system-overview.md#interactive-node).


## Q. How to use previous ABCI Environment Modules

ABCI provides previous ABCI Environment Modules.
ABCI Environment Modules for each year are installed below, so set the path of the year you want to use in the `MODULE_HOME` environment variable and load the configuration file.

Please note that previous ABCI Environment Modules is not eligible for the ABCI System support.

!!! note
    In FY2023, we changed the operating system for the Compute Node (V) and the Interactive Node (V) from CentOS 7 to Rocky Linux 8.
    As a result, the previous Environment Modules for CentOS 7 will not work on the new Compute Node (V) and the Interactive Node (V).
    Please use the Memory-Intensive Node to use the previous Environment Modules for CentOS 7.

| ABCI Environment Modules | Installed Path                | Compute Node (V) | Compute Node (A) | Memory-Intensive Node |
| ------------------------ | ----------------------------- | ---------------- | ---------------- | --------------------- |
| 2020 version             | `/apps/modules-abci-1.0`      | -                | -                | Yes                   |
| 2021 version             | `/apps/modules-abci-2.0-2021` | -                | Yes              | Yes                   |
| 2022 version             | `/apps/modules-abci-2.0-2022` | -                | Yes              | Yes                   |

The following is an example of using the 2021 version of ABCI Environment Modules.

sh, bash:

```
export MODULE_HOME=/apps/modules-abci-2.0-2021
. ${MODULE_HOME}/etc/profile.d/modules.sh
```

ch, tcsh:

```
setenv MODULE_HOME /apps/modules-abci-2.0-2021
source ${MODULE_HOME}/etc/profile.d/modules.csh
```


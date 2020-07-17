# FAQ

## Q. If I enter Ctrl+S during interactive jobs, I cannot enter keys after that

This is because standard terminal emulators for macOS, Windows, and Linux have Ctrl+S/Ctrl+Q flow control enabled by default. To disable it, execute the following in the terminal emulator of the local PC:

```shell
$ stty -ixon
```

Executing while logged in to the interactive node has the same effect.

## Q. The group area is consumed more than the actual size

Generally, any file systems have their own block size, and even the smallest file consumes the capacity of the block size.

ABCI sets the block size of the group area to 128 KB and the block size of the home area to 4 KB. For this reason, if a large number of small files are created in the group area, usage efficiency will be reduced. For example, if you want to create a file that is less than 4KB in the group area, you need about 32 times the capacity of the home area.

## Q. Singularity cannot use container registries that require authentication

Singularity version 2.6 has a function equivalent to ``docker login`` that provides authentication information with environment variables.

```shell
[username@es ~]$ export SINGULARITY_DOCKER_USERNAME='username'
[username@es ~]$ export SINGULARITY_DOCKER_PASSWORD='password'
[username@es ~]$ singularity pull docker://myregistry.azurecr.io/namespace/repo_name:repo_tag
```

For more information on Singularity version 2.6 authentication, see below.

* [Singularity Container Documentation](https://www.sylabs.io/guides/2.6/user-guide.pdf)
    * 14.6 How do I specify my Docker image?
    * 14.7 Custom Authentication

## Q. NGC CLI cannot be executed

When running [NGC Catalog CLI](https://docs.nvidia.com/ngc/ngc-catalog-cli-user-guide/index.html) on ABCI, the following error message appears and execution is not possible. This is because the NGC CLI is built for Ubuntu 14.04 and later.

```
ImportError: /lib64/libc.so.6: version `GLIBC_2.18' not found (required by /tmp/_MEIxvHq8h/libstdc++.so.6)
[89261] Failed to execute script ngc
```

By preparing the following shell script, it can be executed using Singularity. This technique can be used not only for NGC CLI but also for general use.

```
#!/bin/sh
source /etc/profile.d/modules.sh
module load singularity/2.6.1

NGC_HOME=$HOME/ngc
singularity exec $NGC_HOME/ubuntu-18.04.simg $NGC_HOME/ngc $@
```

## Q. I want to assign multiple compute nodes and have each compute node perform different processing

If you give `-l rt_F=N` option to `qrsh` or `qsub`, you can assign N compute nodes. You can also use MPI if you want to perform different processing on each assigned compute node.

```
$ module load openmpi/2.1.6
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

## Q. I want to use a newer version of Open MPI

ABCI offers CUDA-aware and CUDA non-aware versions of Open MPI, and you can check the availability provided by [Using MPI](08.md#open-mpi).

The Environment Modules provided by ABCI will attempt to configure CUDA-aware Open MPI environment when loading `openmpi` module only if `cuda` module has been loaded beforehand.

For the combination where CUDA-aware MPI is provided (`cuda/10.0/10.0.130.1`, `openmpi/2.1.6`), therefore, the environment settings will succeed:

```
$ module load cuda/10.0/10.0.130.1
$ module load openmpi/2.1.6
$ module list
Currently Loaded Modulefiles:
  1) cuda/10.0/10.0.130.1   2) openmpi/2.1.6
```

For the combination where CUDA-aware MPI is not provided (`cuda/10.0/10.0.130.1`, `openmpi/3.1.3`), the environment setup will fail and `openmpi` module will not be loaded:

```
$ module load cuda/10.0/10.0.130.1
$ module load openmpi/3.1.3
ERROR: loaded cuda module is not supported.
WARINING: openmpi/3.1.3 is supported only host version
$ module list
Currently Loaded Modulefiles:
  1) cuda/10.0/10.0.130.1
```

On the other hand, there are cases where CUDA-aware version of Open MPI is not necessary, such as when you want to use Open MPI just for parallelization by Horovod. In this case, you can use a newer version of Open MPI that does not support CUDA-aware functions by loading `openmpi` module first.

```
$ module load openmpi/3.1.3
$ module load cuda/10.0/10.0.130.1
module list
Currently Loaded Modulefiles:
  1) openmpi/3.1.3          2) cuda/10.0/10.0.130.1
```

!!! note
    The functions of CUDA-aware versions of Open MPI can be found on the Open MPI site:
    [FAQ: Running CUDA-aware Open MPI](https://www.open-mpi.org/faq/?category=runcuda)

## Q. I want to know how ABCI job execution environment is congested

ABCI operates a web service that visualizes job congestion status as well as utilization of compute nodes, power consumption of the whole datacenter, PUE, cooling facility, etc.
The service runs on an internal server, named `vws1`, on 3000/tcp port.
You can access it by following the procedure below.

You need to set up SSH tunnel.
The following example, written in `$HOME/.ssh/config` on your PC, sets up the SSH tunnel connection to ABCI internal servers through as.abci.ai by using ProxyCommand.
Please also refer to the procedure in [Login using an SSH Client::General method](./02.md#general-method) in ABCI System User Environment.

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

[This page](tips/datasets.md) may be useful.


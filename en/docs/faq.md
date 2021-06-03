# FAQ

## Q. If I enter Ctrl+S during interactive jobs, I cannot enter keys after that

This is because standard terminal emulators for macOS, Windows, and Linux have Ctrl+S/Ctrl+Q flow control enabled by default. To disable it, execute the following in the terminal emulator of the local PC:

```shell
$ stty -ixon
```

Executing while logged in to the interactive node has the same effect.

## Q. The group area is consumed more than the actual size

Generally, any file systems have their own block size, and even the smallest file consumes the capacity of the block size.

ABCI sets the block size of the group area 1,2,3 to 128 KB and the block size of the home area and group area to 4 KB. For this reason, if a large number of small files are created in the group area 1,2,3 , usage efficiency will be reduced. For example, if you want to create a file that is less than 4KB in the group area, you need about 32 times the capacity of the home area.

## Q. Singularity cannot use container registries that require authentication

SingularityPRO has a function equivalent to ``docker login`` that provides authentication information with environment variables.

```shell
[username@es1 ~]$ export SINGULARITY_DOCKER_USERNAME='username'
[username@es1 ~]$ export SINGULARITY_DOCKER_PASSWORD='password'
[username@es1 ~]$ singularity pull docker://myregistry.azurecr.io/namespace/repo_name:repo_tag
```

For more information on SingularityPRO authentication, see below.

* [SingularityPRO 3.7 User Guide](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/)
    * [Making use of private images from Private Registries](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/singularity_and_docker.html?highlight=support%20docker%20oci#making-use-of-private-images-from-private-registries)

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
module load singularitypro

NGC_HOME=$HOME/ngc
singularity exec $NGC_HOME/ubuntu-18.04.simg $NGC_HOME/ngc $@
```

## Q. I want to assign multiple compute nodes and have each compute node perform different processing

If you give `-l rt_F=N` or `-l rt_AF=N` option to `qrsh` or `qsub`, you can assign N compute nodes. You can also use MPI if you want to perform different processing on each assigned compute node.

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

ABCI offers CUDA-aware and CUDA non-aware versions of Open MPI, and you can check the availability provided by [Open MPI](mpi.md#open-mpi).

The Environment Modules provided by ABCI will attempt to configure CUDA-aware Open MPI environment when loading `openmpi` module only if `cuda` module has been loaded beforehand.

For the combination where CUDA-aware MPI is provided (`cuda/10.0/10.0.130.1`, `openmpi/2.1.6`), therefore, the environment settings will succeed:

```
$ module load cuda/10.0/10.0.130.1
$ module load openmpi/2.1.6
$ module list
Currently Loaded Modulefiles:
  1) cuda/10.0/10.0.130.1   2) openmpi/2.1.6
```

For the combination where CUDA-aware MPI is not provided (`cuda/9.1/9.1.85.3`, `openmpi/3.1.6`), the environment setup will fail and `openmpi` module will not be loaded:

```
$ module load cuda/9.1/9.1.85.3
$ module load openmpi/3.1.6
ERROR: loaded cuda module is not supported.
WARNING: openmpi/3.1.6 cannot be loaded due to missing prereq.
HINT: at least one of the following modules must be loaded first: cuda/9.2/9.2.88.1 cuda/9.2/9.2.148.1 cuda/10.0/10.0.130.1 cuda/10.1/10.1.243 cuda/10.2/10.2.89 cuda/11.0/11.0.3 cuda/11.1/11.1.1 cuda/11.2/11.2.2
$ module list
Currently Loaded Modulefiles:
  1) cuda/9.1/9.1.85.3
```

On the other hand, there are cases where CUDA-aware version of Open MPI is not necessary, such as when you want to use Open MPI just for parallelization by Horovod. In this case, you can use a newer version of Open MPI that does not support CUDA-aware functions by loading `openmpi` module first.

```
$ module load openmpi/3.1.6
$ module load cuda/9.1/9.1.85.3
module list
Currently Loaded Modulefiles:
  1) openmpi/3.1.6       2) cuda/9.1/9.1.85.3
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

Please see [this page](tips/datasets.md).

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

## Q. What are the new group area and data migration? {#q-what-are-the-new-group-area-and-data-migration}

In FY2021, we expanded the storage system. Refer to [Storage Systems](https://docs.abci.ai/en/01/#storage-systems) for details.
As the storage system is expanded, the configuration of the group area will be changed.
All the data in the existing group area used in FY2020 are going to be migrated into a new group area in FY2021.

The existing group area (The **Old Area**) will not be accessible from the coming new computing resources (The Compute Node (A)).
Therefore we need to create a new group area (The **New Area**), which is accessible from the Compute Node (A), and migrate all the data stored in the **Old Area** to the **New Area**.
The data copy is managed by the operating team, so the users do not have to take care of the copy process.

A user group who are using the **Old Area** `/groups[1-2]/gAA50NNN` had been also allocated the **New Area** at `/groups/gAA50NNN`.
Both the **Old and New Area** are accessible from all the interactive nodes and all the existing computing nodes (The Compute Node (V)). 

For the groups newly created in FY2021, only **New Area** will be allocated, so it is not a target of data migration. As results, it is not affected by data migration.  

### Basic Strategy

* The ABCI operating team will copy all the files in the **Old Area** to the **New Area** behind the scene. It will take one year to finish the copy process for all the user groups.
* The users can keep using the **Old Area** during the data migration, we would like to ask the users to use the **New Area** as much as possible in order to reduce the amount of the data to be migrated.
* When the copying process finishes, the operating team will switch the reference from the **Old Area** to the **New Area** by changing the symbolic link.

### The new area /groups/gAA50NNN

* The files in the **Old Area** will be copied to the **New Area** `/groups/gAA50NNN/migrated_from_SFA_GPFS/`. Note that the users cannot access the copied data under that directory until the migration finishes.
* The area other than that directory in the **New Area** can be freely used.
* Disk usage will increase as data is copied. For this reason, the limit of the storage usage for the **New Area** is set to be twice the quota value, which is the group disk quantity value applied in the ABCI User Portal. This is a temporal treatment. After the migration,  the limit of the storage usage is set to the same value as the quota value in the ABCI User Portal, after a grace period.

### The old area /groups[1-2]/gAA50NNN

#### During the data migration

* During the data migration, the users can read, write and delete files in the **Old Area**.
* In order to reduce the amount of the data to be moved, please do not put new files in the **Old Area** as much as possible.
* Consider deleting unnecessary files in the **Old Area** as much as possible.
* As usual, the quota value applied in the ABCI User Portal is set as the the limit of the storage usage of the **Old Area**. As usual, you can increase or decrease the quota value by applying a new quota value in the ABCI User Portal.

#### At the end of the data migration

* At the end of the data migration, there will be a period of several days where you cannot access the **Old area** `/groups[1-2]/gAA50NNN` and the **New area** `/groups/gAA50NNN/migrated_from_SFA_GPFS/`.
* During that period, you can read, write and delete files in the **New Area**.
* After the period, the copied data in **New Area** will become available. The reference to the **Old Area** will be redirected to the copied directory.


#### After the data migration is completed

* You can access the migrated data in the **New Area** with the same path `/groups[1-2]/gAA50NNN` as before. It is achieved by changing the symbolic link.
* The files in the **Old Area** are copied to `/groups/gAA50NNN/migrate_from_SFA_GPFS/` in the **New Area**.
* You cannot access `/groups[1-2]/gAA50NNN` in the **Old Area**.


## Q. What is the difference between Compute Node (A) and Compute Node (V) {# q-what-is-the-difference-between-compute-node-A-and-compute-node-V}

ABCI was upgraded to ABCI 2.0 in May 2021.
In addition to the previously provided Compute Node (V) with NVIDIA V100, the Compute Node (A) with NVIDIA A100 is currently available.

This section describes the differences between the Compute Node (A) and the Compute Node (V), and points to note when using the Compute Node (A).

### Resource type name

The Resource type name is different between the Compute Node (A) and the Compute Node (V).

The following Resource types are available for Compute Node (A).
Specify the resource type name you want to use when submitting a job.

Resource type | Resource type name | Assigned physical CPU core | Number of assigned GPU | Memory (GiB) |
|:-|:-|:-|:-|:-|
| Full | rt_AF | 72 | 8 | 480 |
AG.small | rt_AG.small | 9 | 1 | 60 |

For more detailed Resource types, see Available Resource types (job-execution.md#available-resource-types).


### Fees

Charges are different for Compute Node (A) and Compute Node (V).

The table below shows the prices for batch and interactive jobs on Compute Node (A).

| Resource type name | Fee (point/hour) |
|:-|:-|
| rt_AF | 3.0 |
| rt_AG.small | 0.5 |

The table below shows the reserving charges for Compute Node (A).

| Resource type name | Fee (points/day) |
|:-|:-|
| rt_AF | 108 |
| rt_AG.small | N/A |

See [ABCI USAGE FEES](https://abci.ai/en/how_to_use/tariffs.html) for pricing details.


### Operating System

The Compute Node (A) and the Compute Node (V) have different Operating Systems. 

| Node | Operating System |
|:-|:-|
| Compute Node (A) | Red Hat Enterprise Linux 8.2 |
| Compute Node (V) | CentOS Linux 7.5 |

Since the versions of libraries such as kernel and glibc are different, the operation is not guaranteed even if the program built for the Compute Node (V) is run on the Compute Node (A).

Please rebuild the program for the Compute Node (A) using the Compute Node (A) or the Interactive Node (A) described later.


### CUDA Version

The NVIDIA A100 on the compute node (A) supports Compute Capability 8.0.

CUDA 10 and earlier does not support this Compute Capability 8.0. Therefore, Compute Node (A) should use CUDA 11 with Compute Capability 8.0 support.


### Interactive Node (A)

ABCI 2.0 provides the Interactive Node (A) for program development for the Compute Node (A).

The Interactive Node (A) has the same software configuration as the Compute Node (A).
Therefore, the program built on the Interactive Node (A) does not guarantee the operation on the Compute Node (V).

For more information on Interactive Node (A), see [Interactive Node](system-overview.md#interactive-node).


### Group area

The old area (`/groups[1-2]/gAA50NNN`) cannot be accessed from the Compute Node (A).

If you want to use the file in the old area in the Compute Node (A), the user needs to copy the file to the home area or the new area (`/groups/gAA50NNN`).
When copying files from the old area, use the Interactive Node (A), Interactive Node (V), or Compute Node (V).

Since April 2021, we have been working on migrating files in the old area to the new area.
After this migration work is completed, the files in the old area will be accessible from the Compute Node (A) with the same path `/groups[1-2]/gAA50NNN` as before.

For information of Group area data migration, see the FAQ [Q. What are the new group area and data migration?](faq.md#q-what-are-the-new-group-area-and-data-migration).


## Q. How to use ABCI 1.0 Environment Modules

ABCI was upgraded in May 2021.
Due to the upgrade, the Environment Modules as of FY2020 (The **ABCI 1.0 Environment Modules**) is installed in the `/apps/modules-abci-1.0` directory.
If you want to use the ABCI 1.0 Environment Modules, set the `MODULE_HOME` environment variable as follows and load the configuration file.

Please not that the ABCI 1.0 Environment Modules is not eligible for the ABCI System support.

sh, bash:

```
export MODULE_HOME=/apps/modules-abci-1.0
. ${MODULE_HOME}/etc/profile.d/modules.sh
```

ch, tcsh:

```
setenv MODULE_HOME /apps/modules-abci-1.0
source ${MODULE_HOME}/etc/profile.d/modules.csh
```


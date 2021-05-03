# Storage

## Home Area

Home area is the disk area of the Lustre file system shared by interactive and compute nodes, and is available to all ABCI users by default. The disk quota is limited to 200GiB.

!!! warning
    In Home area, there is an upper limit on the number of files that can be created under one directory.
    The upper limit depends on the length of the file names located in the directory and is approximately 4M to 12M files.
    If an attempt is made to create a file that exceeds the limit, an error message "No spcae left on device" is output and the file creation fails.

### [Advanced Option] File Striping

Home area is provided by the Lustre file system. The Lustre file system distributes and stores file data onto multiple disks. On home area, you can choose two distribution methods which are Round-Robin (default) and Striping.

#### How to Set Up File Striping

```
$ lfs setstripe  [options] <dirname | filename>
```

| Option | Description |
|:--:|:---|
| -S | Sets a stripe size. -S #k, -S #m or -S #g option sets the size to KiB, MiB or GiB respectively. |
| -i | Specifies the start OST index to which a file is written. If -1 is set, the start OST is randomly selected. |
| -c | Sets a stripe count. If -1 is set, all available OSTs are written. |

!!! Tips
    To display  OST index, use the ```lfs df``` or ```lfs osts``` command

Example) Set a stripe pattern #1. (Creating a new file with a specific stripe pattern.)

```
[username@es1 work]$ lfs setstripe -S 1m -i 10 -c 4 stripe-file
[username@es1 work]$ ls
stripe-file
```

Example) Set a stripe pattern #2. (Setting up a stripe pattern to a directory.)

```
[username@es1 work]$ mkdir stripe-dir
[username@es1 work]$ lfs setstripe -S 1m -i 10 -c 4 stripe-dir
```

#### How to Display File Striping Settings

To display the stripe pattern of a specified file or directory, use the lfs getstripe command.

```
$ lfs getstripe <dirname | filename>
```

Example) Display stripe settings #1. (Displaying the stripe pattern of a file.)

```
[username@es1 work]$ lfs getstripe stripe-file
stripe-file
lmm_stripe_count:  4
lmm_stripe_size:   1048576
lmm_pattern:       1
lmm_layout_gen:    0
lmm_stripe_offset: 10
        obdidx           objid           objid           group
            10         3024641       0x2e2701                0
            11         3026034       0x2e2c72                0
            12         3021952       0x2e1c80                0
            13         3019616       0x2e1360                0
```

Example) Display stripe settings #2. (Displaying the stripe pattern of a directory.)

```
[username@es1 work]$ lfs getstripe stripe-dir
stripe-dir
stripe_count:  4 stripe_size:   1048576 stripe_offset: 10
```

## Group Area

Group area is the disk area of the Lustre file system shared by interactive and compute nodes. Group area 1,2,3 is the GPFS file system disk space shared by the interactive nodes and each compute node (V).
To use Group area, "Usage Manager" of the group needs to apply "Add group disk" via [ABCI User Portal](https://portal.abci.ai/user/). Regarding how to add group disk, please refer to [Disk Addition Request](https://docs.abci.ai/portal/en/03/#352-disk-addition-request) in the [ABCI Portal Guide](https://docs.abci.ai/portal/en/).

To find the path to your group area, use the `show_quota` command. For details, see [Checking Disk Quota](02.md#checking-disk-quota).

## Local Storage

In ABCI System, a 1.6 TB NVMe SSD x1 is installed into each compute node (V), a 2.0 TB NVMe SSD x2 are installed into each compute node (A) and a 1.9 TB SATA 3.0 SSD x1 is installed into each memory-intensive node. There are two ways to utilize these storages as follows:

* Using as a local scratch of a node (*Using as a local scratch*, *Using as a persistent local scratch (Reserved only)*).
* Using as a distributed shared file system, which consists of multiple NVMe storages in multiple compute nodes (*Using as a BeeOND storage*).

The follwing table shows how to utilize local storage by two types of node.

|  | compute node | memory-intensive node |
|:---|:--:|:--:|
| using as a Local scratch | ok | ok |
| using as a BeeOND storage | ok | - |
| using as a Persistent Local scratch (Reserved only) | ok | - |

### Using as a local scratch

You can use local storages attached to compute or memory-intensive nodes on which your jobs are running as temporal local scratch without specifying any additional options.
Note that the amount of the local storage you can use is determined by "Resource type". For more detail on "Resource type", please refer to [Job Execution Resource](03.md#job-execution-resource).
The local storage path is different for each job and you can access to local storage by using [environment variables](03.md#environment-variables) `SGE_LOCALDIR`.

Example) sample of job script (use_local_storage.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

echo test1 > $SGE_LOCALDIR/foo.txt
echo test2 > $SGE_LOCALDIR/bar.txt
cp -rp $SGE_LOCALDIR/foo.txt $HOME/test/foo.txt
```

Example) Submitting a job

```
[username@es1 ~]$ qsub -g grpname use_local_storage.sh
```

Example) Status after execution of use_local_storage.sh

```
[username@es1 ~]$ ls $HOME/test/
foo.txt    <- The file remain only when it is copied explicitly in script.
```

!!! warning
    The file stored under `$SGE_LOCALDIR` directory is removed when job finished. The required files need to be moved to Home area or Group area in job script using `cp` command.

### Using as a persistent local scratch (Reserved only)

The Reserved service allows the local storage of the compute node to have persistent space that is not deleted on a per-job basis. This space is created when the Reserved service starts and is removed when the Reserved service ends.

Example) sample of job script (use_reserved_storage_write.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

echo test1 > $SGE_ARDIR/foo.txt
echo test2 > $SGE_ARDIR/bar.txt
```

Example) Submitting a job

```
[username@es1 ~]$ qsub -g grpname -ar 12345 use_reserved_storage_write.sh
```

Example) sample of job script (use_reserved_storage_read.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

cat $SGE_ARDIR/foo.txt
cat $SGE_ARDIR/bar.txt
```

Example) Submitting a job
```
[username@es1 ~]$ qsub -g grpname -ar 12345 use_reserved_storage_read.sh
```

!!! warning
    The files created under `$SGE_ARDIR` will be deleted when the Reserved service is finished, so the necessary files should be copied to the home area or group area using `cp` command etc.

!!! warning
    The compute node (A) contains two NVMe SSDs with separate local storage for local scratch and persistent local scratch (Reserved only).
    Since the compute node (V) contains only one NVMe SSD, the local storage for local scratch usage and the local storage for persistent local scratch (Reserved only) usage are the same storage.
    Pay attention to usage when using persistent local scratch (Reserved only).

### Using as a BeeOND storage

By using the BeeGFS On Demand (BeeOND), you can aggregate local storages attached to compute nodes on which your job is running to use as a temporal distributed shared file system.
To use BeeOND, you need to submit job with `-l USE_BEEOND=1` option.
And you need to specify `-l rt_F` or `-l rt_AF` option in this case, because node must be exclusively allocated to job.

The created distributed shared file system area can be accessed using [Environment Variables](03.md#environment-variables).

Example) sample of job script (use_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=2
#$-l USE_BEEOND=1
#$-cwd

echo test1 > $SGE_BEEONDDIR/foo.txt
echo test2 > $SGE_BEEONDDIR/bar.txt
cp -rp $SGE_BEEONDDIR/foo.txt $HOME/test/foo.txt
```

Example) Submitting a job

```
[username@es1 ~]$ qsub -g grpname use_beeond.sh
```

Example) Status after execution of use_beeond.sh

```
[username@es1 ~]$ ls $HOME/test/
foo.txt    <- The file remain only when it is copied explicitly in script.
```

!!! warning
    The file stored under `$SGE_BEEONDDIR` directory is removed when job finished. The required files need to be moved to Home area or Group area in job script using `cp` command.

!!! warning
    The compute node (A) contains two NVMe SSDs with separate local storage for local scratch and BeeOND storage.
    Since the compute node (V) has only one NVMe SSD, the local storage for local scratch usage and the local storage for BeeOND storage usage are the same storage.

#### [Advanced Option] Configure BeeOND Servers

A BeeOND filesystem partition consists of two kinds of services running on compute nodes: one is storage service which stores files, and the other is metadata service which stores file matadata.  Each service runs on compute nodes.  We refer to a compute node which runs storage service as a storage server and a compute node which runs metadata service as a metadata server.  Users can specify number of storage servers and metadata servers.

The default values for counts of metadata server and storage server are as follows.

| Parameter | Default |
|:--:|---:|
| Count of metadata servers | 1 |
| Count of storage servers | Number of nodes requested by a job |

To change the counts, define following environment variables.  These environment variables have to be defined at job submission, and changing in job script takes no effect.  When counts of servers are less than the number of requested nodes, servers are lexicographically selected by their names from assigned compute nodes.

| Environment Variable | Description |
|:---|:---|
| BEEOND_METADATA_SERVER | Count of metadata servers in integer |
| BEEOND_STORAGE_SERVER | Count of storage servers in integer |

The following example create a BeeOND partition with two metadata servers and four storage servers.  `beegfs-df` is used to see the configuration.

Example) sample of job script (use_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=8
#$-l USE_BEEOND=1
#$-v BEEOND_METADATA_SERVER=2
#$-v BEEOND_STORAGE_SERVER=4
#$-cwd

beegfs-df -p /beeond
```

Example output
```
METADATA SERVERS:
TargetID   Cap. Pool        Total         Free    %      ITotal       IFree    %
========   =========        =====         ====    =      ======       =====    =
       1      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       2      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%

STORAGE TARGETS:
TargetID   Cap. Pool        Total         Free    %      ITotal       IFree    %
========   =========        =====         ====    =      ======       =====    =
       1      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       2      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       3      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       4      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
```

#### [Advanced Option] File Striping

Files are split into small chunks and stored in multiple storage servers in a BeeOND partition.  Users can change file striping configuration of BeeOND.

The default configuration of the file striping is as follows.

| Parameter | Default | Description |
|:--:|---:|:---|
| Stripe size | 512 KB | File chunk size |
| Stripe count | 4 | Number of storage servers that store chunks of a file |

Users can configure file striping per-file or per-directory using `beegfs-ctl` command.

The following example sets file striping configuration of `/beeond/data` directory as 8 stripe count and 4MB stripe size.

Example) sample of job script (use_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=8
#$-l USE_BEEOND=1
#$-cwd

BEEOND_DIR=/beeond/data
mkdir ${BEEOND_DIR}
beegfs-ctl --setpattern --numtargets=8 --chunksize=4M --mount=/beeond ${BEEOND_DIR}
beegfs-ctl --mount=/beeond --getentryinfo ${BEEOND_DIR}
```

Output example

```
New chunksize: 4194304
New number of storage targets: 8

EntryID: 0-5D36F5EC-1
Metadata node: gXXXX.abci.local [ID: 1]
Stripe pattern details:
+ Type: RAID0
+ Chunksize: 4M
+ Number of storage targets: desired: 8
+ Storage Pool: 1 (Default)
```

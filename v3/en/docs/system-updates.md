# System Updates

## 2025-12-26 {#2025-12-26}

A CSAD deactivation feature has been added to the cloud storage service. Accordingly, instructions for configuring bucket ACLs using a configuration file have been added.

## 2025-12-23 {#2025-12-23}

/local is now available for interactive nodes.

* Added a note to the notes section of "ABCI System Overview > Storage System > Interactive Nodes."
* Added a new section, ["Tips > Using /local for Interactive Nodes."](tips/interactive_node_local_fs.md)

We updated the following softwares.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | gcc(Compute Node)                      | 11.5.0         | 11.4.1         |
| Update | python(Interactive Node, Compute Node) | 3.9.25, 3.9.23 | 3.9.21, 3.9.21 |
| Update | ruby(Compute Node)                     | 3.0.7          | 3.0.4          |
| Update | java(Interactive Node)                 | 17.0.17        | 17.0.16        |
| Update | Go(Interactive Node, Compute Node)     | 1.25.3, 1.25.3 | 1.24.6, 1.24.4 |
| Update | DDN Lustre                             | 2.14.0_ddn230  | 2.14.0_ddn196  |
| Update | SingularityCE(Interactive Node)        | 4.3.5          | 4.1.5          |
| Update | SingularityPRO                         | 4.1.12         | 4.1.7          |

We increased the maximum number of files that can be opened simultaneously in the compute nodes as follows.

| Limit type | Previous value | Current value |
|:--|:--|:--|
| Soft limit | 16384 | 65536 |
| Hard limit | 16384 | 1048576 |

The maximum number of files that can be opened can be changed using the `ulimit -n {limit}` command after starting the job.

Example in the interactive job:

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1
[username@hnode001 ~]$ ulimit -n 131072
```

Example in the batch job:

```shell
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

ulimit -n 262144

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
./a.out
```

## 2025-12-15 {#2025-12-15}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | graphviz(Compute Node) | 2.44.0 | |

## 2025-12-11 {#2025-12-11}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | rclone | 1.71.0 | |

## 2025-12-03 {#2025-12-03}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | SingularityCE | 4.3.3 | |

## 2025-10-29 {#2025-10-29}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | s3fs-fuse | 1.95 | |

## 2025-10-28 {#2025-10-28}

Due to high job volume, we have temporarily adjusted the number of available nodes for reservation. We plan to revert them once the congestion eases.

| Item | Normal Setting Value | Setting Value for Peak Period | Notes |
|:--|:--|:--|:--|
| Minimum reservation days | 1 day | 1 day | No change. |
| Maximum reservation days | 60 days | 60 days | No change. |
| Maximum number of nodes can be reserved at once per ABCI group | 32 nodes | 32 nodes | No change. |
| Maximum number of nodes can be reserved at once per system | 640 nodes | 96 nodes | Temporal value for peak period. |
| Minimum reserved nodes per reservation | 1 node | 1 node | No change. |
| Maximum reserved nodes per reservation | 32 nodes | 32 nodes | No change. |
| Maximum reserved node time per reservation | 10,752 nodes x hours | 5,376 nodes x hours |  Temporal value for peak period. For 32 nodes, corresponds to 24 hours x 7 days at a maximum. |

## 2025-10-22 {#2025-10-22}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | openjdk | 25.0.0 | |

## 2025-10-21 {#2025-10-21}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | nccl | 2.27.7-1 (for CUDA 13)<br>2.28.3-1 (for CUDA 13) | |

## 2025-10-15 {#2025-10-15}

We installed the following softwares.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 13.0.1 | |
| Add | cudnn | 9.12.0 (for CUDA 13)<br>9.13.0 (for CUDA 12, 13) | |

## 2025-09-29 {#2025-09-29}

We installed the following softwares.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | go | 1.25.1 | |

## 2025-09-24 {#2025-09-24}

We installed `qgdel`. This allows a Responsible Person or User Administrators to delete any job submitted by users belonging to the same group.

## 2025-09-18 {#2025-09-18}

We installed the following softwares.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cmake | 4.1.1 | |
| Add | nccl | 2.24.3-1<br>2.26.6-1<br>2.27.7-1<br>2.28.3-1 | |
| Add | cudnn | 9.6.0<br>9.7.1<br>9.8.0<br>9.9.0<br>9.10.2<br>9.11.1 | |

## 2025-08-26 {#2025-08-26}

We installed/updated the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 12.9.1 | |
| Add | cudnn | 9.12.0 | |
| Add | firefox(Compute Node) | 128.13.0-1 | |
| Update | python(Compute Node) | 3.9.21 | 3.9.18 |
| Update | ruby(Interactive Node) | 3.0.7 | 3.0.4 |
| Update | R(Interactive Node, Compute Node) | 4.5.1, 4.5.1 | 4.4.3, 4.4.1 |
| Update | java(Interactive Node, Compute Node) | 17.0.16, 17.0.16 | 11.0.22.0.7, 11.0.23.0.9 |

We granted the users access to NVIDIA GPU Performance Counters.

## 2025-08-08 {#2025-08-08}

We installed the following software.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | gcc | 13.2.0 | |

## 2025-08-05 {#2025-08-05}

We have added a description for ABCI Cloud Storage to the manual.

\* The open day of the service for the users is expected to be in late August. Please note that ABCI Cloud Storage is only available within ABCI (login nodes and compute nodes) and is not currently available from external sources (such as the Internet). We will provide further information on external use as soon as it becomes available.

## 2025-07-25 {#2025-07-25}

Disabled the usage of qalter command by the users.

## 2025-07-11 {#2025-07-11}

We installed `qgstat_l` which is the lightweight version of qgstat.

## 2025-06-20 {#2025-06-20}

We have added the following applications as Open OnDemand Interactive Apps.

* code-server
* Interactive Desktop(Xfce)

## 2025-04-15 {#2025-04-15}

We implemented the following features:

* SSH access control option when submitting jobs
    * With the addition of the `qsub` command option, you can now control SSH login to compute nodes while a job is running. For detailed, please refer to [Job Execution Options](job-execution.md#job-execution-options).
* Open OnDemand Job Composer

The following software has been updated:

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Lustre-client | 2.14.0_ddn196 | 2.14.0_ddn172 |
| Update | python (Interactive Node) | 3.9.21 | 3.9.18 |
| Add | python | 3.12.9 | |
| Add | python | 3.13.2 | |

The ABCI 2.0 home area (`/home-2.0`) that was mounted for data migration has been unmounted due to the end of provision.

## 2025-03-03 {#2025-03-03}

SingularityPRO is now available. For detailed usage instructions, please refer to [How to use SingularityPRO](containers.md#how-to-use-singularitypro).

## 2025-01-31 {#2025-01-31}

With the addition of the `qrstat --available=grpname` feature, you can now check the availability of node reservations. For more details on how to use this feature, please refer to [show the status of reservations](job-execution.md#show-the-status-of-reservations).

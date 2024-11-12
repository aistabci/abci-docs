# ABCI System Overview

## System Architecture

The ABCI system consists of 766 compute nodes with 6,128 NVIDIA H200 GPU accelerators and other computing resources, shared file systems and ABCI Cloud Storage with total capacity of approximately 74 PB, InfiniBand network that connects these elements at high speed, firewall, and so on. It also includes software to make the best use of these hardware. And, the ABCI system uses SINET5, the Science Information NETwork, to connect to the Internet at 100 Gbps.

## Computing Resources

Below is a list of the computational resources of the ABCI system.

| Node Type | Hostname | Description | # |
|:--|:--|:--|:--|
| Access Server | *as.v3.abci.ai* | SSH server for external access | 2 |
| Interactive Node | *int* | Login server, the frontend of the ABCI system | 5 |
| Compute Node | *hnode001*-*hnode108*[^1] | Server w/ NVIDIA H200 GPU accelerators | 108 |

[^1]: 766 compute nodes will become available around January 2025.

!!! note
    Due to operational and maintenance reasons, some computing resources may not be provided.

Among them, each interactive node and compute node are equipped with InfiniBand HDR and are connected to Storage Systems described later by InfiniBand switch group.
Also, each compute node is equipped with 8 port of InfiniBand NDR and the compute nodes are connected by InfiniBand switch.

Below are the details of these nodes.

### Interactive Node

The interactive node of ABCI system consists of HPE ProLiant DL380 Gen11.
The interactive node is equipped with two Intel Xeon Platinum 8468 Processors and approximately 1100 GB of main memory available.

The specifications of the interactive node are shown below:

| Item| Description | # |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8468 Processor 2.1 GHz, 48 Cores | 2 |
| Memory | 68 GB DDR5-4800 | 16 |
| SSD | SAS SSD 960 GB | 2 |
| SSD | NVMe SSD 3.2 TB | 4 |
| Interconnect | InfiniBand HDR (200 Gbps) | 2 |
| | 10GBASE-SR | 1 |
| | 1GBASE-SR | 1 |

Users can login to the interactive node, the frontend of the ABCI system, using SSH tunneling via the access server.

The interactive node allows users to interactively execute commands, and create and edit programs, submit jobs, and display job statuses. The interactive node does not have a GPU, but users can use it to develop programs for compute nodes.

Please refer to [Getting Started ABCI](getting-started.md) for details of login method and [Job Execution](job-execution.md) for details of job submission method.

!!! warning
    Do not run high-load tasks on the interactive node, because resources such as CPU and memory of the interactive node are shared by many users. If you want to perform high-load pre-processing and post-processing, please the compute nodes.
	Please note that if you run a high-load task on the interactive node, the system will forcibly terminate it.

### Compute Node

To execute the program for the compute node, submit the program to the job management system as a batch job or an interactive job. Interactive jobs allow you to compile and debug programs, and run interactive applications, visualization software and so on. For details, refer to [Job Execution](job-execution.md).

#### Compute Node

The compute node of ABCI system consists of HPE Cray XD670.
The compute node is equipped with two Intel Xeon Platinum 8558 Processors and eight NVIDIA H200 GPU accelerators. In the entire system, the total number of CPU cores is 36,768 cores, and the total number of GPUs is 6,128.

The specifications of the compute node are shown below:

| Item | Description | # |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8558 2.1GHz, 48cores | 2 |
| GPU | NVIDIA H200 SXM 141GB | 8 |
| Memory | 68 GB DDR5-5600 4400 MHz | 32 |
| SSD | NVMe SSD 7.68 TB | 2 |
| Interconnect | InfiniBand NDR (200 Gbps) | 8 |
| | InfiniBand HDR (200 Gbps) | 1 |
| | 10GBASE-SR | 1 |


## Storage Systems

The ABCI system has three storage systems for storing large amounts of data used for AI and Big Data applications, and these are used to provide shared file systems and ABCI Cloud Storage. The total effective capacity is up to approximately 74 PB.

| # | Storage System | Media | Usage |
|:--|:--|:--|:--|
| 1 | DDN ES400NVX2 | 61.44TB NVMe SSD x256 | Home area(/home) |
| 2 | DDN ES400NVX2 | 61.44TB NVMe SSD x1280 | Group area(/groups) |
| 3 | DDN ES400NVX2 | 30.72TB NVMe SSD x48 | ABCI Cloud Storage(/groups_s3) |

Below is a list of shared file systems and ABCI Cloud Storage provided by the ABCI system using the above storage systems.

| Usage | Mount point | Capacity | File system | Notes |
|:--|:--|:--|:--|:--|
| Home area | /home | 10 PB | Lustre |  |
| Group area | /groups | 63 PB | Lustre |  |
| ABCI Cloud Storage | /groups_s3 | 1 PB | Lustre |  |


Interactive nodes, and compute nodes mount the shared file systems, and users can access these file systems from common mount points.

Besides this, these nodes each have local storage that can be used as a local scratch area. The list is shown below.

| Node type | Mount point | Capacity | File system | Notes |
|:--|:--|:--|:--|:--|
| Interactive node | /local | 12 TB | XFS | |
| Compute node | /local1 | 7 TB | XFS |  |
|                 | /local2 | 7 TB | XFS | Includes BeeGFS |

## Software

The software available on the ABCI system is shown below. Details on the version information are scheduled to be released by January 2025.

| Category | Software | Interactive Node | Compute Node |
|:--|:--|:--|:--|
| OS | Rocky Linux | - | 9.4 |
| OS | Red Hat Enterprise Linux | 9.4 | - |
| Job Scheduler | Altair PBS Professional |  |  |
| Development Environment | CUDA Toolkit |  |  |
| | Intel oneAPI<br>(compilers and libraries) |  |  |
| | Python |  |  |
| | Ruby |  |  |
| | R |  |  |
| | Java |  |  |
| | Scala |  |  |
| | Perl |  |  |
| | Go |  |  |
| File System | DDN Lustre |  |  |
| | BeeOND |  |  |
| Object Storage | DDN S3 API |  |  |
| Container | Singularity-CE |  |  |
| MPI | Intel MPI |  |  |
| Library | cuDNN |  |  |
| | NCCL |  |  |
| | gdrcopy |  |  |
| | UCX |  |  |
| | Intel MKL |  |  |
| Utility | aws-cli |  |  |
| | s3fs-fuse |  |  |
| | rclone |  |  |


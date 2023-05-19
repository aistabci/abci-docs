# System Updates

## 2023-05-18

* Change the following limits for Spot and Reserved services on compute node(A) until the end of August 2023.<br>
However, depending on power and congestion conditions, it is possible to restore the settings before the end of August 2023.

| Service | Resource type name | Limitations | Previous upper limit | Changed upper limit |
|:--|:--|:--|:--|:--|
| Spot | rt_AF | Number of nodes available at the same time | 64 nodes | 90 nodes |
| Spot | rt_AF | Limit of elapsed time | 72 hours | 168 hours |
| Spot | rt_AF | Limit of node-time product | 288 nodes &middot; hours | 15120 nodes &middot; hours |
| Reserved | rt_AF | Maximum reserved nodes per reservation | 18 nodes | 30 nodes |

## 2023-05-16

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 12.1.1 | |
| Add | cudnn | 8.9.1 | |
| Add | nccl | 2.18.1-1 | |

## 2023-04-07 {#2023-04-07}

* Change the OS for compute nodes (V) and interactive nodes (V) from ***CentOS 7*** to ***Rocky Linux 8***.
    * This change requires you to recompile your programs or rebuild the Python virtual environments.

* The following tools are no longer supported on 2023/03/31.
  For modules that are no longer supported, please use container images or [previous ABCI Environment Modules](faq.md#q-how-to-use-previous-abci-environment-modules).
  For more information, please refer to the [Modules removed and alternatives](tips/modules-removed-and-alternatives.md).
    * Compilers：PGI
    * Development Tools：Lua
    * Deep Learning Frameworks：Caffe, Caffe2, Theano, Chainer
    * MPI：OpenMPI
    * Utilities：fuse-sshfs
    * Container Engine：Docker

* The maximum number of nodes that can be reserved at the same time for each ABCI Group was set.
    * The maximum number of the Compute Node (V) that can be reserved at the same time for each ABCI Group: 272 nodes
    * The maximum number of the Compute Node (A) that can be reserved at the same time for each ABCI Group: 30 nodes

* The inode quota limit for groups area was set.
    * The inode quota limit for groups area was set to 200 millions on April 2023.
    * For more information about checking the number of inodes, please refer to the [Checking Disk Quota](getting-started.md#checking-disk-quota).
 
* Updates the ABCI Singularity Endpoint.
    * With this update, you will need to recreate the access token.
    * With this update, the SingularityPRO Enterprise Plugin is available. As a result, the following overlapping functions have been removed.
        * list_singularity_images
        * revoke_singularity_token

* ABCI User Portal Updates
    * The following functions have been added to the Declaration regarding the applicability of specific categories.
        * The "Declaration Concerning Applicability to Specified Categories" for "Japanese Students, etc." can be applied for from the ABCI User Portal.
        * All users other than "Japanese Students, etc." and "Non-residents" can apply for the "Declaration Concerning Applicability to Specified Categories" from the ABCI User Portal. (Note: Users who have not applied for the "Declaration Concerning Applicability to Specified Categories" cannot use the ABCI.)
    * The following functions have been added for public key operations.
        * The ABCI group's responsible person/administrator can refer to the public key operation history of the ABCI group's users.
        * When a user in the ABCI group registers or deletes a public key, a notification e-mail will be sent to the responsible person/administrator of the ABCI group. By default, no notification is sent.

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Delete | gcc | 9.3.0 | |
| Delete | cuda | 9.0.176.1<br>9.1.85.3<br>9.2.148.1<br>10.0.130.1<br>10.1.243<br>11.7.0 | |
| Delete | cudnn | 7.0.5<br>7.1.4<br>7.2.1<br>7.3.1<br>7.4.2<br>7.5.1 | |
| Delete | nccl | 2.4.8-1 | |
| Update | intel | 2023.0.0 | 2022.2.1 |
| Update | intel-advisor | 2023.0 | 2022.3.1 |
| Update | intel-inspector | 2023.0 | 2022.3.1 |
| Update | intel-itac | 2021.8.0 | 2021.7.1 |
| Update | intel-mkl | 2023.0.0 | 2022.0.2 |
| Update | intel-vtune | 2023.0.0 | 2022.4.1 |
| Update | intel-mpi | 2021.8 | 2021.7 |
| Delete | pgi | 20.4 | |
| Update | cmake | 3.26.1 | 3.22.3 |
| Update | go | 1.20 | 1.18 |
| Update | julia | 1.8 | 1.6 |
| Update | openjdk | 1.8.0.362 | 1.8.0.332 |
| Update | openjdk | 11.0.18.0.10 | 11.0.15.0.9<br>11.0.15.0.10 |
| Update | openjdk | 17.0.6.0.10 | 17.0.3.0.7 |
| Update | R | 4.2.3 | 4.1.3 |
| Delete | openmpi | 4.0.5 | |
| Delete | openmpi | 4.1.3 | |
| Update | aws-cli | 2.11 | 2.4 |
| Delete | fuse-sshfs | 3.7.2 |  |
| Update | SingularityPRO | 3.9-10 | 3.9-9 |
| Update | Singularity Enterprise | 2.1.5 | 1.7.2 |
| Update | DDN Lustre | 2.12.8_ddn23 | 2.12.8_ddn10 |
| Update | Scality S3 Connector | 7.10.6.7 | 7.10.2.2 |
| Update | BeeOND | 7.3.3 | 7.2.3 |

## 2023-03-08

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 12.1.0 | |
| Add | cudnn | 8.8.1 | |
| Add | nccl | 2.17.1-1 | |

## 2023-02-03

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | intel | 2022.2.1 | 2022.0.2 |
| Update | intel-advisor | 2022.3.1 | 2022.0 |
| Update | intel-inspector | 2022.3.1 | 2022.0 |
| Update | intel-itac | 2021.7.1 | 2021.5.0 |
| Update | intel-mkl | 2022.0.2 | 2022.0.0 |
| Update | intel-vtune | 2022.4.1 | 2022.0.0 |
| Update | intel-mpi | 2021.7 | 2021.5 |

* Programs compiled with previous version of the Intel oneAPI may contain vulnerabilities, so please recompile with the newer version.
* `intel/2022.0.2` and earlier Intel oneAPI modules containing vulnerabilities have been deprecated.
Programs compiled with previous version of the Intel oneAPI modules, which was deprecated on Feb 6, may no longer run, so please recompile with the newer version.

## 2023-01-05

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.9-9 | 3.9-8 |

## 2022-12-23

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 12.0.0 | |
| Add | cudnn | 8.7.0 | |
| Add | nccl | 2.16.2-1 | |

## 2022-12-13

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.9-8 | 3.9-4 |
| Update | Singularity Endpoint | 1.7.2 | 1.2.5 |

## 2022-10-25

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 11.8.0 | |
| Add | cudnn | 8.6.0 | |
| Add | nccl | 2.15.5-1 | |

## 2022-09-02

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 11.7.1 | |
| Add | cudnn | 8.5.0 | |
| Add | nccl | 2.13.4-1<br>2.14.3-1 | |

## 2022-07-29

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | cudnn | 8.4.1 | 8.4.0 |

## 2022-06-24

* Changed the job execution option for change GPU Compute Mode to EXCLUSIVE_PROCESS mode from `-v GPU_COMPUTE_MODE=1` to `-v GPU_COMPUTE_MODE=3`. For more information, please refer to the [Changing GPU Compute Mode](gpu.md#changing-gpu-compute-mode).


## 2022-06-21

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add    | cuda    | 11.7.0 | |
| Update | nccl    | 2.12.12-1 | 2.12.10-1 |
| Update | Altair Grid Engine | 8.6.19_C121_1 | 8.6.17 |
| Update | openjdk | 1.8.0.332 | 1.8.0.322 |
| Update | openjdk | 11.0.15.0.9(Compute Node (V))<br>11.0.15.0.10(Compute Node (A)) | 11.0.14.1.1 |
| Update | openjdk | 17.0.3.0.7 | 17.0.2.0.8 |
| Update | DDN Lustre | 2.12.8_ddn10 | 2.12.6_ddn58-1 |

* Altair Grid Engine has been updated. The job queue and job reservations are not preserved. Please resubmit your batch job(s). Please recreate your reservation(s). 
* Some of [Known Issues](known-issues.md) have been resolved in this update.
* Reinstalled R (4.1.3) with --enable-R-shlib enabled.
* The update of Singularity Endpoint has been postponed.

## 2022-05-26 

* Product names documented in this User Guide have been renamed to reflect the acquisition of Univa by Altair.

| Current | Previous |
|:--|:--|
| Altair Grid Engine | Univa Grid Engine |
| AGE | UGE |

## 2022-05-10

| Add / Update / Delete | Software | Version   | Previous version |
| --------------------- | -------- | --------- | ---------------- |
| Add                   | gcc      | 9.3.0     |                  |
| Add                   | cudnn    | 8.4.0     |                  |
| Update                | nccl     | 2.12.10-1 | 2.12.7-1         |

* Deleted `gcc/9.3.0` module has been restored to the current environment modules.

## 2022-04-06

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Scality S3 Connector | 8.5.2.2 | 7.4.9.3 |
| Update | SingularityPRO | 3.9-4 | 3.7-4 |
| Update | DDN Lustre (Compute node (V)) | 2.12.6_ddn58-1 | 2.12.5_ddn13-1 |
| Update | OFED (Compute node (V)) | 5.2-1.0.4.0 | 5.0-2.1.8.0 |
| Update | gcc | 11.2.0 | 9.3.0 |
| Delete | gcc | 7.4.0 | |
| Update | intel | 2022.0.2 | 2020.4.304 |
| Delete | nvhpc | 20.11<br>21.2 | |
| Delete | openjdk | 1.7.0.171 | |
| Update | openjdk | 1.8.0.322 | 1.8.0.242 |
| Update | openjdk | 11.0.14.1.1 | 11.0.6.10 |
| Update | openjdk | 17.0.2.0.8 | 15.0.2.0.7 |
| Delete | lua | 5.3.6<br>5.4.2 | |
| Delete | julia | 1.0 | |
| Update | julia | 1.6.6 | 1.5 |
| Update | intel-advisor | 2022.0 | 2020.3 |
| Update | intel-inspector | 2022.0 | 2020.3 |
| Update | intel-itac | 2021.5.0 | 2020.0.3 |
| Update | intel-mkl | 2022.0.0 | 2020.0.4 |
| Update | intel-vtune | 2022.0.0 | 2020.3 |
| Add | python | 3.10.4 | |
| Update | python | 3.7.13 | 3.7.10 |
| Update | python | 3.8.13 | 3.8.7 |
| Delete | python | 3.6.12 | |
| Update | R | 4.1.3 | 4.0.4 |
| Delete | cuda | 8.0.61.2<br>9.2.88.1<br>11.4.1<br>11.6.0 | |
| Update | cuda | 11.4.4 | 11.4.1 |
| Update | cuda | 11.5.2 | 11.5.1 |
| Update | cuda | 11.6.2 | 11.6.0 |
| Delete | cudnn | 5.1.10<br>6.0.21<br>8.2.0<br>8.2.1<br>8.2.2 | |
| Update | cudnn | 8.3.3 | 8.3.2 |
| Delete | nccl | 1.3.5-1<br>2.1.15-1<br>2.2.13-1<br>2.3.7-1<br>2.9.6-1<br> | |
| Add | nccl | 2.12.7-1 | |
| Update | gdrcopy | 2.3 | 2.0 |
| Update | intel-mpi | 2021.5 | 2019.9 |
| Add | openmpi | 4.1.3 | |
| Delete | openmpi | 2.1.6 | |
| Delete | openmpi | 3.1.6 | |
| Update | aws-cli | 2.4 | 2.1 |
| Update | fuse-sshfs | 3.7.2 | 3.7.1 |
| Update | f3fs-fuse | 1.91 | 1.87 |
| Delete | sregistory-cli | 0.2.36 | |
| Update | NVIDIA Tesla Driver | [510.47.03](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-517-47-03/index.html) | 470.57.02 |

* Maximum reserved node time per reservation of compute node (V) is changed in the Reserved Service from 12,288 to 13,056.
* Maximum reserved nodes per reservation of compute node (A) is changed in the Reserved Service from 16 to 18.
* Maximum reserved node time per reservation of compute node (A) is changed in the Reserved Service from 6,144 to 6,912.
* The installation of Singularity Enterprise CLI has been postponed.
* One of [known issues](known-issues.md) has been resolved in this update.
* We have reconfigured the Environment Modules. If you would like to use modules prior to FY2021, please refer to the FAQ ([How to use previous ABCI Environment Modules](faq.md#q-how-to-use-previous-abci-environment-modules)).
* Due to the reconfiguration of the Environment Modules, some modules have been removed. For more information, please refer to the [Modules removed and alternatives](tips/modules-removed-and-alternatives.md).


## 2022-03-03 

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Delete | hadoop | 3.3 | |
| Delete | spark | 3.0 | |
| Update | DDN Lustre (Compute Node (A)) | 2.12.6_ddn58-1 | 2.12.5_ddn13-1 |
| Update | OFED (Compute Node (A)) | 5.2-1.0.4.0 | 5.1-0.6.6.0 |

* One of [known issues](known-issues.md) has been resolved in this update.

## 2022-01-27

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | CUDA  | 11.3.1<br>11.4.1<br>11.4.2<br>11.5.1<br>11.6.0 | |
| Add | cuDNN | 8.2.2<br>8.2.4<br>8.3.2 | |
| Add | NCCL  | 2.10.3-1<br>2.11.4-1 | |

## 2021-12-15

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | OFED | 5.1-0.6.6.0 | 5.0-2.1.8.0 |
| Update | Scality S3 Connector | 7.4.9.3 | 7.4.8.4 |
| Update | NVIDIA Tesla Driver | [470.57.02](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-470-57-02/index.html) | 460.32.03 |
| Add | ffmpeg | 3.4.9<br>4.2.5 |  |

* Maximum reserved nodes per reservation of compute node (V) has been changed in the Reserved Service from 32 to 34.
* With the addition of the Global Scratch Area, we added [Global scratch area](storage.md#scratch-area) section.

## 2021-08-12

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | BeeOND | 7.2.3 | 7.2.1 |
| Update | DDN Lustre | 2.12.5\_ddn13-1 | 2.12.6\_ddn13-1 |

## 2021-07-06

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.7-4 | 3.7-1 |

## 2021-06-30

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [8.2.1](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-821) | |
| Add | NCCL | [2.9.9-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-9-9.html) | |

## 2021-05-10

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [8.2.0](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-820) | |
| Add | NCCL | [2.9.6-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-9-6.html) | |

* The documentation has been revised with the addition of a compute node (A) with NVIDIA A100.

## 2021-04-07

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | NVIDIA Tesla Driver | [460.32.03](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-460-32-03/index.html) | 440.33.01 |
| Update | OFED | 5.0-2.1.8.0 | 4.4-1.0.0.0 |
| Update | Univa Grid Engine | 8.6.17 | 8.6.6 |
| Update | SingularityPRO | 3.7-1 | 3.5-6 |
| Update | BeeOND | 7.2.1 | 7.2 |
| Update | Docker | 19.03.15 | 17.12.0 |
| Update | Scality S3 Connector | 7.4.8.1 | 7.4.8 |
| Add | gcc | 9.3.0 | |
| Add | pgi | 20.4 | |
| Add | nvhpc | 20.11<br>21.2 | |
| Add | cmake | 3.19 | |
| Add | go | 1.15 | |
| Add | julia | 1.5 | |
| Add | lua | 5.3.6<br>5.4.2 | |
| Add | python | 2.7.18<br>3.6.12<br>3.7.10<br>3.8.7 | |
| Add | R | 4.0.4 | |
| Add | CUDA | 11.0.3<br>11.1.1<br>11.2.2 | |
| Add | cuDNN | [8.1.1](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-811) | |
| Add | NCCL | [2.8.4-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-8-4.html) | |
| Add | openmpi | 4.0.5 | |
| Add | mvapich2-gdr | 2.3.5 | |
| Add | mvapich2 | 2.3.5 | |
| Add | hadoop | 3.3 | |
| Add | spark | 3.0 | |
| Add | aws-cli | 2.1 | |
| Add | fuse-sshfs | 3.7.1 | |
| Add | s3fs-fuse | 1.87 | |
| Add | sregistry-cli | 0.2.36 | |
| Delete | intel | 2017.8.262<br>2018.5.274<br>2019.5.281 | |
| Delete | pgi | 17.10<br>18.10<br>19.1<br>19.10<br>20.1 | |
| Delete | nvhpc | 20.9 | |
| Delete | cmake | 3.16<br>3.17 | |
| Delete | go | 1.12<br>1.13 | |
| Delete | intel-advisor | 2017.5<br>2018.4<br>2019.5 | |
| Delete | intel-inspector | 2017.4<br>2018.4<br>2019.5 | |
| Delete | intel-itac | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Delete | intel-mkl | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Delete | intel-vtune | 2017.6<br>2018.4<br>2019.6 | |
| Delete | julia | 1.3<br>1.4 | |
| Delete | python | 2.7.15<br>3.4.8<br>3.5.5<br>3.7.6 | |
| Delete | R | 3.5.0<br>3.6.3 | |
| Delete | cuda | 10.0.130 | |
| Delete | cudnn | 7.1.3<br>7.5.0<br>7.6.0<br>7.6.1<br>7.6.2<br>7.6.3<br>7.6.4<br>8.0.2 | |
| Delete | nccl | 2.3.4-1<br>2.3.5-2<br>2.4.2-1<br>2.4.7-1<br>2.8.3-1 | |
| Delete | intel-mpi | 2017.4<br>2018.4<br>2019.5 | |
| Delete | openmpi | 4.0.3 | |
| Delete | mvapich2-gdr | 2.3.3<br>2.3.4 | |
| Delete | mvapich2 | 2.3.3<br>2.3.4 | |
| Delete | hadoop | 2.9<br>2.10<br>3.1 | |
| Delete | singularity | 2.6.1 | |
| Delete | spark | 2.3<br>2.4 | |
| Delete | aws-cli | 1.16.194<br>1.18<br>2.0 | |
| Delete | fuse-sshfs | 2.10 | |
| Delete | s3fs-fuse | 1.85 | |
| Delete | sregistry-cli | 0.2.31 | |

## 2021-03-13

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.5-6 | 3.5-4 |
| Update | DDN Lustre | 2.12.6\_ddn13-1 | 2.10.7\_ddn14-1 |

## 2020-12-15

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | go | 1.14 | |
| Add | intel | 2020.4.304 | |
| Add | intel-advisor | 2020.3 | |
| Add | intel-inspector | 2020.3 | |
| Add | intel-itac | 2020.0.3 | |
| Add | intel-mkl | 2020.0.4 | |
| Add | intel-mpi | 2019.9 | |
| Add | intel-vtune | 2020.3 | |
| Add | nvhpc | 20.9 | |
| Add | cuDNN | [8.0.5](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_8.html#rel-805) | |
| Add | NCCL | [2.8.3-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-8-3.html) | |
| Update | BeeOND | 7.2 | 7.1.5 |
| Update | Scality S3 Connector | 7.4.8 | 7.4.6.3 |

### Additional Feature: SSH Access to Compute Nodes

We have added the feature to enable SSH login to the compute nodes. See [SSH Access to Compute Nodes](appendix/ssh-access.md) for details.

## 2020-10-09

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.5-4 | 3.5-2 |

## 2020-08-31

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Scality S3 Connector | 7.4.6.3 | 7.4.5.4 |

## 2020-07-31

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | SingularityPRO | 3.5-2 | |
| Add | cuDNN | [8.0.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_8.html#rel-802) | |
| Add | NCCL | [2.7.8-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-7-8.html) | |
| Add | mvapich2-gdr | 2.3.4 | |
| Add | mvapich2 | 2.3.4 | |

## 2020-06-01

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | BeeOND | 7.1.5 | 7.1.4 |

## 2020-04-21

### Update MVAPICH2-GDR 2.3.3

MVAPICH2-GDR 2.3.3 for gcc 4.8.5 was updated to the fixed version about the following issue.

- MPI_Allreduce provided by MVAPICH2-GDR may raise floating point exceptions

On the other hand, MVAPICH2-GDR 2.3.3 for PGI was uninstalled.
If you need MVAPICH2-GDR for PGI, please contact Customer Support.

## 2020-04-03

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | DDN GRIDScaler | 4.2.3.20 | 4.2.3.17 |
| Update | Scality S3 Connector | 7.4.5.4 | 7.4.5.0 |
| Update | libfabric | 1.7.0-1 | 1.5.3-1 |
| Add | intel | 2018.5.274<br>2019.5.281 | |
| Add | pgi | 19.1<br>19.10<br>20.1 | |
| Add | R | 3.6.3 | |
| Add | cmake | 3.16<br>3.17 | |
| Add | go | 1.12<br>1.13 | |
| Add | intel-advisor | 2017.5<br>2018.4<br>2019.5 | |
| Add | intel-inspector | 2017.4<br>2018.4<br>2019.5 | |
| Add | intel-itac | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Add | intel-mkl | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Add | intel-vtune | 2017.6<br>2018.4<br>2019.6 | |
| Add | julia | 1.0<br>1.3<br>1.4 | |
| Add | openjdk | 1.8.0.242<br>11.0.6.10 | |
| Add | python | 3.7.6<br>3.8.2 | |
| Add | gdrcopy | 2.0 | |
| Add | nccl | [2.6.4-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-6-4.html) | |
| Add | intel-mpi | 2017.4<br>2018.4<br>2019.5 | |
| Add | mvapich2-gdr | 2.3.3 | |
| Add | mvapich2 | 2.3.3 | |
| Add | openmpi | 3.1.6<br>4.0.3 | |
| Add | hadoop | 2.9<br>2.10<br>3.1 | |
| Add | spark | 2.3<br>2.4 | |
| Add | aws-cli | 1.18<br>2.0 | |
| Delete | gcc | 7.3.0 | |
| Delete | intel | 2018.2.199<br>2018.3.222<br>2019.3.199 | |
| Delete | pgi | 18.5<br>19.3 | |
| Delete | go | 1.11.2 | |
| Delete | intel-mkl | 2017.8.262<br>2018.2.199<br>2018.3.222<br>2019.3.199 | |
| Delete | openjdk | 1.6.0.41<br>1.8.0.161 | |
| Delete | cuda | 9.0/9.0.176.2<br>9.0/9.0.176.3 | |
| Delete | gdrcopy | 1.2 | |
| Delete | intel-mpi | 2018.2.199 | |
| Delete | mvapich2-gdr | 2.3rc1<br>2.3<br>2.3a<br>2.3.1<br>2.3.2 | |
| Delete | mvapich2 | 2.3rc2<br>2.3<br>2.3.2 | |
| Delete | openmpi | 1.10.7<br>2.1.3<br>2.1.5<br>3.0.3<br>3.1.0<br>3.1.2<br>3.1.3 | |
| Delete | hadoop | 2.9.1<br>2.9.2 | |
| Delete | spark | 2.3.1<br>2.3.2<br>2.4.0 |

## 2019-12-17

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | DDN Lustre | 2.10.7\_ddn14-1 | 2.10.5\_ddn7-1 |
| Update | BeeOND | 7.1.4 | 7.1.3 |
| Update | Scality S3 Connector | 7.4.5.0 | 7.4.4.4 |
| Update | NVIDIA Tesla Driver | [440.33.01](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-440-3301/index.html) | 410.104 |
| Add | CUDA | [10.2.89](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html) | |
| Add | cuDNN | [7.6.5](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_765.html) | |
| Add | NCCL | [2.5.6-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-5-6.html) | |

Other fixes are as follows:

* Add [Memory-Intensive Node](system-overview.md#memory-intensive-node)

## 2019-11-06

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | GCC | 7.3.0, 7.4.0 | |
| Add | sregistry-cli | 0.2.31 | |

Other fixes are as follows:

* Fixed cuda/* modules to set the paths to `extras/CUPTI`.
* Fixed python/3.4, python/3.5, and python/3.6 to solve the problem that error occurred when executing `shutil.copytree` on Home area.

## 2019-10-04

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Univa Grid Engine | 8.6.6 | 8.6.3 |
| Update | DDN GRIDScaler | 4.2.3.17 | 4.2.3.15 |
| Update | BeeOND | 7.1.3 | 7.1.2 |
| Add | CUDA | [10.1.243](https://docs.nvidia.com/cuda/archive/10.1/) | |
| Add | cuDNN | [7.6.3](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_750.html)<br>[7.6.4](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_764.html) | |
| Add | NCCL | [2.4.8-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-8.html) | |
| Add | MVAPICH2-GDR | 2.3.2 | |
| Add | MVAPICH2 | 2.3.2 | |
| Add | fuse-sshfs | 2.10 | |

Other fixes are as follows:

* Add CUDA 10.1 support to cuDNN 7.5.0, 7.5.1, 7.6.0, 7.6.1, 7.6.2
* Add CUDA 10.1 support to NCCL 2.4.2-1, 2.4.7-1
* Add CUDA 10.0 and 10.1 support to GDRCopy 1.2
* Add CUDA 10.1 support to Open MPI 2.1.6
* Increase /tmp capacity of interactive nodes from 26GB to 12TB
* Add process monitoring and process cancellation mechanism on the interactive node

### Start process monitoring on the interactive nodes

Process monitoring started on the interactive nodes.
High load or lengthy tasks on the interactive nodes will be killed by the
process monitoring system, so use the compute nodes with the `qrsh/qsub` 
command.

### Change the job submission and execution limits

We changed the job submission and execution limits as follows.

| Limitations                                                     | Current limits | Previous limits |
| :--                                                             | :--            | :--             |
| The maximum number of tasks within an array job                 | 75000          | 1000            |
| The maximum number of any user's running jobs at the same time  | 200            | 0(unlimited)    |

### About known issues

The status of following known issues were changed to close.

* A comupte node can execute only up to 2 jobs each resource type "rt_G.small"
  and "rt_C.small" (normally up to 4 jobs ).

## 2019-08-01

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [7.6.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_762.html) | |
| Add | NCCL | [2.4.7-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-7.html) | |
| Add | s3fs-fuse | 1.85 | |

Other fixes are as follows:

* Add CUDA 10.0 support to Open MPI 1.10.7, 2.1.5, 2.1.6

## 2019-07-10

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | CUDA | 10.0.130.1 | |
| Add | cuDNN | [7.5.1](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_751.html)<br>[7.6.0](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_760.html)<br>[7.6.1](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_761.html) | |
| Add | aws-cli | 1.16.194 | |

## 2019-04-05

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | CentOS | 7.5 | 7.4 |
| Update | Univa Grid Engine | 8.6.3 | 8.5.4 |
| Update | Java | 1.7.0\_171 | 1.7.0\_141|
| Update | Java | 1.8.0\_161 | 1.8.0\_131|
| Add | DDN Lustre | 2.10.5\_ddn7-1 | |
| Update | NVIDIA Tesla Driver | [410.104](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-410-104/index.html) | 396.44 |
| Add | CUDA | [10.0.130](https://docs.nvidia.com/cuda/archive/10.0/) | |
| Add | Intel Compiler | 2019.3 | |
| Add | PGI | 18.10<br>19.3 | |

Other fixes are as follows:

* Migrate Home area from GPFS to DDN Lustre

## 2019-03-14

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | Intel Compiler | 2017.8<br>2018.3 | |
| Add | PGI | 17.10 | |
| Add | Open MPI | 2.1.6 | |
| Add | cuDNN | [7.5.0](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_750.html) | |
| Add | NCCL | [2.4.2-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-2.html) | |
| Add | Intel MKL | 2017.8<br>2018.3 | |

Other fixes are as follows:

* Add PGI 17.10 support to MVAPICH2-GDR 2.3
* Add PGI support to Open MPI 2.1.5, 2.1.6, 3.1.3
* Change the default version of Open MPI to 2.1.6
* Fix typo in MVAPICH2 modules, wrong top directory

## 2019-01-31

### User/Group/Job names are now masked when displaying the result of 'qstat'

We changed the job scheduler configuration, so that User/Group/Job names are masked from the result of `qstat` command. These columns are shown only for your own jobs, otherwise these columns are masked by '*'. An example follows:

```
[username@es1 ~]$ qstat -u '*' | head
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
    123456 0.28027 run.sh     username     r     01/31/2019 12:34:56 gpu@g0001                                                        80
    123457 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0002                                                        80
    123458 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0003                                                        80
    123450 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0004                                                        80
```

## 2018-12-18

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [7.4.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_742.html) | |
| Add | NCCL | [2.3.7-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-3-7.html) | |
| Add | Open MPI | 3.0.3<br>3.1.3 | |
| Add | MVAPICH2-GDR | 2.3 | |
| Add | Hadoop | 2.9.2 | |
| Add | Spark | 2.3.2<br>2.4.0 | |
| Add | Go | 1.11.2 | |
| Add | Intel MKL | 2018.2.199 | |

### cuDNN 7.4.2

The NVIDIA CUDA Deep Neural Network library (cuDNN) 7.4.2 was installed.

To set up user environment:

```
$ module load cuda/9.2/9.2.148.1
$ module load cudnn/7.4/7.4.2
```

### NCCL 2.3.7-1

The NVIDIA Collective Communications Library (NCCL) 2.3.7-1 was installed.

To set up user environment:

```
$ module load cuda/9.2/9.2.148.1
$ module load nccl/2.3/2.3.7-1
```

### Open MPI 3.0.3, 3.1.3

Open MPI (without --cuda option) 3.0.3, 3.1.3 were installed.

To set up user environment:

```
$ module load openmpi/3.1.3
```

### MVAPICH2-GDR 2.3

MVAPICH2-GDR 2.3 was installed.

To set up user environment:

```
$ module load cuda/9.2/9.2.148.1
$ module load mvapich/mvapich2-gdr/2.3
```

### Hadoop 2.9.2

Apache Hadoop 2.9.2 was installed.

To set up user environment:

```
$ module load openjdk/1.8.0.131
$ module load hadoop/2.9.1
```

### Spark 2.3.2, 2.4.0

Apache Spark 2.3.2, 2.4.0 were installed.

To set up user environment:

```
$ module load spark/2.4.0
```

### Go 1.11.2

Go Programming Language 1.11.2 was installed.

To set up user environment:

```
$ module load go/1.11.2
```

### Intel MKL 2018.2.199

Intel Math Kernel Library (MKL) 2018.2.199 was installed.

To set up user environment:

```
$ module load intel-mkl/2018.2.199
```

## 2018-12-14

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Singularity | 2.6.1 | 2.6.0 |
| Delete | Singularity | 2.5.2 | |

Singularity 2.6.1 was installed. The usage is as follows:

```
$ module load singularity/2.6.1
$ singularity run image_path
```

The release note will be found:

[Singularity 2.6.1](https://github.com/sylabs/singularity/releases/tag/2.6.1)

And, we uninstalled version 2.5.2 and 2.6.0 because severe security issues ([CVE-2018-19295](https://cve.mitre.org/cgi-bin/cvename.cgi?name=2018-19295)) were reported. If you are using Singularity with specifying version number, such as `singularity/2.5.0` or `singularity/2.6.0`, please modify your job scripts to specify `singularity/2.6.1`.

```
ex) module load singularity/2.5.2 -> module load singularity/2.6.1
```

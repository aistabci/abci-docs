# Job Execution

## Job Services

The following job services are available in the ABCI System.

| Service name | Description | Service charge coefficient | Job style |
|:--|:--|:--|:--|
| On-demand | Job service of interactive execution | 7.5 | Interactive |
| Spot | Job service of batch execution | 7.5 | Batch |
| Reserved | Job service of reservation | 11.25 | Batch/Interactive |

For the job execution resources available for each job service and the restrictions, see [Job Execution Resources](#job-execution-resource). Also, for accounting, see [Accounting](#accounting).

### On-demand Service

On-demand service is an interactive job execution service suitable for compiling and debugging programs, interactive applications, and running visualization software.

See [Interactive Jobs](#interactive-jobs) for usage, and [Job Execution Options](#job-execution-options) for details on interactive job execution options.

### Spot Service

Spot Service is a batch job execution service suitable for executing applications that do not require interactive processing. It is possible to execute jobs that take longer or have a higher degree of parallelism than On-demand service.

See [Batch Jobs](#batch-jobs) for usage, and [Job Execution Options](#job-execution-options) for details on batch job execution options.

### Reserved Service

Reserved service is a service that allows you to reserve and use computational resources on a daily basis in advance. It allows planned job execution without being affected by the congenstions of On-demand and Spot service. In addition, since you can reserve more days than the elapsed time limit of the Spot Service, it is possible to execute jobs for a longer time.

In Reserved service, you first make a reservation in advance to obtain a reservation ID (AR-ID), and then use this reservation ID to execute interactive jobs and batch jobs.

See [Advance Reservation](#advance-reservation) for the reservation method. The usage and execution options for batch job is the same as for Spot service.
The usage and execution options for interactive jobs and batch jobs are the same as for On-demand and Spot services.

## Job Execution Resource

The ABCI System allocates system resources to jobs using resource type that means logical partition of compute nodes.
When using any of the On-demand, Spot, and Reserved services, you need to specify the resource type and its quantity that you want to use, submit or execute jobs, and reserves compute nodes.

The following describes the available resource types first, followed by the restrictions on the amount of resources available at the same time, elapsed time and node-time product, job submissions and executions, and so on.

### Available Resource Types

The ABCI system provides the following resource types:


| Resource type name | Description | Assigned physical CPU core | Number of assigned GPU | Memory (GB) | Local storage (GB) | Resource type charge coefficient |
|:--|:--|:--|:--|:--|:--|:--|
| rt\_HF | node-exclusive | 96 | 8 | 1728 | 14 | 15 |
| rt\_HG | node-sharing<br>with GPU | 8 | 1 | 144 | 1.4 | 3|
| rt\_HC | node-sharing<br>CPU only | 16 | 0 | 288 | 1.4 | 1 |


### Number of nodes available at the same time

The available resource type and number of nodes for each service are as follows. When you execute a job using multiple nodes, you need to specify resource type `rt_HF`.

| Service | Resource type name | Number of nodes |
|:--|:--|--:|
| Reserved  | rt\_HF       | 1-(number of reserved nodes) |

### Elapsed time and node-time product limits

There is an elapsed time limit (executable time limit) for jobs depending on the job service and resource type. The upper limit and default values are shown below.

| Service | Resource type name | Limit of elapsed time (upper limit/default) |
|:--|:--|:--|
| Spot      | rt\_HF, rt\_HG, rt\_HC | 168:00:00/1:00:00 |
| On-demand | rt\_HF, rt\_HG, rt\_HC | 12:00:00/1:00:00 |

In addition, when executing a job that uses multiple nodes in On-demand or Spot services, there are the following restrictions on the node-time product (execution time &times; number of used nodes).

| Service | max value of node-hour |
|:--|--:|
| Spot:                         | 21504 nodes &middot; hourss |
| On-demand                                     |    12 nodes &middot; hours |

!!!note
    There is no limit on the elapsed time in the Reserved service, but the job will be forcibly terminated when the reservation ends. See [Advance Reservation](#advance-reservation) for more information about restrictions on Reserved Services.

### Limitation on the number of job submissions and executions

The job limit of submission and execution for the job service are as follows. 
The number of the submitted jobs to the reserved node is included in the number of unfinished/running jobs as well as other On-demand/Spot job and are affected by the limit.

| Limitations                                                       | Limits  |
| :--                                                               | :--     |
| The maximum number of tasks within an array job                   | 75000   |
| The maximum number of any user's unfinished jobs at the same time | 1000    |
| The maximum number of any user's running jobs at the same time    | 200     |

Until fiscal 2023, there was no limit on the number of jobs executed per resource type, and the system was allocated sequentially from the available calculation resources. Starting in fiscal 2024, we will impose restrictions on the number of running jobs at the same time per system for each resource type.
The Job Services subject to this will be the On-demand Service and the Spot Service.
Jobs submitted to reserved nodes in the Reserved service are not included in the count.

| Resource type name | Maximum number of running jobs at the same time per system |
|:--|:--|
| rt_HF | 736 |
| rt_HG | 240 |
| rt_HC | 60 |

## Job Execution Options

Use `qsub` command to run interactive jobs and batch jobs.

The major options of the `qsub` command are follows.

| Option | Description |
|:--|:--|
| -P *group* | Specify ABCI user group. You can only specify the ABCI group to which your ABCI account belongs. (mandatory) |
| -q *resource_type* | Specify resource type (mandatory) |
| -l select=*num*:ncpus=*num_cpus*[*:mpiprocs=num_mpi:ompthreads=num_omp*] | Specify the number of nodes with *num* and the number of CPUs corresponding to each resource type with *num_cpus*, the number of MPI processes with *num_mpi*, and the number of threads with *num_omp*. For *num_cpus*, set 192 for rt_HF, 32 for rt_HC, and 16 for rt_HG. (mandatory) |
| -l walltime=[*HH:MM:*]*SS* | Specify elapsed time by [*HH:MM:*]*SS*. When execution time of job exceed specified time, job is rejected. |
| -N name | Specify the job name with *name*. The default is the job script name. |

## Interactive Jobs

To run an interactive job, add the `-I` option to the `qsub` command.

```
$ qsub -I -P group -q resource_type -l select=num:ncpus=num_cpus [options]
```

Example) Executing an interactive job (On-demand service)

```
[username@int1 ~]$ qsub -I -P grpname -q rt_HF -l select=1:ncpus=192
[username@hnode001 ~]$ 
```

!!! note
    If ABCI point is insufficient when executing an interactive job with On-demand service, the execution is failed.

## Batch Jobs

To run a batch job on the ABCI System, you need to make a job script in addition to execution program.
The job script is described job execute option, such as resource type, elapsed time limit, etc., and executing command sequence.

```bash
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1:ncpus=192
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

[Initialization of Environment Modules]
[Setting of Environment Modules]
[Executing program]
```

Example) Sample job script executing program with CUDA

```bash
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1:ncpus=192
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
./a.out
```

### Submit a batch job

To submit a batch job, use the `qsub` command. The job ID is displayed after submission. 

```
$ qsub job_script
```

Example) Submission job script run.sh as a batch job (Spot service)

```
[username@int1 ~]$ qsub run.sh
1234.pbs1
```

!!! note
    If ABCI point is insufficient when executing a batch job with Spot service, the execution is failed.

### Job submission error

If the batch job submission is successful, the exit status of the `qsub` command will be `0`.
If it fails, it will be a non-zero value and an error message will appear.

### Show the status of batch jobs

To show the current status of batch jobs, use the `qstat` command.

```
$ qstat [option]
```

The major options of the `qstat` command are follows.

| Option | Description |
|:--|:--|
| -f | Display additional information about job |

Example)

```
[username@int1 ~]$ qstat
Job id                 Name             User              Time Use S Queue
---------------------  ---------------- ----------------  -------- - -----
12345.pbs1              run.sh           username          00:01:23 R rt_HF
```

| Field | Description |
|:--|:--|
| Job id | Job ID |
| Name | Job name |
| User | Job owner |
| Time Use | CPU usage time of the job |
| S | Job status (R: running, Q: queued, F: finished, S: suspended, E: exiting) |
| Queue | Resource type |

### Delete a batch job

To delete a batch job, use the `qdel` command.

```
$ qdel job_ID
```

Example) Delete a batch job

```
[username@int1 ~]$ qstat
Job id                 Name             User              Time Use S Queue
---------------------  ---------------- ----------------  -------- - -----
12345.pbs1              run.sh           username          00:01:23 R rt_HF
[username@int1 ~]$ qdel 12345.pbs1
[username@int1 ~]$
```


### Stdout and Stderr of Batch Jobs

Standard output file and standard error output file are written to job execution directory, or to files specified at job submission.
Standard output generated during a job execution is written to a standard output file and error messages generated during the
job execution to a standard error output file if no standard output and standard err output files are specified at job submission,
the following files are generated for output.

- *JOB_NAME*.o*NUM_JOB_ID*  ---  Standard output file
- *JOB_NAME*.e*NUM_JOB_ID*  ---  Standard error output file

## Advance Reservation (Under Update)

In the case of Reserved service, job execution can be scheduled by reserving compute node in advance.

The maximum number of nodes and the node-time product that can be reserved for this service is "Maximum reserved nodes per reservation" and "Maximum reserved node time per reservation" in the following table. In addition, in this service, the user can only execute jobs with the maximum number of reserved nodes. Note that there is an upper limit on "Maximum number of nodes can be reserved at once per system" for the entire system, so you may only be able to make reservations that fall below "Maximum reserved nodes per reservation" or you may not be able to make reservations. [Each resource types](#available-resource-types) are available for reserved compute nodes.

| Item | Setting Value |
|:--|:--|
| Minimum reservation days | 1 day |
| Maximum reservation days | 60 days |
| Maximum number of nodes can be reserved at once per ABCI group | 192 nodes |
| Maximum number of nodes can be reserved at once per system | 384 nodes |
| Minimum reserved nodes per reservation | 1 nodes |
| Maximum reserved nodes per reservation | 192 nodes |
| Maximum reserved node time per reservation | 64,512 nodes x hour |

### Make a reservation

To make a reservation compute node, use `qrsub` command.
When the reservation is completed, a reservation ID will be issued. Please specify this reservation ID when using the reserved node.

!!! warning
    Making reservation of compute node is permitted to a Responsible Person or User Administrators.

```
$ qrsub options
```

| Option | Description |
|:--|:--|
| -a *YYYYMMDD* | Specify start reservation date (format: YYYYMMDD) |
| -d *days* | Specify reservation day. exclusive with -e option |
| -e *YYYYMMDD* | Specify end reservation date (format: YYYYMMDD). exclusive with -d option |
| -g *group* | Specify ABCI UserGroup |
| -N *name* | Specify reservation name. The reservation name can be alphanumeric and special characters `=+-_.`. The maximum length is 64 characters. However, the first letter must not be a number. |
| -n *nnode* | Specify the number of nodes. |
| -l *resource_type* | Specifies the resource type to reserve. ( default: rt_F )|

Example) Make a reservation 4 compute nodes from 2024/07/05 to 1 week (7 days)

```
[username@int1 ~]$ qrsub -a 20240705 -d 7 -P grpname -n 4 -N "Reserve_for_AI"
Your advance reservation 12345 has been granted
```


The ABCI points are consumed when complete reservation.
In addition, the issued reservation ID can be used for the ABCI accounts belonging to the ABCI group specified at the time of reservation.

!!! note
    If the number of nodes that can be reserved is less than the number of nodes specified by the `qrsub` command, the reservation acquisition fails with the following error message:  
    ```
    advance_reservation: no suitable queues
    ```  
    Note that the number of nodes displayed by the `qrstat --available` command does not include currently running jobs. Therefore, even if the `qrstat` command shows the number of nodes that can be reserved, the reservation might fail.

### Show the status of reservations

To show the current status of reservations, use the `qrstat` command.

Example)

```
[username@int1 ~]$ qrstat
ar-id      name       owner        state start at             end at               duration    sr
----------------------------------------------------------------------------------------------------
     12345 Reserve_fo root         w     07/05/2024 10:00:00  07/12/2024 09:30:00  167:30:00    false
```

| Field | Description |
|:-|:-|
| ar-id | Reservation ID (AR-ID) |
| name | Reserve name |
| owner | `root` is always displayed |
| state | Status of reservation |
| start at | Start reservation date (start time is 10:00 a.m. at all time) |
| end at | End reservation date (end time is 9:30 a.m. at all time) |
| duration | Reservation term (hhh:mm:ss) |
| sr | `false` is always displayed |

If you want to show the number of nodes that can be reserved, use`qrstat` command with `--available` option.

Checking the Number of Reservable Nodes for Compute Nodes
```
[username@int1 ~]$ qrstat --available
06/27/2024  441
07/05/2024  432
07/06/2024  434
```


!!! note
    The no reservation day is not printed.

### Cancel a reservation

!!! warning
    Canceling reservation is permitted to a Responsible Person or User Administrators.

To cancel a reservation, use the `qrdel` command. When canceling reservation with qrdel command, multiple reservation IDs can be specified as comma separated list. If you specify a reservation ID that does not exist or a reservation ID that you do not have deletion permission for, an error occurs and any reservations are not canceled.

Example) Cancel a reservation

```
[username@int1 ~]$ qrdel 12345,12346
```

### How to use reserved node  

To run a job using reserved compute nodes, specify reservation ID with the `-ar` option.

Example) Execute an interactive job on compute node reserved with reservation ID `12345`.

```
[username@int1 ~]$ qrsh -g grpname -ar 12345 -l rt_HF=1 -l h_rt=1:00:00
[username@hnode001 ~]$ 
```

Example) Submit a batch job on compute node reserved with reservation ID `12345`.

```
[username@int1 ~]$ qsub -P grpname -ar 12345 run.sh
Your job 12345 ("run.sh") has been submitted
```

!!! note
    - You must specify ABCI group that you specified when making reservation.
    - The batch job can be submitted immediately after making reservation, until reservation start time.
    - The batch job submitted before resevation start time can be deleted with `qdel` command.
    - If a reservation is deleted before reservation start time, batch jobs submitted to the reservation will be deleted.
    - At reservation end time, running jobs are killed.

### Cautions for Using reserved node

Advance Reservation does not guarantee the health of the compute node for the duration. Some reserved compute nodes may become unavailable while they are in use. Please check the following points.

* To check the availability status of the reserved compute nodes, using the `qrstat -ar ar_id` command. 
* If some reserved compute nodes appear unavailable status the day before the reservation start date, consider canceling the reservation and making the reservation again. 
* For example, if the compute node becomes unavailable during the reservation period, please check [Contact](./contact.md) and contact <abci3-qa@abci.ai>.

!!! note
    - Reservation can be canceled by 9:00 p.m. of the day before the reservation starts.  
    - Reservation cannot make when there is no free compute node.  
    - Hardware failures are handled properly. Please refrain from inquiring about unavailability before the day before the reservation starts.  
    - Requests to change the number of reserved compute nodes or to extend the reservation period can not be accepted.

Example) hnode001 is available, hnode002 is unavailable
```
[username@int1 ~]$ qrsub -a 20240705 -d 7 -P grpname -n 2 -N "Reserve_for_AI" 
Your advance reservation 12345 has been granted
[username@int1 ~]$ qrstat -ar 12345
(snip)
message                             reserved queue gpu@hnode002 is disabled
message                             reserved queue gpu@hnode002 is unknown
granted_parallel_environment        perack01
granted_slots_list                  gpu@hnode001=80,gpu@hnode002=80
```

## Accounting (Under Update)

### Spot Service

In On-demand and Spot services, when starting a job, the ABCI point scheduled
for job is calculated by limited value of elapsed time, and subtract processing is executed.
When a job finishes, the ABCI point is calculated again by actual elapsed time, and repayment process is executed.

The calculation formula of ABCI point for using On-demand and Spot services is as follows:

> [Service charge coefficient](#job-services)  
> &times; [Resource type charge coefficient](#available-resource-types)  
> &times; POSIX priority charge coefficient(1.0 or 1.5)  
> &times; Number of resource type  
> &times; max(Elapsed time[sec], Minimum Elapsed time[sec])  
> &times; Utilization class coefficient(Standard Utilization:1.0, Development Acceleration Utilization:0.5)  
> &div; 3600

!!! note
    * The five and under decimal places is rounding off.
    * If the elapsed time of job execution is less than the minimum elapsed time, ABCI point calculated based on the minimum elapsed time.

### Reserved Service

In Reserved service, when completing a reservation, the ABCI point is calculated by
a period of reservation, end subtract processing is executed.
The repayment process is not executed unless reservation is cancelled.
The points are counted as the usage points of the person responsible for the use of the group.

The calculation formula of ABCI point for using Reserved service is follows:

> [Service charge coefficient](#job-services)  
> &times; [Resource type charge coefficient](#available-resource-types)  
> &times; number of reserved nodes  
> &times; number of reserved days  
> &times; Utilization class coefficient(Standard Utilization:1.0, Development Acceleration Utilization:0.5)  
> &times; 24

!!! note
    Reservation for Compute Node is treated as resource type rt_HF.

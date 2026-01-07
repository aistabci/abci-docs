# MPI

The following MPIs can be used with the ABCI system.

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

To use one of these libraries, it is necessary to configure the user environment in advance using the `module` command.
If you run the `module` command in an interactive node, environment variables for compilation are set automatically.
If you run the `module` command in a compute node, environment variables both for compilation and execution are set automatically.

```
[username@login1 ~]$ module load hpcx/2.20
```

```
[username@login1 ~]$ module load intel-mpi/2021.13
```

The following is a list MPI versions installed in the ABCI system.

## NVIDIA HPC-X

| Module Version | Open MPI Version |  Compute Node (H) |
| :-- | :-- | :-- |
| 2.20 | 4.1.7a1 | Yes |

### Using HPC-X

This section describes how to use the NVIDIA HPC-X module.

ABCI provides the following types of HPC-X modules.Please load the module according to your application.

| Module Name | Description |
| :-- | :-- |
| hpcx       | Standard  |
| hpcx-mt    | Multi-Threading support |
| hpcx-debug | for debug  |
| hpcx-prof  | for profiling  |

When executing the `mpirun` and `mpiexec` commands in a job, a host file is also specified in the `-hostfile` option.
The host file is set in the `$PBS_NODEFILE` environment variable.

```
[username@login1 ~]$ qsub -I -P groupname -q rt_HF -l select=2:mpiprocs=192 -l walltime=01:00:00
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $PBS_NODEFILE ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.7a1, package: Open MPI root@hnode001 Distribution, ident: 4.1.7a1, repo rev: v4.1.5-115-g41ba5192d2, Unreleased developer copy, 141)
Hello, world, I am 1 of 2, (Open MPI v4.1.7a1, package: Open MPI root@hnode001 Distribution, ident: 4.1.7a1, repo rev: v4.1.5-115-g41ba5192d2, Unreleased developer copy, 141)
```

NVIDIA HPC-X provides the NCCL-SHARP plug-in.
The plug-in supports different versions of NCCL for different versions of HPC-X.
See the table below for compatibility between HPC-X and NCCL.

| HPC-X Version | NCCL Version |
| :-- | :-- |
| 2.20 | 2.23 |

For more information about NVIDIA HPC-X, please refer to [the official documentation](https://docs.nvidia.com/networking/category/hpcx).

## Intel MPI

| intel-mpi/ | Compute Node (H) |
|:--|:--|
| 2021.13 | Yes |

## How to change the number of InfiniBand NDR

There are eight InfiniBand NDR HCA on compute nodes(H).  
The following configuration is used by default on `hpcx`/`intel-mpi` modules.

* The number of lanes is four for Rendezvous protocol(large message size)
* The number of lanes is one for Eager protocol(small message size)

The number of lanes can be changed by setting `UCX_MAX_RNDV_RAILS`/`UCX_MAX_EAGER_RAILS` environment variables.

!!!info
    The range of the above environment variables is 1-8.

The following is an example usage of interactive job.  
In this example, the number of lanes used is doubled.

```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=2:mpiprocs=8 -l walltime=1:0:0
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ export UCX_MAX_RNDV_RAILS=8
[username@hnode001 ~]$ export UCX_MAX_EAGER_RAILS=2
[username@hnode001 ~]$ mpirun ./a.out
```

Additionally, a wrapper script like the following can be used to assign a unique NDR HCA to each process.

* wrap.sh(hpcx)

```
#!/bin/sh

NNDRS=8

for i in $(seq 1 $NNDRS)
do
    if [ $((OMPI_COMM_WORLD_RANK%NNDRS)) -eq $((i-1)) ];then
        export UCX_NET_DEVICES=mlx5_ibn$i:1
    fi
done

exec "$@"
```

```
mpirun -np $NP ./wrap.sh ./a.out
```

* wrap.sh(intel-mpi)

```
#!/bin/sh

NNDRS=8

for i in $(seq 1 $NNDRS)
do
    if [ $((PMI_RANK%NNDRS)) -eq $((i-1)) ];then
        export UCX_NET_DEVICES=mlx5_ibn$i:1
    fi
done

exec "$@"
```
  
```
mpiexec.hydra -np $NP ./wrap.sh ./a.out
```

!!!warn
    Please specify the number of MPI processes by specifying `mpiprocs`(ppn) option of `qsub` command.
  
!!!info
    `mlx5_ibn$i` is the name of NDR HCA.

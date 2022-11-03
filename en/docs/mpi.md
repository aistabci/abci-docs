# MPI

The following MPIs can be used with the ABCI system.

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Open MPI](https://www.open-mpi.org/)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

To use one of these libraries, it is necessary to configure the user environment in advance using the `module` command.
If you run the `module` command in an interactive node, environment variables for compilation are set automatically.
If you run the `module` command in a compute node, environment variables both for compilation and execution are set automatically.

```
[username@es1 ~]$ module load hpcx/2.11
```

```
[username@es1 ~]$ module load openmpi/4.0.5
```

```
[username@es1 ~]$ module load intel-mpi/2021.5
```

The following is a list MPI versions installed in the ABCI system.

## NVIDIA HPC-X

Compute Node (A):

| Module Version | MPI Version |
| :-- | :-- |
| 2.11 | 4.1.4rc1 |

!!! note
    NVIDIA HPC-X for Compute Node (V) is not currently provided.

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
The host file is set in the `$SGE_JOB_HOSTLIST` environment variable.

```
[username@es-a1 ~]$ qrsh -g groupname -l rt_AF=2 -l h_rt=01:00:0
[username@a0000 ~]$ module load hpcx/2.11
[username@a0000 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $SGE_JOB_HOSTLIST ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.4rc1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.4rc1, repo rev: v4.1.4rc1, Unreleased developer copy, 135)
Hello, world, I am 1 of 2, (Open MPI v4.1.4rc1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.4rc1, repo rev: v4.1.4rc1, Unreleased developer copy, 135)
```

NVIDIA HPC-X provides the NCCL-SHARP plug-in.
The plug-in supports different versions of NCCL for different versions of HPC-X.
See the table below for compatibility between HPC-X and NCCL.

| HPC-X Version | NCCL Version |
| :-- | :-- |
| 2.11 | 2.8、2.9、2.10、2.11 |

For information on how to use SHARP and the NCCL-SHARP plug-in, see [Using SHARP](tips/sharp.md).

## Open MPI

Compute Node (V):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/4.8.5     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/4.8.5     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

Compute Node (A):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/8.3.1     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/8.3.1     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2021.5 | Yes | Yes |

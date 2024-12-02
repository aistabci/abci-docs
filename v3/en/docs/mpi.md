# MPI

The following MPIs can be used with the ABCI system.

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

To use one of these libraries, it is necessary to configure the user environment in advance using the `module` command.
If you run the `module` command in an interactive node, environment variables for compilation are set automatically.
If you run the `module` command in a compute node, environment variables both for compilation and execution are set automatically.

```
[username@es1 ~]$ module load hpcx/2.12
```

```
[username@es1 ~]$ module load intel-mpi/2021.11
```

The following is a list MPI versions installed in the ABCI system.

## NVIDIA HPC-X

| Module Version | Open MPI Version |  Compute Node (V) | Compute Node (A) |
| :-- | :-- | :-- | :-- |
| 2.12 | 4.1.5a1 | Yes | Yes |

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
[username@es1 ~]$ qrsh -g groupname -l rt_F=2 -l h_rt=01:00:0
[username@g0001 ~]$ module load hpcx/2.12
[username@g0001 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $SGE_JOB_HOSTLIST ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
Hello, world, I am 1 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
```

NVIDIA HPC-X provides the NCCL-SHARP plug-in.
The plug-in supports different versions of NCCL for different versions of HPC-X.
See the table below for compatibility between HPC-X and NCCL.

| HPC-X Version | NCCL Version |
| :-- | :-- |
| 2.12 | 2.12 |

For information on how to use SHARP and the NCCL-SHARP plug-in, see [Using SHARP](tips/sharp.md).

For more information about NVIDIA HPC-X, please refer to [the official documentation](https://docs.nvidia.com/networking/category/hpcx).

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2021.11 | Yes | Yes |

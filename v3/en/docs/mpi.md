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
| 2.20 | <mark>4.1.5a1</mark> | Yes |

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
[username@login1 ~]$ qsub -I -P groupname -q rt_HF -l select=2 -l walltime=01:00:00
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $SGE_JOB_HOSTLIST ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
Hello, world, I am 1 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
```

NVIDIA HPC-X provides the NCCL-SHARP plug-in.
The plug-in supports different versions of NCCL for different versions of HPC-X.
See the table below for compatibility between HPC-X and NCCL.

| HPC-X Version | NCCL Version |
| :-- | :-- |
| 2.20 | <mark>2.23</mark> |

For more information about NVIDIA HPC-X, please refer to [the official documentation](https://docs.nvidia.com/networking/category/hpcx).

## Intel MPI

| intel-mpi/ | Compute Node (H) |
|:--|:--|
| 2021.13 | Yes |

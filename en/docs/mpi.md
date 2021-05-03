# MPI

The following MPIs can be used with the ABCI system.

* [Open MPI](https://www.open-mpi.org/)
* [MVAPICH2](http://mvapich.cse.ohio-state.edu/overview/#mv2)
* [MVAPICH2-GDR](http://mvapich.cse.ohio-state.edu/overview/#mv2gdr)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

To use one of these libraries, it is necessary to configure the user environment in advance using the `module` command.
If you run the `module` command in an interactive node, environment variables for compilation are set automatically.
If you run the `module` command in a compute node, environment variables both for compilation and execution are set automatically.

```
[username@es1 ~]$ module load openmpi/4.0.5
```

```
[username@es1 ~]$ module load cuda/11.0 mvapich/mvapich2-gdr/2.3.5
```

```
[username@es1 ~]$ module load mvapich/mvapich2/2.3.5
```

```
[username@es1 ~]$ module load intel-mpi/2019.9
```

The following is a list MPI versions installed in the ABCI system.

## Open MPI

Compute Node (V):

| openmpi/ | Compiler version | w/o CUDA | cuda8.0 | cuda9.0 | cuda9.1 | cuda9.2 | cuda10.0 | cuda10.1 | cuda10.2 | cuda11.0 | cuda11.1 | cuda11.2 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.1.6  | gcc/4.8.5     | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | gcc/7.4.0     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | gcc/9.3.0     | Yes | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | pgi/20.4      | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | nvhpc/20.11   | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | nvhpc/21.2    | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/4.8.5     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/7.4.0     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/9.3.0     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | pgi/20.4      | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | nvhpc/20.11   | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | nvhpc/21.2    | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/4.8.5     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/7.4.0     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/9.3.0     | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | pgi/20.4      | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | nvhpc/20.11   | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | nvhpc/21.2    | Yes | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

Compute Node (A):

| openmpi/ | Compiler version | w/o CUDA | cuda10.0[^1] | cuda10.1[^1] | cuda10.2[^1] | cuda11.0 | cuda11.1 | cuda11.2 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.1.6  | gcc/7.4.0     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | gcc/8.3.1     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | gcc/9.3.0     | Yes | -   | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | pgi/20.4      | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | nvhpc/20.11   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.1.6  | nvhpc/21.2    | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/7.4.0     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/8.3.1     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | gcc/9.3.0     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | pgi/20.4      | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | nvhpc/20.11   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 3.1.6  | nvhpc/21.2    | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/7.4.0     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/8.3.1     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | gcc/9.3.0     | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | pgi/20.4      | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | nvhpc/20.11   | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 4.0.5  | nvhpc/21.2    | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

[^1]: Provided only for experimental use. NVIDIA A100 is supported on CUDA 11＋.

## MVAPICH2

| mvapich/mvapich2/ | Compiler version | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|:--|
| 2.3.5 | gcc/4.8.5     | Yes | -   |
| 2.3.5 | gcc/7.4.0     | Yes | Yes |
| 2.3.5 | gcc/8.3.1     | -   | Yes |
| 2.3.5 | gcc/9.3.0     | Yes | Yes |
| 2.3.5 | pgi/20.4      | Yes | Yes |
| 2.3.5 | nvhpc/20.11   | Yes | Yes |
| 2.3.5 | nvhpc/21.2    | Yes | Yes |

## MVAPICH2-GDR

| mvapich/mvapich2-gdr/ | Compiler version | cuda10.0 | cuda10.1 | cuda10.2 | cuda11.0 |
|:--|:--|:--|:--|:--|:--|
| 2.3.5  | gcc/4.8.5 | -   | -   | Yes | Yes |

!!! note
    Compute Node (A) does not currently provide MVAPICH2-GDR.

!!! note
    If you need MVAPICH2-GDR for PGI, please contact Customer Support.

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2019.9 | Yes | Yes |

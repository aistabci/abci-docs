# MPI

The following MPIs can be used with the ABCI system.

* [Open MPI](https://www.open-mpi.org/)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

To use one of these libraries, it is necessary to configure the user environment in advance using the `module` command.
If you run the `module` command in an interactive node, environment variables for compilation are set automatically.
If you run the `module` command in a compute node, environment variables both for compilation and execution are set automatically.

```
[username@es1 ~]$ module load openmpi/4.0.5
```

```
[username@es1 ~]$ module load intel-mpi/2021.5
```

The following is a list MPI versions installed in the ABCI system.

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

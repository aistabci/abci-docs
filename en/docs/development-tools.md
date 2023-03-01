# Development Tools

## GNU Compiler Collection (GCC)

GNU Compiler Collection (GCC) is available on the ABCI System.

List of compile/link command of GCC:

| Parallelism | Programming Language | command |
|:--|:--|:--|
| Serial | Fortran | gfortran |
| | C | gcc |
| | C++ | g++ |
| MPI parallel | Fortran | mpifort |
| | C | mpicc |
| | C++ | mpic++ |

## Intel oneAPI

Intel oneAPI is available on the ABCI System.
To use Intel oneAPI, set up user environment by the `module` command.
If you set up with the `module` command in compute node, environment variables for compilation and execution are set automatically.

Setting command for Intel oneAPI is following:

```
[username@g0001 ~]$ module load intel/2022.2.1
```

List of compile/link commands of Intel oneAPI:

| Programing Language | command |
|:--|:--|
| Fortran | ifort |
| C | icc |
| C++ | icpc |

## PGI

PGI Compiler is available on the ABCI System.
To use PGI compiler, set up user environment by the `module` command.
If you set up with the `module` command in compute node, environment variables for compilation and execution are set automatically.

Setting command for PGI Compiler is following:

```
[username@g0001 ~]$ module load pgi/20.4
```

List of compile/link commands of PGI Compiler:

| Programing Language | command |
|:--|:--|
| Fortran | pgf90 |
| C | pgcc |
| C++ | pgc++ |

## OpenMP

The compilers provided on the ABCI System support thread parallelization by OpenMP specifications.
To activate the OpenMP specifications, specify the compile option as follows:

| | Compile option |
|:--|:--|
| GCC | -fopenmp |
| Intel oneAPI | -qopenmp |
| PGI | -mp |

## CUDA

CUDA is available on the ABCI System.
To use CUDA compiler, set up user environment by the `module` command.
If you set up with the `module` command in compute node, environment variables for compilation and execution are set automatically.

| Programing Language | command |
|:--|:--|
| C++ | nvcc |

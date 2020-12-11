# Software Management by Spack

[Spack](https://spack.io/) is a software package manager for supercomputers developed by Lawrence Livermore National Laboratory.
By using Spack, you can easily install software packages by changing their versions, configurations and compilers, and then select necessary one them when you use.
Using Spack on ABCI enables easily installing software which is not officially supported by ABCI.

!!! note
    We tested Spack using bash on Dec 3rd 2020, and we used Spack 0.16.0 which was the latest version at that time.

!!! caution
    Spack installs software packaged in its original format which is not compatible with packages
    provided by any Linux distributions, such as `.deb` and `.rpm`.
    Therefore, Spack is not a replacement of `yum` or `apt` system.

!!! caution
    Spack installs software under a directory where Spack was installed.
    Manage software installed by Sapck by yourself, for example, by uninstalling unused software, because Spack consumes large amount of disk space if you install many software.


## Setup Spack {#setup-spack}

### Install {#install}

You can install Spack by cloning from GitHub and checking out the version you want to use.
```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.16.0
```

After that, you can use Spack by loading a setup shell script.
```
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

### Configuration for ABCI {#configuration-for-abci}

#### Adding Compilers {#adding-compilers}

First, you have to register compilers you want to use in Spack.

`spack compiler list` command automatically detects and registers compilers which are located in the default path (/usr/bin).
```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@4.8.5  gcc@4.4.7
```

ABCI provides a pre-configured compiler definition file for Spack, `compilers.yaml`.
Copying this file to your environment sets up GCC 4.8.5 and 7.4.0 to be used in Spack.
```
[username@es1 ~]$ cp /apps/spack/compilers.yaml ${HOME}/.spack/linux/
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5
```


#### Adding ABCI Software {#adding-abci-software}

Spack automatically resolves software dependencies and installs dependant software.
Spack, by default, installs another copies of software which is already supported by ABCI, such as CUDA and OpenMPI.
As it is a waste of disk space, we recommend to configure Spack to *refer to* software supported by ABCI.

Software referred by Spack can be defined in the configuration file `$HOME/.spack/linux/packages.yaml`.
ABCI provides a pre-configured `packages.yaml` which defines mappings of Spack package and software installed on ABCI.
Copying this file to your environment lets Spack use installed CUDA, OpenMPI, MVAPICH, cmake and etc.
```
[username@es1 ~]$ cp /apps/spack/packages.yaml ${HOME}/.spack/linux/
```

packages.yaml (excerpt)
```
packages:
  cuda:
    buildable: false
    externals:
(snip)
    - spec: cuda@10.2.89%gcc@4.8.5
      modules:
      - cuda/10.2/10.2.89
    - spec: cuda@10.2.89%gcc@7.4.0
      modules:
      - cuda/10.2/10.2.89
(snip)
```

After you copy this file, when you let Spack install CUDA version 10.2.89, it use `cuda/10.2/10.2.89` environment module, instead of installing another copy of CUDA.
`buildable: false` defined under CUDA section prohibits Spack to install other versions of CUDA specified here.
If you let Spack install versions of CUDA which are not supported by ABCI, remove this directive.

Please refer to [the official document](https://spack.readthedocs.io/en/latest/build_settings.html) for detail about `packages.yaml`.


## Basic of Spack {#basic-of-spack}

Here is the Spack basic usage.
For detail, please refer to [the official document](https://spack.readthedocs.io/en/latest/basic_usage.html).

### Compiler Operations {#compiler-operations}

`compiler list` sub-command shows the list of compilers registered to Spack.
```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5
```

`compiler info` sub-command shows the detail of a specific compiler.
```
[username@es1 ~]$ spack compiler info gcc@4.8.5
gcc@4.8.5:
    paths:
        cc = /usr/bin/gcc
        cxx = /usr/bin/g++
        f77 = /usr/bin/gfortran
        fc = /usr/bin/gfortran
    Extra rpaths:
        /usr/lib/gcc/x86_64-redhat-linux/4.8.5
    modules  = []
    operating system  = centos7
```

### Software Management Operations {#software-management-operations}

#### Install {#install}

The default version of OpenMPI can be installed as follows.
Refer to [Example Software Installation](#cuda-aware-openmpi) for options.
```
[username@es1 ~]$ spack install openmpi schedulers=sge fabrics=auto
```

If you want to install a specific version, use `@` to specify the version.
```
[username@es1 ~]$ spack install openmpi@3.1.4 schedulers=sge fabrics=auto
```

The compiler to build the software can be specified by `%`.
The following example use GCC 7.4.0 for building OpenMPI.
```
[username@es1 ~]$ spack install openmpi@3.1.4 %gcc@7.4.0 schedulers=sge fabrics=auto
```

#### Uninstall {#uninstall}

`uninstall` sub-command uninstalls installed software.
As with installation, you can uninstall software by specifying a version.
```
[username@es1 ~]$ spack uninstall openmpi
```

Each software package installed by Spack has a hash, and you can also uninstall a software by specifying a hash.
Specify `/` followed by a hash.
You can get a hash of an installed software by `find` sub-command shown in [Information](#information).
```
[username@es1 ~]$ spack uninstall /ffwtsvk
```

To uninstall all the installed software, type as follows.
```
[username@es1 ~]$ spack uninstall --all
```

#### Information {#information}

`list` sub-command shows all software which can be installed by Spack.
```
[username@es1 ~]$ spack list
abinit
abyss
(snip)
```

By specifying a keyword, it only shows software related to the keyword.
The following example uses `mpi` as the keyword.
```
[username@es1 ~]$ spack list mpi
==> 21 packages.
compiz       mpifileutils  mpix-launch-swift  r-rmpi        vampirtrace
fujitsu-mpi  mpilander     openmpi            rempi
intel-mpi    mpileaks      pbmpi              spectrum-mpi
mpibash      mpip          pnmpi              sst-dumpi
mpich        mpir          py-mpi4py          umpire
```

`find` sub-command shows all the installed software.
```
[username@es1 ~]$ spack find
==> 49 installed packages
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
autoconf@2.69    gdbm@1.18.1          libxml2@2.9.9  readline@8.0
(snip)
```

Adding `-dl` option to `find` sub-command shows hashes and dependencies of installed software.
```
[username@es1 ~]$ spack find -dl openmpi
-- linux-centos7-skylake_avx512 / gcc@7.4.0 ---------------------
6pxjftg openmpi@3.1.1
ahftjey     hwloc@1.11.11
vf52amo         cuda@9.0.176.4
edtwt6g         libpciaccess@0.16
bt74u75         libxml2@2.9.10
qazxaa4             libiconv@1.16
jb22kvg             xz@5.2.5
pkmj6e7             zlib@1.2.11
2dq7ece         numactl@2.0.14
```

To see the detail about a specific software, use `info` sub-command.
```
[username@es1 ~]$ spack info openmpi
AutotoolsPackage:   openmpi

Description:
    An open source Message Passing Interface implementation. The Open MPI
    Project is an open source Message Passing Interface implementation that
(snip)
```

`versions` sub-command shows avaitable versions for a specific software.
```
[username@es1 ~]$ spack versions openmpi
==> Safe versions (already checksummed):
  develop  3.0.3  2.1.1   1.10.5  1.8.5  1.7.2  1.5.5  1.4.2  1.2.8  1.1.5
  4.0.1    3.0.2  2.1.0   1.10.4  1.8.4  1.7.1  1.5.4  1.4.1  1.2.7  1.1.4
  4.0.0    3.0.1  2.0.4   1.10.3  1.8.3  1.7    1.5.3  1.4    1.2.6  1.1.3
  3.1.4    3.0.0  2.0.3   1.10.2  1.8.2  1.6.5  1.5.2  1.3.4  1.2.5  1.1.2
  3.1.3    2.1.6  2.0.2   1.10.1  1.8.1  1.6.4  1.5.1  1.3.3  1.2.4  1.1.1
  3.1.2    2.1.5  2.0.1   1.10.0  1.8    1.6.3  1.5    1.3.2  1.2.3  1.1
  3.1.1    2.1.4  2.0.0   1.8.8   1.7.5  1.6.2  1.4.5  1.3.1  1.2.2  1.0.2
  3.1.0    2.1.3  1.10.7  1.8.7   1.7.4  1.6.1  1.4.4  1.3    1.2.1  1.0.1
  3.0.4    2.1.2  1.10.6  1.8.6   1.7.3  1.6    1.4.3  1.2.9  1.2    1.0
```


### Use of Installed Software {#use-of-installed-software}

Software installed with Spack is available with the `spack load` command.
Like the module provided by ABCI, the installed software can be be loaded and used.
```
[username@es1 ~]$ spack load xxxxx
```
`spack load` sets environment variables, such as `PATH`, `MANPATH`, `CPATH`, `LD_LIBRARY_PATH`, so that the software can be used.

If you no more use, type `spack unload` to unset the variables.
```
[username@es1 ~]$ spack unload xxxxx
```


## Example Software Installation {#example-software-installation}

### CUDA-aware OpenMPI {#cuda-aware-openmpi}

ABCI provides software modules of CUDA-aware OpenMPI, however, they do not support all the combinations of compilers, CUDA and OpenMPI versions ([Reference](https://docs.abci.ai/en/08/#open-mpi)).
It is easy to use Spack to install unsupported versions of CUDA-aware OpenMPI.

#### How to Install {#how-to-install}

This is an example of installing OpenMPI 3.1.1 that uses CUDA 10.1.243.
You have to use a compute node to install it.
```
[username@g0001 ~]$ spack install cuda@10.1.243
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@10.1.243
[username@g0001 ~]$ spack find --paths openmpi@3.1.1
==> 1 installed package
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
openmpi@3.1.1  ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v
[username@g0001 ~]$ echo "btl_openib_warn_default_gid_prefix = 0" >> ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v/etc/openmpi-mca-params.conf
```

Line #1 installs CUDA version `10.1.243` so that Spack uses a CUDA provided by ABCI.
Line #2 installs OpenMPI 3.1.1 as the same configuration with [this page](../appendix/installed-software.md#open-mpi).
Meanings of the installation options are as follows.

- `+cuda`: Build with CUDA support
- `schedulers=sge`: Specify how to invoke MPI processes.  You have to specify `sge` as ABCI uses Univa Grid Engine which is compatible with SGE.
- `fabrics=auto`: Specify a communication library.
- `^cuda@10.1.243`: Specify a CUDA to be used.  `^` is used to specify software dependency.

Line #4 edits a configuration file to turn off runtime warnings (optional).
For this purpose, Line #3 checks the installation path of OpenMPI.

Spack can manage variants of the same version of software.
This is an example that you additionally install OpenMPI 3.1.1 that uses CUDA 9.0.176.4.
```
[username@g0001 ~]$ spack install cuda@9.0.176.4
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@9.0.176.4
```

#### How to Use {#how-to-use}

This is an example of using "OpenMPI 3.1.1 that uses CUDA 10.1.243" installed above.
Specify the version of OpenMPI and CUDA dependency to load the software.
```
[username@es1 ~]$ spack load openmpi@3.1.1 ^cuda@10.1.243
```

To build an MPI program using the above OpenMPI, you need to load OpenMPI installed by Spack .
```
[username@g0001 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
[username@g0001 ~]$ spack load openmpi@3.1.1 ^cuda@10.1.243
[username@g0001 ~]$ mpicc ...
```

A job script that runs the built MPI program is as follows.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load openmpi@3.1.1 ^cuda@10.1.243

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIOPTS="-n ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -x PATH -x LD_LIBRARY_PATH"
mpiexec ${MPIOPTS} YOUR_PROGRAM
```

If you no more use the OpenMPI, you can uninstall it by specifying the version and dependencies.
```
[username@es1 ~]$ spack uninstall openmpi@3.1.1 ^cuda@10.1.243
```


### CUDA-aware MVAPICH2 {#cuda-aware-mvapich2}

MVAPICH2 modules provided by ABCI does not support CUDA.
If you want to use CUDA-aware MVAPICH2, install by yourself referring to the documents below.

You have to use a compute node to build CUDA-aware MVAPICH2.
As with [OpenMPI](#cuda-aware-openmpi) above, you first install CUDA and then install MVAPICH2 by enabling CUDA (`+cuda`) and specifying a communication library (`fabrics=mrail`) and CUDA dependency (`^cuda@10.1.243`).
```
[username@g0001 ~]$ spack install cuda@10.1.243
[username@g0001 ~]$ spack install mvapich2@2.3.2 +cuda fabrics=mrail ^cuda@10.1.243
```

To use CUDA-aware MVAPICH2, as with OpenMPI, load modules of a CUDA and the installed MVAPICH2.
Here is a job script example.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mvapich2@2.3.2 ^cuda@10.1.243

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIE_ARGS="-genv MV2_USE_CUDA=1"
MPIOPTS="${MPIE_ARGS} -np ${NUM_PROCS} -ppn ${NUM_GPUS_PER_NODE}"

mpiexec ${MPIOPTS} YOUR_PROGRAM
```


### MPIFileUtils {#mpifileutils}

[MPIFileUtils](https://hpc.github.io/mpifileutils/) a file transfer tool that uses MPI for communication between nodes.
Although manually installing it is messy as it depends on many libraries, using Spack enables an easy install of MPIFileUtils.

The following example installs MPIFileUtils that uses OpenMPI 2.1.6.
Line #1 installs OpenMPI, and Line #2 installs MPIFileUtils by specifying a dependency on OpenMPI.
If you copied `packages.yaml` as described in [Adding ABCI Software](#adding-abci-software), OpenMPI 2.1.6 provided by ABCI is used.
```
[username@es1 ~]$ spack install openmpi@2.1.6
[username@es1 ~]$ spack install mpifileutils ^openmpi@2.1.6
```

To use MPIFileUtils, you have to load modules of OpenMPI 2.1.6 and MPIFileUtils.
When you load MPIFileUtils module, PATH to program, such as `dbcast` is set.
This is an example job script.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mpifileutils@0.10.1 ^openmpi@2.1.6

NPPN=5
NMPIPROC=$(( $NHOSTS * $NPPN ))
SRC_FILE=name_of_file
DST_FILE=name_of_file

mpiexec -n ${NMPIPROC} -map-by ppr:${NPPN}:node dbcast $SRC_FILE $DST_FILE
```

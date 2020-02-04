# Software Management by Spack

[Spack](https://spack.io/) is a software package manager for supercomputers developed by Lawrence Livermore National Laboratory.
By using Spack, users can easily install software packages by changing their versions, configurations and compilers, and then switch them when they use.
Using Spack on ABCI enables easily installing software which is not officially supported by ABCI.

!!! note
    We tested Spack on Feb 3rd 2020, and we used Spack 0.13.3 which was the latest version at that time.

!!! caution
    Spack installs software under a directory where Spack was installed.
    Manage software installed by Sapck by yourself, for example, by uninstalling unused software, because it consumes large amount of disk space if you install many software.


## Setup Spack {#setup-spack}

### Install {#install}

Installing Spack is completed by cloning it from GitHub and checking out the version we use.
```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.13.3
```

After that, Spack can be used by loading a setup shell script.
```
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

### Configuration for ABCI {#configuration-for-abci}

#### Adding Compilers {#adding-compilers}

First, we have to register compilers we want to use in Spack.
It can be done by `spack compiler find` command.

Here, we register GCC 4.4.7, 4.8.5 and 7.4.0.
Spack automatically finds GCC 4.4.7 and 4.8.5 because they are installed in the default path (/usr/bin).
We have to do `module load` of GCC 7.4.0 because it is provided by a software module.
```
[username@es1 ~]$ module load gcc/7.4.0
[username@es1 ~]$ spack compiler find
[username@es1 ~]$ module purge
```

We can confirm the registration completion if we see the following output when we execute `spack compiler list` command which shows the registered compilers.
```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5  gcc@4.4.7
```

The default compiler can be specified in the configuration file `$HOME/.spack/linux/packages.yaml`.
Add the following lines to the file to specify GCC 4.8.5 as the default compiler.
```
packages:
  all:
    compiler: [gcc@4.8.5]
```

#### Adding ABCI Software {#adding-abci-software}

Spack automatically resolves software dependencies and install dependant software.
Spack, by default, installs another copies of software which is already supported by ABCI, such as CUDA and OpenMPI.
As it is a waste of disk space, we recommend to configure Spack to *refer to* software supported by ABCI.

Software referred by Spack can be defined in the configuration file `$HOME/.spack/linux/packages.yaml`.
Create the file by the following contents (it includes the default compiler configuration).
```
packages:
  cuda:
    paths:
      cuda@abci-8.0.61.2:   /apps/cuda/8.0.61.2
      cuda@abci-9.0.176.4:  /apps/cuda/9.0.176.4
      cuda@abci-9.1.85.3:   /apps/cuda/9.1.85.3
      cuda@abci-9.2.148.1:  /apps/cuda/9.2.148.1
      cuda@abci-10.0.130.1: /apps/cuda/10.0.130.1
      cuda@abci-10.1.243:   /apps/cuda/10.1.243
      cuda@abci-10.2.89:    /apps/cuda/10.2.89
    buildable: False
  openmpi:
    paths:
      openmpi@abci-2.1.6-nocuda%gcc@4.8.5: /apps/openmpi/2.1.6/gcc4.8.5
      openmpi@abci-3.1.3-nocuda%gcc@4.8.5: /apps/openmpi/3.1.3/gcc4.8.5
  mvapich2:
    paths:
      mvapich2@abci-2.3-nocuda%gcc@4.8.5:   /apps/mvapich2/2.3/gcc4.8.5
      mvapich2@abci-2.3.2-nocuda%gcc@4.8.5: /apps/mvapich2/2.3.2/gcc4.8.5
  cmake:
    paths:
      cmake@abci-3.11.4: /apps/cmake/3.11.4
  all:
    compiler: [gcc@4.8.5]
```

The above example configures CUDA, OpenMPI, MVAPICH and CMake.
In case of `cuda@abci-8.0.61.2: /apps/cuda/8.0.61.2`, it means that Spack refers to software installed in `/apps/cuda/8.0.61.2`, instead of installing another copy of CUDA, when we conduct the installation of CUDA version abci-8.0.61.2.
`buildable: False` defined under CUDA section prohibit Spack to install other versions of CUDA specified here.
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
gcc@7.4.0  gcc@4.8.5  gcc@4.4.7
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
	modules  = []
	operating system  = centos7
```

### Software Management Operations {#software-management-operations}

#### Install {#install}

The default version of OpenMPI can be installed as follows.
Refer to [Example Software Installation](#example_openmpi) for options.
```
[username@es1 ~]$ spack install openmpi schedulers=sge
```

If we want to install a specific version, use `@` to specify the version.
```
[username@es1 ~]$ spack install openmpi@3.1.4 schedulers=sge
```

The compiler to build the software can be specified by `%`.
The following example use GCC 7.3.0 for building OpenMPI.
```
[username@es1 ~]$ spack install openmpi@3.1.4 %gcc@7.3.0 schedulers=sge
```

#### Uninstall {#uninstall}

`uninstall` sub-command uninstalls installed software.
As with installation, we can uninstall software by specifying a version.
```
[username@es1 ~]$ spack uninstall openmpi
```

Each software package installed by Spack has a hash, and we can also uninstall a software by specifying a hash.
Specify `/` followed by a hash.
We can get a hash of an installed software by `find` sub-command shown in [Information](#usage_package_info).
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
sif5fzv openmpi@3.1.4
xqsp4xn     hwloc@1.11.11
3movoj3         libpciaccess@0.13.5
d6xghgt         libxml2@2.9.9
zydtv5a             libiconv@1.16
y6e4zi2             xz@5.2.4
kv37bl2             zlib@1.2.11
onnjyv2         numactl@2.0.12
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

Software installed by Spack is automatically registered to the Environment Modules.
As with modules provided by ABCI, the installed software can be used by loading them.
```
[username@es1 ~]$ module load xxxxx
```

To update modules of all the installed software, type the following command.
```
[username@es1 ~]$ spack module tcl refresh
```

To remove modules of all the installed software, type the following command.
```
[username@es1 ~]$ spack module tcl rm
```

!!! note
    Try to reload the Spack setup script if the installed software do not appear in the Environment Modules.

    ```
    [username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
    ```


## Example Software Installation {#example-software-installation}

### CUDA-aware OpenMPI {#cuda-aware-openmpi}

ABCI provides software modules of CUDA-aware OpenMPI, however, they do not support all the combinations of compilers, CUDA and OpenMPI versions ([Reference](https://docs.abci.ai/en/08/#open-mpi)).
It is easy to use Spack to install unsupported versions of CUDA-aware OpenMPI.

#### How to Install {#how-to-install}

This is an example of installing OpenMPI 3.1.1 that uses CUDA 10.1.243.
We use a compute node to install it.
```
[username@g0001 ~]$ spack install cuda@abci-10.1.243
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@abci-10.1.243
[username@g0001 ~]$ spack find --paths openmpi@3.1.1
==> 1 installed package
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
openmpi@3.1.1  ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v
[username@g0001 ~]$ echo "btl_openib_warn_default_gid_prefix = 0" >> ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v/etc/openmpi-mca-params.conf
```

Line #1 installs CUDA version `abci-10.1.243` so that Spack uses a CUDA provided by ABCI.
Line #2 installs OpenMPI 3.1.1 as the same configuration with [this page](https://docs.abci.ai/en/appendix1/#open-mpi).
Meanings of the installation options are as follows.

- `+cuda`: Build with CUDA support
- `schedulers=sge`: Specify how to invoke MPI processes.  We specify `sge` as ABCI uses Univa Grid Engine which is compatible with SGE.
- `fabrics=auto`: Specify a communication library.
- `^cuda@abci-10.1.243`: Specify a CUDA to be used.  `^` is used to specify software dependency.

Line #4 edits a configuration file to turn off runtime warnings (optional).
For this purpose, Line #3 checks the installation path of OpenMPI.

Spack can manage variants of the same software.
Here, we additionally install OpenMPI 3.1.1 that uses CUDA 9.0.176.4.
```
[username@g0001 ~]$ spack install cuda@abci-9.0.176.4
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@abci-9.0.176.4
```

#### How to Use {#how-to-use}

This is an example of using "OpenMPI 3.1.1 that uses CUDA 10.1.243" installed above.

As we installed two OpenMPI 3.1.1, we can observe the following modules.
```
[username@es1 ~]$ module avail openmpi
------------------------- $HOME/spack/share/spack/modules/linux-centos7-haswell -------------------------
openmpi-3.1.1-gcc-4.8.5-4mmghhf             openmpi-3.1.1-gcc-4.8.5-zqwwrqy
(snip)
```

First of all, we have to identify an OpenMPI module we want to use.
The name of a module created by Spack includes the following five attributes: (1) name of software, (2) version of software, (3) compiler used to build, (4) version of the compiler and (5) hash of the built software.
We have to identify the module by (5) hash because all (1) to (4) are same in this case.

We can get the hash of OpenMPI that uses CUDA 10.1.243 by checking the dependencies.
```
[username@es1 ~]$ spack find -dl openmpi
==> 2 installed packages
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
4mmghhf openmpi@3.1.1
glgpfmf     hwloc@1.11.11
6ddc273         cuda@abci-10.1.243
(snip)

zqwwrqy openmpi@3.1.1
b4gs3k5     hwloc@1.11.11
l6ayrkp         cuda@abci-9.0.176.4
(snip)
```

We can find that OpenMPI having hash `4mmghhf` is what we want, and we need to use a module named `openmpi-3.1.1-gcc-4.8.5-4mmghhf`.

To build an MPI program using the above OpenMPI, we need to load a CUDA module provided by ABCI and the  OpenMPI module.
```
source ${HOME}/spack/share/spack/setup-env.sh
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ module load openmpi-3.1.1-gcc-4.8.5-4mmghhf
[username@g0001 ~]$ mpicc ...
```

A job script that runs the built MPI program is as follows.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load cuda/10.1/10.1.243
module load openmpi-3.1.1-gcc-4.8.5-4mmghhf

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIOPTS="-n ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -x PATH -x LD_LIBRARY_PATH"
mpiexec ${MPIOPTS} YOUR_PROGRAM
```

If we no more use the OpenMPI, we can uninstall it by specifying its hash.
```
[username@es1 ~]$ spack uninstall /4mmghhf
```


### CUDA-aware MVAPICH2 {#cuda-aware-mvapich2}

MVAPICH2 modules provided by ABCI does not support CUDA.
If you want to use CUDA-aware MVAPICH2, install by yourself referring to the documents below.

We use a compute node to build MVAPICH2.
As with [OpenMPI](#example_openmpi), we first install CUDA and then install MVAPICH2 by enabling CUDA (`+cuda`) and specifying a communication library (`fabrics=mrail`) and CUDA dependency (`^cuda@abci-10.1.243`).
```
[username@g0001 ~]$ spack install cuda@abci-10.1.243
[username@g0001 ~]$ spack install mvapich2@2.3 +cuda fabrics=mrail ^cuda@abci-10.1.243
```

To use CUDA-aware MVAPICH2, as with OpenMPI, load CUDA and installed MVAPICH2.
Here is a job script example.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load cuda/10.1/10.1.243
module load mvapich2-2.3-gcc-4.8.5-wy2qkke

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIE_ARGS="-genv MV2_USE_CUDA=1"
MPIOPTS="${MPIE_ARGS} -np ${NUM_PROCS} -ppn ${NUM_GPUS_PER_NODE}"

mpiexec ${MPIOPTS} YOUR_PROGRAM
```


### MPIFileUtils {#mpifileutils}

[MPIFileUtils](https://hpc.github.io/mpifileutils/) a file transfer tool for supercomputers that use MPI.
Although manually installing it is messy as it depends on many libraries, using Spack enables an easy install of MPIFileUtils.

The following example installs MPIFileUtils by using OpenMPI 2.1.6 provided by ABCI.
Line #1 installs OpenMPI to be used, and Line #2 installs MPIFileUtils by specifying a dependency for it.
```
[username@es1 ~]$ spack install openmpi@abci-2.1.6-nocuda
[username@es1 ~]$ spack install mpifileutils ^openmpi@abci-2.1.6-nocuda
```

To use MPIFileUtils, we have to load modules for OpenMPI 2.1.6 and MPIFileUtils.
When we load MPIFileUtils module, PATH to program, such as `dbcast` is set.
This is an example job script.
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load openmpi/2.1.6
module load mpifileutils-0.9.1-gcc-4.8.5-qdv7523

NPPN=5
NMPIPROC=$(( $NHOSTS * $NPPN ))
SRC_FILE=name_of_file
DST_FILE=name_of_file

mpiexec -n ${NMPIPROC} -map-by ppr:${NPPN}:node dbcast $SRC_FILE $DST_FILE
```

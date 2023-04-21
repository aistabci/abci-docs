# Software Management by Spack

[Spack](https://spack.io/) is a software package manager for supercomputers developed by Lawrence Livermore National Laboratory.
By using Spack, you can easily install software packages by changing their versions, configurations and compilers, and then select necessary one them when you use.
Using Spack on ABCI enables easily installing software which is not officially supported by ABCI.

!!! note
    We tested Spack using bash on March 31 2023, and we used Spack 0.19.1 which was the latest version at that time.

!!! caution
    - Spack installs software packaged in its original format which is not compatible with packages provided by any Linux distributions, such as `.deb` and `.rpm`.  Therefore, Spack is not a replacement of `yum` or `apt` system.

    - Spack installs software under a directory where Spack was installed.  Manage software installed by Sapck by yourself, for example, by uninstalling unused software, because Spack consumes large amount of disk space if you install many software.
    
    - Because of the difference of OS of Compute Node (V) and Compute Node (A), the instruction below for installing Spack enables you to use only one type of node.  Please select a node type you want to use Spack.  Please note that examples in this document show results on Compute Node (V).


## Setup Spack {#setup-spack}

### Install {#install}

You can install Spack by cloning from GitHub and checking out the version you want to use.

```Console
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.19.1
```

After that, you can use Spack by loading a setup shell script.

```Console
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

### Configuration for ABCI {#configuration-for-abci}

#### Adding Compilers {#adding-compilers}

First, register the compiler to be used in Spack by `spack compiler find` command.

```Console
[username@es1 ~]$ spack compiler find
==> Added 2 new compilers to ${HOME}/.spack/linux/compilers.yaml
    gcc@8.5.0  clang@13.0.1
==> Compilers are defined in the following files:
    ${HOME}/.spack/linux/compilers.yaml
```

`spack compiler list` command shows registered compilers.

GCC 8.5.0 is located in the default path (/usr/bin), so automatically detected and registered.

```Console
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@4.8.5  gcc@4.4.7
```

ABCI provides a pre-configured compiler definition file for Spack, `compilers.yaml`.
Copying this file to your environment sets up GCC to be used in Spack.

Compute Node (V)

```Console
[username@es1 ~]$ cp /apps/spack/vnode/compilers.yaml ${HOME}/.spack/linux/
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5
```

Compute Node (A)

```Console
[username@es-a1 ~]$ cp /apps/spack/anode/compilers.yaml ${HOME}/.spack/linux/
[username@es-a1 ~]$ spack compiler list
==> Available compilers
-- gcc rhel8-x86_64 ---------------------------------------------
gcc@12.2.0  gcc@8.3.1
```



#### Adding ABCI Software {#adding-abci-software}

Spack automatically resolves software dependencies and installs dependant software.
Spack, by default, installs another copies of software which is already supported by ABCI, such as CUDA and OpenMPI.
As it is a waste of disk space, we recommend to configure Spack to *refer to* software supported by ABCI.

Software referred by Spack can be defined in the configuration file `$HOME/.spack/linux/packages.yaml`.
ABCI provides a pre-configured `packages.yaml` which defines mappings of Spack package and software installed on ABCI.
Copying this file to your environment lets Spack use installed CUDA, OpenMPI, cmake and etc.

Compute Node (V)

```Console
[username@es1 ~]$ cp /apps/spack/vnode/packages.yaml ${HOME}/.spack/linux/
```

Compute Node (A)

```Console
[username@es-a1 ~]$ cp /apps/spack/anode/packages.yaml ${HOME}/.spack/linux/
```



packages.yaml (excerpt)

```yaml
packages:
  cuda:
    buildable: false
    externals:
(snip)
    - spec: cuda@11.7.1%gcc@8.5.0
      modules:
      - cuda/11.7/11.7.1
    - spec: cuda@11.7.1%gcc@12.2.0
      modules:
      - cuda/11.7/11.7.1
(snip)
  hpcx-mpi:
    externals:
    - spec: hpcx@2.11%gcc@8.5.0
      prefix: /apps/openmpi/2.11/gcc8.5.0
(snip)
```

After you copy this file, when you let Spack install CUDA version 11.7.1, it use `cuda/11.7/11.7.1` environment module, instead of installing another copy of CUDA.
`buildable: false` defined under CUDA section prohibits Spack to install other versions of CUDA specified here.
If you let Spack install versions of CUDA which are not supported by ABCI, remove this directive.

Please refer to [the official document](https://spack.readthedocs.io/en/latest/build_settings.html) for detail about `packages.yaml`.


## Basic of Spack {#basic-of-spack}

Here is the Spack basic usage.
For detail, please refer to [the official document](https://spack.readthedocs.io/en/latest/basic_usage.html).

### Compiler Operations {#compiler-operations}

`compiler list` sub-command shows the list of compilers registered to Spack.

```Console
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc rhel8-x86_64 ---------------------------------------------
gcc@12.2.0  gcc@8.3.1
```

`compiler info` sub-command shows the detail of a specific compiler.

```Console
sername@es1 ~]$ spack compiler info gcc@8.5.0
gcc@8.5.0:
        paths:
             cc = /usr/bin/gcc
             cxx = /usr/bin/g++
             f77 = /usr/bin/gfortran
             fc = /usr/bin/gfortran
        modules  = []
        operating system  = rocky8
```

### Software Management Operations {#software-management-operations}

#### Install {#install-openmpi}

The default version of OpenMPI can be installed as follows.
Refer to [Example Software Installation](#cuda-aware-openmpi) for options.

```Console
[username@es1 ~]$ spack install openmpi schedulers=sge fabrics=auto
```

If you want to install a specific version, use `@` to specify the version.

```Console
[username@es1 ~]$ spack install openmpi@4.1.3 schedulers=sge fabrics=auto
```

The compiler to build the software can be specified by `%`.
The following example use GCC 12.2.0 for building OpenMPI.

```Console
[username@es1 ~]$ spack install openmpi@4.1.3 %gcc@12.2.0 schedulers=sge fabrics=auto
```

#### Uninstall {#uninstall}

`uninstall` sub-command uninstalls installed software.
As with installation, you can uninstall software by specifying a version.

```Console
[username@es1 ~]$ spack uninstall openmpi
```

Each software package installed by Spack has a hash, and you can also uninstall a software by specifying a hash.
Specify `/` followed by a hash.
You can get a hash of an installed software by `find` sub-command shown in [Information](#information).

```Console
[username@es1 ~]$ spack uninstall /ffwtsvk
```

To uninstall all the installed software, type as follows.

```Console
[username@es1 ~]$ spack uninstall --all
```

#### Information {#information}

`list` sub-command shows all software which can be installed by Spack.

```Console
[username@es1 ~]$ spack list
abinit
abyss
(snip)
```

By specifying a keyword, it only shows software related to the keyword.
The following example uses `mpi` as the keyword.

```Console
[username@es1 ~]$ spack list mpi
compiz                          intel-oneapi-mpi  mpir               r-rmpi
cray-mpich                      mpi-bash          mpitrampoline      rempi
exempi                          mpi-serial        mpiwrapper         rkt-compiler-lib
fujitsu-mpi                     mpibind           mpix-launch-swift  spectrum-mpi
hpcx-mpi                        mpich             openmpi            spiral-package-mpi
intel-mpi                       mpifileutils      pbmpi              sst-dumpi
intel-mpi-benchmarks            mpilander         phylobayesmpi      umpire
intel-oneapi-compilers          mpileaks          pnmpi              vampirtrace
intel-oneapi-compilers-classic  mpip              py-mpi4py          wi4mpi
==> 36 packages
```

`find` sub-command shows all the installed software.

```Console
[username@es1 ~]$ spack find
==> 49 installed packages
-- linux-rocky8-skylake_avx512 / gcc@8.5.0 ----------------------------
autoconf@2.69    gdbm@1.18.1          libxml2@2.9.9  readline@8.0
(snip)
```

Adding `-dl` option to `find` sub-command shows hashes and dependencies of installed software.

```Console
[username@es1 ~]$ spack find -dl openmpi
-- linux-rocky8-skylake_avx512 / gcc@8.5.0 ---------------------
6pxjftg openmpi@4.1.4
ahftjey     hwloc@2.8.0
vf52amo         cuda@11.8.0
edtwt6g         libpciaccess@0.16
bt74u75         libxml2@2.10.1
qazxaa4             libiconv@1.16
jb22kvg             xz@5.2.7
pkmj6e7             zlib@1.2.13
2dq7ece         numactl@2.0.14
```

To see the detail about a specific software, use `info` sub-command.

```Console
[username@es1 ~]$ spack info openmpi
AutotoolsPackage:   openmpi

Description:
    An open source Message Passing Interface implementation. The Open MPI
    Project is an open source Message Passing Interface implementation that
(snip)
```

`versions` sub-command shows avaitable versions for a specific software.

```Console
[username@es1 ~]$ spack versions openmpi
==> Safe versions (already checksummed):
  main   4.0.4  3.1.2  2.1.6  2.0.2   1.10.1  1.8.1  1.6.4  1.5.1  1.3.3  1.2.4  1.1.1
  4.1.4  4.0.3  3.1.1  2.1.5  2.0.1   1.10.0  1.8    1.6.3  1.5    1.3.2  1.2.3  1.1
  4.1.3  4.0.2  3.1.0  2.1.4  2.0.0   1.8.8   1.7.5  1.6.2  1.4.5  1.3.1  1.2.2  1.0.2
  4.1.2  4.0.1  3.0.5  2.1.3  1.10.7  1.8.7   1.7.4  1.6.1  1.4.4  1.3    1.2.1  1.0.1
  4.1.1  4.0.0  3.0.4  2.1.2  1.10.6  1.8.6   1.7.3  1.6    1.4.3  1.2.9  1.2    1.0
  4.1.0  3.1.6  3.0.3  2.1.1  1.10.5  1.8.5   1.7.2  1.5.5  1.4.2  1.2.8  1.1.5
  4.0.7  3.1.5  3.0.2  2.1.0  1.10.4  1.8.4   1.7.1  1.5.4  1.4.1  1.2.7  1.1.4
  4.0.6  3.1.4  3.0.1  2.0.4  1.10.3  1.8.3   1.7    1.5.3  1.4    1.2.6  1.1.3
  4.0.5  3.1.3  3.0.0  2.0.3  1.10.2  1.8.2   1.6.5  1.5.2  1.3.4  1.2.5  1.1.2
==> Remote versions (not yet checksummed):
  4.1.5
```


### Use of Installed Software {#use-of-installed-software}

Software installed with Spack is available with the `spack load` command.
Like the module provided by ABCI, the installed software can be be loaded and used.

```Console
[username@es1 ~]$ spack load xxxxx
```

`spack load` sets environment variables, such as `PATH`, `MANPATH`, `CPATH`, `LD_LIBRARY_PATH`, so that the software can be used.

If you no more use, type `spack unload` to unset the variables.

```Console
[username@es1 ~]$ spack unload xxxxx
```

### Using Environments {#using-environments}

Spack has an *environment* feature in which you can group installed software.
You can install software with different versions and dependencies in each environment, and can change software to use at once by changing environments.

You can create a Spack environment by `spack env create` command.
You can create multiple environments by specifying different environment names here.

```Console
[username@es1 ~]$ spack env create myenv
```

To activate the created environment, type `spack env activate`.
Adding `-p` option will display the current activated environment on your console.
Then, install software you need to the activated environment.

```Console
[username@es1 ~]$ spack env activate -p myenv
[myenv] [username@es1 ~]$ spack install xxxxx
```

You can deactivate the environment by `spack env deactivate`.
To switch to another environment, type `spack env activate` to activate it.

```Console
[myenv] [username@es1 ~]$ spack env deactivate
[username@es1 ~]$
```

Use `spack env list` to display the list of created Spack environments.

```Console
[username@es1 ~]$ spack env list
==> 2 environments
    myenv
    another_env
```


## Example of Use

### CUDA-aware OpenMPI {#cuda-aware-openmpi}

#### How to Install {#how-to-install}

This is an example of installing OpenMPI 4.1.4 that uses CUDA 11.8.0.
You have to use a compute node to install it.

```Console
[username@g0001 ~]$ spack install cuda@11.8.0
[username@g0001 ~]$ spack install openmpi@4.1.4 +cuda schedulers=sge fabrics=auto ^cuda@11.8.0
[username@g0001 ~]$ spack find --paths openmpi@4.1.4
==> 1 installed package
-- linux-rocky8-skylake_avx512 / gcc@8.5.0 ----------------------------
openmpi@4.1.4  ${SPACK_ROOT}/opt/spack/linux-rocky8-skylake_avx512/gcc-8.5.0/openmpi-4.1.4-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v
[username@g0001 ~]$ echo "btl_openib_warn_default_gid_prefix = 0" >> ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-8.5.0/openmpi-4.1.4-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v/etc/openmpi-mca-params.conf
```

Line #1 installs CUDA version `11.8.0` so that Spack uses a CUDA provided by ABCI.
Line #2 installs OpenMPI 4.1.4 as the same configuration with [Configuration of Installed Software](../appendix/installed-software.md#open-mpi).
Meanings of the installation options are as follows.

- `+cuda`: Build with CUDA support
- `schedulers=sge`: Specify how to invoke MPI processes.  You have to specify `sge` as ABCI uses Altair Grid Engine which is compatible with SGE.
- `fabrics=auto`: Specify a communication library.
- `^cuda@11.8.0`: Specify a CUDA to be used.  `^` is used to specify software dependency.

Line #4 edits a configuration file to turn off runtime warnings (optional).
For this purpose, Line #3 checks the installation path of OpenMPI.

Spack can manage variants of the same version of software.
This is an example that you additionally install OpenMPI 4.1.3 that uses CUDA 11.7.1.

```Console
[username@g0001 ~]$ spack install cuda@11.7.1
[username@g0001 ~]$ spack install openmpi@4.1.3 +cuda schedulers=sge fabrics=auto ^cuda@11.7.1
```

#### How to Use {#how-to-use}

This is an example of using "OpenMPI 4.1.4 that uses CUDA 11.8.0" installed above.
Specify the version of OpenMPI and CUDA dependency to load the software.

```Console
[username@es1 ~]$ spack load openmpi@4.1.4 ^cuda@11.8.0
```

To build an MPI program using the above OpenMPI, you need to load OpenMPI installed by Spack .

```Console
[username@g0001 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
[username@g0001 ~]$ spack load openmpi@4.1.4 ^cuda@11.8.0
[username@g0001 ~]$ mpicc ...
```

A job script that runs the built MPI program is as follows.

```shell
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load openmpi@4.1.4 ^cuda@11.8.0

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIOPTS="-n ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -x PATH -x LD_LIBRARY_PATH"
mpiexec ${MPIOPTS} YOUR_PROGRAM
```

If you no more use the OpenMPI, you can uninstall it by specifying the version and dependencies.

```Console
[username@es1 ~]$ spack uninstall openmpi@4.1.4 ^cuda@11.8.0
```


### CUDA-aware MVAPICH2 {#cuda-aware-mvapich2}

If you want to use CUDA-aware MVAPICH2, install by yourself referring to the documents below.

You have to use a compute node to build CUDA-aware MVAPICH2.
As with [OpenMPI](#cuda-aware-openmpi) above, you first install CUDA and then install MVAPICH2 by enabling CUDA (`+cuda`) and specifying a communication library (`fabrics=mrail`) and CUDA dependency (`^cuda@11.8.0`).

```Console
[username@g0001 ~]$ spack install cuda@11.8.0
[username@g0001 ~]$ spack install mvapich2@2.3.7 +cuda fabrics=mrail ^cuda@11.8.0
```

To use CUDA-aware MVAPICH2, as with OpenMPI, load modules of a CUDA and the installed MVAPICH2.
Here is a job script example.

```shell
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mvapich2@2.3.7 ^cuda@11.8.0

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

The following example installs MPIFileUtils that uses OpenMPI 4.1.4.
Line #1 installs OpenMPI, and Line #2 installs MPIFileUtils by specifying a dependency on OpenMPI.

```Console
[username@es1 ~]$ spack install openmpi@4.1.4
[username@es1 ~]$ spack install mpifileutils ^openmpi@4.1.4
```

To use MPIFileUtils, you have to load modules of OpenMPI 4.1.4 and MPIFileUtils.
When you load MPIFileUtils module, PATH to program, such as `dbcast` is set.
This is an example job script.

```shell
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mpifileutils@0.11.1 ^openmpi@4.1.4

NPPN=5
NMPIPROC=$(( $NHOSTS * $NPPN ))
SRC_FILE=name_of_file
DST_FILE=name_of_file

mpiexec -n ${NMPIPROC} -map-by ppr:${NPPN}:node dbcast $SRC_FILE $DST_FILE
```

### Build Singularity Image from Environment {#build-singularity-image-from-environment}

You can create a Singularity image from a Spack environment created referring [Using environments](#using-environments).
The following example creates an environment named `myenv`, installs CUDA-aware OpenMPI and creates a Singularity image from the environment.

```Console
[username@es1 ~]$ spack env create myenv
[username@es1 ~]$ spack activate -p myenv
[myenv] [username@es1 ~]$ openmpi +cuda schedulers=sge fabrics=auto
[username@es1 ~]$ cp -p ${HOME}/spack/var/spack/environments/myenv/spack.yaml .
[username@es1 ~]$ vi spack.yaml
```

Edit `spack.yaml` as follows.

```yaml
# This is a Spack Environment file.
#
# It describes a set of packages to be installed, along with
# configuration settings.
spack:
  # add package specs to the `specs` list
  specs: [openmpi +cuda fabrics=auto schedulers=sge]
  view: true                       # <- Delete this line

  container:                       # <- Add this line
    images:                        # <- Add this line
      build: spack/centos7:0.19.1  # <- Add this line
      final: spack/centos7:0.19.1  # <- Add this line
    format: singularity            # <- Add this line
    strip: false                   # <- Add this line
```

Create a Singularity recipe file (myenv.def) from `spack.yaml` using `spack containerize`.

```Console
[username@es1 ~]$ spack containerize > myenv.def
```

To create a Singularity image from the generated recipe file on ABCI, please refer to [Create a Singularity image (build)](../containers.md#create-a-singularity-image-build).

# Environment Modules

The ABCI system offers various development environments, MPIs, libraries, utilities, etc. listed in [Software](system-overview.md#software). And, users can use these software in combination as *module*s.

[Environment Modules](http://modules.sourceforge.net/) allows users to configure their environment settings, flexibly and dynamically, required to use these *module*s.

## Usage

Users can configure their environment using the `module` command:

```
$ module [options] <sub-command> [sub-command options]
```

The following is a list of sub-commands.

| Sub-command | Description |
|:--|:--|
| list | List loaded modules |
| avail | List all available modules |
| show *module* | Display the configuration of "*module*" |
| load *module* | Load a module named "*module*" into the environment |
| unload *module* | Unload a module named "*module*" from the environment |
| switch *moduleA* *moduleB* | Switch loaded "*moduleA*" with "*moduleB*" |
| purge | Unload all loaded modules (Initialize) |
| help *module* | Print the usage of "*module*" |

## Use cases

### Loading modules

```
[username@login1 ~]$ module load cuda/12.6/12.6.1 cudnn/9.5/9.5.1
```

### List loaded modules

```
[username@login1 ~]$ module list
Currently Loaded Modulefiles:
 1) cuda/12.6/12.6.1   2) cudnn/9.5/9.5.1
```

### Display the configuration of modules

```
[username@login1 ~]$ module show cuda/12.6/12.6.1
-------------------------------------------------------------------
/apps/modules/modulefiles/rhel9/gpgpu/cuda/12.6/12.6.1:

module-whatis   {cuda 12.6.1}
conflict        cuda
prepend-path    CUDA_HOME /apps/cuda/12.6.1
prepend-path    CUDA_PATH /apps/cuda/12.6.1
prepend-path    PATH /apps/cuda/12.6.1/bin
prepend-path    LD_LIBRARY_PATH /apps/cuda/12.6.1/extras/CUPTI/lib64
prepend-path    LD_LIBRARY_PATH /apps/cuda/12.6.1/lib64
prepend-path    CPATH /apps/cuda/12.6.1/extras/CUPTI/include
prepend-path    CPATH /apps/cuda/12.6.1/include
prepend-path    LIBRARY_PATH /apps/cuda/12.6.1/lib64
prepend-path    MANPATH /apps/cuda/12.6.1/doc/man
prepend-path    PATH /apps/cuda/12.6.1/gds/tools
prepend-path    MANPATH /apps/cuda/12.6.1/gds/man
-------------------------------------------------------------------
```

### Unload all loaded modules (Initialize)

```
[username@login1 ~]$ module purge
[username@login1 ~]$ module list
No Modulefiles Currently Loaded.
```

### Load dependent modules

```
[username@login1 ~]$ module load cudnn/9.5/9.5.1
WARNING: cudnn/9.5/9.5.1 cannot be loaded due to missing prereq.
HINT: the following modules must be loaded first: cuda/12.6

Loading cudnn/9.5/9.5.1
  ERROR: Module evaluation aborted
```

Because of dependencies, you cannot load `cudnn/9.5/9.5.1` without first loading `cuda/12.6`.

```
[username@login1 ~]$ module load cuda/12.6/12.6.1
[username@login1 ~]$ module load cudnn/9.5/9.5.1
```

### Load exclusive modules

Modules that are in an exclusive relationship, such as modules of different versions of the same library, cannot be used at the same time.

```
[username@login1 ~]$ module load cuda/12.5/12.5.1
[username@login1 ~]$ module load cuda/12.6/12.6.1
Loading cuda/12.6/12.6.1
  ERROR: Module cannot be loaded due to a conflict.
    HINT: Might try "module unload cuda" first.
```

### Switch modules 

```
[username@login1 ~]$ module load cuda/12.5/12.5.1
[username@login1 ~]$ module switch cuda/12.5/12.5.1 cuda/12.6/12.6.1
```


## Usage in a job script

When using the `module` command in a job script for a batch job, it is necessary to add initial settings as follows.

sh, bash:

```
source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
```

csh, tcsh:

```
source /etc/profile.d/modules.csh
module load cuda/12.6/12.6.1
```

## List of modules {#modules-table}

Currently, following modules are available.

| Category        | Software        | Version  |
|:--|:--|:--|
| compiler        | gcc             | 13.2.0   |
|                 | intel           | 2024.2.1 |
|                 | nvhpc           | 24.9     |
| devtools        | code-server     | 4.100.2  |
|                 | intel-advisor   | 2024.2.1 |
|                 | intel-inspector | 2024.2   |
|                 | intel-itac      | 2022.4   |
|                 | intel-mkl       | 2024.2.1 |
|                 | intel-vtune     | 2024.2.1 |
|                 | julia           | 1.11.1   |
|                 | novnc           | 1.6.0    |
|                 | python          | 3.12/3.12.9 , 3.13/3.13.2 |
|                 | scala           | 3.5.2    |
|                 | turbovnc        | 3.1.4    |
| gpgpu           | cuda            | 11.8.0 , 12.0.1 , 12.1.1 , 12.2.2 , 12.3.2 , 12.4.1 , 12.5.1 , 12.6.1 , 12.8.1 , 12.9.1 |
|                 | cudnn           | 9.5/9.5.1 , 9.12/9.12.0 |
|                 | nccl            | 2.23/2.23.4-1 , 2.25/2.25.1-1 |
| mpi             | hpcx            | 2.20     |
|                 | hpcx-debug      | 2.20     |
|                 | hpcx-mt         | 2.20     |
|                 | hpcx-prof       | 2.20     |
|                 | intel-mpi       | 2021.13  |
| utils           | aws-cli         | 1.29.62  |
|                 | gdrcopy         | 2.4.1    |
|                 | singularitypro  | 4.1.7    |

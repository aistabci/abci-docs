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

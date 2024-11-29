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
[username@login1 ~]$ module load cuda/11.7/11.7.1 cudnn/8.4/8.4.1
```

### List loaded modules

```
[username@login1 ~]$ module list
Currently Loaded Modulefiles:
 1) cuda/11.7/11.7.1   2) cudnn/8.4/8.4.1
```

### Display the configuration of modules

```
[username@login1 ~]$ module show cuda/11.7/11.7.1
-------------------------------------------------------------------
/apps/modules/modulefiles/rocky8/gpgpu/cuda/11.7/11.7.1:

module-whatis   {cuda 11.7.1}
conflict        cuda
prepend-path    CUDA_HOME /apps/cuda/11.7.1
prepend-path    CUDA_PATH /apps/cuda/11.7.1
prepend-path    PATH /apps/cuda/11.7.1/bin
prepend-path    LD_LIBRARY_PATH /apps/cuda/11.7.1/extras/CUPTI/lib64
prepend-path    LD_LIBRARY_PATH /apps/cuda/11.7.1/lib64
prepend-path    CPATH /apps/cuda/11.7.1/extras/CUPTI/include
prepend-path    CPATH /apps/cuda/11.7.1/include
prepend-path    LIBRARY_PATH /apps/cuda/11.7.1/lib64
prepend-path    MANPATH /apps/cuda/11.7.1/doc/man
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
[username@login1 ~]$ module load cudnn/8.4/8.4.1
WARNING: cudnn/8.4/8.4.1 cannot be loaded due to missing prereq.
HINT: at least one of the following modules must be loaded first: cuda/10.2 cuda/11.0 cuda/11.1 cuda/11.2 cuda/11.3 cuda/11.4 cuda/11.5 cuda/11.6 cuda/11.7

Loading cudnn/8.4/8.4.1
  ERROR: Module evaluation aborted
```

Because of dependencies, you cannot load `cudnn/8.4/8.4.1` without first loading one of the modules from `cuda/10.2` or `cuda/11.0` to `cuda/11.7`.

```
[username@login1 ~]$ module load cuda/11.7/11.7.1
[username@login1 ~]$ module load cudnn/8.4/8.4.1
```

### Load exclusive modules

Modules that are in an exclusive relationship, such as modules of different versions of the same library, cannot be used at the same time.

```
[username@login1 ~]$ module load cuda/11.7/11.7.1
[username@login1 ~]$ module load cuda/12.0/12.0.0
Loading cuda/12.0/12.0.0
  ERROR: cuda/12.0/12.0.0 cannot be loaded due to a conflict.
    HINT: Might try "module unload cuda" first.
```

### Switch modules (Under Update)

```
[username@login1 ~]$ module load cuda/11.7/11.7.1
[username@login1 ~]$ module switch cuda/11.7/11.7.1 cuda/12.0/12.0.0
```

Switching may not be successful if there are dependencies.

```
[username@login1 ~]$ module load cuda/11.0/11.0.3
[username@login1 ~]$ module load cudnn/8.4/8.4.1
[username@login1 ~]$ module switch cuda/11.0/11.0.3 cuda/11.2/11.2.2
[username@login1 ~]$ echo $LD_LIBRARY_PATH
/apps/cuda/11.2.2/lib64:/apps/cuda/11.2.2/extras/CUPTI/lib64:/apps/cudnn/8.4.1/cuda11.0/lib64
```

CUDA 11.2 and cuDNN for CUDA 11.0 are loaded.


In this case, unload the modules that depend on the target module in advance and load them again after switching.

```
[username@login1 ~]$ module load cuda/11.0/11.0.3 cudnn/8.4/8.4.1
[username@login1 ~]$ module unload cudnn/8.4/8.4.1
[username@login1 ~]$ module switch cuda/11.0/11.0.3 cuda/11.2/11.2.2
[username@login1 ~]$ module load cudnn/8.4/8.4.1
[username@login1 ~]$ echo $LD_LIBRARY_PATH
/apps/cudnn/8.4.1/cuda11.2/lib64:/apps/cuda/11.2.2/lib64:/apps/cuda/11.2.2/extras/CUPTI/lib64
```

## Usage in a job script

When using the `module` command in a job script for a batch job, it is necessary to add initial settings as follows.

sh, bash:

```
source /etc/profile.d/modules.sh
module load cuda/10.2/10.2.89
```

csh, tcsh:

```
source /etc/profile.d/modules.csh
module load cuda/10.2/10.2.89
```

# Containers

ABCI allows users to create an application execution environment using Singularity containers.
This allows users to create their own customized environments or build and compute equivalent environments on ABCI based on container images officially distributed by external organizations.

For example, the [NGC Catalog](https://catalog.ngc.nvidia.com/) provides container images of various deep learning frameworks, CUDA and HPC environments.

You can also download container images on which the latest software is installed from official or verified repositories on Docker Hub.
However, be aware not to use untrusted container images.
The followings are examples.

* [AWS CLI](https://hub.docker.com/r/amazon/aws-cli)
* [TensorFlow](https://hub.docker.com/r/tensorflow/tensorflow)
* [PyTorch](https://hub.docker.com/r/pytorch/pytorch)
* [Python](https://hub.docker.com/_/python)

## Singularity

[Singularity](https://www.sylabs.io/singularity/) is available on the ABCI System.
Available version is SingularityCE 4.1.

More comprehensive user guide for Singularity will be found:

* [SingularityCE User Guide](https://docs.sylabs.io/guides/4.1/user-guide/)

### Create a Singularity image (pull)

Singularity container image can be stored as a file.
This procedure shows how to create a Singularity image file using `pull`.

Example) Create a Singularity image file using `pull`
```
[username@login1 ~]$ singularity pull tensorflow.sif docker://tensorflow/tensorflow:latest-gpu
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
...
[username@login1 ~]$ ls tensorflow.sif
tensorflow.sif
```

### Create a Singularity image (build)

!!! warning
    When using the `fakeroot` option, only node-local areas (such as /tmp or $PBS_LOCALDIR) can be specified for the `SINGULARITY_TMPDIR` environment variable.
    Home area ($HOME), Group area (/groups/$YOUR_GROUP)  cannot be specified.

Example) Create a Singularity image file using `build`

```
[username@login1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@login1 ~]$ singularity build --fakeroot ubuntu.sif ubuntu.def
INFO:    Starting build...
(snip)
INFO:    Creating SIF file...
INFO:    Build complete: ubuntu.sif
[username@login1 singularity]$
```

If the output destination of the image file (ubuntunt.sif) is set to the group area in the above command, an error occurs. In this case, it is possible to avoid the problem by executing the `newgrp` command after checking the ownership group of the image destination group area with `id` command as follows.
In the example below, `gaa00000` is the owning group of the image destination group area.

```
[username@login1 groupname]$ id -a
uid=10000(aaa10000aa) gid=10000(aaa10000aa) groups=10000(aaa10000aa),50000(gaa50000)
[username@login1 groupname]$ newgrp gaa50000
```

### Running a container with Singularity

When you use Singularity, you need to start Singularity container using `singularity run` command in job script.
To run an image file in a container, specify the image file as an argument to the `singularity run` command.
You can also use the `singularity run` command to run a container image published in Docker Hub.

Example) Run a container with a Singularity image file in an interactive job

```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1 -l walltime=1:00:00
[username@hnode001 ~]$ singularity run --nv ./tensorflow.sif
```
Example) Run a container with a Singularity image file in a batch job

```
[username@login1 ~]$ cat job.sh
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
singularity exec --nv ./tensorflow.sif python3 sample.py

[username@login1 ~]$ qsub job.sh
```

Example) Run a container image published in Docker Hub

The following sample executes a Singularity container using TensorFlow container image published in Docker Hub.
`python3 sample.py` is executed in the container started by `singularity run` command.
The container image is downloaded at the first startup and cached in home area.
The second and subsequent times startup is faster by using cached data.

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1 -l walltime=1:00:00
[username@hnode001 ~]$ export SINGULARITY_TMPDIR=$PBS_LOCALDIR
[username@hnode001 ~]$ singularity run --nv docker://tensorflow/tensorflow:latest-gpu

________                               _______________
___  __/__________________________________  ____/__  /________      __
__  /  _  _ \_  __ \_  ___/  __ \_  ___/_  /_   __  /_  __ \_ | /| / /
_  /   /  __/  / / /(__  )/ /_/ /  /   _  __/   _  / / /_/ /_ |/ |/ /
/_/    \___//_/ /_//____/ \____//_/    /_/      /_/  \____/____/|__/


You are running this container as user with ID 10000 and group 10000,
which should map to the ID and group for your user on the Docker host. Great!

/sbin/ldconfig.real: Can't create temporary cache file /etc/ld.so.cache~: Read-only file system
Singularity> python3 sample.py
```
### Build Singularity image from Dockerfile

On ABCI, you cannot build a Singularity image directly from Dockerfile.
If you have only Dockerfile, you have two ways to build a Singularity image on ABCI.

#### Via Docker Hub

Build a Docker container image from Dockerfile on a system having Docker execution environment, and upload the image to Docker Hub. You can use the Docker container image on ABCI.

Following example shows how to build [SSD300 v1.1 image](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD) developed by NVIDIA from Dockerfile and upload it to Docker Hub.

```
[user@pc ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
[user@pc ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
[user@pc SSD]$ cat Dockerfile
ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:20.06-py3
FROM ${FROM_IMAGE_NAME}

# Set working directory
WORKDIR /workspace

ENV PYTHONPATH "${PYTHONPATH}:/workspace"

COPY requirements.txt .
RUN pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger.git#egg=dllogger
RUN pip install -r requirements.txt
RUN python3 -m pip install pycocotools==2.0.0

# Copy SSD code
COPY ./setup.py .
COPY ./csrc ./csrc
RUN pip install .

COPY . .
[user@pc SSD]$ docker build -t user/docker_name .
[user@pc SSD]$ docker login && docker push user/docker_name
```

To run the built image on ABCI, please refer to [Running a container with Singularity](#running-a-container-with-singularity)

#### Convert Dockerfile to Singularity recipe

By converting Dockerfile to Singularity recipe, you can build a Singularity container image which provides the same functionality defined in the Dockerfile on ABCI.
You can manually convert Dockerfile, but using [Singularity Python](https://singularityhub.github.io/singularity-cli/) helps the conversion.

!!! warning
    The conversion of Singularity Python is not perfect.
    If `singularity build` fails when the generated Singularity recipe file is used, modify the recipe file manually.

Example procedure for installing Singularity Python)

```
[username@login1 ~]$ python3 -m venv work
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ pip3 install spython
```

Following example shows how to convert Dockerfile of [SSD300 v1.1 image](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD) developed by NVIDIA using Singularity Python and modify the generated Singularity recipe (ssd.def) so that it can correctly generate a Singularity image.

Modifications)

- Files in WORKDIR will not be copied => Set the copy destination to the absolute path of WORKDIR

```
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
(work) [username@login1 ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
(work) [username@login1 SSD]$ spython recipe Dockerfile ssd.def
(work) [username@login1 SSD]$ cp -p ssd.def ssd_org.def
(work) [username@login1 SSD]$ vi ssd.def
Bootstrap: docker
From: nvcr.io/nvidia/pytorch:22.10-py3
Stage: spython-base

%files
requirements.txt /workspace/ssd/  #<- copy to WORKDIR directory.
. /workspace/ssd/                 #<- copy to WORKDIR directory.
%post
FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:22.10-py3

# Set working directory
mkdir -p /workspace/ssd
cd /workspace/ssd

# Copy the model files

# Install python requirements
pip install --no-cache-dir -r requirements.txt
mkdir models #<- Requires to run main.py

CUDNN_V8_API_ENABLED=1
TORCH_CUDNN_V8_API_ENABLED=1
%environment
export CUDNN_V8_API_ENABLED=1
export TORCH_CUDNN_V8_API_ENABLED=1
%runscript
cd /workspace/ssd
exec /bin/bash "$@"
%startscript
cd /workspace/ssd
exec /bin/bash "$@"
```

To create a Singularity image from the generated recipe file on ABCI, please refer to [Create a Singularity image (build)](#create-a-singularity-image-build).

### Examples of Singularity recipe files

This chapter shows examples of Singularity recipe files. See the [Singularity](#singularity) user guide for more information about the recipe file.

#### Including local files in the container image

This is an example of compiling Open MPI and local program files (C language) into a container image.
In this case, locate the Singularity recipe file (openmpi.def) and the program file (mpitest.c) in your home directory.

openmpi.def
```
Bootstrap: docker
From: ubuntu:latest

%files
    mpitest.c /opt

%environment
    export OMPI_DIR=/opt/ompi
    export SINGULARITY_OMPI_DIR=$OMPI_DIR
    export SINGULARITYENV_APPEND_PATH=$OMPI_DIR/bin
    export SINGULAIRTYENV_APPEND_LD_LIBRARY_PATH=$OMPI_DIR/lib

%post
    echo "Installing required packages..."
    apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file bzip2

    echo "Installing Open MPI"
    export OMPI_DIR=/opt/ompi
    export OMPI_VERSION=4.1.7
    export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$OMPI_VERSION.tar.bz2"
    mkdir -p /tmp/ompi
    mkdir -p /opt
    # Download
    cd /tmp/ompi && wget -O openmpi-$OMPI_VERSION.tar.bz2 $OMPI_URL && tar -xjf openmpi-$OMPI_VERSION.tar.bz2
    # Compile and install
    cd /tmp/ompi/openmpi-$OMPI_VERSION && ./configure --prefix=$OMPI_DIR && make install
    # Set env variables so we can compile our application
    export PATH=$OMPI_DIR/bin:$PATH
    export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
    export MANPATH=$OMPI_DIR/share/man:$MANPATH

    echo "Compiling the MPI application..."
    cd /opt && mpicc -o mpitest mpitest.c
```

mpitest.c
```
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
int main (int argc, char **argv) {
        int rc;
        int size;
        int myrank;

        rc = MPI_Init (&argc, &argv);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Init() failed\n");
                return EXIT_FAILURE;
        }

        rc = MPI_Comm_size (MPI_COMM_WORLD, &size);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Comm_size() failed\n");
                goto exit_with_error;
        }

        rc = MPI_Comm_rank (MPI_COMM_WORLD, &myrank);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Comm_rank() failed\n");
                goto exit_with_error;
        }

        fprintf (stdout, "Hello, I am rank %d/%d\n", myrank, size);

        MPI_Finalize();

        return EXIT_SUCCESS;

 exit_with_error:
        MPI_Finalize();
        return EXIT_FAILURE;
}
```

Use `singularity` command to build the container image. If successful, a container image (openmpi.sif) is generated.
```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1
[username@hnode001 ~]$ singularity build --fakeroot openmpi.sif openmpi.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: openmpi.sif
[username@hnode001 ~]$
```

Example) running the container
```
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ mpirun -hostfile $PBS_NODEFILE -np 4 -map-by node singularity exec --env OPAL_PREFIX=/opt/ompi --env PMIX_INSTALL_PREFIX=/opt/ompi openmpi.sif /opt/mpitest
Hello, I am rank 2/4
Hello, I am rank 3/4
Hello, I am rank 0/4
Hello, I am rank 1/4
```

#### Using the CUDA Toolkit

This is an example of running python on  [h2o4gpu](https://github.com/sylabs/examples/tree/eb713691a30cfd455e1de24cb014646bde404adb/machinelearning/h2o4gpu) with the CUDA Toolkit.
In this case, you will have a Singularity recipe file (h2o4gpuPy.def) and a validation script (h2o4gpu_sample.py) in your home directory.

h2o4gpuPy.def
```
BootStrap: docker
From: nvidia/cuda:12.1.0-devel-ubuntu18.04

# Note: This container will have only the Python API enabled

%environment
# -----------------------------------------------------------------------------------
    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    export LC_ALL=C

%post
# -----------------------------------------------------------------------------------
# this will install all necessary packages and prepare the contianer

    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64

    apt-get -y update
    apt-get install -y --no-install-recommends build-essential
    apt-get install -y --no-install-recommends git
    apt-get install -y --no-install-recommends vim
    apt-get install -y --no-install-recommends wget
    apt-get install -y --no-install-recommends ca-certificates
    apt-get install -y --no-install-recommends libjpeg-dev
    apt-get install -y --no-install-recommends libpng-dev
    apt-get install -y --no-install-recommends libpython3.6-dev
    apt-get install -y --no-install-recommends libopenblas-dev pbzip2
    apt-get install -y --no-install-recommends libcurl4-openssl-dev libssl-dev libxml2-dev
    apt-get install -y --no-install-recommends python3-pip
    apt-get install -y --no-install-recommends wget

    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python
    ln -s /usr/bin/pip3 /usr/bin/pip

    pip3 install setuptools
    pip3 install --upgrade pip

    wget https://s3.amazonaws.com/h2o-release/h2o4gpu/releases/stable/ai/h2o/h2o4gpu/0.4-cuda10/rel-0.4.0/h2o4gpu-0.4.0-cp36-cp36m-linux_x86_64.whl
    pip install h2o4gpu-0.4.0-cp36-cp36m-linux_x86_64.whl
```

h2o4gpu_sample.py
```
import h2o4gpu
import numpy as np
X = np.array([[1.,1.], [1.,4.], [1.,0.]])
model = h2o4gpu.KMeans(n_clusters=2,random_state=1234).fit(X)
print(model.cluster_centers_)
```

Use `singularity` command to build the container image. If successful, a container image (h2o4gpuPy.sif) is generated.
```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1
[username@hnode001 ~]$ singularity build --fakeroot h2o4gpuPy.sif h2o4gpuPy.def
INFO:    Starting build...
Getting image source signatures
(skip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: h2o4gpuPy.sif
[username@hnode001 ~]$
```

Example) running the container
```
[username@hnode001 ~]$ module load cuda/12.6
[username@hnode001 ~]$ singularity exec --nv h2o4gpuPy.sif python3 h2o4gpu_sample.py
[[1.  0.5]
 [1.  4. ]]
[username@hnode001 ~]$
```

### Environment Variables

Below are some of the environment variables available when executing the `singularity` command.

| Variable Name | Description |
|:--|:--|
| SINGULARITYENV\_CUDA_VISIBLE\_DEVICES | Control of GPUs available from Singularity |
| SINGULARITYENV\_LD\_LIBRARY\_PATH | The specified library paths outside the container are applied to the LD_LIBRARY_PATH inside the container |
| SINGULARITY\_TMPDIR | Path to the temporary directory |
| SINGULARITY\_BINDPATH | Bind mount a host system directory into the container |

!!! note
    By using SINGULARITYENV\_*MYVAR*, it is possible to pass any environment variable *MYVAR* into the container

Additionally, below are some of the environment variables available when using the `--nvccli` option

| Variable Name | Description |
|:--|:--|
| NVIDIA\_DRIVER\_CAPABILITIES | Function control in the container |
| NVIDIA\_REQUIRE\_* | Specify constraints for cuda, driver, arch, and brand |

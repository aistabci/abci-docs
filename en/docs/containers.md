# Containers

ABCI allows users to create an application execution environment using Singularity containers.
This allows users to create their own customized environments or build and compute equivalent environments on ABCI based on container images officially distributed by external organizations.

For example, the [NGC Catalog](https://catalog.ngc.nvidia.com/) provides container images of various deep learning frameworks, CUDA and HPC environments.
See [NVIDIA NGC](https://docs.abci.ai/ja/tips/ngc/)for tips on how to use the NGC Catalog with ABCI.

You can also download container images on which the latest software is installed from official or verified repositories on Docker Hub.
However, be aware not to use untrusted container images.
The followings are examples.

* [AWS CLI](https://hub.docker.com/r/amazon/aws-cli)
* [TensorFlow](https://hub.docker.com/r/tensorflow/tensorflow)
* [PyTorch](https://hub.docker.com/r/pytorch/pytorch)
* [Python](https://hub.docker.com/_/python)

## Singularity

[Singularity](https://www.sylabs.io/singularity/) is available on the ABCI System.
Available version is SingularityPRO 3.9.
To use Singularity, set up user environment by the `module` command.

```
[username@g0001 ~]$ module load singularitypro
```

More comprehensive user guide for Singularity will be found:

* [SingularityPRO User Guide](https://repo.sylabs.io/guides/pro-3.9/user-guide/)

To run NGC-provided Docker images on ABCI by using Singularity: [NVIDIA NGC](tips/ngc.md)

### Create a Singularity image (pull)

Singularity container image can be stored as a file.
This procedure shows how to create a Singularity image file using `pull`.

Example) Create a Singularity image file using `pull`

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ export SINGULARITY_TMPDIR=/scratch/$USER
[username@es1 ~]$ singularity pull tensorflow.img docker://tensorflow/tensorflow:latest-gpu
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
...
[username@es1 ~]$ ls tensorflow.img
tensorflow.img
```

The `SINGULARITY_TMPDIR` environment variable specifies the location where temporary files are created when the pull or build commands are executed.
Please refer to the FAQ ["I get an error due to insufficient disk space, when I ran the singularity build/pull on the compute node."](faq.md#q-insufficient-disk-space-for-singularity-build) for more information.

### Create a Singularity image (build)

In the SingularityPRO environment of the ABCI system, you can build container image files using `fakeroot` option.

!!! note
    In the SingularityPRO environment, you can also build container image file using remote build. See [ABCI Singularity Endpoint](abci-singularity-endpoint.md) for more information.

Example) Create a Singularity image file using `build`

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:20.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@es1 ~]$ export SINGULARITY_TMPDIR=/scratch/$USER
[username@es1 ~]$ singularity build --fakeroot ubuntu.sif ubuntu.def
INFO:    Starting build...
(snip)
INFO:    Creating SIF file...
INFO:    Build complete: ubuntu.sif
[username@es1 singularity]$
```

If the output destination of the image file (ubuntunt.sif) is set to the group area in the above command, an error occurs. In this case, it is possible to avoid the problem by executing the `newgrp` command after checking the ownership group of the image destination group area with `id` command as follows.
In the example below, `gaa00000` is the owning group of the image destination group area.

```
[username@es1 groupname]$ id -a
uid=0000(aaa00000aa) gid=0000(aaa00000aa) groups=0000(aaa00000aa),00000(gaa00000)
[username@es1 groupname]$ newgrp gaa00000
```

### Running a container with Singularity

When you use Singularity, you need to start Singularity container using `singularity run` command in job script.
To run an image file in a container, specify the image file as an argument to the `singularity run` command.
You can also use the `singularity run` command to run a container image published in Docker Hub.

Example) Run a container with a Singularity image file in an interactive job

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv ./tensorflow.img
```

Example) Run a container with a Singularity image file in a batch job

```
[username@es1 ~]$ cat job.sh
#!/bin/sh
#$-l rt_F=1
#$-j y
source /etc/profile.d/modules.sh
module load singularitypro

singularity run --nv ./tensorflow.img

[username@es1 ~]$ qsub -g grpname job.sh
```

Example) Run a container image published in Docker Hub

The following sample executes a Singularity container using TensorFlow container image published in Docker Hub.
`python3 sample.py` is executed in the container started by `singularity run` command.
The container image is downloaded at the first startup and cached in home area.
The second and subsequent times startup is faster by using cached data.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ export SINGULARITY_TMPDIR=$SGE_LOCALDIR
[username@g0001 ~]$ singularity run --nv docker://tensorflow/tensorflow:latest-gpu

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
[username@es1 ~]$ module load python/3.10
[username@es1 ~]$ python3 -m venv work
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ pip3 install spython
```

Following example shows how to convert Dockerfile of [SSD300 v1.1 image](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD) developed by NVIDIA using Singularity Python and modify the generated Singularity recipe (ssd.def) so that it can correctly generate a Singularity image.

Modifications)

- Files in WORKDIR will not be copied => Set the copy destination to the absolute path of WORKDIR

```
[username@es1 ~]$ module load python/3.10
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
(work) [username@es1 ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
(work) [username@es1 SSD]$ spython recipe Dockerfile ssd.def
(work) [username@es1 SSD]$ cp -p ssd.def ssd_org.def
(work) [username@es1 SSD]$ vi ssd.def
Bootstrap: docker
From: nvcr.io/nvidia/pytorch:21.05-py3
Stage: spython-base

%files
requirements.txt /workspace/ssd/  #<- copy to WORKDIR directory.
. /workspace/ssd/                 #<- copy to WORKDIR directory.
%post
FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:21.05-py3

# Set working directory
cd /workspace/ssd

# Install nv-cocoapi
COCOAPI_VERSION=2.0+nv0.6.0
export COCOAPI_TAG=$(echo ${COCOAPI_VERSION} | sed 's/^.*+n//') \
&& pip install --no-cache-dir pybind11                             \
&& pip install --no-cache-dir git+https://github.com/NVIDIA/cocoapi.git@${COCOAPI_TAG}#subdirectory=PythonAPI
# Install dllogger
pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger.git#egg=dllogger

# Install requirements
pip install -r requirements.txt
python3 -m pip install pycocotools==2.0.0
mkdir models #<- Requires to run main.py

%environment
export COCOAPI_VERSION=2.0+nv0.6.0
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
    apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file

    echo "Installing Open MPI"
    export OMPI_DIR=/opt/ompi
    export OMPI_VERSION=4.1.5
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
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ export SINGULARITY_TMPDIR=$SGE_LOCALDIR
[username@g0001 ~]$ singularity build --fakeroot openmpi.sif openmpi.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: openmpi.sif
[username@g0001 ~]$
```

Example) running the container
```
[username@g0001 ~]$ module load singularitypro hpcx/2.12
[username@g0001 ~]$ mpirun -hostfile $SGE_JOB_HOSTLIST -np 4 -map-by node singularity exec openmpi.sif /opt/mpitest
Hello, I am rank 2/4
Hello, I am rank 3/4
Hello, I am rank 0/4
Hello, I am rank 1/4
```

#### Using the CUDA Toolkit

This is an example of running python on  [h2o4gpu](https://github.com/sylabs/examples/tree/eb713691a30cfd455e1de24cb014646bde404adb/machinelearning/h2o4gpu) with the [CUDA Toolkit](gpu.md#cuda-toolkit).
In this case, you will have a Singularity recipe file (h2o4gpuPy.def) and a validation script (h2o4gpu_sample.py) in your home directory.

h2o4gpuPy.def
```
BootStrap: docker
From: nvidia/cuda:10.2-devel-ubuntu18.04

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

    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

    apt-get -y update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        libpython3.6-dev \
        libopenblas-dev pbzip2 \
        libcurl4-openssl-dev libssl-dev libxml2-dev

    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

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
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ export SINGULARITY_TMPDIR=$SGE_LOCALDIR
[username@g0001 ~]$ singularity build --fakeroot h2o4gpuPy.sif h2o4gpuPy.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: h2o4gpuPy.sif
[username@g0001 ~]$
```

Example) running the container
```
[username@g0001 ~]$ module load singularitypro cuda/10.2
[username@g0001 ~]$ singularity exec --nv h2o4gpuPy.sif python3 h2o4gpu_sample.py
[[1.  0.5]
 [1.  4. ]]
[username@g0001 ~]$
```

## Docker

!!! warning
    We plan to discontinue support for the ability to run jobs on Docker containers in FY2022 operations. If you wish to use containers, please use Singularity containers in your jobs.
    We will also discontinue maintenance of the Docker images we provide. 

In the ABCI System, job can be executed on Docker container.
When you use Docker, you need to set up user environment by the `module` command and specify `-l docker` option and `-l docker_image` option at job submission.

| option | description |
|:--|:--|
| -l docker | job is executed on Docker container |
| -l docker_images | specify using Docker image |

!!! warning
    Docker container can not be used on memory-intensive node in the ABCI system.

The available Docker image can be referred by `show_docker_images` command.

```
[username@es1 ~]$ show_docker_images
REPOSITORY                TAG             IMAGE ID     CREATED       SIZE
jcm:5000/dhub/ubuntu      latest          113a43faa138 3 weeks ago   81.2MB
```

!!! warning
    In the ABCI System, Users can use only Docker images provided in the system.

Example) job script using Docker

The following job script executes `python3 ./sample.py` on Docker container.

```
[username@es1 ~]$ cat run.sh
#!/bin/sh
#$-cwd
#$-j y
#$-l rt_F=1
#$-l docker=1
#$-l docker_images="*jcm:5000/dhub/ubuntu*"

python3 ./sample.py
```

Example) Submission of job script using Docker

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 12345 ("run.sh") has been submitted
```

!!! warning
    Docker container is only available on a node-exclusive job.

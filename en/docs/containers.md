# Containers

## Singularity

!!! warning
    We have stopped offering Singularity 2.6 at the end of March 2021.

[Singularity](https://www.sylabs.io/singularity/) is available on the ABCI System.
Available version is SingularityPRO 3.7.
To use Singularity, set up user environment by the `module` command.

```
[username@g0001 ~]$ module load singularitypro
```

More comprehensive user guide for Singularity will be found:

* [SingularityPRO User Guide](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/)

To run NGC-provided Docker images on ABCI by using Singularity: [NVIDIA NGC](tips/ngc.md)

### Create a Singularity image (pull)

Singularity container image can be stored as a file.
This procedure shows how to create a Singularity image file using pull.

Example) Create a Singularity image file using `pull`

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull caffe2.img docker://caffe2ai/caffe2:latest
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
...
[username@es1 ~]$ ls caffe2.img
caffe2.img
```

### Create a Singularity image (build)

In the SingularityPRO environment of the ABCI system, you can build container image files using `fakeroot` option.

!!! note
    In the SingularityPRO environment, you can also build container image file using remote build. See [ABCI Singularity Endpoint](abci-singularity-endpoint.md) for more information.

Example) Create a Singularity image file using `build`

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:18.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@es1 ~]$ singularity build --fakeroot ubuntu.sif ubuntu.def
INFO:    Starting build...
(snip)
INFO:    Creating SIF file...
INFO:    Build complete: ubuntu.sif
[username@es1 singularity]$
```

If the output destination of the image file (ubuntunt.sif) is set to the group area (/groups1, /groups2) in the above command, an error occurs. In this case, it is possible to avoid the problem by executing the `newgrp` command after checking the ownership group of the image destination group area with `id` command as follows.
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
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity run ./caffe2.img
```

Example) Run a container with a Singularity image file in a batch job

```
[username@es1 ~]$ cat job.sh
#!/bin/sh
#$-l rt_F=1
#$-j y
source /etc/profile.d/modules.sh
module load singularitypro openmpi/3.1.6

mpiexec -n 4 singularity exec --nv ./caffe2.img \
    python sample.py

[username@es1 ~]$ qsub -g grpname job.sh
```

Example) Run a container image published in Docker Hub

The following sample executes a Singularity container using caffe2 container image published in Docker Hub.
`python sample.py` is executed in the container started by `singularity run` command.
The container image is downloaded at the first startup and cached in home area.
The second and subsequent times startup is faster by using cached data.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv docker://caffe2ai/caffe2:latest
...
Singularity> python sample.py
True
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
[username@es1 ~]$ module load python/3.6/3.6.12
[username@es1 ~]$ python3 -m venv work
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ pip3 install spython
```

Following example shows how to convert Dockerfile of [SSD300 v1.1 image](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD) developed by NVIDIA using Singularity Python and modify the generated Singularity recipe (ssd.def) so that it can correctly generate a Singularity image.

Just converting Dockerfile results in a built time error.
To avoid the problem, this example modifies the Singularity recipe as described below.

- Files in WORKDIR will not be copied => Set the copy destination to the absolute path of WORKDIR
- No path to pip => Add a setting to take over environment variables available in Docker image

```
[username@es1 ~]$ module load python/3.6/3.6.12
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
(work) [username@es1 ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
(work) [username@es1 SSD]$ spython recipe Dockerfile ssd.def
(work) [username@es1 SSD]$ cp -p ssd.def ssd_org.def
(work) [username@es1 SSD]$ vi ssd.def
Bootstrap: docker
From: nvcr.io/nvidia/pytorch:20.06-py3
Stage: spython-base

%files
requirements.txt /workspace                     <- Change path
./setup.py /workspace                           <- Change path
./csrc /workspace/csrc                          <- Change path
. /workspace                                    <- Change path
%post
FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:20.06-py3
. /.singularity.d/env/10-docker2singularity.sh  <- Add

# Set working directory
cd /workspace

PYTHONPATH="${PYTHONPATH}:/workspace"

pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger.git#egg=dllogger
pip install -r requirements.txt
python3 -m pip install pycocotools==2.0.0

# Copy SSD code
pip install .

%environment
export PYTHONPATH="${PYTHONPATH}:/workspace"
%runscript
cd /workspace
exec /bin/bash "$@"
%startscript
cd /workspace
exec /bin/bash "$@"
```

To create a Singularity image from the generated recipe file on ABCI, please refer to [Create a Singularity image (build)](#create-a-singularity-image-build).

## Docker

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

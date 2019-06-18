# NVIDIA GPU Cloud (NGC)

[NVIDIA GPU Cloud (NGC)](https://ngc.nvidia.com/) provides Docker images for GPU-optimized deep learning framework containers and HPC application containers and NGC container registry to distribute them.
ABCI allows users to execute NGC-provided Docker images easily by using [Singularity](09.md#singularity), 

In this page, we will explain the procedure to use Docker images registered in NGC container registry with ABCI.

## Prerequisites

### NGC Container Registry

Each Docker image of NGC container registry is specified by the following format:

```
nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

When using with Singularity, each image is referenced first with the URL schema ``docker://`` as like:

```
docker://nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

### NGC Website

[NGC Website](https://ngc.nvidia.com/) is the portal for browsing the contents of the NGC container registry, generating NGC API keys, and so on.

Most of the docker images provided by the NGC container registry are freely available, but some are 'locked' and required that you have an NGC account and an API key to access them. Below are examples of both cases.

* Freely available image: [https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)
* Locked image: [https://ngc.nvidia.com/catalog/containers/partners:chainer](https://ngc.nvidia.com/catalog/containers/partners:chainer)

If you do not have signed in with an NGC account, you can neither see the information such as ``pull`` command to use locked images, nor generate an API key.

In the following instructions, we will use freely available images. To use locked images, we will explain later ([Using Locked Images](#using-locked-images)).

See [NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html) for more details on NGC Website.

## Single-node Run

Using TensorFlow as an example, we will explain how to run Docker images provided by NGC container registry.

### Identify Image URL

First, we need to find the URL for TensorFlow image via NGC Website.

Open [https://ngc.nvidia.com/](https://ngc.nvidia.com/) with your browser, and input "tensorflow" to the search form "Search Containers".
Then, you'll find:
[https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)

In this page, you will see the the ``pull`` command for using TensorFlow image on Docker:

```
docker pull nvcr.io/nvidia/tensorflow:19.05-py2
```

As we mentioned at [NGC Container Registry](#ngc-container-registry), when using with Singularity, this image can be specified by the following URL:

```
docker://nvcr.io/nvidia/tensorflow:19.05-py2
```

### Build a Singularity image

Build a Singularity image for TensorFlow on the interactive node.

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ singularity pull --name tensorflow-19.05-py2.simg docker://nvcr.io/nvidia/tensorflow:19.05-py2
```

### Run a Singularity image

Start an interactive job with one full-node, and run a sample program ``cnn_mnist.py``.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.12.0/tensorflow/examples/tutorials/layers/cnn_mnist.py
[username@g0001 ~]$ singularity run --nv tensorflow-19.05-py2.simg python cnn_mnist.py
:
{'loss': 0.10828217, 'global_step': 20000, 'accuracy': 0.9667}
```

We can do the same thing with a batch job.

```
#!/bin/sh
#$ -l rt_F=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularity/2.6.1
wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.12.0/tensorflow/examples/tutorials/layers/cnn_mnist.py
singularity run --nv tensorflow-19.05-py2.simg python cnn_mnist.py
```

## Multiple-node Run

Some of NGC container images support multiple-node run with using MPI.
TensorFlow image, which we used for [Single-node Run](#single-node-run), also supports multi-node run.

### Identify MPI version

First, check the version of MPI installed into the TensorFlow image.

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ singularity exec tensorflow-19.05-py2.simg mpirun --version
mpirun (Open MPI) 3.1.3

Report bugs to http://www.open-mpi.org/community/help/
```

Next, check the available versions of Open MPI on the ABCI system.

```
[username@es1 ~] $ module avail openmpi

-------------------------------------------- /apps/modules/modulefiles/mpi ---------------------------------------------
openmpi/1.10.7         openmpi/2.1.5          openmpi/3.0.3          openmpi/3.1.2
openmpi/2.1.3          openmpi/2.1.6(default) openmpi/3.1.0          openmpi/3.1.3
```

``openmpi/3.1.3`` module seems to be suitable to run this image. In general, at least the major versions of both MPIs should be the same.

### Run a Singularity image with MPI

Start an interative job with two full-nodes, and load required environment modules.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2
[username@g0001 ~]$ module load singularity/2.6.1 openmpi/3.1.3
```

Each full-node has four GPUs, and we have eight GPUs in total.
In this case, we run four processes on each full-node in parallel, that means eight processes in total, so as to execute the sample program ``tensorflow_mnist.py``.

```
[username@g0001 ~]$ wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
[username@g0001 ~]$ mpirun -np 8 -npernode 4 singularity run --nv tensorflow-19.05-py2.simg python tensorflow_mnist.py
:
INFO:tensorflow:loss = 2.1563044, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1480849, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1783454, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1527252, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1556997, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1814752, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.190885, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1524186, step = 30 (0.153 sec)
INFO:tensorflow:loss = 1.7863444, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7349662, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.8009219, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7753524, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7744101, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7266351, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7221795, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.8231221, step = 40 (0.154 sec)
:
```

We can do the same thing with a batch job.

```
#!/bin/sh
#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularity/2.6.1 openmpi/3.1.3
wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
mpirun -np 8 -npernode 4 singularity run --nv tensorflow-19.05-py2.simg python tensorflow_mnist.py
```

## Using Locked Images

Using Chainer as an example, we will explain how to run locked Docker images provided by NGC container registry.

### Identify Locked Image URL

First, we need to find the URL for Chainer image via NGC Website.

Open [https://ngc.nvidia.com/](https://ngc.nvidia.com/) with your browser, sign in with an NGC account, and input "chainer" to the search form "Search Containers". Then, you'll find:
[https://ngc.nvidia.com/catalog/containers/partners:chainer](https://ngc.nvidia.com/catalog/containers/partners:chainer)

In this page, you will see the ``pull`` command for using Chainer image on Docker (you must sign in with an NGC account):

```
docker pull nvcr.io/partners/chainer:4.0.0b1
```

When using with Singularity, this image can be specified by the following URL:

```
docker://nvcr.io/partners/chainer:4.0.0b1
```

### Build a Singularity image for a locked NGC image

To build an image, an NGC API key is required. Follow the following procedure to generate an API key:

* [Generating Your NGC API Key](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html#generating-api-key)

Build a Singularity image for Chainer on the interactive node.
In this case, you need to set two environment variables, ``SINGULARITY_DOCKER_USERNAME`` and ``SINGULARITY_DOCKER_PASSWORD`` for downloading images from NGC container registry.

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
[username@es1 ~] $ export SINGULARITY_DOCKER_PASSWORD=<NGC API Key>
[username@es1 ~] $ singularity pull --name chainer-4.0.0b1.simg docker://nvcr.io/partners/chainer:4.0.0b1
```

### Run a Singularity image

We can run the resulted image, just as same as freely available images.

```
[username@es1 ~] $ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/v4.0.0b1/examples/mnist/train_mnist.py
[username@g0001 ~]$ singularity exec --nv chainer-4.0.0b1.simg python train_mnist.py -g 0
:
epoch       main/loss   validation/main/loss  main/accuracy  validation/main/accuracy  elapsed_time
1           0.192916    0.103601              0.9418         0.967                     9.05948
2           0.0748937   0.0690557             0.977333       0.9784                    10.951
3           0.0507463   0.0666913             0.983682       0.9804                    12.8735
4           0.0353792   0.0878195             0.988432       0.9748                    14.7425
:
```

## Reference

1. [NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html)
1. [NGC Container User Guide](https://docs.nvidia.com/ngc/ngc-user-guide/index.html)
1. [Running NGC Containers Using Singularity](https://docs.nvidia.com/ngc/ngc-user-guide/singularity.html)

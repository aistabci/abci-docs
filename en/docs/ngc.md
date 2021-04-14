# NVIDIA GPU Cloud (NGC)

[NVIDIA NGC](https://ngc.nvidia.com/) (hereinafter referred to as "NGC") provides Docker images for GPU-optimized deep learning framework containers and HPC application containers and NGC container registry to distribute them.
ABCI allows users to execute NGC-provided Docker images easily by using [Singularity](09.md#singularity).

In this page, we will explain the procedure to use Docker images registered in NGC container registry with ABCI.

## Prerequisites {#prerequisites}

### NGC Container Registry {#ngc-container-registry}

Each Docker image of NGC container registry is specified by the following format:

```
nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

When using with Singularity, each image is referenced first with the URL schema ``docker://`` as like:

```
docker://nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

### NGC Website {#ngc-website}

[NGC Website](https://ngc.nvidia.com/) is the portal for browsing the contents of the NGC container registry, generating NGC API keys, and so on.

Most of the docker images provided by the NGC container registry are freely available, but some are 'locked' and required that you have an NGC account and an API key to access them. Below are examples of both cases.

* Freely available image: [https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)
* Locked image: [https://ngc.nvidia.com/catalog/containers/partners:chainer](https://ngc.nvidia.com/catalog/containers/partners:chainer)

If you do not have signed in with an NGC account, you can neither see the information such as ``pull`` command to use locked images, nor generate an API key.

In the following instructions, we will use freely available images. To use locked images, we will explain later ([Using Locked Images](#using-locked-images)).

See [NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html) for more details on NGC Website.

## Single-node Run {#single-node-run}

Using TensorFlow as an example, we will explain how to run Docker images provided by NGC container registry.

### Identify Image URL {#identify-image-url}

First, you need to find the URL for TensorFlow image via NGC Website.

Open [https://ngc.nvidia.com/](https://ngc.nvidia.com/) with your browser, and input "tensorflow" to the search form "Search Containers".
Then, you'll find:
[https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)

In this page, you will see the ``pull`` command for using TensorFlow image on Docker:

```
docker pull nvcr.io/nvidia/tensorflow:19.06-py2
```

As we mentioned at [NGC Container Registry](#ngc-container-registry), when using with Singularity, this image can be specified by the following URL:

```
docker://nvcr.io/nvidia/tensorflow:19.06-py2
```

### Build a Singularity image {#build-a-singularity-image}

Build a Singularity image for TensorFlow on the interactive node.

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/tensorflow:19.06-py2
```
An image named ``tensorflow_19.06-py2.sif`` will be generated.

### Run a Singularity image {#run-a-singularity-image}

Start an interactive job with one full-node and run a sample program ``cnn_mnist.py``.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.13.1/tensorflow/examples/tutorials/layers/cnn_mnist.py
[username@g0001 ~]$ singularity run --nv tensorflow_19.06-py2.sif python cnn_mnist.py
:
{'loss': 0.102341905, 'global_step': 20000, 'accuracy': 0.9696}
```

You can do the same thing with a batch job.

```
#!/bin/sh
#$ -l rt_F=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularitypro
wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.13.1/tensorflow/examples/tutorials/layers/cnn_mni
st.py
singularity run --nv tensorflow_19.06-py2.sif python cnn_mnist.py
```

## Multiple-node Run {#multiple-node-run}

Some of NGC container images support multiple-node run with using MPI.
TensorFlow image, which you used for [Single-node Run](#single-node-run), also supports multi-node run.

### Identify MPI version {#identify-mpi-version}

First, check the version of MPI installed into the TensorFlow image.

```
[username@es1 ~] $ module load singularitypro
[username@es1 ~] $ singularity exec tensorflow_19.06-py2.sif mpirun --version
mpirun (Open MPI) 3.1.3

Report bugs to http://www.open-mpi.org/community/help/
```

Next, check the available versions of Open MPI on the ABCI system.

```
[username@es1 ~] $ module avail openmpi

-------------------------------------------- /apps/modules/modulefiles/mpi ---------------------------------------------
openmpi/2.1.6          openmpi/3.1.6          openmpi/4.0.5(default)
```

``openmpi/3.1.6`` module seems to be suitable to run this image. In general, at least the major versions of both MPIs should be the same.

### Run a Singularity image with MPI {#run-a-singularity-image-with-mpi}

Start an interative job with two full-nodes, and load required environment modules.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro openmpi/3.1.6
```

Each full-node has four GPUs, and you have eight GPUs in total.
In this case, you run four processes on each full-node in parallel, that means eight processes in total, so as to execute the sample program ``tensorflow_mnist.py``.

```
[username@g0001 ~]$ wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
[username@g0001 ~]$ mpirun -np 8 -npernode 4 singularity run --nv tensorflow_19.06-py2.sif python tensorflow_mnist.py
:
INFO:tensorflow:loss = 2.227471, step = 30 (0.151 sec)
INFO:tensorflow:loss = 2.2297306, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.2236195, step = 30 (0.151 sec)
INFO:tensorflow:loss = 2.2085133, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.2206438, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.2315774, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.2195148, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.2279806, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.0452738, step = 40 (0.152 sec)
INFO:tensorflow:loss = 2.0309064, step = 40 (0.152 sec)
INFO:tensorflow:loss = 2.0354269, step = 40 (0.152 sec)
INFO:tensorflow:loss = 2.0014856, step = 40 (0.152 sec)
INFO:tensorflow:loss = 2.0149295, step = 40 (0.153 sec)
INFO:tensorflow:loss = 2.0528066, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.962772, step = 40 (0.153 sec)
INFO:tensorflow:loss = 2.0659132, step = 40 (0.153 sec)
:
```

You can do the same thing with a batch job.

```
#!/bin/sh
#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularitypro openmpi/3.1.6
wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
mpirun -np 8 -npernode 4 singularity run --nv tensorflow_19.06-py2.sif python tensorflow_mnist.py
```

## Using Locked Images {#using-locked-images}

Using Chainer as an example, we will explain how to run locked Docker images provided by NGC container registry.

### Identify Locked Image URL {#identify-locked-image-url}

First, you need to find the URL for Chainer image via NGC Website.

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

### Build a Singularity image for a locked NGC image {#build-a-singularity-image-for-a-locked-ngc-image}

To build an image, an NGC API key is required. Follow the following procedure to generate an API key:

* [Generating Your NGC API Key](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html#generating-api-key)

Build a Singularity image for Chainer on the interactive node.
In this case, you need to set two environment variables, ``SINGULARITY_DOCKER_USERNAME`` and ``SINGULARITY_DOCKER_PASSWORD`` for downloading images from NGC container registry.

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
[username@es1 ~]$ export SINGULARITY_DOCKER_PASSWORD=<NGC API Key>
[username@es1 ~]$ singularity pull docker://nvcr.io/partners/chainer:4.0.0b1
```

An image named ``chainer_4.0.0b1.sif`` will be generated.

You can also specify ``--docker-login`` option to download images instead of environment variables.

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull --disable-cache --docker-login docker://nvcr.io/partners/chainer:4.0.0b1
Enter Docker Username: $oauthtoken
Enter Docker Password: <NGC API Key>
```

### Run a Singularity image {#run-a-singularity-image_1}

You can run the resulted image, just as same as freely available images.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/v4.0.0b1/examples/mnist/train_mnist.py
[username@g0001 ~]$ singularity exec --nv chainer_4.0.0b1.sif python train_mnist.py -g 0
:
epoch       main/loss   validation/main/loss  main/accuracy  validation/main/accuracy  elapsed_time
1           0.191976    0.0931192             0.942517       0.9712            18.7328
2           0.0755601   0.0837004             0.9761         0.9737            20.6419
3           0.0496073   0.0689045             0.984266       0.9802            22.5383
4           0.0343888   0.0705739             0.988798       0.9796            24.4332
:
```

## Reference {#reference}

1. [NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html)
1. [NGC Container User Guide](https://docs.nvidia.com/ngc/ngc-user-guide/index.html)
1. [Running NGC Containers Using Singularity](https://docs.nvidia.com/ngc/ngc-user-guide/singularity.html)
1. [ABCI Adopts NGC for Easy Access to Deep Learning Frameworks | NVIDIA Blog](https://blogs.nvidia.com/blog/2019/06/17/abci-adopts-ngc/)

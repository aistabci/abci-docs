# MXNet

This section describes how to install and run MXNet and how to install Horovod to perform distributed learning.

## Running MXNet on a single node {#using}

### Precondition {#precondition}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation {#installation}

Here are the steps to create a Python virtual environment and install MXNet into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet) [username@g0001 ~]$ pip3 install mxnet-cu101
```

With the installation, you can use MXNet next time you want to use it by simply loading the module and activating the Python virtual environment, as follows

```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
```

### Execution

The following shows how to execute the MXNet sample program `train_mnist.py` in the case of an interactive job and a batch job.

**Run as an interactive job**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ git clone https://github.com/apache/incubator-mxnet.git
(mxnet) [username@g0001 ~]$ python3 incubator-mxnet/example/image-classification/train_mnist.py --gpus 0
```

**Run as a batch job**

Save the following job script as a `run.sh` file.

```
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
source ~/venv/mxnet/bin/activate
git clone https://github.com/apache/incubator-mxnet.git
python3 incubator-mxnet/example/image-classification/train_mnist.py --gpus 0
deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## Running MXNet on multiple nodes {#using-with-horovod}

### Precondition {#precondition-with-horovod}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in [the home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.


### Installation {#installation-with-horovod}

Here are the steps to create a Python virtual environment and install MXNet  and Horovod into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet+horovod
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet+horovod) [username@g0001 ~]$ pip3 install mxnet-cu101
(mxnet+horovod) [username@g0001 ~]$ HOROVOD_WITH_MXNET=1 HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL pip3 install --no-cache-dir horovod
```

With the installation, you can use MXNet and Horovod next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
```

### Execution {#run-with-horovod}

The following shows how to execute a sample program `mxnet_train.py` of MXNet with Horovod for distributed learning.


**Run as an interactive job**

In this example, using 4 GPUs in an interactive node for distributed learning.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ git clone -b v0.18.2 https://github.com/horovod/horovod.git
(mxnet+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node python3 horovod/examples/mxnet_mnist.py
```

**Run as a batch job**

In this example, a total of 8 GPUs are used for distributed learning.
2 compute nodes are used, with 4 GPUs per compute node.

Save the following job script as a run.sh file.

```
#!/bin/sh -x

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
source ~/venv/mxnet+horovod/bin/activate

git clone -b v0.18.2 https://github.com/horovod/horovod.git

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

mpirun ${MPIOPTS} python3 horovod/examples/mxnet_mnist.py

deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

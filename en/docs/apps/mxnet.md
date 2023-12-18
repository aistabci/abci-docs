# MXNet

This section describes how to install and run MXNet and how to install Horovod to perform distributed learning.

## Running MXNet on a single node

### Precondition

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](../python.md#python-virtual-environments){:target="python-virtual-environments"} should be created in the [home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation

Here are the steps to create a Python virtual environment and install MXNet into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet) [username@g0001 ~]$ pip3 install mxnet-cu112==1.9.1 numpy==1.23.5
```

With the installation, you can use MXNet next time you want to use it by simply loading the module and activating the Python virtual environment, as follows

```
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
```

### Execution

The following shows how to execute the MXNet sample program `mnist.py` in the case of an interactive job and a batch job.

**Run as an interactive job**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ git clone -b v1.9.x https://github.com/apache/incubator-mxnet.git
(mxnet) [username@g0001 ~]$ python3 incubator-mxnet/example/gluon/mnist/mnist.py --cuda
```

**Run as a batch job**

Save the following job script as a `run.sh` file.

```shell
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8
source ~/venv/mxnet/bin/activate
git clone -b v1.9.x https://github.com/apache/incubator-mxnet.git
python3 incubator-mxnet/example/gluon/mnist/mnist.py --cuda
deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## Running MXNet on multiple nodes

### Precondition

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](../python.md#python-virtual-environments){:target="python-virtual-environments"} should be created in [the home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation

Here are the steps to create a Python virtual environment and install MXNet  and Horovod into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8 hpcx-mt/2.12
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet+horovod
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet+horovod) [username@g0001 ~]$ pip3 install wheel
(mxnet+horovod) [username@g0001 ~]$ pip3 install mxnet-cu112==1.9.1 numpy==1.23.5
(mxnet+horovod) [username@g0001 ~]$ HOROVOD_NCCL_LINK=SHARED HOROVOD_WITH_MXNET=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_WITH_MPI=1 HOROVOD_WITHOUT_GLOO=1 pip3 install --no-cache-dir horovod==0.27.0
```

With the installation, you can use MXNet and Horovod next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8 hpcx-mt/2.12
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
```

### Execution

The following shows how to execute a sample program `mxnet2_train.py` of MXNet with Horovod for distributed learning.

**Run as an interactive job**

In this example, using 4 GPUs in a compute node for distributed learning.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8 hpcx-mt/2.12
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ git clone -b v0.27.0 https://github.com/horovod/horovod.git
(mxnet+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node -mca pml ob1 python3 horovod/examples/mxnet/mxnet_mnist.py
```

**Run as a batch job**

In this example, a total of 8 GPUs are used for distributed learning. 2 compute nodes are used, with 4 GPUs per compute node.

Save the following job script as a run.sh file.

```shell
#!/bin/sh

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.11 cuda/11.2 cudnn/8.1 nccl/2.8 hpcx-mt/2.12
source ~/venv/mxnet+horovod/bin/activate

git clone -b v0.27.0 https://github.com/horovod/horovod.git

NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NHOSTS} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-hostfile $SGE_JOB_HOSTLIST -np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include bond0"

mpirun ${MPIOPTS} python3 horovod/examples/mxnet/mxnet_mnist.py

deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```


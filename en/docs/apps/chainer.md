# Chainer

This section describes how to install and run [Chainer](https://chainer.org/) with pip.

### Precondition

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](../python.md#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](../storage.md#home-area){:target="home-area"} or [group](../storage.md#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation

Here are the steps to create a Python virtual environment and install Chainer into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ python3 -m venv ~/venv/chainer
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
(chainer) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(chainer) [username@g0001 ~]$ pip3 install numpy==1.17 cupy-cuda112==8.6.0 chainer==7.7.0 mpi4py==3.0.3
```

With the installation, you can use Chainer next time you want to use it by simply loading the module and activating the Python virtual environment, as follows

```
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
```

## Execution

The following shows how to execute one of the Chainer sample program [mnist](http://yann.lecun.com/exdb/mnist/) in the case of an interactive job and a batch job.

**Run as an interactive job**

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/master/examples/chainermn/mnist/train_mnist.py
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
(chainer) [username@g0001 ~]$ python3 train_mnist.py
```

**Run as a batch job**

In this example, a total of 8 GPUs are used for distributed learning. 2 compute nodes are used, with 4 GPUs per compute node.

Save the following job script as a `run.sh` file.

```
#!/bin/sh
#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
source ~/venv/chainer/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

APP="python3 ./train_mnist.py"

mpirun ${MPIOPTS} ${APP}

deactivate
```

The variables and arguments of mpirun used in this script are as follows.

| variables | description |
| :-- | :-- |
| NUM_NODES | The number of nodes used in the job. |
| NUM_GPU_PRE_NODE | The number of GPUs used in one node. |
| NUM_PROCS | The number of processes to be used by the program. |
| MPIOPTS | The options passed to mpirun. |

| mpirun options | description |
| :-- | :-- |
| -np *NUM* | Specifies the number of processes (*NUM*) to be used by the program. |
| -map-by ppr:*NUM*:node | Specify the number of processes (*NUM*) to be placed on each node. |

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

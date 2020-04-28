# Chainer

This section describes how to install and run [Chainer](https://chainer.org/) with pip.
Specifically, here are the steps to install and execute the Chainer.

Operational verification was done on November 30, 2019.

The version of Chainer is as follows

| Livrary | Version |
| :-- | :-- |
| chainer | 6.6.0 |
| cupy-cuda100 | 6.6.0 |

The modules ABCI provide and their versions used in this document are as follows.

| Module | Version |
| :-- | :-- |
| python  | 3.6.5      |
| cuda    | 10.0.130.1 |
| cudnn   | 7.6.4      |
| nccl    | 2.4.8-1    |

The environment variables used in this document are as follows.

| Environment Variable | Detail |
| :-- | :-- |
| HOME | User home directory |
| WORK | Program execution directory |

## Using Chainer { #using-chainer }

### Installation { #installation }

Create a Python virtual environment `$HOME/venv/chainer`, occupying one compute node, and install `chainer` and `cupy-cuda` with `pip`.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ python3 -m venv $HOME/venv/chainer
[username@g0001 ~]$ source $HOME/venv/chainer/bin/activate
(chainer) [username@g0001 ~]$ pip3 install --upgrade pip
(chainer) [username@g0001 ~]$ pip3 install --upgrade setuptools
(chainer) [username@g0001 ~]$ pip3 install cupy-cuda100==6.6.0 chainer==6.6.0 mpi4py matplotlib
(chainer) [username@g0001 ~]$ exit
[username@es1 ~]$
```

From now on, you can use Chainer by simply loading the module and activating the Python environment, as shown below.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/chainer/bin/activate
```

### Execution

In this section, we describe how to execute one of the Chainer sample programs, [mnist](http://yann.lecun.com/exdb/mnist/).

First, download the sample program.

```
[username@es1 ~]$ mkdir -p ${WORK}
[username@es1 ~]$ cd ${WORK}
[username@es1 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/master/examples/chainermn/mnist/train_mnist.py
```

Next, occupy a single compute node and activate the installed Chainer execution environment.
Once activated, you can run `train_mnist.py`.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/chainer/bin/activate
(pytorch) [username@g0001 ~]$ cd $WORK
(pytorch) [username@g0001 ~]$ python3 ./train_mnist.py
```

The same can be done for batch job scripts.
The job is done using 4 GPUs in each of the 2 nodes.

```
#!/bin/sh
#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5
module load cuda/10.0/10.0.130.1
module load cudnn/7.6/7.6.4
source ${HOME}/venv/chainer/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

APP="python3 ./train_mnist.py"

mpirun ${MPIOPTS} ${APP}

deactivate
```

The environment variables and arguments of mpirun used in this script are as follows.

| environment variables | description |
| :-- | :-- |
| NUM_NODES | The number of nodes used in the job. (The value specified by rt_F) |
| NUM_GPU_PRE_NODE | The number of GPUs used in one node. (Since the computation node is equipped with 4 GPUs, the value of 4 is specified) |
| NUM_PROCS | The number of processes to be used by the program. |
| MPIOPTS | The options passed to mpirun. |

| mpirun options | description |
| :-- | :-- |
| -np *NUM* | Specifies the number of processes (*NUM*) to be used by the program. |
| -map-by ppr:*NUM*:node | Specify the number of processes (*NUM*) to be placed on each node. |

Save the above script as a `submit.sh` file and submit the job with the qsub command.

```
[username@es1 ~]$ cd $WORK
[username@es1 ~]$ qsub -g grpname submit.sh
```




# TensorFlow-Keras

This section describes how to install and run TensorFlow and Keras, and how to install TensorFlow, Keras and Horovod to perform distributed learning.

## Running TensorFlow-Keras on a single node {#using}

### Precondition {#precondition}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation {#installation}

Here are the steps to create a Python virtual environment and install TensorFlow and Keras into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow-keras
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
(tensorflow-keras) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow-keras) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15 keras
```

With the installation, you can use TensorFlow and Keras next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
```

### Execution {#run}

The following shows how to execute the TensorFlow sample program `mnist_cnn.py` in the case of an interactive job and a batch job.

**Run as an interactive job**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
(tensorflow-keras) [username@g0001 ~]$ git clone https://github.com/keras-team/keras.git
(tensorflow-keras) [username@g0001 ~]$ python3 keras/examples/mnist_cnn.py
```

**Run as a batch job**

Save the following job script as a `run.sh` file.

```
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5
source ~/venv/tensorflow-keras/bin/activate
git clone https://github.com/keras-team/keras.git
python3 keras/examples/mnist_cnn.py
deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## Running TensorFlow on multiple nodes {#using-with-horovod}

### Precondition {#precondition-with-horovod}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation {#installation-with-horovod}

Here are the steps to create a Python virtual environment and install TensorFlow, Keras and Horovod into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow-keras+horovod
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
(tensorflow-keras+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow-keras+horovod) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15 keras
(tensorflow-keras+horovod) [username@g0001 ~]$ HOROVOD_WITH_TENSORFLOW=1 HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_GPU_BROADCAST=NCCL pip3 install --no-cache-dir horovod
```

With the installation, you can use TensorFlow, Keras and Horovod next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
```

### Execution {#run-with-horovod}

The following shows how to execute a sample program `keras_mnist.py` of TensorFlow with Horovod for distributed learning.

**Run as an interactive job**

In this example, using 4 GPUs in an interactive node for distributed learning.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
[username@g0001 ~]$ git clone -b v0.18.2 https://github.com/horovod/horovod.git
[username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node python3 horovod/examples/keras_mnist.py
```

**Run as a batch job**

In this example, a total of 8 GPUs are used for distributed learning.
2 compute nodes are used, with 4 GPUs per compute node.

Save the following job script as a `run.sh` file.

```
#!/bin/sh -x

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.0/10.0.130.1 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
source ~/venv/tensorflow-keras+horovod/bin/activate

git clone -b v0.18.2 https://github.com/horovod/horovod.git

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

mpirun ${MPIOPTS} python3 horovod/examples/keras_mnist.py

deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.


```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

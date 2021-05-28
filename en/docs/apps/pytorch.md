# PyTorch

This section describes how to install and run PyTorch and how to install Horovod to perform distributed learning.

## Running PyTorch on a single node {#using}

### Precondition {#precondition}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation {#installation}

Here are the steps to create a Python virtual environment and install PyTorch into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.1/11.1.1 cudnn/8.0/8.0.5
[username@g0001 ~]$ python3 -m venv ~/venv/pytorch
[username@g0001 ~]$ source ~/venv/pytorch/bin/activate
(pytorch) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(pytorch) [username@g0001 ~]$ pip3 install filelock torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
```

With the installation, you can use PyTorch next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.1/11.1.1 cudnn/8.0/8.0.5
[username@g0001 ~]$ source ~/venv/pytorch/bin/activate
```

### Execution {#run}

The following shows how to execute the PyTorch sample program `main.py` in the case of an interactive job and a batch job.

**Run as an interactive job**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.1/11.1.1 cudnn/8.0/8.0.5
[username@g0001 ~]$ source ~/venv/pytorch/bin/activate
(pytorch) [username@g0001 ~]$ git clone https://github.com/pytorch/examples.git
(pytorch) [username@g0001 ~]$ cd examples/mnist
(pytorch) [username@g0001 ~]$ python3 main.py
```

**Run as a batch job**

Save the following job script as a `run.sh` file.

```shell
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.1/11.1.1 cudnn/8.0/8.0.5
source ~/venv/pytorch/bin/activate
git clone https://github.com/pytorch/examples.git
cd examples/mnist
python3 main.py
deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## Running PyTorch on multiple nodes {#using-with-horovod}

### Precondition {#precondition-with-horovod}

- Replace `grpname` with your own ABCI group.
- [The Python virtual environment](/06/#python-virtual-environments){:target="python-virtual-enviroments"} should be created in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.
- The sample program should be saved in the [home](/04/#home-area){:target="home-area"} or [group](/04/#group-area){:target="group-area"} area so that it can be referenced by interactive nodes and each compute node.

### Installation {#installation-with-horovod}

Here are the steps to create a Python virtual environment and install PyTorch and Horovod into the Python virtual environment.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.1/11.1.1 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ python3 -m venv ~/venv/pytorch+horovod
[username@g0001 ~]$ source ~/venv/pytorch+horovod/bin/activate
(pytorch+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(pytorch+horovod) [username@g0001 ~]$ pip3 install filelock torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
(pytorch+horovod) [username@g0001 ~]$ HOROVOD_WITH_PYTORCH=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_WITHOUT_GLOO=1 pip3 install --no-cache-dir horovod==0.22.0
```

With the installation, you can use PyTorch and Horovod next time you want to use it by simply loading the module and activating the Python virtual environment, as follows.

```
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.1/11.1.1 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ source ~/venv/pytorch+horovod/bin/activate
```

### Execution {#run-with-horovod}

The following shows how to execute a sample program `pytorch_mnist.py` of PyTorch with Horovod for distributed learning.

**Run as an interactive job**

In this example, using 4 GPUs in a compute node for distributed learning.

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.1/11.1.1 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ source ~/venv/pytorch+horovod/bin/activate
(pytorch+horovod) [username@g0001 ~]$ git clone -b v0.22.0 https://github.com/horovod/horovod.git
(pytorch+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node -mca pml ob1 python3 horovod/examples/pytorch/pytorch_mnist.py
```

**Run as a batch job**

In this example, a total of 8 GPUs are used for distributed learning. 2 compute nodes are used, with 4 GPUs per compute node.

Save the following job script as a `run.sh` file.

```shell
#!/bin/sh

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.1/11.1.1 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
source ~/venv/pytorch+horovod/bin/activate

git clone -b v0.22.0 https://github.com/horovod/horovod.git

NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NHOSTS} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include bond0"

mpirun ${MPIOPTS} python3 horovod/examples/pytorch/pytorch_mnist.py

deactivate
```

Submit a saved job script `run.sh` as a batch job with the qsub command.

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```


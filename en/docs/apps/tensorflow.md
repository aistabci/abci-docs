To use TensorFlow on the ABCI system, user must install it to home or group area.
The procedures for installation and test run are as follows (as of March 29th, 2019).

## Single GPU

### Installation

To install [TensorFlow](https://www.tensorflow.org/),
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@es1 ~]$ qrsh -g group_name -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
```

### Execution

Download sample program
```
WORK : working directory
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/tutorials/mnist/mnist.py
```

Job script (an example of train_mnist.py execution using 1GPU on node)
```
WORK : working directory
[username@es ~]$ cd ${WORK}
[username@es ~]$ cat submit.sh
#!/bin/sh

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

python3 ${WORK}/mnist.py
```

Submit a job
```
GROUP    : ABCI user group
WORK     : working directory
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

## Multi GPU on Single node

### Installation

Install tensorflow with horovod
```
NEW_VENV : python virtual environment or path to be installed

[username@es1 ~]$ qrsh -g group_name -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
(NEW_VENV) [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL pip3 install horovod
```

### Execution

Download sample program
```
WORK : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```


Job script (an example of tensorflow_mnist.py execution using 4GPUs on node)
```
WORK : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ cat submit.sh
#!/bin/sh

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-n ${NUM_PROCS}"

APP="python3 $HOME/tensorflow_mnist.py"
          
horovodrun ${MPIOPTS} ${APP}
```

Submit a job (using 4GPUs on node)
```
GROUP    : ABCI user group
WORK     : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

## Multi GPU on multi nodes

### Installation

Install tensorflow with horovod
```
NEW_VENV : python virtual environment or path to be installed

[username@es1 ~]$ qrsh -g group_name -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
(NEW_VENV) [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL pip3 install horovod
```

### Execution

Download sample program
```
WORK : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```


Job script (an example of tensorflow_mnist.py execution using 4GPUs on 2nodes)
```
WORK : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ cat submit.sh
#!/bin/sh

#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-n ${NUM_PROCS}"

APP="python3 $HOME/tensorflow_mnist.py"
          
horovodrun ${MPIOPTS} ${APP}
```

Submit a job (using 2nodes with 4GPUs each)
```
GROUP    : ABCI user group
WORK     : working directory

[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```


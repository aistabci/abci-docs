ABCIシステムでTensorFlowを利用する場合、利用者がホーム領域またはグループ領域にインストールする必要があります。
TensorFlowのインストール方法、動作確認方法は以下の通りです（2019年3月29日時点での確認）。

## シングルGPU

### 導入方法

[TensorFlow](https://www.tensorflow.org/)のインストール方法は以下を参照ください。

```
NEW_VENV : インストールするPython仮想環境、またはディレクトリパス
[username@es1 ~]$ qrsh -g グループ名 -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
```

###  実行方法

サンプルプログラムのダウンロード
```
WORK : 実行環境
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/tutorials/mnist/mnist.py
```

ジョブスクリプト(ノード内1GPUを使用してmnist.pyを実行するジョブスクリプト例)
```
WORK : 実行環境
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

ジョブ投入
```
GROUP    : ABCI利用グループ
WORK     : 実行環境
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

## シングルノードマルチGPU

### 導入方法

horovodを利用したtensorflow並列環境の構築
```
NEW_VENV : インストールするPython仮想環境、またはディレクトリパス

[username@es1 ~]$ qrsh -g グループ名 -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
(NEW_VENV) [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL pip3 install horovod
```

### 実行方法

サンプルプログラムのダウンロード
```
WORK : 実行環境

[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

!!! warning
    以下の説明には誤りが含まれています。Horovodを利用したTensorFlow実行環境を利用したい場合は運用サポートまでご連絡ください。

ジョブスクリプト(ノード内4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例)
```
WORK : 実行環境

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

ジョブ投入(1ノードで4GPUを利用する場合)
```
GROUP    : ABCI利用グループ
WORK     : 実行環境

[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

## マルチノードマルチGPU

### 導入方法

horovodを利用したtensorflow並列環境の構築
```
NEW_VENV : インストールするPython仮想環境、またはディレクトリパス

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.12.0
(NEW_VENV) [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL pip3 install horovod
```

### 実行方法

サンプルプログラムのダウンロード
```
WORK : 実行環境

[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

!!! warning
    以下の説明には誤りが含まれています。Horovodを利用したTensorFlow実行環境を利用したい場合は運用サポートまでご連絡ください。

ジョブスクリプト(ノード内4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例)
```
WORK : 実行環境

[username@es ~]$ cd ${WORK}
[username@es ~]$ cat submit.sh
#!/bin/sh

#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1 nccl/2.3/2.3.7-1 openmpi/2.1.5
source $HOME/NEW_VENV/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-n ${NUM_PROCS}"

APP="python3 $HOME/tensorflow_mnist.py"
          
horovodrun ${MPIOPTS} ${APP}
```

ジョブ投入(2ノードでそれぞれ4GPUを利用する場合)
```
GROUP    : ABCI利用グループ
WORK     : 実行環境

[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

ABCIシステムでTensorFlowを利用する場合、利用者がホーム領域またはグループ領域にインストールする必要があります。
TensorFlowのインストール方法、動作確認方法は以下の通りです（2019年11月12日時点での確認）。

| 使用ライブラリ | 動作確認済みバージョン |
| :-- | :-- |
| gcc | 7.4.0 |
| python | 3.6.5 |
| cuda | 10.0.130 |
| cudnn | 7.6.4 |
| nccl | 2.4.8-1 |
| openmpi | 2.1.6 |
| tensorflow-gpu | 1.15.0 |
| horocod | 0.18.2 |

## TensorFlow

### 導入方法

[TensorFlow](https://www.tensorflow.org/)のインストール方法は以下を参照ください。
> NEW_VENV : インストールするPython仮想環境、またはディレクトリパス
```
[username@es1 ~]$ qrsh -g グループ名 -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130 cudnn/7.6/7.6.4
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
```

### シングルGPUを用いた深層学習の実行例

サンプルプログラムのダウンロード
> WORK : 実行環境
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/tutorials/mnist/mnist.py
```

ジョブスクリプト(ノード内1GPUを使用してmnist.pyを実行するジョブスクリプト例)
> WORK : 実行環境  
```
#!/bin/sh

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5 cuda/10.0/10.0.130 cudnn/7.6/7.6.4
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

python3 ${WORK}/mnist.py

deactivate
```

ジョブ投入(1ノードで1GPUを利用する場合)
> GROUP : ABCI利用グループ  
> WORK : 実行環境  
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```


## TensorFlow + Horovod
### 導入方法
[TensorFlow](https://www.tensorflow.org/)を[horovod](https://github.com/horovod/horovod)で並列化する場合のインストール方法は以下を参照ください。
> NEW_VENV : インストールするPython仮想環境、またはディレクトリパス
```
[username@es1 ~]$ qrsh -g グループ名 -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.0/10.0.130 cudnn/7.6/7.6.4 nccl/2.4/2.4.8-1 openmpi/2.1.6
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
(tensorflow-gpu)  [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install horovod
```

### シングルノードマルチGPU分散深層学習の実行例

サンプルプログラムのダウンロード
> WORK : 実行環境
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

ジョブスクリプト(ノード内4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例)
> WORK : 実行環境
```
#!/bin/sh

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5 cuda/10.0/10.0.130 cudnn/7.6/7.6.4 nccl/2.4/2.4.8-1 openmpi/2.1.6
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

APP="python3 ${WORK}/tensorflow_mnist.py"
          
mpirun ${MPIOPTS} ${APP}

deactivate
```

ジョブ投入(1ノードで4GPUを利用する場合)
> GROUP    : ABCI利用グループ  
> WORK     : 実行環境  
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

実行結果例
```
(snip)
INFO:tensorflow:loss = 0.00024408945, step = 4990 (0.102 sec)
I1115 11:45:54.286664 47760267357632 basic_session_run_hooks.py:260] loss = 0.00024408945, step = 4990 (0.102 sec)
INFO:tensorflow:loss = 0.021003742, step = 4990 (0.102 sec)
I1115 11:45:54.286758 47618314866112 basic_session_run_hooks.py:260] loss = 0.021003742, step = 4990 (0.102 sec)
INFO:tensorflow:loss = 0.072201274, step = 4990 (0.102 sec)
INFO:tensorflow:loss = 1.9928242e-05, step = 4990 (0.102 sec)
I1115 11:45:54.286807 47528272862656 basic_session_run_hooks.py:260] loss = 0.072201274, step = 4990 (0.102 sec)
I1115 11:45:54.286818 47704005340608 basic_session_run_hooks.py:260] loss = 1.9928242e-05, step = 4990 (0.102 sec)
INFO:tensorflow:Saving checkpoints for 5000 into ./checkpoints/model.ckpt.
I1115 11:45:54.379096 47704005340608 basic_session_run_hooks.py:606] Saving checkpoints for 5000 into ./checkpoints/model.ckpt.
```

### マルチノードマルチGPU分散深層学習の実行例

サンプルプログラムのダウンロード
> WORK : 実行環境
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

ジョブスクリプト(ノード内4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例)
> WORK : 実行環境
```
#!/bin/sh

#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5 cuda/10.0/10.0.130 cudnn/7.6/7.6.4 nccl/2.4/2.4.8-1 openmpi/2.1.6
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

APP="python3 ${WORK}/tensorflow_mnist.py"
          
mpirun ${MPIOPTS} ${APP}

deactivate
```

ジョブ投入(2ノードで4GPUを利用する場合)
> GROUP    : ABCI利用グループ  
> WORK     : 実行環境  
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```

実行結果例
```
(snip)
INFO:tensorflow:loss = 1.5364076e-05, step = 2490 (0.102 sec)
I1115 12:10:17.351316 47108070133184 basic_session_run_hooks.py:260] loss = 1.5364076e-05, step = 2490 (0.102 sec)
I1115 12:10:17.351280 47541720673728 basic_session_run_hooks.py:260] loss = 0.037832655, step = 2490 (0.102 sec)
I1115 12:10:17.351558 47249233841600 basic_session_run_hooks.py:260] loss = 0.0021181286, step = 2490 (0.102 sec)
INFO:tensorflow:loss = 0.0002751056, step = 2490 (0.102 sec)
I1115 12:10:17.351346 47446035205568 basic_session_run_hooks.py:260] loss = 0.0002751056, step = 2490 (0.102 sec)
INFO:tensorflow:loss = 8.130686e-05, step = 2490 (0.102 sec)
I1115 12:10:17.351369 47244077174208 basic_session_run_hooks.py:260] loss = 8.130686e-05, step = 2490 (0.102 sec)
INFO:tensorflow:Saving checkpoints for 2500 into ./checkpoints/model.ckpt.
I1115 12:10:17.443821 47844145257920 basic_session_run_hooks.py:606] Saving checkpoints for 2500 into ./checkpoints/model.ckpt.
```

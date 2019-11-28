# TensorFlow

ABCIで[TensorFlow](https://www.tensorflow.org/)を利用するための手順について説明します。  
ABCIシステムでTensorFlowを利用する場合、利用者がホーム領域またはグループ領域にインストールする必要があります。  
本ドキュメントでは複数GPUを利用する場合に[horovod](https://github.com/horovod/horovod)を利用した並列化を行なっています。  
horovodは、TensorFlow、Keras、PyTorch、MXNet等の分散処理フレームワークであり、horovodによる並列化を利用した場合にTensorFlowの分散処理を使用する場合よりも、簡単なソース修正で並列処理することができます。

TensorFlowのインストール方法、動作確認方法は以下の通りです（2019年11月12日時点での確認）。

| 使用ライブラリ | 動作確認済みバージョン |
| :-- | :-- |
| gcc | 7.4.0 |
| python | 3.6.5 |
| cuda | 10.0.130.1 |
| cudnn | 7.6.4 |
| nccl | 2.4.8-1 |
| openmpi | 2.1.6 |
| tensorflow-gpu | 1.15.0 |
| horovod | 0.18.2 |

> 動作確認に用いたライブラリは、動作確認時ABCIに導入している最新版で実施しています。  
> ただしcudaについては最新版(10.1.243)では正常に動作しなかったため、10.0.130.1を使用しています。  
> またgccについてはTensorFlowのインストールに必要なため使用しています。

本ドキュメントで使用する環境変数一覧は以下の通りです。

| 環境変数 | 説明 |
| :-- | :-- |
| HOME | ユーザのホームディレクトリ |
| NEW_VENV | インストールするPython仮想環境、またはディレクトリパス |
| WORK | プログラムの実行ディレクトリ |
| GROUP | ABCI利用グループ |


## TensorFlow

### 導入方法

[TensorFlow](https://www.tensorflow.org/)のインストール方法は以下を参照ください。
ジョブサービスのOn-demandサービスを利用し、計算ノード上でインストールを実行します。
```
[username@es1 ~]$ qrsh -g ${GROUP} -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
(tensorflow-gpu) [username@g0001 ~]$ deactivate
```

### シングルGPUを用いたディープラーニングの実行例

ここではTensorflowのサンプルプログラムの1つである[mnist](http://yann.lecun.com/exdb/mnist/)を用いて実行方法を説明します。  
まずTensorFlowでサンプルプログラムmnistを実行するスクリプトをダウンロードします。
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/tutorials/mnist/mnist.py
```

1ノード内の1GPUを使用してmnist.pyを実行するジョブスクリプト例です。  
資源タイプrt_G.smallを利用し、導入方法で構築したPython仮想環境を利用して実行します。
```
#!/bin/sh

#$ -l rt_G.small=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5
module load cuda/10.0/10.0.130.1
module load cudnn/7.6/7.6.4
export NEW_VENV=${HOME}/venv/tensorflow-gpu
source ${NEW_VENV}/bin/activate

python3 ${WORK}/mnist.py

deactivate
```

ABCI利用グループを指定し、qsubコマンドでジョブ実行します。
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g GROUP submit.sh
```


## TensorFlow + Horovod
### 導入方法
[TensorFlow](https://www.tensorflow.org/)を[horovod](https://github.com/horovod/horovod)で並列化する場合のインストール方法は以下を参照ください。  
ジョブサービスのOn-demandサービスを利用し、計算ノード上でインストールを実行します。

```
[username@es1 ~]$ qrsh -g ${GROUP} -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ module load nccl/2.4/2.4.8-1
[username@g0001 ~]$ module load openmpi/2.1.6
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ export NEW_VENV=${HOME}/venv/tensorflow-gpu
[username@g0001 ~]$ python3 -m venv ${NEW_VENV}
[username@g0001 ~]$ source ${NEW_VENV}/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
(tensorflow-gpu)  [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install horovod
```

### シングルノードマルチGPU分散ディープラーニングの実行例
ここではTensorflowのサンプルプログラムの1つである[mnist](http://yann.lecun.com/exdb/mnist/)を用いて実行方法を説明します。
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

1ノード4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例は以下の通りです。  
資源タイプrt_Fを利用し、導入方法で構築したPython仮想環境を利用して実行します。  
本スクリプト内で使用する環境変数ならびにmpirunの引数は以下の通りです。  
rt_Fでノード数を指定することで、自動的にノード数×4のプロセス数のMPI並列プログラムを実行します。
> horovodの推奨するhorovodrunではマルチノードを利用した並列が実行できないため、mpirunを利用しています。

| 環境変数 | 説明 |
| :-- | :-- |
| NUM_NODES | ジョブで使用するノード数(rt_Fで指定した数が自動で入力される) |
| NUM_GPU_PRE_NODE | 1ノード内で使用するGPU数(計算ノードに4GPU搭載しているため4を指定) |
| NUM_GPUS_PER_SOCKET | 1ソケットにあるGPU数 |
| NUM_PROCS | プログラムが使用するプロセス数 |
| MPIOPTS | mpirunに渡す引数をまとめたもの |

| mpirunの引数 | 説明 |
| :-- | :-- |
| -np <num> | プログラムが使用するプロセス数<num>を指定 |
| -map-by ppr:<num>:node | 1ノードに配置するプロセス数<num>を指定 |

```
#!/bin/sh

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5
module load cuda/10.0/10.0.130.1
module load cudnn/7.6/7.6.4
module load nccl/2.4/2.4.8-1
module load openmpi/2.1.6
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

ABCI利用グループを指定し、qsubコマンドでジョブ実行します。
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g ${GROUP} submit.sh
```


### マルチノードマルチGPU分散ディープラーニングの実行例

2ノード4GPUを使用してtensorflow_mnist.pyを実行するジョブスクリプト例は以下の通りです。  
環境・サンプルプログラムについてはシングルノードマルチGPUと同様のものを利用します。  
1ノード実行時のスクリプトからrt_Fの値を1から2に変更することで複数ノードを利用したジョブを実行可能です。
```
#!/bin/sh

#$ -l rt_F=2
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/7.4.0
module load python/3.6/3.6.5
module load cuda/10.0/10.0.130.1
module load cudnn/7.6/7.6.4
module load nccl/2.4/2.4.8-1
module load openmpi/2.1.6
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

ABCI利用グループを指定し、ジョブスクリプトをqsubコマンドでジョブ実行します。  
ジョブスクリプト内で使用するノード数を指定しているため、ジョブ実行コマンドはシングルノード実行時と同様です。
```
[username@es ~]$ cd ${WORK}
[username@es ~]$ qsub -g ${GROUP} submit.sh
```

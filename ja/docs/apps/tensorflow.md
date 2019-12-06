# TensorFlow

ここでは、[TensorFlow](https://www.tensorflow.org/)をpipでインストールして利用する手順を説明します。具体的には、TensorFlowをインストールして実行する手順と、TensorFlowと[Horovod](https://github.com/horovod/horovod)をインストールして分散学習を実行する手順を示します。

動作確認は2019年11月12日に行っています。

TensorFlow、Horovodのバージョンは以下の通りです。

| 使用ライブラリ | 動作確認済みバージョン |
| :-- | :-- |
| tensorflow-gpu | 1.15.0 |
| horovod        | 0.18.2 |

本ドキュメントで使用する、ABCIが提供するモジュールとそのバージョンは以下の通りです。

| 使用モジュール | 動作確認済みバージョン |
| :-- | :-- |
| gcc     | 7.4.0      |
| python  | 3.6.5      |
| cuda    | 10.0.130.1 |
| cudnn   | 7.6.4      |
| nccl    | 2.4.8-1    |
| openmpi | 2.1.6      |

!!! warning
    動作確認に用いたライブラリは、動作確認時ABCIに導入している最新版で実施しています。
    またgcc7.4.0についてはHorovodのインストールに必要なため使用しています。

本ドキュメントで使用する環境変数一覧は以下の通りです。

| 環境変数 | 説明 |
| :-- | :-- |
| HOME | ユーザのホームディレクトリ |
| WORK | プログラムの実行ディレクトリ |

## TensorFlow の利用 { #using-tensorflow }

### 導入方法 { #installation }

計算ノードを一台占有し、Python仮想環境`$HOME/venv/tensorflow-gpu`を作成し、`pip`で`tensorflow-gpu`をインストールします。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ python3 -m venv $HOME/venv/tensorflow-gpu
[username@g0001 ~]$ source $HOME/venv/tensorflow-gpu/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
(tensorflow-gpu) [username@g0001 ~]$ exit
[username@es1 ~]$
```

次回以降は、以下のようにモジュールの読み込みとPython環境のアクティベートだけでTensorFlowを利用できます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/tensorflow-gpu/bin/activate
```

### 実行方法

ここでは、Tensorflowのサンプルプログラムの1つである[mnist](http://yann.lecun.com/exdb/mnist/)を用いて実行方法を説明します。

まず、サンプルプログラムをダウンロードします。

```
[username@es1 ~]$ mkdir -p ${WORK}
[username@es1 ~]$ cd ${WORK}
[username@es1 ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/tutorials/mnist/mnist.py
```

計算ノードを一台占有し、導入したTensorFlowの利用環境を設定し、`mnist.py`を実行します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/tensorflow-gpu/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ cd $WORK
(tensorflow-gpu) [username@g0001 ~]$ python3 ./mnist.py
```

バッチ利用時のジョブスクリプトでも同様のことができます。以下では、1ノード内の1GPUを使用して実行しています。

```
#!/bin/sh
#$ -l rt_G.small=1
#$ -l h_rt=1:23:45
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5
module load cuda/10.0/10.0.130.1
module load cudnn/7.6/7.6.4
source ${HOME}/venv/tensorflow-gpu/bin/activate

python3 ./mnist.py

deactivate
```

qsubコマンドでジョブ実行します。

```
[username@es1 ~]$ cd $WORK
[username@es1 ~]$ qsub -g grpname submit.sh
```

## TensorFlow + Horovod の利用 { #using-tensorflow-horovod }

Horovodは、TensorFlow、Keras、PyTorch、MXNetに対応した分散学習フレームワークです。
Horovodを使用すると、ABCIシステムが搭載するInfiniBandを用いた高速な分散学習が容易に実現できます。
また、TensorFlow組み込みの分散処理の仕組みである[Distributed TensorFlow](https://www.tensorflow.org/guide/distributed_training)を使うよりも、Horovodを使用する方が、シングルGPU用コードを複数GPUに対応させる時の修正が少ない、高い性能が得られる、と言われています（[参考1](https://eng.uber.com/horovod/)、[参考2](https://github.com/horovod/horovod#why-not-traditional-distributed-tensorflow)）。

### 導入方法 { #installation_1 }

計算ノードを一台占有し、Python仮想環境`$HOME/venv/tensorflow-gpu`を作成し、`pip`で`tensorflow-gpu`並びに`horovod`をインストールします。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ module load nccl/2.4/2.4.8-1
[username@g0001 ~]$ module load openmpi/2.1.6
[username@g0001 ~]$ python3 -m venv $HOME/venv/tensorflow-gpu
[username@g0001 ~]$ source $HOME/venv/tensorflow-gpu/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade pip
(tensorflow-gpu) [username@g0001 ~]$ pip3 install --upgrade setuptools
(tensorflow-gpu) [username@g0001 ~]$ pip3 install tensorflow-gpu==1.15.0
(tensorflow-gpu) [username@g0001 ~]$ HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip3 install horovod
(tensorflow-gpu) [username@g0001 ~]$ exit
[username@es1 ~]$
```

### 実行方法

ここではTensorFlowのサンプルプログラムの1つであるmnistを用いて実行方法を説明します。
まずHorovodによりTensorFlowを並列化したサンプルプログラムmnistを実行するプログラムをダウンロードします。

```
[username@es1 ~]$ cd ${WORK}
[username@es1 ~]$ wget https://raw.githubusercontent.com/uber/horovod/master/examples/tensorflow_mnist.py
```

計算ノードを一台占有し、導入したTensorFlow+Horovodの利用環境を設定し、`tensorflow_mnist.py`を実行します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ module load nccl/2.4/2.4.8-1
[username@g0001 ~]$ module load openmpi/2.1.6
[username@g0001 ~]$ source $HOME/venv/tensorflow-gpu/bin/activate
(tensorflow-gpu) [username@g0001 ~]$ cd $WORK
(tensorflow-gpu) [username@g0001 ~]$ python3 horovodrun -n 4 ./tensorflow_mnist.py
```

バッチ利用時のジョブスクリプトでも同様のことができます。
以下のスクリプトでは、2ノードでそれぞれ4 MPIプロセスを起動し、各MPIプロセスが1 GPUを用いた学習を行います。  
より多くのノードを使用する場合は、資源量（rt_F）の指定のみ変更することで「ノード数 x 4」のGPUが使用されます。

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
source $HOME/venv/tensorflow-gpu/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

APP="python3 ./tensorflow_mnist.py"

mpirun ${MPIOPTS} ${APP}

deactivate
```

本スクリプト内で使用する環境変数ならびにmpirunの引数は以下の通りです。

| 環境変数 | 説明 |
| :-- | :-- |
| NUM_NODES | ジョブで使用するノード数(rt_Fで指定した数が入ります) |
| NUM_GPU_PRE_NODE | 1ノード内で使用するGPU数(計算ノードに4GPU搭載しているため4を指定) |
| NUM_PROCS | プログラムが使用するプロセス数 |
| MPIOPTS | mpirunに渡す引数をまとめたもの |

| mpirunの引数 | 説明 |
| :-- | :-- |
| -np *NUM* | プログラムが使用するプロセス数(*NUM*)を指定 |
| -map-by ppr:*NUM*:node | 1ノードに配置するプロセス数(*NUM*)を指定 |

!!! warning
    Horovodの推奨するhorovodrunではマルチノードを利用した並列が実行できません。
    シングルノードの実行ではhorovodrunを利用可能ですが、マルチノードの実行ではmpirunを利用します。


qsubコマンドでジョブ実行します。

```
[username@es1 ~]$ cd $WORK
[username@es1 ~]$ qsub -g grpname submit.sh
```

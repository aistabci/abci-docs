# Chainer

ここでは、[Chainer](https://chainer.org/)をpipでインストールして利用する手順を説明します。具体的には、Chainerをインストールして実行する手順を示します。

動作確認は2019年11月30日に行っています。

Chainerのバージョンは以下の通りです。

| 使用ライブラリ | 動作確認済みバージョン |
| :-- | :-- |
| chainer | 6.6.0 |
| cupy-cuda100 | 6.6.0 |

本ドキュメントで使用する、ABCIが提供するモジュールとそのバージョンは以下の通りです。

| 使用モジュール | 動作確認済みバージョン |
| :-- | :-- |
| python  | 3.6.5      |
| cuda    | 10.0.130.1 |
| cudnn   | 7.6.4      |
| nccl    | 2.4.8-1    |

本ドキュメントで使用する環境変数一覧は以下の通りです。

| 環境変数 | 説明 |
| :-- | :-- |
| HOME | ユーザのホームディレクトリ |
| WORK | プログラムの実行ディレクトリ |

## Chainer の利用 { #using-chainer }

### 導入方法 { #installation }

計算ノードを一台占有し、Python仮想環境`$HOME/venv/chainer`を作成し、`pip`で`chainer`と`cupy-cuda`をインストールします。

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

次回以降は、以下のようにモジュールの読み込みとPython環境のアクティベートだけでChainerを利用できます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/chainer/bin/activate
```

### 実行方法

ここでは、Chainerのサンプルプログラムの1つである[mnist](http://yann.lecun.com/exdb/mnist/)を用いて実行方法を説明します。

まず、サンプルプログラムをダウンロードします。

```
[username@es1 ~]$ mkdir -p ${WORK}
[username@es1 ~]$ cd ${WORK}
[username@es1 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/master/examples/chainermn/mnist/train_mnist.py
```

計算ノードを一台占有し、導入したChainerの利用環境を設定し、`train_mnist.py`を実行します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.6/7.6.4
[username@g0001 ~]$ source $HOME/venv/chainer/bin/activate
(pytorch) [username@g0001 ~]$ cd $WORK
(pytorch) [username@g0001 ~]$ python3 ./train_mnist.py
```

バッチ利用時のジョブスクリプトでも同様のことができます。以下では、2ノード内のそれぞれ4GPUを使用して実行しています。

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

qsubコマンドでジョブ実行します。

```
[username@es1 ~]$ cd $WORK
[username@es1 ~]$ qsub -g grpname submit.sh
```

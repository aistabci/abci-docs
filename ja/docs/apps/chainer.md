# Chainer

ここでは、[Chainer](https://chainer.org/)をpipで導入して実行する手順を説明します。

## 前提 {#precondition}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](/06/#python-virtual-environments){:target="python-virtual-enviroments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に保存してください

## 導入方法 { #installation }

[venv](/06/#venv){:target="python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へChainerを[pip](/06/#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ python3 -m venv ~/venv/chainer
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
(chainer) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(chainer) [username@g0001 ~]$ pip3 install numpy==1.17 cupy-cuda112==8.6.0 chainer==7.7.0 mpi4py==3.0.3
```

次回以降は、次のようにモジュールの読み込みとPython環境のアクティベートだけでChainerを使用できます。

```
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
```

## 実行方法 {#run}

Chainerサンプルプログラムの1つである[mnist](http://yann.lecun.com/exdb/mnist/)の実行方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/master/examples/chainermn/mnist/train_mnist.py
[username@g0001 ~]$ module load python/3.6/3.6.12 cuda/11.2/11.2.2 cudnn/8.1/8.1.1 openmpi/4.0.5
[username@g0001 ~]$ source ~/venv/chainer/bin/activate
(chainer) [username@g0001 ~]$ python3 train_mnist.py
```

**バッチジョブとして実行**

この例では、計8つのGPUを利用して分散学習します。計算ノード2台を使用し、計算ノード1台あたり4つのGPUを使用しています。

次のジョブスクリプトを `run.sh` ファイルとして保存します。

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

ジョブスクリプト内で使用する変数ならびにmpirunの引数は以下の通りです。

| 変数 | 説明 |
| :-- | :-- |
| NUM_NODES | ジョブで使用するノード数 |
| NUM_GPU_PRE_NODE | 1ノード内で使用するGPU数 |
| NUM_PROCS | プログラムが使用するプロセス数 |
| MPIOPTS | mpirunに渡す引数をまとめたもの |

| mpirunの引数 | 説明 |
| :-- | :-- |
| -np *NUM* | プログラムが使用するプロセス数(*NUM*)を指定 |
| -map-by ppr:*NUM*:node | 1ノードに配置するプロセス数(*NUM*)を指定 |

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

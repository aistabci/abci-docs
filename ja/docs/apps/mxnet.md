# MXNet

ここでは、MXNetをpipで導入して実行する手順を説明します。具体的には、MXNetを導入して実行する手順と、MXNetとHorovodを導入して分散学習を実行する手順を示します。

## MXNetの単体実行 {#using}

### 前提 {#precondition}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](/06/#python-virtual-environments){:target="python-virtual-enviroments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に保存してください

### 導入方法 {#installation}

[venv](/06/#venv){:target="python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へMXNetを[pip](/06/#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet) [username@g0001 ~]$ pip3 install mxnet-cu101
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでMXNetを使用できます。
```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
```

### 実行方法 {#run}

MXNetサンプルプログラム `train_mnist.py` 実行方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**
```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
[username@g0001 ~]$ source ~/venv/mxnet/bin/activate
(mxnet) [username@g0001 ~]$ git clone https://github.com/apache/incubator-mxnet.git
(mxnet) [username@g0001 ~]$ python3 incubator-mxnet/example/image-classification/train_mnist.py --gpus 0
```

**バッチジョブとして実行**

次のジョブスクリプトを `run.sh` ファイルとして保存します。
```
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5
source ~/venv/mxnet/bin/activate
git clone https://github.com/apache/incubator-mxnet.git
python3 incubator-mxnet/example/image-classification/train_mnist.py --gpus 0
deactivate
```

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。
```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## MXNet + Horovod {#using-with-horovod}

### 前提 {#precondition-with-horovod}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](/06/#python-virtual-environments){:target="python-virtual-enviroments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](/04/#home-area){:target="home-area"}または[グループ領域](/04/#group-area){:target="group-area"}に保存してください

### 導入方法 {#installation-with-horovod}

[venv](/06/#venv){:target="python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へMXNetとHorovodを[pip](/06/#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ python3 -m venv ~/venv/mxnet+horovod
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(mxnet+horovod) [username@g0001 ~]$ pip3 install mxnet-cu101
(mxnet+horovod) [username@g0001 ~]$ HOROVOD_WITH_MXNET=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_HOME=$NCCL_HOME pip3 install --no-cache-dir horovod
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでMXNetとHorovodを使用できます。
```
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
```

### 実行方法 {#run-with-horovod}

Horovodを利用するMXNetサンプルプログラム `mxnet_train.py` で分散学習する方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

この例では、インタラクティブノードの4つのGPUを利用して分散学習します。
```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
[username@g0001 ~]$ source ~/venv/mxnet+horovod/bin/activate
(mxnet+horovod) [username@g0001 ~]$ git clone -b v0.20.0 https://github.com/horovod/horovod.git
(mxnet+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node python3 horovod/examples/mxnet_mnist.py
```

**バッチジョブとして実行**

この例では、計8つのGPUを利用して分散学習します。計算ノード2台を使用し、計算ノード1台あたり4つのGPUを使用しています。

次のジョブスクリプトを `run.sh` ファイルとして保存します。
```
#!/bin/sh -x

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/10.1/10.1.243 cudnn/7.6/7.6.5 nccl/2.5/2.5.6-1 openmpi/2.1.6 gcc/7.4.0
source ~/venv/mxnet+horovod/bin/activate

git clone -b v0.20.0 https://github.com/horovod/horovod.git

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node"

mpirun ${MPIOPTS} python3 horovod/examples/mxnet_mnist.py

deactivate
```

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。
```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

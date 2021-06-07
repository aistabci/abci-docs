# TensorFlow-Keras

ここでは、TensorFlowとKerasをpipで導入して実行する手順を説明します。具体的には、TensorFlowとKerasを導入して実行する手順と、TensorFlow、KerasとHorovodを導入して分散学習を実行する手順を示します。

!!! note
    TensorFlow 2からKerasはTensorFlowに含まれるようになりました。これによりTensorFlow 2をインストールすることでKerasも使えるようになります。
    ここで説明するTensorFlowおよびKerasのインストール手順は、実行するサンプルでKerasを使用することを除いて、[TensorFlow](tensorflow.md)のインストール手順と同じです。

## TensorFlow-Kerasの単体実行 {#running-tensorflow-keras-on-a-single-node}

### 前提 {#precondition}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](../python.md#python-virtual-environments){:target="python-virtual-environments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に保存してください

### 導入方法 {#installation}

[venv](../python.md#venv){:target="python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へTensorFlowとKerasを[pip](../python.md#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.0/11.0.3 cudnn/8.0/8.0.5
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow-keras
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
(tensorflow-keras) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow-keras) [username@g0001 ~]$ pip3 install tensorflow==2.4.1
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでTensorFlow、Kerasを使用できます。

```
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.0/11.0.3 cudnn/8.0/8.0.5
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
```

### 実行方法 {#execution}

TensorFlowサンプルプログラム `mnist_convnet.py` の実行方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.0/11.0.3 cudnn/8.0/8.0.5
[username@g0001 ~]$ source ~/venv/tensorflow-keras/bin/activate
(tensorflow-keras) [username@g0001 ~]$ git clone https://github.com/keras-team/keras-io.git
(tensorflow-keras) [username@g0001 ~]$ python3 keras-io/examples/vision/mnist_convnet.py
```

**バッチジョブとして実行**

次のジョブスクリプトを `run.sh` ファイルとして保存します。

```shell
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/9.3.0 python/3.8/3.8.7 cuda/11.0/11.0.3 cudnn/8.0/8.0.5
source ~/venv/tensorflow-keras/bin/activate
git clone https://github.com/keras-team/keras-io.git
python3 keras-io/examples/vision/mnist_convnet.py
deactivate
```

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

## TensorFlow + Horovod {#running-tensorflow-on-multiple-nodes}

### 前提 {#precondition_1}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](../python.md#python-virtual-environments){:target="python-virtual-environments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に保存してください

### 導入方法 {#installation_1}

[venv](../python.md#venv){:target="_python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へTensorFlow、KerasとHorovodを[pip](../python.md#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.0/11.0.3 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow-keras+horovod
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
(tensorflow-keras+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow-keras+horovod) [username@g0001 ~]$ pip3 install tensorflow==2.4.1
(tensorflow-keras+horovod) [username@g0001 ~]$ HOROVOD_WITH_TENSORFLOW=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_HOME=$NCCL_HOME pip3 install --no-cache-dir horovod==0.22.0
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでTensorFlow、KerasとHorovodを使用できます。

```
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.0/11.0.3 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
```

### 実行方法 {#execution_1}

Horovodを利用するTensorFlowサンプルプログラム `tensorflow2_keras_mnist.py` で分散学習する方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

この例では、計算ノードの4つのGPUを利用して分散学習します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.0/11.0.3 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
[username@g0001 ~]$ source ~/venv/tensorflow-keras+horovod/bin/activate
(tensorflow-keras+horovod) [username@g0001 ~]$ git clone -b v0.22.0 https://github.com/horovod/horovod.git
(tensorflow-keras+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node -mca pml ob1 python3 horovod/examples/tensorflow2/tensorflow2_keras_mnist.py
```

**バッチジョブとして実行**

この例では、計8つのGPUを利用して分散学習します。計算ノード2台を使用し、計算ノード1台あたり4つのGPUを使用しています。

次のジョブスクリプトを `run.sh` ファイルとして保存します。

```shell
#!/bin/sh

#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load gcc/9.3.0 python/3.8/3.8.7 openmpi/4.0.5 cuda/11.0/11.0.3 cudnn/8.0/8.0.5 nccl/2.8/2.8.4-1
source ~/venv/tensorflow-keras+horovod/bin/activate

git clone -b v0.22.0 https://github.com/horovod/horovod.git

NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NHOSTS} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include bond0"

mpirun ${MPIOPTS} python3 horovod/examples/tensorflow2/tensorflow2_keras_mnist.py

deactivate
```

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

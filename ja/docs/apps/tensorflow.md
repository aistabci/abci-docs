# TensorFlow

ここでは、TensorFlowをpipで導入して実行する手順を説明します。具体的には、TensorFlowを導入して実行する手順と、TensorFlowとHorovodを導入して分散学習を実行する手順を示します。

## TensorFlowの単体実行 {#running-tensorflow-on-a-single-node}

### 前提 {#precondition}

- `grpname`はご自身のABCI利用グループ名に置き換えてください
- [Python仮想環境](../python.md#python-virtual-environments){:target="python-virtual-environments"}はインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に作成してください
- サンプルプログラムはインタラクティブノードと各計算ノードで参照できるよう、[ホーム領域](../storage.md#home-area){:target="home-area"}または[グループ領域](../storage.md#group-area){:target="group-area"}に保存してください

### 導入方法 {#installation}

[venv](../python.md#venv){:target="python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へTensorFlowを[pip](../python.md#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow
[username@g0001 ~]$ source ~/venv/tensorflow/bin/activate
(tensorflow) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow) [username@g0001 ~]$ pip3 install tensorflow==2.12.0
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでTensorFlowを使用できます。

```
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6
[username@g0001 ~]$ source ~/venv/tensorflow/bin/activate
```

### 実行方法 {#execution}

TensorFlowサンプルプログラム `train.py` の実行方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6
[username@g0001 ~]$ source ~/venv/tensorflow/bin/activate
(tensorflow) [username@g0001 ~]$ git clone https://github.com/tensorflow/tensorflow.git
(tensorflow) [username@g0001 ~]$ python3 tensorflow/tensorflow/examples/speech_commands/train.py --how_many_training_steps 1000,500
```

**バッチジョブとして実行**

次のジョブスクリプトを `run.sh` ファイルとして保存します。

```shell
#!/bin/sh

#$ -l rt_G.small=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load python/3.11 cuda/11.8 cudnn/8.6
source ~/venv/tensorflow/bin/activate
git clone https://github.com/tensorflow/tensorflow.git
python3 tensorflow/tensorflow/examples/speech_commands/train.py --how_many_training_steps 1000,500
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

[venv](../python.md#venv){:target="_python_venv"}モジュールでPython仮想環境を作成し、作成したPython仮想環境へTensorFlowとHorovodを[pip](../python.md#pip){:target="pip"}で導入する手順です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6 nccl/2.16 hpcx-mt/2.12
[username@g0001 ~]$ python3 -m venv ~/venv/tensorflow+horovod
[username@g0001 ~]$ source ~/venv/tensorflow+horovod/bin/activate
(tensorflow+horovod) [username@g0001 ~]$ pip3 install --upgrade pip setuptools
(tensorflow+horovod) [username@g0001 ~]$ pip3 install tensorflow==2.12.0
(tensorflow+horovod) [username@g0001 ~]$ HOROVOD_NCCL_LINK=SHARED HOROVOD_WITH_TENSORFLOW=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_NCCL_HOME=$NCCL_HOME HOROVOD_WITHOUT_GLOO=1 pip3 install --no-cache-dir horovod==0.27.0
```

次回以降は、次のようにモジュールの読み込みとPython仮想環境のアクティベートだけでTensorFlowとHorovodを使用できます。

```
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6 nccl/2.16 hpcx-mt/2.12
[username@g0001 ~]$ source ~/venv/tensorflow+horovod/bin/activate
```

### 実行方法 {#execution_1}

Horovodを利用するTensorFlowサンプルプログラム `tensorflow2_mnist.py` で分散学習する方法をインタラクティブジョブとバッチジョブそれぞれの場合で示します。

**インタラクティブジョブとして実行**

この例では、計算ノードの4つのGPUを利用して分散学習します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.large=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load python/3.11 cuda/11.8 cudnn/8.6 nccl/2.16 hpcx-mt/2.12
[username@g0001 ~]$ source ~/venv/tensorflow+horovod/bin/activate
(tensorflow+horovod) [username@g0001 ~]$ export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CUDA_HOME
(tensorflow+horovod) [username@g0001 ~]$ git clone -b v0.27.0 https://github.com/horovod/horovod.git
(tensorflow+horovod) [username@g0001 ~]$ mpirun -np 4 -map-by ppr:4:node -mca pml ob1 python3 horovod/examples/tensorflow2/tensorflow2_mnist.py
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
module load python/3.11 cuda/11.8 cudnn/8.6 nccl/2.16 hpcx-mt/2.12
source ~/venv/tensorflow+horovod/bin/activate

export XLA_FLAGS=--xla_gpu_cuda_data_dir=${CUDA_HOME}
git clone -b v0.27.0 https://github.com/horovod/horovod.git

NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NHOSTS} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-hostfile $SGE_JOB_HOSTLIST -np ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include bond0"

mpirun ${MPIOPTS} python3 horovod/examples/tensorflow2/tensorflow2_mnist.py

deactivate
```

バッチジョブ実行のため、ジョブスクリプト `run.sh` をqsubコマンドでバッチジョブとして投入します。

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 1234567 ('run.sh') has been submitted
```

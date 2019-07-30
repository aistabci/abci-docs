[Chainer](https://chainer.org/)のインストール方法は以下を参照ください。
Chainerのインストール方法、動作確認方法は以下の通りです（2019年3月29日時点での確認）。
```
NEW_VENV : インストールするPython仮想環境、またはディレクトリパス

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install cupy-cuda91 chainer
```

サンプルプログラムのダウンロード
```
[username@es ~]$ git clone https://github.com/chainer/chainer.git chainer_sample
[username@es ~]$ cd chiner_sample/examples/chainermn/mnist
[username@es mnist]$ ls
README.md          model_parallel.png    train_mnist_checkpoint.py     train_mnist_model_parallel.py
dual_parallel.png  parallelism_axis.png  train_mnist.py                train_mnist_dual_parallel.py
```

ジョブ投入スクリプト(4gpuを使用してtrain_mnist.pyを実行するジョブスクリプト例)
```
[username@es ~]$ cat submit.sh
#!/bin/bash

source /etc/profile.d/modules.sh
module load python/3.6/3.6.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
module load openmpi/2.1.5
source $HOME/NEW_VENV/bin/activate

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_GPUS_PER_SOCKET=$(expr ${NUM_GPUS_PER_NODE} / 2)
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})

MPIOPTS="-np ${NUM_PROCS} --map-by ppr:${NUM_GPUS_PER_SOCKET}:socket --mca mpi_warn_on_fork 0 -x PATH -x LD_LIBRARY_PATH"

APP="python $HOME/chainer_sample/examples/chainermn/mnist/train_mnist.py"

mpiexec ${MPIOPTS} ${APP}  --gpu
```

ジョブ投入(2ノードでそれぞれ4gpuを利用する場合)
```
GROUP    : ABCI利用グループ

[username@es ~]$ qsub -g GROUP -l rt_F=2 submit.sh
```

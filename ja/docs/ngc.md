# NVIDIA GPU Cloud (NGC)

[NVIDIA GPU Cloud (NGC)](https://ngc.nvidia.com/)は、GPUに最適化されたディープラーニングフレームワークコンテナやHPCアプリケーションコンテナのDockerイメージと、それらを配布するためのNGCコンテナレジストリを提供しています。ABCIでは、[Singularity](09.md#singularity)を利用することで、NGCが提供するDockerイメージを簡便に実行することができます。

ここでは、NGCコンテナレジストリに登録されているDockerイメージをABCIで利用する手順について説明します。

## 前提知識 {#prerequisites}

### NGCコンテナレジストリ {#ngc-container-registry}

NGCコンテナレジストリのDockerイメージは、以下の形式で指定されます。

```
nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

Singularityから利用する場合には、URLスキーマとして``docker://``を指定して以下のように表します。

```
docker://nvcr.io/<namespace>/<repo_name>:<repo_tag>
```

### NGC Website {#ngc-website}

[NGC Website](https://ngc.nvidia.com/)は、NGCコンテナレジストリのカタログの提供、NGC API Keyの生成などの機能を提供するポータルです。

NGCコンテナレジストリのDockerイメージのうち、大半は自由に利用できますが、一部はNGCアカウントとNGC API Keyがなければアクセスできません。以下に両者の例を挙げます。

* 自由に利用できるイメージの例: [https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)
* アクセス制限されたイメージの例: [https://ngc.nvidia.com/catalog/containers/partners:chainer](https://ngc.nvidia.com/catalog/containers/partners:chainer)

NGC Websiteで、NGCアカウントでサインインしていない状態では、後者のイメージを利用するためのPull Commandなど一部情報が閲覧できず、またAPI Keyを生成することもできません。
以下では、自由に利用できるイメージを前提に説明を行います。[アクセス制限されたイメージの利用](#using-locked-images)については後述します。

その他、NGC Websiteに関する詳細は[NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html)を参照してください。

## シングルノードでの実行 {#single-node-run}

TensorFlowを例にとり、NGCコンテナレジストリで提供されているDockerイメージの実行方法を説明します。

### イメージURLの確認 {#identify-image-url}

TensorFlowのイメージをNGC Wbesiteで探します。ブラウザで "[https://ngc.nvidia.com/](https://ngc.nvidia.com/)" を開き、"Search Containers" と表示されている検索フォームに "tensorflow" と入力すると、
[https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)
が見つけられるはずです。

Dockerで利用する際のPull Commandが以下のように示されています。

```
docker pull nvcr.io/nvidia/tensorflow:19.05-py2
```

[NGCコンテナレジストリ](#ngc-container-registry)で説明したとおり、Singularityから利用する場合には、このイメージは以下のURLで指定できます。

```
docker://nvcr.io/nvidia/tensorflow:19.05-py2
```

### Singularityイメージの生成 {#build-a-singularity-image}

インタラクティブノード上でTensorFlowのSingularityイメージを生成します。

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ singularity pull --name tensorflow-19.05-py2.simg docker://nvcr.io/nvidia/tensorflow:19.05-py2
```

### Singularityイメージの実行 {#run-a-singularity-image}

1ノード占有でインタラクティブジョブを起動し、サンプルプログラム cnn_mnist.py を実行します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.12.0/tensorflow/examples/tutorials/layers/cnn_mnist.py
[username@g0001 ~]$ singularity run --nv tensorflow-19.05-py2.simg python cnn_mnist.py
:
{'loss': 0.10828217, 'global_step': 20000, 'accuracy': 0.9667}
```

バッチジョブでも同様に実行できます。

```
#!/bin/sh
#$ -l rt_F=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularity/2.6.1
wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.12.0/tensorflow/examples/tutorials/layers/cnn_mnist.py
singularity run --nv tensorflow-19.05-py2.simg python cnn_mnist.py
```

## 複数ノードでの実行 {#multiple-node-run}

NGCのコンテナイメージのうち一部は、MPIでの並列実行に対応しています。[シングルノードでの実行](#single-node-run)で使用したTensorFlowイメージも並列実行に対応しています。

### MPIバージョンの確認 {#identify-mpi-version}

TensorFlowイメージにインストールされているMPIのバージョンを確認します。

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ singularity exec tensorflow-19.05-py2.simg mpirun --version
mpirun (Open MPI) 3.1.3

Report bugs to http://www.open-mpi.org/community/help/
```

次にABCIで利用できるOpen MPIのバージョンを確認します。

```
[username@es1 ~] $ module avail openmpi

-------------------------------------------- /apps/modules/modulefiles/mpi ---------------------------------------------
openmpi/1.10.7         openmpi/2.1.5          openmpi/3.0.3          openmpi/3.1.2
openmpi/2.1.3          openmpi/2.1.6(default) openmpi/3.1.0          openmpi/3.1.3
```

``openmpi/3.1.3`` を使うのが適当のようです。少なくともメジャーバージョンが一致している必要があります。

### SingularityイメージのMPI実行 {#run-a-singularity-image-with-mpi}

2ノード占有でインタラクティブジョブを起動し、必要なモジュールを読み込みます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2
[username@g0001 ~]$ module load singularity/2.6.1 openmpi/3.1.3
```

1ノードあたり4基のGPUがあり、2ノード占有では計8基のGPUが使えることになります。この場合、8個のプロセスをノードあたり4個ずつ並列に起動し、サンプルプログラム tensorflow_mnist.py を実行します。

```
[username@g0001 ~]$ wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
[username@g0001 ~]$ mpirun -np 8 -npernode 4 singularity run --nv tensorflow-19.05-py2.simg python tensorflow_mnist.py
:
INFO:tensorflow:loss = 2.1563044, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1480849, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1783454, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1527252, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1556997, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1814752, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.190885, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1524186, step = 30 (0.153 sec)
INFO:tensorflow:loss = 1.7863444, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7349662, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.8009219, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7753524, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7744101, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7266351, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7221795, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.8231221, step = 40 (0.154 sec)
:
```

バッチジョブでも同様に実行できます。

```
#!/bin/sh
#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularity/2.6.1 openmpi/3.1.3
wget https://raw.githubusercontent.com/horovod/horovod/v0.16.4/examples/tensorflow_mnist.py
mpirun -np 8 -npernode 4 singularity run --nv tensorflow-19.05-py2.simg python tensorflow_mnist.py
```

## アクセス制限されたイメージの利用 {#using-locked-images}

以下では、Chainerを例に、NGCコンテナレジストリ上でアクセス制限されたイメージの実行方法を説明します。

### イメージURLの確認 {#identify-locked-image-url}

[https://ngc.nvidia.com/catalog/containers/partners:chainer](https://ngc.nvidia.com/catalog/containers/partners:chainer) でNGCアカウントにサインインすることで、Dockerで利用する際のPull Commandが得られます。

```
docker pull nvcr.io/partners/chainer:4.0.0b1
```

Singularityから利用する場合には、このイメージは以下のURLで指定できることが分かります。

```
docker://nvcr.io/partners/chainer:4.0.0b1
```

### Singularityイメージの生成 {#build-a-singularity-image-for-a-locked-ngc-image}

イメージの生成には、NGC API Keyが必要です。下記の手順にしたがって生成してください。

* [Generating Your NGC API Key](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html#generating-api-key)

インタラクティブノード上でSingularityイメージを生成します。Dockerイメージのダウンロードには、環境変数``SINGULARITY_DOCKER_USERNAME``, ``SINGULARITY_DOCKER_PASSWORD``の設定が必要です。

```
[username@es1 ~] $ module load singularity/2.6.1
[username@es1 ~] $ export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
[username@es1 ~] $ export SINGULARITY_DOCKER_PASSWORD=<NGC API Key>
[username@es1 ~] $ singularity pull --name chainer-4.0.0b1.simg docker://nvcr.io/partners/chainer:4.0.0b1
```

### Singularityイメージの実行 {#run-a-singularity-image_1}

通常のSingularityイメージと同じ手順で実行できます。

```
[username@es1 ~] $ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/v4.0.0b1/examples/mnist/train_mnist.py
[username@g0001 ~]$ singularity exec --nv chainer-4.0.0b1.simg python train_mnist.py -g 0
:
epoch       main/loss   validation/main/loss  main/accuracy  validation/main/accuracy  elapsed_time
1           0.192916    0.103601              0.9418         0.967                     9.05948
2           0.0748937   0.0690557             0.977333       0.9784                    10.951
3           0.0507463   0.0666913             0.983682       0.9804                    12.8735
4           0.0353792   0.0878195             0.988432       0.9748                    14.7425
:
```

## 参考 {#reference}

1. [NGC Getting Started Guide](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html)
1. [NGC Container User Guide](https://docs.nvidia.com/ngc/ngc-user-guide/index.html)
1. [Running NGC Containers Using Singularity](https://docs.nvidia.com/ngc/ngc-user-guide/singularity.html)
1. [日本最速のスーパーコンピュータが NGC を採用し、ディープラーニング フレームワークの利用をより簡単に | NVIDIA](https://blogs.nvidia.co.jp/2019/06/19/abci-adopts-ngc/)

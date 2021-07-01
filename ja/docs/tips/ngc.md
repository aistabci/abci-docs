# NVIDIA NGC

[NVIDIA NGC](https://ngc.nvidia.com/)（以下、NGCという）は、GPUに最適化されたディープラーニングフレームワークコンテナやHPCアプリケーションコンテナのDockerイメージと、それらを配布するためのNGCコンテナレジストリを提供しています。ABCIでは、[Singularity](../containers.md#singularity)を利用することで、NGCが提供するDockerイメージを簡便に実行することができます。

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

その他、NGC Websiteに関する詳細は[NGC Documentation](https://docs.nvidia.com/ngc/index.html)を参照してください。

## シングルノードでの実行 {#single-node-run}

TensorFlowを例にとり、NGCコンテナレジストリで提供されているDockerイメージの実行方法を説明します。

### イメージURLの確認 {#identify-image-url}

TensorFlowのイメージをNGC Wbesiteで探します。ブラウザで "[https://ngc.nvidia.com/](https://ngc.nvidia.com/)" を開き、"Search Containers" と表示されている検索フォームに "tensorflow" と入力すると、
[https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow)
が見つけられるはずです。

Dockerで利用する際のPull Commandが以下のように示されています。

```
docker pull nvcr.io/nvidia/tensorflow:21.06-tf1-py3
```

[NGCコンテナレジストリ](#ngc-container-registry)で説明したとおり、Singularityから利用する場合には、このイメージは以下のURLで指定できます。

```
docker://nvcr.io/nvidia/tensorflow:21.06-tf1-py3
```

### Singularityイメージの生成 {#build-a-singularity-image}

インタラクティブノード上でTensorFlowのSingularityイメージを生成します。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/tensorflow:21.06-tf1-py3
```
``tensorflow_21.06-tf1-py3.sif``という名前のイメージファイルが生成されます。


### Singularityイメージの実行 {#run-a-singularity-image}

1ノード占有でインタラクティブジョブを起動し、サンプルプログラム cnn_mnist.py を実行します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.15.5/tensorflow/examples/tutorials/layers/cnn_mnist.py
[username@g0001 ~]$ singularity run --nv tensorflow_21.06-tf1-py3.sif python cnn_mnist.py
:
{'accuracy': 0.9703, 'loss': 0.10137254, 'global_step': 20000}
```

バッチジョブでも同様に実行できます。

```shell
#!/bin/sh
#$ -l rt_F=1
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularitypro
wget https://raw.githubusercontent.com/tensorflow/tensorflow/v1.15.5/tensorflow/examples/tutorials/layers/cnn_mnist.py
singularity run --nv tensorflow_21.06-tf1-py3.sif python cnn_mnist.py
```

## 複数ノードでの実行 {#multiple-node-run}

NGCのコンテナイメージのうち一部は、MPIでの並列実行に対応しています。[シングルノードでの実行](#single-node-run)で使用したTensorFlowイメージも並列実行に対応しています。

### MPIバージョンの確認 {#identify-mpi-version}

TensorFlowイメージにインストールされているMPIのバージョンを確認します。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity exec tensorflow_21.06-tf1-py3.sif mpirun --version
mpirun (Open MPI) 4.1.1rc1

Report bugs to http://www.open-mpi.org/community/help/
```

次にABCIで利用できるOpen MPIのバージョンを確認します。

```
[username@es1 ~]$ module avail openmpi

-------------------- /apps/modules/modulefiles/centos7/mpi ---------------------
openmpi/2.1.6          openmpi/3.1.6          openmpi/4.0.5(default)
```

``openmpi/4.0.5`` を使うのが適当のようです。少なくともメジャーバージョンが一致している必要があります。

### SingularityイメージのMPI実行 {#run-a-singularity-image-with-mpi}

2ノード占有でインタラクティブジョブを起動し、必要なモジュールを読み込みます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro openmpi/4.0.5
```

1ノードあたり4基のGPUがあり、2ノード占有では計8基のGPUが使えることになります。この場合、8個のプロセスをノードあたり4個ずつ並列に起動し、サンプルプログラム tensorflow_mnist.py を実行します。

```
[username@g0001 ~]$ wget https://raw.githubusercontent.com/horovod/horovod/v0.22.1/examples/tensorflow/tensorflow_mnist.py
[username@g0001 ~]$ mpirun -np 8 -npernode 4 singularity run --nv tensorflow_21.06-tf1-py3.sif python tensorflow_mnist.py
:
INFO:tensorflow:loss = 0.13635147, step = 30 (0.236 sec)
INFO:tensorflow:loss = 0.16320482, step = 30 (0.236 sec)
INFO:tensorflow:loss = 0.23524982, step = 30 (0.237 sec)
INFO:tensorflow:loss = 0.1300551, step = 30 (0.236 sec)
INFO:tensorflow:loss = 0.10259462, step = 30 (0.237 sec)
INFO:tensorflow:loss = 0.04606852, step = 30 (0.237 sec)
INFO:tensorflow:loss = 0.10536947, step = 30 (0.236 sec)
INFO:tensorflow:loss = 0.09811305, step = 30 (0.237 sec)
INFO:tensorflow:loss = 0.06823079, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.0671196, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.1545426, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.13310829, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.084449895, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.10252285, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.078794435, step = 40 (0.225 sec)
INFO:tensorflow:loss = 0.17852336, step = 40 (0.225 sec)
:
```

バッチジョブでも同様に実行できます。

```shell
#!/bin/sh
#$ -l rt_F=2
#$ -j y
#$ -cwd

source /etc/profile.d/modules.sh
module load singularitypro openmpi/4.0.5
wget https://raw.githubusercontent.com/horovod/horovod/v0.22.1/examples/tensorflow/tensorflow_mnist.py
mpirun -np 8 -npernode 4 singularity run --nv tensorflow_21.06-tf1-py3.sif python tensorflow_mnist.py
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

* [Generating Your NGC API Key](https://docs.nvidia.com/ngc/ngc-overview/index.html#generating-api-key)

インタラクティブノード上でSingularityイメージを生成します。Dockerイメージのダウンロードには、環境変数``SINGULARITY_DOCKER_USERNAME``, ``SINGULARITY_DOCKER_PASSWORD``の設定が必要です。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
[username@es1 ~]$ export SINGULARITY_DOCKER_PASSWORD=<NGC API Key>
[username@es1 ~]$ singularity pull docker://nvcr.io/partners/chainer:4.0.0b1
```

``chainer_4.0.0b1.sif``という名前のイメージファイルが生成されます。

環境変数の代わりに``--docker-login``オプションを指定してイメージをダウンロードすることも可能です。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull --disable-cache --docker-login docker://nvcr.io/partners/chainer:4.0.0b1
Enter Docker Username: $oauthtoken
Enter Docker Password: <NGC API Key>
```

### Singularityイメージの実行 {#run-a-singularity-image_1}

通常のSingularityイメージと同じ手順で実行できます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ wget https://raw.githubusercontent.com/chainer/chainer/v4.0.0b1/examples/mnist/train_mnist.py
[username@g0001 ~]$ singularity exec --nv chainer_4.0.0b1.sif python train_mnist.py -g 0
:
epoch       main/loss   validation/main/loss  main/accuracy  validation/main/accuracy  elapsed_time
1           0.191976    0.0931192             0.942517       0.9712            18.7328
2           0.0755601   0.0837004             0.9761         0.9737            20.6419
3           0.0496073   0.0689045             0.984266       0.9802            22.5383
4           0.0343888   0.0705739             0.988798       0.9796            24.4332
:
```

## 参考 {#reference}

1. [NGC Documentation](https://docs.nvidia.com/ngc/index.html)
1. [NGC Container User Guide for NGC Catalog](https://docs.nvidia.com/ngc/ngc-catalog-user-guide/index.html)
1. [Running Singularity Containers](https://docs.nvidia.com/ngc/ngc-catalog-user-guide/index.html#singularity)
1. [日本最速のスーパーコンピュータが NGC を採用し、ディープラーニング フレームワークの利用をより簡単に | NVIDIA](https://blogs.nvidia.co.jp/2019/06/19/abci-adopts-ngc/)

# コンテナ

ABCIではSingularityコンテナを利用してアプリケーション実行環境を作成できます。
これにより、利用者自身でカスタマイズした環境を作成したり、外部機関によって公式に配布されているコンテナイメージをもとにABCI上に同等の環境を構築し、計算することができます。

例えば、[NGC Catalog](https://catalog.ngc.nvidia.com/)からは各種の深層学習フレームワーク、CUDAやHPC環境がセットアップされたコンテナイメージを利用できます。

また、Docker Hubの公式リポジトリおよび検証済みリポジトリから、最新のソフトウェアがインストールされたコンテナイメージをダウンロードして使用することもできます。ただし、信頼できないコンテナイメージは使用しないように注意してください。
以下はDocker Hubで公開されているコンテナイメージの例です。

* [AWS CLI](https://hub.docker.com/r/amazon/aws-cli)
* [TensorFlow](https://hub.docker.com/r/tensorflow/tensorflow)
* [PyTorch](https://hub.docker.com/r/pytorch/pytorch)
* [Python](https://hub.docker.com/_/python)

## Singularity

ABCIシステムでは[SingularityCE](https://www.sylabs.io/singularity/)または、[SingularityPRO](https://sylabs.io/singularity-pro/)が利用可能です。
利用可能なバージョンはそれぞれSingularityCE 4.1、SingularityPRO 4.1となります。網羅的なユーザガイドは、以下にあります。

* [SingularityCE User Guide](https://docs.sylabs.io/guides/4.1/user-guide/) (英文)
* [SingularityPRO User Guide](https://repo.sylabs.io/guides/pro-4.1/user-guide/) (英文)

### SingularityCEの利用方法 {#how-to-use-singularityce}

SingularityCEはシステムにインストールされており、`singularity`コマンドにより利用可能です。

```
[username@hnode001 ~]$ singularity --version
singularity-ce version 4.1.5-1.el9
[username@hnode001 ~]$ 
```

### SingularityPROの利用方法 {#how-to-use-singularitypro}

SingularityPROは[モジュール](environment-modules.md)として提供しています。
SingularityPROを利用する場合は、`module load`コマンドを用いて利用環境を設定してください。

利用環境を設定後、`singularity`コマンドでSingularityPROが利用できます。

```
[username@hnode001 ~]$ module load singularitypro/4.1.7
[username@hnode001 ~]$ singularity --version
SingularityPRO version 4.1.7-1.el9
[username@hnode001 ~]$
```

### Singularityイメージファイルの作成(pull) {#create-a-singularity-image-pull}

Singularityコンテナイメージはファイルとして保存することが可能です。
ここでは、`pull`を用いたSingularityイメージファイルの作成手順を示します。

pullによるSingularityイメージファイルの作成例）

```
[username@login1 ~]$ singularity pull tensorflow.sif docker://tensorflow/tensorflow:latest-gpu
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
...
[username@login1 ~]$ ls tensorflow.sif
tensorflow.sif
```

### Singularityイメージファイルの作成(build) {#create-a-singularity-image-build}

ABCIシステムのSingularityCE環境では`fakeroot`オプションを使用することによりbuildを使ったイメージ構築が可能です。

!!! warning
    `fakeroot`オプションを使用する場合、`SINGULARITY_TMPDIR`環境変数に指定できる場所は、ノードローカルの領域のみ(/tmpや$PBS_LOCALDIRなど)となります。
    ホーム領域($HOME)、グループ領域(/groups/$YOUR_GROUP)は指定できません。

`build`によるSingularityイメージファイルの作成例）

```
[username@login1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@login1 ~]$ singularity build --fakeroot ubuntu.sif ubuntu.def
INFO:    Starting build...
(snip)
INFO:    Creating SIF file...
INFO:    Build complete: ubuntu.sif
[username@login1 singularity]$
```

なお、上記コマンドにおいてイメージファイル(ubuntu.sif)の出力先をグループ領域にするとエラーが発生します。その場合、singularityコマンドを実行する前に以下のように`id`コマンドでイメージ出力先グループ領域の所有グループを確認の上、`newgrp`コマンドを実施いただくことで回避可能です。
下記例の`gaa50000`の箇所がイメージ出力先グループ領域の所有グループとなります。

```
[username@login1 groupname]$ id -a
uid=10000(aaa10000aa) gid=10000(aaa10000aa) groups=10000(aaa10000aa),50000(gaa50000)
[username@login1 groupname]$ newgrp gaa50000
```

### コンテナの実行 {#running-a-container-with-singularity}

Singularityを利用する場合、ジョブ中に`singularity run`コマンドを実行しSingularityコンテナを起動します。
イメージファイルをコンテナで実行する場合は`singularity run`コマンドの引数でイメージファイルを指定します。
また、`singularity run`コマンドではDocker Hubで公開されているコンテナイメージを指定して実行することも可能です。

インタラクティブジョブにおけるSingularityイメージファイルを使用したコンテナの実行例）

```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1 -l walltime=1:00:00
[username@hnode001 ~]$ singularity run --nv ./tensorflow.sif
```

バッチジョブにおけるSingularityイメージファイルを使用したコンテナの実行例）

```
[username@login1 ~]$ cat job.sh
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
singularity exec --nv ./tensorflow.sif python3 sample.py

[username@login1 ~]$ qsub job.sh
```

Docker Hubで公開されているコンテナイメージの実行例）

以下の例はDocker Hubで公開されているTensorFlowのコンテナイメージを使用しSingularityを実行しています。
`singularity run`コマンドにより起動したSingularityコンテナ上で`python3 sample.py`を実行します。
コンテナイメージは初回起動時にダウンロードされ、ホーム領域にキャッシングされます。
2回目以降の起動はキャッシュされたデータを使用することで起動が高速化されます。

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1 -l walltime=1:00:00
[username@hnode001 ~]$ export SINGULARITY_TMPDIR=$PBS_LOCALDIR
[username@hnode001 ~]$ singularity run --nv docker://tensorflow/tensorflow:latest-gpu

________                               _______________
___  __/__________________________________  ____/__  /________      __
__  /  _  _ \_  __ \_  ___/  __ \_  ___/_  /_   __  /_  __ \_ | /| / /
_  /   /  __/  / / /(__  )/ /_/ /  /   _  __/   _  / / /_/ /_ |/ |/ /
/_/    \___//_/ /_//____/ \____//_/    /_/      /_/  \____/____/|__/


You are running this container as user with ID 10000 and group 10000,
which should map to the ID and group for your user on the Docker host. Great!

/sbin/ldconfig.real: Can't create temporary cache file /etc/ld.so.cache~: Read-only file system
Singularity> python3 sample.py
```

### DockerfileからのSingularityイメージファイルの作成方法 {#build-singularity-image-from-dockerfile}

Singularityでは、Dockerfileから直接Singularityで利用できるコンテナイメージを作成できません。
Dockerfileしかない場合には、次の2通りの方法にて、ABCIシステム上のSingularityで利用できるコンテナイメージを作成できます。

#### Docker Hubを経由 {#via-docker-hub}

Dockerの実行環境があるシステム上でDockerfileからDockerコンテナイメージを作成し、Docker Hubにアップロードすることで、作成したDockerコンテナイメージをABCIシステム上で利用することができるようになります。

以下の例では、NVIDIA社による[SSD300 v1.1モデル学習用コンテナイメージ](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD)をDockerfileから作成し、Docker Hubにアップロードしています。

```
[user@pc ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
[user@pc ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
[user@pc SSD]$ cat Dockerfile
ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:20.06-py3
FROM ${FROM_IMAGE_NAME}

# Set working directory
WORKDIR /workspace

ENV PYTHONPATH "${PYTHONPATH}:/workspace"

COPY requirements.txt .
RUN pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger.git#egg=dllogger
RUN pip install -r requirements.txt
RUN python3 -m pip install pycocotools==2.0.0

# Copy SSD code
COPY ./setup.py .
COPY ./csrc ./csrc
RUN pip install .

COPY . .
[user@pc SSD]$ docker build -t user/docker_name .
[user@pc SSD]$ docker login && docker push user/docker_name
```

作成したDockerコンテナイメージをABCI上で起動する方法については[コンテナの実行](#running-a-container-with-singularity)をご参照ください。

#### DockerfileをSingularity recipeファイルに変換 {#convert-dockerfile-to-singularity-recipe}

DockerfileをSingularity recipeファイルに変換することで、ABCIシステム上でSingularityコンテナイメージを作成できます。
変換には[Singularity Python](https://singularityhub.github.io/singularity-cli/)を使うことができます。

!!! warning
    Singularity Pythonを使うことでDockerfileとSingularity recipeファイルの相互変換を行うことができますが、完璧ではありません。
    変換されたSingularity recipeファイルにて`singularity build`に失敗する場合は、手動でrecipeファイルを修正してください。

Singularity Pythonのインストール例）

```
[username@login1 ~]$ python3 -m venv work
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ pip3 install spython
```

以下の例では、NVIDIA社による[SSD300 v1.1モデル学習用コンテナイメージ](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD)のDockerfileをSingularity recipeファイル（ssd.def）に変換し、正常にイメージを作成できるよう修正します。

変更点)

- WORKDIRにファイルがコピーされない => コピー先をWORKDIRの絶対パスに設定

```
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
(work) [username@login1 ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
(work) [username@login1 SSD]$ spython recipe Dockerfile ssd.def
(work) [username@login1 SSD]$ cp -p ssd.def ssd_org.def
(work) [username@login1 SSD]$ vi ssd.def
Bootstrap: docker
From: nvcr.io/nvidia/pytorch:22.10-py3
Stage: spython-base

%files
requirements.txt /workspace/ssd/  #<- WORKDIR以下にコピー
. /workspace/ssd/                 #<- WORKDIR以下にコピー
%post
FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:22.10-py3

# Set working directory
mkdir -p /workspace/ssd
cd /workspace/ssd

# Copy the model files

# Install python requirements
pip install --no-cache-dir -r requirements.txt
mkdir models #<- main.py実行時に必要なため追加

CUDNN_V8_API_ENABLED=1
TORCH_CUDNN_V8_API_ENABLED=1
%environment
export CUDNN_V8_API_ENABLED=1
export TORCH_CUDNN_V8_API_ENABLED=1
%runscript
cd /workspace/ssd
exec /bin/bash "$@"
%startscript
cd /workspace/ssd
exec /bin/bash "$@"
```

Singularity recipeファイルからのコンテナイメージの作成方法については、[Singularityイメージファイルの作成(build)](#create-a-singularity-image-build)をご参照ください。

### Singularity recipeファイル例

ここでは、Singularityのrecipeファイルの例を示します。
recipeファイルの詳細については[Singularity](#singularity)のユーザガイドを参照してください。

#### コンテナイメージ内にローカルファイルを組み込む場合

Open MPIおよびローカルのプログラムファイル(C言語)をコンパイルして、コンテナイメージに組み込む場合の例です。
ここでは、Singularity recipeファイル(openmpi.def)とプログラムファイル(mpitest.c)をホームディレクトリに用意します。

openmpi.def
```
Bootstrap: docker
From: ubuntu:latest

%files
    mpitest.c /opt

%environment
    export OMPI_DIR=/opt/ompi
    export SINGULARITY_OMPI_DIR=$OMPI_DIR
    export SINGULARITYENV_APPEND_PATH=$OMPI_DIR/bin
    export SINGULAIRTYENV_APPEND_LD_LIBRARY_PATH=$OMPI_DIR/lib

%post
    echo "Installing required packages..."
    apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file bzip2

    echo "Installing Open MPI"
    export OMPI_DIR=/opt/ompi
    export OMPI_VERSION=4.1.7
    export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$OMPI_VERSION.tar.bz2"
    mkdir -p /tmp/ompi
    mkdir -p /opt
    # Download
    cd /tmp/ompi && wget -O openmpi-$OMPI_VERSION.tar.bz2 $OMPI_URL && tar -xjf openmpi-$OMPI_VERSION.tar.bz2
    # Compile and install
    cd /tmp/ompi/openmpi-$OMPI_VERSION && ./configure --prefix=$OMPI_DIR && make install
    # Set env variables so we can compile our application
    export PATH=$OMPI_DIR/bin:$PATH
    export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
    export MANPATH=$OMPI_DIR/share/man:$MANPATH

    echo "Compiling the MPI application..."
    cd /opt && mpicc -o mpitest mpitest.c
```

mpitest.c
```
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char **argv) {
        int rc;
        int size;
        int myrank;

        rc = MPI_Init (&argc, &argv);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Init() failed\n");
                return EXIT_FAILURE;
        }

        rc = MPI_Comm_size (MPI_COMM_WORLD, &size);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Comm_size() failed\n");
                goto exit_with_error;
        }

        rc = MPI_Comm_rank (MPI_COMM_WORLD, &myrank);
        if (rc != MPI_SUCCESS) {
                fprintf (stderr, "MPI_Comm_rank() failed\n");
                goto exit_with_error;
        }

        fprintf (stdout, "Hello, I am rank %d/%d\n", myrank, size);

        MPI_Finalize();

        return EXIT_SUCCESS;

 exit_with_error:
        MPI_Finalize();
        return EXIT_FAILURE;
}
```

`singularity`コマンドでコンテナイメージをbuildします。
buildに成功すると、コンテナイメージ(openmpi.sif)が生成されます。
```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1
[username@hnode001 ~]$ singularity build --fakeroot openmpi.sif openmpi.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: openmpi.sif
[username@hnode001 ~]$
```

実行例)
```
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ mpirun -hostfile $PBS_NODEFILE -np 4 -map-by node singularity exec --env OPAL_PREFIX=/opt/ompi --env PMIX_INSTALL_PREFIX=/opt/ompi openmpi.sif /opt/mpitest
Hello, I am rank 2/4
Hello, I am rank 3/4
Hello, I am rank 0/4
Hello, I am rank 1/4
```

#### CUDA Toolkitを使用する場合

CUDA Toolkitを組み入れて [h2o4gpu](https://github.com/sylabs/examples/tree/eb713691a30cfd455e1de24cb014646bde404adb/machinelearning/h2o4gpu) で python を実行する場合の例です。
ここでは、Singularity recipeファイル(h2o4gpuPy.def)および動作確認用のスクリプト(h2o4gpu_sample.py)をホームディレクトリに用意します。

h2o4gpuPy.def
```
BootStrap: docker
From: nvidia/cuda:12.1.0-devel-ubuntu18.04

# Note: このコンテナは Python API のみを有効にしています。

%environment
# -----------------------------------------------------------------------------------
    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    export LC_ALL=C

%post
# -----------------------------------------------------------------------------------
# 必要なパッケージをインストールしてコンテナを準備します

    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64

    apt-get -y update
    apt-get install -y --no-install-recommends build-essential
    apt-get install -y --no-install-recommends git
    apt-get install -y --no-install-recommends vim
    apt-get install -y --no-install-recommends wget
    apt-get install -y --no-install-recommends ca-certificates
    apt-get install -y --no-install-recommends libjpeg-dev
    apt-get install -y --no-install-recommends libpng-dev
    apt-get install -y --no-install-recommends libpython3.6-dev
    apt-get install -y --no-install-recommends libopenblas-dev pbzip2
    apt-get install -y --no-install-recommends libcurl4-openssl-dev libssl-dev libxml2-dev

    apt-get install -y --no-install-recommends python3-pip
    apt-get install -y --no-install-recommends wget

    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python
    ln -s /usr/bin/pip3 /usr/bin/pip

    pip3 install setuptools
    pip3 install --upgrade pip

    wget https://s3.amazonaws.com/h2o-release/h2o4gpu/releases/stable/ai/h2o/h2o4gpu/0.4-cuda10/rel-0.4.0/h2o4gpu-0.4.0-cp36-cp36m-linux_x86_64.whl
    pip install h2o4gpu-0.4.0-cp36-cp36m-linux_x86_64.whl
```

h2o4gpu_sample.py
```
import h2o4gpu
import numpy as np
X = np.array([[1.,1.], [1.,4.], [1.,0.]])
model = h2o4gpu.KMeans(n_clusters=2,random_state=1234).fit(X)
print(model.cluster_centers_)
```

`singularity`コマンドでコンテナイメージをbuildします。
buildに成功すると、コンテナイメージ(h2o4gpuPy.sif)が生成されます。
```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=1
[username@hnode001 ~]$ singularity build --fakeroot h2o4gpuPy.sif h2o4gpuPy.def
INFO:    Starting build...
Getting image source signatures
(skip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: h2o4gpuPy.sif
[username@hnode001 ~]$
```

実行例
```
[username@hnode001 ~]$ module load cuda/12.6
[username@hnode001 ~]$ singularity exec --nv h2o4gpuPy.sif python3 h2o4gpu_sample.py
[[1.  0.5]
 [1.  4. ]]
[username@hnode001 ~]$
```

### 環境変数 {#environment-variables}

`singularity`コマンド実行時に利用可能な環境変数の一部を以下に記載します。

| 環境変数 | 説明 |
|:--|:--|
| SINGULARITYENV\_CUDA_VISIBLE\_DEVICES | Singularityから利用可能なGPUの制御 |
| SINGULARITYENV\_LD\_LIBRARY\_PATH | 指定されたコンテナ外のライブラリのパスがコンテナ内のLD_LIBRARY_PATHに適用される |
| SINGULARITY\_TMPDIR | 一時ディレクトリのパス |
| SINGULARITY\_BINDPATH | ホストシステムのディレクトリをコンテナ内にバインドマウント |

!!! note
    SINGULARITYENV\_*MYVAR*を利用することで、任意の環境変数*MYVAR*をコンテナ内に引き継ぐことが可能です。

また、`--nvccli`オプションを利用した場合に利用可能な環境変数の一部を以下に記載します。

| 環境変数 | 説明 |
|:--|:--|
| NVIDIA\_DRIVER\_CAPABILITIES | コンテナにおける機能制御 |
| NVIDIA\_REQUIRE\_* | cuda、driver、arch、brandの要件指定 |

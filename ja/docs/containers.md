# コンテナ

## Singularity

!!! warning
    Singularity 2.6 は2021年3月末に提供を停止しました。

ABCIシステムでは[Singularity](https://www.sylabs.io/singularity/)が利用可能です。
利用可能なバージョンはSingularityPRO 3.7となります。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。

```
[username@g0001 ~]$ module load singularitypro
```

より網羅的なユーザガイドは、以下にあります。

* [SingularityPRO User Guide](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/)

Singularityを用いて、NGCが提供するDockerイメージをABCIで実行する方法は、[NVIDIA NGC](tips/ngc.md) で説明しています。

### Singularityイメージファイルの作成(pull) {#create-a-singularity-image-pull}

Singularityコンテナイメージはファイルとして保存することが可能です。
ここでは、`pull`を用いたSingularityイメージファイルの作成手順を示します。

pullによるSingularityイメージファイルの作成例）

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull caffe2.img docker://caffe2ai/caffe2:latest
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
...
[username@es1 ~]$ ls caffe2.img
caffe2.img
```

### Singularityイメージファイルの作成(build) {#create-a-singularity-image-build}

ABCIシステムのSingularityPRO環境では`fakeroot`オプションを使用することによりbuildを使ったイメージ構築が可能です。

!!! note
    SingularityPRO環境ではリモートビルドも利用可能です。詳細は[ABCI Singularity エンドポイント](abci-singularity-endpoint.md)を参照して下さい。

buildによるSingularityイメージファイルの作成例）

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:18.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@es1 ~]$ singularity build --fakeroot ubuntu.sif ubuntu.def
INFO:    Starting build...
(snip)
INFO:    Creating SIF file...
INFO:    Build complete: ubuntu.sif
[username@es1 singularity]$
```

なお、上記コマンドにおいてイメージファイル(ubuntu.sif)の出力先をグループ領域(/groups1, /groups2)にするとエラーが発生します。その場合、singularityコマンドを実行する前に以下のように`id`コマンドでイメージ出力先グループ領域の所有グループを確認の上、`newgrp`コマンドを実施いただくことで回避可能です。
下記例の`gaa00000`の箇所がイメージ出力先グループ領域の所有グループとなります。

```
[username@es1 groupname]$ id -a
uid=0000(aaa00000aa) gid=0000(aaa00000aa) groups=0000(aaa00000aa),00000(gaa00000)
[username@es1 groupname]$ newgrp gaa00000
```

### コンテナの実行 {#running-a-container-with-singularity}

Singularityを利用する場合、ジョブ中に`singularity run`コマンドを実行しSingularityコンテナを起動します。
イメージファイルをコンテナで実行する場合は`singularity run`コマンドの引数でイメージファイルを指定します。
また、`singularity run`コマンドではDocker Hubで公開されているコンテナイメージを指定して実行することも可能です。

インタラクティブジョブにおけるSingularityイメージファイルを使用したコンテナの実行例）

```
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run ./caffe2.img
```

バッチジョブにおけるSingularityイメージファイルを使用したコンテナの実行例）

```
[username@es1 ~]$ cat job.sh
#!/bin/sh
#$-l rt_F=1
#$-j y
source /etc/profile.d/modules.sh
module load singularitypro openmpi/3.1.6

mpiexec -n 4 singularity exec --nv ./caffe2.img \
    python sample.py

[username@es1 ~]$ qsub -g grpname job.sh
```

Docker Hubで公開されているコンテナイメージの実行例）

以下の例はDocker Hubで公開されているcaffe2のコンテナイメージを使用しSingularityを実行しています。
`singularity run`コマンドにより起動したSingularityコンテナ上で`python sample.py`が実行されます。
コンテナイメージは初回起動時にダウンロードされ、ホーム領域にキャッシングされます。
2回目以降の起動はキャッシュされたデータを使用することで起動が高速化されます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv docker://caffe2ai/caffe2:latest
...
Singularity> python sample.py
True
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
[username@es1 ~]$ module load python/3.6/3.6.12
[username@es1 ~]$ python3 -m venv work
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ pip3 install spython
```

以下の例では、NVIDIA社による[SSD300 v1.1モデル学習用コンテナイメージ](https://github.com/NVIDIA/DeepLearningExamples/tree/master/PyTorch/Detection/SSD)のDockerfileをSingularity recipeファイル（ssd.def）に変換し、正常にイメージを作成できるよう修正します。

Dockerfileから変換しただけでは次の2点の問題が発生するため、それぞれの対処が必要となります。

- WORKDIRにファイルがコピーされない => コピー先をWORKDIRの絶対パスに設定
- pipにパスが通らない => %postセクションにDockerイメージの環境変数を引き継ぐ設定を追加

```
[username@es1 ~]$ module load python/3.6/3.6.12
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ git clone https://github.com/NVIDIA/DeepLearningExamples
(work) [username@es1 ~]$ cd DeepLearningExamples/PyTorch/Detection/SSD
(work) [username@es1 SSD]$ spython recipe Dockerfile ssd.def
(work) [username@es1 SSD]$ cp -p ssd.def ssd_org.def
(work) [username@es1 SSD]$ vi ssd.def
Bootstrap: docker
From: nvcr.io/nvidia/pytorch:20.06-py3
Stage: spython-base

%files
requirements.txt /workspace                     <- コピー先を相対パス（.）から絶対パスに変更
./setup.py /workspace                           <- コピー先を相対パス（.）から絶対パスに変更
./csrc /workspace/csrc                          <- コピー先を相対パス（.）から絶対パスに変更
. /workspace                                    <- コピー先を相対パス（.）から絶対パスに変更
%post
FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:20.06-py3
. /.singularity.d/env/10-docker2singularity.sh  <- 追加

# Set working directory
cd /workspace

PYTHONPATH="${PYTHONPATH}:/workspace"

pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger.git#egg=dllogger
pip install -r requirements.txt
python3 -m pip install pycocotools==2.0.0

# Copy SSD code
pip install .

%environment
export PYTHONPATH="${PYTHONPATH}:/workspace"
%runscript
cd /workspace
exec /bin/bash "$@"
%startscript
cd /workspace
exec /bin/bash "$@"
```

Singularity recipeファイルからのコンテナイメージの作成方法については、[Singularityイメージファイルの作成(build)](#create-a-singularity-image-build)をご参照ください。

### Singularity recipeファイル例

ここでは、Singularityのrecipeファイルの例を示します。
recipeファイルの詳細については[Singularity](#singularity)のユーザガイドを参照願います。

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
    apt-get update && apt-get install -y wget git bash gcc gfortran g++ make file

    echo "Installing Open MPI"
    export OMPI_DIR=/opt/ompi
    export OMPI_VERSION=4.0.5
    export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-$OMPI_VERSION.tar.bz2"
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
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity build --fakeroot openmpi.sif openmpi.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: openmpi.sif
[username@g0001 ~]$
```

実行例
```
[username@g0001 ~]$ module load singularitypro openmpi/4.0.5
[username@g0001 ~]$ mpirun -np 4 -map-by node singularity exec openmpi.sif /opt/mpitest
Hello, I am rank 2/4
Hello, I am rank 3/4
Hello, I am rank 0/4
Hello, I am rank 1/4
```

#### CUDA Toolkitを使用する場合

[CUDA Toolkit](gpu.md#cuda-toolkit)を組み入れて [h2o4gpu](https://github.com/sylabs/examples/tree/eb713691a30cfd455e1de24cb014646bde404adb/machinelearning/h2o4gpu) で python を実行する場合の例です。
ここでは、Singularity recipeファイル(h2o4gpuPy.def)および動作確認用のスクリプト(h2o4gpu_sample.py)をホームディレクトリに用意します。

h2o4gpuPy.def
```
BootStrap: docker
From: nvidia/cuda:10.2-devel-ubuntu18.04

# Note: This container will have only the Python API enabled

%environment
# -----------------------------------------------------------------------------------

    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    export LC_ALL=C

%post
# -----------------------------------------------------------------------------------
# this will install all necessary packages and prepare the contianer

    export PYTHON_VERSION=3.6
    export CUDA_HOME=/usr/local/cuda
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64/:$CUDA_HOME/lib/:$CUDA_HOME/extras/CUPTI/lib64

    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

    apt-get -y update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        libpython3.6-dev \
        libopenblas-dev pbzip2 \
        libcurl4-openssl-dev libssl-dev libxml2-dev

    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

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
[username@es1 ~]$ qrsh -g grpname -l rt_G.small=1
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity build --fakeroot h2o4gpuPy.sif h2o4gpuPy.def
INFO:    Starting build...
Getting image source signatures
(snip)
INFO:    Adding environment to container
INFO:    Creating SIF file...
INFO:    Build complete: h2o4gpuPy.sif
[username@g0001 ~]$
```

実行例
```
[username@g0001 ~]$ module load singularitypro openmpi/4.0.5 cuda/10.2
[username@g0001 ~]$ singularity exec --nv h2o4gpuPy.sif python3 h2o4gpu_sample.py
[[1.  0.5]
 [1.  4. ]]
[username@g0001 ~]$
```

## Docker

ABCIシステムではDockerコンテナ上でのジョブ実行が可能です。
Dockerを利用する場合、ジョブ投入時に`-l docker`オプションと`-l docker_images`オプションを指定する必要があります。

| オプション | 説明 |
|:--|:--|
| -l docker | ジョブをDockerコンテナ上で実行します。 |
| -l docker_images | 利用するDockerイメージを指定します。 |

!!! warning
    ABCIシステムでは、メモリインテンシブノードではDockerを利用できません。

利用可能なDockerイメージは`show_docker_images`コマンドで参照可能です。

```
[username@es1 ~]$ show_docker_images
REPOSITORY                TAG             IMAGE ID     CREATED       SIZE
jcm:5000/dhub/ubuntu      latest          113a43faa138 3 weeks ago   81.2MB
```

!!! warning
    ABCIシステムでは、システム内で公開されているDockerイメージのみ利用可能です。

Dockerジョブのジョブスクリプト例）

以下のジョブスクリプトでは`python3 ./sample.py`がDockerコンテナ上で実行されます。

```
[username@es1 ~]$ cat run.sh
#!/bin/sh
#$-cwd
#$-j y
#$-l rt_F=1
#$-l docker=1
#$-l docker_images="*jcm:5000/dhub/ubuntu*"

python3 ./sample.py
```

Dockerジョブの投入例）

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 12345 ("run.sh") has been submitted
```

!!! warning
    Dockerコンテナはノード占有ジョブでのみ利用可能です。

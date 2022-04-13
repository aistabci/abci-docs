
# 提供を終了したモジュールとその代替手段

2022年度の開始にあたり、ABCIで提供しているモジュールの再構成を行いました。
再構成によりサポートが終了したソフトウェアを最新のEnvironment Modulesから削除しています。

なお、過去のEnvironment Modulesは別途提供していますので、削除したモジュールを利用したい場合はFAQ [過去のABCI Environment Modulesを利用したい](../faq.md#q-how-to-use-previous-abci-environment-modules)を参考に設定を行なってください。

ここでは削除したモジュールをSingularityコンテナとして実行する方法、および、ホームディレクトリ下にインストールして利用する方法を説明します。
本文中のインストールパスは適宜変更してください。

2022年度に削除したモジュールは以下の通りです。

| ソフトウェア                                            | モジュール名  |
| ------------------------------------------------------- | ------------- |
| [NVIDIA HPC SDK](#nvidia-hpc-sdk)                       | nvhpc         |
| [Lua](#lua)                                             | lua           |
| [MVAPICH2](#mvapich2)                                   | mvapich2      |
| [CUDA-aware Open MPI](#cuda-aware-open-mpi)             | openmpi       |
| [Apache Hadoop](#apache-hadoop)                         | hadoop        |
| [Apache Spark](#apache-spark)                           | spark         |
| [Singularity Global Client](#singularity-global-client) | sregistry-cli |

また、[Spack](https://spack.io)を使用して独自にソフトウェアをインストール、管理することもできます。Spackの利用については[Spackによるソフトウェア管理](spack.md)を参照してください。

## NVIDIA HPC SDK {#nvidia-hpc-sdk}

NVIDIA HPC SDKはNVIDIA NGCで提供されている[コンテナ](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nvhpc)を利用します。

Singularityを使用してコンテナを作成し、作成したコンテナを使ってCUDAプログラムのビルドおよび実行を行う方法を説明します。
なお、コンテナイメージのバージョンは適宜変更してください。

まず、開発用コンテナをダウンロードします。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/nvhpc:22.3-devel-cuda11.6-ubuntu20.04
```

次に、サンプルプログラムをビルドします。
サンプルプログラムはコンテナ内の`/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/examples/CUDA-Fortran/SDK/bandwidthTest`をホームディレクトリにコピーして使用します。

```
[username@es1 ~]$ singularity shell --nv nvhpc_22.3-devel-cuda11.6-ubuntu20.04.sif
Singularity> export CUDA_HOME=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/cuda
Singularity> export CUDA_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/cuda
Singularity> cp -r /opt/nvidia/hpc_sdk/Linux_x86_64/22.3/examples/CUDA-Fortran/SDK/bandwidthTest ./
Singularity> cd bandwidthTest/
Singularity> make build
```

最後に、実行用コンテナをダウンロードし、ビルドしたプログラムを実行します。

```
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/nvhpc:22.3-runtime-cuda11.6-ubuntu20.04
[username@es1 ~]$ ls bandwidthTest/
Makefile  bandwidthTest.cuf  bandwidthTest.out
[username@es1 ~]$ singularity run --nv nvhpc_22.3-runtime-cuda11.6-ubuntu20.04.sif bandwidthTest/bandwidthTest.out
```

## Lua {#lua}

Luaはソースからインストールして利用します。
ここでは `$HOME/apps/lua` 以下にインストールします。

```
[username@es1 ~]$ wget http://www.lua.org/ftp/lua-5.4.4.tar.gz
[username@es1 ~]$ tar xzf lua-5.4.4.tar.gz
[username@es1 ~]$ cd lua-5.4.4
[username@es1 ~]$ make && make install INSTALL_TOP=$HOME/apps/lua
[username@es1 ~]$ export PATH=$HOME/apps/lua/bin:$PATH
[username@es1 ~]$ lua -v
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
```

## MVAPICH2 {#mvapich2}

MVAPICH2はソースからインストールして利用します。
ここでは `$HOME/apps/mvapich2` 以下にインストールします。

```
[username@es1 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.7.tar.gz
[username@es1 ~]$ tar xzf mvapich2-2.3.7.tar.gz
[username@es1 ~]$ cd mvapich2-2.3.7
[username@es1 ~]$ ./configure --prefix=$HOME/apps/mvapich2
[username@es1 ~]$ make -j8
[username@es1 ~]$ make install
[username@es1 ~]$ export PATH=$HOME/apps/mvapich2/bin:$PATH
[username@es1 ~]$ mpicc --version
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-28)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## CUDA-aware Open MPI {#cuda-aware-open-mpi}

CUDA-aware Open MPIはソースからインストールして利用します。
ここでは `$HOME/apps/openmpi` 以下にインストールします。
利用したいCUDAバージョンは適宜変更してください。ここではCUDA 11.6を使用します。

```
[username@es1 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.3.tar.gz
[username@es1 ~]$ tar xvf openmpi-4.1.3.tar.gz
[username@es1 ~]$ module load gcc/11.2.0 cuda/11.6
[username@es1 ~]$ cd openmpi-4.1.3/
[username@es1 ~]$ ./configure --prefix=$HOME/apps/openmpi --enable-mpi-thread-multiple --with-cuda=$CUDA_HOME --enable-orterun-prefix-by-default --with-sge
[username@es1 ~]$ make -j8
[username@es1 ~]$ make install
[username@es1 ~]$ export PATH=$HOME/apps/openmpi/bin:$PATH
[username@es1 ~]$ mpicc --version
gcc (GCC) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
[username@es1 ~]$ ompi_info --parsable --all | grep mpi_built_with_cuda_support:value
mca:mpi:base:param:mpi_built_with_cuda_support:value:true
```

## Apache Hadoop {#apache-hadoop}

Apache Hadoopはビルド済みのバイナリをダウンロードし利用します。
ここでは `$HOME/apps/hadoop` 以下にインストールします。

```
[username@es1 ~]$ wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
[username@es1 ~]$ mkdir $HOME/apps/hadoop
[username@es1 ~]$ tar xzf hadoop-3.3.2.tar.gz -C $HOME/apps/hadoop --strip-components 1
[username@es1 ~]$ export PATH=$HOME/apps/hadoop/bin:$PATH
[username@es1 ~]$ export HADOOP_HOME=$HOME/apps/hadoop
[username@es1 ~]$ module load openjdk/11.0.14.1.1
[username@es1 ~]$ hadoop version
Hadoop 3.3.2
Source code repository git@github.com:apache/hadoop.git -r 0bcb014209e219273cb6fd4152df7df713cbac61
Compiled by chao on 2022-02-21T18:39Z
Compiled with protoc 3.7.1
From source with checksum 4b40fff8bb27201ba07b6fa5651217fb
```


## Apache Spark {#apache-spark}

Apache Sparkはビルド済みのバイナリをダウンロードし利用します。
ここでは `$HOME/apps/spark` 以下にインストールします。

```
[username@es1 ~]$ wget https://downloads.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
[username@es1 ~]$ mkdir $HOME/apps/spark
[username@es1 ~]$ tar xf spark-3.2.1-bin-hadoop3.2.tgz -C $HOME/apps/spark --strip-components 1
[username@es1 ~]$ export PATH=$HOME/apps/spark/bin:$PATH
[username@es1 ~]$ export SPARK_HOME=$HOME/apps/spark
[username@es1 ~]$ module load openjdk/11.0.14.1.1
[username@es1 ~]$ spark-submit --version
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/home/aaa10126pn/apps/spark/jars/spark-unsafe_2.12-3.2.1.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.2.1
      /_/
                        
Using Scala version 2.12.15, OpenJDK 64-Bit Server VM, 11.0.14.1
Branch HEAD
Compiled by user hgao on 2022-01-20T19:26:14Z
Revision 4f25b3f71238a00508a356591553f2dfa89f8290
Url https://github.com/apache/spark
Type --help for more information.
```

## Singularity Global Client {#singularity-global-client}

Singularity Global Clientはpipコマンドでインストールし利用します。
ここでは仮想環境を `$HOME/venv/sregistry` に作成しSingularity Global Clientをインストールします。

```
[username@es1 ~]$ module load module load gcc/11.2.0 python/3.8 singularitypro
[username@es1 ~]$ python3 -m venv venv/sregistry
[username@es1 ~]$ source venv/sregistry/bin/activate
(sregistry) [username@es1 ~]$ pip3 install --upgrade pip setuptools
(sregistry) [username@es1 ~]$ pip3 install sregistry[all]
```

また、`sregistry pull`を実行する際に`umask 0022`を実行してください。
デフォルトの`umask 0027`で`sregister pull`したコンテナは、権限が足りず実行に失敗する場合があるためです。

```
(sregistry) [username@es1 ~]$ umask 0022
(sregistry) [username@es1 ~]$ sregistry pull docker://alpine
(sregistry) [username@es1 ~]$ umask 0027
(sregistry) [username@es1 ~]$ singularity exec `sregistry get alpine` uname -a
Linux es1.abci.local 3.10.0-862.el7.x86_64 #1 SMP Fri Apr 20 16:44:24 UTC 2018 x86_64 Linux
```


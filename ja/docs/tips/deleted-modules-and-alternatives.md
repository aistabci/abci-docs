
# 2022年度に提供を停止したモジュールとその代替手段 

2022年度の開始にあたり、ABCIで提供しているモジュールの再構成を行いました。
再構成によりサポートが終了したソフトウェアをEnvironment Modulesから削除しました。

削除したモジュールは以下の通りです。

|                                                         | モジュール名  |
| ------------------------------------------------------- | ------------- |
| [NVIDIA HPC SDK](#nvidia-hpc-sdk)                       | nvhpc         |
| [Lua](#lua)                                             | lua           |
| [MVAPICH2](#mvapich2)                                   | mvapich2      |
| [CUDA-aware Open MPI](#cuda-aware-open-mpi)             | openmpi       |
| [Apache Hadoop](#apache-hadoop)                         | hadoop        |
| [Apache Spark](#apache-spark)                           | spark         |
| [Singularity Global Client](#singularity-global-client) | sregistry-cli |

ここでは削除したモジュールをSingularityコンテナとして実行する方法、および、ホームディレクトリ下にインストールして利用する方法を説明します。
インストールパスは適宜変更してください。

<!--
- curlなのかwgetなのか統一するべき、ここではwgetを使う.
- ログをファイルに書き出すのかどうかも統一した方がいい。ここでは書き出さない。垂れ流し。
- tarのオプションの並びに統一性がない... xzfを使う. 
- PATHを設定するところまでやろう。
-->

## NVIDIA HPC SDK {#nvidia-hpc-sdk}

NVIDIA HPC SDKはNVIDIA NGCで提供されている[コンテナ](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nvhpc)を利用します。
Singularityを使用してCUDAプログラムのビルドおよび実行手順を説明します。
なお、コンテナイメージのバージョンは適宜変更してください。

開発用コンテナをダウンロードします。

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/nvhpc:22.3-devel-cuda11.6-ubuntu20.04
```

サンプルプログラムをビルドします。

サンプルプログラムはコンテナ内の`/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/examples/CUDA-Fortran/SDK/bandwidthTest`をホームディレクトリにコピーして使用します。

```
[username@es1 ~]$ singularity shell --nv nvhpc_22.3-devel-cuda11.6-ubuntu20.04.sif
Singularity> export CUDA_HOME=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/cuda
Singularity> export CUDA_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/cuda
Singularity> cp -r /opt/nvidia/hpc_sdk/Linux_x86_64/22.3/examples/CUDA-Fortran/SDK/bandwidthTest ./
Singularity> cd bandwidthTest/
Singularity> make build
```

ビルドしたプログラムを実行用コンテナで実行します。

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
[username@es1 ~]$ which mpicc
~/apps/mvapich2/bin/mpicc
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

<!-- 
- cuda 11.6でいいかね?
-->

```
[username@es1 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.3.tar.gz
[username@es1 ~]$ tar xvf openmpi-4.1.3.tar.gz
[username@es1 ~]$ module load gcc/11.2.0 cuda/11.6
[username@es1 ~]$ cd openmpi-4.1.3/
[username@es1 ~]$ ./configure --prefix=$HOME/apps/openmpi --enable-mpi-thread-multiple --with-cuda=$CUDA_HOME --enable-orterun-prefix-by-default --with-sge
[username@es1 ~]$ make -j8
[username@es1 ~]$ make install
[username@es1 ~]$ export PATH=$HOME/apps/openmpi/bin:$PATH
[username@es1 ~]$ which mpicc
~/apps/openmpi/bin/mpicc
[username@es1 ~]$ mpicc --version
gcc (GCC) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

<!--
簡単な実行方法ものせた方がいいのでは?
-->

## Apache Hadoop {#apache-hadoop}

Apache Hadoopはビルド済みのバイナリをダウンロードし利用します。
ここでは `$HOME/apps/hadoop` 以下にインストールします。

```
[username@es1 ~]$ wget https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
[username@es1 ~]$ mkdir $HOME/apps/hadoop
[username@es1 ~]$ tar xzf hadoop-3.3.2.tar.gz -C $HOME/apps/hadoop --strip-components 1
[username@es1 ~]$ export PATH=$HOME/apps/hadoop/bin:$PATH
[username@es1 ~]$ module load openjdk/11.0.14.1.1
[username@es1 ~]$ hadoop version
```


## Apache Spark {#apache-spark}

Apache Sparkはビルド済みのバイナリをダウンロードし利用します。
ここでは `$HOME/apps/spark` 以下にインストールします。

```
[username@es1 ~]$ wget https://downloads.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
[username@es1 ~]$ mkdir $HOME/apps/spark
[username@es1 ~]$ tar xf spark-3.2.1-bin-hadoop3.2.tgz -C $HOME/apps/spark --strip-components 1
[username@es1 ~]$ export PATH=$HOME/apps/spark/bin:$PATH
[username@es1 ~]$ module load openjdk/11.0.14.1.1
[username@es1 ~]$ $HOME/apps/spark/bin/run-example SparkPi 10
```

## Singularity Global Client {#singularity-global-client}

Singularity Global Clientはpipコマンドでインストールし利用します。
ここでは仮想環境を `$HOME/venv/sregistry` に作成しSingularity Global Clientをインストールします。

<!--
- sregistry pullする際に umask 0022 する方法を説明する?
  それともパッチを用意して当ててもらう? umaskかなぁ...
  - インストール時にsingularityいるんだっけ?
説明としては、
- ファイルのother権限を落とすumaskだと、sregistry pullしてコンテナイメージを作成する際に利用できないイメージが作成される場合がある。
  これを回避するため、sregistry pull実行時は umask 0022 を実行しotherが読み取れるようにする必要がある。
-->

```
[username@es1 ~]$ module load singularitypro/3.7 gcc/9.3.0 python/3.8/3.8.7
[username@es1 ~]$ python3 -m venv sregistry
[username@es1 ~]$ source sregistry/bin/activate
(sregistry) $ pip install --upgrade pip setuptools
(sregistry) $ pip install sregistry[all]
```



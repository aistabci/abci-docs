
# 2022年度に提供を停止したモジュールとその代替手段 

* 2022年度の開始にあたり、ABCIで提供しているモジュールの再構成を行なった。
* 再構成にあたり、サポートが終了したソフトウェアをEnvironment Modulesから削除した。
* 削除したモジュールは以下の通り
  * nvhpc(NVidia HPC SDKが正式名称), lua, mvapich2, cuda-aware-mpi, hadoop, spark, sregistry-cli
* ここでは削除したモジュールをSingularityコンテナとして実行する方法、および、ホームディレクトリ下にインストールして利用する方法を説明する。

## NVIDIA HPC SDK

* NVIDIA HPC SDKはNVIDIA NGCで提供されているイメージが利用できる。
* Singularityを利用してCUDAプログラムのビルドおよび実行例を示す。
* コンテナイメージのバージョンは適宜変更すること。

<!-- 22.3 がでてるcuda 11.6, 11.0, 10.2用のイメージがある.-->

開発用コンテナのダウンロード:

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/nvhpc:22.1-devel-cuda11.5-ubuntu20.04
```

CUDAプログラムのビルド:

<!--
sakabeさんの例なんだけど、これ何をmakeしてるの?
CUDAサンプルっぽいのだけど、どこで用意するのかの指示がない。 コンテナ内でmakeやっても書き込みは不可だよね?
-->

```
[username@es1 ~]$ ls
nvhpc_22.1-devel-cuda11.5-ubuntu20.04.sif 
[username@es1 ~]$ singularity shell --nv nvhpc_22.1-devel-cuda11.5-ubuntu20.04.sif
Singularity> export CUDA_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/22.1/cuda
Singularity> make
```

ビルドプログラムを実行する:

```
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/nvhpc:22.1-runtime-cuda11.5-ubuntu20.04
[username@es1 ~]$ ls
nvhpc_22.1-devel-cuda11.5-ubuntu20.04.sif nvhpc_22.1-runtime-cuda11.5-ubuntu20.04.sif
[username@es1 ~]$ singularity run --nv nvhpc_22.1-runtime-cuda11.5-ubuntu20.04.sif bandwidthTest
[CUDA Bandwidth Test] - Starting...
Running on...
(snip)
```

## Lua

## MVAPICH2

## CUDA-aware Open MPI

## Apache Hadoop

## Apache Spark

## Singularity Global Client

sregistry-cli


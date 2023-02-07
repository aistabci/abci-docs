# MPI

ABCIシステムでは、以下のMPIを利用できます。

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Open MPI](https://www.open-mpi.org/)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
インタラクティブノードで`module`コマンドを用いると、コンパイル用環境変数（ヘッダファイルおよびライブラリのサーチパス）が自動で設定されます。
計算ノードで`module`コマンドを用いると、コンパイル用環境変数に加え、実行用環境変数も自動で設定されます。

```
[username@es-a1 ~]$ module load hpcx/2.11
```

```
[username@es1 ~]$ module load openmpi/4.0.5
```

```
[username@es1 ~]$ module load intel-mpi/2021.7
```

以下では、ABCIシステムに導入されているMPIのバージョン一覧を示します。

## NVIDIA HPC-X

計算ノード(A):

| Module Version | MPI Version |
| :-- | :-- |
| 2.11 | 4.1.4rc1 |

!!! note
    計算ノード(V)向けのNVIDIA HPC-Xは現在提供していません。

### 使用方法

ここでは、NVIDIA HPC-Xモジュールの使用方法を説明します。

ABCIで提供しているHPC-Xモジュールには以下の種類があります。用途に応じてモジュールを読み込んでください。

| モジュール名 | 説明 |
| :-- | :-- |
| hpcx       | 標準  |
| hpcx-mt    | マルチスレッド対応  |
| hpcx-debug | デバッグ用          |
| hpcx-prof  | プロファイリング用  |

また、ジョブ内で`mpirun`、`mpiexec`コマンドを実行する際には`-hostfile`オプションにホストファイルを指定します。
ホストファイルは`SGE_JOB_HOSTLIST`環境変数に設定されています。

```
[username@es-a1 ~]$ qrsh -g groupname -l rt_AF=2 -l h_rt=01:00:0
[username@a0000 ~]$ module load hpcx/2.11
[username@a0000 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $SGE_JOB_HOSTLIST ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.4rc1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.4rc1, repo rev: v4.1.4rc1, Unreleased developer copy, 135)
Hello, world, I am 1 of 2, (Open MPI v4.1.4rc1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.4rc1, repo rev: v4.1.4rc1, Unreleased developer copy, 135)
```

NVIDIA HPC-XではNCCL-SHARPプラグインを提供しています。
プラグインはHPC-Xのバージョンごとに対応するNCCLのバージョンが異なります。HPC-XとNCCLの対応は以下の表を参照してください。

| HPC-Xバージョン | NCCL バージョン |
| :-- | :-- |
| 2.11 | 2.8、2.9、2.10、2.11 |

SHARPおよびNCCL-SHARPプラグインの使用方法については[SHARPの利用](tips/sharp.md)を参照してください。

NVIDIA HPC-Xについて、より詳しい情報は[公式ドキュメント](https://docs.nvidia.com/networking/category/hpcx)を参照してください。

## Open MPI

計算ノード(V):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/4.8.5     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/4.8.5     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

計算ノード(A):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/8.3.1     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/8.3.1     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2021.7 | Yes | Yes |

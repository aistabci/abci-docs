# MPI

ABCIシステムでは、以下のMPIを利用できます。

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
インタラクティブノードで`module`コマンドを用いると、コンパイル用環境変数（ヘッダファイルおよびライブラリのサーチパス）が自動で設定されます。
計算ノードで`module`コマンドを用いると、コンパイル用環境変数に加え、実行用環境変数も自動で設定されます。

```
[username@es1 ~]$ module load hpcx/2.12
```

```
[username@es1 ~]$ module load intel-mpi/2021.8
```

以下では、ABCIシステムに導入されているMPIのバージョン一覧を示します。

## NVIDIA HPC-X

| Module Version | Open MPI Version |  Compute Node (V) | Compute Node (A) |
| :-- | :-- | :-- | :-- |
| 2.12 | 4.1.5a1 | Yes | Yes |

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
[username@es1 ~]$ qrsh -g groupname -l rt_F=2 -l h_rt=01:00:0
[username@g0001 ~]$ module load hpcx/2.12
[username@g0001 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $SGE_JOB_HOSTLIST ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
Hello, world, I am 1 of 2, (Open MPI v4.1.5a1, package: Open MPI root@hpc-kernel-03 Distribution, ident: 4.1.5a1, repo rev: v4.1.4-2-g1c67bf1c6a, Unreleased developer copy, 144)
```

NVIDIA HPC-XではNCCL-SHARPプラグインを提供しています。
プラグインはHPC-Xのバージョンごとに対応するNCCLのバージョンが異なります。HPC-XとNCCLの対応は以下の表を参照してください。

| HPC-Xバージョン | NCCL バージョン |
| :-- | :-- |
| 2.12 | 2.12 |

SHARPおよびNCCL-SHARPプラグインの使用方法については[SHARPの利用](tips/sharp.md)を参照してください。

NVIDIA HPC-Xについて、より詳しい情報は[公式ドキュメント](https://docs.nvidia.com/networking/category/hpcx)を参照してください。

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2021.8 | Yes | Yes |

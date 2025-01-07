# MPI

ABCIシステムでは、以下のMPIを利用できます。

* [NVIDIA HPC-X](https://developer.nvidia.com/networking/hpc-x)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
インタラクティブノードで`module`コマンドを用いると、コンパイル用環境変数（ヘッダファイルおよびライブラリのサーチパス）が自動で設定されます。
計算ノードで`module`コマンドを用いると、コンパイル用環境変数に加え、実行用環境変数も自動で設定されます。

```
[username@login1 ~]$ module load hpcx/2.20
```

```
[username@login1 ~]$ module load intel-mpi/2021.13
```

以下では、ABCIシステムに導入されているMPIのバージョン一覧を示します。

## NVIDIA HPC-X

| Module Version | Open MPI Version |  Compute Node (H) |
| :-- | :-- | :-- | 
| 2.20 | 4.1.7a1 | Yes |

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
ホストファイルは`PBS_NODEFILE`環境変数に設定されています。

```
[username@login1 ~]$ qsub -I -P groupname -q rt_HF -l select=2:mpiprocs=192 -l walltime=01:00:00
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ mpirun -np 2 -map-by ppr:1:node -hostfile $PBS_NODEFILE ./hello_c
Hello, world, I am 0 of 2, (Open MPI v4.1.7a1, package: Open MPI root@hnode001 Distribution, ident: 4.1.7a1, repo rev: v4.1.5-115-g41ba5192d2, Unreleased developer copy, 141)
Hello, world, I am 1 of 2, (Open MPI v4.1.7a1, package: Open MPI root@hnode001 Distribution, ident: 4.1.7a1, repo rev: v4.1.5-115-g41ba5192d2, Unreleased developer copy, 141)
```

NVIDIA HPC-XではNCCL-SHARPプラグインを提供しています。
プラグインはHPC-Xのバージョンごとに対応するNCCLのバージョンが異なります。HPC-XとNCCLの対応は以下の表を参照してください。

| HPC-Xバージョン | NCCL バージョン |
| :-- | :-- |
| 2.20 | 2.23 |

NVIDIA HPC-Xについて、より詳しい情報は[公式ドキュメント](https://docs.nvidia.com/networking/category/hpcx)を参照してください。

## Intel MPI

| intel-mpi/ | Compute Node (H) |
|:--|:--|
| 2021.13 | Yes |

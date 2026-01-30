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

## InfiniBand NDRの使用個数の変更方法

計算ノード(H)にはInfiniBand NDR HCAが8つ搭載されています。
ABCIが提供する`hpcx`モジュールおよび`intel-mpi`モジュールでは、デフォルトでマルチレールのレーン数に次の値が設定されています。

* Rendezvousプロトコル(大容量メッセージ)の使用レーンは4
* Eagerプロトコル(小容量メッセージ)の使用レーンは1

使用レーン数はそれぞれ`UCX_MAX_RNDV_RAILS`/`UCX_MAX_EAGER_RAILS`環境変数で変更することができます。

!!!info
    `UCX_MAX_RNDV_RAILS`、`UCX_MAX_EAGER_RAILS`環境変数に設定できる値は1-8です。

以下はインタラクティブジョブによる変更方法例です。
この例では、使用レーン数をデフォルト値の倍に設定しています。

```
[username@login1 ~]$ qsub -I -P group -q rt_HF -l select=2:mpiprocs=8 -l walltime=1:0:0
[username@hnode001 ~]$ module load hpcx/2.20
[username@hnode001 ~]$ export UCX_MAX_RNDV_RAILS=8
[username@hnode001 ~]$ export UCX_MAX_EAGER_RAILS=2
[username@hnode001 ~]$ mpirun ./a.out
```

また、以下のようなラッパースクリプトを用いることで各プロセスにユニークなNDR HCAを割り当てることができます。

* wrap.sh(hpcx)

```
#!/bin/sh

NNDRS=8

for i in $(seq 1 $NNDRS)
do
    if [ $((OMPI_COMM_WORLD_RANK%NNDRS)) -eq $((i-1)) ];then
        export UCX_NET_DEVICES=mlx5_ibn$i:1
    fi
done

exec "$@"
```

```
mpirun ./wrap.sh ./a.out
```

* wrap.sh(intel-mpi)

```
#!/bin/sh

NNDRS=8

for i in $(seq 1 $NNDRS)
do
    if [ $((PMI_RANK%NNDRS)) -eq $((i-1)) ];then
        export UCX_NET_DEVICES=mlx5_ibn$i:1
    fi
done

exec "$@"
```

```
mpiexec.hydra ./wrap.sh ./a.out
```

!!!warn
    ジョブ投入時に`qsub`コマンドに`mpiprocs`(ppn)を指定してMPIプロセス数を指定して下さい。

!!!info
    上記の`mlx5_ibn$i`がNDR HCAのデバイス名です。

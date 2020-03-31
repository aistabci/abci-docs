# システム更新履歴

## 2020-04-0X

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | Intel Parallel Stduio XE Cluster Edition | 2018.4<br>2019.5 | |
| Remove | Intel Parallel Stduio XE Cluster Edition | 2018.2<br>2018.3<br>2019.3 | |
| Add | PGI Professional Edition | 19.1<br>19.10<br>20.1 |
| Remove | PGI Professional Edition | 18.5<br>19.3 |
| Add | NCCL | [2.6.4-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-6-x.html) | |
| Add | CMake | 3.16<br>3.17 | |
| Add | Julia | 1.0<br>1.3<br>1.4 | |
| Add | Go | 1.12<br>1.13 | |
| Add | hadoop | 2.9<br>2.10<br>3.1 | |
| Remove | hadoop | 2.9.1<br>2.9.2 | |
| Add | spark | 2.3<br>2.4 | |
| Remove | spark | 2.3.1<br>2.3.2<br>2.4.0 | |
| Add | aws-cli | 1.18<br>2.0 | |

## 2019-12-17

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | DDN Lustre | 2.10.7\_ddn14-1 | 2.10.5\_ddn7-1 |
| Update | BeeOND | 7.1.4 | 7.1.3 |
| Update | Scality S3 Connector | 7.4.5.0 | 7.4.4.4 |
| Update | NVIDIA Tesla Driver | [440.33.01](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-440-3301/index.html) | 410.104 |
| Add | CUDA | [10.2.89](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html) | |
| Add | cuDNN | [7.6.5](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_765.html) | |
| Add | NCCL | [2.5.6-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-5-6.html) | |

その他の修正点は下記の通りです:

* [メモリインテンシブノード](01.md#memory-intensive-node-configuration)を追加いたしました。

## 2019-11-06

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | GCC | 7.3.0<br>7.4.0 | |
| Add | sregistry-cli | 0.2.31 | |

その他の修正点は下記の通りです:

* cuda/* モジュールを修正し、`extras/CUPTI` へのパスを設定するようにしました。
* python/3.4, python/3.5, python/3.6 を修正し、ホーム領域上で `shutil.copytree` を実行するとエラーが発生する問題を解決しました。

## 2019-10-04

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Univa Grid Engine | 8.6.6 | 8.6.3 |
| Update | DDN GRIDScaler | 4.2.3.17 | 4.2.3.15 |
| Update | BeeOND | 7.1.3 | 7.1.2 |
| Add | CUDA | [10.1.243](https://docs.nvidia.com/cuda/archive/10.1/) | |
| Add | cuDNN | [7.6.3](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_750.html)<br>[7.6.4](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_764.html) | |
| Add | NCCL | [2.4.8-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-8.html) | |
| Add | MVAPICH2-GDR | 2.3.2 | |
| Add | MVAPICH2 | 2.3.2 | |
| Add | fuse-sshfs | 2.10 | |

その他の修正点は下記の通りです:

* cuDNN 7.5.0, 7.5.1, 7.6.0, 7.6.1, 7.6.2 を CUDA 10.1 に対応
* NCCL 2.4.2-1, 2.4.7-1 を CUDA 10.1 に対応
* GDRCopy 1.2 を CUDA 10.0, 10.1 に対応
* Open MPI 2.1.6 を CUDA 10.1 に対応
* インタラクティブノードの /tmp の容量を 26GB から 12TB に増量
* インタラクティブノードにてプロセス監視およびプロセス削除の仕組みを追加

### インタラクティブノードのプロセス監視を開始

インタラクティブノードのプロセス監視を開始しました。
インタラクティブノードでの高負荷な処理や長時間の処理はプロセス監視システムに
よって停止されるため、`qrsh/qsub`コマンドを用いて計算ノードをご使用ください。

### ジョブ投入数および実行数制限の変更

ジョブ投入数および実行数制限を以下のように変更しました。

| 制限項目                                 | 現在の制限値 | 変更前の制限値 |
| :--                                      | :--          | :--            |
| アレイジョブあたりの最大投入可能タスク数 | 75000        | 1000           |
| ABCI アカウントあたりの同時実行ジョブ数  | 200          | 0(無制限)      |

### 既知の問題に関して

以下の既知の問題への対応が完了しました。

* 資源タイプ rt_C.small/rt_G.small を指定したジョブが1計算ノードあたり
  2ジョブまでしか実行されない(通常4ジョブが実行される)。

## 2019-08-01

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [7.6.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_762.html) | |
| Add | NCCL | [2.4.7-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-7.html) | |
| Add | s3fs-fuse | 1.85 | |

その他の修正点は下記の通りです:

* Open MPI 1.10.7, 2.1.5, 2.1.6 を CUDA 10.0 に対応

## 2019-07-10

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | CUDA | 10.0.130.1 | |
| Add | cuDNN | [7.5.1](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_751.html)<br>[7.6.0](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_760.html)<br>[7.6.1](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_761.html) | |
| Add | aws-cli | 1.16.194 | |

## 2019-04-05

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | CentOS | 7.5 | 7.4 |
| Update | Univa Grid Engine | 8.6.3 | 8.5.4 |
| Update | Java | 1.7.0\_171 | 1.7.0\_141|
| Update | Java | 1.8.0\_161 | 1.8.0\_131|
| Add | DDN Lustre | 2.10.5\_ddn7-1 | |
| Update | NVIDIA Tesla Driver | [410.104](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-410-104/index.html) | 396.44 |
| Add | CUDA | [10.0.130](https://docs.nvidia.com/cuda/archive/10.0/) | |
| Add | Intel Compiler | 2019.3 | |
| Add | PGI | 18.10<br>19.3 | |

その他の修正点は下記の通りです:

* ホーム領域を GPFS から Lustre に移行

## 2019-03-14

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | Intel Compiler | 2017.8<br>2018.3 | |
| Add | PGI | 17.10 | |
| Add | Open MPI | 2.1.6 | |
| Add | cuDNN | [7.5.0](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_750.html) | |
| Add | NCCL | [2.4.2-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-4-2.html) | |
| Add | Intel MKL | 2017.8<br>2018.3 | |

その他の修正点は下記の通りです:

* MVAPICH2-GDR 2.3 を PGI 17.10 に対応
* Open MPI 2.1.5, 2.1.6, 3.1.3 を PGI に対応
* Open MPI の default module を 2.1.6 に変更
* MVAPICH2 のトップディレクトリのtypoを修正

## 2019-01-31

### qstatコマンドの出力の変更

ジョブスケジューラの設定変更を実施し、qstat コマンドの出力において、ユーザ/グループ/ジョブ名がマスク表示されるようにしました。

自身のジョブの場合のみ上記の情報は表示され、そうでない場合はこれらの情報は'*'でマスクされます。以下に表示例を示します。

```
[username@es1 ~]$ qstat -u '*' | head
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
    123456 0.28027 run.sh     username     r     01/31/2019 12:34:56 gpu@g0001                                                        80
    123457 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0002                                                        80
    123458 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0003                                                        80
    123450 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0004                                                        80
```

## 2018-12-18

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [7.4.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_742.html) | |
| Add | NCCL | [2.3.7-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-3-7.html) | |
| Add | Open MPI | 3.0.3<br>3.1.3 | |
| Add | MVAPICH2-GDR | 2.3 | |
| Add | Hadoop | 2.9.2 | |
| Add | Spark | 2.3.2<br>2.4.0 | |
| Add | Go | 1.11.2 | |
| Add | Intel MKL | 2018.2.199 | |

### cuDNN 7.4.2

NVIDIA CUDA Deep Neural Network library (cuDNN) 7.4.2 をインストールしました。

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load cudnn/7.4/7.4.2
```

### NCCL 2.3.7-1

NVIDIA Collective Communications Library (NCCL) 2.3.7-1 をインストールしました。

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load nccl/2.3/2.3.7-1
```

### Open MPI 3.0.3, 3.1.3

Open MPI (without --cuda option) 3.0.3, 3.1.3 をインストールしました。

利用環境の設定:

```
$ module load openmpi/3.1.3
```

### MVAPICH2-GDR 2.3

MVAPICH2-GDR 2.3 をインストールしました。

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load mvapich/mvapich2-gdr/2.3
```

### Hadoop 2.9.2

Apache Hadoop 2.9.2 をインストールしました。

利用環境の設定:

```
$ module load openjdk/1.8.0.131
$ module load hadoop/2.9.1
```

### Spark 2.3.2, 2.4.0

Apache Spark 2.3.2, 2.4.0 をインストールしました。

利用環境の設定:

```
$ module load spark/2.4.0
```

### Go 1.11.2

Go 言語 1.11.2 をインストールしました。

利用環境の設定:

```
$ module load go/1.11.2
```

### Intel MKL 2018.2.199

Intel Math Kernel Library (MKL) 2018.2.199 をインストールしました。

利用環境の設定:

```
$ module load intel-mkl/2018.2.199
```

## 2018-12-14

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Singularity | 2.6.1 | 2.6.0 |
| Delete | Singularity | 2.5.2 | |

Singularity 2.6.1 をインストールしました。使用方法は以下の通りです。

```
$ module load singularity/2.6.1
$ singularity run image_path
```

アップデート情報については、以下のページを参照ください。

[Singularity 2.6.1](https://github.com/sylabs/singularity/releases/tag/2.6.1)

また、ソフトウェアの脆弱性 ([CVE-2018-19295](https://cve.mitre.org/cgi-bin/cvename.cgi?name=2018-19295)) が報告されたため、Singularity 2.5.2, 2.6.0 はアンインストールしました。ジョブスクリプト内で、バージョンを指定して Singularity 環境を設定している場合（`singularity/2.5.2`, `singularity/2.6.0`など）、バージョン指定を `singularity/2.6.1` に修正ください。

```
ex) module load singularity/2.5.2 -> module load singularity/2.6.1
```

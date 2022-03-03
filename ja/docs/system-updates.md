# システム更新履歴

## 2022-04-11 更新予定

* Reservedサービスにおいて計算ノード(V)の1予約あたりの最大予約ノード時間積を12,288から13,056に変更予定です。
* Reservedサービスにおいて計算ノード(A)の1予約あたりの最大予約ノード数を16から18に変更予定です。
* Reservedサービスにおいて計算ノード(A)の1予約あたりの最大予約ノード時間積を6,144から6,912に変更予定です。

## 2022-03-03 

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Delete | hadoop | 3.3 | |
| Delete | spark | 3.0 | |
| Update | DDN Lustre (計算ノード(A)) | 2.12.6_ddn58-1 | 2.12.5_ddn13-1 |
| Update | OFED (計算ノード(A)) | 5.2-1.0.4.0 | 5.1-0.6.6.0 |

## 2022-01-27

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | CUDA  | 11.3.1<br>11.4.1<br>11.4.2<br>11.5.1<br>11.6.0 | |
| Add | cuDNN | 8.2.2<br>8.2.4<br>8.3.2 | |
| Add | NCCL  | 2.10.3-1<br>2.11.4-1 | |

## 2021-12-15

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | OFED | 5.1-0.6.6.0 | 5.0-2.1.8.0 |
| Update | Scality S3 Connector | 7.4.9.3 | 7.4.8.4 |
| Update | NVIDIA Tesla Driver | [470.57.02](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-470-57-02/index.html) | 460.32.03 |
| Add | ffmpeg | 3.4.9<br>4.2.5 |  |

* Reservedサービスにおいて計算ノード(V)の1予約あたりの最大予約ノード数が32から34に変更されました。
* グローバルスクラッチ領域の追加に伴い、ドキュメントの「ストレージ」へ[グローバルスクラッチ領域](storage.md#scratch-area)を追加しました。

## 2021-08-12

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | BeeOND | 7.2.3 | 7.2.1 |
| Update | DDN Lustre | 2.12.5\_ddn13-1 | 2.12.6\_ddn13-1 |

## 2021-07-06

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.7-4 | 3.7-1 |

## 2021-06-30

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [8.2.1](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-821) | |
| Add | NCCL | [2.9.9-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-9-9.html) | |

## 2021-05-10

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuDNN | [8.2.0](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-820) | |
| Add | NCCL | [2.9.6-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-9-6.html) | |

* NVIDIA A100 を搭載した計算ノード(A)の追加に伴い、ドキュメントを修正しました。

## 2021-04-07

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | NVIDIA Tesla Driver | [460.32.03](https://docs.nvidia.com/datacenter/tesla/tesla-release-notes-460-32-03/index.html) | 440.33.01 |
| Update | OFED | 5.0-2.1.8.0 | 4.4-1.0.0.0 |
| Update | Univa Grid Engine | 8.6.17 | 8.6.6 |
| Update | SingularityPRO | 3.7-1 | 3.5-6 |
| Update | BeeOND | 7.2.1 | 7.2 |
| Update | Docker | 19.03.15 | 17.12.0 |
| Update | Scality S3 Connector | 7.4.8.1 | 7.4.8 |
| Add | gcc | 9.3.0 | |
| Add | pgi | 20.4 | |
| Add | nvhpc | 20.11<br>21.2 | |
| Add | cmake | 3.19 | |
| Add | go | 1.15 | |
| Add | julia | 1.5 | |
| Add | lua | 5.3.6<br>5.4.2 | |
| Add | python | 2.7.18<br>3.6.12<br>3.7.10<br>3.8.7 | |
| Add | R | 4.0.4 | |
| Add | CUDA | 11.0.3<br>11.1.1<br>11.2.2 | |
| Add | cuDNN | [8.1.1](https://docs.nvidia.com/deeplearning/cudnn/release-notes/rel_8.html#rel-811) | |
| Add | NCCL | [2.8.4-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-8-4.html) | |
| Add | openmpi | 4.0.5 | |
| Add | mvapich2-gdr | 2.3.5 | |
| Add | mvapich2 | 2.3.5 | |
| Add | hadoop | 3.3 | |
| Add | spark | 3.0 | |
| Add | aws-cli | 2.1 | |
| Add | fuse-sshfs | 3.7.1 | |
| Add | s3fs-fuse | 1.87 | |
| Add | sregistry-cli | 0.2.36 | |
| Delete | intel | 2017.8.262<br>2018.5.274<br>2019.5.281 | |
| Delete | pgi | 17.10<br>18.10<br>19.1<br>19.10<br>20.1 | |
| Delete | nvhpc | 20.9 | |
| Delete | cmake | 3.16<br>3.17 | |
| Delete | go | 1.12<br>1.13 | |
| Delete | intel-advisor | 2017.5<br>2018.4<br>2019.5 | |
| Delete | intel-inspector | 2017.4<br>2018.4<br>2019.5 | |
| Delete | intel-itac | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Delete | intel-mkl | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Delete | intel-vtune | 2017.6<br>2018.4<br>2019.6 | |
| Delete | julia | 1.3<br>1.4 | |
| Delete | python | 2.7.15<br>3.4.8<br>3.5.5<br>3.7.6 | |
| Delete | R | 3.5.0<br>3.6.3 | |
| Delete | cuda | 10.0.130 | |
| Delete | cudnn | 7.1.3<br>7.5.0<br>7.6.0<br>7.6.1<br>7.6.2<br>7.6.3<br>7.6.4<br>8.0.2 | |
| Delete | nccl | 2.3.4-1<br>2.3.5-2<br>2.4.2-1<br>2.4.7-1<br>2.8.3-1 | |
| Delete | intel-mpi | 2017.4<br>2018.4<br>2019.5 | |
| Delete | openmpi | 4.0.3 | |
| Delete | mvapich2-gdr | 2.3.3<br>2.3.4 | |
| Delete | mvapich2 | 2.3.3<br>2.3.4 | |
| Delete | hadoop | 2.9<br>2.10<br>3.1 | |
| Delete | singularity | 2.6.1 | |
| Delete | spark | 2.3<br>2.4 | |
| Delete | aws-cli | 1.16.194<br>1.18<br>2.0 | |
| Delete | fuse-sshfs | 2.10 | |
| Delete | s3fs-fuse | 1.85 | |
| Delete | sregistry-cli | 0.2.31 | |

## 2021-03-13

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.5-6 | 3.5-4 |
| Update | DDN Lustre | 2.12.6\_ddn13-1 | 2.10.7\_ddn14-1 |

## 2020-12-15

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | go | 1.14 | |
| Add | intel | 2020.4.304 | |
| Add | intel-advisor | 2020.3 | |
| Add | intel-inspector | 2020.3 | |
| Add | intel-itac | 2020.0.3 | |
| Add | intel-mkl | 2020.0.4 | |
| Add | intel-mpi | 2019.9 | |
| Add | intel-vtune | 2020.3 | |
| Add | nvhpc | 20.9 | |
| Add | cuDNN | [8.0.5](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_8.html#rel-805) | |
| Add | NCCL | [2.8.3-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-8-3.html) | |
| Update | BeeOND | 7.2 | 7.1.5 |
| Update | Scality S3 Connector | 7.4.8 | 7.4.6.3 |

### 機能追加: 計算ノードへのSSHアクセス

使用する計算ノードへのSSHログインを可能にする機能を追加しました。詳細は[計算ノードへのSSHアクセス](appendix/ssh-access.md)を参照してください。

## 2020-10-09

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | SingularityPRO | 3.5-4 | 3.5-2 |

## 2020-08-31

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Scality S3 Connector | 7.4.6.3 | 7.4.5.4 |

## 2020-07-31

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | SingularityPRO | 3.5-2 | |
| Add | cuDNN | [8.0.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_8.html#rel-802) | |
| Add | NCCL | [2.7.8-1](https://docs.nvidia.com/deeplearning/nccl/release-notes/rel_2-7-8.html) | |
| Add | mvapich2-gdr | 2.3.4 | |
| Add | mvapich2 | 2.3.4 | |

## 2020-06-01

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | BeeOND | 7.1.5 | 7.1.4 |

## 2020-04-21

### MVAPICH2-GDR 2.3.3 の更新

gcc 4.8.5 対応の MVAPICH2-GDR 2.3.3 を以下の既知の問題が修正されたバージョンに更新しました。

- MVPICH2-GDR の MPI_Allreduce で floating point exception が発生する場合がある。

また、PGI 対応の MVAPICH2-GDR 2.3.3 は提供を停止しました。
PGI 版が必要の場合、ユーザーサポートまでご連絡ください。

## 2020-04-03

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | DDN GRIDScaler | 4.2.3.20 | 4.2.3.17 |
| Update | Scality S3 Connector | 7.4.5.4 | 7.4.5.0 |
| Update | libfabric | 1.7.0-1 | 1.5.3-1 |
| Add | intel | 2018.5.274<br>2019.5.281 | |
| Add | pgi | 19.1<br>19.10<br>20.1 | |
| Add | R | 3.6.3 | |
| Add | cmake | 3.16<br>3.17 | |
| Add | go | 1.12<br>1.13 | |
| Add | intel-advisor | 2017.5<br>2018.4<br>2019.5 | |
| Add | intel-inspector | 2017.4<br>2018.4<br>2019.5 | |
| Add | intel-itac | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Add | intel-mkl | 2017.0.4<br>2018.0.4<br>2019.0.5 | |
| Add | intel-vtune | 2017.6<br>2018.4<br>2019.6 | |
| Add | julia | 1.0<br>1.3<br>1.4 | |
| Add | openjdk | 1.8.0.242<br>11.0.6.10 | |
| Add | python | 3.7.6<br>3.8.2 | |
| Add | gdrcopy | 2.0 | |
| Add | nccl | [2.6.4-1](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/rel_2-6-4.html) | |
| Add | intel-mpi | 2017.4<br>2018.4<br>2019.5 | |
| Add | mvapich2-gdr | 2.3.3 | |
| Add | mvapich2 | 2.3.3 | |
| Add | openmpi | 3.1.6<br>4.0.3 | |
| Add | hadoop | 2.9<br>2.10<br>3.1 | |
| Add | spark | 2.3<br>2.4 | |
| Add | aws-cli | 1.18<br>2.0 | |
| Delete | gcc | 7.3.0 | |
| Delete | intel | 2018.2.199<br>2018.3.222<br>2019.3.199 | |
| Delete | pgi | 18.5<br>19.3 | |
| Delete | go | 1.11.2 | |
| Delete | intel-mkl | 2017.8.262<br>2018.2.199<br>2018.3.222<br>2019.3.199 | |
| Delete | openjdk | 1.6.0.41<br>1.8.0.161 | |
| Delete | cuda | 9.0/9.0.176.2<br>9.0/9.0.176.3 | |
| Delete | gdrcopy | 1.2 | |
| Delete | intel-mpi | 2018.2.199 | |
| Delete | mvapich2-gdr | 2.3rc1<br>2.3<br>2.3a<br>2.3.1<br>2.3.2 | |
| Delete | mvapich2 | 2.3rc2<br>2.3<br>2.3.2 | |
| Delete | openmpi | 1.10.7<br>2.1.3<br>2.1.5<br>3.0.3<br>3.1.0<br>3.1.2<br>3.1.3 | |
| Delete | hadoop | 2.9.1<br>2.9.2 | |
| Delete | spark | 2.3.1<br>2.3.2<br>2.4.0 |

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

* [メモリインテンシブノード](system-overview.md#memory-intensive-node)を追加しました。

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
| Add | PGI | 18.10 19.3 | |

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

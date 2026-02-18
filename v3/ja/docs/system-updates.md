# システム更新履歴

## 2026-02-18 {#2026-02-18}

Open OnDemandのバージョンを4.0.8にアップデートしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Open OnDemand                           | 3.1.10         | 4.0.8         |

## 2026-02-17 {#2026-02-17}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cudnn | 9.18.1 (CUDA 12, 13対応版) | |

## 2026-02-10 {#2026-02-10}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | singularity-ce | 4.3.6 | |

## 2026-01-20 {#2026-01-20}

資源タイプ`rt_HG`、`rt_HC`における[システムあたりの同時実行ジョブ数の制限値](job-execution.md#limitation-on-the-number-of-job-submissions-and-executions)を以下のとおり変更しました。

| 資源タイプ | 更新前 | 更新後 |
|:--|:--|:--|
| rt_HG | 240 | 64 |
| rt_HC | 60  | 16 |

## 2025-12-26 {#2025-12-26}

クラウドストレージに、CSAD無効化機能が追加されました。これに伴い、設定ファイルを用いたバケットACLの設定方法を追記しました。

## 2025-12-23 {#2025-12-23}

インタラクティブノードの/localが利用可能になりました。

* ABCIシステムの概要 > ストレージシステム > インタラクティブノード」の備考欄に追記。
* [「Tips > インタラクティブノードの/localの利用」](tips/interactive_node_local_fs.md)を新設。

以下のソフトウェアを更新しました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | gcc(計算ノード)                            | 11.5.0         | 11.4.1         |
| Update | python(インタラクティブノード, 計算ノード) | 3.9.25, 3.9.23 | 3.9.21, 3.9.21 |
| Update | ruby(計算ノード)                           | 3.0.7          | 3.0.4          |
| Update | java(インタラクティブノード)               | 17.0.17        | 17.0.16        |
| Update | Go(インタラクティブノード, 計算ノード)     | 1.25.3, 1.25.3 | 1.24.6, 1.24.4 |
| Update | DDN Lustre                                 | 2.14.0_ddn230  | 2.14.0_ddn196  |
| Update | SingularityCE(インタラクティブノード)      | 4.3.5          | 4.1.5          |
| Update | SingularityPRO                             | 4.1.12         | 4.1.7          |

計算ノードにおいて同時にオープン可能なファイル数の上限値を以下のように増加しました。

| リミット種別 | 更新前 | 更新後 |
|:--|:--|:--|
| ソフト・リミット | 16384 | 65536 |
| ハード・リミット | 16384 | 1048576 |

オープン可能なファイル数の上限値は、ジョブを実行後`ulimit -n {limit}`コマンドで変更できます。

インタラクティブジョブの例:

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1
[username@hnode001 ~]$ ulimit -n 131072
```

バッチジョブの例:

```shell
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

ulimit -n 262144

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
./a.out
```

`hpcx`モジュール及び`intel-mpi`モジュールのデフォルトのマルチレール設定を変更いたしました。

|Parameter | Previous value | Current value |
|:--|:--|:--|
| UCX_MAX_RNDV_RAILS | none | 4 |
| UCX_MAX_EAGER_RAILS | none | 1 |
| UCX_NET_DEVICES | none | NDR IB devices (8 ports) only |

## 2025-12-15 {#2025-12-15}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | graphviz(計算ノード) | 2.44.0 | |

## 2025-12-11 {#2025-12-11}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | rclone | 1.71.0 | |

## 2025-12-03 {#2025-12-03}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | singularity-ce | 4.3.3 | |

## 2025-10-29 {#2025-10-29}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | s3fs-fuse | 1.95 | |

## 2025-10-28 {#2025-10-28}

ジョブが混雑しているため、予約可能ノード数を一時的に変更しました。混雑が緩和された後、設定を戻す予定です。

| 項目 | 変更前の値 | 変更後の値 | 備考 |
|:--|:--|:--|:--|
| 最小予約日数 | 1日 | 1日 | 変更なし。 |
| 最大予約日数 | 60日 | 60日 | 変更なし。 |
| ABCIグループあたりの最大同時予約可能ノード数 | 32ノード | 32ノード | 変更なし。 |
| システムあたりの最大同時予約可能ノード数 | 640ノード | 96ノード | 混雑している期間の一時的設定に変更。 |
| 1予約あたりの最小予約ノード数 | 1ノード | 1ノード | 変更なし。 |
| 1予約あたりの最大予約ノード数 | 32ノード | 32ノード | 変更なし。 |
| 1予約あたりの最大予約ノード時間積 | 10,752ノード時間積 | 5,376ノード時間積 | 混雑している期間の一時的な設定変更。32ノードの場合は最大7日。 |

## 2025-10-22 {#2025-10-22}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | openjdk | 25.0.0 | |

## 2025-10-21 {#2025-10-21}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | nccl | 2.27.7-1 (CUDA 13対応版)<br>2.28.3-1 (CUDA 13対応版) | |

## 2025-10-15 {#2025-10-15}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 13.0.1 | |
| Add | cudnn | 9.12.0 (CUDA 13対応版)<br>9.13.0 (CUDA 12, 13対応版) | |

## 2025-09-29 {#2025-09-29}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | go | 1.25.1 | |

## 2025-09-24 {#2025-09-24}

`qgdel`コマンドを提供しました。これにより、利用管理者・責任者は同じグループに所属する利用者の任意のジョブを削除可能となります。

## 2025-09-18 {#2025-09-18}

以下のソフトウェアをインストールしました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cmake | 4.1.1 | |
| Add | nccl | 2.24.3-1<br>2.26.6-1<br>2.27.7-1<br>2.28.3-1 | |
| Add | cudnn | 9.6.0<br>9.7.1<br>9.8.0<br>9.9.0<br>9.10.2<br>9.11.1 | |

## 2025-08-26 {#2025-08-26}

以下のソフトウェアを追加／更新しました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | cuda | 12.9.1 | |
| Add | cudnn | 9.12.0 | |
| Add | firefox(計算ノード) | 128.13.0-1 | |
| Update | python(計算ノード) | 3.9.21 | 3.9.18 |
| Update | ruby(インタラクティブノード) | 3.0.7 | 3.0.4 |
| Update | R(インタラクティブノード, 計算ノード) | 4.5.1, 4.5.1 | 4.4.3, 4.4.1 |
| Update | java(インタラクティブノード, 計算ノード) | 17.0.16, 17.0.16 | 11.0.22.0.7, 11.0.23.0.9 |

一般利用者による NVIDIA GPU Performance Counters の利用を許可しました。

## 2025-08-08 {#2025-08-08}

以下のソフトウェアを追加しました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | gcc | 13.2.0 | |

## 2025-08-05 {#2025-08-05}

ABCIクラウドストレージの説明文章を追記しました。

※ サービス開始は8月下旬を予定しています。サービス開始時点では、ABCI内部（ログインノードや計算ノード）からのみ利用可能で、外部（インターネットなど）からは利用できません。外部からの利用につきましては、準備が整い次第、改めてご案内申し上げます。

## 2025-07-25 {#2025-07-25}

qalter コマンドの利用者による使用を抑止しました。

## 2025-07-11 {#2025-07-11}

軽量版のqgstatである`qgstat_l`コマンドを提供しました。

## 2025-06-20 {#2025-06-20}

Open OnDemand のインタラクティブアプリに、次のアプリケーションを追加しました。

* code-server
* Interactive Desktop(Xfce)

## 2025-04-15 {#2025-04-15}

次の機能の実装をしました。

* ジョブ投入時のSSHアクセス制御オプション
    * `qsub`コマンドのオプション追加により、ジョブ実行中の計算ノードへのSSHログイン制御ができるようになりました。使い方の詳細は[ジョブ実行オプション](job-execution.md#job-execution-options)を参照してください。
* Open OnDemand Job Composer

以下のソフトウェア・アップデートを行いました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Lustre-client | 2.14.0_ddn196 | 2.14.0_ddn172 |
| Update | python (インタラクティブノード) | 3.9.21 | 3.9.18 |
| Add | python | 3.12.9 | |
| Add | python | 3.13.2 | |

データ移行のためにマウントしていたABCI 2.0のホーム領域(`/home-2.0`)を提供終了に伴いアンマウントしました。

## 2025-03-03 {#2025-03-03}

SingularityPROが利用可能となりました。使い方の詳細は[SingularityPROの利用方法](containers.md#how-to-use-singularitypro)を参照してください。

## 2025-01-31 {#2025-01-31}

`qrstat --available=grpname`機能の追加により、ノードの予約の空き状況を参照できるようになりました。使い方の詳細は[予約状態の確認](job-execution.md#show-the-status-of-reservations)を参照してください。

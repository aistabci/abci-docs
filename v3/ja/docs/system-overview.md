# ABCIシステムの概要

## システム全体概要 {#system-architecture}

ABCIシステムは、合計6,128基のNVIDIA H200 GPUアクセラレーターを備えた766台の計算ノード(H)を始めとする計算リソース、物理容量75PBのストレージ、これらを高速に結合するInfiniBandネットワーク、ファイアウォールなどからなるハードウェアと、これらを最大限活用するためのソフトウェアから構成されます。また、ABCIシステムは学術情報ネットワークSINET6を利用して、100 Gbpsでインターネットに接続しています。

## 計算リソース {#computing-resources}

ABCIシステムの計算リソースの一覧を以下に示します。

| 項目 | ホスト名 | 説明 | ノード数 |
|:--|:--|:--|:--|
| アクセスサーバ | *as.v3.abci.ai* | 外部からアクセスするためのSSHサーバ | 2 |
| インタラクティブノード | *login* | ABCIシステムのフロントエンドとなるログインサーバ | 5 |
| 計算ノード(H) | *hnode001*-*hnode108*[^1] | NVIDIA H200 GPUを搭載するサーバ | 108 |

[^1]: 2025年1月頃に766台の計算ノード(H)が利用可能となります。

!!! note
    運用・保守上の合理的理由により、計算リソースの一部が提供されない場合があります。

このうち、インタラクティブノードと計算ノード(H)は、それぞれInfiniBand HDR (200 Gbps)を備えており、後述のストレージシステムにInfiniBandスイッチを介して接続されます。
また、計算ノード(H)は追加でInfiniBand NDR (200 Gbps)を8ポート備えており、計算ノード(H)間がInfiniBandスイッチにより接続されます。

以下ではこれらのノードの詳細を示します。

### インタラクティブノード {#interactive-node}

ABCIシステムのインタラクティブノードは、HPE ProLiant DL380 Gen11で構成されています。
Intel Xeon Platinum 8468プロセッサーを2基搭載し、約1024 GBのメインメモリが利用可能です。

インタラクティブノードの構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8468 Processor 2.1 GHz, 48 Cores | 2 |
| Memory | 64 GB DDR5-4800 | 16 |
| SSD | SAS SSD 960 GB | 2 |
| SSD | NVMe SSD 3.2 TB | 4 |
| Interconnect | InfiniBand HDR (200 Gbps) | 2 |
| | 10GBASE-SR | 1 |

ABCIシステムのフロントエンドであるインタラクティブノードには、アクセスサーバを経由したSSHトンネリングを用いてログインします。インタラクティブノードではコマンドの対話的実行が可能であり、プログラムの作成・編集、ジョブ投入・表示などを行います。インタラクティブノードにはGPUが搭載されていませんが、インタラクティブノードで計算ノード向けのプログラム開発も可能です。

ログイン方法の詳細は[ABCIの利用開始](getting-started.md)、ジョブ投入方法の詳細は[ジョブ実行](job-execution.md)をそれぞれ参照してください。

!!! warning
    インタラクティブノードのCPUやメモリなどの資源は多くの利用者で共有するため、高負荷な処理は行わないようにしてください。高負荷な前処理、後処理を行う場合は、計算ノードを利用してください。
    インタラクティブノードで高負荷な処理を行った場合、システムにより処理が強制終了されますのでご注意ください。

### 計算ノード {#compute-node}

計算ノード向けのプログラムを実行するには、バッチジョブもしくはインタラクティブジョブとしてジョブ管理システムに処理を依頼します。インタラクティブジョブでは、プログラムのコンパイルやデバッグ、対話的なアプリケーション、可視化ソフトウェアの実行が可能です。詳細は[ジョブ実行](job-execution.md)を参照してください。

#### 計算ノード(H) {#compute-node-h}

計算ノード(H)は、HPE Cray XD670で構成されています。
計算ノード(H)は、Intel Xeon Platinum 8558プロセッサーを2基、NVIDIA H200 GPUアクセラレーターを8基搭載しています。システム全体では、総CPUコア数は73,536コア、総GPU数は6,128基となります。

計算ノード(H)の構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8558 2.1GHz, 48cores | 2 |
| GPU | NVIDIA H200 SXM 141GB | 8 |
| Memory | 64 GB DDR5-5600 4400 MHz | 32 |
| SSD | NVMe SSD 7.68 TB | 2 |
| Interconnect | InfiniBand NDR (200 Gbps) | 8 |
| | InfiniBand HDR (200 Gbps) | 1 |
| | 10GBASE-SR | 1 |


## ストレージシステム {#storage-systems}

ABCIシステムは、人工知能やビッグデータ応用に用いる大容量データを格納するためのストレージシステムを3基備えており、これらを用いて共有ファイルシステムを提供しています。下記の/home、 /groups、 /groups_s3の合算で約74 PBの実効容量があります。

| 構成 | ストレージシステム | メディア | 用途 |
|:--|:--|:--|:--|
| 1 | DDN ES400NVX2 | 61.44TB NVMe SSD x256 | ホーム領域(/home) |
| 2 | DDN ES400NVX2 | 61.44TB NVMe SSD x1280 | グループ領域(/groups) |
| 3 | DDN ES400NVX2 | 30.72TB NVMe SSD x48 | ABCIオブジェクト領域(/groups_s3) |

上記のストレージシステムを用いて、ABCIシステムが提供している共有ファイルシステムの一覧を以下に示します。

| 用途 | マウントポイント | 実行容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| ホーム領域 | /home | 10 PB | Lustre |  |
| グループ領域 | /groups | 63 PB | Lustre |  |
| ABCIオブジェクト領域 | /groups_s3 | 1 PB | Lustre |  |

データ移行目的のために、下記のファイルシステムがマウントされています。

| 用途 | マウントポイント | 実行容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| アーカイブ | /home-2.0 | 0.5 PB | Lustre | 読み取り専用。ABCI 2.0で利用されていたホーム領域 |
| アーカイブ | /groups-2.0 | 10.8 PB | Lustre | 読み取り専用。ABCI 2.0で利用されていたグループ領域 |


インタラクティブノード、計算ノードは、共有ファイルシステムをマウントしており、利用者は共通のマウントポイントからこれらのファイルシステムにアクセスすることができます。

これ以外に、これらのノードはそれぞれローカルスクラッチ領域として利用可能なローカルストレージを搭載しています。以下に一覧を示します。

| ノード種類 | マウントポイント | 容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| インタラクティブノード | /local | 12 TB | XFS | |
| 計算ノード(H) | /local1 | 7 TB | XFS |  |
|               | /local2 | 7 TB | XFS | BeeGFS含む |

## ソフトウェア {#software}

ABCIシステムで利用可能なソフトウェア一覧を以下に示します。詳細なバージョン情報については2025年1月までに公表予定です。

| Category | Software | Interactive Node | Compute Node |
|:--|:--|:--|:--|
| OS | Rocky Linux | - | 9.4 |
| OS | Red Hat Enterprise Linux | 9.4 | - |
| Job Scheduler | Altair PBS Professional |  |  |
| Development Environment | CUDA Toolkit |  |  |
| | Intel oneAPI<br>(compilers and libraries) |  |  |
| | Python |  |  |
| | Ruby |  |  |
| | R |  |  |
| | Java |  |  |
| | Scala |  |  |
| | Perl |  |  |
| | Go |  |  |
| File System | DDN Lustre |  |  |
| | BeeOND |  |  |
| Object Storage | DDN S3 API |  |  |
| Container | SingularityCE |  |  |
| MPI | Intel MPI |  |  |
| Library | cuDNN |  |  |
| | NCCL |  |  |
| | gdrcopy |  |  |
| | UCX |  |  |
| | Intel MKL |  |  |
| Utility | aws-cli |  |  |
| | s3fs-fuse |  |  |
| | rclone |  |  |

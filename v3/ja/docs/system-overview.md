# ABCIシステムの概要

## システム全体概要 {#system-architecture}

ABCIシステムは、合計6,128基のNVIDIA H200 GPUアクセラレーターを備えた766台の計算ノードを始めとする計算リソース、合算で約74PBの容量を有する共有ファイルシステム及びABCIクラウドストレージ、これらを高速に結合するInfiniBandネットワーク、ファイアウォールなどからなるハードウェアと、これらを最大限活用するためのソフトウェアから構成されます。また、ABCIシステムは学術情報ネットワークSINET5を利用して、100 Gbpsでインターネットに接続しています。

<!--[![ABCI System Overview](img/abci_system_ja.svg)](img/abci_system_ja.svg)-->
<!--
ABCIシステムの主要な諸元は以下のとおりです。

| 項目 | 計算ノード(V) 合算性能・容量 | 計算ノード(A) 合算性能・容量 | 合算性能・容量 |
|:--|:--|:--|:--|
| 理論ピーク演算性能 (FP64) | 37.2 PFLOPS | 19.3 PFLOPS | 56.6 PFLOPS |
| HPLによる実効性能 | 19.88 PFLOPS[^1] | 11.48 PFLOPS | 22.20 PFLOPS[^2] |
| HPLによる電力あたりの実効性能 | 14.423 GFLOPS/Watt | 21.89 GFLOPS/W | - |
| 理論ピーク演算性能 (FP32) | 75.0 PFLOPS | 151.0 PFLOPS | 226.0 PFLOPS |
| 理論ピーク演算性能 (FP16) | 550.6 PFLOPS | 300.8 PFLOPS | 851.5 PFLOPS |
| 理論ピーク演算性能 (INT8) | 261.1 POPS | 599.0 POPS | 860.1 POPS |
| メモリ合算容量 | 476 TiB | 97.5 TiB | 573.5 TiB |
| メモリ合算ピークバンド幅 | 4.19 PB/s | 1.54 PB/s | 5.73 PB/s |
| ローカルストレージの合算容量 | 1,740 TB | 480 TB | 2,220 TB |

[^1]: [https://www.top500.org/system/179393/](https://www.top500.org/system/179393/)
[^2]: [https://www.top500.org/system/179954/](https://www.top500.org/system/179954/)
-->
## 計算リソース {#computing-resources}

ABCIシステムの計算リソースの一覧を以下に示します。

| 項目 | ホスト名 | 説明 | ノード数 |
|:--|:--|:--|:--|
| アクセスサーバ | *as.v3.abci.ai* | 外部からアクセスするためのSSHサーバ | 2 |
| インタラクティブノード | *int* | ABCIシステムのフロントエンドとなるログインサーバ | 5 |
| 計算ノード | *hnode001*-*hnode108*[^1] | NVIDIA H200 GPUを搭載するサーバ | 108 |

[^1]: 2025年1月頃に766台の計算ノードが利用可能となります。

!!! note
    運用・保守上の合理的理由により、計算リソースの一部が提供されない場合があります。

このうち、インタラクティブノードと計算ノードは、それぞれInfiniBand HDRを備えており、後述のストレージシステムにInfiniBandスイッチを介して接続されます。
また、計算ノードは追加でInfiniBand NDRを8ポート備えており、計算ノード間がInfiniBandスイッチにより接続されます。
<!--このうち、インタラクティブノード、計算ノード(V)はInfiniBand EDRを2ポート、計算ノード(A)はInfiniBand HDRを4ポート備えており、後述の[ストレージシステム](#storage-systems)とともに、InfiniBandスイッチにより接続されます。-->

以下ではこれらのノードの詳細を示します。

### インタラクティブノード {#interactive-node}

<!--ABCIシステムでは、計算ノード(V), 計算ノード(A)という2種類の計算ノードを提供しています。各計算ノード向けプログラム開発の利便性を向上させるため、インタラクティブノード(V)、インタラクティブノード(A) という2種類のインタラクティブノードを提供しています。

各計算ノード向けアプリケーションのプログラム開発の際は、対応するインタラクティブノードを利用してください。なお、どちらのインタラクティブノードからも両方の計算ノードにジョブを投入することが可能です。
-->
ABCIシステムのインタラクティブノードは、HPE ProLiant DL380 Gen11で構成されています。
Intel Xeon Platinum 8468プロセッサーを2基搭載し、約1100 GBのメインメモリが利用可能です。

インタラクティブノードの構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8468 Processor 2.1 GHz, 48 Cores | 2 |
| Memory | 68 GB DDR5-4800 | 16 |
| SSD | SAS SSD 960 GB | 2 |
| SSD | NVMe SSD 3.2 TB | 4 |
| Interconnect | InfiniBand HDR (200 Gbps) | 2 |
| | 10GBASE-SR | 1 |
| | 1GBASE-SR | 1 |

ABCIシステムのフロントエンドであるインタラクティブノードには、アクセスサーバを経由したSSHトンネリングを用いてログインします。インタラクティブノードではコマンドの対話的実行が可能であり、プログラムの作成・編集、ジョブ投入・表示などを行います。インタラクティブノードにはGPUが搭載されていませんが、インタラクティブノードで計算ノード向けのプログラム開発も可能です。

ログイン方法の詳細は[ABCIの利用開始](getting-started.md)、ジョブ投入方法の詳細は[ジョブ実行](job-execution.md)をそれぞれ参照してください。

!!! warning
    インタラクティブノードのCPUやメモリなどの資源は多くの利用者で共有するため、高負荷な処理は行わないようにしてください。高負荷な前処理、後処理を行う場合は、計算ノードを利用してください。
    インタラクティブノードで高負荷な処理を行った場合、システムにより処理が強制終了されますのでご注意ください。

### 計算ノード {#compute-node}

計算ノード向けのプログラムを実行するには、バッチジョブもしくはインタラクティブジョブとしてジョブ管理システムに処理を依頼します。インタラクティブジョブでは、プログラムのコンパイルやデバッグ、対話的なアプリケーション、可視化ソフトウェアの実行が可能です。詳細は[ジョブ実行](job-execution.md)を参照してください。

#### 計算ノード {#compute-node}

計算ノードは、HPE Cray XD670で構成されています。
計算ノードは、Intel Xeon Platinum 8558プロセッサーを2基、NVIDIA H200 GPUアクセラレーターを8基搭載しています。システム全体では、総CPUコア数は36,768コア、総GPU数は6,128基となります。

計算ノードの構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | Intel Xeon Platinum 8558 2.1GHz, 48cores | 2 |
| GPU | NVIDIA H200 SXM 141GB | 8 |
| Memory | 68 GB DDR5-5600 4400 MHz | 32 |
| SSD | NVMe SSD 7.68 TB | 2 |
| Interconnect | InfiniBand NDR (200 Gbps) | 8 |
| | InfiniBand HDR (200 Gbps) | 1 |
| | 10GBASE-SR | 1 |

<!--参考: [計算ノード(V)のブロック図](img/compute-node-v-diagram.png)-->

## ストレージシステム {#storage-systems}

ABCIシステムは、人工知能やビッグデータ応用に用いる大容量データを格納するためのストレージシステムを3基備えており、これらを用いて共有ファイルシステム及びABCIクラウドストレージを提供しています。合算で最大約74 PBの実効容量があります。

| 構成 | ストレージシステム | メディア | 用途 |
|:--|:--|:--|:--|
| 1 | DDN ES400NVX2 | 61.44TB NVMe SSD x256 | ホーム領域(/home) |
| 2 | DDN ES400NVX2 | 61.44TB NVMe SSD x1280 | グループ領域(/groups) |
| 3 | DDN ES400NVX2 | 30.72TB NVMe SSD x48 | ABCIクラウドストレージ(/groups_s3) |

上記のストレージシステムを用いて、ABCIシステムが提供している共有ファイルシステム及びABCIクラウドストレージの一覧を以下に示します。

| 用途 | マウントポイント | 容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| ホーム領域 | /home | 10 PB | Lustre |  |
| グループ領域 | /groups | 63 PB | Lustre |  |
| ABCIクラウドストレージ | /groups_s3 | 1 PB | Lustre |  |


インタラクティブノード、計算ノードは、共有ファイルシステムをマウントしており、利用者は共通のマウントポイントからこれらのファイルシステムにアクセスすることができます。

これ以外に、これらのノードはそれぞれローカルスクラッチ領域として利用可能なローカルストレージを搭載しています。以下に一覧を示します。

| ノード種類 | マウントポイント | 容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| インタラクティブノード | /local | 12 TB | XFS | |
| 計算ノード | /local1 | 7 TB | XFS |  |
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
| Container | Singularity-CE |  |  |
| MPI | Intel MPI |  |  |
| Library | cuDNN |  |  |
| | NCCL |  |  |
| | gdrcopy |  |  |
| | UCX |  |  |
| | Intel MKL |  |  |
| Utility | aws-cli |  |  |
| | s3fs-fuse |  |  |
| | rclone |  |  |

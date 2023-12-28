# ABCIシステムの概要

## システム全体概要 {#system-architecture}

ABCIシステムは、合計4,352基のNVIDIA V100 GPUアクセラレーターを備えた1,088台の計算ノード(V)と合計960基のNVIDIA A100 GPUアクセラレーターを備えた120台の計算ノード(A)を始めとする計算リソース、合算で約47 PBの容量を有する共有ファイルシステム及びABCIクラウドストレージ、これらを高速に結合するInfiniBandネットワーク、ファイアウォールなどからなるハードウェアと、これらを最大限活用するためのソフトウェアから構成されます。また、ABCIシステムは学術情報ネットワークSINET5を利用して、100 Gbpsでインターネットに接続しています。

[![ABCI System Overview](img/abci_system_ja.svg)](img/abci_system_ja.svg)

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

## 計算リソース {#computing-resources}

ABCIシステムの計算リソースの一覧を以下に示します。

| 項目 | ホスト名 | 説明 | ノード数 |
|:--|:--|:--|:--|
| アクセスサーバ | *as.abci.ai* | 外部からアクセスするためのSSHサーバ | 2 |
| インタラクティブノード(V) | *es* | ABCIシステムのフロントエンドとなる計算ノード(V)向けログインサーバ | 2 |
| インタラクティブノード(A) | *es-a* | ABCIシステムのフロントエンドとなる計算ノード(A)向けログインサーバ | 2 |
| 計算ノード(V) | *g0001*-*g1088* | NVIDIA V100 GPUを搭載するサーバ | 1,088 |
| 計算ノード(A) | *a0001*-*a0120* | NVIDIA A100 GPUを搭載するサーバ | 120 |

!!! note
    以降の説明で、「インタラクティブノード」は、インタラクティブノード(V)とインタラクティブノード(A)の両方を指します。
    同様に、「計算ノード」は、計算ノード(V)と計算ノード(A)の両方を指します。

!!! note
    運用・保守上の合理的理由により、計算リソースの一部が提供されない場合があります。

!!! note
    メモリインテンシブノードのサービスは、2023年10月27日15:00 をもって終了しました。

このうち、インタラクティブノード、計算ノード(V)はInfiniBand EDRを2ポート、計算ノード(A)はInfiniBand HDRを4ポート備えており、後述の[ストレージシステム](#storage-systems)とともに、InfiniBandスイッチにより接続されます。

以下ではこれらのノードの詳細を以下に示します。

### インタラクティブノード {#interactive-node}

ABCIシステムでは、計算ノード(V), 計算ノード(A)という2種類の計算ノードを提供しています。各計算ノード向けプログラム開発の利便性を向上させるため、インタラクティブノード(V)、インタラクティブノード(A) という2種類のインタラクティブノードを提供しています。

各計算ノード向けアプリケーションのプログラム開発の際は、対応するインタラクティブノードを利用してください。なお、どちらのインタラクティブノードからも両方の計算ノードにジョブを投入することが可能です。

ABCIシステムのインタラクティブノードは、FUJITSU Server PRIMERGY RX2540 M4で構成されています。
Intel Xeon Gold 6148プロセッサーを2基搭載し、384 GiBのメインメモリが利用可能です。

インタラクティブノードの構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | [Intel Xeon Gold 6148 Processor 2.4 GHz, 20 Cores (40 Threads)](https://ark.intel.com/products/120489/Intel-Xeon-Gold-6148-Processor-27-5M-Cache-2-40-GHz-) | 2 |
| Memory | 32 GiB DDR4 2666 MHz RDIMM (ECC) | 12 |
| SSD | SAS-SSD 3.2 TB | 4 |
| Interconnect | InfiniBand EDR (100 Gbps) | 2 |
| | 10GBASE-SR | 2 |

ABCIシステムのフロントエンドであるインタラクティブノードには、アクセスサーバを経由したSSHトンネリングを用いてログインします。インタラクティブノードではコマンドの対話的実行が可能であり、プログラムの作成・編集、ジョブ投入・表示などを行います。インタラクティブノードにはGPUが搭載されていませんが、インタラクティブノードで計算ノード向けのプログラム開発も可能です。

ログイン方法の詳細は[ABCIの利用開始](getting-started.md)、ジョブ投入方法の詳細は[ジョブ実行](job-execution.md)をそれぞれ参照してください。

!!! warning
    インタラクティブノードのCPUやメモリなどの資源は多くの利用者で共有するため、高負荷な処理は行わないようにしてください。高負荷な前処理、後処理を行う場合は、計算ノードを利用してください。
    インタラクティブノードで高負荷な処理を行った場合、システムにより処理が強制終了されますのでご注意ください。

### 計算ノード {#compute-node}

ABCIシステムの計算ノードは、計算ノード(V)と計算ノード(A)から構成されています。
計算ノード向けのプログラムを実行するには、バッチジョブもしくはインタラクティブジョブとしてジョブ管理システムに処理を依頼します。インタラクティブジョブでは、プログラムのコンパイルやデバッグ、対話的なアプリケーション、可視化ソフトウェアの実行が可能です。詳細は[ジョブ実行](job-execution.md)を参照してください。

#### 計算ノード(V) {#compute-node-v}

計算ノード(V)は、FUJITSU Server PRIMERGY CX2570 M4で構成されています。
計算ノード(V)は、Intel Xeon Gold 6148プロセッサーを2基、NVIDIA V100 GPUアクセラレーターを4基搭載しています。システム全体では、総CPUコア数は43,520コア、総GPU数は4,352基となります。

計算ノード(V)の構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | [Intel Xeon Gold 6148 Processor 2.4 GHz, 20 Cores (40 Threads)](https://ark.intel.com/products/120489/Intel-Xeon-Gold-6148-Processor-27-5M-Cache-2-40-GHz-) | 2 |
| GPU | [NVIDIA V100 for NVLink 16GiB HBM2](https://www.nvidia.com/en-us/data-center/v100/) | 4 |
| Memory | 32 GiB DDR4 2666 MHz RDIMM (ECC) | 12 |
| NVMe SSD | [Intel SSD DC P4600 1.6 TB u.2](https://ark.intel.com/products/97005/Intel-SSD-DC-P4600-Series-1-6TB-2-5in-PCIe-3-1-x4-3D1-TLC-) | 1 |
| Interconnect | InfiniBand EDR (100 Gbps) | 2 |

参考: [計算ノード(V)のブロック図](img/compute-node-v-diagram.png)

#### 計算ノード(A) {#compute-node-a}

計算ノード(A)は、FUJITSU Server PRIMERGY GX2570後継機で構成されています。
計算ノード(A)は、Intel Xeon Platinum 8360Yプロセッサーを2基、NVIDIA A100 GPUアクセラレーターを8基搭載しています。システム全体では、総CPUコア数は8,640コア、総GPU数は960基となります。

計算ノード(A)の構成を以下に示します。

| 項目 | 説明 | 個数 |
|:--|:--|:--|
| CPU | [Intel Xeon Platinum 8360Y Processor 2.4 GHz, 36 Cores (72 Threads)](https://ark.intel.com/content/www/us/en/ark/products/212459/intel-xeon-platinum-8360y-processor-54m-cache-2-40-ghz.html) | 2 |
| GPU | [NVIDIA A100 for NVLink 40GiB HBM2](https://www.nvidia.com/en-us/data-center/a100/) | 8 |
| Memory | 32 GiB DDR4 3200 MHz RDIMM (ECC) | 16 |
| NVMe SSD | [Intel SSD DC P4510 2.0 TB u.2](https://ark.intel.com/content/www/us/en/ark/products/122580/intel-ssd-dc-p4510-series-2-0tb-2-5in-pcie-3-1-x4-3d2-tlc.html) | 2 |
| Interconnect | InfiniBand HDR (200 Gbps) | 4 |

参考: [計算ノード(A)のブロック図](img/compute-node-a-diagram.png)

## ストレージシステム {#storage-systems}

ABCIシステムは、人工知能やビッグデータ応用に用いる大容量データを格納するためのストレージシステムを5基備えており、これらを用いて共有ファイルシステム及びABCIクラウドストレージを提供しています。合算で最大47 PBの実効容量があります。

| 構成 | ストレージシステム | メディア | 用途 |
|:--|:--|:--|:--|
| 1 | DDN SFA 14KX x1<br>DDN SS9012エンクロージャ x5 | 7.68 TB SAS SSD x185 | ホーム領域(/home)、アプリケーション領域 |
| 2 | DDN ES7990X x3<br>DDN SS9012エンクロージャ x6 | 18 TB NL-SAS HDD x801 | グループ領域(/groups) |
| 3 | DDN ES400NVX x3 | 7.68 TB NVMe HDD x69 | 高速データ領域(/bb) |
| 4 | DDN SFA 14KX x3<br>DDN SS8462エンクロージャ x30 | 3.84 TB SAS SSD x216<br>12 TB NL-SAS HDD x2400 | 特定グループ領域(/projects)、グローバルスクラッチ領域(/scratch) |
| 5 | HPE Apollo 4510 Gen10 x24 | 12 TB SATA HDD x1440 | ABCIクラウドストレージ |

上記のストレージシステムを用いて、ABCIシステムが提供している共有ファイルシステム及びABCIクラウドストレージの一覧を以下に示します。

| 用途 | マウントポイント | 容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| ホーム領域 | /home | 1.0 PB | Lustre | [ホーム領域](storage.md#home-area)を参照 |
| グループ領域 | /groups | 10.8 PB | Lustre | [グループ領域](storage.md#group-area)を参照 |
| 特定グループ領域 | /projects | 21.6 PB | Lustre | 特定用途に予約済みの領域 |
| ABCIクラウドストレージ | | 最大13 PB | | [ABCIクラウドストレージ](abci-cloudstorage.md)を参照 |
| 高速データ領域 | /bb | 0.3 PB | Lustre | 特定用途に予約済みの領域 |
| グローバルスクラッチ領域 | /scratch | 0.4 PB | Lustre | [グローバルスクラッチ領域](storage.md#scratch-area)を参照 |


インタラクティブノード、計算ノードは、共有ファイルシステムをマウントしており、利用者は共通のマウントポイントからこれらのファイルシステムにアクセスすることができます。

これ以外に、これらのノードはそれぞれローカルスクラッチ領域として利用可能なローカルストレージを搭載しています。以下に一覧を示します。

| ノード種類 | マウントポイント | 容量 | ファイルシステム | 備考 |
|:--|:--|:--|:--|:--|
| インタラクティブノード | /local | 12 TB | XFS | |
| 計算ノード(V) | /local | 1.6 TB | XFS | [ローカルストレージ](storage.md#local-storage)を参照 |
| 計算ノード(A) | /local1 | 2.0 TB | XFS | [ローカルストレージ](storage.md#local-storage)を参照 |
|               | /local2 | 2.0 TB | XFS | [ローカルストレージ](storage.md#local-storage)を参照 |

## ソフトウェア {#software}

ABCIシステムで利用可能なソフトウェア一覧を以下に示します。

| Category | Software | Interactive/Compute Node (V) Version | Interactive/Compute Node (A) Version |
|:--|:--|:--|:--|
| OS | Rocky Linux | 8.6 | - |
| OS | Red Hat Enterprise Linux | - | 8.2 |
| Job Scheduler | Altair Grid Engine | 8.6.19_C121_1 | 8.6.19_C121_1 |
| Development Environment | [CUDA Toolkit](gpu.md#cuda-toolkit) | 10.2.89<br>11.0.3<br>11.1.1<br>11.2.2<br>11.3.1<br>11.4.4<br>11.5.2<br>11.6.2<br>11.7.1<br>11.8.0<br>12.0.0<br>12.1.0<br>12.1.1<br>12.2.0<br>12.3.0 | 10.2.89<br>11.0.3<br>11.1.1<br>11.2.2<br>11.3.1<br>11.4.4<br>11.5.2<br>11.6.2<br>11.7.1<br>11.8.0<br>12.0.0<br>12.1.0<br>12.1.1<br>12.2.0<br>12.3.0 |
| | Intel oneAPI<br>(compilers and libraries) | 2023.0.0 | 2023.0.0 |
| | Intel VTune | 2023.0.0 | 2023.0.0 |
| | Intel Trace Analyzer and Collector | 2021.8.0 | 2021.8.0 |
| | Intel Inspector | 2023.0 | 2023.0 |
| | Intel Advisor | 2023.0 | 2023.0 |
| | GCC | 8.5.0<br>12.2.0 | 8.3.1<br>12.2.0 |
| | cmake | 3.26.1 | 3.26.1 |
| | [Python](python.md) | 3.10.10<br>3.11.2 | 3.10.10<br>3.11.2 |
| | Ruby | 2.5.9-229 | 2.5.5-157 |
| | R | 4.2.3 | 4.2.3 |
| | Java | 1.8.0.362<br>11.0.18.0.10<br>17.0.6.0.10 | 1.8.0.362<br>11.0.18.0.10<br>17.0.6.0.10 |
| | Scala | 2.10.6 | 2.10.6 |
| | Perl | 5.26.3 | 5.26.3 |
| | Go | 1.20 | 1.20 |
| | Julia | 1.8 | 1.8 |
| File System | [DDN Lustre](storage.md#home-area) | 2.12.8\_ddn23 | 2.12.8\_ddn23 |
| | [BeeOND](storage.md#beeond-storage) | 7.3.3 | 7.3.3 |
| Object Storage | Scality S3 Connector | 7.10.6.7 | 7.10.6.7 |
| Container | [SingularityPRO](containers.md#singularity) | 3.11-5 | 3.11-5 |
| | Singularity Endpoint | 2.1.5 | 2.1.5 |
| MPI | [Intel MPI](mpi.md#intel-mpi) | 2021.8 | 2021.8 |
| Library | [cuDNN](gpu.md#cudnn) | 7.6.5<br>8.0.5<br>8.1.1<br>8.2.4<br>8.3.3<br>8.4.1<br>8.5.0<br>8.6.0<br>8.7.0<br>8.8.1<br>8.9.1<br>8.9.2<br>8.9.5 | 7.6.5<br>8.0.5<br>8.1.1<br>8.2.4<br>8.3.3<br>8.4.1<br>8.5.0<br>8.6.0<br>8.7.0<br>8.8.1<br>8.9.1<br>8.9.2<br>8.9.5 |
| | [NCCL](gpu.md#nccl) | 2.5.6-1<br>2.6.4-1<br>2.7.8-1<br>2.8.4-1<br>2.9.9-1<br>2.10.3-1<br>2.11.4-1<br>2.12.12-1<br>2.13.4-1<br>2.14.3-1<br>2.15.5-1<br>2.16.2-1<br>2.17.1-1<br>2.18.1-1<br>2.18.3-1<br>2.18.5-1 | 2.5.6-1<br>2.6.4-1<br>2.7.8-1<br>2.8.4-1<br>2.9.9-1<br>2.10.3-1<br>2.11.4-1<br>2.12.12-1<br>2.13.4-1<br>2.14.3-1<br>2.15.5-1<br>2.16.2-1<br>2.17.1-1<br>2.18.1-1<br>2.18.3-1<br>2.18.5-1 |
| | gdrcopy | 2.3 | 2.3 |
| | UCX | 1.10 | 1.11 |
| | libfabric | 1.7.0-1 | 1.9.0rc1-1 |
| | Intel MKL | 2022.0.2 | 2022.0.2 |
| Utility | aws-cli | 2.11 | 2.11 |
| | s3fs-fuse | 1.91 | 1.91 |
| | rclone | 1.61.1 | 1.61.1 |

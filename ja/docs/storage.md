# ストレージ

## ホーム領域 {#home-area}

ホーム領域は、インタラクティブノードおよび各計算ノードで共有されたLustreファイルシステムのディスク領域です。すべての利用者がデフォルトで利用可能です。ディスククォータは200GiBに設定されています。

!!! warning
    ホーム領域では、1ディレクトリ配下に作成できるファイル数に上限があります。上限値はディレクトリ配下のファイル名の長さに依存し、約4百万〜12百万個です。
    上限値を超えてファイルを作成しようとした場合、"No space left on device" のエラーメッセージが出力されファイル作成に失敗します。

### [高度な設定] ストライプ機能 {#advanced-option-file-striping}

ホーム領域は並列ファイルシステムで構成されています。並列ファイルシステムでは、ファイルのデータはストレージを構成する複数のディスクに分散して格納されます。ホーム領域では、この分散方式として、ラウンドロビン分散（デフォルト）とストライプ分散が使用可能です。以下では、ストライプ機能の設定方法を説明します。

#### ストライプ機能の設定方法 {#how-to-set-up-file-striping}

ストライプ機能の設定は、```lfs setstripe```コマンドで行います。 ```lfs setstripe```コマンドでは、データを分散させるストライプパターン（ストライプサイズや範囲）を指定することができます。

```
$ lfs setstripe  [options] <dirname | filename>
```

| オプション | 説明 |
|:--:|:---|
| -S | ストライプサイズを設定。-S #k, -S #m, -S #gとすることで、サイズをKiB,MiB,GiBで設定可能。 |
| -i | ファイル書き込みを開始するOSTインデックスを指定。 -1とした場合、ファイル書き込みを開始するOSTはランダム。本システムでは、OSTインデックスは 0 から 17 を指定可能です。 |
| -c | ストライプカウントを設定。 -1とした場合、すべてのOSTに書き込みを実行。 |

!!! Tips
    OSTインデックスは、```lfs df```コマンドの OST:#の値 や```lfs osts```コマンドの左端の値で確認可能です。

例）ストライプパターンを持った新規ファイルの作成

```
[username@es1 work]$ lfs setstripe -S 1m -i 10 -c 4 stripe-file
[username@es1 work]$ ls
stripe-file
```

例) ディレクトリに対して、ストライプパターンを設定

```
[username@es1 work]$ mkdir stripe-dir
[username@es1 work]$ lfs setstripe -S 1m -i 10 -c 4 stripe-dir
```

#### ストライプ機能の表示方法 {#how-to-display-file-striping-settings}

ファイルやディレクトリのストライプパターンの情報を表示する場合は、```lfs getstripe```コマンドで行います。

```
$ lfs getstripe <dirname | filename>
```

例) ファイルの設定表示例

```
[username@es1 work]$ lfs getstripe stripe-file
stripe-file
lmm_stripe_count:  4
lmm_stripe_size:   1048576
lmm_pattern:       1
lmm_layout_gen:    0
lmm_stripe_offset: 10
        obdidx           objid           objid           group
            10         3024641       0x2e2701                0
            11         3026034       0x2e2c72                0
            12         3021952       0x2e1c80                0
            13         3019616       0x2e1360                0
```

例) ディレクトリの設定表示例

```
[username@es1 work]$ lfs getstripe stripe-dir
stripe-dir
stripe_count:  4 stripe_size:   1048576 stripe_offset: 10
```

## グループ領域 {#group-area}

グループ領域は、インタラクティブノードおよび各計算ノードで共有されたLustreファイルシステムのディスク領域です。また、グループ領域1〜3は、インタラクティブノードおよび各計算ノード(V)で共有されたGPFSファイルシステムのディスク領域です。[ABCI利用者ポータル](https://portal.abci.ai/user/)から利用管理者権限でグループディスク追加申請を行うことで利用可能になります。追加申請方法については、[ABCI利用者ポータルガイド](https://docs.abci.ai/portal/ja/)の[ディスク追加申請](https://docs.abci.ai/portal/ja/03/#352)をご参照ください。

グループ領域のパスを確認するには、`show_quota` コマンドを実行してください。コマンドの説明については [ディスククォータの確認](getting-started.md#checking-disk-quota) を参照してください。

## グローバルスクラッチ領域 {#scratch-area}

グローバルスクラッチ領域は、利用者全員が利用可能な、インタラクティブノードおよび各計算ノードで共有されたLustreファイルシステムの短期利用向け高速ストレージです。ディスククォータは10TiBに設定されています。
各利用者は以下の領域を短期利用高速データ領域として利用することが可能です。
```
/scratch/(ABCIアカウント名)
```

!!! warning
    グローバルスクラッチ領域は、クリーンアップ機能を備えています。
    ストレージ全体の空き容量が少なくなった場合に、作成から40日経過した/scratch/(ABCIアカウント名) 直下のファイルおよびディレクトリを自動的に削除します。
    削除されたファイルおよびディレクトリは復元できませんので、必要に応じて事前にバックアップしてください。

!!! note
    グローバルスクラッチ領域配下に大量のファイルを格納する場合は、/scratch/(ABCIアカウント名) 配下にディレクトリを作成の上、格納することを推奨します。

### [高度な設定] DoM(Data on MDT)機能 {#advanced-option-dom}

グローバルスクラッチ領域ではDoM(Data on MDT)機能により、LustreのMDT上にデータを格納することが可能です。
なお、DoMでMDT上に作成可能なコンポーネントサイズの最大値は 64KiB となります。

#### DoM機能の設定方法 {#how-to-set-up-dom}

DoM機能の設定は、```lfs setstripe```コマンドで行います。

```
$ lfs setstripe [options] <dirname | filename>
```

| オプション | 説明 |
|:--:|:---|
| -E | レイアウトサイズを設定。-E #k, -E #m, -E #gとすることで、サイズをKiB,MiB,GiBで設定可能です。 |
| -L | レイアウトタイプを設定。mdt を指定することで、DoM が有効になります。 |

例）DoM を有効にした新規ファイルの作成

```
[username@es1 work]$ lfs setstripe -E 64k -L mdt -E -1 dom-file
[username@es1 work]$ ls
dom-file
```

例）ディレクトリに対して、DoM 機能を設定

```
[username@es1 work]$ mkdir dom-dir
[username@es1 work]$ lfs setstripe -E 64k -L mdt -E -1 dom-dir
```

!!! note
    64KiB まで MDT にデータが格納されます。このとき、64KiB を超えたデータは OST に格納されます。

また、DoM 機能と一緒に[ストライプ機能](storage.md#advanced-option-file-striping)を設定可能です。

例）DoM 機能とストライプパターンを持った新規ファイルの作成

```
[username@es1 work]$ lfs setstripe -E 64k -L mdt -E -1 -S 1m -i 10 -c 4 dom-stripe-file
[username@es1 work]$ ls
dom-stripe-file
```

例）ディレクトリに対して、DoM 機能とストライプパターンを設定

```
[username@es1 work]$ mkdir dom-stripe-dir
[username@es1 work]$ lfs setstripe -E 64k -L mdt -E -1 -S 1m -i 10 -c 4 dom-stripe-dir
```

## ローカルストレージ {#local-storage}

ABCIシステムでは、計算ノード(V)に1.6 TBのNVMe SSD x 1、計算ノード(A)に2.0 TBのNVMe SSD x 2、メモリインテンシブノードに1.9 TBのSATA 3.0 SSD x 1が搭載されています。これらローカルストレージは次のように利用できます。

- ノードに閉じたスクラッチ領域として利用する（*ローカルスクラッチ*、*永続ローカルスクラッチ (Reserved専用)*）。
- 複数の計算ノードのローカルストレージにまたがる分散共有ファイルシステムを構成して利用する（*BeeONDストレージ*）。

ただし、ノード毎にサポートしている利用方法が異なっています。以下の対応表を確認してください。

| ローカルストレージの利用方法 | 計算ノード（VおよびA） | メモリインテンシブノード |
|:---|:--:|:--:|
| ローカルスクラッチ | ok | ok |
| BeeONDストレージ | ok | - |
| 永続ローカルスクラッチ (Reserved専用) | ok | - |

### ローカルスクラッチ {#local-scratch}

計算ノードとメモリインテンシブノードのローカルストレージは、ジョブ投入時に特別なオプションを指定することなくローカルスクラッチとして利用できます。
なお、ローカルストレージとして利用できる容量は、指定した[ジョブ実行リソース](job-execution.md#job-execution-resource)によって異なります。
ローカルストレージへのパスはジョブ毎に異なり、[環境変数](job-execution.md#environment-variables)`SGE_LOCALDIR`を利用してアクセスすることができます。

例）ジョブスクリプトの例(use\_local\_storage.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

echo test1 > $SGE_LOCALDIR/foo.txt
echo test2 > $SGE_LOCALDIR/bar.txt
cp -rp $SGE_LOCALDIR/foo.txt $HOME/test/foo.txt
```

例）ジョブの投入

```
[username@es1 ~]$ qsub -g grpname use_local_storage.sh
```

例）use\_local\_storage.sh 実行後の状態

```
[username@es1 ~]$ ls $HOME/test/
foo.txt    <- スクリプト内で明示的にコピーしたファイルのみが残る。
```

!!! warning
    `$SGE_LOCALDIR`以下に作成したファイルはジョブ実行終了時に削除されるため、必要なファイルは`cp`コマンドなどを用いてジョブスクリプト内でホーム領域またはグループ領域にコピーをしてください。

!!! note
    rt\_AF では`$SGE_LOCALDIR`だけではなく、`/local2`以下も利用できます。ジョブ実行終了時に削除されるのは同様です。

### 永続ローカルスクラッチ (Reserved専用) {#persistent-local-scratch}

本機能は、Reservedサービス専用です。Reservedサービスでは、計算ノードのローカルストレージに、ジョブ毎に削除されない永続領域を使用可能です。この領域はReservedサービス開始時に作成され、Reservedサービス終了時に削除されます。
永続ローカルスクラッチは、[環境変数](job-execution.md#environment-variables)`SGE_ARDIR`を利用してアクセスすることができます。

例）ジョブスクリプトの例 (use\_reserved\_storage\_write.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

echo test1 > $SGE_ARDIR/foo.txt
echo test2 > $SGE_ARDIR/bar.txt
```

例）ジョブの投入

```
[username@es1 ~]$ qsub -g grpname -ar 12345 use_reserved_storage_write.sh
```

例）ジョブスクリプトの例 (use\_reserved\_storage\_read.sh)

```bash
#!/bin/bash

#$-l rt_F=1
#$-cwd

cat $SGE_ARDIR/foo.txt
cat $SGE_ARDIR/bar.txt
```

例）ジョブの投入

```
[username@es1 ~]$ qsub -g grpname -ar 12345 use_reserved_storage_read.sh
```

!!! warning
    `$SGE_ARDIR`以下に作成したファイルはReservedサービス終了時に削除されるため、必要なファイルは`cp`コマンドなどを用いてジョブにてホーム領域またはグループ領域にコピーをしてください。

!!! warning
    計算ノード(A)では、NVMe SSD が2つ搭載されており、永続ローカルスクラッチは`/local2`を使用します。ローカルスクラッチと永続ローカルスクラッチが同一のストレージに割り当てられる場合があり、その場合は容量を共有します。
    計算ノード(V)では、NVMe SSD が1つしか搭載されていないため、ローカルスクラッチと永続ローカルスクラッチは同一のストレージとなり、必ず容量を共有します。
	いずれの場合も、永続ローカルスクラッチを利用する場合には使用量に注意してください。

### BeeONDストレージ {#beeond-storage}

BeeGFS On Demand (BeeOND) を使用することで、ジョブに割り当てられた計算ノードのローカルストレージを集約し、一時的な分散共有ファイルシステムとして使用可能です。
BeeOND を利用するジョブを投入するときは、`-l USE_BEEOND=1`オプションを指定してジョブを実行してください。
また、BeeONDを利用する場合はノードを占有する必要があるため、`-l rt_F`オプションもしくは`-l rt_AF`オプションを指定する必要もあります。

作成された分散共有ファイルシステム領域には、[環境変数](job-execution.md#environment-variables)SGE_BEEONDDIRを利用してアクセスすることができます。

例）ジョブスクリプトの例 (use\_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=2
#$-l USE_BEEOND=1
#$-cwd

echo test1 > $SGE_BEEONDDIR/foo.txt
echo test2 > $SGE_BEEONDDIR/bar.txt
cp -rp $SGE_BEEONDDIR/foo.txt $HOME/test/foo.txt
```

例）ジョブの投入

```
[username@es1 ~]$ qsub -g grpname use_beeond.sh
```

例）use\_beeond.sh 実行後の状態

```
[username@es1 ~]$ ls $HOME/test/
foo.txt    <- スクリプト内で明示的にコピーしたファイルのみが残る。
```

!!! warning
    `$SGE_BEEONDDIR`以下に作成したファイルはジョブ実行終了時に削除されるため、必要なファイルは`cp`コマンドなどを用いてジョブスクリプト内でホーム領域またはグループ領域にコピーをしてください。

!!! warning
    計算ノード(A)では、NVMe SSD が2つ搭載されており、BeeONDストレージは`/local2`を使用します。
    計算ノード(V)では、NVMe SSD が1つしか搭載されていないため、ローカルスクラッチとBeeONDストレージは同一のストレージを使用し、必ず容量を共有します。

#### [高度な設定] BeeONDサーバ数変更 {#advanced-option-configure-beeond-servers}

BeeONDファイルシステム領域は、ファイルの実体を格納するストレージサービスを提供する計算ノード（ストレージサーバ）、ファイルのメタデータを格納するメタデータサービスを提供する計算ノード（メタデータサーバ）により構成されます。
ABCIのBeeONDではストレージサーバ数、メタデータサーバ数を変更することができます。

メタデータサーバ数・ストレージサーバ数のデフォルトの設定は以下の通りです。

| 設定項目 | デフォルト値 |
|:--:|---:|
| メタデータサーバ数 | 1 |
| ストレージサーバ数 | ジョブの要求ノード数 |

それぞれの数を変更するときには、ジョブスクリプトで次の環境変数を設定します。この環境変数はジョブ投入時に定義されている必要があり、ジョブスクリプト中で変更しても反映されません。サーバ数がジョブの要求ノード数よりも小さい場合、割り当てられた計算ノードから名前順に選択されます。

| 環境変数 | 説明 |
|:---|:---|
| BEEOND_METADATA_SERVER | メタデータサーバ数を整数で指定 |
| BEEOND_STORAGE_SERVER | ストレージサーバ数を整数で指定 |

以下の例では、メタデータサーバ数2、ストレージサーバ数4でBeeONDファイルシステム領域を構成する例です。`beegfs-df`で構成を確認しています。

例）ジョブスクリプトの例(use_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=8
#$-l USE_BEEOND=1
#$-v BEEOND_METADATA_SERVER=2
#$-v BEEOND_STORAGE_SERVER=4
#$-cwd

beegfs-df -p /beeond
```

出力例
```
METADATA SERVERS:
TargetID   Cap. Pool        Total         Free    %      ITotal       IFree    %
========   =========        =====         ====    =      ======       =====    =
       1      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       2      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%

STORAGE TARGETS:
TargetID   Cap. Pool        Total         Free    %      ITotal       IFree    %
========   =========        =====         ====    =      ======       =====    =
       1      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       2      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       3      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
       4      normal    1489.7GiB    1322.7GiB  89%      149.0M      149.0M 100%
```

#### [高度な設定] ストライプ機能 {#advanced-option-file-striping_1}

BeeONDファイルシステム領域では、ファイルのデータはファイルシステムを構成する複数のストレージサーバに分散して格納されます。ABCIのBeeONDではストライプ分散の設定を変更することができます。

ストライプ分散のデフォルトの設定は次の通りです。

| 設定項目 | デフォルト値 | 説明 |
|:--:|---:|:---|
| ストライプサイズ | 512 KB | ファイルの分割サイズ |
| ストライプカウント | 4 | 分割したファイル断片を格納するストレージサーバの数 |

ファイル単位、またはディレクトリ単位でストライプ分散の設定を行えます。ストライプ分散の設定は`beegfs-ctl`で行えます。

以下の例では`/beeond/data`ディレクトリ以下のストライプ設定を、ストライプカウント8、ストライプサイズ4MBに設定しています。

例）ジョブスクリプトの例(use_beeond.sh)

```bash
#!/bin/bash

#$-l rt_F=8
#$-l USE_BEEOND=1
#$-cwd

BEEOND_DIR=/beeond/data
mkdir ${BEEOND_DIR}
beegfs-ctl --setpattern --numtargets=8 --chunksize=4M --mount=/beeond ${BEEOND_DIR}
beegfs-ctl --mount=/beeond --getentryinfo ${BEEOND_DIR}
```

出力例

```
New chunksize: 4194304
New number of storage targets: 8

EntryID: 0-5D36F5EC-1
Metadata node: gXXXX.abci.local [ID: 1]
Stripe pattern details:
+ Type: RAID0
+ Chunksize: 4M
+ Number of storage targets: desired: 8
+ Storage Pool: 1 (Default)
```

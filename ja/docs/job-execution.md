# ジョブ実行

## ジョブサービス {#job-services}

ABCIシステムでは、以下のジョブサービスが利用可能です。

| サービス名 | 説明 | サービス課金係数 | 利用形態 |
|:--|:--|:--|:--|
| On-demand | インタラクティブジョブの実行サービス | 1.0 | インタラクティブジョブ |
| Spot | バッチジョブの実行サービス | 1.0 | バッチジョブ |
| Reserved | 事前予約型ジョブサービス | 1.5 | 事前予約 |

各ジョブサービスで利用可能なジョブ実行リソース、制限事項等については、[ジョブ実行リソース](#job-execution-resource)を参照してください。また、課金については、[課金](#accounting)を参照してください。

### On-demandサービス {#on-demand-service}

プログラムのコンパイルやデバッグ、対話的なアプリケーション、可視化ソフトウェアの実行に適したインタラクティブジョブの実行サービスです。

利用方法は[インタラクティブジョブ](#interactive-jobs)、インタラクティブジョブの実行オプションの詳細は[ジョブ実行オプション](#job-execution-options)をそれぞれ参照してください。

### Spotサービス {#spot-service}

対話的な処理の必要がないアプリケーションの実行に適したバッチジョブの実行サービスです。On-demandサービスに比べてより長時間のジョブや、より並列度の高いジョブの実行が可能です。

利用方法は[バッチジョブ](#batch-jobs)、バッチジョブの実行オプションの詳細は[ジョブ実行オプション](#job-execution-options)をそれぞれ参照してください。

### Reservedサービス {#reserved-service}

計算リソースを日単位で事前に予約して利用できるサービスです。On-demandおよびSpotサービスの混雑の影響を受けることなく、計画的なジョブ実行が可能となります。また、経過時間およびノード時間積の制限がないため、より長時間のジョブ実行が可能です。

Reservedサービスでは、まず事前予約を行って予約ID (AR-ID)を取得し、この予約IDを用いてインタラクティブジョブやバッチジョブの実行を行います。

予約方法は[事前予約](#advance-reservation)を参照してください。インタラクティブジョブやバッチジョブの利用方法、実行オプションはOn-demandおよびSpotサービスと共通です。

## ジョブ実行リソース {#job-execution-resource}

ABCIシステムでは、計算リソースを論理的に分割した資源タイプを利用して、ジョブサービスにシステムリソースを割り当てます。On-demand、Spot、Reservedのいずれのサービスを利用する場合も、利用者は利用したい資源タイプとその数量を指定して、ジョブの投入/実行、計算ノードの予約を行います。

以下では、まず利用可能な資源タイプについて解説し、続いて同時に利用可能な資源量、経過時間およびノード時間積、ジョブ投入数および実行数に関する制限事項等を説明します。

### 利用可能な資源タイプ {#available-resource-types}

ABCIシステムには、[計算ノード](system-overview.md#compute-node)と[メモリインテンシブノード](system-overview.md#memory-intensive-node)の2種類の計算リソースがあり、それぞれについて次のように資源タイプが用意されています。

#### 計算ノード(V) {#compute-node-v}

| 資源タイプ | 資源タイプ名 | 説明 | 割り当て物理CPUコア数 | 割り当てGPU数 | メモリ (GiB) | ローカルストレージ (GB) | 資源タイプ課金係数 |
|:--|:--|:--|:--|:--|:--|:--|:--|
| Full | rt\_F | ノード占有 | 40 | 4 | 360 | 1440 | 1.00 |
| G.large | rt\_G.large | ノード共有<br>GPU利用 | 20 | 4 | 240 | 720 | 0.90 |
| G.small | rt\_G.small | ノード共有<br>GPU利用 | 5 | 1 | 60 | 180 | 0.30 |
| C.large | rt\_C.large | ノード共有<br>CPUのみ利用 | 20 | 0 | 120 | 720 | 0.60 |
| C.small | rt\_C.small | ノード共有<br>CPUのみ利用 | 5 | 0 | 30 | 180 | 0.20 |

#### 計算ノード(A) {#compute-node-a}

| 資源タイプ | 資源タイプ名 | 説明 | 割り当て物理CPUコア数 | 割り当てGPU数 | メモリ (GiB) | ローカルストレージ (GB) | 資源タイプ課金係数 |
|:--|:--|:--|:--|:--|:--|:--|:--|
| Full | rt\_AF | ノード占有 | 72 | 8 | 480 | 3440[^1] | 3.00 |
| AG.small | rt\_AG.small | ノード共有<br>GPU利用 | 9 | 1 | 60 | 390 | 0.50 |

[^1]: /local1 (1590 GB) と /local2 (1850 GB) の合算。

#### メモリインテンシブノード {#memory-intensive-node}

| 資源タイプ | 資源タイプ名 | 説明 | 割り当て物理CPUコア数 | 割り当てGPU数 | メモリ (GiB) | ローカルストレージ (GB) | 資源タイプ課金係数 |
|:--|:--|:--|:--|:--|:--|:--|:--|
| M.large | rt\_M.large | ノード共有<br>CPUのみ利用 | 8 | \- | 800 | 480 | 0.40 | 
| M.small | rt\_M.small | ノード共有<br>CPUのみ利用 | 4 | \- | 400 | 240 | 0.20 | 

複数ノードを使用するジョブを実行する場合は、計算ノードを占有する資源タイプ`rt_F`もしくは`rt_AF`を指定してください。メモリインテンシブノードでは複数ノードを使用するジョブを実行することはできません。

!!! warning
    ノード共有の資源タイプでは、ジョブのプロセス情報は同一ノードで実行されている他のジョブから参照可能になります。
    他のジョブから参照させたくない場合、資源タイプ`rt_F`もしくは`rt_AF`を指定しノード占有でジョブを実行してください。

### 同時に利用可能なノード数 {#number-of-nodes-available-at-the-same-time}

ジョブサービスごとに利用可能な資源タイプとノード数の組み合わせを以下に示します。同時に複数ノードを利用する場合は、資源タイプ`rt_F`もしくは`rt_AF`を指定する必要があります。

| サービス名 | 資源タイプ名 | ノード数 |
|:--|:--|--:|
| On-demand | rt\_F       | 1-32 |
|           | rt\_G.large | 1 |
|           | rt\_G.small | 1 |
|           | rt\_C.large | 1 |
|           | rt\_C.small | 1 |
|           | rt\_AF      | 1-4 |
|           | rt\_AG.small| 1 |
|           | rt\_M.large | 1 |
|           | rt\_M.small | 1 |
| Spot      | rt\_F       | 1-512 |
|           | rt\_G.large | 1 |
|           | rt\_G.small | 1 |
|           | rt\_C.large | 1 |
|           | rt\_C.small | 1 |
|           | rt\_AF      | 1-64 |
|           | rt\_AG.small| 1 |
|           | rt\_M.large | 1 |
|           | rt\_M.small | 1 |
| Reserved  | rt\_F       | 1-予約ノード数 |
|           | rt\_G.large | 1 |
|           | rt\_G.small | 1 |
|           | rt\_C.large | 1 |
|           | rt\_C.small | 1 |
|           | rt\_AF      | 1-予約ノード数 |
|           | rt\_AG.small| 1 |

### 経過時間およびノード時間積の制限 {#elapsed-time-and-node-time-product-limits}

ジョブサービス、資源タイプに応じて、ジョブの経過時間制限 (実行可能時間の制限) があります。上限値およびデフォルト値を以下に示します。

| サービス名 | 資源タイプ名 | 経過時間制限 (上限値/デフォルト) |
|:--|:--|:--|
| On-demand | rt\_F, rt\_AF | 12:00:00/1:00:00 |
|           | rt\_G.large, rt\_C.large, rt\_M.large | 12:00:00/1:00:00 |
|           | rt\_G.small, rt\_C.small, rt\_AG.small, rt\_M.small | 12:00:00/1:00:00 |
| Spot      | rt\_F, rt\_AF | 72:00:00/1:00:00 |
|           | rt\_G.large, rt\_C.large, rt\_M.large, rt\_M.small | 72:00:00/1:00:00 |
|           | rt\_G.small, rt\_C.small, rt\_AG.small | 168:00:00/1:00:00 |
| Reserved  | rt\_F, rt\_AF | 無制限 |
|           | rt\_G.large, rt\_C.large | 無制限 |
|           | rt\_G.small, rt\_C.small, rt\_AG.small | 無制限 |

また、On-demandおよびSpotサービスで、複数ノードを使用するジョブを実行する場合には、ノード時間積（使用ノード数 &times; 実行時間）に以下の制限があります。

| サービス名 | ノード時間積の最大値 |
|:--|--:|
| On-demand                                     |   12 nodes &middot; hours |
| Spot(計算ノード(V), メモリインテンシブノード) | 2304 nodes &middot; hours |
| Spot(計算ノード(A))                           |  288 nodes &middot; hours |

### ジョブ投入数および実行数の制限 {#limitation-on-the-number-of-job-submissions-and-executions}

1ユーザが同時に投入・実行できるジョブ数に以下の制限があります。
予約ノードに投入されたジョブもOn-demandやSpotのジョブと同様にジョブ数のカウントに含まれ、本制約を受けます。

| 制限項目 | 制限値 |
|:--|:--|
| 1ユーザあたりの同時投入可能ジョブ数 | 1000 |
| 1ユーザあたりの同時実行ジョブ数 | 200 |
| 1アレイジョブあたりの最大投入可能タスク数 | 75000 |

### 実行優先度 {#execution-priority}

各ジョブサービスでは、実行時にPOSIX優先度を指定できます。指定可能な優先度の値は以下のとおりです。

| サービス名 | 優先度 | 説明 | POSIX優先度課金係数 |
|:--|:--|:--|:--|
| On-demand | -450 | 既定 (変更不可) | 1.0 |
| Spot      | -500 | 既定 | 1.0 |
|           | -400 | 優先実行 | 1.5 |
| Reserved  | -500 | 既定 (変更不可) | NA |

On-demandサービスでは、優先度は`-450`に固定されており変更できません。

Spotサービスでは、`-400`を指定することで他のジョブより優先的に実行できます。ただし、POSIX優先度課金係数に応じた課金が行われます。

Reservedサービスでは、インタラクティブジョブ、バッチジョブのいずれの場合も優先度は`-500`に固定されており変更できません。

## ジョブ実行オプション {#job-execution-options}

インタラクティブジョブの実行には`qrsh`コマンド、バッチジョブの実行には`qsub`コマンドをそれぞれ使用します。

`qrsh`、`qsub`コマンドに共通する、主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -g *group* | ABCI利用グループを*group*で指定します。 |
| -l *resource_type*=*num* | 資源タイプ*resource_type*と、その個数*num*を指定します。本オプションは指定必須です。 |
| -l h\_rt=[*HH:MM:*]*SS* | 経過時間制限値を指定します。[*HH:MM:*]*SS*で指定することができます。ジョブの実行時間が指定した時間を超過した場合、ジョブは強制終了されます。 |
| -N *name* | ジョブ名を*name*で指定します。デフォルトは、ジョブスクリプト名です。 |
| -o *stdout_name* | 標準出力名を*stdout_name*で指定します。 |
| -p *priority* | SpotサービスでPOSIX優先度を*priority*で指定します。 |
| -e *stderr_name* | 標準エラー出力名を*stderr_name*で指定します。 |
| -j y | 標準エラー出力を標準出力にマージします。 |
| -m a | ジョブが実行中止された場合にメールを送信します。 |
| -m b | ジョブ実行開始時にメールを送信します。 |
| -m e | ジョブ実行終了時にメールを送信します。 |
| -t *n*[*-m*[*:s*]] | アレイジョブのタスクIDを*n*[*-m*[*:s*]]で指定します。*n*は開始番号、*m*は終了番号、*s*はステップサイズを表します。 |
| -hold\_jid *job_id* | 依存関係にあるジョブIDを*job_id*で指定します。指定された依存ジョブが終了するまでジョブは実行開始されません。`qrsh`コマンドにて使用する場合、引数にコマンドを指定した場合のみ利用可能です。 |
| -ar *ar_id* | 予約した計算ノードを利用する際に予約ID(AR-ID)を*ar_id*で指定します。 |

この他、拡張オプションとして以下のオプションが使用可能です。

| オプション | 説明 |
|:--|:--|
| -l USE\_SSH=*1*<br>-v SSH\_PORT=*port* | 計算ノードへのSSHログインを有効にする。詳細は[計算ノードへのSSHアクセス](appendix/ssh-access.md)を参照。 |
| -l USE\_BEEOND=*1*<br>-v BEEOND\_METADATA\_SERVER=*num*<br>-v BEEOND\_STORAGE\_SERVER=*num* | BeeGFS On Demand (BeeOND)を利用するジョブの投入。詳細は[BeeONDストレージ利用](storage.md#beeond-storage)を参照。 |
| -v GPU\_COMPUTE\_MODE=*mode* | 計算ノードのGPU Compute Modeの変更。詳細は[GPU Compute Modeの変更](gpu.md#changing-gpu-compute-mode)を参照。 |
| -l docker<br>-l docker\_images | Dockerを利用するジョブの投入。詳細は[Docker](containers.md#docker)を参照。 |

## インタラクティブジョブ {#interactive-jobs}

インタラクティブジョブを実行するには、`qrsh`コマンドを使用します。

```
$ qrsh -g group -l resource_type=num [options]
```

例) インタラクティブジョブを実行 (On-demandサービス)

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ 
```

!!! note
    On-demandサービスでは、インタラクティブジョブ実行時にABCIポイントが不足している場合、ジョブの実行に失敗します。

X Window を利用するアプリケーションを実行するには、
まずインタラクティブノードへのログイン時に、X11転送を有効（`-X`もしくは`-Y`オプションを指定）にします。

```
[yourpc ~]$ ssh -XC -p 10022 -l username localhost
```

次にインタラクティブジョブ実行時に、引数に`-pty yes -display $DISPLAY -v TERM /bin/bash`を指定します。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00 -pty yes -display $DISPLAY -v TERM /bin/bash
[username@g0001 ~]$ xterm <- Xアプリケーションを起動
```

## バッチジョブ {#batch-jobs}

ABCIシステムでバッチジョブを実行する場合、実行するプログラムとは別にジョブスクリプトを作成します。
ジョブスクリプトには利用する資源タイプ名、経過時間制限値などの資源などのジョブ実行オプションを記述した上で、
実行するコマンド列を記載します。

```bash
#!/bin/bash

#$ -l rt_F=1
#$ -l h_rt=1:23:45
#$ -j y
#$ -cwd

[Environment Modules の初期化]
[Environment Modules の設定]
[プログラムの実行]
```

例) CUDAを利用したプログラムを実行するジョブスクリプト例

```bash
#!/bin/bash

#$-l rt_F=1
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
module load cuda/9.2/9.2.88.1
./a.out
```

### バッチジョブの投入 {#submit-a-batch-job}

バッチジョブを実行するには、`qsub`コマンドを使用します。

```
$ qsub -g group [options] script_name
```

例) ジョブスクリプトrun.shをバッチジョブとして投入 (Spotサービス)

```
[username@es1 ~]$ qsub -g grpname run.sh
Your job 12345 ("run.sh") has been submitted
```

!!! warning
    `-g`オプションは、ジョブスクリプト内には指定できません。

!!! note
    Spotサービスでは、バッチジョブ投入時にABCIポイントが不足している場合、バッチジョブの投入に失敗します。

### バッチジョブの状態の確認 {#show-the-status-of-batch-jobs}

バッチジョブを状態を確認するには、`qstat`コマンドを利用します。

```
$ qstat [options]
```

`qstat`コマンドの主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -r | ジョブのリソース情報を表示します。 |
| -j | ジョブに関する追加情報を表示します。 |

例)

```
[username@es1 ~]$ qstat
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
     12345 0.25586 run.sh     username     r     06/27/2018 21:14:49 gpu@g0001                                                        80
```

| 項目 | 説明 |
|:--|:--|
| job-ID | ジョブID |
| prior | ジョブ優先度 |
| name | ジョブ名 |
| user | ジョブのオーナー |
| state | ジョブ状態 (r: 実行中、qw: 待機中、d: 削除中、E: エラー状態) |
| submit/start at | ジョブ投入/開始時刻 |
| queue | キュー名 |
| jclass | ジョブクラス名 |
| slots | ジョブスロット数 (ノード数 x 80) |
| ja-task-ID | アレイジョブのタスクID |

### バッチジョブの削除 {#delete-a-batch-job}

バッチジョブを削除するには、`qdel`コマンドを利用します。

```
$ qdel job_id
```

例) バッチジョブを削除

```
[username@es1 ~]$ qstat
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
     12345 0.25586 run.sh     username     r     06/27/2018 21:14:49 gpu@g0001                                                        80
[username@es1 ~]$ qdel 12345
username has registered the job 12345 for deletion
```

### バッチジョブの標準出力と標準エラー出力 {#stdout-and-stderr-of-batch-jobs}

バッチジョブの標準出力ファイルと標準エラー出力ファイルは、ジョブ実行ディレクトリもしくは、
ジョブ投入時に指定されたファイルに出力されます。
標準出力ファイルにはジョブ実行中の標準出力、標準エラー出力ファイルにはジョブ実行中のエラーメッセージが出力されます。
ジョブ投入時に、標準出力ファイル、標準エラー出力ファイルを指定しなかった場合は、以下のファイルに出力されます。

- *JOB_NAME*.o*JOB_ID*  ---  標準出力ファイル
- *JOB_NAME*.e*JOB_ID*  ---  標準エラー出力ファイル

例）ジョブ名がrun.sh、ジョブIDが`12345`の場合

- 標準出力ファイル名：run.sh.o12345
- 標準エラー出力ファイル名：run.sh.e12345

### バッチジョブの統計情報出力 {#report-batch-job-accounting}

バッチジョブの統計情報を出力するには、`qacct`コマンドを利用します。

```
$ qacct [options]
```

`qacct`コマンドの主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -g *group* | *group*のジョブに関する情報を表示します。 |
| -j *job_id* | *job_id*のジョブに関する情報を表示します。 |
| -t *n*[*-m*[*:s*]] | アレイジョブのタスクIDを*n*[*-m*[*:s*]]で指定します。指定されたタスクIDにマッチするジョブの情報のみ表示されます。本オプションは-jオプションを指定した場合のみ使用可能です。 |

例) バッチジョブの統計情報を参照

```
[username@es1 ~]$ qacct -j 12345
==============================================================
qname        gpu
hostname     g0001
group        group 
owner        username
project      group 
department   group
jobname      run.sh
jobnumber    12345
taskid       undefined
account      username
priority     0
cwd          NONE
submit_host  es1.abci.local
submit_cmd   /home/system/uge/latest/bin/lx-amd64/qsub -P username -l h_rt=600 -l rt_F=1
qsub_time    07/01/2018 11:55:14.706
start_time   07/01/2018 11:55:18.170
end_time     07/01/2018 11:55:18.190
granted_pe   perack17
slots        80
failed       0
deleted_by   NONE
exit_status  0
ru_wallclock 0.020
ru_utime     0.010
ru_stime     0.013
ru_maxrss    6480
ru_ixrss     0
ru_ismrss    0
ru_idrss     0
ru_isrss     0
ru_minflt    1407
ru_majflt    0
ru_nswap     0
ru_inblock   0
ru_oublock   8
ru_msgsnd    0
ru_msgrcv    0
ru_nsignals  0
ru_nvcsw     13
ru_nivcsw    1
wallclock    3.768
cpu          0.022
mem          0.000
io           0.000
iow          0.000
ioops        0
maxvmem      0.000
maxrss       0.000
maxpss       0.000
arid         undefined
jc_name      NONE
```

主な表示項目は以下の通りです。
その他項目の詳細は`man sge_accounting`を参照ください。

| 項目 | 説明 |
|:--|:--|
| jobnunmber   | ジョブID |
| taskid       | アレイジョブのタスクID |
| qsub\_time   | ジョブの実行投入時刻 |
| start\_time  | ジョブの実行開始時刻 |
| end\_time    | ジョブの実行終了時刻 |
| failed       | ジョブスケジューラのジョブ終了コード |
| exit\_status | ジョブの終了ステータス |
| wallclock    | ジョブの実行時間(前後処理を含む) |

### 環境変数 {#environment-variables}

ジョブ実行中に、ジョブスクリプトもしくはコマンドラインで利用できる環境変数は以下の通りです。

| 環境変数 | 説明 |
|:--|:--|
| ENVIRONMENT | ジョブの場合、"BATCH"が割り当てられる |
| JOB\_ID | ジョブID |
| JOB\_NAME | ジョブ名 |
| JOB\_SCRIPT | ジョブスクリプト名 |
| NHOSTS | ジョブに割り当てられたホスト数 |
| PE\_HOSTFILE | ジョブに割り当てられたホスト、スロット、キュー名が記載されたファイルへのパス |
| RESTARTED | ジョブが再実行された場合は1、それ以外は0 |
| SGE\_ARDIR | Reservedサービスに割り当てられたローカルストレージへのパス |
| SGE\_BEEONDDIR | BeeONDストレージ利用時に割り当てられたBeeONDストレージへのパス |
| SGE\_JOB\_HOSTLIST | ジョブに割り当てられたホストが記載されたファイルへのパス |
| SGE\_LOCALDIR | ジョブに割り当てられたローカルストレージへのパス |
| SGE\_O\_WORKDIR | ジョブ投入時の作業ディレクトリへのパス |
| SGE\_TASK\_ID | アレイジョブのタスクID(アレイジョブでない場合は"undefined") |
| SGE\_TASK\_FIRST | アレイジョブの最初のタスクID |
| SGE\_TASK\_LAST | アレイジョブの最後のタスクID |
| SGE\_TASK\_STEPSIZE | アレイジョブのステップサイズ |

## 事前予約 {#advance-reservation}

Reservedサービスでは、計算ノードを事前に予約して計画的なジョブ実行が可能となります。

本サービスで予約可能なノード数およびノード時間積は、以下表の「1予約あたりの最大予約ノード数」、「1予約あたりの最大予約ノード時間積」が上限です。また、本サービスでは、利用者は予約ノード数を上限とするジョブしか実行できません。なお、システム全体で「システムあたりの最大同時予約可能ノード数」に上限があるため、「1予約あたりの最大予約ノード数」を下回る予約しかできない場合や、予約自体ができない場合があります。予約した計算ノードにて[各資源タイプ](#available-resource-types)が利用可能です。

| 項目 | 計算ノード(V)向け説明 | 計算ノード(A)向け説明|
|:--|:--|:--|
| 最小予約日数 | 1日 | 1日 |
| 最大予約日数 | 30日 | 30日 |
| システムあたりの最大同時予約可能ノード数 | 442ノード | 50ノード |
| 1予約あたりの最大予約ノード数 | 32ノード | 16ノード |
| 1予約あたりの最大予約ノード時間積 | 12,288ノード時間積 | 6,144ノード時間積 |
| 予約受付開始時刻 | 30日前の午前10時 | 30日前の午前10時 |
| 予約受付締切時刻 | 予約開始前日の午後9時 | 予約開始前日の午後9時 |
| 予約取消受付期間 | 予約開始前日の午後9時 | 予約開始前日の午後9時 |
| 予約開始時刻 | 予約開始日の午前10時 | 予約開始日の午前10時 |
| 予約終了時刻 | 予約終了日の午前9時30分 | 予約終了日の午前9時30分 |

### 予約の実行 {#make-a-reservation}

計算ノードを予約するには、[ABCI利用者ポータル](https://portal.abci.ai/user/)もしくは`qrsub`コマンドを使用します。

!!! warning
    計算ノードの予約は、利用責任者もしくは利用管理者のみが実施できます。

!!! warning
    ABCI利用者ポータルでは、計算ノード(A)の予約はできません。

```
$ qrsub options
```

| オプション | 説明 |
|:--|:--|
| -a *YYYYMMDD* | 予約開始日を*YYYYMMDD*で指定します。 |
| -d *days* | 予約日数を*days*で指定します。 -eオプションとは排他です。 |
| -e *YYYYMMDD* | 予約終了日を*YYYYMMDD*指定します。-dオプションとは排他です。 |
| -g *group* | ABCI利用グループを*group*で指定します。 |
| -N *name* | 予約名を*name*で指定します。英数字と記号`=+-_.`が指定可能で、最大64文字まで指定できます。ただし、先頭の文字に数字を指定することはできません。 |
| -n *nnnode* | 予約するノード数を*nnnode*で指定します。 |
| -l *resource_type* | 予約する資源タイプを*resource_type*で指定します。 省略した場合は、rt_F が指定されたとみなします。|

例) 2018年7月5日から1週間 (7日間) 計算ノード(V)4台を予約

```
[username@es1 ~]$ qrsub -a 20180705 -d 7 -g grpname -n 4 -N "Reserve_for_AI"
Your advance reservation 12345 has been granted
```

例) 2021年7月5日から1週間 (7日間) 計算ノード(A)4台を予約

```
[username@es1 ~]$ qrsub -a 20210705 -d 7 -g grpname -n 4 -N "Reserve_for_AI" -l rt_AF
Your advance reservation 12345 has been granted
```

計算ノードの予約が完了した時点でABCIポイントを消費します。

### 予約状態の確認 {#show-the-status-of-reservations}

予約状態を確認するには、[ABCI利用者ポータル](https://portal.abci.ai/user/)もしくは`qrstat`コマンドを使用します。

例)

```
[username@es1 ~]$ qrstat
ar-id      name       owner        state start at             end at               duration    sr
----------------------------------------------------------------------------------------------------
     12345 Reserve_fo root         w     07/05/2018 10:00:00  07/12/2018 09:30:00  167:30:00    false
```

| 項目 | 説明 |
|:--|:--|
| ar-id | 予約ID (AR-ID) |
| name | 予約名 |
| owner | 常にrootと表示 |
| state | 予約状態 |
| start at | 予約開始日 (予約開始時刻は常に午前10時) |
| end at | 予約終了日 (予約終了時刻は常に午前9時30分) |
| duration | 予約期間 (hhh:mm:ss) |
| sr | 常にfalseと表示 |

システムあたりの予約可能ノード数を確認するには、[ABCI利用者ポータル](https://portal.abci.ai/user/)もしくは`qrstat`コマンドの`--available`オプションを使用します。

計算ノード(V)の予約可能ノード数の確認
```
[username@es1 ~]$ qrstat --available
06/27/2018  441
07/05/2018  432
07/06/2018  434
```

計算ノード(A)の予約可能ノード数の確認
```
[username@es1 ~]$ qrstat --available -l rt_AF
06/27/2021   41
07/05/2021   32
07/06/2021   34
```

!!! note
    計算ノードが予約されていない日付は表示されません。

### 予約の取り消し {#cancel-a-reservation}

!!! warning
    予約の取り消しは利用責任者もしくは利用管理者のみが実施できます。

予約を取り消すには、[ABCI利用者ポータル](https://portal.abci.ai/user/)もしくは`qrdel`コマンドを使用します。`qrdel`コマンドでの予約取り消しは、「,(カンマ)」区切りのリストとして複数指定できます。指定したar_idの中に1つでも存在しない予約ID、もしくは削除権限のない予約IDが指定されている場合は、エラーとなり削除は実行されません。

例) 予約を取り消し

```
[username@es1 ~]$ qrdel 12345,12346
```

### 予約ノードの使い方 {#how-to-use-reserved-node}

予約した計算ノードには、`-ar`オプションにて予約IDを指定してジョブを投入します。

例) 予約ID`12345`で予約された計算ノードでインタラクティブジョブを実行

```
[username@es1 ~]$ qrsh -g grpname -ar 12345 -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ 
```

例) ジョブスクリプトrun.shを予約ID`12345`で予約された計算ノードにバッチジョブとして投入

```
[username@es1 ~]$ qsub -g grpname -ar 12345 run.sh
Your job 12345 ("run.sh") has been submitted
```

!!! note  
    - 予約作成時に指定したABCIグループを指定する必要があります。
    - バッチジョブは予約作成直後から投入できますが、予約開始時刻になるまで実行されません。  
    - 予約開始時刻前に投入したバッチジョブは`qdel`コマンドで削除できます。  
    - 予約開始時刻前に予約を削除した場合、当該予約に投入されていたバッチジョブは削除されます。  
    - 予約終了時刻になると実行中のジョブは強制終了されます。  

### 予約ノードご利用時の注意 {#cautions-for-using-reserved-node}

予約は期間中の計算ノードの健全性を保証するものではありません。予約した計算ノードの利用中に一部が利用不可となることがありますので、以下の点をご確認ください。

* 予約した計算ノードの利用可否状態は、`qrstat -ar ar_id` コマンドで確認できます。
* 予約開始前日に一部の予約ノードが利用不可と表示される場合は、予約の取り消し・再度予約をご検討ください。
* 予約期間中に計算ノードが利用不可となった場合などの時は、[お問い合わせ](./contact.md)のページをご覧の上、<qa@abci.ai> までご連絡ください。

!!! note
    - 予約の取り消しは予約開始前日の午後9時までになります。
    - 計算ノードの空きが無い場合、予約の作成はできません。
    - ハードウェア障害は適宜対応しております。予約開始前日より前の利用不可に対するお問い合わせはご遠慮願います。
    - 予約している計算ノード数変更や予約期間の延長の依頼は対応不可になります。

例) g0001は利用可能、g0002は利用不可
```
[username@es1 ~]$ qrsub -a 20180705 -d 7 -g grpname -n 2 -N "Reserve_for_AI" 
Your advance reservation 12345 has been granted
[username@es1 ~]$ qrstat -ar 12345
(snip)
message                             reserved queue gpu@g0002 is disabled
message                             reserved queue gpu@g0002 is unknown
granted_parallel_environment        perack01
granted_slots_list                  gpu@g0001=80,gpu@g0002=80
```

## 課金 {#accounting}

### On-demandおよびSpotサービス {#on-demand-and-spot-services}

On-demandおよびSpotサービスでは、ジョブ実行開始時にジョブが使用予定のABCIポイントを経過時間制限値を元に計算し、減算処理を実施します。ジョブ実行終了時に実際の経過時間を元にABCIポイントを再計算し、返却処理を実施します。

サービスごとの使用ABCIポイントの計算式は以下の通りです。

> [サービス課金係数](#job-services)  
> &times; [資源タイプ課金係数](#available-resource-types)  
> &times; [POSIX 優先度課金係数](#execution-priority)  
> &times; 資源タイプ個数  
> &times; max(経過時間[秒], 最低経過時間[秒])  
> &div; 3600

!!! note
    - 小数点5位以下は切り捨てられます。
    - 最低経過時間より短い経過時間ジョブを実行した場合、ABCIポイントは最低経過時間を元に計算されます。

### Reservedサービス {#reserved-service_1}

Reservedサービスでは、予約完了時に予約期間を元にABCIポイントを計算し、減算処理を実施します。予約の取り消しをしない限り、返却処理は実施されません。予約にて消費するポイントは、グループの利用責任者の消費ポイントとしてカウントされます。

サービスごとの使用ABCIポイントの計算式は以下の通りです。

> [サービス課金係数](#job-services)  
> &times; 予約ノード数  
> &times; 予約日数  
> &times; 24

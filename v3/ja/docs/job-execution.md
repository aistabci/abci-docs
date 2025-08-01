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

計算リソースを日単位で事前に予約して利用できるサービスです。On-demandおよびSpotサービスの混雑の影響を受けることなく、計画的なジョブ実行が可能となります。また、Spotサービスの経過時間制限以上の予約日数が取れるため、より長時間のジョブ実行が可能です。

Reservedサービスでは、まず事前予約を行って予約ID (Resv ID)を取得し、この予約IDを用いてインタラクティブジョブやバッチジョブの実行を行います。

予約方法は[事前予約](#advance-reservation)を参照してください。インタラクティブジョブやバッチジョブの利用方法、実行オプションはOn-demandおよびSpotサービスと共通です。

## ジョブ実行リソース {#job-execution-resource}

ABCIシステムでは、計算リソースを論理的に分割した資源タイプを利用して、ジョブサービスにシステムリソースを割り当てます。On-demand、Spot、Reservedのいずれのサービスを利用する場合も、利用者は利用したい資源タイプとその数量を指定して、ジョブの投入/実行、計算ノードの予約を行います。

以下では、まず利用可能な資源タイプについて解説し、続いて同時に利用可能な資源量、経過時間およびノード時間積、ジョブ投入数および実行数に関する制限事項等を説明します。

### 利用可能な資源タイプ {#available-resource-types}

ABCIシステムには、次の資源タイプが用意されています。

| 資源タイプ名 | 説明 | 割り当てCPUコア数 | 割り当てGPU数 | メモリ (GB) | ローカルストレージ (TB) |
|:--|:--|:--|:--|:--|:--|
| rt\_HF | ノード占有 | 192 | 8 | 1920 | 14 |
| rt\_HG | ノード共有<br>GPU利用 | 16 | 1 | 160 | 1.4 |
| rt\_HC | ノード共有<br>CPUのみ利用 | 32 | 0 | 320 | 1.4 |

資源毎の利用料金につきましては[ご利用料金](https://abci.ai/ja/how_to_use/tariffs.html)を参照ください。


### 同時に利用可能なノード数 {#number-of-nodes-available-at-the-same-time}

ジョブサービスごとに利用可能な資源タイプとノード数の組み合わせを以下に示します。同時に複数ノードを利用する場合は、資源タイプ`rt_HF`を指定する必要があります。

| サービス名 | 資源タイプ名 | ノード数 |
|:--|:--|--:|
| On-demand  | rt\_HF       | 1-128 |
|   | rt\_HG       | 1 |
|   | rt\_HC       | 1 |
| Spot  | rt\_HF       | 1-128 |
|   | rt\_HG       | 1 |
|   | rt\_HC       | 1 |
| Reserved  | rt\_HF       | 1-予約ノード数 |

### 経過時間およびノード時間積の制限 {#elapsed-time-and-node-time-product-limits}

ジョブサービス、資源タイプに応じて、ジョブの経過時間制限 (実行可能時間の制限) があります。上限値およびデフォルト値を以下に示します。

| サービス名 | 資源タイプ名 | 経過時間制限 (上限値/デフォルト) |
|:--|:--|:--|
| Spot      | rt\_HF, rt\_HG, rt\_HC | 168:00:00/1:00:00 |
| On-demand | rt\_HF, rt\_HG, rt\_HC | 12:00:00/1:00:00 |

また、On-demandおよびSpotサービスで、複数ノードを使用するジョブを実行する場合には、ノード時間積（使用ノード数 &times; 実行時間）に以下の制限があります。

| サービス名 | ノード時間積の最大値 |
|:--|--:|
| Spot                          | 21504 nodes &middot; hours |
| On-demand                                     |    12 nodes &middot; hours |

!!! note
    Reservedサービスでは経過時間に制限はありませんが、予約の終了と共にジョブは強制終了します。
    Reservedサービスに関する制限の詳細については[事前予約](#advance-reservation)を参照してください。

### ジョブ投入数および実行数の制限 {#limitation-on-the-number-of-job-submissions-and-executions}

1ユーザが同時に投入・実行できるジョブ数に以下の制限があります。
予約ノードに投入されたジョブもOn-demandやSpotのジョブと同様にジョブ数のカウントに含まれ、本制約を受けます。

| 制限項目 | 制限値 |
|:--|:--|
| 1ユーザあたりの同時投入可能ジョブ数 | 1000 |
| 1ユーザあたりの同時実行ジョブ数 | 200 |
| 1アレイジョブあたりの最大投入可能タスク数 | 75000 |

2023年度まで資源タイプごとのジョブ実行数に制限はなく、利用可能な計算リソースから順次割り当てていましたが、
2024年度以降、資源タイプごとにシステムあたりの同時実行ジョブ数に制限を設けます。
なお、対象となるジョブサービスはOn-demandサービスとSpotサービスとなります。
Reservedサービスで予約ノードに投入されたジョブはカウントに含まれません。

| 資源タイプ | システムあたりの同時実行ジョブ数の制限値 |
|:--|:--|
| rt_HF | 736 |
| rt_HG | 240 |
| rt_HC | 60 |

## ジョブ実行オプション {#job-execution-options}

インタラクティブジョブ、バッチジョブの実行には`qsub`コマンドを使用します。

`qsub`コマンドに関する、主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -P *group* | ABCI利用グループを*group*で指定します。自分のABCIアカウントが所属しているABCIグループのみ指定できます。本オプションは指定必須です。 |
| -q *resource_type* | 資源タイプ*resource_type*を指定します。本オプションは指定必須です。 |
| -l select=*num*[*:ncpus=num_cpus:mpiprocs=num_mpi:ompthreads=num_omp*] | ノード数を*num*で、MPIプロセス数を*num_mpi*で、スレッド数を*num_omp*で指定します。*ncpus*には`-q`オプションで指定した資源タイプに応じた割り当てCPUコア数が設定され、利用者からは変更できません。本オプションは指定必須です。 |
| -l walltime=[*HH:MM:*]*SS* | 経過時間制限値を指定します。[*HH:MM:*]*SS*で指定することができます。ジョブの実行時間が指定した時間を超過した場合、ジョブは強制終了されます。 |
| -N name | ジョブ名を*name*で指定します。デフォルトは、ジョブスクリプト名です。 |
| -o *stdout_name* | 標準出力名を*stdout_name*で指定します。出力ファイルはジョブ終了後に作成されます。 |
| -e *stderr_name* | 標準エラー出力名を*stderr_name*で指定します。出力ファイルはジョブ終了後に作成されます。 |
| -k oe | 実行中の標準出力、標準エラー出力がストリームで*JOB_NAME*.o*NUM_JOB_ID*に出力されます。ただしこちらのオプションを利用した場合、-oや、-eで指定したファイルに標準出力、また標準エラー出力は出力されません。 |
| -j oe | 標準エラー出力を標準出力にマージします。 |
| -m n | メールの送信を行わないよう指定します。 |
| -m a | バッチシステムによりジョブが中止された場合にメールを送信します。（デフォルト） |
| -m b | ジョブ実行開始時にメールを送信します。 |
| -m e | ジョブ実行終了時にメールを送信します。 |
| -J *start*-*stop*[*:step*] | アレイジョブのインデックス範囲を*start*-*stop*[*:step*]で指定します。*start*は最初のインデックス、*stop*はインデックスの上限です。*step*はステップ係数を表し、指定しない場合は1とみなされます。 |
| -M *mail_address* | 送信先メールアドレスを*mail_address*で指定します。デフォルトはジョブ実行ユーザのABCIに登録されたメールアドレスです。 |

この他、拡張オプションとして以下のオプションが使用可能です。

| オプション | 説明 |
|:--|:--|
| -v RTYPE=resource\_type | 予約ジョブで利用する資源タイプを指定します。本オプションは予約ノードにジョブを投入する場合に必須です。 |
|  -v USE\_SSH=*{0,1,2}* | 資源タイプ"rt_HF"のジョブ実行時に割り当てられた計算ノードへのSSHログインを有効にします。指定がない場合SSHログイン機能は無効です。指定できる値、0(default): SSHログイン機能を無効にします。1: 自身のABCIアカウントのみSSHログインを許可します。2: ジョブ投入時に指定したABCIグループに属するABCIアカウントのSSHログインを許可します。 |

## インタラクティブジョブ {#interactive-jobs}

インタラクティブジョブを実行するには、`qsub`コマンドに`-I`オプションを付け加えます。

```
$ qsub -I -P group -q resource_type -l select=num [options]
```

例) インタラクティブジョブを実行 (On-demandサービス)

```
[username@login1 ~]$ qsub -I -P grpname -q rt_HF -l select=1
[username@hnode001 ~]$ 
```

!!! note
    On-demandサービスでは、インタラクティブジョブ実行時にABCIポイントが不足している場合、ジョブの実行に失敗します。

X Window Systemを利用するアプリケーションを実行するには、MobaXtermなどのXサーバーをサポートするソフトウェアでインタラクティブノードへログインします。
次にインタラクティブジョブを実行する際、引数に`-X`オプションを指定します。

```
[username@login1 ~]$ qsub -IX -P grpname -q rt_HF -l select=1 -l walltime=01:00:00
[username@hnode001 ~]$ xterm <- Xアプリケーションを起動
```

## バッチジョブ {#batch-jobs}

ABCIシステムでバッチジョブを実行する場合、実行するプログラムとは別にジョブスクリプトを作成します。
ジョブスクリプトには利用する資源タイプ名、経過時間制限値などの資源などのジョブ実行オプションを記述した上で、
実行するコマンド列を記載します。

```bash
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

[Environment Modules の初期化]
[Environment Modules の設定]
[プログラムの実行]
```

例) CUDAを利用したプログラムを実行するジョブスクリプト例

```bash
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
./a.out
```

またジョブスクリプト内の各コマンドの標準出力を、ジョブ実行中にファイルに出力するには、リダイレクト`>&`を利用可能です。

例) ジョブ実行中に標準出力をファイルに出力する場合の例

```bash
#!/bin/sh
#PBS -q rt_HF
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P grpname

cd ${PBS_O_WORKDIR}

./a.out >& logfilename
```


### バッチジョブの投入 {#submit-a-batch-job}

バッチジョブを実行するには、`qsub`コマンドを使用します。実行後はジョブIDが出力されます。

```
$ qsub script_name
```

例) ジョブスクリプトrun.shをバッチジョブとして投入 (Spotサービス)

```
[username@login1 ~]$ qsub run.sh
1234.pbs1
```

!!! note
    Spotサービスでは、バッチジョブ投入時にABCIポイントが不足している場合、バッチジョブの投入に失敗します。

### ジョブ投入時のエラー {#job-submission-error}

バッチジョブの投入に成功した場合、`qsub`コマンドの終了ステータスは`0`となります。
失敗した場合は0以外の値となり、エラーメッセージが出力されます。

### バッチジョブの状態の確認 {#show-the-status-of-batch-jobs}

利用者自身が投入したバッチジョブの状態を確認するには、`qstat`コマンドを利用します。

```
$ qstat [options]
```

`qstat`コマンドの主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -f | ジョブに関する詳細情報を表示します。 |
| -a | 利用ノード数などの追加情報を含めて表示します。 |
| -x | 過去10日間に終了したジョブの情報も含めて表示します。 |
| -t | アレイジョブの情報も含めて表示します。 |

例)

```
[username@login1 ~]$ qstat
Job id                 Name             User              Time Use S Queue
---------------------  ---------------- ----------------  -------- - -----
12345.pbs1             run.sh           username          00:01:23 R rt_HF
```

| 項目 | 説明 |
|:--|:--|
| Job id | ジョブID |
| Name | ジョブ名 |
| User | ジョブのオーナー |
| Time Use | ジョブのCPU利用時間 |
| S | ジョブ状態 (R: 実行中, Q: 待機中, F: 完了, S: 一時停止, E: 終了中) |
| Queue | 資源タイプ |


自身が所属するグループを対象としてバッチジョブの状態を確認するには、`qgstat`コマンドを利用します。

```
$ qgstat [options]
```

`qgstat`コマンドの主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -f | ジョブに関する詳細情報を表示します。 |
| -a | 利用ノード数などの追加情報を含めて表示します。 |
| -x | 過去10日間に終了したジョブの情報も含めて表示します。 |
| -t | アレイジョブの情報も含めて表示します。 |

例)

```
[username@login1 ~]$ qgstat
Job id                 Name             User              Time Use S Queue
---------------------  ---------------- ----------------  -------- - -----
12345.pbs1             run01.sh         username01        00:01:23 R rt_HF
23456.pbs1             run02.sh         username02        00:01:23 R rt_HF
```

| 項目 | 説明 |
|:--|:--|
| Job id | ジョブID |
| Name | ジョブ名 |
| User | ジョブのオーナー |
| Time Use | ジョブのCPU利用時間 |
| S | ジョブ状態 (R: 実行中, Q: 待機中, F: 完了, S: 一時停止, E: 終了中) |
| Queue | 資源タイプ |


### バッチジョブの削除 {#delete-a-batch-job}

バッチジョブを削除するには、`qdel`コマンドを利用します。

```
$ qdel job_id
```

例) バッチジョブを削除

```
[username@login1 ~]$ qstat
Job id                 Name             User              Time Use S Queue
---------------------  ---------------- ----------------  -------- - -----
12345.pbs1             run.sh           username          00:01:23 R rt_HF
[username@login1 ~]$ qdel 12345.pbs1
[username@login1 ~]$
```


### バッチジョブの標準出力と標準エラー出力 {#stdout-and-stderr-of-batch-jobs}

バッチジョブの標準出力ファイルと標準エラー出力ファイルは、ジョブ実行ディレクトリもしくは、
ジョブ投入時に指定されたファイルに出力されます。
標準出力ファイルにはジョブ実行中の標準出力、標準エラー出力ファイルにはジョブ実行中のエラーメッセージが出力されます。
ジョブ投入時に、標準出力ファイル、標準エラー出力ファイルを指定しなかった場合は、以下のファイルに出力されます。
また、出力ファイルはジョブ終了後に作成されます。

- *JOB_NAME*.o*NUM_JOB_ID*  ---  標準出力ファイル
- *JOB_NAME*.e*NUM_JOB_ID*  ---  標準エラー出力ファイル

例）ジョブ名がrun.sh、ジョブIDが`12345.pbs1`の場合

- 標準出力ファイル名：run.sh.o12345
- 標準エラー出力ファイル名：run.sh.e12345


## 環境変数 {#environment-variables}

ジョブ実行中に、ジョブスクリプトもしくはコマンドラインで利用できる環境変数は以下の通りです。

| 環境変数 | 説明 |
|:--|:--|
| PBS\_ENVIRONMENT | バッチジョブの場合"PBS\_BATCH"が、インタラクティブジョブの場合"PBS\_INTERACTIVE"が割り当てられる |
| PBS\_JOBID | ジョブID |
| PBS\_JOBNAME | ジョブ名 |
| PBS\_NODEFILE | ジョブに割り当てられたホストが記載されたファイルへのパス |
| PBS\_LOCALDIR | ジョブに割り当てられたローカルストレージへのパス |
| PBS\_O\_WORKDIR | ジョブ投入時の作業ディレクトリへのパス |
| PBS\_ARRAY\_INDEX | アレイジョブのインデックス番号 |

!!! warning
    上記の環境変数については、ジョブスケジューラで予約された変数であり、ジョブスケジューラの動作に影響を与える可能性があるためジョブの中で変更しないようにしてください。

## 事前予約 {#advance-reservation}

Reservedサービスでは、計算ノードを事前に予約して計画的なジョブ実行が可能となります。

本サービスで予約可能なノード数およびノード時間積は、以下表の「1予約あたりの最大予約ノード数」、「1予約あたりの最大予約ノード時間積」が上限です。また、本サービスでは、利用者は予約ノード数を上限とするジョブしか実行できません。なお、システム全体で「システムあたりの最大同時予約可能ノード数」に上限があるため、「1予約あたりの最大予約ノード数」を下回る予約しかできない場合や、予約自体ができない場合があります。予約した計算ノードにて[各資源タイプ](#available-resource-types)が利用可能です。

| 項目 | 設定値 |
|:--|:--|
| 最小予約日数 | 1日 |
| 最大予約日数 | 60日 |
| ABCIグループあたりの最大同時予約可能ノード数 | 32ノード |
| システムあたりの最大同時予約可能ノード数 | 640ノード |
| 1予約あたりの最小予約ノード数 | 1ノード |
| 1予約あたりの最大予約ノード数 | 32ノード |
| 1予約あたりの最大予約ノード時間積 | 10,752ノード時間積 |

### 予約の実行 {#make-a-reservation}

計算ノードを予約するには、`qrsub`コマンドを使用します。
予約が完了すると、予約IDが発行されますので、予約した計算ノードを使用する際にこの予約IDを指定してください。

!!! warning
    計算ノードの予約は、利用責任者もしくは利用管理者のみが実施できます。

```
$ qrsub options
```

| オプション | 説明 |
|:--|:--|
| -R *YYMMDD* | 予約開始日を*YYMMDD*で指定します。 |
| -D *days* | 予約日数を*days*で指定します。|
| -P *group* | ABCI利用グループを*group*で指定します。 |
| -N *name* | 予約名を*name*で指定します。スペース以外の英数字と記号`+-_.`が指定可能で、最大230文字まで指定できます。 |
| -n *numnodes* | 予約するノード数を*numnodes*で指定します。 |

例) 2025年1月15日から1週間 (7日間) 計算ノード(H)4台を予約

```
[username@login1 ~]$ qrsub -R 250115 -D 7 -P grpname -n 4 -N "Reserve_for_AI"
R1234.pbs1 UNCONFIRMED
```

計算ノードの予約が完了した時点でABCIポイントを消費します。
また、発行された予約IDは予約時に指定したABCIグループに所属するABCIアカウントでご利用いただけます。

!!! note
    予約可能なノード数が`qrsub`コマンドで指定したノード数より少ない場合、エラーメッセージを出力して予約取得に失敗します。  

### 予約状態の確認 {#show-the-status-of-reservations}

予約状態を確認するには、`qrstat`コマンドを使用します。

```
$ qrstat [options]
```

`qrstat`コマンドの主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -f, -F | 詳細な予約情報を表示します。 |

例)

```
[username@login1 ~]$ qrstat
Resv ID         Queue         User     State             Start / Duration / End
-------------------------------------------------------------------------------
R1234.pbs1      R1234         usrname  RN            Wed 10:40 / 1506000 / Sat Feb 01 21:00
```

| 項目 | 説明 |
|:--|:--|
| Resv ID | 予約ID (Resv ID) |
| Queue | キュー名 |
| User | 実行ユーザ |
| State | 予約状態 (CO: 予約確定, RN: 予約実行中) |
| Start | 予約開始日 (予約開始時刻は常に午前10時) |
| Duration | 予約期間 (秒) |
| End | 予約終了日 (予約終了時刻は常に午前9時30分) |

グループあたりの予約可能ノード数を確認するには、`qrstat`コマンドの`--available=grpname`オプションに所属グループ名を指定し、実行します。こちらのオプションは全ユーザが利用可能です。

例)予約可能ノード数の確認
```
[username@login1 ~]$ qrstat --available=grpname
date       available nodes for group
---------- -------------------------
01/30/2025                       32
01/31/2025                       32
```

### 予約の取り消し {#cancel-a-reservation}

!!! warning
    予約の取り消しは利用責任者もしくは利用管理者のみが実施できます。

予約を取り消すには、`qrdel`コマンドを使用します。指定したResv IDが存在しない場合、もしくは削除権限のない予約IDが指定されている場合は、エラーとなり削除は実行されません。

例) 予約を取り消し

```
[username@login1 ~]$ qrdel R1234.pbs1
```

### 予約ノードの使い方 {#how-to-use-reserved-node}

予約した計算ノードにジョブを投入するには、`qsub`コマンドの`-q`オプションに予約キューを指定します。
予約キューは予約IDのドット(`.`)より前の文字列、または`qrstat`コマンドの`Queue`欄から確認できます。

さらに、予約ノードで利用する資源タイプをqsubコマンドの`-v RTYPE=resource_type`オプションで指定してください。

例) 予約ID`R1234.pbs1`で予約された計算ノードで`rt_HG`のインタラクティブジョブを実行

```
[username@login1 ~]$ qsub -I -P grpname -q R1234 -v RTYPE=rt_HG -l select=1
[username@hnode001 ~]$ 
```

例) ジョブスクリプトrun.shを予約ID`R1234.pbs1`で予約された計算ノードに`rt_HG`のバッチジョブとして投入

```
[username@login1 ~]$ qsub -P grpname -q R1234 -v RTYPE=rt_HG -l select=1 run.sh
9290.pbs1
```

!!! note  
    - 予約作成時に指定したABCIグループを指定する必要があります。
    - バッチジョブは予約作成直後から投入できますが、予約開始時刻になるまで実行されません。  
    - 予約開始時刻前に投入したバッチジョブは`qdel`コマンドで削除できます。  
    - 予約開始時刻前に予約を削除した場合、当該予約に投入されていたバッチジョブは削除されます。  
    - 予約終了時刻になると実行中のジョブは強制終了されます。  

### 予約ノードご利用時の注意 {#cautions-for-using-reserved-node}

予約は期間中の計算ノードの可用性を保証するものではありません。予約した計算ノードの利用中に一部が利用不可となることがありますので、以下の点をご確認ください。

* 予約した計算ノードの利用可否状態は、`qrstat -f Resv ID` コマンドで確認できます。
* 予約開始前日に一部の予約ノードが利用不可と表示される場合は、予約の取り消し・再度予約をご検討ください。
* 予約期間中に計算ノードが利用不可となった場合などの時は、[お問い合わせ](./contact.md)のページをご覧の上、<abci3-qa@abci.ai> までご連絡ください。

!!! note
    - 予約の取り消しは予約開始前日の午後9時までになります。
    - 計算ノードの空きが無い場合、予約の作成はできません。
    - ハードウェア障害は適宜対応しております。予約開始前日より前の利用不可に対するお問い合わせはご遠慮願います。
    - 予約している計算ノード数変更や予約期間の延長の依頼は対応不可になります。

例) 予約ID`R1234.pbs1`により予約されたノードを確認する。
```
[username@login1 ~]$ qrsub -R 250115 -D 7 -P grpname -n 3 -N "Reserve_for_AI"
R1234.pbs1 UNCONFIRMED
[username@login1 ~]$ qrstat -f R1234.pbs1
(skip)
resv_nodes = (hnode015[0]:ncpus=96+hnode015[1]:ncpus=96)+(hnode021[0]:ncpus=96+hnode021[1]:ncpus=96)+(hnode022[0]:ncpus=96+hnode022[1]:ncpus=96)
Authorized_Users = username@login2
Authorized_Groups = groupname
```

## 課金 {#accounting}

### On-demandおよびSpotサービス {#on-demand-and-spot-services}

On-demandおよびSpotサービスでは、ジョブ実行開始時にジョブが使用予定のABCIポイントを経過時間制限値を元に計算し、減算処理を実施します。ジョブ実行終了時に実際の経過時間を元にABCIポイントを再計算し、返却処理を実施します。

On-demandおよびSpotサービスの課金については、[ご利用料金](https://abci.ai/ja/how_to_use/tariffs.html)を参照ください。

!!! note
    - 小数点5位以下は切り捨てられます。
    - 最低経過時間（1.8秒）より短い経過時間ジョブを実行した場合、ABCIポイントは最低経過時間を元に計算されます。

### Reservedサービス {#reserved-service_1}

Reservedサービスでは、予約完了時に予約期間を元にABCIポイントを計算し、減算処理を実施します。予約の取り消しをしない限り、返却処理は実施されません。予約にて消費するポイントは、グループの利用責任者の消費ポイントとしてカウントされます。

課金情報については、[ご利用料金](https://abci.ai/ja/how_to_use/tariffs.html)を参照ください。

!!! note
    計算ノード(H)の予約は資源タイプrt_HFとして扱われます。

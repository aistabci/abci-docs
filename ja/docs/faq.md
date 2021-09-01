# FAQ

## Q. インタラクティブ利用時にCtrl+Sを入力するとそれ以降のキー入力ができない

macOS、Windows、Linuxなどの標準のターミナルエミュレータでは、デフォルトでCtrl+S/Ctrl+Qによる出力制御が有効になっているためです。無効にするためには、ローカルPCのターミナルエミュレータで以下を実行してください。

```shell
$ stty -ixon
```

インタラクティブノードにログインした状態で実行しても同等の効果があります。

## Q. グループ領域が実サイズ以上に消費されてしまう

一般にファイルシステムにはブロックサイズがあり、どんなに小さいファイルであってもブロックサイズ分の容量を消費します。

ABCIでは、グループ領域1〜3のブロックサイズは128KB、ホーム領域、グループ領域のブロックサイズは4KBとしています。このため、グループ領域1〜3に小さいファイルを大量に作ると利用効率が下がります。例えば、4KB未満のファイルを作る場合には、ホーム領域の約32倍の容量が必要になります。

## Q. 認証が必要なコンテナレジストリをSingularityで利用できない

SingularityPROには``docker login``相当の機能として、環境変数で認証情報を与える機能があります。

```shell
[username@es1 ~]$ export SINGULARITY_DOCKER_USERNAME='username'
[username@es1 ~]$ export SINGULARITY_DOCKER_PASSWORD='password'
[username@es1 ~]$ singularity pull docker://myregistry.azurecr.io/namespace/repo_name:repo_tag
```

SingularityPRO の認証に関する詳細は、以下をご参照ください。

* [SingularityPRO 3.7 User Guide](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/)
    * [Making use of private images from Private Registries](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/singularity_and_docker.html?highlight=support%20docker%20oci#making-use-of-private-images-from-private-registries)

## Q. NGC CLIが実行できない

ABCI上で、[NGC Catalog CLI](https://docs.nvidia.com/ngc/ngc-catalog-cli-user-guide/index.html)を実行すると、以下のエラーメッセージが出て実行できません。これはNGC CLIがUbuntu 14.04以降用にビルドされているためです。

```
ImportError: /lib64/libc.so.6: version `GLIBC_2.18' not found (required by /tmp/_MEIxvHq8h/libstdc++.so.6)
[89261] Failed to execute script ngc
```

以下のようなシェルスクリプトを用意することで、Singularityを使って実行させることができます。NGC CLIに限らず、一般的に使えるテクニックです。

```
#!/bin/sh
source /etc/profile.d/modules.sh
module load singularitypro

NGC_HOME=$HOME/ngc
singularity exec $NGC_HOME/ubuntu-18.04.simg $NGC_HOME/ngc $@
```

## Q. 複数の計算ノードを割り当て、それぞれの計算ノードで異なる処理をさせたい

`qrsh`や`qsub`で`-l rt_F=N`オプションもしくは`-l rt_AF=N`オプションを与えると、N個の計算ノードを割り当てることができます。割り当てられた計算ノードでそれぞれ異なる処理をさせたい場合にもMPIが使えます。

```
$ module load openmpi/2.1.6
$ mpirun -hostfile $SGE_JOB_HOSTLIST -np 1 command1 : -np 1 command2 : ... : -np1 commandN
```

## Q. SSHのセッションが閉じられてしまうのを回避したい

SSHでABCIに無事接続したしばらく後に、SSHのセッションが閉じられてしまうことがあります。このような場合は、SSHクライアントとサーバ間でKeepAliveの通信をすることで回避できる場合があります。

KeepAliveを適用するには、利用者の端末でシステムのssh設定ファイル(/etc/ssh/ssh_config)、またはユーザ毎の設定ファイル(~/.ssh/config)に、オプション ServerAliveInterval を60秒程度で設定してください。

```
[username@userpc ~]$ vi ~/.ssh/config
[username@userpc ~]$ cat ~/.ssh/config
(snip)
Host as.abci.ai
   ServerAliveInterval 60
(snip)
[username@userpc ~]$
```

!!! note
    ServerAliveInterval の初期値は 0 (KeepAliveなし)です。

## Q. Open MPIの新しいバージョンが使いたい

ABCIではCUDA対応版Open MPIとCUDA非対応版Open MPIを提供しており、提供の状況は、[Open MPI](mpi.md#open-mpi)で確認できます。

ABCIが提供するEnvironment Modulesでは、事前に`cuda`モジュールがロードされている場合に限り、`openmpi`モジュールのロード時にCUDA対応版Open MPIの環境設定を試みます。

したがって、CUDA対応版MPIが提供されている組み合わせ(`cuda/10.0/10.0.130.1`, `openmpi/2.1.6`)では環境設定に成功します。

```
$ module load cuda/10.0/10.0.130.1
$ module load openmpi/2.1.6
$ module list
Currently Loaded Modulefiles:
  1) cuda/10.0/10.0.130.1   2) openmpi/2.1.6
```

CUDA対応版MPIが提供されていない組み合わせ(`cuda/9.1/9.1.85.3`, `openmpi/3.1.6`)では環境設定に失敗し、`openmpi`モジュールはロードされません。

```
$ module load cuda/9.1/9.1.85.3
$ module load openmpi/3.1.6
ERROR: loaded cuda module is not supported.
WARNING: openmpi/3.1.6 cannot be loaded due to missing prereq.
HINT: at least one of the following modules must be loaded first: cuda/9.2/9.2.88.1 cuda/9.2/9.2.148.1 cuda/10.0/10.0.130.1 cuda/10.1/10.1.243 cuda/10.2/10.2.89 cuda/11.0/11.0.3 cuda/11.1/11.1.1 cuda/11.2/11.2.2
$ module list
Currently Loaded Modulefiles:
  1) cuda/9.1/9.1.85.3
```

一方、Horovodによる並列化のためにOpen MPIが使いたいなど、Open MPIのCUDA版機能が不要な場合もあります。この場合は、先に`openmpi`モジュールをロードすることで、より新しいバージョンのCUDA非対応版Open MPIを利用できます。

```
$ module load openmpi/3.1.6
$ module load cuda/9.1/9.1.85.3
module list
Currently Loaded Modulefiles:
  1) openmpi/3.1.6       2) cuda/9.1/9.1.85.3
```

!!! note
    CUDA対応版の機能はOpen MPIのサイトで確認できます: [FAQ: Running CUDA-aware Open MPI](https://www.open-mpi.org/faq/?category=runcuda)

## Q. ジョブの混雑状況を知りたい

ジョブの混雑状況に加え、計算ノードの利用状況、データセンター全体の消費電力やPUE、冷却設備の稼働状況等を可視化するWebサービスを動作させています。
ABCI内部サーバ`vws1`の3000/tcpポートで動作していますので、以下の通りにアクセスできます。

SSHトンネルの設定をしてください。
以下の例では、ローカルPCの`$HOME/.ssh/config`に、ProxyCommandを用いてas.abci.ai経由でABCI内部サーバにSSHトンネル接続する設定をしています。
ABCIシステム利用環境の[SSHクライアントによるログイン::一般的なログイン方法](getting-started.md#general-method)も参考にしてください。

```shell
Host *.abci.local
    User         username
    IdentityFile /path/identity_file
    ProxyCommand ssh -W %h:%p -l username -i /path/identity_file as.abci.ai
```

ローカルPCの3000番ポートをvws1サーバの3000/tcpポートに転送するSSHトンネルを作成します。

```shell
[username@userpc ~]$ ssh -L 3000:vws1:3000 es.abci.local
```

ブラウザで`http://localhost:3000/`にアクセスします。

!!! note
    ABCI User Groupでは、インタラクティブノード上で混雑状況を確認する方法が紹介されていますので、こちらもご参照ください。

    - [ABCIの混雑具合を確認する](https://abciug.abci.ai/abci%e5%88%a9%e7%94%a8%e3%81%ae%e8%b1%86%e7%9f%a5%e8%ad%98/abci%e3%81%ae%e6%b7%b7%e9%9b%91%e5%85%b7%e5%90%88%e3%82%92%e7%a2%ba%e8%aa%8d%e3%81%99%e3%82%8b_i6)
    - [ABCIの混雑具合を確認する（その２）](https://abciug.abci.ai/abci%e5%88%a9%e7%94%a8%e3%81%ae%e8%b1%86%e7%9f%a5%e8%ad%98/abci%e3%81%ae%e6%b7%b7%e9%9b%91%e5%85%b7%e5%90%88%e3%82%92%e7%a2%ba%e8%aa%8d%e3%81%99%e3%82%8b%e3%81%9d%e3%81%ae%ef%bc%92_i10)
    - [ABCIの空ノード数を調べる](https://abciug.abci.ai/abci%e5%88%a9%e7%94%a8%e3%81%ae%e8%b1%86%e7%9f%a5%e8%ad%98/abci%e3%81%ae%e7%a9%ba%e3%83%8e%e3%83%bc%e3%83%89%e6%95%b0%e3%82%92%e8%aa%bf%e3%81%b9%e3%82%8b_i16)

## Q. ダウンロード済みのデータセットはありませんか?

[データセットの利用](tips/datasets.md)を参照してください。

## Q. バッチジョブでSingularity pullでのイメージファイル作成に失敗する

バッチジョブでSingularity pullでのイメージファイルを作成しようとした際に、mksquashfs の実行ファイルが見つからず作成に失敗することがあります。

```
INFO:    Converting OCI blobs to SIF format
FATAL:   While making image from oci registry: while building SIF from layers: unable to create new build: while searching for mksquashfs: exec: "mksquashfs": executable file not found in $PATH
```

これは、以下のように、`/usr/sbin` にパスを通すことで回避できます。 

実行例）
```
[username@g0001 ~]$ export PATH="$PATH:/usr/sbin"
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv docker://caffe2ai/caffe2:latest
```

## Q. 計算ノードでsingularity build/pullすると容量不足でエラーになる {#q-insufficient-disk-space-for-singularity-build}

singularity build/pull コマンドは一時ファイルの作成場所として `/tmp` を使用します。
大きなコンテナを計算ノード上でsingularity build/pullする際に `/tmp` の容量が足りずエラーになる場合があります。
容量が足りずエラーになる場合は、次のようにローカルスクラッチを使用するよう`SINGULARITY_TMPDIR`環境変数を設定してください。

```
[username@g0001 ~]$ SINGULARITY_TMPDIR=$SGE_LOCALDIR singularity pull docker://nvcr.io/nvidia/tensorflow:20.12-tf1-py3
```

## Q. ジョブ ID を調べるには？ {#q-how-can-i-find-the-job-id}

`qsub` コマンドを使ってバッチジョブを投入した場合は、コマンドがジョブ ID を出力しています。

```
[username@es1 ~]$ qsub -g grpname test.sh
Your job 1000001 ("test.sh") has been submitted
```

`qrsh` を使っている場合は、環境変数 JOB_ID の値を見ることで確認できます。この変数は、qsub (バッチジョブ) の場合でも利用可能です。

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ echo $JOB_ID
1000002
[username@g0001 ~]$
```

すでに投入済みのジョブに付与されているジョブ ID を確認するには、`qstat` コマンドを使ってください。

```
[username@es1 ~]$ qstat
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
   1000003 0.00000 test.sh username   qw    08/01/2020 13:05:30
```

対象のジョブがすでに完了している場合は、`qacct -j` を使ってジョブ ID を調べます。`-b` や `-e` オプションが、対象範囲を限定するために役に立ちます。qacct(1) man ページ (インタラクティブノードで `man qacct`) で使い方を確認できます。下記の例は、完了したジョブのうち、2020年 9月 1日 以降に開始されていたものを出力しています。`jobnumber` がジョブ ID です。

```
[username@es1 ~]$ qacct -j -b 202009010000
==============================================================
qname        gpu
hostname     g0001
group        grpname
owner        username

:

jobname      QRLOGIN
jobnumber    1000010

:

qsub_time    09/01/2020 16:41:37.736
start_time   09/01/2020 16:41:47.094
end_time     09/01/2020 16:45:46.296

:

==============================================================
qname        gpu
hostname     g0001
group        grpname
owner        username

:

jobname      testjob
jobnumber    1000120

:

qsub_time    09/07/2020 15:35:04.088
start_time   09/07/2020 15:43:11.513
end_time     09/07/2020 15:50:11.534

:
```

## Q. 割り当てられた全計算ノードでコマンドを並列に実行したい

ABCIでは、割り当てられた全計算ノードで並列にLinuxコマンドを実行する`ugedsh`コマンドを用意しています。
`ugedsh`コマンドの引数で指定したコマンドは、各ノードで1回ずつ実行されます。

実行例) 

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=2
[username@g0001 ~]$ ugedsh hostname
g0001: g0001.abci.local
g0002: g0002.abci.local
```

## Q. 計算ノード(A)と計算ノード(V)の違いが知りたい {#q-what-is-the-difference-between-compute-node-a-and-compute-node-v}

ABCIは、2021年5月にABCI 2.0にアップグレードされました。
従来より提供していたNVIDIA V100搭載の計算ノード(V)に加えて、NVIDIA A100を搭載した計算ノード(A)が利用できるようになりました。

ここでは計算ノード(A)と計算ノード(V)の違い、および、計算ノード(A)を利用する際の注意点などを説明します。

### 資源タイプ名 {#resource-type-name}

計算ノード(A)と計算ノード(V)では資源タイプ名が異なります。計算ノード(A)は、以下の資源タイプ名を指定することで利用できます。

| 資源タイプ | 資源タイプ名 | 割り当て物理CPUコア数 | 割り当てGPU数 | メモリ(GiB) |
|:--|:--|:--|:--|:--|
| Full     | rt\_AF       | 72 | 8 | 480 |
| AG.small | rt\_AG.small | 9  | 1 | 60  |

より詳しい資源タイプについては、[利用可能な資源タイプ](job-execution.md#available-resource-types)を参照してください。

### 課金 {#accounting}

[利用可能な資源タイプ](job-execution.md#available-resource-types)に示す通り、計算ノード(A)と計算ノード(V)では資源タイプ課金係数が異なります。このため、[課金](job-execution.md#accounting)に基づいて算出される、使用ABCIポイント数も異なります。

計算ノード(A)利用時の使用ABCIポイント数は、以下の通りとなります。

| [資源タイプ名](job-execution.md#available-resource-types)<br>[実行優先度](job-execution.md#execution-priority) | On-demandおよびSpotサービス<br>実行優先度: -500(既定)<br>(ポイント/時間) | On-demandおよびSpotサービス<br>実行優先度: -400<br>(ポイント/時間) | Reservedサービス<br>(ポイント/日) |
|:--|:--|:--|:--|
| rt\_AF       | 3.0 | 4.5  | 108 |
| rt\_AG.small | 0.5 | 0.75 | NA  |

### Operating System

計算ノード(A)と計算ノード(V)では、使用しているOSが異なります。

| 項目 | OS |
|:--|:--|
| 計算ノード(A) | Red Hat Enterprise Linux 8.2 |
| 計算ノード(V) | CentOS Linux 7.5 |

カーネルやglibcなどライブラリのバージョンも異なるため、計算ノード(V)向けにビルドしたプログラムをそのまま計算ノード(A)上で動かしても動作は保証されません。

計算ノード(A)向けのプログラムは、計算ノード(A)や後述するインタラクティブノード(A)を使用してビルドしてください。

### CUDA Version

計算ノード(A)に搭載されているNVIDIA A100はCompute Capability 8.0に準拠しています。

CUDA 10以前ではCompute Capability 8.0をサポートしていません。そのため、計算ノード(A)では、Compute Capability 8.0をサポートするCUDA 11以降を使用してください。

!!! note
    [Environment Modules](environment-modules.md)では、試験用にCUDA 10も利用可能としていますが、動作を保証するものではありません。

### インタラクティブノード(A) {#interactive-node-a}

ABCIでは、計算ノード(A)向けのプログラム開発の利便性のため、インタラクティブノード(A)を提供しています。
インタラクティブノード(A)は、計算ノード(A)と同様のソフトウェア構成を有しています。
インタクティブノード(A)でビルドしたプログラムは、計算ノード(V)での動作を保証しません。

インタラクティブノードの使い分けについては以下を参照してください。

| | インタラクティブノード(V) | インタラクティブノード(A) |
|:--|:--|:--|
| 利用者がログインできるか? | Yes | Yes |
| 計算ノード(V)向けのプログラム開発が可能か? | Yes | No |
| 計算ノード(A)向けのプログラム開発が可能か? | No | Yes |
| 計算ノード(V)向けのジョブ投入が可能か? | Yes | Yes |
| 計算ノード(A)向けのジョブ投入が可能か? | Yes | Yes |
| グループ領域の旧領域にアクセス可能か? | Yes | Yes |

インタラクティブノード(A)の詳細は、[インタラクティブノード](system-overview.md#interactive-node)を参照してください。

### グループ領域 {#group-area}

計算ノード(A)からは**旧領域**(`/groups[1-2]/gAA50NNN`)にアクセスできません。

**旧領域**にあるファイルを計算ノード(A)で利用する場合は、事前に利用者がファイルをホーム領域や**新領域**(`/groups/gAA50NNN`)にコピーしておく必要があります。**旧領域**にあるファイルをコピーする場合は、インタラクティブノードおよび計算ノード(V)を利用してください。

なお、2021年4月より**旧領域**のファイルを**新領域**へ移行する作業も進めています。グループ領域のデータ移行については、FAQの[グループ領域のデータ移行について知りたい](faq.md#q-what-are-the-new-group-area-and-data-migration)を参照してください。

## Q. ABCI 1.0 Environment Modulesを利用したい {#q-how-to-use-abci-10-environment-modules}

ABCIは、2021年5月にABCI 2.0にアップグレードされました。
このアップグレードにともない、2020年度時点のEnvironment Modules(以下、**ABCI 1.0 Environment Modules**)を`/apps/modules-abci-1.0`としてインストールしました。
ABCI 1.0 Environment Modulesを利用したい場合は、以下のように`MODULE_HOME`環境変数を設定し、設定ファイルを読み込んでください。

なお、ABCI 1.0 Environment Modulesはサポート対象外です。あらかじめご了承ください。

sh, bashの場合:

```
export MODULE_HOME=/apps/modules-abci-1.0
. ${MODULE_HOME}/etc/profile.d/modules.sh
```

csh, tcshの場合:

```
setenv MODULE_HOME /apps/modules-abci-1.0
source ${MODULE_HOME}/etc/profile.d/modules.csh
```

## Q. グループ領域のデータ移行について知りたい {#q-what-are-the-new-group-area-and-data-migration}

2021年度に、ストレージシステムの増強を行いました。詳細は[ストレージシステム](https://docs.abci.ai/ja/01/#storage-systems)を参照ください。
ストレージシステムの増強にともない、グループ領域の構成変更を行います。具体的には、2020年度まで使用していたグループ領域から新しいグループ領域へのデータ移行を行います。

2020年度まで使用していたグループ領域(以下、**旧領域**)は、2021年5月に新規導入された計算資源(計算ノード(A))からアクセスできません。
このため、新たに計算ノード(A)からアクセス可能なグループ領域(以下、**新領域**)を作成し、そちらへの移行を行います。
データの移行は運用側で行いますので、利用者が作業をする必要はありません。

2020年度まで**旧領域**`/groups[1-2]/gAA50NNN/`を利用していたグループには、4月から新しく**新領域**`/groups/gAA50NNN/`を割り当てています。
また、**旧領域**`/fs3/`を利用していた一部のグループには、2021年7月中旬から**新領域**`/projects/`を割り当てています。
**旧領域**、**新領域**ともにすべてのインタラクティブノードと計算ノード(V)からアクセスできます。

なお、2021年度に新規に作成されたABCIグループについては、**新領域**のみが割り当てられるためデータ移行の対象ではなく、データ移行の影響を受けません。

次にデータ移行について説明します。

### 基本的な方針

* **旧領域**のデータを**新領域**に運用側がバックグラウンドでコピーします。全利用者データのコピー完了は2021年度末の予定です。
* コピー完了後、シンボリックリンクの切り替えによって**旧領域**への参照を**新領域**への参照に書き換えます。
* **旧領域**のデータは下記の移行先ディレクトリにコピーされます。

	| 移行元                | 移行先                                                       | 備考             |
	|:--                    |:--                                                           |:--               |
	| `/groups1/gAA50NNN/`  | `/groups/gAA50NNN/migrated_from_SFA_GPFS/`                   |                  |
	| `/groups2/gAA50NNN/`  | `/groups/gAA50NNN/migrated_from_SFA_GPFS/`                   | 移行作業完了     |
	| `/fs3/d001/gAA50NNN/` | `/projects/d001/gAA50NNN/migrated_from_SFA_GPFS/`            |                  |
	| `/groups1/gAA50NNN/`  | `/projects/datarepository/gAA50NNN/migrated_from_SFA_GPFS/`  | d002 利用者 [^1] |
	| `/fs3/d002/gAA50NNN/` | `/projects/datarepository/gAA50NNN/migrated_from_SFA_GPFS3/` | [^1]             |
[^1]: /fs3/d002 利用者は移行元が複数あるため移行先のディレクトリが migrated_from_SFA_GPFS/ と migrated_from_SFA_GPFS3/ に別れています。

* コピー完了後、利用者へ移行が完了した旨をメールでお知らせします。

データ移行に用いるコマンドは以下の通りです。

```
# rsync -avH /{Old Area}/gAA50NNN/  /{New Area}/gAA50NNN/migrated_from_SFA_GPFS/
```

データ移行後に確認のため以下のコマンドを実行します。

```
# rsync -avH --delete /{Old Area}/gAA50NNN/  /{New Area}/gAA50NNN/migrated_from_SFA_GPFS/
```

### 新領域について

* データ移行完了までは利用者が**新領域**内の上記移行先ディレクトリにアクセスすることはできません。
* 移行先のディレクトリ以外の**新領域**は自由に使用することができます。
* データコピーにともないディスク使用量が増加します。このため、移行期間中は、利用者ポータルで申請したグループディスク量(以下、クォータ値)の2倍の値を、**新領域**のディスク使用量上限値に設定します。移行完了後、一定の猶予期間を設けて、**新領域**のディスク使用量上限値を、クォータ値と同じ値に設定します。


### 旧領域/groups[1-2]/gAA50NNNおよび/fs3/d00[1-2]/gAA50NNNについて

* 2021年8月11日以降、**旧領域**を読み取り専用に変更しました。データの保存には**新領域**を利用してください。
* データ移行完了後、**旧領域**上の`/groups[1-2]/gAA50NNN`および`/fs3/d00[1-2]/gAA50NNN/`にはアクセスできなくなります。
* これらのパスは、それぞれの**旧領域**内の全データが移行完了後、**新領域**内の移行先ディレクトリへのシンボリックリンクに置き換えられ、従来と同じパスでアクセス可能になります。


## Q. クォータ値とディスク使用量上限値の関係が知りたい {#q-about-the-quota-value-and-the-limit-of-the-storage-usage}

### データ移行中

データ移行前は、クォータ値（利用者ポータルで申請したグループディスク量)とディスク使用量上限値(show_quotaコマンドで「limit」と表示される値)は同一に設定されていましたが、データ移行開始後に変更しました。
2021年6月27日まではクォータ値を**旧領域**のディスク使用量上限値として設定し、クォータ値の2倍の値を**新領域**のディスク使用量上限値として設定していました。
2021年6月28日以降、クォータ値の変更申請と**旧領域**のディスク使用量上限値の関係を以下のとおり変更しました。

#### クォータ値の増量申請

* クォータ値の増量を申請しても、**旧領域**のディスク使用量上限値は増えません。
* **新領域**(/groups/gAA50NNN)のディスク使用量上限値は、「それまでに設定されていた値」と「新しいグループディスク量の2倍」のいずれか多い方に設定されます。

#### クォータ値の減量申請

* クォータ値の減量を申請した場合は、**旧領域**の利用量(show_quotaコマンドで「used」と表示される値)が新しいクォータ値より少ない場合のみ減量できます。
* クォータ値の減量申請が受理された後、**旧領域**のディスク使用量上限値はクォータ値と同じ値に設定されます。
* **新領域**のディスク使用量上限値は減りません。

グループディスクの利用で消費するABCIポイントは従来同様、クォータ値（利用者ポータルで申請したグループディスク量）をもとに計算されます。

### データ移行完了後

データ移行期間中は、クォータ値（利用者ポータルで申請したグループディスク量）の2倍（またはそれ以上の）値を、**新領域**のディスク使用量上限値に設定していました。
**データ移行完了後、一定の猶予期間を設けて、新領域のディスク使用量上限値を、クォータ値と同じ値に戻します。**

猶予期間は以下の通りです。猶予期間を過ぎた後、クォータ値を超えるデータが**新領域**に保存されている場合、書き込みができなくなります。
不要なファイルを削除するか、[ABCI利用者ポータル](https://portal.abci.ai/user/)から「利用グループ管理」の一覧画面を開き、「グループディスクの追加申請」を行ってください。

| グループ領域         | 猶予期間          |
| --                   | --                |
| `/groups1/gAA50NNN/` | 移行完了後に設定  |
| `/groups2/gAA50NNN/` | 2021年9月30日まで |
| `/fs3`               | 移行完了後に設定  |


## Q. グループ領域のデータ移行状況が知りたい

2021年度のストレージシステムの増強にともない、2020年度まで使用していたグループ領域から新しいグループ領域へのデータ移行を行っています。
2021年8月現在、グループ領域の移行状況は以下の通りです。

| グループ領域         | 状況               |
| --                   | --                 |
| `/groups1/gAA50NNN/` | 移行中             |
| `/groups2/gAA50NNN/` | 2021年7月1日に完了 |
| `/fs3`               | 2021年10月開始予定 |


## Q. 旧領域にデータが書き込めません

2020年度まで使用していたグループ領域(**旧領域**)の`/groups1`、`/fs3`は、データ移行の効率化を図るため、2021年8月11日に**読み取り専用**に変更しました。
データの書き込みを行いたい場合は、新しいグループ領域(**新領域**)の`/groups`、`/projects`を利用してください。

なお、旧領域の`/groups2`についてはデータ移行が完了し、現在は**新領域**へのシンボリックリンクが設定されています。そのため、従来通りのパスで書き込みができるようになっています。

データ移行については、 FAQの[グループ領域のデータ移行について知りたい](faq.md#q-what-are-the-new-group-area-and-data-migration)を参照してください。


## Q. データ移行中のグループ領域のアクセス権限が知りたい {#q-about-access-rights-for-each-directory-in-the-group-area}

データ移行中のグループ領域のアクセス権限は以下の通りです。

| ディレクトリ                                                 | 読み取り | 書き込み | 削除    | 説明                            |
|:--                                                           |:--       |:--       |:--      |:--                              |
| `/groups/gAA50NNN/`                                          | Yes[^2]  | Yes[^2]  | Yes[^2] | 新領域                          |
| `/groups1/gAA50NNN/`                                         | Yes      | No       | No      | 旧領域                          |
| `/groups2/gAA50NNN/`                                         | Yes      | Yes      | Yes     | `/groups/gAA50NNN/migrated_from_SFA_GPFS/`への参照 |
| `/fs3/d00[1-2]/gAA50NNN/`                                    | Yes      | No       | No      | 旧領域                          |
| `/projects/d001/gAA50NNN/`                                   | Yes[^2]  | Yes[^2]  | Yes[^2] | d001利用者向けの新領域          |
| `/projects/datarepository/gAA50NNN/`                         | Yes[^2]  | Yes[^2]  | Yes[^2] | d002利用者向けの新領域          |
| `/groups/gAA50NNN/migrated_from_SFA_GPFS/`                   | No[^3]   | No[^3]   | No[^3]  | `/groups1/gAA50NNN/`の移行先    |
| `/projects/d001/gAA50NNN/migrated_from_SFA_GPFS/`            | No[^3]   | No[^3]   | No[^3]  | `/fs3/d001/gAA500NNN`の移行先   |
| `/projects/datarepository/gAA50NNN/migrated_from_SFA_GPFS/`  | No[^3]   | No[^3]   | No[^3]  | d002利用者の`/groups1/gAA500NNN`の移行先[^1] |
| `/projects/datarepository/gAA50NNN/migrated_from_SFA_GPFS3/` | No[^3]   | No[^3]   | No[^3]  | `/fs3/d002/gAA500NNN`の移行先[^1] |

[^1]: /fs3/d002利用者は移行元が複数あるため移行先のディレクトリがmigrated_from_SFA_GPFS/とmigrated_from_SFA_GPFS3/に別れています。
[^2]: 移行先ディレクトリを除きます。
[^3]: データ移行完了後にアクセス可能になります。


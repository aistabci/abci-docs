# FAQ

## Q. インタラクティブ利用時にCtrl+Sを入力するとそれ以降のキー入力ができない

macOS、Windows、Linuxなどの標準のターミナルエミュレータでは、デフォルトでCtrl+S/Ctrl+Qによる出力制御が有効になっているためです。無効にするためには、ローカルPCのターミナルエミュレータで以下を実行してください。

```shell
$ stty -ixon
```

インタラクティブノードにログインした状態で実行しても同等の効果があります。

## Q. グループ領域が実サイズ以上に消費されてしまう

一般にファイルシステムにはブロックサイズがあり、どんなに小さいファイルであってもブロックサイズ分の容量を消費します。

ABCIでは、グループ領域のブロックサイズは128KB、ホーム領域のブロックサイズは4KBとしています。このため、グループ領域に小さいファイルを大量に作ると利用効率が下がります。例えば、4KB未満のファイルを作る場合には、ホーム領域の約32倍の容量が必要になります。

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

`qrsh`や`qsub`で`-l rt_F=N`オプションを与えると、N個の計算ノードを割り当てることができます。割り当てられた計算ノードでそれぞれ異なる処理をさせたい場合にもMPIが使えます。

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

ABCIではCUDA対応版Open MPIとCUDA非対応版Open MPIを提供しており、提供の状況は、[MPIの利用](08.md#open-mpi)で確認できます。

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
ABCIシステム利用環境の[SSHクライアントによるログイン::一般的なログイン方法](./02.md#general-method)も参考にしてください。

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

[こちら](tips/datasets.md)のページをご参照ください。

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


## Q. 新ABCIグループ領域とデータ移行について知りたい {#q-what-are-the-new-abci-group-area-and-data-migration}

2021年度のABCIグループ領域について説明します。

これまでお使いいただいていたグループ領域(以後**旧領域**)は、新規増設予定の計算資源からアクセスできません。
このため、新たにグループ領域(以後**新領域**)を作成し、そちらへの移行を行います。
データのコピーは運用側で行いますので、利用者様がコピーする必要はありません。

これまで旧領域`/groups[1-2]/gAA50NNN`をご利用頂いていた皆様には、4月から新しく新領域`/groups/gAA50NNN`を割り当てられます。
旧領域、新領域ともにすべてのインタラクティブノードとすべての既存の計算ノードからアクセス可能です。

以下にデータ移行について説明します。

**(0) 基本的な方針**

* 旧領域のファイルを新領域に運用側がバックグラウンドでコピーします。全利用者データのコピー完了までには1年間かかることを予定しています。
* 利用者様は、旧領域をそのままお使いいただけますが、可能な限り新領域のご利用をお願いします。
* コピー完了後、リンクの切り替えによって旧領域への参照を新領域への参照に書き換えます。

**(1) 新領域/groups/gAA50NNNについて**

* 旧領域のデータは、新領域の`/groups/gAA50NNN/migrated_from_SFA_GPFS/`にコピーされます。ただし、移行完了までは利用者様がアクセスすることはできません。
* 新領域のこのフォルダ以外の領域は自由にお使いいただけます。
* 新領域のクォータは、旧領域のクォータの2倍に設定されます。これはデータ移行完了までの一時的な措置で、移行完了後、一定の猶予期間を設けて、旧領域のクォータ値に戻します。
* データコピーにともなって、ディスククォータ使用量が増大しますが、害はありません。

**(2) 旧領域/groups[1-2]/gAA50NNNについて**

**1. データ移行中**

* データ移行中も、利用者様は自由に旧領域に読み込み/書き込み可能です。ファイルを削除することも可能です。
* ただし、データ移行のコストが増大するため、可能な限り新領域のご利用をお願いします。
* データ移行コスト削減のため、可能な範囲で構いませんので、不要なファイルの削除をお願いします。

**2.データ移行完了のための参照不可期間について**

* データ移行完了の確認のために、旧領域を参照できない期間が数日発生する予定です。
* その期間、新領域は読み込み/書き込み/削除可能です。
* 参照不可期間終了後、旧領域`/groups[1-2]/gAA50NNN`と同じパスで、新領域にコピーされた旧領域のデータにアクセスが可能になります。

**3.データ移行完了後について**

* 旧領域に存在したデータは、従来と同じパス`/groups[1-2]/gAA50NNN`でアクセス可能になります。
* これは、新領域の`/groups/gAA50NNN/migrated_from_SFA_GPFS/`へのシンボリックリンクで実現されます。


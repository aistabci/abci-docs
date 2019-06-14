# 付録2. HPCIによるABCI利用

!!! note
    本項では、HPCIの利用者の方を対象に、ABCIシステムのインタラクティブノードへのログイン、ファイル転送方法等を説明します。

## インタラクティブノードへのログイン {#login-to-interactive-node}

ABCIシステムのフロントエンドであるインタラクティブノード (代表ホスト名：*es*) にログインするには、代理証明書を利用してHPCI 向けアクセスサーバ (ホスト名：*hpci.abci.ai*) にログインして、更に`ssh`コマンドを用いてインタラクティブノードにログインする必要があります。なお本章では、ABCIのサーバ名はフォントをイタリックで表記します。

### Linux / macOSなどの環境 {#linux-macos-environment}

`gsissh`コマンドでHPCI向けアクセスサーバ(*hpci.abci.ai*)にログインします。

<div class="codehilite"><pre>
yourpc$ gsissh -p 2222 <i>hpci.abci.ai</i>
[username@hpci1 ~]$
</pre></div>

HPCI向けアクセスサーバにログイン後、`ssh`コマンドを用いてインタラクティブノードにログインします。

<div class="codehilite"><pre>
[username@hpci1 ~]$ ssh <i>es</i>
[username@es1 ~]$
</pre></div>

### Windows環境 (GSI-SSHTerm) {#windows-environment-gsi-sshterm}

インタラクティブノードへのログインは、以下手順で実施します。

1. GSI-SSHTerm を起動
2. ホスト名にHPCI向けアクセスサーバ(*hpci.abci.ai*)を入力し、ログイン
3. `ssh`コマンドを用いてインタラクティブノードへログイン

HPCI向けアクセスサーバにログイン後、`ssh`コマンドを用いてインタラクティブノードにログインします。

<pre>
 [username@hpci1 ~]$ ssh <i>es</i>
 [username@es1 ~]$
</pre>

## インタラクティブノードへのファイル転送 {#file-transfer-to-interactive-node}

HPCI向けアクセスサーバではホーム領域が共有されていません。
そのため、インタラクティブノードへファイル転送をする場合、
一旦HPCI向けアクセスサーバ(ホスト名：*hpci.abci.ai*)へファイル転送し、
さらにインタラクティブノードへ`scp`(`sftp`)コマンドで転送してください。

<div class="codehilite"><pre>
[username@hpci1 ~]$ scp local-file username@<i>es</i>:remote-dir
local-file    100% |***********************|  file-size  transfer-time
</pre></div>

HPCI向けアクセスサーバ用ホーム領域の使用状況と割り当て量を表示するには、
`quota`コマンドを利用します。

```
[username@hpci1 ~]$ quota
Disk quotas for user axa01004ti (uid 1004):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
      /dev/sdb2      48  104857600 104857600              10       0       0
```

| 項目  | 説明 |
|:--|:--|
| Filesystem | ファイルシステム   |
| blocks     | ディスク使用量(KB) |
| files      | ファイル使用数     |
| quota      | 上限値(ソフトリミット) |
| limit      | 上限値(ハードリミット) |
| grace      | 猶予期間 |

!!! note
    HPCI向けアクセスサーバのホーム領域の割り当て量は100GBです。
    不要になったファイルは削除してください。

## HPCI共用ストレージのマウント {#mount-hpci-shared-storage}

HPCI向けアクセスサーバでHPCI共用ストレージをマウントする場合は、`mount.hpci`コマンドを使用します。

!!! note
    インタラクティブノードではHPCI共用ストレージはマウントできません。

```
[username@hpci1 ~]$ mount.hpci
```

マウント状況は`df`コマンドで確認できます。

```
[username@hpci1 ~]$ df -h /gfarm/project-ID/username
```

HPCI共用ストレージをアンマウントする場合は、`umount.hpci`コマンドを使用します。

```
[username@hpci1 ~]$ umount.hpci
```

## HPCI向けアクセスサーバと外部サービスの通信 {#communication-between-access-server-for-hpci-and-external-services}

HPCI向けアクセスサーバとABCI外部のサービス・サーバ間の通信は一部許可されています。
現在許可されていない通信に関しても、申請ベースで一定期間許可することを検討しますので、要望ありましたらサポートまで問い合わせください。

- HPCI向けアクセスサーバからABCI外部への通信
  以下のポートに関して通信を許可しています。

| ポート番号 | サービスタイプ |
|:--|:--|
| 443/tcp | https |

!!! note
    HPCI向けアクセスサーバからABCI外部のHPCIログインサーバへアクセスすることはできません。

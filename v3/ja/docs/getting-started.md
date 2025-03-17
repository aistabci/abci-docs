# ABCIの利用開始

## インタラクティブノードへの接続 {#connecting-to-interactive-node}

ABCIシステムのフロントエンドであるインタラクティブノード(ホスト名: *login*)に接続するには、二段階のSSH公開鍵認証による接続を行います。

1. SSH公開鍵認証を用いてアクセスサーバ(ホスト名: *as.v3.abci.ai*)にログインして、ローカルPCとインタラクティブノードの間にSSHポートフォワーディングによるトンネリング（以下「SSHトンネル」という）を作成
2. SSHトンネルを介して、SSH公開鍵認証を用いてインタラクティブノード(*login*)にログイン

なお本章では、ABCIのサーバ名は *イタリック* で表記します。

### 前提 {#prerequisites}

インタラクティブノードに接続するには、以下が必要になります。

* SSHクライアント: Linux、macOSを含むUNIX系OS、Windows 10 version 1803 (April 2018 Update)以降など、ほとんどのPCには、デフォルトでSSHクライアントがインストールされています。インストールされているかどうかを確認するには、コマンドラインから``ssh``コマンドを実行してください。
* SSHプロトコルバージョン: SSHプロトコルバージョン2のみサポートしています。
* 安全なSSH公開鍵・秘密鍵ペアの生成: ABCIで利用可能な鍵ペアは以下のとおりです。
	* RSA鍵 (2048bit以上)
	* ECDSA鍵 (256bit、384bit、または521bit)
	* Ed25519鍵
* SSH公開鍵の登録は、[ABCI 3.0 利用者ポータル](https://portal.v3.abci.ai/ProjectApplication_01)から実施ください。
* ABCI 3.0利用者ポータルの利用手順は、以下を参照してください。
	* 利用の手引き： [https://docs.abci.ai/v3/portal/ja/](https://docs.abci.ai/v3/portal/ja/)

!!! note
    SSHクライアントとして、Tera TermやPuTTYも利用可能です。

### SSHクライアントによるログイン {#login-using-an-ssh-client}

以下では、SSHクライアントを用いて、(1) アクセスサーバでSSHトンネルの作成後にインタラクティブノードにログインする方法と、(2) OpenSSH 7.3以降で実装されたProxyJumpを使ったより簡便なログイン方法を説明します。

#### 一般的なログイン方法 {#general-method}

以下のコマンドでアクセスサーバ(*as.v3.abci.ai*)にログインし、SSHトンネルを作成します。接続例としてポート番号を50022としていますが、他ホストへのSSH接続やローカルPC上のネットワークサービスですでに使用している場合は適宜変更してください。

```
[yourpc ~]$ ssh -i /path/identity_file -L 50022:login:22 -l username as.v3.abci.ai
The authenticity of host 'as.v3.abci.ai (0.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- 初回ログイン時のみ表示
Are you sure you want to continue connecting (yes/no)?  <- yesを入力
Warning: Permanently added ‘XX.XX.XX.XX' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- パスフレーズ入力
```


アクセスサーバへのログインが成功すると、ターミナル上に下記のメッセージが表示されます。

```
Welcome to ABCI access server.
Please press any key if you disconnect this session.
```

!!! warning
    上記状態で何らかのキーを入力するとSSH接続が切断されてしますので注意してください。

続いて、別のターミナルを起動し、SSHトンネルを用いてインタラクティブノードにログインします。

```
[yourpc ~]$ ssh -i /path/identity_file -p 50022 -l username localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- 初回ログイン時のみ表示
Are you sure you want to continue connecting (yes/no)? <- yesを入力
Warning: Permanently added 'localhost' (RSA) to the list of known hosts.
Enter passphrase for key '-i /path/identity_file': <- パスフレーズ入力
[username@login1 ~]$
```

#### ProxyJumpの使用 {#proxyjump}

ここではOpenSSH 7.3で実装されたProxyJumpを使ったログイン方法を説明します。Windows Subsystem for Linux (WSL)でも同様のログイン方法が使えます。

まずローカルPCの``$HOME/.ssh/config``に以下の記述を行います。

```
Host abci
     HostName login
     User username
     ProxyJump %r@as.v3.abci.ai
     IdentityFile /path/to/identity_file
     HostKeyAlgorithms ssh-ed25519

Host as.v3.abci.ai
     IdentityFile /path/to/identity_file
```

以降は、以下のコマンドのみでログインできます。

```
[yourpc ~]$ ssh abci
```

Windows 10 バージョン 1803 以降に標準でバンドルされている OpenSSH_for_Windows_7.7p1 では ProxyJump が機能しないため、代わりに ProxyCommand を使用してください。以下に ProxyCommand を使った config ファイルの例を示します。ssh.exe は絶対パスで記述して下さい。

```
Host abci
     HostName login
     User username
     ProxyCommand C:\WINDOWS\System32\OpenSSH\ssh.exe -W %h:%p %r@as.v3.abci.ai
     IdentityFile C:\path\to\identity_file

Host as.v3.abci.ai
     IdentityFile C:\path\to\identity_file
```

## インタラクティブノードへのファイル転送 {#file-transfer-to-interactive-node}

ローカルPCとABCIシステム間でファイル転送をするには、`scp`(`sftp`)コマンドを利用します。この場合もSSHトンネルを介して行う必要があります。

SSHトンネルの設定後、以下のように実行します。

```
[yourpc ~]$ scp -i /path/identity_file -P 50022 local-file username@localhost:remote-dir
Enter passphrase for key: <- パスフレーズを入力
    
local-file    100% |***********************|  file-size  transfer-time
```

ProxyJumpが使える場合は、SSHトンネルを明示的に設定する必要はありません。[ProxyJumpの使用](#proxyjump)で説明したとおり``$HOME/.ssh/config``の設定がしてあれば、直接`scp` (`sftp`)コマンドでファイル転送が行えます。

```
[yourpc ~]$ scp local-file abci:remote-dir
```

## ログインシェル {#login-shell}

ABCIシステムのデフォルトログインシェルは、bashが設定されています。
ログインシェルの変更については、運用担当者（abci3-qa@abci.ai ）までご連絡ください。

## ABCIポイントの確認 {#checking-abci-point} 

ABCIポイントの使用状況と購入数を確認するには、`show_point`コマンドを利用します。
ABCIポイント消費率が100%を超える見込みの場合、新規ジョブ投入が行えず、投入済みジョブは実行開始時にエラーになります（実行中ジョブは影響を受けません）。

例) ABCIポイントを確認する。

```
[username@login1 ~]$ show_point
Group                 Disk            ObjectStorage                    Used           Point   Used%
grpname                  5                  0.0124             12,345.6789         100,000      12
  `- username          -                         -                  0.1234               -       0
```

| 項目  | 説明 |
|:--|:--|
| Group | ABCI利用グループ名 |
| Disk  | グループ領域割当量(TB) |
| ObjectStorage | ABCIオブジェクトストレージの ABCIポイント使用量 |
| Used  | ABCIポイント使用量 |
| Point | ABCIポイント購入量 |
| Used% | ABCIポイント消費率 |

月ごとのABCIポイントの使用状況を確認するには、`show_point_history`コマンドを利用します。

例) ABCIポイントの月単位の使用状況を確認する。

```
[username@login1 ~]$ show_point_history -g grpname
                      Apr        May        Jun        Jul        Aug        Sep        Oct        Nov        Dec        Jan        Feb        Mar          Total
Disk           1,000.0000     0.0000     0.0000          -          -          -          -          -          -          -          -          -     1,000.0000
ObjectStorage       1.0000     1.5000     0.5000          -          -          -          -          -          -          -          -          -         2.0000
Job              100.0000    50.0000    10.0000          -          -          -          -          -          -          -          -          -       160.0000
  |- username1    60.0000    40.0000     5.0000          -          -          -          -          -          -          -          -          -       105.0000
  `- username2    40.0000    10.0000     5.0000          -          -          -          -          -          -          -          -          -        55.0000
Total          1,101.0000    51.5000    10.5000          -          -          -          -          -          -          -          -          -     1,162.0000
```

| 項目  | 説明 |
|:--|:--|
| Disk  | グループ領域のABCIポイント使用量 |
| ObjectStorage | ABCIオブジェクトストレージの ABCIポイント使用量 |
| Job | グループ所属全ユーザのOn-demand、Spot、ReservedサービスでのABCIポイント使用量の合計値 |
| Total(行) | Disk、ObjectStorage、JobでのABCIポイント使用量の合計値 |

!!! note
    - ジョブサービスのABCIポイント使用の計算については、[課金](job-execution.md#accounting)を参照してください。
    - On-demandおよびSpotサービスのジョブ実行から終了の間に月を跨ぐ場合、当該ジョブのポイント使用量は全てジョブを投入した月にてカウントします。ジョブ終了後の返却処理も、ジョブを投入した月の使用ポイントに対して実施されます。
    - Reservedサービスの使用ポイントは、予約を作成した月にカウントします。予約を取り消した場合、予約を作成した月の使用ポイントから当該予約分のポイントが削減されます。


## ディスククォータの確認 {#checking-disk-quota}

ホーム領域およびグループ領域の使用状況と割り当て量を表示するには、`show_quota`コマンドを利用します。
`show_quota`コマンドに関する、主要なオプションを以下に示します。

| オプション | 説明 |
|:--|:--|
| -b *G* | ディスクサイズの単位をGibibyteとして表示します。デフォルトではTebibyte単位での表示となります。 |

例) ディスクおよびinodeクォータを確認する。

```
[username@login1 ~]$ show_quota
Disk quotas for ABCI group grpname
  Directory                          used(TiB)        limit(TiB)      used(nfiles)     limit(nfiles)
  /groups/grpname                            0                32            422372         200000000

Disk quotas for user username
  Directory                          used(TiB)        limit(TiB)      used(nfiles)     limit(nfiles)
  /home/username                             0                 2            103219                 0
```

| 項目  | 説明 |
|:--|:--|
| Directory  | 領域種別 |
| used(TiB)  | ディスク使用量 |
| limit(TiB) | ディスク上限値 |
| used(nfiles) | inode使用数 |
| limit(nfiles) | inode数上限値 |

例) 単位をGibibyteとして、ディスクおよびinodeクォータを確認する。

```
[username@login1 ~]$ show_quota -b G
Disk quotas for ABCI group grpname
  Directory                          used(GiB)        limit(GiB)      used(nfiles)     limit(nfiles)
  /groups/grpname                          312             32768            422372         200000000

Disk quotas for user username
  Directory                          used(GiB)        limit(GiB)      used(nfiles)     limit(nfiles)
  /home/username                            32              2048            103221                 0
```

| 項目  | 説明 |
|:--|:--|
| Directory  | 領域種別 |
| used(GiB)  | ディスク使用量 |
| limit(GiB) | ディスク上限値 |
| used(nfiles) | inode使用数 |
| limit(nfiles) | inode数上限値 |

なお、inode数上限値の欄に "0" が表示されている場合、inode使用数に制限はありません。
また、ディスク使用量がディスク上限値を超えている場合、ディスク使用量の欄に"*"が表示されます。

inode使用数がinode数上限値を超過している、またはディスク使用量がディスク上限値を超過している場合、新規ファイル・ディレクトリの作成に失敗します。

```
[username@login1 ~]$ touch quota_test
touch: cannot touch 'quota_test': Disk quota exceeded
```

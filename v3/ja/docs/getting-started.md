# ABCIの利用開始
<!-- 
## ABCIアカウントの取得 {#getting-an-account}

### ABCIの利用申請 {#application-for-use-of-abci}
ABCIを利用するためには、[「ご利用の流れ」](https://abci.ai/ja/how_to_use/)に掲載された利用規定（約款または規約）に従い、研究・開発テーマを決定し、[ABCI利用者ポータル](https://portal.abci.ai/user/project_register_app.php) から「ABCI利用申請」を提出します。ABCI申請受付担当は利用規定に基づいて審査し、要件が満たされている場合に、申請されたABCIグループを作成し、申請者に採択された旨を通知します。申請者が通知を受け取ったら、利用開始となります。

利用料金は、[料金表](https://abci.ai/ja/how_to_use/tariffs.html)を確認の上、ABCIポイントを購入することで支払いいただきます。ABCIポイントはABCIグループごとに購入してください。申請時には、ABCIポイントを 1,000ポイント以上購入する必要があります。

### ABCIアカウントの種類 {#account-type}
ABCIアカウントには、「利用責任者」「利用管理者」「利用者」の3種類があります。ABCIシステムを利用するには、「利用責任者」が [ABCI利用者ポータル](https://portal.abci.ai/user/project_register_app.php) から「利用グループ申請」を行い、ABCIアカウントを取得する必要があります。
詳細は [ABCI利用者ポータルガイド](https://docs.abci.ai/portal/ja/) を参照してください。

!!! note
    - 「利用責任者」自身にもABCIアカウントが発行されます。
    - 「利用責任者」は [ABCI利用者ポータル](https://portal.abci.ai/user/) にて「利用者」を「利用管理者」に変更することが可能です。
    - 「利用責任者」と「利用管理者」は、ABCIグループに「利用管理者」もしくは「利用者」を追加することが可能です。
    - 「利用責任者」と「利用管理者」は、ABCIグループの「利用責任者」を変更することが可能です。

### ABCIアカウントの一意性 {#account-uniqueness}
原則として、1人の方は1つのABCIアカウントを利用ください。例えば、会社で1つのABCIアカウントを取得し、複数の社員が共有して使い回すことは認められません。
一方で1人の方が複数の法人に所属している場合は複数のABCIアカウントを取得することができます。この場合、それぞれの法人に対応するABCIアカウントを使い分ける必要があります。

### 複数のABCIグループに所属する場合 {#multi-titled-person}
1人の方が1つの法人の中で複数のテーマに同時に取り組んでいる場合、1人で複数のABCIアカウントをそれぞれ取得するのではなく、1つのABCIアカウントで複数のABCIグループに所属することになります。この場合、その利用目的に応じてABCIグループを使い分ける必要があります。どのABCIグループを利用すべきか不明の場合は、ABCIグループの「利用責任者」または「利用管理者」へお問い合わせください。自分が所属しているABCIグループの「利用責任者」または「利用管理者」は、[ABCI利用者ポータル](https://portal.abci.ai/user/) へログイン後の最初の画面に表示されます。

ご利用料金をどのABCIグループが負担するかに関わるため、ABCIグループの「利用責任者」または「利用管理者」の指示に従い、適切なABCIグループを利用ください。
 -->


## インタラクティブノードへの接続 {#connecting-to-interactive-node}

ABCIシステムのフロントエンドであるインタラクティブノード(ホスト名: *int*)に接続するには、二段階のSSH公開鍵認証による接続を行います。

1. SSH公開鍵認証を用いてアクセスサーバ(ホスト名: *as.v3.abci.ai*)にログインして、ローカルPCとインタラクティブノードの間にSSHポートフォワーディングによるトンネリング（以下「SSHトンネル」という）を作成
2. SSHトンネルを介して、SSH公開鍵認証を用いてインタラクティブノード(*int*)にログイン

なお本章では、ABCIのサーバ名は *イタリック* で表記します。

### 前提 {#prerequisites}

インタラクティブノードに接続するには、以下が必要になります。

* SSHクライアント: Linux、macOSを含むUNIX系OS、Windows 10 version 1803 (April 2018 Update)以降など、ほとんどのPCには、デフォルトでSSHクライアントがインストールされています。インストールされているかどうかを確認するには、コマンドラインから``ssh``コマンドを実行してください。
* SSHプロトコルバージョン: SSHプロトコルバージョン2のみサポートしています。
* 安全なSSH公開鍵・秘密鍵ペアの生成: ABCIで利用可能な鍵ペアは以下のとおりです。
	* RSA鍵 (2048bit以上)
	* ECDSA鍵 (256bit、384bit、または521bit)
	* Ed25519鍵
* SSH公開鍵の登録については、運用担当者までご連絡ください。

!!! note
    SSHクライアントとして、Tera TermやPuTTYを利用可能です。

### SSHクライアントによるログイン {#login-using-an-ssh-client}

以下では、SSHクライアントを用いて、(1) アクセスサーバでSSHトンネルの作成後にインタラクティブノードにログインする方法と、(2) OpenSSH 7.3以降で実装されたProxyJumpを使ったより簡便なログイン方法を説明します。

#### 一般的なログイン方法 {#general-method}

以下のコマンドでアクセスサーバ(*as.v3.abci.ai*)にログインし、SSHトンネルを作成します。

```
[yourpc ~]$ ssh -i /path/identity_file -L 10022:int:22 -l username as.v3.abci.ai
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
[yourpc ~]$ ssh -i /path/identity_file -p 10022 -l username localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- 初回ログイン時のみ表示
Are you sure you want to continue connecting (yes/no)? <- yesを入力
Warning: Permanently added 'localhost' (RSA) to the list of known hosts.
Enter passphrase for key '-i /path/identity_file': <- パスフレーズ入力
[username@int1 ~]$
```

#### ProxyJumpの使用 {#proxyjump}

ここではOpenSSH 7.3で実装されたProxyJumpを使ったログイン方法を説明します。Windows Subsystem for Linux (WSL)でも同様のログイン方法が使えます。

まずローカルPCの``$HOME/.ssh/config``に以下の記述を行います。

```
Host abci
     HostName int
     User username
     ProxyJump %r@as.v3.abci.ai
     IdentityFile /path/to/identity_file
     HostKeyAlgorithms ssh-rsa

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
     HostName int
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
[yourpc ~]$ scp -i /path/identity_file -P 10022 local-file username@localhost:remote-dir
Enter passphrase for key: <- パスフレーズを入力
    
local-file    100% |***********************|  file-size  transfer-time
```

ProxyJumpが使える場合は、SSHトンネルを明示的に設定する必要はありません。[ProxyJumpの使用](#proxyjump)で説明したとおり``$HOME/.ssh/config``の設定がしてあれば、直接`scp` (`sftp`)コマンドでファイル転送が行えます。

```
[yourpc ~]$ scp local-file abci:remote-dir
```
<!--
## パスワード変更 {#changing-password}

ABCIシステムのパスワードはLDAPで管理されています。 SSHログインではパスワードは使用しませんが、
[ABCI利用者ポータル](https://portal.abci.ai/user/)へのログイン、ログインシェルの変更の際にパスワードが必要になります。
パスワードを変更する場合は、`passwd`コマンドを使用します。

```
[username@int1 ~]$ passwd
Changing password for user username.
Current Password: <- 現在のパスワードを入力
New password: <- 新しいパスワードを入力
Retype new password: <- 新しいパスワードを再度入力
passwd: all authentication tokens updated successfully.
```

!!! warning
    パスワード規約は以下の通りです。

    - 15文字以上のランダムに並べた文字列を指定してください。例えばLinuxの辞書に登録されている単語は使用できません。文字をランダムに選ぶ方法として、パスワード作成用のソフトウェアを用いるなどして、自動的に生成することを推奨します。
    - 英大文字[A-Z]、英小文字[a-z]、数字[0-9]、記号の4種類をすべて使用してください。
    - 使用可能な記号は次の33種類です。
      (空白) ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
    - 全角文字は使用できません。

## ログインシェル {#login-shell}

ABCIシステムのデフォルトログインシェルは、bashが設定されています。
ログインシェルは`chsh`コマンドを使用してtcshもしくはzshに変更することができます。
ログインシェルの変更は次回ログインから有効となります。また、ログインシェルの反映には10分程度時間がかかります。

```
$ chsh [options] <new_shell>
```

| オプション | 説明 |
|:--|:--|
| -l | 利用可能なログインシェル一覧を表示する |
| -s *new_shell* | ログインシェルを*new_shell*に変更する |

例) ログインシェルを tcsh に変更する。

```
[username@int1 ~]$ chsh -s /bin/tcsh
Password for username@ABCI.LOCAL: <- パスワードを入力
```

ABCIシステムへログインすると、ABCIシステムを利用するための環境設定が自動で設定されます。環境変数`PATH`や環境変数`LD_LIBRARY_PATH`等をカスタマイズする場合は、以下に示す個人用設定ファイルに設定してください。

| ログインシェル  | 個人用設定ファイル |
|:--|:--|
| bash  |  $HOME/.bash_profile |
| tcsh  |  $HOME/.cshrc |
| zsh   |  $HOME/.zshrc |

!!! warning
    設定ファイルに環境変数`PATH`にパスを追加する際は、環境変数`PATH`の最後に追加してください。先頭に追加した場合、システムを正常に使用できなくなる恐れがあります。

個人用設定ファイルのオリジナル（雛形）は`/etc/skel`配下に格納しています。
-->
<!--
## ABCIポイントの確認 {#checking-abci-point}

ABCIポイントの使用状況と購入数を確認するには、`show_point`コマンドを利用します。
ABCIポイント消費率が100%を超える見込みの場合、新規ジョブ投入が行えず、投入済みジョブは実行開始時にエラーになります（実行中ジョブは影響を受けません）。

例) ABCIポイントを確認する。

```
[username@int1 ~]$ show_point
Group                 Disk            CloudStorage                    Used           Point   Used%
grpname                  5                  0.0124             12,345.6789         100,000      12
  `- username          -                         -                  0.1234               -       0
```

| 項目  | 説明 |
|:--|:--|
| Group | ABCI利用グループ名 |
| Disk  | グループ領域割当量(TB) |
| CloudStorage | ABCIクラウドストレージの ABCIポイント使用量 |
| Used  | ABCIポイント使用量 |
| Point | ABCIポイント購入量 |
| Used% | ABCIポイント消費率 |

月ごとのABCIポイントの使用状況を確認するには、`show_point_history`コマンドを利用します。

例) ABCIポイントの月単位の使用状況を確認する。

```
[username@int1 ~]$ show_point_history -g grpname
                      Apr        May        Jun        Jul        Aug        Sep        Oct        Nov        Dec        Jan        Feb        Mar          Total
Disk           1,000.0000     0.0000     0.0000          -          -          -          -          -          -          -          -          -     1,000.0000
CloudStorage       1.0000     1.5000     0.5000          -          -          -          -          -          -          -          -          -         2.0000
Job              100.0000    50.0000    10.0000          -          -          -          -          -          -          -          -          -       160.0000
  |- username1    60.0000    40.0000     5.0000          -          -          -          -          -          -          -          -          -       105.0000
  `- username2    40.0000    10.0000     5.0000          -          -          -          -          -          -          -          -          -        55.0000
Total          1,101.0000    51.5000    10.5000          -          -          -          -          -          -          -          -          -     1,162.0000
```

| 項目  | 説明 |
|:--|:--|
| Disk  | グループ領域のABCIポイント使用量 |
| CloudStorage | ABCIクラウドストレージの ABCIポイント使用量 |
| Job | グループ所属全ユーザのOn-demand、Spot、ReservedサービスでのABCIポイント使用量の合計値 |
| Total(行) | Disk、CloudStorage、JobでのABCIポイント使用量の合計値 |

!!! note
    - ジョブサービスのABCIポイント使用の計算については、[課金](job-execution.md#accounting)を参照してください。
    - On-demandおよびSpotサービスのジョブ実行から終了の間に月を跨ぐ場合、当該ジョブのポイント使用量は全てジョブを投入した月にてカウントします。ジョブ終了後の返却処理も、ジョブを投入した月の使用ポイントに対して実施されます。
    - Reservedサービスの使用ポイントは、予約を作成した月にカウントします。予約を取り消した場合、予約を作成した月の使用ポイントから当該予約分のポイントが削減されます。

## ディスククォータの確認 {#checking-disk-quota}

ホーム領域およびグループ領域の使用状況と割り当て量を表示するには、
`show_quota`コマンドを利用します。

例) ディスクおよびinodeクォータを確認する。

```
[username@int1 ~]$ show_quota
Disk quotas for user username
  Directory                            used(GiB)        limit(GiB)      used(nfiles)     limit(nfiles)
  /home                                      100               200             1,234                 -
  /scratch/username                        1,234            10,240                 0                 -

Disk quotas for ABCI group grpname
  Directory                            used(GiB)        limit(GiB)      used(nfiles)     limit(nfiles)
  /groups/grpname                          1,024             2,048           123,456       200,000,000
```

| 項目  | 説明 |
|:--|:--|
| Directory  | 領域種別 |
| used(GiB)  | ディスク使用量 |
| limit(GiB) | ディスク上限値 |
| used(nfiles) | inode使用数 |
| limit(nfiles) | inode数上限値 |

なお、inode数上限値の欄に "-" が表示されている場合、inode使用数に制限はありません。
また、ディスク使用量がディスク上限値を超えている場合、ディスク使用量の欄に"*"が表示されます。

inode使用数がinode数上限値を超過している、またはディスク使用量がディスク上限値を超過している場合、新規ファイル・ディレクトリの作成に失敗します。

```
[username@int1 ~]$ touch quota_test
touch: cannot touch 'quota_test': Disk quota exceeded
```

## ABCI クラウドストレージ利用状況の確認 {#checking-cloud-storage-usage}

ABCI クラウドストレージの使用状況表示するには、`show_cs_usage` コマンドを利用します。

例1) オプション指定なしで、所属するABCIグループ grpname の直近の利用状態を確認できます。
```
[username@int1 ~]$ show_cs_usage
Cloud Storage Usage for ABCI groups
Date           Group                   used(GiB)
2020/01/13     grpname                       162
```

例2) オプション -d で日付を指定できます。日付の書式は、 yyyymmdd で指定してください。(ABCIグループは grpname)
```
[username@int1 ~]$ show_cs_usage -d 20191217
Cloud Storage Usage for ABCI groups
Date           Group                   used(GiB)
2019/12/17     grpname                       124
```
-->
# Singularity Remote Builder 利用手順

## 概要

ABCI では、Singularity Enterprise が提供するサービスを利用することができます。このサービスを利用すれば、通常はシステム管理者の権限が必要なコンテナイメージの作成を、一般利用者でも行うことができます。また、作成したコンテナをライブラリに保存し、他の ABCI 利用者と共有することも可能です。
これらのサービスは ABCI のシステム内で稼働しているため、インターネットに利用者のデータを持ち出すことなく、ABCI の内部でサービスを利用することが可能です。
ここでは、Singularity Enterprise の以下サービスの利用方法を説明します。

* Remote Builder
* Key service
* Library

## アクセストークンの準備

### Singularity Pro の利用準備

以下の説明では、Singularity Pro の使用を前提とします。singularity pro を使用するためには、 environment module で ``singularitypro`` をロードします。

```
[username@es1 ~]$ module load singularitypro/3.5
[username@es1 ~]$ singularity --version
SingularityPRO version 3.5-2.el7
```

### アクセストークンの発行

各種サービスを利用するためにはアクセストークンを取得し利用者の環境に登録する必要があります。アクセストークンとは、各種サービスの利用を認可する文字列のことで、ABCI の利用者は誰でも取得することができます。

アクセストークンは、専用のコマンド ``get_singularity_token``を使用してインタラクティブノード、計算ノードおよびメモリインテンシブノードで取得可能です。発行には ABCI のパスワード (利用者ポータルへのログインに使用) の入力が必要です。
以下にアクセストークンの発行例を示します。
```
[username@es1 ~]$ get_singularity_token
ABCI portal password :利用ポータルのパスワードを入力
just a moment, please...
アクセストークンの表示
```
表示されたアクセストークンは後で使用するためコピーなどで控えておきます。

!!! note
    アクセストークンは非常に長い１行の文字列のため、途中に改行などが入らないよう注意してください。

### Remote Endpoint の登録

次に、ABCI のリモートエンドポイントを追加します。リモートエンドポイントとは、singularity remote のサービス提供元となる接続先で、初期値として SylabsCloud (cloud.sylabs.io) が登録されています。

!!! note
    SylabsCloud は Sylabs 社が運営するサービスです。

ABCI ではリモートエンドポイント `` cloud.se.abci.local `` を任意の登録名で追加します。以下は、登録名が ``abci-se`` の例です。``API Key: `` に上で発行したアクセストークンをコピーして貼り付けます。
```
[username@es1 ~]$ singularity remote add abci-se cloud.se.abci.local
INFO:    Remote "abci-se" added.
INFO:    Authenticating with remote: abci-se
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key:アクセストークンを入力（非表示）
INFO:    API Key Verified!
[username@es1 ~]$ 
```
!!! note
    アクセストークンの貼り付けは、貼り付けた文字列が表示されないため不要な文字が混入しないよう注意してください。

アクセストークンが適正と判定されると、```API Key Verified!``` が表示されます。登録したリモートエンドポイントは、以下コマンドで確認できます。
```
$ [username@es1 ~]$ singularity remote list
NAME         URI                  GLOBAL
[SylabsCloud]  cloud.sylabs.io      YES
abci-se    cloud.se.abci.local  NO <- 追加されたリモートエンドポイント
[username@es1 ~]$
```

次に、デフォルトのままでは上記のように "[]" で囲まれた SylabsCloud すなわち Sylabs社のリモートエンドポイントを使用してしまうため、登録した ```abci-se``` に切り替えます。
```
[username@es1 ~]$ singularity remote use abci-se
INFO:    Remote "abci-se" now in use.
```

abci-se が "[]" で囲まれたことを確認します。
```
[username@es1 ~]$ singularity remote list
NAME         URI                  GLOBAL
SylabsCloud  cloud.sylabs.io      YES
[abci-se]    cloud.se.abci.local  NO
[username@es1 ~]$
```

以上で、Remote Endpoint の登録は完了です。

### アクセストークンの更新

アクセストークンを再発行した場合は、再度、登録したリモートエンドポイント (上の例では``abci-se``) にログインすることで更新されます。
```
[username@es1 ~]$ singularity remote login abci-se
INFO:    Authenticating with remote: abci-se
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key:
INFO:    API Key Verified!
[username@es1 ~]$
```

## Remote Builder の利用

ここでは、singularity の Remote Builder サービスによるコンテナイメージの作成について説明します。

以下の例では、Docker Hub から取得した Ubuntu のコンテナから Singularity イメージ (SIF) を作成しています。
まず、def ファイルを作成します。

```
[username@es1 ~]$ vi ubuntu.def
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:16.04

%runscript
    echo "hello world from ubuntu container!" 
[username@es1 ~]$ 
```

次に、``--remote`` オプションをつけてコンテナをビルドします。
```
[username@es1 ~]$ singularity build  --remote ubuntu.sif ubuntu.def
INFO:    Remote "default" added.
INFO:    Authenticating with remote: default
INFO:    API Key Verified!
INFO:    Remote "default" now in use.
INFO:    Starting build...
:
(中略)
:
INFO:    Build complete: ubuntu.sif
[username@es1 ~]$ 
```

動作確認
```
[username@es1 ~]$ qrsh -l rt_C.small=1 -g group
[username@g0001 ~]$ module load singularitypro/3.5
[username@g0001 ~]$ singularity run ubuntu.sif
hello world from ubuntu container!
```

## Keystore の利用

ここでは、Keystore サービスを説明します。
Keystore サービスは ``singularity key newpair`` コマンドで作成したキーペアの公開鍵を ABCI 内で公開できるサービスです。コンテナイメージの作成者が、コンテナイメージの署名に使用した公開鍵を Keystore に登録することで、別の利用者が Library サービスから取得したコンテナイメージを公開鍵で検証することが可能になります。

### キーペアの発行

``singularity key newpair``で作成したキーペアは、利用者のローカル環境で、キーリストに追加されます。作成時に Keystore への push  を選択した場合は、作成時に Keystore に push まで実行されます。キーペアの発行には、以下表に示す値を入力します。

| 項目 | 入力値 |
| :-- | :-- |
| Enter your name | ABCIアカウント名 |
| Enter your email address | ABCI アカウント |
| Enter optional comment | 任意の文字列 |
| Enter a passphrase | キーのパスフレーズ |
| Would you like to push it to the keystore? | 公開鍵をKeystore に push する場合 'Y' を選択|


以下に例を示します。ここでは、キーのコメントを sample としています。
```
[username@es1 ~]$ singularity key newpair
Enter your name (e.g., John Doe) : ABCI アカウント名
Enter your email address (e.g., john.doe@example.com) : ABCIアカウント名
Enter optional comment (e.g., development keys) : sample <- 任意の文字列
Enter a passphrase : <- キーのパスフレーズを入力（非表示）
Retype your passphrase :
Would you like to push it to the keystore? [Y,n] Y <- Keystore にpush する場合 'Y'
Generating Entity and OpenPGP Key Pair... done
Key successfully pushed to: https://keys.se.abci.local
```

### キーの一覧表示

作成したキーは、リスト表示で確認ができます。
ローカルのキーリストは以下のようにして確認します。
```
[username@es1 ~]$ singularity key list
Public key listing (/home/ABCIアカウント名/.singularity/sypgp/pgp-public):
:
(中略)
:
   --------
7) U: ABCIアカウント名 (sample) <ABCIアカウント名>
   C: 2020-06-15 03:40:05 +0900 JST
   F: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   L: 4096
   --------
[username@es1 ~]$
```

Keystore に push したキーは、以下のように確認することができます。

```
[username@es1 ~]$ singularity key search -l ABCIアカウント名
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  ABCIアカウント名 (sample) <ABCIアカウント名>

[username@es1 ~]$
```

### Keysotre への push

ローカルのキーリストに保存されているキーは、フィンガープリントを指定して Keystore に push することができます。

!!! note
    Keystore に push したキーは削除することができません。

```
[username@es1 ~]$ singularity key list
0) U: ABCIアカウント名 (test key 03) <ABCIアカウント名>
   C: 2020-08-08 04:28:35 +0900 JST
   F: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ <- push するキーのフィンガープリント
   L: 4096
   --------

[username@es1 ~]$ singularity key push ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
public key `ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' pushed to server successfully

[username@es1 ~]$ singularity key search -l ABCIアカウント名
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  ABCIアカウント名 (sample) <ABCIアカウント名>
```

### Keysotre から pull 

Keystore で公開されているキーは、自分のローカルのキーリストに pull して保存することが可能です。以下の例では、WORD で検索してヒットしたキーを pull しています。
```
[username@es1 ~]$ $ singularity key search -l WORD
Showing 2 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  ABCIアカウント名 (sample) <ABCIアカウント名>

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  RSA        4096  2020-06-22 11:51:45 +0900 JST  [ultimate]       [enabled]  ABCIアカウント名 (WORD) <ABCIアカウント名>

[username@es1 ~]$ singularity key pull AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
1 key(s) added to keyring of trust /home/ABCIアカウント名/.singularity/sypgp/pgp-public
[username@es1 ~]$ singularity key list
1) U: ABCIアカウント (WORD) <ABCIアカウント>
   C: 2020-08-10 11:51:45 +0900 JST
   F: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   L: 4096
   --------
[username@es1 ~]$
```

### キーの削除

作成したキーは、キーのフィンガープリントを指定して、削除することができます。なお、削除可能なキーはローカルのキーリストからのみで、Keystore に push したキーは削除することができません。

```
[username@es1 ~]$ singularity key remove AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
[username@es1 ~]$
```

## Library の利用

ここでは、Singularity Enterprise の Library サービスについて説明します。Library サービスでは、利用者がコンテナイメージを ABCI 内で公開することが可能です。公開されたコンテナイメージは、利用者がジョブの中で pull して計算ノードで利用したり、他利用者も pull して利用することが可能になります。

Library 上のコンテナイメージのパスは、``library://ABCIアカウント名`` を固定として以下のような URL で示されます。

```
library://ABCIアカウント名/コレクション名/コンテナ名:tag
```
ここで、パスの構成は以下表のようになります。

| 項目 | 入力値 |
| :-- | :-- |
| コレクション名 | コレクション名を任意の文字列で指定 |
| コンテナ名 | コンテナ名を任意の文字列で指定 |
| tag | 同名コンテナのバージョンの指定 |

### Library への push

Library にコンテナイメージをプッシュするためには、まず、キーリストに登録されたキーで署名します。
``-k`` で指定している数値は、``singularity key list`` で表示されるキーリストの番号です。
```
[username@es1 ~]$ singularity sign -k 7 ./ubuntu.sif
Signing image: ./ubuntu.sif
Enter key passphrase : <- キー作成時のパスフレーズを入力する。
Signature created and applied to ./ubuntu.sif
```

コレクション名をabci-test-se, push 先のコンテナイメージ名を helloworld.sif また、tag として latest を指定した例を以下に示します。
```
[username@es1 ~]$ singularity push ubuntu.sif library://ABCIアカウント名/abci-se-test/helloworld:latest
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
 35.36 MiB / 35.36 MiB [===========================================================================================================================================================================================================] 100.00% 182.68 MiB/s 0s
[username@es1 ~]$
```
### Library から pull

Libraryに登録したコンテナは以下のようにして pull が可能です。
```
[username@es1 ~]$ singularity pull library://ABCIアカウント名/abci-se-test/helloworld:latest
INFO:    Downloading library image
 35.37 MiB / 35.37 MiB [=============================================================================================================================================================================================================] 100.00% 353.47 MiB/s 0s
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
INFO:    Download complete: helloworld_latest.sif
[username@es1 ~]$
```

この例では、以下のようにコンテナイメージに署名したキーがローカルのキーリストに格納済みのため、コンテナイメージをダウンロードするときに自動的に検証が行われています。

```
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
```

ローカルのキーリストに公開鍵が格納されていない場合は、対象のキーを pull しローカルのキーリストに追加するか、または、``singularity verify`` コマンドで検証が可能です。``singularity verify`` コマンドでの検証は以下のようになります。

```
[username@es1 ~]$ singularity verify helloworld_latest.sif
Container is signed by 1 key(s):

Verifying partition: FS:
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
[REMOTE]   ABCIアカウント名 (COMMENT) <ABCIアカウント名> -> Keystoreで公開鍵を発見
[OK]      Data integrity verified  -> 検証に成功

INFO:    Container verified: helloworld_latest.sif
```

!!! note
    検証に失敗する場合でもコンテナイメージの実行は可能ですが、検証可能なコンテナイメージの使用を推奨します

### Library 内の検索
Libraryに登録したコンテナをキーワードで検索ができます。

ABCIアカウントにヒットした場合の例：
```
[username@es1 ~]$ singularity search ABCIアカウント名1
Found 1 users for 'ABCIアカウント名1'
	library://ABCIアカウント名1
```

コンテナ名にヒットした場合の例：

```
[username@es1 ~]$ singularity search ubuntu
No users found for 'ubuntu'

No collections found for 'ubuntu'

Found 1 containers for 'ubuntu'
	library://axa01001hf/exam-honban/ubuntu-test.sif
		Tags: latest
```

### コンテナイメージの削除
Library サービスに push したコンテナイメージは、以下のようにして削除が可能です。

```
[username@es1 ~]$ singularity delete library://ABCIアカウント名/abci-se-test/helloworld:latest
```

!!! caution
    現在、singularity の不具合により ``singularity delete`` コマンドが正常動作しません。以下代替コマンドでコンテナイメージの削除をお願いします。

``singularity delete`` の代替コマンド
```
singularity delete --arch amd64  --library https://library.se.abci.local/  library://abci-se-test/helloworld:latest
```


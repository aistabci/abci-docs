# ABCI Singularity エンドポイント

## 概要

ABCI では、Singularity で使うコンテナイメージをリモートビルドするためのサービスである Remote Builder と、作成したコンテナイメージを保管するための Container Library サービスを提供しています。

!!! tip
    SingularityPRO 3.5 を使って、[ローカルビルドで作成](09.md#build-a-singularity-image)することもできます。

!!! note
    ABCI 内部向けのサービスであり、外部から直接アクセスすることはできません。

## Remote Builder の使い方

### モジュールのロード

コンテナイメージのリモートビルドやアップロードを行うには、SingularityPRO を使用します。singularitypro/3.5 モジュールをロードしてください。

```
[username@es1 ~]$ module load singularitypro/3.5
```

!!! note
    Singularity 2.6.1 では、リモートビルドを行うことができません。

### アクセストークンの取得

サービスの認証に必要なアクセストークンを取得し、SingularityPRO に登録します。ABCI の利用者は誰でも取得することができます。インタラクティブノードで `get_singularity_token` コマンドを実行します。計算ノードやメモリインテンシブノードでも実行できますが、発行には ABCI のパスワード (利用者ポータルへのログインに使用するパスワード) の入力が必要です。

```
[username@es1 ~]$ get_singularity_token
ABCI portal password :
just a moment, please...
```

この後に続いて、アクセストークンが出力されます。後で登録する時に必要になりますので、安全なところに控えておきます。

!!! note
    アクセストークンは、非常に長い１行の文字列で作られているため、途中に改行などが入らないよう注意してください。

!!! warning
    現時点では、一度発行したアクセストークン(後述)を無効化することはできません。

### リモートエンドポイントの設定

リモートビルドを行う時の接続先となる Remote Builder のエンドポイントを登録します。初期値として SylabsCloud (cloud.sylabs.io) が登録されています。

!!! note
    SylabsCloud は [Sylabs](https://sylabs.io/) 社が運営するサービスです。そちらを使うこともできます。サービス内容については <https://cloud.sylabs.io/> をご確認ください。

ABCI の Remote Builder は、`cloud.se.abci.local` です。以下は、`abci` という名前で登録する例です。名前は任意のものをつけることができます。

```
[username@es1 ~]$ singularity remote add abci cloud.se.abci.local
INFO:    Remote "abci" added.
INFO:    Authenticating with remote: abci
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key: 
```

`API Key:` と出力されたら、控えておいたアクセストークンをコピーして貼り付けます。

!!! note
    貼り付けた文字列は表示されないため、不要な文字が混入しないよう注意してください。

アクセストークンが適正と判定されると、`API Key Verified!` と出力されます。登録したリモートエンドポイントは、以下コマンドで確認できます。

```
[username@es1 ~]$ singularity remote list
NAME           URI                  GLOBAL
[SylabsCloud]  cloud.sylabs.io      YES
abci           cloud.se.abci.local  NO
[username@es1 ~]$
```

リモートビルドやアップロードの時には、`[]` で囲まれているものが使われます。上記の例では SylabsCloud を使う設定になっているため、登録した `abci` に切り替えます。

```
[username@es1 ~]$ singularity remote use abci
INFO:    Remote "abci" now in use.
```

`abci` が "[]" で囲まれたことを `singularity remote list` で確認します。

```
[username@es1 ~]$ singularity remote list
NAME         URI                  GLOBAL
SylabsCloud  cloud.sylabs.io      YES
[abci]       cloud.se.abci.local  NO
[username@es1 ~]$
```

### リモートビルド

ビルドする前に、定義ファイルを作ります。以下の例では、Docker Hub から取得した Ubuntu のコンテナイメージをベースとして、追加パッケージのインストールと、 `singularity run` で起動した場合に実行するコマンドを指定しています。定義ファイルの詳細については、[Definition Files](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro35-user-guide/definition_files.html) を参照してください。

```
[username@es1 ~]$ vi ubuntu.def
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:18.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@es1 ~]$ 
```

`singularity build` コマンドに `--remote` を指定して、ubuntu.def の内容からコンテナイメージ ubuntu.sif をリモートビルドで作成します。

```
[username@es1 ~]$ singularity build  --remote ubuntu.sif ubuntu.def
INFO:    Remote "default" added.
INFO:    Authenticating with remote: default
INFO:    API Key Verified!
INFO:    Remote "default" now in use.
INFO:    Starting build...
:
:
INFO:    Build complete: ubuntu.sif
[username@es1 ~]$ 
```

動作確認として `singularity run` でコンテナイメージを起動する例です。定義ファイルで指定した `lsb_release -d` が実行されて、その結果が出力されています。

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro/3.5
[username@g0001 ~]$ singularity run ubuntu.sif
Description:	Ubuntu 18.04.5 LTS
[username@g0001 ~]$ 
```

### アクセストークンの再設定

アクセストークンを再発行した場合は、`singularity remote login` を実行して新しいアクセストークンを設定してください。既存のアクセストークンは上書きされます。

```
[username@es1 ~]$ singularity remote login abci
INFO:    Authenticating with remote: abci
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key:
INFO:    API Key Verified!
[username@es1 ~]$
```

## Container Library サービスの利用

Container Library サービスにコンテナイメージをアップロードすると、他の ABCI 利用者もダウンロードして利用できるようになります。ABCI 内でイメージを公開したい場合などに使えます。

### 仕様と制約事項

* アップロードしたコンテナイメージは、ABCI 内部からダウンロードできるようになり、アクセス制御の設定はできません(ABCI の利用者であれば誰でもアクセスできることを意味します)
* 1人あたり合計 100GiB まで保存することができます
* 現時点では、自分が所有するアップロードしたコンテナイメージの一覧を取得することはできません
* 現時点では、64MiB以上のコンテナイメージをアップロードすることはできません(リモートビルドでコンテナイメージを作成することはできます)

### Keystore サービス

Container Library サービスを利用するに先立ち、公開鍵を ABCI 内に公開するための Keystore サービスの使い方を説明します。コンテナイメージの作成者が、コンテナイメージの署名に使用した鍵の公開鍵を Keystore に登録することで、別の利用者が Container Library サービスから取得したコンテナイメージの署名を検証することが可能になります。

#### キーペアの作成

`singularity key newpair` でキーペアを作成します。

```
[username@es1 ~]$ singularity key newpair
Enter your name (e.g., John Doe) : 
Enter your email address (e.g., john.doe@example.com) : 
Enter optional comment (e.g., development keys) : 
Enter a passphrase : 
Retype your passphrase :
Would you like to push it to the keystore? [Y,n] 
Generating Entity and OpenPGP Key Pair... done
```

各入力値の説明は以下のとおりです。

| 項目 | 入力値 |
| :-- | :-- |
| Enter your name | ABCIアカウント名を入力してください |
| Enter your email address | email address となっていますが、ABCIアカウント名を入力してください |
| Enter optional comment | このキーペアにつけておきたい任意のコメントを入力します |
| Enter a passphrase | パスフレーズを決めて入力してください。コンテナイメージを署名する時などに必要になります |
| Would you like to push it to the keystore? | 公開鍵を Keystore にアップロードする場合は `Y` を入力してください |

#### キーの一覧表示

`singularity key list` を実行すると、作成したキーの情報を確認できます。

```
[username@es1 ~]$ singularity key list
Public key listing (/home/username/.singularity/sypgp/pgp-public):
:
:
   --------
7) U: username (comment) <username>
   C: 2020-06-15 03:40:05 +0900 JST
   F: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   L: 4096
   --------
[username@es1 ~]$
```

Keystore にアップロードしたキーの情報を取得するには、`singularity key search -l` に ABCIアカウント名を指定します。

```
[username@es1 ~]$ singularity key search -l username
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>

[username@es1 ~]$
```

#### Keystore へ公開鍵を登録する

キーペアの作成時に、Keystore へのアップロードを指定しなかった場合、あとからアップロードすることもできます。

!!! warning
    Keystore に登録した公開鍵を削除することはできません。

```
[username@es1 ~]$ singularity key list
0) U: username (comment) username
   C: 2020-08-08 04:28:35 +0900 JST
   F: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
   L: 4096
   --------

```

この 0 番のキーをアップロードするには、`F:` のところに表示されているフィンガープリントを `singularity key push` に指定します。

```
[username@es1 ~]$ singularity key push ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
public key `ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' pushed to server successfully

[username@es1 ~]$ singularity key search -l ABCIアカウント名
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>
```

#### Keysotre から公開鍵を取得する

Keystore に登録されている公開鍵は、ダウンロードして自分のキーリングに保存することができます。以下の例では、username2 で検索して見つけた公開鍵を保存しています。鍵につけられたコメントにマッチする文字列で探すこともできます。`singularity key pull` には、フィンガープリントを指定します。

```bash hl_lines="1 7"
[username@es1 ~]$ singularity key search -l username2
Showing 2 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  RSA        4096  2020-06-22 11:51:45 +0900 JST  [ultimate]       [enabled]  username2 (comment) <username2>

[username@es1 ~]$ singularity key pull AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
1 key(s) added to keyring of trust /home/username/.singularity/sypgp/pgp-public
[username@es1 ~]$ singularity key list
1) U: username2 (comment) <username2>
   C: 2020-08-10 11:51:45 +0900 JST
   F: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   L: 4096
   --------
[username@es1 ~]$
```

#### キーの削除

作成した鍵やダウンロードして保存した鍵は、`singularity key remove` に鍵のフィンガープリントを指定して、削除することができます。Keystore 上に保存されている公開鍵を削除することはできません。

```
[username@es1 ~]$ singularity key remove AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

### コンテナイメージのアップロード

Container Library サービスにおけるコンテナイメージの場所は、`library://ABCIアカウント名/コレクション名/コンテナイメージ名:タグ` のような URI で表されます。

ABCIアカウント名以外の構成要素は以下のとおりです。

| 項目名 | 値 |
| :-- | :-- |
| コレクション名 | コレクション名を任意の文字列で指定します |
| コンテナイメージ名 | コンテナイメージ名を任意の文字列で指定します |
| タグ | 同じコンテナイメージを識別するための文字列で、バージョンやリリース日、リビジョン番号や `latest` などの文字列でも構いません |

Container Library にアップロードする前に、コンテナイメージに署名します。
`singularity key list` で使う鍵の番号を確認し、`singularity sign` で署名します。
以下の例では 2 番の鍵を使用して、`ubuntu.sif` へ署名しています。`-k` オプションで鍵の番号を指定してください。

```bash hl_lines="1 11"
[username@es1 ~]$ singularity key list
Public key listing (/home/username/.singularity/sypgp/pgp-public):
:
:
   --------
2) U: username (comment) <username>
   C: 2020-06-15 03:40:05 +0900 JST
   F: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   L: 4096
   --------
[username@es1 ~]$ singularity sign -k 2 ./ubuntu.sif
Signing image: ./ubuntu.sif
Enter key passphrase : 
Signature created and applied to ./ubuntu.sif
```

コレクション名を `abci-lib`、 コンテナイメージ名を `helloworld`、タグとして `latest` を指定した例を以下に示します。

```
[username@es1 ~]$ singularity push ubuntu.sif library://username/abci-lib/helloworld:latest
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
 35.36 MiB / 35.36 MiB [===========================================================================================================================================================================================================] 100.00% 182.68 MiB/s 0s
[username@es1 ~]$
```

### コンテナイメージのダウンロード

Container Library に登録されているコンテナイメージは、以下のようにダウンロードできます。

```
[username@es1 ~]$ singularity pull library://username/abci-lib/helloworld:latest
INFO:    Downloading library image
 35.37 MiB / 35.37 MiB [=============================================================================================================================================================================================================] 100.00% 353.47 MiB/s 0s
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
INFO:    Download complete: helloworld_latest.sif
[username@es1 ~]$
```

この例では、署名したキーの公開鍵がローカルのキーリングに入っているため、自動的に検証が行われ、`Container is trusted` と出力されています。

ローカルのキーリングに公開鍵が格納されていない場合は、Keystore からダウンロードして追加するか、または、`singularity verify` コマンドで検証することができます。

```
[username@es1 ~]$ singularity verify helloworld_latest.sif
Container is signed by 1 key(s):

Verifying partition: FS:
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
[REMOTE]  username (comment) <username>
[OK]      Data integrity verified

INFO:    Container verified: helloworld_latest.sif
```

!!! note
    検証に失敗した場合でもコンテナイメージを実行することはできますが、検証可能なコンテナイメージの使用を推奨します。

### コンテナイメージの検索

Container Library に登録したコンテナをキーワードで検索することができます。

```
[username@es1 ~]$ singularity search hello
No users found for 'hello'

No collections found for 'hello'

Found 1 containers for 'hello'
	library://username/abci-lib/helloworld
		Tags: latest
```

### コンテナイメージの削除

Container Library サービスに push したコンテナイメージは、`singularity delete` で削除することができます。

```
[username@es1 ~]$ singularity delete library://username/abci-lib/helloworld:latest
```

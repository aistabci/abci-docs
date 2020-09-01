# ABCI Singularity エンドポイント


## 概要

ABCI Singularity エンドポイントでは、ABCI 内部向けに Singularity Container サービスを提供しています。このサービスは、Singularity で用いるコンテナイメージをリモートビルドするための Remote Builder と、作成したコンテナイメージを保管・共有するための Container Library から成ります。ABCI 内部向けのサービスであるため、外部から直接アクセスすることはできません。

!!! warning Container Library は Experimental のサービスです。特に、64MB以上のコンテナイメージをアップロードできない問題があります。

以下では、ABCI において本サービスを利用するための基本的な操作を説明します。詳細は Sylabs 社の[ドキュメント](https://sylabs.io/docs/)を参照下さい。

<!-- 削除
!!! tip
    SingularityPRO 3.5 を使って、[ローカルビルドで作成](09.md#build-a-singularity-image)することもできます。

!!! note
    ABCI 内部向けのサービスであり、外部から直接アクセスすることはできません。
 -->


## 事前準備


### モジュールのロード

本サービスを利用するため、以下のように SingularityPRO のモジュールをロードして下さい。

```
[username@es1 ~]$ module load singularitypro/3.5
```

!!! note
    Singularity 2.6.1 では本サービスを利用できません。


### アクセストークンの取得

最初に、本サービスの認証に必要なアクセストークンを取得します。
<!--ABCI の利用者は誰でも取得することができます。-->
インタラクティブノードで `get_singularity_token` コマンドを実行して下さい。発行には ABCI のパスワード (利用者ポータルへのログインに使用するパスワード) の入力が必要です。<!--計算ノードやメモリインテンシブノードでも実行できます。-->

```
[username@es1 ~]$ get_singularity_token
ABCI portal password :
just a moment, please...
  (The generated access token will be displayed.)
```

取得したアクセストークンは、この後の登録に必要になりますので、安全なところに控えておいて下さい。

!!! note
    アクセストークンは、非常に長い１行の文字列で作られているため、途中に改行などが入らないよう注意して下さい。

<!--
!!! warning
    現時点では、一度発行したアクセストークン(後述)を無効化することはできません。-->


### リモートエンドポイントの設定確認

`singularity remote list` を実行し、本サービスを提供している ABCI Singularity エンドポイント（cloud.se.abci.local）が、リモートエンドポイントとして正しく設定されていることを確認して下さい。

```
[username@es1 ~]$ singularity remote list
NAME         URI                  GLOBAL
[ABCI]       cloud.se.abci.local  YES
SylabsCloud  cloud.sylabs.io      YES
[username@es1 ~]$
```

上記は "[]" で囲まれている `ABCI` が現在のデフォルトのエンドポイントであることを示しています。

!!! note
    SylabsCloud は [Sylabs社](https://sylabs.io/) が運営するパブリックサービスのエンドポイントです。<https://cloud.sylabs.io/> にサインインし、アクセストークンを取得することで利用可能になります。
 
!!! note
    Singularity のコンテナイメージは、Singularity Global Client を用いて取得することも可能です。詳細は[こちら](tips/sregistry-cli.md)を参照下さい。


### アクセストークンの登録

ABCI Singularity エンドポイントに対して、`singularity remote login` を実行し、先に取得したアクセストークンを入力し、自身の SingularityPRO の設定ファイルに登録します。

```
[username@es1 ~]$ singularity remote login ABCI
INFO:    Authenticating with remote: ABCI
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key:
INFO:    API Key Verified!
[username@es1 ~]$
```

アクセストークンを再取得した際にも、上記コマンドを再実行し、アクセストークンを再登録して下さい。既存のアクセストークンは上書きされます。

!!! note
    現在、アクセストークンの有効期限は１ヶ月に設定されています。期限が切れた場合には再度、取得と登録を実行して下さい。


## Remote Builder の使い方

最初に、コンテナイメージをビルドするための定義ファイルを作成して下さい。以下の例では、Docker Hub から取得した Ubuntu のコンテナイメージをベースとして、追加パッケージのインストールと、コンテナを起動した際にコンテナが実行するコマンドを指定しています。定義ファイルの詳細については、[Definition Files](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro35-user-guide/definition_files.html) を参照して下さい。

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

次に、`singularity build` コマンドに `--remote` を指定して、ubuntu.def の内容からコンテナイメージ ubuntu.sif をリモートビルドで作成して下さい。

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

動作確認として `singularity run` でコンテナイメージを起動する例を以下に示します。定義ファイル内で指定した `lsb_release -d` が実行され、その結果が出力されています。

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro/3.5
[username@g0001 ~]$ singularity run ubuntu.sif
Description:	Ubuntu 18.04.5 LTS
[username@g0001 ~]$ 
```


## Container Library の使い方（Experimental）

作成したコンテナイメージを Container Library にアップロードし、他の ABCI 利用者に公開することができます。1人あたり、合計 100GiB までアップロードして保存することができます。

!!! note
    Container Library にアップロードしたコンテナイメージに対して、アクセス制御の設定はできません。つまり、ABCIの利用者であれば誰でもアクセス可能になりますので、アップロードするイメージが適切なものであるか十分に確認して下さい。


### 現在の制約事項
* 64MiB以上のコンテナイメージをアップロードすることはできません。リモートビルドでコンテナイメージを作成することはできます。
* アップロードしたコンテナイメージの一覧を取得することはできません。


### コンテナイメージの署名鍵の作成と登録

Container Library へコンテナイメージをアップロードして、ABCI 内に公開する場合には、事前に鍵ペアを作成し、KeyStore に公開鍵を登録して下さい。コンテナイメージの作成者は、秘密鍵を用いてコンテナイメージに署名し、コンテナイメージの利用者は KeyStore に登録されている公開鍵を用いてその署名を検証することが可能です。


#### 鍵ペアの作成

`singularity key newpair` により鍵ペアを作成します。

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
| Enter your name | ABCIアカウント名を入力してください。 |
| Enter your email address | email address となっていますが、ABCIアカウント名を入力して下さい。 |
| Enter optional comment | この鍵ペアにつけておきたい任意のコメントを入力します。 |
| Enter a passphrase | パスフレーズを決めて入力して下さい。コンテナイメージを署名する時などに必要になります。 |
| Would you like to push it to the keystore? | 公開鍵を Keystore にアップロードする場合は `Y` を入力して下さい。 |

!!! warning
    鍵ペアを2つ以上生成すると、意図どおりに動作しないケースがあります。現時点では 1 つだけ生成するようにして下さい。


#### 鍵の一覧表示

`singularity key list` を実行すると、作成した鍵情報を確認できます。

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

Keystore に登録されている鍵情報を取得するには、`singularity key search -l` に ABCIアカウント名を指定します。

```
[username@es1 ~]$ singularity key search -l username
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>

[username@es1 ~]$
```


#### Keystore への公開鍵の登録

鍵ペアの作成時に、Keystore へのアップロードを指定しなかった場合、あとからアップロードすることもできます。

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

この 0 番の公開鍵をアップロードするには、`F:` のところに表示されているフィンガープリントを `singularity key push` に指定します。

```
[username@es1 ~]$ singularity key push ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
public key `ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' pushed to server successfully

[username@es1 ~]$ singularity key search -l ABCIアカウント名
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>
```


#### Keysotre に登録されている公開鍵の取得

Keystore に登録されている公開鍵は、ダウンロードして自分の鍵リングに保存することができます。以下の例では、username2 で検索して見つけた公開鍵をダウンロードして、保存しています。鍵につけられたコメントにマッチする文字列を指定して検索することもできます。`singularity key pull` には、フィンガープリントを指定します。

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


#### 鍵の削除

作成した鍵やダウンロードして保存した鍵は、`singularity key remove` に鍵のフィンガープリントを指定して、削除することができます。Keystore に登録された公開鍵を削除することはできません。

```
[username@es1 ~]$ singularity key remove AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```


### コンテナイメージのアップロード

Container Library におけるコンテナイメージの場所は、`library://ABCIアカウント名/コレクション名/コンテナイメージ名:タグ` の URI で指定します。

ABCIアカウント名以外の構成要素は以下のとおりです。

| 項目名 | 値 |
| :-- | :-- |
| コレクション名 | コレクション名を任意の文字列で指定します。 |
| コンテナイメージ名 | コンテナイメージ名を任意の文字列で指定します。 |
| タグ | 同じコンテナイメージを識別するための文字列です。バージョンやリリース日、リビジョン番号や `latest` などの文字列で指定します。 |

Container Library にアップロードする前に、コンテナイメージに署名します。
`singularity key list` で鍵の番号を確認し、`singularity sign` で署名します。
`-k` オプションで鍵の番号を指定して下さい。以下の例では 2 番の鍵を使用して、`ubuntu.sif` へ署名しています。

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

コレクション名を `abci-lib`、 コンテナイメージ名を `ubuntu`、タグとして `latest` を指定した例を以下に示します。

```
[username@es1 ~]$ singularity push ubuntu.sif library://username/abci-lib/ubuntu:latest
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
 35.36 MiB / 35.36 MiB [===========================================================================================================================================================================================================] 100.00% 182.68 MiB/s 0s
[username@es1 ~]$
```


### コンテナイメージのダウンロード

Container Library にアップロードされたコンテナイメージは、以下のようにダウンロードできます。

```
[username@es1 ~]$ singularity pull library://username/abci-lib/ubuntu:latest
INFO:    Downloading library image
 35.37 MiB / 35.37 MiB [=============================================================================================================================================================================================================] 100.00% 353.47 MiB/s 0s
INFO:    Download complete: ubuntu_latest.sif
[username@es1 ~]$
```

署名が検証できない場合は、以下のような WARNING メッセージが出力されますが、ダウンロードは行われます。

```
WARNING: Skipping container verification
```

ダウンロードした後に `singularity verify` を使って署名を検証することもできます。
以下の例では、Keystore に登録されている公開鍵で署名が検証されています。自分の鍵リングに登録されている公開鍵で検証された場合は、`REMOTE` ではなく `LOCAL` と出力されます。検証できなかった場合は WARNING メッセージが出力されます。

```
[username@es1 ~]$ singularity verify ubuntu_latest.sif
Verifying image: ubuntu_latest.sif
[REMOTE]  Signing entity: username (comment) <username>
[REMOTE]  Fingerprint: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Objects verified:
ID  |GROUP   |LINK    |TYPE
------------------------------------------------
1   |1       |NONE    |Def.FILE
2   |1       |NONE    |JSON.Generic
3   |1       |NONE    |FS
Container verified: ubuntu_latest.sif
```

!!! note
    検証に失敗した場合でもコンテナイメージを実行することはできますが、検証可能なコンテナイメージの使用を推奨します。


### コンテナイメージの検索

Container Library にアップロードされたコンテナイメージをキーワードで検索することができます。

```
[username@es1 ~]$ singularity search hello
No users found for 'hello'

No collections found for 'hello'

Found 1 containers for 'hello'
	library://username/abci-lib/helloworld
		Tags: latest
```


### コンテナイメージの削除

Container Library にアップロードされたコンテナイメージは、`singularity delete` で削除することができます。

```
[username@es1 ~]$ singularity delete library://username/abci-lib/helloworld:latest
```

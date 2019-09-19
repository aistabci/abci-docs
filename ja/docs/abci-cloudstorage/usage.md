# ABCIクラウドストレージの使い方

ここでは、クライアントツールとして AWS Command Line Interface (以降、AWS CLI) を用いたクラウドストレージの利用方法を説明します。

<!-- クラウドストレージアカウントの命名規則(xxxx.1, xxxx.2, ....)については、今のところ説明しない  -->


## モジュールのロード

モジュールをロードします。AWS CLI はインタラクティブノードでも計算ノードでも利用できます。

```
[username@es1 ~]$ module load aws-cli
```


## 認証情報などの設定

ABCIクラウドストレージへのアクセスは、ABCIアカウントとは別のクラウドストレージアカウントを用います。アカウントは複数持つことができ、それぞれにアクセスキー(アクセスキー ID とシークレットアクセスキーのペア)が対応しています。初回は次のように、そのアクセスキーを AWS CLI に設定する作業が必要です。region name には、 `us-east-1` を設定してください。
```
[username@es1 ~]$ aws configure
AWS Access Key ID [None]: ACCESS-KEY-ID
AWS Secret Access Key [None]: SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(入力不要)
```

複数のクラウドストレージアカウントを所持している場合は、--profile オプションを使用することで使い分けることができます。
例えば、クラウドストレージアカウント aaa00000.2 を別に登録する場合は、以下のように設定します。
```
[username@es1 ~]$ aws configure --profile aaa00000.2
AWS Access Key ID [None]: aaa00000.2's ACCESS-KEY-ID
AWS Secret Access Key [None]: aaa00000.2's SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(入力不要)
```

クラウドストレージアカウント aaa00000.2 で aws コマンドを実行するときは、以下のように --profile オプションで指定します。
```
[username@es1 ~]$  aws --profile aaa00000.2 --endpoint-url https://s3.abci.ai s3api list-buckets
```

設定はホームディレクトリ(~/.aws)に保存されるため、インタラクティブノードで設定していれば、計算ノードで改めて行う必要はありません。

## 各種操作

バケットの作成やデータのアップロードなどの基本操作について説明します。

### 基本事項

各種操作を行うにあたって、以下の基本事項を理解しておく必要があります。

AWS CLI の構文は
```
aws [options] <command> <subcommand> [parameters]
```
のようになっており、例えば `aws --endpoint-url https://s3.abci.ai s3 ls` は、s3 が &lt;command&gt; で、ls は &lt;subcommand&gt; (s3 コマンドの ls コマンド、あるいは s3 ls コマンド)です。

s3 コマンドでは、オブジェクトのパスを S3 URI で表します。
例えば

```
s3://bucket-1/project-1/docs/fig1.png
```

では、`bucket-1` がバケット名、`project-1/docs/fig1.png` がオブジェクトキー（またはキー名)です。`project-1/docs/` の部分はプレフィックスと呼ばれ、オブジェクトキーを疑似階層的に（いわゆるファイルシステムにおける "フォルダ" の下に入っているかのように）表現するために使われます。

バケット名は以下の規約があります。

* クラウドストレージ全体で一意である必要があります。
* 3～63文字で定義する必要があります。
* '\_'(アンダースコア)を含めることはできません。
* 先頭は小文字の英数字を指定する必要があります。
* IPアドレス(例えば192.168.0.1)のような形式は使用できません。
* '.'(ピリオド)は問題になる場合があります。使用しないことを推奨します。

オブジェクトキーには、UTF-8 文字も使うことはできますが、アスキーコードの範囲であっても、避けた方が良い特殊文字があります。

* `-` (ハイフンマイナス)、`_` (アンダースコア)、`.`(ドット)は問題なく扱えます
* `!` `*` `'` `(` `)` (エクスクラメーションマーク、アスタリスク、アポストロフィ(0x27)、左括弧、右括弧)、これら5つは、例えばシェルにおいてはエスケープしたりクォートするなど正しく扱っているならば、問題ありません

上記以外の特殊文字(例えば `<` や `#` など)は、避けた方が安全です。

エンドポイント(--endpoint-url)には、`https://s3.abci.ai` を指定してください。インタラクティブノード、および計算ノードからは、`http://s3.abci.ai` を使うこともできます。 


### バケットの作成

s3 mb コマンドでバケットを作成します。
例として、'dataset-summer-2012' というバケットを作るには、以下のように aws コマンドを実行します。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mb s3://dataset-summer-2012
make_bucket: dataset-summer-2012
```


### バケットの一覧表示

所属するABCIグループ内で作成されたバケットの一覧をリストするには、 `aws --endpoint-url https://s3.abci.ai/ s3 ls` を実行します。

実行例
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 ls
2019-06-15 10:47:37 testbucket1
2019-06-15 18:10:37 testbucket2
```


### オブジェクトのリスト

バケット入っているオブジェクトをリストするには、 `aws --endpoint-url https://s3.abci.ai/ s3 ls s3://bucket-name` を実行します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 ls s3://mybucket
                           PRE pics/
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
```

例えば pics/ というプレフィックスを持つデータをリストするには、バケット名の後ろにプレフィックスをつけます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 ls s3://mybucket/pics/
2019-07-29 21:55:57    1048576 test3.png
2019-07-29 21:55:59    1048576 test4.png
```

`--recursive` オプションを使い、バケット内の全オブジェクトをリストすることもできます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 ls s3://mybucket --recursive
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
2019-07-29 21:55:57    1048576 pics/test3.png
2019-07-29 21:55:59    1048576 pics/test4.png
```


### データのコピー(アップロード、ダウンロード、コピー)

ファイルシステム上からABCIクラウドストレージ上のバケットへ、クラウドストレージ上のバケットからファイルシステム上へ、またはABCIクラウドストレージ上のバケットからABCIクラウドストレージ上のバケットへデータをコピーできます。

0001.jpg というファイルを dataset-c0541 バケットにコピー
```
[username@es1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp ./images/0001.jpg s3://dataset-c0541/
upload: images/0001.jpg to s3://dataset-c0541/0001.jpg
[username@es1 ~]$
```

images ディレクトリの中身を dataset-c0542 バケットにコピー
```
[username@es1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp images s3://dataset-c0542/ --recursive
upload: images/0001.jpg to s3://dataset-c0542/0001.jpg
upload: images/0002.jpg to s3://dataset-c0542/0002.jpg
upload: images/0003.jpg to s3://dataset-c0542/0003.jpg
upload: images/0004.jpg to s3://dataset-c0542/0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://dataet-c0542/
2019-06-10 19:03:19    1048576 0001.jpg
2019-06-10 19:03:19    1048576 0002.jpg
2019-06-10 19:03:19    1048576 0003.jpg
2019-06-10 19:03:19    1048576 0004.jpg
[username@es1 ~]$
```

dataset-tmpl-c0000 バケットから dataset-c0541 バケットへ logo.png をコピー
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp s3://dataset-tmpl-c0000/logo.png s3://dataset-c0541/logo.png
copy: s3://dataset-tmpl-c0000/logo.png to s3://dataset-c0541/logo.png
```


### データの移動

オブジェクトを移動するには aws mv を使用します。
バケット間の移動の他、ローカルからバケット、バケットからローカルへ移動を行えます。
タイムスタンプは保持されません。
--recursive オプションの付与で特定のプレフィックスを持つオブジェクト、
または特定のディレクトリに入っているファイルを対象として扱えます。

次の例では、カレントディレクトリにある annotations.zip をクラウドストレージ上の dataset-c0541 バケットに移動を行っています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mv annotations.zip s3://dataset-c0541/
move: ./annotations.zip to s3://dataset-c0541/annotations.zip
```

次の例は、dataset-c0541 バケットの sensor-1 プレフィックスをもつオブジェクトをまとめて dataset-c0542 バケットに移動させています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 mv s3://dataset-c0541/sensor-1/ s3://dataset-c0542/sensor-1/ --recursive
move: s3://dataset-c0541/sensor-1/0001.dat to s3://dataset-c0542/sensor-1/0001.dat
move: s3://dataset-c0541/sensor-1/0003.dat to s3://dataset-c0542/sensor-1/0003.dat
move: s3://dataset-c0541/sensor-1/0004.dat to s3://dataset-c0542/sensor-1/0004.dat
move: s3://dataset-c0541/sensor-1/0002.dat to s3://dataset-c0542/sensor-1/0002.dat
```


### オブジェクトの削除

オブジェクトの削除は `aws s3 rm <S3Uri> [parameters]` で行います。

実行例 
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rm s3://mybucket/readme.txt
delete: s3://mybucket/readme.txt
```

--recursive パラメータを使うことで、指定のプレフィックス以下のオブジェクトを削除できます。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
2019-07-31 14:51:50        512 xml/c.xml
2019-07-31 14:51:54        512 xml/d.xml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rm s3://mybucket/xml --recursive
delete: s3://mybucket/xml/c.xml
delete: s3://mybucket/xml/d.xml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
```


### バケットの削除

dataset-c0541 バケットを削除する例です。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3 rb s3://dataset-c0541
remove_bucket: dataset-c0541
```

空でないバケットを削除しようとするとエラーが返されますが、中身も全部消してしまって良ければ --force をつけると中身を消した上でバケットを削除してくれます。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ rb s3://dataset-c0542 --force
delete: s3://dataset-c0542/0001.jpg
delete: s3://dataset-c0542/0002.jpg
delete: s3://dataset-c0542/0003.jpg
delete: s3://dataset-c0542/0004.jpg
remove_bucket: dataset-c0542
```


<!--  aws s3 mv を追記  -->

<!--  aws s3 sync は後で追記。同一サイズの場合の注意点を書く  -->

<!--  ACL(not IAM policy)の記述は今保留中  -->


## バケットの暗号化機能

保存する前にサーバ側でオブジェクトを自動的に暗号化する(サーバーサイド暗号化)バケットを作成することができます。


### 暗号化を有効にしたバケットの作成

サーバーサイド暗号化を有効にしたバケットを作るには、awsコマンドではなく、ABCI環境に用意されている create-encrypted-bucket コマンドを実行します。
例えば、'dataset-c0543' というバケットを作る場合は以下のように実行します。

```
[username@es1 ~]$ create-encrypted-bucket --endpoint-url https://s3.abci.ai s3://dataset-c0543
create-encrypted-bucket Success.
```

!!! note
    サーバー側が保持する鍵を用いて、サーバー上でオブジェクトを保存する時に暗号化(読み出す時に復号化)するもので、アクセスキーなど送信リクエスト固有の情報で暗号化するものではありません。

!!! note
    暗号化を有効にしていないバケットを、後から暗号化を有効にすることはできません。


### 暗号化を有効にしたバケットかどうかの判別

サーバーサイド暗号化を有効にしたバケットかどうかを判別するには、オブジェクトのメタデータを確認する必要があるため、空のバケットでは確認できません。空の場合は、なにかオブジェクトを1つ作成してください。

`aws s3api head-object` で確認します。
以下では、dataset-c0543 バケットの cat.jpg というオブジェクトのメタデータを確認しています。 `"ServerSideEncryption": "AES256"` という情報が含まれているため、dataset-c0543 は暗号化を有効にしたバケットです。この情報が含まれていない場合は、暗号化を指定されなかったバケットです。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai/ s3api head-object --bucket dataset-c0543 --key cat.jpg
{
    "LastModified": "Tue, 30 Jul 2019 09:34:18 GMT",
    "ContentLength": 1048576,
    "ETag": "\"c951191fe4fa27c0d054a8456c6c20d1\"",
    "ServerSideEncryption": "AES256",
    "Metadata": {}
}
```


<!-- CSE?  -->

<!--  s3fs-fuse は別?  -->

<!--  使い方の説明はしないが Cyberduck と WinSCP について触れる  -->



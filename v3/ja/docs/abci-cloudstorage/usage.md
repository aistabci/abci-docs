# ABCIクラウドストレージの使い方

## aws-cli セットアップ手順

aws-cliはインタラクティブノードにインストール済みです。
クラウドストレージにアクセスするために以下の手順を参考にs3cmdコマンドの設定を行ってください。

## 認証情報などの設定

ABCIクラウドストレージへのアクセスは、ABCIアカウントとは別のクラウドストレージアカウントを用います。
アカウントは複数持つことができ、それぞれにアクセスキー(アクセスキー ID とシークレットアクセスキーのペア)が対応しています。
複数のABCIグループに所属しており、それぞれクラウドストレージを利用している場合は、それぞれのクラウドストレージアカウントが発行されます。
初回は次のように、そのアクセスキーを AWS CLI に設定する作業が必要です。region name には、 ap-northeast-1 を設定してください。
```
[username@login1 ~] $ aws configure
AWS Access Key ID [None]: <受信したAccess Key>
AWS Secret Access Key [None]: <受信したSecret Key>
Default region name [None]: ap-northeast-1
Default output format [None]:(入力不要)
```

複数のクラウドストレージアカウントを所持している場合は、--profile オプションを使用することで使い分けることができます。 
例えば、クラウドストレージアカウント aaa00000.2 を別に登録する場合は、以下のように設定します。
```
[username@login1 ~]$ aws configure --profile aaa00000.2
AWS Access Key ID [None]: aaa00000.2's ACCESS-KEY-ID
AWS Secret Access Key [None]: aaa00000.2's SECRET-ACCESS-KEY
Default region name [None]: ap-northeast-1
Default output format [None]:(入力不要)
```

クラウドストレージアカウント aaa00000.2 で aws コマンドを実行するときは、以下のように --profile オプションで指定します。
```
[username@login1 ~]$  aws --profile aaa00000.2 --endpoint-url https://s3.v3.abci.ai s3api list-buckets
```

設定はホームディレクトリ(~/.aws)に保存されるため、インタラクティブノードで設定していれば、計算ノードで改めて行う必要はありません。

アクセスキーの再発行や削除は、ABCI利用者ポータルから行います。

## 各種操作

バケットの作成やデータのアップロードなどの基本操作について説明します。

### 基本事項

各種操作を行うにあたって、以下の基本事項を理解しておく必要があります。

AWS CLI の構文は
```
aws [options] <command> <subcommand> [parameters]
```
のようになっており、例えば `aws --endpoint-url https://s3.v3.abci.ai s3 ls` は、s3 が &lt;command&gt; で、ls は &lt;subcommand&gt; (s3 コマンドの ls コマンド、あるいは s3 ls コマンド)です。

s3 コマンドでは、オブジェクトのパスを S3 URI で表します。
例えば

```
s3://bucket-1/project-1/docs/fig1.png
```

では、`bucket-1` がバケット名、`project-1/docs/fig1.png` がオブジェクトキー（またはキー名)です。`project-1/docs/` の部分はプレフィックスと呼ばれ、オブジェクトキーを疑似階層的に（いわゆるファイルシステムにおける "フォルダ" の下に入っているかのように）表現するために使われます。

バケット名は以下の規約があります。

* クラウドストレージ全体で一意である必要があります
* 3～63文字で定義する必要があります
* '\_'(アンダースコア)を含めることはできません
* 先頭は小文字の英数字を指定する必要があります
* IPアドレス(例えば192.168.0.1)のような形式は使用できません
* '.'(ピリオド)は問題になる場合があります。使用しないことを推奨します

オブジェクトキーには、UTF-8 文字も使うことはできますが、アスキーコードの範囲であっても、避けた方が良い特殊文字があります。

* `-` (ハイフンマイナス)、`_` (アンダースコア)、`.`(ドット)は問題なく扱えます
* `!` `*` `'` `(` `)` (エクスクラメーションマーク、アスタリスク、アポストロフィ(0x27)、左括弧、右括弧)、これら5つは、例えばシェルにおいてはエスケープしたりクォートするなど正しく扱っているならば、問題ありません

上記以外の特殊文字(例えば `<` や `#` など)は、避けた方が安全です。

エンドポイント(--endpoint-url)には、`https://s3.v3.abci.ai` を指定してください。


### バケットの作成

s3 mb コマンドでバケットを作成します。 例として、'dataset-summer-2012' というバケットを作るには、以下のように aws コマンドを実行します。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mb s3://dataset-summer-2012
make_bucket: dataset-summer-2012
```


### バケットの一覧表示

所属するABCIグループ内で作成されたバケットの一覧をリストするには、 `aws --endpoint-url https://s3.v3.abci.ai s3 ls` を実行します。

実行例
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls
2025-06-15 10:47:37 testbucket1
2025-06-15 18:10:37 testbucket2
```


### オブジェクトのリスト

バケット入っているオブジェクトをリストするには、 `aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://bucket-name` を実行します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket
                           PRE pics/
2025-06-05 17:33:05          4 test1.txt
2025-06-05 21:12:47          4 test2.txt
```

例えば pics/ というプレフィックスを持つデータをリストするには、バケット名の後ろにプレフィックスをつけます。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket/pics/
2025-06-07 21:55:57    1048576 test3.png
2025-06-07 21:55:59    1048576 test4.png
```

`--recursive` オプションを使い、バケット内の全オブジェクトをリストすることもできます。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2025-06-05 17:33:05          4 test1.txt
2025-06-05 21:12:47          4 test2.txt
2025-06-07 21:55:57    1048576 pics/test3.png
2025-06-07 21:55:59    1048576 pics/test4.png
```

### データのコピー(アップロード、ダウンロード、コピー)

ファイルシステム上からABCIクラウドストレージ上のバケットへ、クラウドストレージ上のバケットからファイルシステム上へ、
またはABCIクラウドストレージ上のバケットからABCIクラウドストレージ上のバケットへデータをコピーできます。

0001.jpg というファイルを dataset-c0541 バケットにコピー
```
[username@login1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp ./images/0001.jpg s3://dataset-c0541/
upload: images/0001.jpg to s3://dataset-c0541/0001.jpg
[username@login1 ~]$
```

images ディレクトリの中身を dataset-c0542 バケットにコピー
```
[username@login1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp images s3://dataset-c0542/ --recursive
upload: images/0001.jpg to s3://dataset-c0542/0001.jpg
upload: images/0002.jpg to s3://dataset-c0542/0002.jpg
upload: images/0003.jpg to s3://dataset-c0542/0003.jpg
upload: images/0004.jpg to s3://dataset-c0542/0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://dataet-c0542/
2025-06-10 19:03:19    1048576 0001.jpg
2025-06-10 19:03:19    1048576 0002.jpg
2025-06-10 19:03:19    1048576 0003.jpg
2025-06-10 19:03:19    1048576 0004.jpg
[username@login1 ~]$
```

dataset-tmpl-c0000 バケットから dataset-c0541 バケットへ logo.png をコピー
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://dataset-tmpl-c0000/logo.png s3://dataset-c0541/logo.png
copy: s3://dataset-tmpl-c0000/logo.png to s3://dataset-c0541/logo.png
```

### データの移動

オブジェクトを移動するには aws mv を使用します。 バケット間の移動の他、ローカルからバケット、バケットからローカルへ移動を行えます。 
タイムスタンプは保持されません。`--recursive` オプションの付与で特定のプレフィックスを持つオブジェクト、 または特定のディレクトリに入っているファイルを対象として扱えます。

次の例では、カレントディレクトリにある annotations.zip をクラウドストレージ上の dataset-c0541 バケットに移動を行っています。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mv annotations.zip s3://dataset-c0541/
move: ./annotations.zip to s3://dataset-c0541/annotations.zip
```

次の例は、dataset-c0541 バケットの sensor-1 プレフィックスをもつオブジェクトをまとめて dataset-c0542 バケットに移動させています。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mv s3://dataset-c0541/sensor-1/ s3://dataset-c0542/sensor-1/ --recursive
move: s3://dataset-c0541/sensor-1/0001.dat to s3://dataset-c0542/sensor-1/0001.dat
move: s3://dataset-c0541/sensor-1/0003.dat to s3://dataset-c0542/sensor-1/0003.dat
move: s3://dataset-c0541/sensor-1/0004.dat to s3://dataset-c0542/sensor-1/0004.dat
move: s3://dataset-c0541/sensor-1/0002.dat to s3://dataset-c0542/sensor-1/0002.dat
```

### ローカルディレクトリとクラウドストレージの同期

以下の例では、カレントディレクトリにある sensor2 というディレクトリと mybucket というバケットを同期させています。
--delete オプションをつけていなければバケットにあった既存のオブジェクトは削除されませんが、同名のものは上書きされます。
次に同じコマンドラインを実行すると、更新されたファイルのみ送ります。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 sync ./sensor2 s3://mybucket/
upload: sensor2/0002.dat to s3://mybucket/0002.dat
upload: sensor2/0004.dat to s3://mybucket/0004.dat
upload: sensor2/0001.dat to s3://mybucket/0001.dat
upload: sensor2/0003.dat to s3://mybucket/0003.dat
```

sensor3 バケットの rev1 プレフィックスをもつオブジェクトを testdata ディレクトリに同期する例です。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 sync s3://sensor3/rev1/ testdata
download: s3://sensor3/rev1/0001.zip to testdata/0001.zip
download: s3://sensor3/rev1/0004.zip to testdata/0004.zip
download: s3://sensor3/rev1/0003.zip to testdata/0003.zip
download: s3://sensor3/rev1/0002.zip to testdata/0002.zip
```

!!! note
    次回にこのコマンドラインを実行した際、バケットに入っているデータが更新されていても、サイズが全く同じ場合は再取得の対象となりません。その場合、--exact-timestamps オプションをつけることで対象とすることができますが、ABCI環境の場合はこのオプションを指定すると、すべてのオブジェクトが再取得の対象となります。


### オブジェクトの削除

オブジェクトの削除は `aws s3 rm <S3Uri> [parameters]` で行います。

実行例
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rm s3://mybucket/readme.txt
delete: s3://mybucket/readme.txt
```

--recursive パラメータを使うことで、指定のプレフィックス以下のオブジェクトを削除できます。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2025-06-30 20:46:53         32 a.txt
2025-06-30 20:46:53         32 b.txt
2025-06-31 14:51:50        512 xml/c.xml
2025-06-31 14:51:54        512 xml/d.xml

[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rm s3://mybucket/xml --recursive
delete: s3://mybucket/xml/c.xml
delete: s3://mybucket/xml/d.xml

[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2025-06-30 20:46:53         32 a.txt
2025-06-30 20:46:53         32 b.txt
```


### バケットの削除

dataset-c0541 バケットを削除する例です。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rb s3://dataset-c0541
remove_bucket: dataset-c0541
```

空でないバケットを削除しようとするとエラーが返されますが、中身も全部消してしまって良ければ --force をつけると中身を消した上でバケットを削除してくれます。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai rb s3://dataset-c0542 --force
delete: s3://dataset-c0542/0001.jpg
delete: s3://dataset-c0542/0002.jpg
delete: s3://dataset-c0542/0003.jpg
delete: s3://dataset-c0542/0004.jpg
remove_bucket: dataset-c0542
```

### オブジェクトの所有者の確認

オブジェクトの所有者は、`s3api get-object-acl` コマンドで確認することができます。
以下の例のようにオブジェクトを格納するバケットを BUCKET、オブジェクトの名前を OBJECT として、Owner で示される ABCIGROUP がオブジェクトを所有していることがわかります。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket BUCKET --key OBJECT 

    "Owner": {
        "DisplayName": "ABCIGROUP",
        "ID": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "ABCIGROUP",
                "ID": "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```

### マルチパートアップロード（MPU）について

AWS CLIは、データを自動的に分割して並行に送信することで、効率良くデータをアップロードする機能を備えています。
これはマルチパートアップロード (MPU) と呼ばれています。MPU が有効であるかどうかは、クライアントツールやその設定に依存します。AWS CLI では、
MPU が有効となるデータサイズは、デフォルトで 8MB と定義されています。

### マルチパートアップロードを手動で有効にする方法

AWS CLI では、データサイズに応じて MPU が自動的に有効になりますが、以下の方法を用いることで MPU を有効にすることもできます。

まず、`split` コマンドなどでアプロードしたいデータを分割します。以下の例では、 15M_test.dat を 3つに分割しています。

```
[username@login1 ~]$ split  -n 3 -d 15M_test.dat mpu_part-
total 3199056
-rw-r----- 1 username group   15728640 Nov 30 15:42 15M_test.dat
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-02
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-01
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-00
[username@login1 ~]$
```

次に、コマンド `s3api create-multipart-upload` でアップロード先のバケットとパスを指定して、 MPU を開始します。
アップロード先は、バケットを `--bucket`、パスを `--key` で指定します。以下の例は、バケット 'testbucket-00' に'mpu-sample' というオブジェクトを作成します。
成功すると、以下のように `UploadId` が発行されます。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api create-multipart-upload --bucket testbucket-00 --key mpu-sample

{
    "Bucket": "testbucket-00",
    "Key": "mpu-sample",
    "UploadId": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

} 
```

これらのデータを `s3api part-upload` コマンドでアップロードします。この時、上記の UpLoadId を指定してください。コマンドが成功すると表示される 'ETag' は後で使用するため控えておいてください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 1 --body mpu_part-00 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"sample1d8560e70ca076c897e0715024\""
}
```

同様に、順次 `--part-number` の値と対応するデータを指定して残りのデータもアップロードします。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 2 --body mpu_part-01 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"samplee36a6ef6ae8f2c0ea3328c5e7c\""
}
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 3 --body mpu_part-02 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"sample9e391d5673d2bfd8951367eb01\""
}
[username@login1 ~]$
```

!!! note
    s3api upload-parts でアップロードされたデータは表示されませんが課金対象になります。 このため、MPU は必ずアップロードを完了させるか中止してください。

全てのデータをアップロードしたら、ETag の値を以下のような JSONE 形式のファイルにまとめます。
```
[username@login1 ~]$ cat mpu_fileparts.json
{
    "Parts":[{
        "ETag": "sample1d8560e70ca076c897e0715024",
        "PartNumber": 1
    },
    {
        "ETag": "samplee36a6ef6ae8f2c0ea3328c5e7c",
        "PartNumber": 2
    },
    {
        "ETag": "sample9e391d5673d2bfd8951367eb01",
        "PartNumber": 3
    }]
}
```

最後に、`s3api complete-multipart-upload` コマンドを使用して MPU を完了させます。このタイミングで `--key` で指定したオブジェクトが作成されます。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api complete-multipart-upload --multipart-upload file://mpu_fileparts.json --bucket testbucket-00 --key mpu-sample --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "Location": "http://testbucket-00.s3.v3.abci.ai/mpu-sample",
    "Bucket": "testbucket-00",
    "Key": "mpu-sample",
    "ETag": "\"6203f5cdbecbe0556e2313691861cb99-3\""
}
```
オブジェクトが作成されていることを確認します。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://testbucket-00/
2020-12-01 09:28:03   15728640 mpu-sample
```

### MPU の中止 {#abort-mpu}

実行中の MPU を中止するには、まず MPU の一覧を表示し、`UploadId` と `Key` を確認します。 MPU の一覧は、`s3api list-multipart-uploads` コマンドにアップロード時のバケットを指定して、確認することができます。MPU が残っていない場合は何も表示されません。 以下の例では、オブジェクト data_10gib-1.dat を s3://BUCKET/Testdata/ にアップロードする途中であることが確認できます。`Key` にはバケットより下のパスとオブジェクト名が表示されています。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api list-multipart-uploads --bucket BUCKET
{
    "Uploads": [
        {
            "UploadId": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            "Key": "Testdata/data_10gib-1.dat",
            "Initiated": "2025-11-12T09:58:16.242000+00:00",
            "StorageClass": "STANDARD",
            "Owner": {
                "DisplayName": "ABCI GROUP",
                "ID": "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
            },
            "Initiator": {
                "ID": "arn:aws:iam::123456789123:user/USERNAME",
                "DisplayName": "USERNAME"
            }
        }
    ]
}
```

次に、MPU の中止を実行します。以下に示すように MPU の中止は、`s3api abort-multipart-upload` コマンドの引数に、中止したい MPU の `UploadId` と `Key` を指定します。コマンドが成功すると、プロンプトが返ります。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api abort-multipart-upload --bucket Bucket --key Testdata/data_10gib-1.dat --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
[username@login1 ~]$
```

これで MPU の中止は完了です。MPU の実行中にサーバ側に作成されたデータも削除されます。

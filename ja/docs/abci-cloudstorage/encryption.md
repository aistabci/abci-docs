
# データの暗号化

## 暗号化機能の概要

クラウド向けのストレージにおいては、一般的に、クライアント側で暗号化する CSE（Client-Side Encryption）とサーバ側で暗号化する SSE（Server-Side Encryption）があります。SSEはストレージ側での機能提供が必要であり、ABCIクラウドストレージではSSE機能をサポートしています。

SSE機能を利用すると、データがサーバーに送られた後、ディスクに保存される前に暗号化が行われます。データを取得する時には、ディスクから取り出された後に復号化が行われ、サーバーからデータが送られてきます。SSEでは、送信経路上ではデータが復号化されていますが、ABCIクラウドストレージでは、エンドポイントに https://s3.abci.ai を指定することでTLSによる通信の暗号化が別途行われます。

Amazon S3 では以下のような SSE が提供されていますが、ABCIクラウドストレージでは、SSE-S3 に相当する SSE を提供しています。ただし、Amazon S3 の SSE-S3 と厳密には異なるため、同じ API を用いた操作はできません。また、SSE-C と SSE-KMS もABCIクラウドストレージでは利用できません。

| SSEの種類 | 説明 |
| :-- | :-- |
| SSE-S3 | ストレージ側で管理された鍵を用いて暗号化 |
| SSE-C | ユーザーがリクエストに含めた鍵を用いて暗号化 |
| SSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |

一方、ABCIクラウドストレージではCSEの利用は可能です。ただし、ABCIではKMS(Key Management Service)を提供していませんので、ご注意ください。
CSEの説明は、[Protecting Data Using Client-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingClientSideEncryption.html) などをご参照ください。

| CSEの種類 | 説明 |
| :-- | :-- |
| CSE-C | ユーザーがクライアント側で管理している鍵を用いて暗号化 |
| CSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |


## 暗号化を有効にしたバケットの作成

SSE を有効にしたバケットを作るには、awsコマンドではなく、ABCI環境に用意されている create-encrypted-bucket コマンドを実行します。
例えば、'dataset-s0001' というバケットを作る場合は以下のように実行します。

```
[username@es1 ~]$ create-encrypted-bucket --endpoint-url https://s3.abci.ai s3://dataset-s0001
create-encrypted-bucket Success.
```

!!! note
    ストレージ側が保持する鍵を用いて、サーバー上でオブジェクトを保存する時に暗号化（読み出す時には復号化）するもので、アクセスキーなど送信リクエスト固有の情報で暗号化するものではありません。

!!! note
    暗号化を有効にしていないバケットに対して、後から暗号化を有効にする方法は提供されていません。


## 暗号化を有効にしたバケットかどうかの判別

SSEを有効にしたバケットかどうかを判別するには、オブジェクトのメタデータを確認する必要があるため、空のバケットでは確認できません。空の場合は、なにかオブジェクトを1つ作成してください。

確認は `aws s3api head-object` で行います。
以下では、dataset-s0001 バケットにアップロードした cat.jpg というオブジェクトのメタデータを確認しています。 `"ServerSideEncryption": "AES256"` という情報が含まれているため、dataset-s0001 は暗号化を有効にしたバケットであるといえます。この情報が含まれていない場合は、暗号化が有効でないバケットであることを示しています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api head-object --bucket dataset-s0001 --key cat.jpg
{
    "LastModified": "Tue, 30 Jul 2019 09:34:18 GMT",
    "ContentLength": 1048576,
    "ETag": "\"c951191fe4fa27c0d054a8456c6c20d1\"",
    "ServerSideEncryption": "AES256",
    "Metadata": {}
}
```

<!-- CSE? -->

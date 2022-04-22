
# データの暗号化

## 暗号化機能の概要

クラウド向けのストレージにおいては、一般的に、クライアント側で暗号化する CSE（Client-Side Encryption）とサーバ側で暗号化する SSE（Server-Side Encryption）があります。SSEはストレージ側での機能提供が必要であり、ABCIクラウドストレージではSSE機能をサポートしています。

SSE機能を利用すると、データがサーバーに送られた後、ディスクに保存される前に暗号化が行われます。データを取得する時には、ディスクから取り出された後に復号化が行われ、サーバーからデータが送られてきます。SSEでは、送信経路上ではデータが復号化されていますが、ABCIクラウドストレージでは、エンドポイントに https://s3.abci.ai を指定することでTLSによる通信の暗号化が別途行われます。

Amazon S3 では以下のような SSE が提供されていますが、ABCIクラウドストレージでは、SSE-S3 に相当する SSE を提供しています。ただし、SSE-C と SSE-KMS はABCIクラウドストレージでは利用できません。

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


## バケットのデフォルト暗号化の有効化

バケットの SSE を有効化するには、`aws s3api put-bucket-encryption` を実行します。なお、バケットはあらかじめ作成しておく必要があります。
例えば、'dataset-s0001' というバケットで SSE を有効化する場合は以下のように実行します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-encryption --bucket dataset-s0001 --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'
```

!!! note
    ストレージ側が保持する鍵を用いて、サーバー上でオブジェクトを保存する時に暗号化（読み出す時には復号化）するもので、アクセスキーなど送信リクエスト固有の情報で暗号化するものではありません。

!!! note
    デフォルト暗号化が有効にされる前にバケットに存在していたオブジェクトの暗号化は、変更されません。


## デフォルト暗号化を有効にしたバケットかどうかの判別

SSEを有効にしたバケットかどうかを判別するには、`aws s3api get-bucket-encryption` を実行します。

以下では、dataset-s0001 バケットでSSEが有効になっているかを確認しています。 `"SSEAlgorithm": "AES256"` という情報が含まれているため、dataset-s0001 はデフォルト暗号化を有効にしたバケットであるといえます。この情報が含まれていない場合は、デフォルト暗号化が有効でないバケットであることを示しています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-bucket-encryption --bucket dataset-s0001
{
    "ServerSideEncryptionConfiguration": {
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                },
                "BucketKeyEnabled": false
            }
        ]
    }
}
```

また、`aws s3api head-object` を実行すると、オブジェクトの暗号化が有効かどうかを確認できます。
以下では、dataset-s0001 バケットにアップロードした cat.jpg というオブジェクトのメタデータを確認しています。 `"ServerSideEncryption": "AES256"` という情報が含まれている場合は、オブジェクトの暗号化が有効になっています。

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

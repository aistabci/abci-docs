
# データの暗号化

## 暗号化機能の概要

クラウド向けのストレージにおいては、一般的に、クライアント側で暗号化する Client-Side Encryption (CSE) とサーバ側で暗号化する Server-Side Encryption (SSE) があります。SSEはストレージ側での機能提供が必要であり、ABCIクラウドストレージではSSE機能をサポートしています。

SSE機能を利用すると、データがストレージサーバに送られた後、ディスクに保存される前に暗号化が行われます。データを取得する時には、ディスクから取り出された後に復号化が行われ、ストレージサーバからデータが送られてきます。SSEでは、送信経路上ではデータが復号化されていますが、ABCIクラウドストレージでは、エンドポイントに `https://s3.abci.ai` を指定することでTLSによる通信の暗号化が別途行われます。

Amazon S3 では以下のような SSE が提供されていますが、ABCIクラウドストレージでは、SSE-S3 に相当する SSE を提供しています。SSE-C と SSE-KMS はABCIクラウドストレージでは利用できません。

| SSEの種類 | 説明 |
| :-- | :-- |
| SSE-S3 | ストレージ側で管理された鍵を用いて暗号化 |
| SSE-C | ユーザがリクエストに含めた鍵を用いて暗号化 |
| SSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |

CSEはデータの暗号化および復号を利用者が行い、暗号化されたデータをABCIクラウドストレージに保存します。
ABCIクラウドストレージではCSEを利用できます。

ただし、ABCIクラウドストレージではKey Management Service(KMS)を提供していないため、KMSに保存されている暗号キーを利用してのCSEは利用できません。
CSEの詳しい説明は、[Protecting Data Using Client-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingClientSideEncryption.html) をご参照ください。

| CSEの種類 | 説明 |
| :-- | :-- |
| CSE-C | ユーザがクライアント側で管理している鍵を用いて暗号化 |
| CSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |

!!! note
    ABCI クラウドストレージでは運用開始より、SSE を有効にしたバケットを作成する create-encrypted-bucket コマンドを提供してきましたが、create-encrypted-bucket コマンドは2022年8月を目処に提供を終了する予定です。
    8月より後は、create-encrypted-bucket コマンドの代わりに、aws-cli コマンドを利用ください。
    以前に create-encrypted-bucket コマンドで作成したバケットはそのまま利用可能です。削除や設定の参照は aws-cli コマンドで行うことができます。


## バケットのデフォルト暗号化を有効にする

バケットに対してデフォルトの暗号化動作を設定することができます。バケットのデフォルト暗号化を有効にした場合、全てのオブジェクトでバケットに保存される際に暗号化が行われます。
バケットのデフォルト暗号化を有効にするには、`aws s3api put-bucket-encryption` を実行します。なお、バケットはあらかじめ作成しておく必要があります。
例えば、`dataset-s0001` というバケットでデフォルト暗号化を有効化する場合は以下のように実行します。

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
    バケットのデフォルト暗号化機能は、ストレージ側が保持する鍵を用いて、ストレージサーバ上でオブジェクトを保存する時に暗号化（読み出す時には復号化）するもので、アクセスキーなど送信リクエスト固有の情報で暗号化するものではありません。

!!! note
    デフォルト暗号化が有効にされる前にバケットに存在していたオブジェクトは暗号化されません。


## デフォルト暗号化を有効にしたバケットかどうかの判別

デフォルト暗号化を有効にしたバケットかどうかを判別するには、`aws s3api get-bucket-encryption` を実行します。

以下では、`dataset-s0001` バケットのデフォルト暗号化が有効かどうかを確認しています。
`aws s3api get-bucket-encryption` コマンドの出力に、`"SSEAlgorithm": "AES256"` が含まれていればバケットのデフォルト暗号化は有効です。この情報が含まれていない場合、バケットのデフォルト暗号化は有効ではありません。

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

また、`aws s3api head-object` を実行すると、オブジェクトのメタデータとともに、オブジェクトの暗号化が有効かどうかを確認できます。
以下では、`dataset-s0001` バケットにアップロードした `cat.jpg` というオブジェクトの暗号化が有効かどうかを確認しています。
`aws s3api head-object` コマンドの出力に、`"ServerSideEncryption": "AES256"` が含まれている場合は、オブジェクトの暗号化が有効となっています。

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

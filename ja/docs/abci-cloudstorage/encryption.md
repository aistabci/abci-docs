
# データの暗号化

ABCIクラウドストレージでは、SSE を使うことができます。
SSE は Server-Side Encryption (サーバー側暗号化) の略で、データがサーバーに送られた後、ディスクに保管される前(ストレージに渡される前)に暗号化を行います。データを取得する時には、ストレージから取り出された後に復号化が行われ、サーバーからデータが送られてきます。鍵はサーバー側が管理しているものを使い、ユーザーが指定することはできません。この機能では送信経路上の暗号化は行われませんが、エンドポイントに https://s3.abci.ai を指定することでTLSによる通信の暗号化が行われます。

Amazon S3 では以下のような SSE が提供されています。ABCIクラウドストレージの SSE は、SSE-S3 に相当するもので(厳密に全く同じではありません)、SSE-C と SSE-KMS に相当する機能は提供されていません。

| SSEの種類 | 説明 |
| :-- | :-- |
| SSE-S3 | S3サーバー側で管理された鍵を用いて暗号化 |
| SSE-C | ユーザーがリクエストに含めた鍵を用いて暗号化 |
| SSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |


## 暗号化を有効にしたバケットの作成

SSE を有効にしたバケットを作るには、awsコマンドではなく、ABCI環境に用意されている create-encrypted-bucket コマンドを実行します。
例えば、'dataset-s0001' というバケットを作る場合は以下のように実行します。

```
[username@es1 ~]$ create-encrypted-bucket --endpoint-url https://s3.abci.ai s3://dataset-s0001
create-encrypted-bucket Success.
```

!!! note
    サーバー側が保持する鍵を用いて、サーバー上でオブジェクトを保存する時に暗号化(読み出す時に復号化)するもので、アクセスキーなど送信リクエスト固有の情報で暗号化するものではありません。

!!! note
    暗号化を有効にしていないバケットに対して、後から暗号化を有効に方法は提供されていません。


## 暗号化を有効にしたバケットかどうかの判別

SSEを有効にしたバケットかどうかを判別するには、オブジェクトのメタデータを確認する必要があるため、空のバケットでは確認できません。空の場合は、なにかオブジェクトを1つ作成してください。

`aws s3api head-object` で確認します。
以下では、dataset-s0001 バケットにアップロードした cat.jpg というオブジェクトのメタデータを確認しています。 `"ServerSideEncryption": "AES256"` という情報が含まれているため、dataset-s0001 は暗号化を有効にしたバケットです。この情報が含まれていない場合は、暗号化を指定されなかったバケットです。

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

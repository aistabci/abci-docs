# ABCI クラウドストレージ ご利用時の注意

## MPU 失敗時の課金について {#notice-mpu-fail}

Multipart Upload (MPU) を使用したデータアップロードに失敗した場合に、意図しない課金が発生することがあるため、ここで対処を説明します。
データアップロード中に以下のような事象が発生した場合は、本章を確認してください。

* 使用しているクライアントアプリケーションが定義する MPU 適用開始の閾値を越える大きさのデータをアップロードした
* クライアントアプリのプロセスを強制停止するなどで、データのアップロードが失敗した

!!! note 
    クライアントアプリが MPU 適用を開始するデータサイズは、デフォルトで aws-cliは [8MB](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#multipart-threshold), s3cmd が [15MB](https://s3tools.org/kb/item13.htm) です。

### MPU の失敗と課金発生の詳細

ABCIクラウドストレージは、データアップロード時にデータを分割、同時に送信することでアップロードを高速化する Multipart Uload (MPU) に対応しています。
MPU は、クライアントアプリで定義されるデータサイズを超過するデータに対して自動的に有効となり、例えば aws-cli の初期設定の場合は、デフォルトで 8MB を超過するデータのアップロードに対して MPU が適用されます。
MPU を使用したデータのアップロードでは、分割されたデータはまずサーバの一時領域に格納され、アップロードが完了した後に指定のパスに完全なオブジェクトとして移動されます。

ここで、上述の一時領域は課金の対象となるため、MPU に失敗した時に注意が必要です。
このような状況は、aws-cli であれば CTRL-C などでクライアントとサーバ間の動作を適切に停止する場合には発生しませんが、クライアントの強制終了、予期せぬ通信切断などによって発生する可能性があります。
この時、一時領域に保存されたデータは自動削除されないため、意図しない課金が発生する場合があります。

この意図しない課金を回避するためには、利用者自身が手動で MPU を中断する必要があります。以下に MPU 中断の手順を説明します。

### MPU の中止

MPU を削除するために、まず MPU の一覧を表示し、アップロードに失敗した MPU の `UploadId` と `Key` を確認します。
MPU の一覧は、`s3api list-multipart-uploads` コマンドにアップロード時のバケットを指定して、確認することができます。データが残っていない場合は何も表示されません。
以下の例は、オブジェクト名 data_10gib-1.dat を s3://Bucket/testdata/ にアップロード途中に、クライアント側の aws-cli を強制停止 (kill -9) したことでサーバにデータが残った時のものです。`Key` にバケットより下のパスとオブジェクト名が表示されます。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api list-multipart-uploads --bucket BUCKET
{
    "Uploads": [
        {
            "UploadId": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            "Key": "Testdata/data_10gib-1.dat",
            "Initiated": "2019-11-12T09:58:16.242000+00:00",
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

次に、該当する MPU を中止します。これにより一時保存領域のデータは削除されます。MPU の中止は、`s3api abort-multipart-upload` コマンドに対象アップロードの `UploadId` と `Key` を指定します。コマンドが成功すると、プロンプトが返ります。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api abort-multipart-upload --bucket Bucket --key Testdata/data_10gib-1.dat --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
[username@es1 ~]$
```

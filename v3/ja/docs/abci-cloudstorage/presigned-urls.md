
# 署名付きURL
署名付きURLは、期限付きの認証情報を埋め込んだURLです。署名付きURLを作成し他の利用者に共有することで、その利用者はオブジェクトにアクセス可能となります。このため署名付きURL機能では公開オブジェクトを作ることなく、URLを共有するのみで多数の利用者に期限付きでオブジェクトを公開することが可能です。

## 利用方法
署名付きURLは以下のコマンドで作成可能です。[s3 object path]には対象とするオブジェクトを指定し、[--expires-in <expiration time (seconds)\>] には有効期限を秒単位で指定します。有効期限には現状制限はありません。[--expires-in]オプションを省略した場合は、3600 秒（1時間）がデフォルト値として使用されます。
```
aws [options] s3 presign [s3 object path] [--expires-in <expiration time (seconds)>] 
```

## 実行例
この例では、'bucket-test' というバケットに存在する、'file01.txt'というオブジェクトについて署名付きURLを作成します。
```
[username01@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://bucket-test/file01.txt -
This is file01.txt!
```
このオブジェクトについて、300秒を期限とした署名付きURLを作成する場合は以下のコマンドを実行します。
```
[username01@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 presign s3://bucket-test/file01.txt --expires-in 300
https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282
```
以下の様に出力された署名付きURLにアクセスすることで他の利用者からもアクセスが可能となります。
```
[username02@login1 ~]$ curl "https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282"
This is file01.txt!
```
期限が過ぎた署名付きURLについては、以下の様にアクセスができません。
```
[username02@login1 ~]$ curl "https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282"
<?xml version="1.0" encoding="UTF-8"?><Error><Code>AccessDenied</Code><Message>Access Denied</Message><RequestId>4F60982696162049</RequestId><HostId>00000000000000000</HostId></Error>
```
作成した署名付きURLは、有効期限が切れるまで直接無効化することはできません。共有後に署名付きURLでのアクセスを停止したい場合は、[各種操作](./usage.md#operations)をご参照の上、対象オブジェクトを削除するか、名前を変更することで無効化を行ってください。
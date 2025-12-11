# アクセス制御(3) - アクセスIPアドレスの制限

バケットポリシーを使用することで、バケットにアクセスできるIPアドレスを制限できます。バケットポリシーはJSON形式で記述されます。

## 特定のIPアドレスからのアクセスのみを許可する {#allow-specific-ip-policy}

特定のIPアドレスからのアクセスのみを許可し、その他のIPアドレスからのアクセスを制限するバケットポリシーを適用する方法について説明します。

!!! note
    ABCIクラウドストレージは、ABCI内部（ログインノードや計算ノード）からのみ利用可能で、外部（インターネットなど）からは現在利用できません。
### バケットポリシーファイルの作成

以下の内容でJSONファイル（例：`allow-specific-ip-policy.json`）を作成してください。
`<バケット名>`と許可するIPアドレス`"aws:SourceIp": ["10.0.90.3"]`は環境に合わせて置き換えてください。

```json

{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificIP",
      "Effect": "Deny",
      "Principal": {
        "DDN": ["*"]
      },
      "Action": "s3:*",
      "Resource": "<バケット名>",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["10.0.90.3"]
        }
      }
    }
  ]
}

```

### バケットポリシーの適用

作成したJSONファイルをバケットに適用します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <バケット名> --policy file://allow-specific-ip-policy.json
```

### バケットポリシーの確認

適用したポリシーを確認するには、以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
{
    "Policy": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"AllowSpecificIP\",\"Effect\":\"Deny\",\"Principal\":{\"DDN\":[\"*\"]},\"Action\":[\"s3:*\"],\"Resource\":\"<バケット名>\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":[\"10.0.90.3\"]}}}]}"
}
```

ポリシー適用後、バケット所有者以外のユーザーは指定したIP以外から対象のオブジェクトにアクセスできなくなります。
```
[username2@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://<バケット名>/testfile testfile
download failed: s3://<バケット名>/testfile to - An error occurred (403) when calling the HeadObject operation: Forbidden
```


### バケットポリシーの解除

特定IPアドレスからのアクセス制限を解除し、ポリシーを削除するには以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <バケット名>
```

ポリシーが削除されたことを確認するには、以下のコマンドを実行してください。ポリシーがない場合はエラーメッセージが表示されます。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```

## 全IPアドレスからのアクセスを拒否する {#deny-all-ip-policy}

全てのIPアドレスからのアクセスを拒否する方法について説明します。この設定により、バケット所有者以外のすべてのアクセスを拒否します。

### バケットポリシーファイルの作成

以下の内容でJSONファイル（例：`deny-all-ip-policy.json`）を作成してください。`<バケット名>`は環境に合わせて置き換えてください。

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "DenyAllIP",
      "Effect": "Deny",
      "Principal": {
        "DDN": ["*"]
      },
      "Action": "s3:*",
      "Resource": "<バケット名>",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["0.0.0.0/0"]
        }
      }
    }
  ]
}
```

### バケットポリシーの適用

作成したJSONファイルをバケットに適用します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <バケット名> --policy file://deny-all-ip-policy.json
```

### バケットポリシーの確認

適用したポリシーを確認するには、以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
{
    "Policy": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"DenyAllIP\",\"Effect\":\"Deny\",\"Principal\":{\"DDN\":[\"*\"]},\"Action\":[\"s3:*\"],\"Resource\":\"<バケット名>\",\"Condition\":{\"IpAddress\":{\"aws:SourceIp\":[\"0.0.0.0/0\"]}}}]}"
}
```

ポリシー適用後、バケット所有者以外のユーザーは対象のオブジェクトにアクセスできなくなります。
```
[username2@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://<バケット名>/testfile testfile
download failed: s3://<バケット名>/testfile to - An error occurred (403) when calling the HeadObject operation: Forbidden
```


### バケットポリシーの解除

全IPアドレスからのアクセス拒否を解除し、ポリシーを削除するには以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <バケット名>
```

ポリシーが削除されたことを確認するには、以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```

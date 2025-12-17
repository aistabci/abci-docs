# アクセス制御(2) - ポリシーによる制御

バケットやオブジェクトに設定するACLとは別に、バケットやクラウドストレージアカウントに対する「アクセス制御ポリシー」を設定することができます。これにより、ACLでは設定できないようなアクセス制御が可能です。

「アクセス制御ポリシー」には「バケットポリシー」を使用します。

* バケットポリシー: バケットに対して、アクセス制御ポリシーを設定します。

## デフォルトのアクセス許可

デフォルトでは、バケットやオブジェクトにACLが特に設定されていなければ、自身のクラウドストレージアカウントのみデータにフルアクセス（読み書き両方）できる設定となっています。

デフォルトのまま使う場合には、以降に説明するポリシーの追加設定を行う必要はありません。特定のクラウドストレージアカウントを読み取りしかできないようする、あるバケットにアクセスできるのは一部のクラウドストレージアカウントだけにするなど、細かい制御が必要な場合には、以下を参考にポリシーを設定してください。

## アクセス制御ポリシー共通の注意点

バケットポリシーの注意点を挙げます。

* エンドポイントは https://s3.v3.abci.ai です。
* 順番に関係なく、DenyルールがAllowルールよりも優先されます。同一ポリシー内でなくとも、別のポリシーにDenyルールがあればそれが優先されます。
* ポリシーの名前(--policy-nameに指定する名前)は、大文字を用いてもエラーにはなりませんが、問題になるケースがあるため、小文字英字と数字、およびハイフン(0x2d)で構成してください。

## バケットポリシーの設定 {#config-bucket-policy}

バケットポリシーではバケットに対してアクセス制御ポリシーを設定します。これにより、バケット単位でアクセス制御が可能です。

バケットポリシーの設定では、JSON形式でアクセス許可の定義を書きます。Effect, Action, Resource, Principal の組み合わせにより、何を許可するか、何を拒否するかなどを記述します。

Effect には、"Allow" または "Deny" が設定できます。許可するルールなのか、拒否するルールなのかを記します。

Action には、どのようなリクエスト(動作)に対する制限なのかを記述します。例えば、オブジェクトのダウンロードについては、s3:GetObject を指定します。ワイルドカード (`s3:*`) を使うこともできます。

アクションの一覧：

| アクション | 説明 |
| :-- | :-- |
|s3:ListBucket                     |バケットの一覧表示|
|s3:GetObject	                  |オブジェクトのダウンロード|
|s3:PutObject	                  |オブジェクトのアップロード|
|s3:DeleteObject	                  |オブジェクトの削除|
|s3:GetObjectACL	                  |オブジェクトに設定されたACLを取得|
|s3:PutObjectACL	                  |オブジェクトにACLを適用|
|s3:AbortMultipartUpload           |進行中のすべてのマルチパートアップロードを中止する操作|
|s3:ListMultipartUploadParts       |進行中のマルチパートアップロードを一覧表示する操作|
|s3:* or * (ALL OBJECT OPERATIONS) |上記全ての操作|


Resource には、アクセス対象となるリソースを記述します。例えば、"Resource": "sensor8"は、sensor8 という名前のバケットを示しています。

Principal には、アクセス権を設定するユーザーのUUIDを記述します。ワイルドカード (*) を指定して誰からでもアクセスできる（パブリックアクセス）設定を行うこともできます。なお、NotPrincipal はサポートされていません。

!!! caution
    誰からでも読み取りアクセスができる設定を行う場合は、下記をよくお読みいただき、データを公開することが適切であるかご確認の上、設定をお願いします。
    
    * [ABCI約款・規約](https://abci.ai/ja/how_to_use/)
    * [ABCIクラウドストレージ規約](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf)

!!! caution
    第三者によって意図しない利用がなされる恐れがありますので、誰からでも書き込みアクセスができる設定はしないでください。

!!! note
    バケットポリシーのConditionではIPアドレスのみサポートします。

### 例1：ABCIユーザー間でバケットを共有する {#share-bucket-between-users}

ABCIユーザー間でバケットを共有する方法について説明します。この例では、ユーザーAが所有する share-bucket というバケットを bbb00000.1、bbb00001.1 という2人のクラウドストレージアカウントにアクセスを許可します。

まず、アクセスを許可するアカウント bbb00000.1 と bbb00001.1 の UUID の値をアクセス許可を受けるユーザが `aws s3api list-buckets` でID(UUID)を確認します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api list-buckets
{
    "Buckets": [
        {
            "Name": "<>",
            "CreationDate": "2025-06-24T22:37:19.000Z"
        },
    ],
    "Owner": {
        "DisplayName": "<バケット所有者のUUID>",
        "ID": "<バケット所有者のUUID>"
    }
}
```

次に、ユーザーAが以下の内容の cross-access-pc.json というファイルを作成します。説明上、cross-access-pc.json としますが、任意のファイル名を使うことができます。

```
$cat cross-access-pc.json
{
    "Version": "2008-10-17",
    "Id": "AllowUser",
    "Statement": [
      {
        "Sid": "statement1_Allow",
        "Effect": "Allow",
        "Principal": {
          "DDN": [
            "<bbb00000.1のUUID>",
            "<bbb00001.1のUUID>",
          ]
        },
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
        ],
        "Resource": "share-bucket"
      }
    ]
}
```

上記では、bbb00000.1 と bbb00001.1 に share-bucket バケットに対する読み取り専用のアクセスを許可するポリシーを定義しています。

このポリシーを share-bucket バケットに適用します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket share-bucket --policy file://cross-access-pc.json
```

上記により bbb00000.1 と bbb00001.1 は、share-bucket バケットにアクセスし、オブジェクトのダウンロードができるようになります。

バケットに適用されたポリシーを確認する場合は、aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket share-bucket を実行してください。

また、ポリシーを削除する場合は、aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket share-bucket を実行してください。

## アクセスIPアドレスの制限

[アクセス制限(1)](acl.md)に記載されている手順等により、バケットへのアクセス許可を与えることが可能となります。
これらのアクセス許可が付与されたバケットに対しても、バケットポリシーを使用することで、バケットにアクセスできるIPアドレスを制限できます。
バケットポリシーはJSON形式で記述されます。

### 特定のIPアドレスからのアクセスのみを許可する {#allow-specific-ip-policy}

特定のIPアドレスからのアクセスのみを許可し、その他のIPアドレスからのアクセスを制限するバケットポリシーを適用する方法について説明します。

!!! note
    ABCIクラウドストレージは、ABCI内部（ログインノードや計算ノード）からのみ利用可能で、外部（インターネットなど）からは現在利用できません。
#### バケットポリシーファイルの作成

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

#### バケットポリシーの適用

作成したJSONファイルをバケットに適用します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <バケット名> --policy file://allow-specific-ip-policy.json
```

#### バケットポリシーの確認

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


#### バケットポリシーの解除

特定IPアドレスからのアクセス制限を解除し、ポリシーを削除するには以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <バケット名>
```

ポリシーが削除されたことを確認するには、以下のコマンドを実行してください。ポリシーがない場合はエラーメッセージが表示されます。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```

### 全IPアドレスからのアクセスを拒否する {#deny-all-ip-policy}

全てのIPアドレスからのアクセスを拒否する方法について説明します。この設定により、バケット所有者以外のすべてのアクセスを拒否します。

#### バケットポリシーファイルの作成

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

#### バケットポリシーの適用

作成したJSONファイルをバケットに適用します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <バケット名> --policy file://deny-all-ip-policy.json
```

#### バケットポリシーの確認

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


#### バケットポリシーの解除

全IPアドレスからのアクセス拒否を解除し、ポリシーを削除するには以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <バケット名>
```

ポリシーが削除されたことを確認するには、以下のコマンドを実行してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <バケット名>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```

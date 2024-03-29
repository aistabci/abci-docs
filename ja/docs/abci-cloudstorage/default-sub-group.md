
# アクセス制御(3) - サブグループによる制御

ABCIクラウウドストレージサービスでは、ABCIグループ内のクラウドストレージアカウントが所属するサブグループ**default-sub-group**があらかじめ用意されています。このサブグループにポリシーを設定することで、サブグループに属する全アカウントに対するアクセス制御設定を一括で行うことができます。

サブグループdefault-sub-groupは管理者用クラウドストレージアカウントにより自由に変更できます。
デフォルトでは、default-sub-groupにはグループ内のクラウドストレージへのフルアクセス権限を設定しています。
また、default-sub-groupとは別のサブグループを作成し、サブルグループごとにアクセス制御を行うこともできます。

ここでは、サブグループの操作方法および、サブグループを使ってのアクセス制御について説明します。

## サブグループの操作 {#managing-subgroups}

サブグループの操作はAWS CLIを使用します。
また、サブグループを操作するためには、管理者用のクラウドストレージアカウントが必要です。権限がない場合は、所属グループの利用管理者等、管理者用のクラウドストレージアカウントを持つ者に設定、あるいは権限の付与を依頼してください。

サブグループの操作に用いる主なコマンドは以下の通りです。

| コマンド | 説明 |
| --       | --   |
| aws iam get-group | サブグループに所属するクラウドストレージアカウントの一覧を表示する。 |
| aws iam list-groups | サブグループの一覧を表示する。 |
| aws iam create-group | サブグループを作成する。 |
| aws iam delete-group | サブグループを削除する。 |
| aws iam add-user-to-group | クラウドストレージアカウントをサブグループに追加する。 |
| aws iam remove-user-from-group | クラウドストレージアカウントをサブグループから削除する。 |
| aws iam attach-group-policy | アクセス制御ポリシーをサブグループに割り振る。 |
| aws iam detach-group-policy | アクセス制御ポリシーをサブグループから削除する。 |
| aws iam list-attached-group-policies | サブグループに割り振られたアクセス制御ポリシーの一覧を表示する。 |
| aws iam list-groups-for-user | クラウドストレージアカウントが所属するグループの一覧を表示する。 |

例えば、サブグループの一覧を表示する場合は`aws iam list-groups`コマンドを使用します。
デフォルトではmanaged-groupとdefault-sub-groupの2グループが表示されます。

!!! note
    managed-groupは管理のために運用側で用意したサブグループであり、利用者からは変更できません。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam list-groups
{
    "Groups": [
        {
            "Path": "/abci/",
            "GroupName": "managed-group",
            "GroupId": "GRPES2SG5PLA6UYFHWYA0M6VCEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:group/abci/managed-group",
            "CreateDate": "2020-04-01T02:04:45+00:00"
        },
        {
            "Path": "/",
            "GroupName": "default-sub-group",
            "GroupId": "GRP0L1H8JX1Z9GUXBFHRMFIWJEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:group/default-sub-group",
            "CreateDate": "2019-12-26T14:30:28+00:00"
        }
    ]
}
```

`aws iam get-group`コマンドで、サブグループに所属するクラウドストレージアカウントの一覧を表示できます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam get-group --group-name default-sub-group
{
    "Users": [
        {
            "Path": "/",
            "UserName": "aaa00000.1",
            "UserId": "USRJY5ST1Z16OKRANCL9SZZGQEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:user/aaa00000.1",
            "CreateDate": "2020-01-22T11:53:24+00:00"
        }
    ],
    "Group": {
        "Path": "/",
        "GroupName": "default-sub-group",
        "GroupId": "GRP0L1H8JX1Z9GUXBFHRMFIWJEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/default-sub-group",
        "CreateDate": "2019-12-26T14:30:28+00:00"
    }
}
```

サブグループを作成する場合は以下のように`aws iam create-group`コマンドに作成するグループの名前を指定します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name custom-group
{
    "Group": {
        "Path": "/",
        "GroupName": "custom-group",
        "GroupId": "GRPK7ONKO77EZKM7FVI3AFB8UEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/custom-group",
        "CreateDate": "2021-10-13T10:53:24+00:00"
    }
}
```

サブグループを削除する場合は以下のように`aws iam delete-group`コマンドに削除するグループの名前を指定します。
なお、サブグループを削除する場合はサブグループにアカウントが存在しないこと、かつ、ポリシーが割り当てられていないことを確認してください。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam delete-group --group-name custom-group
```

コマンドのオプションなど詳しい使い方については、各コマンドのヘルプ(`aws iam create-group help`など)を確認してください。

## 例1: オブジェクトの読み書きをサブグループごとに設定する {#example-1-limiting-bucket-access-by-subgroups}

ABCIグループ内にaaa00000.1、aaa00001.1という2つのクラウドストレージアカウントが作られており、sensor8というバケットがあるものとします。
この例では、バケットsensor8に対してオブジェクトの読み取り専用サブグループおよび書き込み専用サブグループを作成し、クラウドストレージアカウントのサブグループをこれらに変更することでアクセス制御を行います。

まず、サブグループを作成します。サブグループの作成には`aws iam create-group`コマンドを使用します。
オブジェクトの読み取り専用のサブグループを`sensor8-read-only-group`、書き込み専用のサブグループを`sensor8-write-only-group`としています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name sensor8-read-only-group
{
    "Group": {
        "Path": "/",
        "GroupName": "sensor8-read-only-group",
        "GroupId": "GRP1P4AHW7GT7NDH3VNADCOGSEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/sensor8-read-only-group",
        "CreateDate": "2021-10-13T09:51:04+00:00"
    }
}
```

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name sensor8-write-only-group
{
    "Group": {
        "Path": "/",
        "GroupName": "sensor8-write-only-group",
        "GroupId": "GRPYSWMCP4RFXPVK8QOVZ3S0REXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/sensor8-write-only-group",
        "CreateDate": "2021-10-13T09:51:43+00:00"
    }
}
```

次に、バケットsensor8に対してオブジェクトの読み取りのみ許可するポリシーを作成します。以下の内容のJSONファイルを用意してください。ファイル名はここでは`sensor8-read-only.json`とします。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::sensor8/*"
        }
    ]
}
```

JSONファイルを用意したら`aws iam create-policy`コマンドを使用しポリシーを作成します。
ポリシー名は`sensor8-read-only`としています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8-read-only --policy-document file://sensor8-read-only.json
{
    "Policy": {
        "PolicyName": "sensor8-read-only",
        "PolicyId": "PLCYI1ZEME36PS9E9G4NIBP2ZEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8-read-only",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:06:41+00:00",
        "UpdateDate": "2021-10-13T10:06:41+00:00"
    }
}
```

次に、バケットsensor8に対してオブジェクトの書き込みのみ許可するポリシーを作成します。以下の内容のJSONファイルを用意してください。ファイル名はここでは`sensor8-write-only.json`とします。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::sensor8/*"
        }
    ]
}
```

JSONファイルを用意したら`aws iam create-policy`コマンドを使用しポリシーを作成します。
ポリシー名は`sensor8-write-only`としています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8-write-only --policy-document file://sensor8-write-only.json
{
    "Policy": {
        "PolicyName": "sensor8-write-only",
        "PolicyId": "PLCYA88HTRZ7N0D5VASY2LSJ8EXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8-write-only",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:11:36+00:00",
        "UpdateDate": "2021-10-13T10:11:36+00:00"
    }
}
```

サブグループとポリシーを作成した後、それぞれのサブグループにポリシーを割り当てます。
ポリシーを割り当てるには`aws iam attach-group-policy`コマンドを使用します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name sensor8-read-only-group --policy-arn arn:aws:iam::123456789012:policy/sensor8-read-only
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name sensor8-write-only-group --policy-arn arn:aws:iam::123456789012:policy/sensor8-write-only
```

最後に、クラウドストレージアカウントをサブグループdefault-sub-groupから新しいサブグループに移動します。
ここではaaa00000.1を読み込み専用グループに、aaa00001.1を書き込み専用グループに移動します。

アカウントの移動にあたって、まず、default-sub-groupからアカウントを外します。
サブグループからアカウントを外すには、`aws iam remove-user-from-group`コマンドを使用します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam remove-user-from-group --user-name aaa00000.1 --group-name default-sub-group
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam remove-user-from-group --user-name aaa00001.1 --group-name default-sub-group
```

サブグループからアカウントを外した後、新しいサブグループにアカウントを追加します。
アカウントをサブグループに追加するには、`aws iam add-user-to-group`コマンドを使用します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam add-user-to-group --user-name aaa00000.1 --group-name sensor8-read-only-group
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam add-user-to-group --user-name aaa00001.1 --group-name sensor8-write-only-group
```

以上で、アカウントのサブグループへの移動が完了しました。
これにより、アカウントaaa00000.1はバケットsensor8内のオブジェクトをダウンロードのみできるようになり、aaa00001.1はオブジェクトのアップロードのみできるようになります。


## 例2: バケットにアクセスできるネットワークを限定する {#example-2-limiting-bucket-access-by-networks}

接続元IPアドレスによるアクセス制限を行う例として、ABCI内部ネットワーク(10.0.0.0/17)外のアクセスは拒否する設定をdefault-sub-groupに追加する方法を説明します。

以下の内容のJSONファイルを作成します。ファイル名は`deny-outside-abci.json`とします。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": [
                        "10.0.0.0/17"
                    ]
                }
            }
        }
    ]
}
```

JSONファイルを用意したら`aws iam create-policy`コマンドを使用しポリシーを作成します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name deny-outside-abci --policy-document file://deny-outside-abci.json
{
    "Policy": {
        "PolicyName": "deny-outside-abci",
        "PolicyId": "PLCYRASJDBNC4TCO8WDA6QKKEEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/deny-outside-abci",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:51:31+00:00",
        "UpdateDate": "2021-10-13T10:51:31+00:00"
    }
}
```

次に、サブグループdefault-sub-groupに作成したポリシーを割り当てます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name default-sub-group --policy-arn arn:aws:iam::123456789012:policy/deny-outside-abci
```

これによりグループ内のクラウドストレージアカウントは、ABCI内部からしかクラウドストレージにアクセスできなくなります。

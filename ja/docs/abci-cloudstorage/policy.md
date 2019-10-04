# アクセス制御（２）- ポリシーによる制御  

バケットやオブジェクトに設定するACLとは別に、クラウドストレージアカウントに対する「アクセス制御ポリシー」を設定することができます。これにより、ACLでは設定できないようなアクセス制御が可能です。ただし、設定には管理者用のクラウドストレージアカウントが必要です。権限がない場合は、グループ管理者に設定、あるいは権限の付与を依頼してください。

!!! note
    バケットやオブジェクトにはポリシーを設定できません。そのため、グループ内のストレージアカウント全てにポリシーを設定しなければならないケースがあります。

## デフォルトのアクセス許可

デフォルトでは、バケットやオブジェクトにACLが特に設定されていなければ、グループ内のクラウドストレージアカウントはグループ内のデータにフルアクセス（読み書き両方）できる設定となっています。

デフォルトのまま使う場合には、以降に説明するポリシーの追加設定を行う必要はありません。特定のクラウドストレージアカウントを読み取りしかできないようする、あるバケットにアクセスできるのは一部のクラウドストレージアカウントだけにするなど、細かい制御が必要な場合には、以下を参考にポリシーを設定してください。


## ポリシーの設定

<!--  デフォルトサブグループが導入されたら、デフォルトのアクセス権限を変更できる  -->

まず最初に、共通の注意点を挙げます。

- エンドポイントは `https://s3.abci.ai` です。
- 順番に関係なく、DenyルールがAllowルールよりも優先されます。同一ポリシー内でなくとも、別のポリシーにDenyルールがあればそれが優先されます。
- ポリシーの名前(--policy-nameに指定する名前)は、大文字を用いてもエラーにはなりませんが、問題になるケースがあるため、小文字英字と数字、およびハイフン(0x2d)で構成してください。

ポリシーの設定では、JSON形式でアクセス許可の定義を書きます。Effect, Action, Resource, Condition の組み合わせにより、何を許可するか、何を拒否するか、どのような条件で判定するかなどを記述します。

Effect には、"Allow" または "Deny" が設定できます。許可するルールなのか、拒否するルールなのかを記します。

Action には、どのようなリクエスト(動作)に対する制限なのかを記述します。例えば、オブジェクトのダウンロードについては、s3:GetObject を指定します。ワイルドカード (`s3:*`) を使うこともできます。

アクションの一覧：

* バケット

| アクション | 説明 |
| :-- | :-- |
| s3:CreateBucket | バケットの作成 |
| s3:DeleteBucket | バケットの削除 |
| s3:ListBucket | バケットの一覧を表示 |
| s3:PutBucketACL | バケットにACLを適用 |
| s3:GetBucketACL | バケットに設定されたACLの一覧を取得 |

* オブジェクト

| アクション | 説明 |
| :-- | :-- |
| s3:GetObject | オブジェクトのダウンロード |
| s3:PutObject | オブジェクトのアップロード |
| s3:DeleteObject | オブジェクトの削除 |
| s3:GetObjectACL | オブジェクトに設定されたACLを取得 |
| s3:PutObjectACL | オブジェクトにACLを適用 |
| s3:HeadObject | オブジェクトのメタデータの取得 |
| s3:CopyObject | オブジェクトのコピー |

<!--
* ポリシー

| アクション | 説明 |
| :-- | :-- |
| iam:ListUsers| クラウドストレージアカウントの一覧を取得 |
| iam:CreateGroup| サブグループを新規に作成 |
| iam:DeleteGroup| サブグループを削除 |
| iam:ListGroups| サブグループの一覧を表示 |
| iam:AddUserToGroup| クラウドストレージアカウントをサブグループに追加 |
| iam:RemoveUserFromGroup| クラウドストレージアカウントをサブグループから除外 |
| iam:ListGroupsForUser| クラウドストレージアカウントが所属しているサブグループを表示 |
| iam:Createpolicy| ポリシーを作成 |
| iam:DeletePolicy| ポリシーを削除 |
| iam:ListPolicies| ポリシーの一覧を表示 |
| iam:AttachGroupPolicy| ポリシーをサブグループに適用 |
| iam:DetachGroupPolicy| サブグループに適用したポリシーを解除 |
| iam:ListAttachedGroupPolicies| グループに適用したポリシーの一覧を取得 |
| iam:AttachUserPolicy| ユーザポリシーをクラウドストレージアカウントに設定 |
| iam:DetachUserPolicy| クラウドストレージアカウントに適用したポリシーを解除 |
| iam:ListAttachedUserPolicies| クラウドストレージアカウントに適用したポリシーの一覧を取得 |
-->

Resource には、アクセス対象となるリソースを記述します。例えば、`arn:aws:s3:::sensor8` は、sensor8 という名前のバケットを示しています。その中のオブジェクトは、`arn:aws:s3:::sensor8/test.dat` のように記します。ワイルドカード (`*`) も使うことができます。

Condition には、条件演算子と条件キーを記述します。

| 条件演算子 | 説明 |
| :-- | :-- |
| StringEquals | 指定した文字列と完全一致することをチェックする文字列条件演算子です。 |
| StringNotEquals | 指定した文字列に一致しないことをチェックする文字列条件演算子です 。|
| StringLike | 指定したパターンに一致することをチェックする文字列条件演算子です。複数文字一致のワイルドカード (\*) と 1 文字一致のワイルドカード (?) を使うことができます。 |
| StringNotLike | 指定したパターンに一致しないことをチェックする文字列条件演算子です。複数文字一致のワイルドカード (\*) と 1 文字一致のワイルドカード (?) を使うことができます。 |
| DateLessThan | 指定した日時よりも前であるかチェックする日付条件演算子です。日付は "2019-09-27T01:30:00Z" のような形式で記述します。 |
| DateGreaterThan | 指定した日時よりも後であるかチェックする日付条件演算子です。日付のフォーマットは DateLessThan と同じです。 |
| IpAddress | 指定のIPアドレスに一致する、または指定のアドレスレンジの範囲に含まれていることをチェックするIPアドレス条件演算子です。 |
| NotIpAddress | 指定のIPアドレスに一致しない、または指定のアドレスレンジの範囲に含まれていないことをチェックするIPアドレス条件演算子です。 |

| 条件キー | 説明 |
| :-- | :-- |
| aws:username | 例えば aaa00000.1 のようなクラウドストレージアカウント名です。文字列条件演算子でチェックします。 |
| aws:SourceIp | 接続元IPアドレスです。IPアドレス条件演算子でチェックします。 |
| aws:CurrentTime | 現在の日時です。日付条件演算子でチェックします。 |
| aws:UserAgent | HTTPヘッダのUser-Agentです。文字列条件演算子でチェックします。偽装が可能なためアクセスの禁止などには適しませんが、例えば、特定のアプリケーション向けに用意したバケットへの誤ったアクセスを防止する対策などに使うことが考えられます。 |

フォーマットについては、以下の例を参考にしてください。
Condition要素は、必要なければ省略可能です。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": "*",
            "Condition": {"StringLike": {"aws:UserAgent" : "aws-cli*"}}
        }
    ]
}
```

以降ではいくつか例を挙げて、ポリシーによるアクセス制御の方法を説明します。

### 例1：バケットにアクセスできるアカウントを限定する

グループ内に aaa00000.1、aaa00001.1、aaa00002.1、aaa00003.1 という4人のクラウドストレージアカウントが作られており、sensor8 というバケットがあるものとします。今回、そこにアクセスできるユーザーを、aaa00000.1 と aaa00001.1 の 2人に限定する方法を説明します。

以下の内容の sensor8.json というファイルを作成します。説明上、sensor8.json としますが、任意のファイル名を使うことができます。

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": ["arn:aws:s3:::sensor8", "arn:aws:s3:::sensor8/*"],
            "Condition" : { "StringNotEquals" : { "aws:username" :
                ["aaa00002.1", "aaa00003.1"]}}
        }
    ]
}
```

上記では aaa00002.1 と aaa00003.1 が sensor8 にアクセスを禁止するポリシーを定義しています。
Denyルールが優先されるため、他のポリシーで aaa00002.1 と aaa00003.1 に対して Allowルールが適用されていたとしても、本ポリシーを適用することでアクセスを禁止することができます。

本ポリシーをクラウドストレージに登録します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8policy --policy-document file://sensor8.json
{
    "Policy": {
        "PolicyName": "sensor8policy",
        "CreateDate": "2019-07-30T06:22:47Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "51OFYS8BQEFTP68KT4I63AAZYHNBPHHA",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8policy",
        "UpdateDate": "2019-07-30T06:22:47Z"
    }
}
```

カレントディレクトリの sensor8.json の内容を sensor8policy という名前で登録しています。
Arn の値は、クラウドストレージアカウントへの適用時に必要になるので、控えておいてください。

ABCIクラウドストレージでは、バケットにポリシーを設定することができないため、


本ポリシーを制限したいクラウドストレージアカウント、すなわち aaa00002.1 と aaa00003.1 に適用します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00002.1
```

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00003.1
```

`--policy-arn`に指定するポリシーのARNは、ポリシーを登録した時に出力されていますが、 `aws --endpoint-url https://s3.abci.ai iam list-policies` を実行して確認することもできます。

上記の登録により aaa00002.1 と aaa00003.1 は、sensor8 バケットにアクセスできなくなりました。aaa00000.1 と aaa00001.1 は、これまで通りアクセスできます。

クラウドストレージアカウントに適用されたポリシーを確認する場合は、`aws --endpoint-url https://s3.abci.ai iam list-attached-user-policies --user-name aaa00002.1` を実行してください。

### 例2：バケットにアクセスできるホストを限定する

接続元IPアドレスによるアクセス制限を行う例として、ABCI内部ネットワーク(10.0.0.0/17)からのアクセスと外部ホスト 203.0.113.2 からのアクセスのどちらでもない場合に、アクセスを拒否する設定を行う方法を説明します。

以下の内容のポリシーを定義した src-ip-pc.json というファイルを作成します。

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
                        "10.0.0.0/17",
                        "203.0.113.2/32"
                    ]
                }
            }
        }
    ]
}
```

このポリシーをクラウドストレージに登録します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name src-ip-pc --policy-document file://src-ip-pc.json
{
    "Policy": {
        "PolicyName": "src-ip-pc",
        "CreateDate": "2019-08-08T13:24:54Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "K9B9SFWR0JL4GSY8Z1K2441VJERSC2Q7",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::123456789012:policy/src-ip-pc",
        "UpdateDate": "2019-08-08T13:24:54Z"
    }
}
```

次に、グループ内の各クラウドストレージアカウントに本ポリシーを適用していきます。以下の例ではクラウドストレージアカウント aaa00004.1 にポリシーを適用しています。ポリシーのARNは、ポリシーを登録した時に出力されていますが、aws --endpoint-url https://s3.abci.ai iam list-policies を実行して確認することもできます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/src-ip-pc --user-name aaa00004.1
```

デフォルトでは、接続元IPアドレスによる制限がないため、本ポリシーを適用していないアカウントは接続元の制限なくアクセスができる状態です。グループ内のクラウドストレージアカウントをリストするには、`aws --endpoint-url https://s3.abci.ai iam list-users` を実行してください。

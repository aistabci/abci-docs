# ポリシーとアクセス許可

ポリシーは、バケットやオブジェクトに設定するACLとは別に、クラウドストレージアカウントに対するアクセス許可を設定するものです。設定するにはグループ管理者(利用責任者または利用管理者)のアカウントが必要です。

## デフォルトのアクセス許可

デフォルトでは、バケットやオブジェクトにACLが特に設定されていなければ、グループ内のクラウドストレージアカウントはグループ内のデータにフルアクセス(読み書き両方)できるアクセス許可が設定されています。

## ポリシーの設定

前述のとおり、デフォルトでは、グループ内のクラウドストレージアカウントはバケットにフルアクセス可能な設定になっています。デフォルトのまま使う場合には、この後に説明するポリシーの追加設定を行う必要はありません。特定のクラウドストレージアカウントを読み取りしかできないようする、あるバケットにアクセスできるのは一部のクラウドストレージアカウントだけにするなど、細かい制御が必要な場合には、クラウドストレージグループ管理者アカウントでポリシーの設定を行います。

ABCIクラウドストレージでは、バケットにポリシーを設定することができないため、グループ内のクラウドストレージアカウント全てにポリシーを適用しなければならないケースがあります。

<!--  デフォルトサブグループが導入されたら、デフォルトのアクセス権限を変更できる  -->

これからいくつかの例を用いて説明していきますが、以下はどの例でも共通する注意点です。

- エンドポイントは `https://s3.abci.ai` です
- 順番に関係なく、DenyルールがAllowルールよりも優先されます。同一ポリシー内でなくとも、別のポリシーにDenyルールがあればそれが優先されます
- ポリシーの名前(--policy-nameに指定する名前)は、大文字を使ってもエラーにはなりませんが、問題になるケースがあるため、小文字英字と数字、およびハイフン(0x2d)で構成してください

JSON形式でアクセス許可の定義を書きます。Effect, Action, Resource, Condition の組み合わせにより、何を許可するか、何を拒否するか、どのような条件で判定するかなどを決定します。

Effect には、"Allow" または "Deny" が設定できます。許可するルールなのか、拒否するルールなのかを決めます。

Action は、どのようなリクエスト(動作)に対する制限なのかを設定します。オブジェクトの取得(ダウンロード)の場合は、s3:GetObject を指定します。ワイルドカード (`s3:*`) が使えます。

アクションの一覧

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
| s3:GetObject | オブジェクトの取得(ダウンロード) |
| s3:PutObject | オブジェクトの作成(アップロード) |
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

Resource には、アクセス対象となるリソースを指定します。例えば、`arn:aws:s3:::sensor8` は、sensor8 という名前のバケットを指します。その中のオブジェクトは、`arn:aws:s3:::sensor8/test.dat` のように書きます。ワイルドカード (`*`) が使えます。

Condition には、条件演算子と条件キーを指定します。

| 条件演算子 | 説明 |
| :-- | :-- |
| StringEquals | 指定した文字列と完全一致することをチェックする文字列条件演算子です |
| StringNotEquals | 指定した文字列に一致しないことをチェックする文字列条件演算子です |
| StringLike | 指定したパターンに一致することをチェックする文字列条件演算子です。複数文字一致のワイルドカード (\*) と 1 文字一致のワイルドカード (?) を指定できます |
| StringNotLike | 指定したパターンに一致しないことをチェックする文字列条件演算子です。複数文字一致のワイルドカード (\*) と 1 文字一致のワイルドカード (?) を指定できます |
| DateLessThan | 指定した日時よりも前(昔)であるかチェックする日付条件演算子です。日付は "2019-09-27T01:30:00Z" のような形式で指定します |
| DateGreaterThan | 指定した日時よりも後であるか(過ぎているか)チェックする日付条件演算子です。日付のフォーマットは DateLessThan と同じです |
| IpAddress | 指定のIPアドレスに一致する、または指定のアドレスレンジの範囲に含まれていることをチェックするIPアドレス条件演算子です |
| NotIpAddress | 指定のIPアドレスに一致しない、または指定のアドレスレンジの範囲に含まれていないことをチェックするIPアドレス条件演算子です |

| 条件キー | 説明 |
| :-- | :-- |
| aws:username | 例えば aaa00000.1 などのクラウドストレージアカウント名です。文字列条件演算子でチェックします |
| aws:SourceIp | 接続元IPアドレスです。IPアドレス条件演算子でチェックします |
| aws:CurrentTime | 現在の日時です。日付条件演算子でチェックします |
| aws:UserAgent | HTTPヘッダのUser-Agentです。文字列条件演算子でチェックします。偽装が可能なためアクセスの禁止などには適しませんが、例えば専用アプリケーション領域への誤った書き込みの防止策などに使うことが考えられます |

フォーマットについては、以下の例を参考にしてください。
Condition要素は、必要なければ書かなくても構いません。

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

### 例1 バケットにアクセスできるアカウントを限定する

グループ内には、aaa00000.1、aaa00001.1、aaa00002.1、aaa00003.1 という4人のクラウドストレージアカウントが作られているものとします。
sensor8 というバケットがあり、そこにアクセスできるユーザーを、aaa00000.1 と aaa00001.1 の 2人に限定する例を説明していきます。

以下のような内容の sensor8.json というファイルを作成します。説明上 sensor8.json としますが、任意のファイル名で構いません。

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

aaa00002.1 と aaa00003.1 が sensor8 にアクセスできないことを定義しています。
Denyルールが優先されるため、他のポリシーで aaa00002.1 と aaa00003.1 に対して Allowルールが適用されていたとしても、この内容を適用することでアクセスを禁止することができます。

この定義をクラウドストレージに登録します。

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
Arn の 値は、クラウドストレージアカウントへの適用時に必要になるので、控えておいてください。

ABCIクラウドストレージでは、バケットにポリシーを設定することができないため、
このポリシーを制限したいクラウドストレージアカウントに適用します。
`--policy-arn`に指定するポリシーのARNは、ポリシーを登録した時に出力されていますが、 `aws --endpoint-url https://s3.abci.ai iam list-policies` を実行して確認することもできます。

登録したポリシーは以下のようにして aaa00002.1 と aaa00003.1 に適用します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00002.1
```

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00003.1
```

これで aaa00002.1 と aaa00003.1 は、sensor8 バケットにアクセスできなくなりました。aaa00000.1 と aaa00001.1 は、これまで通りアクセスできます。

クラウドストレージアカウントに適用されたポリシーを確認する場合は、`aws --endpoint-url https://s3.abci.ai iam list-attached-user-policies --user-name aaa00002.1`のようにして確認が可能です。

### 例2 バケットにアクセスできるホストを限定する

接続元IPアドレスに基くアクセス制限を設定することができます。
今回は、ABCI内部ネットワーク(10.0.0.0/17)からのアクセスと外部ホスト 203.0.113.2 からのアクセスのどちらでもない場合には拒否する設定を行います。

以下のような内容の src-ip-pc.json というファイルを作成します。

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

この定義をクラウドストレージに登録します。

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

これを、グループ内のクラウドストレージアカウントに適用していきます。以下の例ではクラウドストレージアカウント aaa00004.1 にポリシーを適用しています。ポリシーのARNは、ポリシーを登録した時に出力されています(aws --endpoint-url https://s3.abci.ai iam list-policies を実行して確認することもできます)。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/src-ip-pc --user-name aaa00004.1
```

デフォルトでは制限がかかっていないため、このポリシーを適用していないアカウントは接続元の制限なくアクセスできる状態です。グループ内のクラウドストレージアカウントをリストするには、`aws --endpoint-url https://s3.abci.ai iam list-users` を実行します。

# ABCIクラウドストレージグループ管理者

利用責任者または利用管理者には、ABCIクラウドストレージグループ管理者アカウントが作られます。ABCIクラウドストレージグループ管理者は、データのアップロードやダウンロードなどの他に、アクセスポリシーの設定を行える権限を持っています。デフォルトでは、グループ内のクラウドストレージアカウントはデータにフルアクセス(読み書き両方)できますが、これを例えば特定のクラウドストレージアカウント以外は読み取りのみといった設定に変える場合は、ABCIクラウドストレージグループ管理者がポリシーの設定を行います。


<!--  アクセスキーの管理 (リスト表示は残す? ひとまず残さない) は載せない  -->

<!--  アカウントの作成と削除 も載せない  -->


<!--  TODO: グループとポリシーのサンプル  -->

<!--  TODO: 図を作成  -->


<!--  現時点では default-sub-group は導入されていないので、グループを使わず全員にポリシーを適用してメンバーを限定したバケットを実現するサンプル  -->


## アクセスポリシー

前述のとおり、デフォルトでは、グループ内のクラウドストレージアカウントはバケットにフルアクセス可能な設定になっています。このままで良ければ、この後に説明するポリシーの追加設定を行う必要はありません。特定のクラウドストレージアカウントを読み取りしかできないようにしたい、あるバケットにアクセスできるのは一部のクラウドストレージアカウントだけにしたいなど、細かく制御したい場合には、クラウドストレージグループ管理者アカウントでポリシーの設定を行う必要があります。

ABCIクラウドストレージでは、バケットにポリシーを設定することができないため、グループ内のクラウドストレージアカウント全てにポリシーを適用しなければならないケースがあります。

これからいくつかの例を用いて説明していきますが、以下はどの例でも共通する注意点です。

- エンドポイントは `http://s3.abci.ai:8600` です。s3 のオブジェクトをダウンロードする時などとは異なります
- 順番に関係なく、DenyルールがAllowルールよりも優先されます。同一ポリシー内でなくとも、別のポリシーにDenyルールがあればそれが優先されます
- ポリシーの名前(--policy-nameに指定する名前)は、大文字を使ってもエラーにはなりませんが、問題になるケースがありますので、小文字英字と数字、およびハイフン(0x2d)で構成してください

<!--  http://s3.abci.ai:8600 は暫定。問題が解決されたら https://s3.abci.ai:10443  -->

<!--  デフォルトサブグループが導入されたら、デフォルトのアクセス権限を変更できる  -->


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
[username@es1 ~]$ aws --endpoint-url http://s3.abci.ai:8600 iam create-policy --policy-name sensor8policy --policy-document file://sensor8.json
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

ABCIクラウドストレージでは、バケットにポリシーを設定することができないため、
このポリシーを制限したいクラウドストレージアカウントに適用します。
`--policy-arn`に指定するポリシーのARNは、ポリシーを登録した時に出力されていますが、 `aws --endpoint-url http://s3.abci.ai:8600 iam list-policies` を実行して確認することもできます。

```
[username@es1 ~]$ aws --endpoint-url http://s3.abci.ai:8600 iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00002.1
```

```
[username@es1 ~]$ aws --endpoint-url http://s3.abci.ai:8600 iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00003.1
```

これで aaa00002.1 と aaa00003.1 は、sensor8 バケットにアクセスできなくなりました。aaa00000.1 と aaa00001.1 は、これまで通りアクセスできます。


### 例2 バケットにアクセスできるホストを限定する

接続元IPアドレスに基くアクセス制限を設定することができます。
今回は、ABCI内部ネットワークからのアクセスと外部ホスト 203.0.113.2 からのアクセスのどちらでもない場合には拒否する設定を行います。

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
[username@es1 ~]$ aws --endpoint-url http://s3.abci.ai:8600 iam create-policy --policy-name src-ip-pc --policy-document file://src-ip-pc.json
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

これを、グループ内のクラウドストレージアカウントに適用していきます。以下の例ではクラウドストレージアカウント aaa00004.1 にポリシーを適用しています。ポリシーのARNは、ポリシーを登録した時に出力されています(aws --endpoint-url http://s3.abci.ai:8600 iam list-policies を実行して確認することもできます)。

```
[username@es1 ~]$ aws --endpoint-url http://s3.abci.ai:8600 iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/src-ip-pc --user-name aaa00004.1
```

デフォルトでは制限がかかっていないため、適用していないアカウントは接続元の制限なくアクセスできる状態です。グループ内のクラウドストレージアカウントをリストするには、`aws --endpoint-url http://s3.abci.ai:8600/ iam list-users` を実行します。


<!--  例X サブグループ + 特定のプレフィックス配下のみ  -->

<!--  例X 特定の人を外部からアクセスさせない(接続元IPアドレス制限)  -->

<!--  例X デフォルトサブグループの権限を read only  -->


<!--  ポリシーの更新  特に例1のケース  -->


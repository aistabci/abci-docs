
# アクセス制御(1) - ACLによる制御

クラウドストレージでは、バケットやオブジェクトに対してアクセスコントロールリスト(ACL)を設定することで、誰がアクセスできるかを制御できます。
デフォルトでは、自身のみアクセスできますが、他のユーザー、あるいは誰でもアクセスできるよう設定を変更することができます。

## ACLでの設定項目 {#what-to-configure}

ACLは、誰からの、どの操作を許可をするのかをバケットやオブジェクト毎に設定します。

許可する相手として以下を指定することができます。なお、ある特定のABCIグループを指定することはできません。

| 許可する相手| 説明|
| :--| :--|
| ABCIユーザー                                 |特定のABCIユーザーからのアクセスを許可します。|
| クラウドストレージアカウント保持者全員   |クラウドストレージのクラウドストレージアカウントを持つ全ての利用者からのアクセスを許可します。アクセスには、アクセスキーによる認証を要求します。|
| 誰でも                                       |誰からのアクセスでも許可します。アクセスキーによる認証も要求しません。|

許可する操作は、バケットとオブジェクトで異なります。

許可する操作の一覧：バケット

| 許可する操作	|説明|
| :--| :--|
| read	        |指定したバケット配下にあるオブジェクトの一覧の取得を許可します。|
| write	        |指定したバケット配下で、オブジェクトの作成、消去、変更が可能です。|
| read-acp	    |指定したバケットのACLの取得を許可します。|
| write-acp	    |指定したバケットのACLの変更を許可します。|
| full-control   |上記全てのACLを許可します。|

許可する操作の一覧：オブジェクト

| 許可する操作	|説明|
| :--| :--|
| read| オブジェクトデータの読み込みを許可します。|
| write	        |設定できません。|
| read-acp	    |指定したオブジェクトのACLの取得を許可します。|
| write-acp	    |指定したオブジェクトのACLの変更を許可します。|
| full-control	|上記全てのACLを許可します。|

作成したばかりのバケットやオブジェクトは、自身に対する full-control となっています。

インターネットへの公開のような許可する「相手」と「操作」の組み合わせが定型的なACLは、既定ACLが用意されています。既定ACLについては、後述します。

## ACLの設定方法（設定例） {#how-to-set-acl}

### ABCIユーザー間でのオブジェクトの共有 {#share-objects-between-abci-groups}

ABCIユーザー間でオブジェクトを共有する方法について説明します。
例として、ABCIユーザー aaa00000aa の testdata というオブジェクトを、ABCIユーザー aaa11111aa が読みとれるような許可設定を 行います。

| 共有元ABCI ユーザー  |共有先ABCI ユーザー|
| :--| :--|
| aaa00000aa             |aaa11111aa|

共有するオブジェクトの詳細

| バケット名 |prefix |オブジェクト名|
| :--| :--| :--|
| test-share	|test/	|testdata|

まず、共有相手となるABCIグループに UUID の確認を依頼してください。共有相手側では、aaa11111aa ユーザーのクラウドストレージアカウントで s3 list-bucket を実行し、出力にある Owner.ID の値を確認し、共有元に連絡してください。

```
$ aws --endpoint-url https://s3.v3.abci.ai s3api list-buckets
{
    "Buckets": [
        {
            "Name": "aaa11111aa-bucket-1",
            "CreationDate": "2019-08-22T11:36:17.523Z"
        }
    ],
    "Owner": {
        "DisplayName": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6",
        "ID": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6"
    }
}
```

共有元では、以下のようにオブジェクトにACLを設定します。読み込み(read)のみの操作は --grant-read を指定し、被付与者として共有相手の正規IDを指定します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --grant-read id=1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6 --bucket test-share --key test/testdata
```

設定の結果を確認します。デフォルトでは、Grantsの要素に、aaa11111aa の要素が Permission "READ" で追加されています。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket test-share --key test/testdata
{
    "Owner": {
        "DisplayName": "aaa00000aa",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "aaa11111aa",
                "ID": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6",
                "Type": "CanonicalUser"
            },
            "Permission": "READ"
        }
    ]
}
```

設定を戻すときは、以下のように ACL を private に設定すれば、初期値が設定されます。
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl private --bucket test-share --key test/testdata
```
バケットに他のグループのwrite権限を付与し、他のグループがオブジェクトをアップロードした場合、そのオブジェクトの利用量は、バケットを所有しているABCIグループの「クラウドストレージ容量」としてカウントされます。クラウドストレージ容量のためにはABCIポイントが必要です。

### クラウドストレージの全アカウントに公開 {#open-to-all-accounts-on-abci-cloud-storage}

クラウドストレージの全アカウントに公開するには `--acl` に `authenticated-read` を指定します。
以下は、aaa00000aa-bucket-2 というバケットの dataset.txt というオブジェクトに設定する例です。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl authenticated-read  --bucket aaa00000aa-bucket-2 --key dataset.txt
```

### パブリックアクセス {#public-access}

誰からでもアクセスできるようにする（パブリックアクセス）設定は、次の２つの既定ACLを用いて行うことができます。それぞれ、バケットあるいはオブジェクトに適用します。

| 既定ACL           |バケット                                                                                   |オブジェクト|
| :--| :--| :--|
| public-read       |指定したバケット配下のオブジェクト一覧が公開されます。                                     |指定したオブジェクトが公開されます。オブジェクトの変更は、適切な権限を有するクラウドストレージアカウントのみ が行えます。
| public-read-write |誰もが、指定したバケット配下の読み書き、およびACLの変更が可能になります。|誰もがACLを適用したオブジェクトの読み書き、およびA CLの変更が可能になります。

!!! caution
    誰からでも読み取りアクセスができる設定を行う場合は、下記をよくお読みいただき、データを公開することが適切であるかご確認の上、設定をお願いします。

    * [ABCI約款・規約](https://abci.ai/ja/how_to_use/)
    * [ABCIクラウドストレージ規約](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf)

!!! caution
    第三者によって意図しない利用がなされる恐れがありますので、public-read-write は設定しないでください。

デフォルトの既定ACLは private が設定されています。公開を停止する場合は、private を設定してください。

#### バケットの公開 {#public-buckets}

既定ACL「public-read」をバケットに適用することで、そのバケット配下のオブジェクトの一覧が公開されます。ここでは、以下のバケットを公開する例で説明します。

| 適用ACL        |公開バケット|
| :--| :--|
| public-read	|test-pub|

put-bucket-acl で public-read を設定します。設定の確認は get-bucket-acl を用いて行います。public を示すURI "http://acs.amazonaws.com/groups/global/AllUsers" の Permission に READ が付与された Grantee が追加されていることを確認してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-acl --acl public-read --bucket test-pub
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket test-pub
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        },
        {
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AllUsers"
            },
            "Permission": "READ"
        }
    ]
}
```

アクセスができることの確認は、curlコマンドにより「https://s3.vs.abci.ai/バケット名」にアクセスすることでも可能です。バケットtest-pubの場合は、 "curl https://s3.v3.abci.ai/test-pub "とアクセスしてください。
(現在はインターネットブラウザ経由でのURLアクセスはご利用いただけません)
公開を停止し、初期値に戻す手順は以下の通りです。 追加された Grantee がなくなり、ABCIグループ名がの Permission が "FULL_CONTROL" になっていることを確認してください。

```
[username@login1 ~]$ aws --endpoint-url https://test-pub.s3.v3.abci.ai s3api put-bucket-acl --acl private --bucket test-pub
[username@login1 ~]$ aws --endpoint-url https://test-pub.s3.v3.abci.ai s3api get-bucket-acl --bucket test-pub
{
    "Owner": {
        "DisplayName": "gxx00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gxx00000",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```

#### オブジェクトの公開 {#public-objects}

既定ACL「public-read」をオブジェクトに適用することで、そのオブジェクトを公開することができます。ここでは、以下のオブジェクトを公開する例で説明します。

| 適用ACL      |バケット  |prefix  |公開オブジェクト|
| :--| :--| :--| :--|
| public-read	  |test-pub2 |test/   |test.txt    |

put-object-acl で public-read を設定します。また、get-object-acl で設定状況を確認できます。public を示すURI "http://acs.amazonaws.com/groups/global/AllUsers" の Permission に READ が付与された Grantee が追加されていることを確認してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --bucket test-pub2 --acl public-read --key test/test.txt
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl--bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        },
        {
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AllUsers"
            },
            "Permission": "READ"
        }
    ]
}
```

アクセスができることの確認はインターネットブラウザで https://test-pub2.s3.v3.abci.ai/test/test.txt にアクセスすることでも可能です。Firefoxの場合は、オブジェクトのデータが表示されます。
(現在はインターネットブラウザ経由でのURLアクセスはご利用いただけません)
公開を停止し、初期値に戻す手順は以下の通りです。 追加された Grantee がなくなり、ABCIグループ名がの Permission が "FULL_CONTROL" になっていることを確認してください。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl private --bucket  test-pub2 --key test/test.txt
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```


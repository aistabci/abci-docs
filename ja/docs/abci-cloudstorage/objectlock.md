# アクセス制御(4) - Object Lock によるオブジェクト消去の防止

ABCIクラウドストレージでは、Object Lock を利用することで意図しないオブジェクトの消去に備えることができます。
予め Object Lock を有効にしたバケット上でオブジェクトを作成すると、自動的にオブジェクト作成時のバージョンが作成され、さらに保護されます。
このため、これらのオブジェクトは、変更や削除などの操作をされても、作成時の状態に復元することができます。

!!! note
    Object Lock を有効にしたバケットは、Versioning が自動的に有効になります。

Object Lock を有効にする手順は以下の通りです。

* バケット作成 (s3api create-bucket --object-lock-enabled-for-bucket)
* バケットに保持構成を設定 (s3api put-object-lock-configuration)
  
以下の章では、Object Lock の利用について説明します。

## Object Lock の保持構成

Object Lockで指定できる条件は以下の通りです。

* リテンションモード
* 保持期間
  
リテンションモードでは、保護のレベルが異なるGOVERNANCEモードとCOMPLIANCEモードを選択可能です。GOVERNANCEモードは、ロックしたオブジェクトのバージョンをコマンド `s3api delete-object` での削除はできませんが、オプション `--bypass-governance-retention` を付与することで削除が可能です。また、COMPLIANCEモードでは保持期間が終わるまで削除が不可能になります。

!!! note
    ABCIクラウドストレージでは、`s3:BypassGovernanceRetention` パーミッションの操作をサポートしていません。


保持期間は、保持する日数または年数を指定することができますが、日数と年数の同時指定はできません。

!!! note
    ABCIでは通常年度末に利用期間を終了とするため、保持期間はABCIの利用期間を踏まえて検討してください。

## バケットの作成

Object Lock を有効にしたバケットを `s3api create-bucket` コマンドにオプション `--object-lock-enabled-for-bucket` を付与して作成します。
以下に、バケット "object-lock-1" を作成する例を示します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api create-bucket --bucket obj-lock-1 --object-lock-enabled-for-bucket
{
    "Location": "/obj-lock-1"
}
```

!!! note
    `s3 mb` コマンドでは作成できません。

作成したバケットは `s3api object-lock-configuration` コマンドで確認できます。"ObjectLockEnabled" が "Enabled" となっていれば成功です。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-lock-configuration --bucket obj-lock-1
{
    "ObjectLockConfiguration": {
        "ObjectLockEnabled": "Enabled"
    }
}
```

## 保持構成の設定

上記で作成したバケットに、保持構成を設定します。設定できる条件は以下の通りです。

| 指定パラメータ| 説明|
| :-:| :-: |
| MODE| GOVERNANCE または COMPLIANCE|
| Days| 日数で保持日数を指定。Yearsと同時指定は不可|
| Years| 年数で保持年数を指定。Daysと同時指定は不可| 

!!! Warning
    保持期間にABCI のご利用期間以上の期間を設定しないでください。ご利用期間後にも削除されずにオブジェクトが残存してしまう場合があります。

保持構成は、`s3api put-object-lock-configuration` コマンドの `--object-lock-configuration` オプションに続く文字列で設定します。
以下の例では、リテンションモードにGOVERNANCEモード、保持期間を１日に設定しています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-lock-configuration --bucket obj-lock-1 --object-lock-configuration 'ObjectLockEnabled=Enabled,Rule={DefaultRetention={Mode=GOVERNANCE,Days=1}}'
```

設定した条件を表示し、"DefaultRetention" の "Mode"と"Days"を確認します。
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-lock-configuration --bucket obj-lock-1
{
    "ObjectLockConfiguration": {
        "ObjectLockEnabled": "Enabled",
        "Rule": {
            "DefaultRetention": {
                "Mode": "GOVERNANCE",
                "Days": 1
            }
        }
    }
}
```

以上で、Object Lock の設定は完了です。

## オブジェクトに設定された保持構成の確認

オブジェクトに適用された保持構成は、`s3api head-object` コマンドで表示される "ObjectLockMode" と "ObjectLockRetainUntilDate" で確認が可能です。
確認可能な項目は、リテンションモードと保持期間が終了する日時(UTC)です。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api head-object --bucket obj-lock-1 --key 10M_test.dat
{
    "AcceptRanges": "bytes",
    "LastModified": "2022-05-10T21:55:27+00:00",
    "ContentLength": 10485760,
    "ETag": "\"0d051de1058f114e76dd517355fe9dbf-2\"",
    "VersionId": "3938333437373830323732353133393939393939524730303120203838322e343037313139382e3434",
    "Metadata": {},
    "ObjectLockMode": "COMPLIANCE",
    "ObjectLockRetainUntilDate": "2022-05-12T21:55:27.222000+00:00"
}
```

## 保持構成の変更

バケットに設定した保持構成は、`s3api ut-object-lock-configuration` コマンドで条件を上書きすることで変更が可能です。

!!! note
    新しい保持構成は設定完了後に作成したオブジェクトから適用されます。既にあるオブジェクトには適用されず元の保持構成が適用されたままとなります。

以下の例では、リテンションモードがGOVERNANCE, 保持期間が２日の条件から、COMPLIANCEモード、保持期間を４日に変更する例です。

変更前の状態

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-lock-configuration --bucket obj-lock-1
{
    "ObjectLockConfiguration": {
        "ObjectLockEnabled": "Enabled",
        "Rule": {
            "DefaultRetention": {
                "Mode": "GOVERNANCE",
                "Days": 2
            }
        }
    }
}
```

リテンションモードをCOMPLIANCE、保持期間を４日にとする保持構成に変更

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-lock-configuration --bucket obj-lock-1 --object-lock-configuration 'ObjectLockEnabled=Enabled,Rule={DefaultRetention={Mode=COMPLIANCE,Days=4}}'
```

変更後の保持構成の確認。"Mode"と"Days"が変更されていることわかります。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai -s3api get-object-lock-configuration --bucket obj-lock-1
{
    "ObjectLockConfiguration": {
        "ObjectLockEnabled": "Enabled",
        "Rule": {
            "DefaultRetention": {
                "Mode": "COMPLIANCE",
                "Days": 4
            }
        }
    }
}
```

## オブジェクトの復元

ここでは削除してしまったオブジェクトを Object Lock を適用したバージョンに復元する手順を説明します。

Object Lock が適用されたオブジェクト"10M_test.dat"を `s3 rm` で削除すると、以下のようにバケットからは削除されたように見えます。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://obj-lock-1
2022-06-02 08:55:07   10485760 10M_test.dat
2022-06-02 09:02:14         13 dl_testmessage
[username@es1 ~]$
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rm s3://obj-lock-1/10M_test.dat
delete: s3://obj-lock-1/10M_test.dat
[username@es1 ~]$
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://obj-lock-1
2022-06-02 09:02:14         13 dl_testmessage
```

しかし、オブジェクトのバージョンを確認すると元のバージョンに加え"DeleteMarkers"に削除した状態が記録され、かつ最新の状態("IsLatest": true)であることがわかります。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api list-object-versions --bucket obj-lock-1 --prefix 10M_test
{
    "Versions": [
        {
            "ETag": "\"0d051de1058f114e76dd517355fe9dbf-2\"",
            "Size": 10485760,
            "StorageClass": "STANDARD",
            "Key": "10M_test.dat",
            "VersionId": "3938333435383732323932303930393939393939524730303120203838322e343235313830342e3438",
            "IsLatest": false,
            "LastModified": "2022-06-01T23:55:07.908000+00:00",
            "Owner": {
                "DisplayName": "gxa50001",
                "ID": "ea8537bc620c2c4b614d37e312a04bab50a631c774f7f09828f7b11210c8b61a"
            }
        }
    ],
    "DeleteMarkers": [
        {
            "Owner": {
                "DisplayName": "gxa50001",
                "ID": "ea8537bc620c2c4b614d37e312a04bab50a631c774f7f09828f7b11210c8b61a"
            },
            "Key": "10M_test.dat",
            "VersionId": "3938333435383730343635353936393939393939524730303120203838322e343235313830382e3530",
            "IsLatest": true,
            "LastModified": "2022-06-02T00:25:34.403000+00:00"
        }
    ]
}
```

オブジェクトの復元は元のバージョン以外のオブジェクトのバージョンを削除します。バージョンの削除は、`s3api delete-object`にオブジェクトのvsersion-id を指定して削除します。この例では "DeleteMarkers" にエントリされた "VersionId" を指定します。

!!! note
    各バージョンのオブジェクトは必要に応じてバックアップしてください。
    `s3api copy-object --bucket BUCKETNAME  --copy-source BACKETNAME/SRC_OBJECT_NAME?versionId=VERSIONID --key DST_OBJECT_NAME`

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api delete-object --bucket obj-lock-1 --key 10M_test.dat --version-id 3938333435383730343635353936393939393939524730303120203838322e343235313830382e3530
{
    "DeleteMarker": true,
    "VersionId": "3938333435383730343635353936393939393939524730303120203838322e343235313830382e3530"
}
```

Object Lock を適用したバージョンのみになるまでオブジェクトのバージョンを削除します。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api list-object-versions --bucket obj-lock-1 --prefix 10M_test.dat
{
    "Versions": [
        {
            "ETag": "\"0d051de1058f114e76dd517355fe9dbf-2\"",
            "Size": 10485760,
            "StorageClass": "STANDARD",
            "Key": "10M_test.dat",
            "VersionId": "3938333435383732323932303930393939393939524730303120203838322e343235313830342e3438",
            "IsLatest": true,
            "LastModified": "2022-06-01T23:55:07.908000+00:00",
            "Owner": {
                "DisplayName": "gxa50001",
                "ID": "ea8537bc620c2c4b614d37e312a04bab50a631c774f7f09828f7b11210c8b61a"
            }
        }
    ]
}
```

これで削除されたオブジェクトの復元は完了です。
以下の例では `s3 ls` コマンドで、"10M_test.dat" が復元したことを確認しています。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://obj-lock-1
2022-06-02 08:55:07   10485760 10M_test.dat
2022-06-02 09:02:14         13 dl_testmessage
```

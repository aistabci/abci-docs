
# ABCIクラウドストレージのデータ移行

ここでは、ABCIクラウドストレージに保存しているデータを別ストレージへ移行する方法を説明します。

## 移行準備

まずは、ABCIクラウドストレージからデータを取得できるようアクセスキーの発行、設定を行います。

アクセスキーの発行方法は[利用者ポータルガイド](https://docs.abci.ai/portal/ja/02/#282)を参照してください。

ABCIクラウドストレージのクライアントとして`rclone`を利用します。
ABCIではrcloneを提供していますので、次のコマンドを実行してrcloneを使えるようにしてください。

```
[username@es ~]$ module load rclone
```

### rcloneの設定 {#rclone-config}

rcloneの設定は`rclone config`コマンドを使用して、対話的に行います。
ここではABCIクラウドストレージおよびAmazon S3を利用する場合の設定項目を記載しますので、下記の表を参考にrcloneの設定を行なってください。

詳細は[rcloneの設定例](#example-of-rclone-configuration)も参照してください。

`リモート名`、`アクセスキー`、`シークレットアクセスキー`は適宜変更してください。

```
[username@es ~]$ rclone config
```

設定項目(ABCIクラウドストレージ):

| 項目名 | 値 | 説明 |
| -- | -- | -- |
| リモート名(`name>`) | `abci` | アクセス先を示す名称。 |
| ストレージタイプ(`Storage>`) | `5` | Amazon S3準拠のストレージ(`s3`)。 |
| プロバイダー(`provider>`) | `25` | その他(`Other`)のS3プロバイダー。 |
| クレデンシャル(`env_auth>`) | `1` | AWSクレデンシャルを入力する。 |
| アクセスキー(`access_key_id>`) | `ACCESS-KEY` | ABCI利用者ポータルで発行したアクセスキー。 |
| シークレットアクセスキー(`secret_access_key>`) | `SECRET-ACCESS-KEY` | ABCI利用者ポータルで発行したシークレットアクセスキー。 |
| リージョン(`region>`) | `us-east-1` | ABCIクラウドストレージのリージョン。 |
| エンドポイント(`endpoint>`) | `https://s3.abci.ai` | ABCIクラウドストレージのエンドポイント。 |
| 場所の制約(`location_constraint>`) | (空白) | 初期値。 |
| ACL(`acl>`) | `1` | 所有者に`FULL_CONTROLL`を付与。 |

設定項目(Amazon S3):

| 項目名 | 値 | 説明 |
| -- | -- | -- |
| リモート名(`name>`) | `s3` | アクセス先を示す名称。 |
| ストレージタイプ(`Storage>`) | `5` | Amazon S3準拠のストレージ(`s3`)。 |
| プロバイダー(`provider>`) | `1` | Amazon S3。 |
| クレデンシャル(`env_auth>`) | `1` | AWSクレデンシャルを入力する。 |
| アクセスキー(`access_key_id>`) | `ACCESS-KEY` | AWSのアクセスキー。 |
| シークレットアクセスキー(`secret_access_key>`) | `SECRET-ACCESS-KEY` | AWSのシークレットアクセスキー。 |
| リージョン(`region>`) | `14` | Amazon S3のリージョン。ここでは東京リージョンを指定しています。 |
| エンドポイント(`endpoint>`) | (空白) | 初期値。 |
| 場所の制約(`location_constraint>`) | (空白) | 初期値。 |
| ACL(`acl>`) | `1` | 所有者に`FULL_CONTROLL`を付与。 |
| サーバーサイド暗号化(`server_side_encryption>`) | (空白) | 初期値。 |
| SSE KMS ID(`sse_kms_key_id>`) | (空白) | 初期値。 |
| ストレージクラス(`storage_class>`) | (空白) | 初期値。 |


## ABCI 3.0のグループ領域へ移行する

ABCI 3.0のグループ領域はABCI 2.0のインタラクティブノードからは`/groups-new/grpname`として参照できます。
`grpname`には利用者自身のABCIグループが入ります。

ABCIクラウドストレージの`bucket`バケットから`/groups-new/grpname/bucket`ディレクトリにデータをコピーする場合は以下のコマンドを実行します。

```
[username@es ~]$ rclone copy abci:bucket /groups-new/grpname/bucket --multi-thread-streams 0 --transfers 8 --fast-list --no-traverse
```

コピーしたオブジェクトがABCIクラウドストレージ内のものと一致するかは`rclone check`コマンドで確認できます。

```
[username@es ~]$ rclone check abci:bucket /groups-new/grpname/bucket
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 0 differences found
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 121 hashes could not be checked
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 435 matching files
```

使用したrcloneのオプションについては以下の通りです。

| オプション | 説明 |
| -- | -- |
| `--fast-list` | 事前にファイル一覧を取得します。メモリ使用量が増えますが、クラウドストレージとのトランザクションが減少します。 |
| `--no-traverse` | 書き込み先のディレクトリ情報の取得をスキップします。 |
| `--transfers` | 並行して実行するファイル転送の数。|
| `--multi-thread-streams` | マルチスレッドダウンロードの最大ストリーム数(デフォルト:4)。0の場合シングルスレッドでダウンロードします。 |


## Amazon S3へ移行する

rcloneを利用してAmazon S3にデータを転送することもできます。

ここではABCIクラウドストレージのリモート名を`abci`、Amazon S3のリモート名を`s3`として説明します。上述の[rcloneの設定](#rclone-config)を参考に設定しておいてください。
ABCIクラウドストレージの`bucket`バケットからAmazon S3にある`s3-bucket`バケットにデータをコピーするには以下のコマンドを実行します。

```
[username@es ~]$ rclone copy abci:bucket s3:s3-bucket --transfers 8 --fast-list --no-traverse --s3-upload-concurrency 8 --s3-chunk-size 64M
```

ABCIクラウドストレージの`bucket`バケット内のオブジェクトがAmazon S3の`s3-bucket`下にコピーされます。

コピーしたオブジェクトがABCIクラウドストレージ内のものと一致するかは`rclone check`コマンドで確認できます。

```
[username@es ~]$ rclone check abci:bucket s3:s3-bucket
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 0 differences found
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 121 hashes could not be checked
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 435 matching files
```

使用したrcloneのオプションについては以下の通りです。

| オプション | 説明 |
| -- | -- |
| `--fast-list` | 事前にファイル一覧を取得します。メモリ使用量が増えますが、クラウドストレージとのトランザクションが減少します。 |
| `--no-traverse` | 書き込み先のディレクトリ情報の取得をスキップします。 |
| `--transfers` | 並行して実行するファイル転送の数。|
| `--s3-upload-concurrency` | マルチパートアップロード時の並列数。(デフォルト:4) |
| `--s3-chunk-size` | マルチパートアップロード時のチャンクサイズ。(デフォルト:5MiB) |


## rcloneの設定例 {#example-of-rclone-configuration}

以下は`rclone config`の実行例です。

### ABCIクラウドストレージの設定例

```
[username@es ~]$ rclone config
2024/10/31 8:15:00 NOTICE: Config file "/home/username/.config/rclone/rclone.conf" not found - using defaults
No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

Enter name for new remote.
name> abci

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
--(snip)--
 5 / Amazon S3 Compliant Storage Providers including AWS, Alibaba, Ceph, China Mobile, Cloudflare, ArvanCloud, DigitalOcean, Dreamhost, Huawei OBS, IBM COS, IDrive e2, IONOS Cloud, Liara, Lyve Cloud, Minio, Netease, RackCorp, Scaleway, SeaweedFS, StackPath, Storj, Tencent COS, Qiniu and Wasabi
   \ (s3)
--(snip)--
Storage> 5

Option provider.
Choose your S3 provider.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
--(snip)--
25 / Any other S3 compatible provider
   \ (Other)
provider> 25

Option env_auth.
Get AWS credentials from runtime (environment variables or EC2/ECS meta data if no env vars).
Only applies if access_key_id and secret_access_key is blank.
Choose a number from below, or type in your own boolean value (true or false).
Press Enter for the default (false).
 1 / Enter AWS credentials in the next step.
   \ (false)
--(snip)--
env_auth> 1

Option access_key_id.
AWS Access Key ID.
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
access_key_id> EXAMPLE-KEY

Option secret_access_key.
AWS Secret Access Key (password).
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
secret_access_key> EXAMPLE-SECRET-KEY

Option region.
Region to connect to.
Leave blank if you are using an S3 clone and you don't have a region.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
   / Use this if unsure.
 1 | Will use v4 signatures and an empty region.
   \ ()
   / Use this only if v4 signatures don't work.
 2 | E.g. pre Jewel/v10 CEPH.
   \ (other-v2-signature)
region> us-east-1

Option endpoint.
Endpoint for S3 API.
Required when using an S3 clone.
Enter a value. Press Enter to leave empty.
endpoint> https://s3.abci.ai

Option location_constraint.
Location constraint - must be set to match the Region.
Leave blank if not sure. Used when creating buckets only.
Enter a value. Press Enter to leave empty.
location_constraint> 

Option acl.
Canned ACL used when creating buckets and storing or copying objects.
This ACL is used for creating objects and if bucket_acl isn't set, for creating buckets too.
For more info visit https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
Note that this ACL is applied when server-side copying objects as S3
doesn't copy the ACL from the source but rather writes a fresh one.
If the acl is an empty string then no X-Amz-Acl: header is added and
the default (private) will be used.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
   / Owner gets FULL_CONTROL.
 1 | No one else has access rights (default).
   \ (private)
--(snip)--
acl> 1

Edit advanced config?
y) Yes
n) No (default)
y/n> n

Configuration complete.
Options:
- type: s3
- provider: Other
- access_key_id: EXAMPLE-KEY
- secret_access_key: EXAMPLE-SECRET-KEY
- region: us-east-1
- endpoint: https://s3.abci.ai
- acl: private
Keep this "abci" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y

Current remotes:

Name                 Type
====                 ====
abci                 s3

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q
```

### Amazon S3の設定例 {#rclone-config-s3}

```
[username@es ~]$ rclone config
2024/10/31 8:15:00 NOTICE: Config file "/home/username/.config/rclone/rclone.conf" not found - using defaults
No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

Enter name for new remote.
name> s3

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
--(snip)--
 5 / Amazon S3 Compliant Storage Providers including AWS, Alibaba, Ceph, China Mobile, Cloudflare, ArvanCloud, DigitalOcean, Dreamhost, Huawei OBS, IBM COS, IDrive e2, IONOS Cloud, Liara, Lyve Cloud, Minio, Netease, RackCorp, Scaleway, SeaweedFS, StackPath, Storj, Tencent COS, Qiniu and Wasabi
   \ (s3)
--(snip)--
Storage> 5

Option provider.
Choose your S3 provider.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / Amazon Web Services (AWS) S3
   \ (AWS)
provider> 1

Option env_auth.
Get AWS credentials from runtime (environment variables or EC2/ECS meta data if no env vars).
Only applies if access_key_id and secret_access_key is blank.
Choose a number from below, or type in your own boolean value (true or false).
Press Enter for the default (false).
 1 / Enter AWS credentials in the next step.
   \ (false)
 2 / Get AWS credentials from the environment (env vars or IAM).
   \ (true)
env_auth> 1

Option access_key_id.
AWS Access Key ID.
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
access_key_id> EXAMPLE-KEY

Option secret_access_key.
AWS Secret Access Key (password).
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
secret_access_key> EXAMPLE-SECRET-KEY

Option region.
Region to connect to.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
--(snip)--
   / Asia Pacific (Tokyo) Region.
14 | Needs location constraint ap-northeast-1.
   \ (ap-northeast-1)
--(snip)--
region> 14

Option endpoint.
Endpoint for S3 API.
Leave blank if using AWS to use the default endpoint for the region.
Enter a value. Press Enter to leave empty.
endpoint>

Option location_constraint.
Location constraint - must be set to match the Region.
Used when creating buckets only.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
--(snip)--
location_constraint>

Option acl.
Canned ACL used when creating buckets and storing or copying objects.
This ACL is used for creating objects and if bucket_acl isn't set, for creating buckets too.
For more info visit https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
Note that this ACL is applied when server-side copying objects as S3
doesn't copy the ACL from the source but rather writes a fresh one.
If the acl is an empty string then no X-Amz-Acl: header is added and
the default (private) will be used.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
   / Owner gets FULL_CONTROL.
 1 | No one else has access rights (default).
   \ (private)
--(snip)--
acl> 1

Option server_side_encryption.
The server-side encryption algorithm used when storing this object in S3.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / None
   \ ()
--(snip)--
server_side_encryption>

Option sse_kms_key_id.
If using KMS ID you must provide the ARN of Key.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / None
   \ ()
--(snip)--
sse_kms_key_id>

Option storage_class.
The storage class to use when storing new objects in S3.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / Default
   \ ()
--(snip)--
storage_class>

Edit advanced config?
y) Yes
n) No (default)
y/n> n

Configuration complete.
Options:
- type: s3
- provider: AWS
- access_key_id: EXAMPLE-KEY
- secret_access_key: EXAMPLE-SECRET-KEY
- region: ap-northeast-1
- acl: private
Keep this "s3" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y

Current remotes:

Name                 Type
====                 ====
s3                   s3

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q
```

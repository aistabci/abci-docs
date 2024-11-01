
# ABCI Cloud Storage Data Migration

This section explains how to migrate data stored in ABCI cloud storage to another storage.

## Prerequisites

First, set up and issue an access key so you can retrieve data from the ABCI cloud storage.

For instructions on issuing an access key, please refer to the [User Portal Guide](https://docs.abci.ai/portal/en/02/#282).

The `rclone` will be used as the client for ABCI cloud storage. Since ABCI provides rclone, please run the following command to make it available for use.

```
[username@es ~]$ module load rclone
```

### rclone config

The `rclone config` command is used to configure rclone interactively.

Here, we list the configuration items required for using ABCI cloud storage and Amazon S3. Please refer to the table below when setting up rclone.

For further details, please also refer to the [rclone configuration examples](#rclone-config-example).

Please replace `Name`, `Access Key`, and `Secret Access Key` as appropriate.

```
[username@es ~]$ rclone config
```

Setting Items(ABCI Cloud Storage):

| Item | Value | Description |
| -- | -- | -- |
| Name(`name>`) | `abci` | The name indicating the access destination. |
| Type of storage(`Storage>`) | `5` | Amazon S3 Compliant Storage(`s3`)。 |
| Provider(`provider>`) | `25` | Any other S3 compatible provider(`Other`). |
| Credentials(`env_auth>`) | `1` | Enter AWS credentials. |
| Access key(`access_key_id>`) | `ACCESS-KEY` | Access key issued by ABCI. |
| Secret access key(`secret_access_key>`) | `SECRET-ACCESS-KEY` | Secret access key issued by ABCI. |
| Region(`region>`) | `us-east-1` | ABCI cloud storage region. |
| Endpoint(`endpoint>`) | `https://s3.abci.ai` | ABCI cloud storage endpoint. |
| Location constraint(`location_constraint>`) | (empty) | Initial value. |
| ACL(`acl>`) | `1` | Gives owner `FULL_CONTROLL`. |

Setting Items(Amazon S3):

| Item | Value | Description |
| -- | -- | -- |
| Name(`name>`) | `s3` | The name indicating the access destination. |
| Storage type(`Storage>`) | `5` | Amazon S3 Compliant Storage(`s3`). |
| Provider(`provider>`) | `1` | Amazon S3. |
| Credentials(`env_auth>`) | `1` | Enter AWS credentials. |
| Access key(`access_key_id>`) | `ACCESS-KEY` | Access key issued by AWS. |
| Secret access key(`secret_access_key>`) | `SECRET-ACCESS-KEY` | Secret access key issued by AWS |
| Region(`region>`) | `14` | Amazon S3 region. The Tokyo region is specified. |
| Endpoint(`endpoint>`) | (empty) | Initial value. |
| Location constraint(`location_constraint>`) | (empty) | Initial value. |
| ACL(`acl>`) | `1` | Gives owner `FULL_CONTROLL`. |
| Server side encryption(`server_side_encryption>`) | (empty) | Initial value. |
| SSE KMS ID(`sse_kms_key_id>`) | (empty) | Initial value. |
| Storage class(`storage_class>`) | (empty) | Initial value. |

## Migrating to ABCI 3.0 group area

The ABCI 3.0 group area can be accessed from the interactive nodes of the ABCI 2.0 system at `/groups-new/grpname`.
Replace `grpname` with your own ABCI group name.

To copy data from the `bucket` bucket in ABCI cloud storage to the `/groups-new/grpname/bucket` directory, run the following command.

```
[username@es ~]$ rclone copy abci:bucket /groups-new/grpname/bucket --multi-thread-streams 0 --transfers 8 --fast-list --no-traverse
```

You can use the `rclone check` command to check whether the copied data matches what is in the ABCI cloud storage.

```
[username@es ~]$ rclone check abci:bucket /groups-new/grpname/bucket
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 0 differences found
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 121 hashes could not be checked
2024/10/31 8:15:00 NOTICE: Local file system at /groups-new/grpname/bucket: 435 matching files
```

The rclone command options used are as follows:

| Option | Description |
| -- | -- |
| `--fast-list` | Pre-fetch the file list, which increases memory usage but reduces transactions with cloud storage. |
| `--no-traverse` | Skip getting destination directory information. |
| `--transfers` | The number of file transfers to perform in parallel. |
| `--multi-thread-streams` | Number of streams for multi-threaded download (default: 4). If 0, download in single thread. |

## Migrating to Amazon S3

You can also use the `rclone` command to transfer data to Amazon S3.

Here, we will refer to the remote name of the ABCI cloud storage as `abci` and the remote name of Amazon S3 as `s3`.
Please configure these settings according to the [rclone configuration](#rclone-config) mentioned above.

To copy data from the `bucket` bucket in ABCI cloud storage to the `s3-bucket` bucket in Amazon S3, run the following command.

```
[username@es ~]$ rclone copy abci:bucket s3:s3-bucket --transfers 8 --fast-list --no-traverse --s3-upload-concurrency 8 --s3-chunk-size 64M
```

You can use the `rclone check` command to check whether the copied data matches what is in the ABCI cloud storage.

```
[username@es ~]$ rclone check abci:bucket s3:s3-bucket
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 0 differences found
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 121 hashes could not be checked
2024/10/31 8:15:00 NOTICE: S3 bucket s3-bucket: 435 matching files
```

The rclone command options used are as follows:

| Option | Description |
| -- | -- |
| `--fast-list` | Pre-fetch the file list, which increases memory usage but reduces transactions with cloud storage. |
| `--no-traverse` | Skip getting destination directory information. |
| `--transfers` | The number of file transfers to perform in parallel. | 
| `--s3-upload-concurrency` | The number of parallel uploads for multipart uploads. (Default: 4) |
| `--s3-chunk-size` | Chunk size for multipart uploads. (Default: 5MiB) |

## Example of rclone configuration

Below is an example of running `rclone config`.

### Configuration example for ABCI Cloud Storage

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

### Configuration example for Amazon S3

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

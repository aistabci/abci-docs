# How to Use ABCI Object Storage (Under Update)

This section describes how to use ABCI Object Storage as a client tool by using AWS Command Line Interface (AWS CLI).


## Load Module

On the ABCI system, AWS CLI is available both in interactive nodes and in compute nodes. Load the module before using AWS CLI as following.

```
[username@login1 ~]$ module load aws-cli
```

When using AWS CLI outside ABCI (for example, on your PC), get AWS CLI from [here](https://github.com/aws/aws-cli) and install it by following the guide.


## Configuration

In order to access ABCI Object Storage, ABCI users need to use a Object Storage Account that is different from ABCI account. Users are allowed to have multiple Object Storage Accounts. Access Key which is a pair of Access Key ID and Secret Access Key is issued for each Object Storage Account. If a user belongs to multiple ABCI groups and uses ABCI Object Storage from multiple groups, multiple Object Storage Accounts is issued per group. When accessing ABCI Object Storage for the first time, Access Key should be set up in AWS CLI as shown below. Specify `us-east-1` as region name. 
```
[username@login1 ~]$ aws configure
AWS Access Key ID [None]: ACCESS-KEY-ID
AWS Secret Access Key [None]: SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(No input required)
```

A user can switch with the option '--profile' if a user has multiple Object Storage Accounts.
In order to configure the Object Storage Account 'aaa00000.2', for example, follow the instruction below.
```
[username@login1 ~]$ aws configure --profile aaa00000.2
AWS Access Key ID [None]: aaa00000.2's ACCESS-KEY-ID
AWS Secret Access Key [None]: aaa00000.2's SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(No input required)
```

When running the AWS commands with the Object Storage Account 'aaa00000.2', use the option '--profile' as follows.
```
[username@login1 ~]$ aws --profile aaa00000.2 --endpoint-url https://s3.v3.abci.ai s3api list-buckets
```

The configuration is stored in the home directory(i.e. ~/.aws). Therefore, it is not necessarily done in the compute node once it is done in the interacvtive node.

To reissuing or deleting Access Keys, use ABCI User Portal.

## Operations

This section explains basic operations, such as creating buckets and uploading data and so forth.

### For the Begining

Here is basic knowledge which is necessary so as to use AWS CLI.

The structure of AWS CLI commands is shown below.
```
aws [options] <command> <subcommand> [parameters]
```
For instance, in a sentence `aws --endpoint-url https://s3.v3.abci.ai s3 ls`, s3 is a &lt;command&gt; and ls is a &lt;subcommand&gt; (ls command of s3 command or s3 ls command).

The command `s3` will show the path of an object in S3 URI.
The following example shows how s3 works.

```
s3://bucket-1/project-1/docs/fig1.png
```

In this example, `bucket-1` means a name of the bucket and `project-1/docs/fig1.png` is an object key (or a key name). The part `project-1/docs/` is called prefix which is used for describing object keys as if they are as hierarchic systems as "folders" in file systems.

There are rules for naming buckets.

* It must be unique across ABCI Object Storage.
* The numbers of characters should be between 3 and 63.
* It can not include underscores (_).
* The first character must be a small letter of alphabets or numbers.
* A structure such as IP address (e.g. 192.168.0.1) is not allowed.
* Using dots(.) is not recommended.

To name object keys, UTF-8 characters are available though, there are special characters which should be preferably avoided.

* There is no problem with using hyphens (-), underscores (_) and periods (.).
* Five characters, exclamation mark (!), asterisk (*), apostrophe ('),  left parenthesis ('(') and right parenthesis (')'), are available if they are properly used (e.g. escaping or quoting in shell scripts).

Special characters other than the ones mentioned above should be avoided.

Specify https://s3.v3.abci.ai as an endpoint (--endpoint-url).<!-- `http://s3.v3.abci.ai` is also availble from the interactive node and compute node. --> 


### Create Bucket

To create a bucket, use s3 mb command.
A bucket whose name is 'dataset-summer-2024', for example, can be created by running aws commands as following.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mb s3://dataset-summer-2024
make_bucket: dataset-summer-2024
```


### List Bucket

To show the list of buckets created on the ABCI group, run `aws --endpoint-url https://s3.v3.abci.ai s3 ls`.

For example
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls
2019-06-15 10:47:37 testbucket1
2019-06-15 18:10:37 testbucket2
```


### List Object

To show the list of objects in the bucket, run `aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://bucket-name`.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket
                           PRE pics/
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
```

In order to list objects that have prefix 'pics/', for example, add prefix after the bucket name.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket/pics/
2019-07-29 21:55:57    1048576 test3.png
2019-07-29 21:55:59    1048576 test4.png
```

The option '--recursive' can list all objects in a bucket.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
2019-07-29 21:55:57    1048576 pics/test3.png
2019-07-29 21:55:59    1048576 pics/test4.png
```


### Copy data (Upload, Download, Copy)

Data can be copied from the file system to a bucket in ABCI Object Storage, from a bucket in ABCI Object Storage to the file system and from a bucket in ABCI Object Storage to another bucket in ABCI Object Storage.

Example: Copy the file '0001.jpg' to the bucket 'dataset-c0541'
```
[username@login1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp ./images/0001.jpg s3://dataset-c0541/
upload: images/0001.jpg to s3://dataset-c0541/0001.jpg
[username@login1 ~]$
```

Example: Copy files in the directory 'images' to the bucket 'dataset-c0542'
```
[username@login1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp images s3://dataset-c0542/ --recursive
upload: images/0001.jpg to s3://dataset-c0542/0001.jpg
upload: images/0002.jpg to s3://dataset-c0542/0002.jpg
upload: images/0003.jpg to s3://dataset-c0542/0003.jpg
upload: images/0004.jpg to s3://dataset-c0542/0004.jpg
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://dataet-c0542/
2019-06-10 19:03:19    1048576 0001.jpg
2019-06-10 19:03:19    1048576 0002.jpg
2019-06-10 19:03:19    1048576 0003.jpg
2019-06-10 19:03:19    1048576 0004.jpg
[username@login1 ~]$
```

Example: Copy the file 'logo.png' from the bucket 'dataset-tmpl-c0000' to the bucket 'dataset-c0541'
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://dataset-tmpl-c0000/logo.png s3://dataset-c0541/logo.png
copy: s3://dataset-tmpl-c0000/logo.png to s3://dataset-c0541/logo.png
```


### Move Data

To move objects, use aws mv.
It allows users to move objects from the local file system to a bucket and vice versa.
Time stamps are not be preserved.
This command can handle objects which have specific prefix with option '--recursive'
and files which are stored in specific directories.

The example shown next transfers 'annotaitions.zip' in current directory to a bucket 'dataset-c0541' in ABCI Cloud Storage.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mv annotations.zip s3://dataset-c0541/
move: ./annotations.zip to s3://dataset-c0541/annotations.zip
```

The example shown next transfers the objects which have prefix 'sensor-1' in a bucket 'dataset-c0541' to a bucket 'dataset-c0542'.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mv s3://dataset-c0541/sensor-1/ s3://dataset-c0542/sensor-1/ --recursive
move: s3://dataset-c0541/sensor-1/0001.dat to s3://dataset-c0542/sensor-1/0001.dat
move: s3://dataset-c0541/sensor-1/0003.dat to s3://dataset-c0542/sensor-1/0003.dat
move: s3://dataset-c0541/sensor-1/0004.dat to s3://dataset-c0542/sensor-1/0004.dat
move: s3://dataset-c0541/sensor-1/0002.dat to s3://dataset-c0542/sensor-1/0002.dat
```


### Synchronize Local Directory with ABCI Cloud Storage

Here is an example that synchronizes a directory 'sensor2' in current directory and a bucket 'mybucket'. If an option '--delete' is not given, exsiting objects in the bucket will not be deleted and exsiting objects which have same names with the ones in the current directory will be overwritten. When executing same command again, only updated data will be sent.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 sync ./sensor2 s3://mybucket/
upload: sensor2/0002.dat to s3://mybucket/0002.dat
upload: sensor2/0004.dat to s3://mybucket/0004.dat
upload: sensor2/0001.dat to s3://mybucket/0001.dat
upload: sensor2/0003.dat to s3://mybucket/0003.dat
```

The following example sychronizes objects with the prefix 'rev1' in the bucket 'sensor3' to the directory 'testdata.'
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 sync s3://sensor3/rev1/ testdata
download: s3://sensor3/rev1/0001.zip to testdata/0001.zip
download: s3://sensor3/rev1/0004.zip to testdata/0004.zip
download: s3://sensor3/rev1/0003.zip to testdata/0003.zip
download: s3://sensor3/rev1/0002.zip to testdata/0002.zip
```

!!! note
    When executing same command again, data whose size is not changed will be ignored even though the data is actually updated. In that case, the option '--exact-timestamps' enables to syncronize them. This option syncronizes all objects particularly only in the ABCI environment.


### Delete Object

To delete an object, use `aws s3 rm <S3Uri> [parameters]`

For example 
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rm s3://mybucket/readme.txt
delete: s3://mybucket/readme.txt
```

The option '--recursive' enables to delete objects which are located under specified prefix.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
2019-07-31 14:51:50        512 xml/c.xml
2019-07-31 14:51:54        512 xml/d.xml
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rm s3://mybucket/xml --recursive
delete: s3://mybucket/xml/c.xml
delete: s3://mybucket/xml/d.xml
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
```


### Delete Bucket

The command example shown next deletes the bucket 'dataset-c0541.'
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 rb s3://dataset-c0541
remove_bucket: dataset-c0541
```

An error will happen when deleting non-empty buckets. By adding the option '--force', both ojects in the bucket and the bucket itself can be deleted.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai rb s3://dataset-c0542 --force
delete: s3://dataset-c0542/0001.jpg
delete: s3://dataset-c0542/0002.jpg
delete: s3://dataset-c0542/0003.jpg
delete: s3://dataset-c0542/0004.jpg
remove_bucket: dataset-c0542
```

### Check Object Owner

To display object owner, use the `s3api get-object-acl` command. As shown in the example below, BUCKET is the bucket name, OBJECT is the object name and the owner is displayed in "Owner".

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket BUCKET --key OBJECT
{
    "Owner": {
        "DisplayName": "ABCIGROUP",
        "ID": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "ABCIGROUP",
                "ID": "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```

### MPU

Uploading from a local file system, client applications upload data efficiently by automatically splitting the data and sending it in parallel. This is called a multipart upload (MPU). MPU is applied when the threshold of data size defined in the client application is exceeded. For instance, the default threshold is [8MB](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#multipart-threshold) for aws-cli and [15MB](https://s3tools.org/kb/item13.htm) for s3cmd.

### Uploading Data with Manual MPU

The following describes how to apply MPU manually.

!!! note
    It is recommended to use MPU automatically by the client application.

First, using the `split` command to split the file. In the following example,
15M_test.dat is divided into three parts.

```
[username@login1 ~]$ split  -n 3 -d 15M_test.dat mpu_part-
total 3199056
-rw-r----- 1 username group   15728640 Nov 30 15:42 15M_test.dat
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-02
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-01
-rw-r----- 1 username group    5242880 Nov 30 15:51 mpu_part-00
[username@login1 ~]$
```

Then starting MPU with the command `s3api create-multipart-upload`, specifying the destination bucket and path. The following example creates an object named 'mpu-sample' in the bucket 'testbucket-00'. If successful, `UploadId` is issued as follows:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api create-multipart-upload --bucket testbucket-00 --key mpu-sample

{
    "Bucket": "testbucket-00",
    "Key": "mpu-sample",
    "UploadId": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    
}
```

To Upload files splited above use the `s3api part-upload` command, with the 'UpLoadId' specified above. Note the 'ETag' for later use.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 1 --body mpu_part-00 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"sample1d8560e70ca076c897e0715024\""
}
```

Similarly, it sequentially uploads the rest of the files corresponding to the values specified by `--part-number`.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 2 --body mpu_part-01 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"samplee36a6ef6ae8f2c0ea3328c5e7c\""
}
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api upload-part --bucket testbucket-00 --key mpu-sample --part-number 3 --body mpu_part-02 --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "ETag": "\"sample9e391d5673d2bfd8951367eb01\""
}
[username@login1 ~]$
```

!!! note
    Uploaded data by `s3api upload-parts` is not displayed but charged, so MPU must be completed or aborted.

After uploading all the files, create a JSONE file with the ETag value as follows:

```
[username@login1 ~]$ cat mpu_fileparts.json
{
    "Parts":[{
        "ETag": "sample1d8560e70ca076c897e0715024",
        "PartNumber": 1
    },
    {
        "ETag": "samplee36a6ef6ae8f2c0ea3328c5e7c",
        "PartNumber": 2
    },
    {
        "ETag": "sample9e391d5673d2bfd8951367eb01",
        "PartNumber": 3
    }]
}
```

Finally, to complete MPU use the command `s3api complete-multipart-upload`. At this time, the object is created that you specify with `--key`.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api complete-multipart-upload --multipart-upload file://mpu_fileparts.json --bucket testbucket-00 --key mpu-sample --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
{
    "Location": "http://testbucket-00.s3.v3.abci.ai/mpu-sample",
    "Bucket": "testbucket-00",
    "Key": "mpu-sample",
    "ETag": "\"6203f5cdbecbe0556e2313691861cb99-3\""
}
```

You can verify that the object has been created as follows:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 ls s3://testbucket-00/
2020-12-01 09:28:03   15728640 mpu-sample
```

### Aborting Data Upload with Manual MPU {#abort-mpu}

First, display MPU list and get `UploadId` and `Key` from the list. 
To list MPU, use the `s3api list-multipart-uploads` command with the bucket name. If there is no MPU left, nothing is displayed.
The following example shows data remaining on the server while uploading the object "data_10gib-1.dat" to 's3://BUCKET/Testdata/'.
The path and object name are displayed in `Key`.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api list-multipart-uploads --bucket BUCKET
{
    "Uploads": [
        {
            "UploadId": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            "Key": "Testdata/data_10gib-1.dat",
            "Initiated": "2019-11-12T09:58:16.242000+00:00",
            "StorageClass": "STANDARD",
            "Owner": {
                "DisplayName": "ABCI GROUP",
                "ID": "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
            },
            "Initiator": {
                "ID": "arn:aws:iam::123456789123:user/USERNAME",
                "DisplayName": "USERNAME"
            }
        }
    ]
}
```

Then, aborting the MPU, deletes the data on the server.
To abort the MPU, use `s3api abort -multipart -upload` command with specified `UploadId` and `Key` of the MPU. If the command succeeds, a prompt is returned.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api abort-multipart-upload --bucket Testdata --key Testdata/data_10gib-1.dat --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
[username@login1 ~]$
```

<!--  Is s3fs-fuse another ?  -->

<!--  The detail way to use is not described, Cyberduck and WinSCP is described. -->

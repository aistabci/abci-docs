# How to Use ABCI Cloud Storage

This section describes how to use ABCI Cloud Storage as a client tool by using AWS Command Line Interface (AWS CLI).


## Load Module

On the ABCI system, AWS CLI is available both in interactive nodes and in compute nodes. Load the module before using AWS CLI as following.

```
[username@es1 ~]$ module load aws-cli
```

When using AWS CLI outside ABCI (for example, on your PC), get AWS CLI from [here](https://github.com/aws/aws-cli) and install it by following the guide.


## Configuration

In order to access ABCI Cloud Storage, ABCI users need to use a Cloud Storage Account that is different from ABCI account. Users are allowed to have multiple Cloud Storage Accounts. Access Key which is a pair of Access Key ID and Secret Access Key is issued for each Cloud Storage Account. If a user belongs to multiple ABCI groups and uses ABCI Cloud Storage from multiple groups, multiple Cloud Storage Accounts is issued per group. When accessing ABCI Cloud Storage for the first time, Access Key should be set up in AWS CLI as shown below. Specify `us-east-1` as region name. 
```
[username@es1 ~]$ aws configure
AWS Access Key ID [None]: ACCESS-KEY-ID
AWS Secret Access Key [None]: SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(No input required)
```

A user can switch with the option '--profile' if a user has multiple Cloud Storage Accounts.
In order to configure the Cloud Storage Account 'aaa00000.2', for example, follow the instruction below.
```
[username@es1 ~]$ aws configure --profile aaa00000.2
AWS Access Key ID [None]: aaa00000.2's ACCESS-KEY-ID
AWS Secret Access Key [None]: aaa00000.2's SECRET-ACCESS-KEY
Default region name [None]: us-east-1
Default output format [None]:(No input required)
```

When running the AWS commands with the Cloud Storage Account 'aaa00000.2', use the option '--profile' as follows.
```
[username@es1 ~]$ aws --profile aaa00000.2 --endpoint-url https://s3.abci.ai s3api list-buckets
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
For instance, in a sentence `aws --endpoint-url https://s3.abci.ai s3 ls`, s3 is a &lt;command&gt; and ls is a &lt;subcommand&gt; (ls command of s3 command or s3 ls command).

The command `s3` will show the path of an object in S3 URI.
The following example shows how s3 works.

```
s3://bucket-1/project-1/docs/fig1.png
```

In this example, `bucket-1` means a name of the bucket and `project-1/docs/fig1.png` is an object key (or a key name). The part `project-1/docs/` is called prefix which is used for describing object keys as if they are as hierarchic systems as "folders" in file systems.

There are rules for naming buckets.

* It must be unique across ABCI Cloud Storage.
* The numbers of characters should be between 3 and 63.
* It can not include underscores (_).
* The first character must be a small letter of alphabets or numbers.
* A structure such as IP address (e.g. 192.168.0.1) is not allowed.
* Using dots(.) is not recommended.

To name object keys, UTF-8 characters are available though, there are special characters which should be preferably avoided.

* There is no problem with using hyphens (-), underscores (_) and periods (.).
* Five characters, exclamation mark (!), asterisk (*), apostrophe ('),  left parenthesis ('(') and right parenthesis (')'), are available if they are properly used (e.g. escaping or quoting in shell scripts).

Special characters other than the ones mentioned above should be avoided.

Specify https://s3.abci.ai as an endpoint (--endpoint-url).<!-- `http://s3.abci.ai` is also availble from the interactive node and compute node. --> 


### Create Bucket

To create a bucket, use s3 mb command.
A bucket whose name is 'dataset-summer-2012', for example, can be created by running aws commands as following.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mb s3://dataset-summer-2012
make_bucket: dataset-summer-2012
```


### List Bucket

To show the list of buckets created on the ABCI group, run `aws --endpoint-url https://s3.abci.ai s3 ls`.

For example
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls
2019-06-15 10:47:37 testbucket1
2019-06-15 18:10:37 testbucket2
```


### List Object

To show the list of objects in the bucket, run `aws --endpoint-url https://s3.abci.ai s3 ls s3://bucket-name`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket
                           PRE pics/
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
```

In order to list objects that have prefix 'pics/', for example, add prefix after the bucket name.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket/pics/
2019-07-29 21:55:57    1048576 test3.png
2019-07-29 21:55:59    1048576 test4.png
```

The option '--recursive' can list all objects in a bucket.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket --recursive
2019-07-05 17:33:05          4 test1.txt
2019-07-05 21:12:47          4 test2.txt
2019-07-29 21:55:57    1048576 pics/test3.png
2019-07-29 21:55:59    1048576 pics/test4.png
```


### Copy data (Upload, Download, Copy)

Data can be copied from the file system to a bucket in ABCI Cloud Storage, from a bucket in ABCI Cloud Storage to the file system and from a bucket in ABCI Cloud Storage to another bucket in ABCI Cloud Storage.

Example: Copy the file '0001.jpg' to the bucket 'dataset-c0541'
```
[username@es1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp ./images/0001.jpg s3://dataset-c0541/
upload: images/0001.jpg to s3://dataset-c0541/0001.jpg
[username@es1 ~]$
```

Example: Copy files in the directory 'images' to the bucket 'dataset-c0542'
```
[username@es1 ~]$ ls images
0001.jpg    0002.jpg    0003.jpg    0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp images s3://dataset-c0542/ --recursive
upload: images/0001.jpg to s3://dataset-c0542/0001.jpg
upload: images/0002.jpg to s3://dataset-c0542/0002.jpg
upload: images/0003.jpg to s3://dataset-c0542/0003.jpg
upload: images/0004.jpg to s3://dataset-c0542/0004.jpg
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://dataet-c0542/
2019-06-10 19:03:19    1048576 0001.jpg
2019-06-10 19:03:19    1048576 0002.jpg
2019-06-10 19:03:19    1048576 0003.jpg
2019-06-10 19:03:19    1048576 0004.jpg
[username@es1 ~]$
```

Example: Copy the file 'logo.png' from the bucket 'dataset-tmpl-c0000' to the bucket 'dataset-c0541'
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp s3://dataset-tmpl-c0000/logo.png s3://dataset-c0541/logo.png
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
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mv annotations.zip s3://dataset-c0541/
move: ./annotations.zip to s3://dataset-c0541/annotations.zip
```

The example shown next transfers the objects which have prefix 'sensor-1' in a bucket 'dataset-c0541' to a bucket 'dataset-c0542'.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mv s3://dataset-c0541/sensor-1/ s3://dataset-c0542/sensor-1/ --recursive
move: s3://dataset-c0541/sensor-1/0001.dat to s3://dataset-c0542/sensor-1/0001.dat
move: s3://dataset-c0541/sensor-1/0003.dat to s3://dataset-c0542/sensor-1/0003.dat
move: s3://dataset-c0541/sensor-1/0004.dat to s3://dataset-c0542/sensor-1/0004.dat
move: s3://dataset-c0541/sensor-1/0002.dat to s3://dataset-c0542/sensor-1/0002.dat
```


### Synchronize Local Directory with ABCI Cloud Storage

Here is an example that synchronizes a directory 'sensor2' in current directory and a bucket 'mybucket'. If an option '--delete' is not given, exsiting objects in the bucket will not be deleted and exsiting objects which have same names with the ones in the current directory will be overwritten. When executing same command again, only updated data will be sent.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 sync ./sensor2 s3://mybucket/
upload: sensor2/0002.dat to s3://mybucket/0002.dat
upload: sensor2/0004.dat to s3://mybucket/0004.dat
upload: sensor2/0001.dat to s3://mybucket/0001.dat
upload: sensor2/0003.dat to s3://mybucket/0003.dat
```

The following example sychronizes objects with the prefix 'rev1' in the bucket 'sensor3' to the directory 'testdata.'
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 sync s3://sensor3/rev1/ testdata
download: s3://sensor3/rev1/0001.zip to testdata/0001.zip
download: s3://sensor3/rev1/0004.zip to testdata/0004.zip
download: s3://sensor3/rev1/0003.zip to testdata/0003.zip
download: s3://sensor3/rev1/0002.zip to testdata/0002.zip
```

!!! note
    When executing same command again, data whose size is not changed will be ignored even though the data is actually updated. In that case, the option '--exact-timestamps' enables to syncronize them. This option syncronizes all objects particularly only in the ABCI environment.


### Delete Object

To delete a object, use `aws s3 rm <S3Uri> [parameters]`

For example 
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rm s3://mybucket/readme.txt
delete: s3://mybucket/readme.txt
```

The option '--recursive' enables to delete objects which are located under specified prefix.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
2019-07-31 14:51:50        512 xml/c.xml
2019-07-31 14:51:54        512 xml/d.xml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rm s3://mybucket/xml --recursive
delete: s3://mybucket/xml/c.xml
delete: s3://mybucket/xml/d.xml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://mybucket --recursive
2019-07-30 20:46:53         32 a.txt
2019-07-30 20:46:53         32 b.txt
```


### Delete Bucket

The command example shown next deletes the bucket 'dataset-c0541.'
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 rb s3://dataset-c0541
remove_bucket: dataset-c0541
```

An error will happen when deleting non-empty buckets. By adding the option '--force', both ojects in the bucket and the bucket itself can be deleted.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai rb s3://dataset-c0542 --force
delete: s3://dataset-c0542/0001.jpg
delete: s3://dataset-c0542/0002.jpg
delete: s3://dataset-c0542/0003.jpg
delete: s3://dataset-c0542/0004.jpg
remove_bucket: dataset-c0542
```

<!--  Is s3fs-fuse another ?  -->

<!--  The detail way to use is not described, Cyberduck and WinSCP is described. -->

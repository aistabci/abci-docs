# Access Control(4) - Preventing objects loss by Object Lock

ABCI Cloud Storage offers Object Lock to help avoid unexpected object loss.
When objects are created in the bucket applied Object Lock in advance, the version is created and protected automatically.
As a result, these objects can be restored, even if they have been modified or deleted.

!!! note
    Enabling Object Lock, bucket versioning is enabled automatically.

Enabling Object Lock requires the following steps.

* Creating bucket with option (s3api create-bucket --object-lock-enabled-for-bucket)
* Putting retention configuration for the bucket (s3api put-object-lock-configuration)
  
The following sections describe  how to use Object Lock.

## Object Lock Configuration

To configure Object Lock, two parameters are needed as follows.

* Retention modes
* Retention periods

Object Lock provides two retention modes with different levels of protection: GOVERNANCE mode and COMPLIANCE mode.
In GOVERNANCE mode, the version cannot be deleted by command `s3api delete-object` usually. To delete the objects, you need to add option `--bypass-governance-retention` option to the command.
Also in COMPLIANCE mode is the objects cannot be deleted until the retention period expires.

!!! note
    ABCI Cloud Storage does not support the operation of `s3: BypassGovernance Retention` permission like Amazon S3.

The retention period specifies the number of days or years to protect the version. But both days and years cannot be specified at the same time.

!!! note
    ABCI will be serviced until the end of March, so please consider that the retention period does not exceeds the last day of ABCI service.

## Creating Bucket

To create a bucket configured Object Lock, use option `--object-lock-enabled-to-bucket` for bucket create command.
The following example creates a bucket "object-lock-1".

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api create-bucket --bucket obj-lock-1 --object-lock-enabled-for-bucket
{
    "Location": "/obj-lock-1"
}
```

!!! note
    It cannot be created by the `s3 mb` command.

To check configuration of the bucket, use command `s3api object-lock-configuration`.If "ObjectLockEnabled" is "Enabled", Object Lock is enabled.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-lock-configuration --bucket obj-lock-1
{
    "ObjectLockConfiguration": {
        "ObjectLockEnabled": "Enabled"
    }
}
```

## Setting Retention Configuration

To set up the retention configuration for the bucket.
The below table lists items of retention configuration.

| Item| Description|
| :-:| :-: |
| MODE| GOVERNANCE or COMPLIANCE|
| Days| the number of days, cannot be specified with Years at same time.|
| Years| the number of years, cannot be specified with Days at same time.| 

!!! Warning
    Do not set a retention period that exceeds the ABCI service period. Your objects may remain after the expiration date.

To configure the retention configuration for the bucket, use `s3api put-object-lock-configuration` and option `--object-lock-configuration`.
The retention configuration is set in "DefaultRetention" of the option.
The following example is the retention mode to GOVERNANCE mode and the retention period to 1 day.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-lock-configuration --bucket obj-lock-1 --object-lock-configuration 'ObjectLockEnabled=Enabled,Rule={DefaultRetention={Mode=GOVERNANCE,Days=1}}'
```

To check the configuration, use command `s3api get-object-lock-configuration`.

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

Setting of Object Lock is completed.

## Checking the Retention Status of Objects

To display retention status of the objects, use command `s3api head-object` and check items "ObjectLockMode" and "ObjectLockRetainUntilDate".

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

## Modifying a Retention Configuration

The retention configuration for a bucket can be modified by overwriting the new condition.

!!! note
    A new configuration is applied to only objects created after the bucket modified. The objects that have been already exist does not apply new configuration.

The following example is to change retention mode from GOVERNANCE mode to COMPLIANCE mode and retention period from 2 days to 4 days.

Before the change

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

Change retention mode to COMPLIANCE and retention period to 4 days

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-lock-configuration --bucket obj-lock-1 --object-lock-configuration 'ObjectLockEnabled=Enabled,Rule={DefaultRetention={Mode=COMPLIANCE,Days=4}}'
```

To check the modified retention configuration.

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

## Restoring Object

This section describes how to restore a deleted object to its Object Lock version.

When you delete object "10M_test.dat" by command `s3 rm`, it no longer appears in the bucket as follows.

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

But the version remains in "DeleteMarkers" and is latest version ("IsLatest": true).

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

To restore the object, use command `s3api delete-object` with version-id to delete all versions of the object except the original version. 
The following example is to delete version-id in "DeleteMarkers".

!!! note
    Back up each version of the object as needed.

    `s3api copy-object --bucket BUCKETNAME --copy-source YOURBACKET/SRCYOUROBJECT?versionId=VERSIONID --key DSTYUORNAME`

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api delete-object --bucket obj-lock-1 --key 10M_test.dat --version-id 3938333435383730343635353936393939393939524730303120203838322e343235313830382e3530
{
    "DeleteMarker": true,
    "VersionId": "3938333435383730343635353936393939393939524730303120203838322e343235313830382e3530"
}
```

Make sure remaining the version applied Object Lock.

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

Object restore is now complete.
The follwing example is to display restored object "10M_test.dat" by `S3 ls`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 ls s3://obj-lock-1
2022-06-02 08:55:07   10485760 10M_test.dat
2022-06-02 09:02:14         13 dl_testmessage
```

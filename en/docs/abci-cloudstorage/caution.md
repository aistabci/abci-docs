# Cautions for Using ABCI Cloud Storage

## Charge for MPU Failed {#notice-mpu-fail}

ABCI points may be charged when data uploading by Multipart Upload (MPU) fails, so a solution is described here.
If you encounter the following items during data upload: 

* Uploading data whose data size exceeds the threshold of MPU defined by the client application, and
* Failed to upload data, such as by forcing the client application to stop,

please check the instructions below.

!!! note 
    The default data size which MPU applies is [8MB](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#multipart-threshold) for aws-cli and [15MB](https://s3tools.org/kb/item13.htm) for s3cmd.

### Details of MPU Failure and Charging

ABCI Cloud Storage supports Multipart Uload (MPU), which speeds up uploads by sending splite data in parallel.
MPU is effective automatically for the data whose size exceeds the threshold defined by a client application, for example, threshold of aws-cli is 8MB by default.
While data uploading by MPU, the divided data is stored in a temporary area on the server and then moved to the specified path as an object after the upload is complete.

Here, the above temporary area is subject to accounting, so you need to be careful when MPU fails.
This situation does not occur with properly stop operation, such as stopping aws-cli with 'CTRL-C', but may occurs due to the forced termination of the client or disconnect communication unexpectedly.
At this time, data stored in the temporary area is not deleted automatically, so unintended charges may occur.

To avoid the unintended charge, aborting manually MPU by yourself. The procedure for aborting MPU is described below.

### Aborting MPU

First, display MPU list and get `UploadId` and `Key` of failed MPU from the list. 
To list MPU, use the `s3api list-multipart-uploads` command with the bucket name. If there is no MPU left, nothing is displayed.
The following example shows data remaining on the server when aws-cli was killed while uploading the object "data_10gib-1.dat" to 's3://Bucket/Testdata'.
The path and object name are displayed in `Key`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api list-multipart-uploads --bucket BUCKET
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

Then, stop the corresponding MPU. Aborting the MPU, deletes the data in the temporary storage area.
To abort the MPU, use `s3api abort -multipart -upload` command with specified `UploadId` and `Key` of the MPU. If the command succeeds, the prompt is returned.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api abort-multipart-upload --bucket Testdata --key Testdata/data_10gib-1.dat --upload-id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
[username@es1 ~]$
```


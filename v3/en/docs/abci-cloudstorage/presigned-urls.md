
# Presigned URLs
Presigned URLs are URLs that contain time-limited authentication information. By generating a presigned URL and sharing it with other users, those users can access the object without needing separate credentials. This mechanism allows you to make an object available to many users for a limited time simply by sharing the URL, without making the object publicly accessible.

## Usage
A presigned URL can be generated with the following command.
Specify the target object in [s3 object path], and set the publication period in seconds in [--expires-in <expiration time (seconds)\>]. There is currently no limitation on the expiration period. If the [--expires-in] option is omitted, the default value of 3600 seconds (1 hour) is used.
```
aws [options] s3 presign [s3 object path] [--expires-in <expiration time (seconds)>]
```

## Use cases
In this example, a presigned URL is generated for the object 'file01.txt' located in the bucket 'bucket-test'.
```
[username01@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://bucket-test/file01.txt -
This is file01.txt!
```
To generate a presigned URL for this object with an expiration time of 300 seconds, run the following command.
```
[username01@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 presign s3://bucket-test/file01.txt --expires-in 300
https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282
```
By accessing the presigned URL output as shown below, other users will also be able to access the object.
```
[username02@login1 ~]$ curl "https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282"
This is file01.txt!
```
A presigned URL that has expired cannot be accessed, as shown below.
```
[username02@login1 ~]$ curl "https://s3.v3.abci.ai/bucket-test/file01.txt?AWSAccessKeyId=AKIA750J0679G14AF406&Signature=fUzqEYce8eqkEZT4w5MFrw%2F6QMI%3D&Expires=1759474282"
<?xml version="1.0" encoding="UTF-8"?><Error><Code>AccessDenied</Code><Message>Access Denied</Message><RequestId>4F60982696162049</RequestId><HostId>00000000000000000</HostId></Error>
```
A presigned URL cannot be disabled directly until it expires. If you wish to stop access via the presigned URL after sharing it, please refer to [Operations](./usage.md#operations) and disable the URL by deleting or renaming the target object.
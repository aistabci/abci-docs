
# Encrypt data

## Outline of Encryption

There are two typical encryptions for cloud storages. The one is Client-Side Encryption (CSE) and another one is Server-Side Encryption (SSE). SSE needs to provide functionality from storage side. The ABCI Cloud Storage supports SSE.

Data is encrypted when it is stored in disks after uploading to the ABCI Cloud Storage. Encrypted data is decryped after retrieving data from the disk. Then the data will be downloaded. Thus, data are decrypted while transferring through the routes though, communications are encrypted by TLS with specifying 'https://s3.abci.ai' as an endpoint.

Amazon S3 provides SSE shown in the table below. The ABCI Cloud Storage provides SSE functionality equivalent to SSE-S3. However, it is technically slightly different from SSE-S3 provided by Amazon S3, so that APIs available for Amazon S3 don't work for the ABCI Cloud Storage. Neither SSE-C nor SSE KMS are available for the ABCI Cloud Storage.

| SSE Type | Description |
| :-- | :-- |
| SSE-S3 | Encryption with key managed on storage side. |
| SSE-C | Encryption with key included to request by user. |
| SSE-KMS | Encryption with key registerd to Key Management Service. |

CSE is available for the ABCI Cloud Storage. However, ABCI doesn't offer Key Management Service (KMS), so users should be careful.
For detailed information, see [Protecting Data Using Client-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingClientSideEncryption.html).

| CSE Type | Description |
| :-- | :-- |
| CSE-C | Encryption with key managed on client side by user. |
| CSE-KMS | Encryption with key registered to Key Management Service |


## Create Buckets with Encryption

To create buckets with activated SSE, use create-encrypted-bucket provided by ABCI system instead of using the aws commands.
The following example shows how to create a bucket 'dataset-s0001'.

```
[username@es1 ~]$ create-encrypted-bucket --endpoint-url https://s3.abci.ai s3://dataset-s0001
create-encrypted-bucket Success.
```

!!! note
    The above is encrypted when storing the object on the server using the key stored on the storage side (decrypted when reading), it is not encrypted with information unique to the transmission request such as access key.

!!! note
    There is no way to later enable encryption for buckets that do not have encryption enabled.


## Confirm a bucket with activated SSE

To confirm if a bucket is created with activated SSE, there should be objects in the bucket because meta data of objects is necessary. Thus, if the bucket is empty, create an object.

To confirm, run the `aws s3api head-object`.
The following example screens meta data of 'cat.jpg' uploaded to the bucket 'dataset-s0001.' The bucket is created with activated encryption because the string "ServerSideEncryption": "AES256" is listed. Unless the string is listed, the bucket is without encryption.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api head-object --bucket dataset-s0001 --key cat.jpg
{
    "LastModified": "Tue, 30 Jul 2019 09:34:18 GMT",
    "ContentLength": 1048576,
    "ETag": "\"c951191fe4fa27c0d054a8456c6c20d1\"",
    "ServerSideEncryption": "AES256",
    "Metadata": {}
}
```

<!-- CSE? -->

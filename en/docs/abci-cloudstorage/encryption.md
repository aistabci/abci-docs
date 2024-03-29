
# Data Encryption

## Outline of Encryption

There are two typical encryptions for cloud storages. The one is Client-Side Encryption (CSE) and another one is Server-Side Encryption (SSE). SSE needs to provide functionality from storage side. The ABCI Cloud Storage supports SSE.

Data is encrypted when it is stored in disks after uploading to ABCI Cloud Storage. Encrypted data is decrypted after retrieving data from the disk. Then the data will be downloaded. Thus, data are decrypted while transferring through the routes though, communications are encrypted by TLS with specifying `https://s3.abci.ai` as an endpoint.

Amazon S3 provides SSE shown in the table below. ABCI Cloud Storage provides SSE functionality equivalent to SSE-S3. SSE-C and SSE-KMS are not available for ABCI Cloud Storage.

| SSE Type | Description |
| :-- | :-- |
| SSE-S3 | Encryption with key managed on storage side. |
| SSE-C | Encryption with key included to request by user. |
| SSE-KMS | Encryption with key registered to Key Management Service. |

CSE encrypts and decrypts data by the user, and stores the encrypted data in ABCI cloud storage.
CSE is available for ABCI cloud storage.

However, ABCI doesn't offer Key Management Service (KMS), so CSE using encryption keys registered to KMS cannot be used.
For detailed information, see [Protecting Data Using Client-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingClientSideEncryption.html).

| CSE Type | Description |
| :-- | :-- |
| CSE-C | Encryption with key managed on client side by user. |
| CSE-KMS | Encryption with key registered to Key Management Service |

!!! note
    Since the start of operation, ABCI Cloud Storage has provided the create-encrypted-bucket command to create an SSE-enabled bucket, but the create-encrypted-bucket command is scheduled to be discontinued by August 2022.
    After August, please use the aws-cli command instead of the create-encrypted-bucket command.
    Buckets previously created with the create-encrypted-bucket command can still be used. You can delete buckets or refer configuration with the aws-cli command.


## Enabling Default Bucket Encryption

You can set the default encryption behavior for a bucket. If you enable default encryption for a bucket, all objects will have encryption when stored in the bucket.
To enable default encryption for a bucket, run `aws s3api put-bucket-encryption`. Note that the bucket must be created beforehand.
The following example shows how to enable default encryption for a bucket `dataset-s0001`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-encryption --bucket dataset-s0001 --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'
```

!!! note
    The default encryption for a bucket is encrypted when storing the object on the server using the key stored on the storage side (decrypted when reading), it is not encrypted with information unique to the transmission request such as access key.

!!! note
    Objects, which existed in the bucket before the bucket's default encryption was enabled, are not encrypted.


## Confirming Default Bucket Encryption

To confirm if a bucket is activated default encryption, run `aws s3api get-bucket-encryption`.

The following example screens show bucket `dataset-s0001` with default encryption enabled. The bucket is activated default encryption because the string `"SSEAlgorithm": "AES256"` is listed. Unless the string is listed, the bucket is without default encryption.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-bucket-encryption --bucket dataset-s0001
{
    "ServerSideEncryptionConfiguration": {
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                },
                "BucketKeyEnabled": false
            }
        ]
    }
}
```

In addition, you can run `aws s3api head-object` to confirm if object encryption is activated, along with the object metadata.
The following example confirm if encryption of `cat.jpg` uploaded to the bucket `dataset-s0001` is activated.
The object is uploaded with activated encryption because the string `"ServerSideEncryption": "AES256"` is listed.

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


# Data Encryption

## Outline of Encryption

There are two typical encryptions for cloud storages. The one is Client-Side Encryption (CSE) and another one is Server-Side Encryption (SSE). SSE needs to provide functionality from storage side. The ABCI Cloud Storage supports SSE.

Data is encrypted when it is stored in disks after uploading to ABCI Cloud Storage. Encrypted data is decryped after retrieving data from the disk. Then the data will be downloaded. Thus, data are decrypted while transferring through the routes though, communications are encrypted by TLS with specifying 'https://s3.abci.ai' as an endpoint.

Amazon S3 provides SSE shown in the table below. ABCI Cloud Storage provides SSE functionality equivalent to SSE-S3. SSE-C and SSE-KMS are not available for ABCI Cloud Storage.

| SSE Type | Description |
| :-- | :-- |
| SSE-S3 | Encryption with key managed on storage side. |
| SSE-C | Encryption with key included to request by user. |
| SSE-KMS | Encryption with key registerd to Key Management Service. |

CSE is available for ABCI Cloud Storage. However, ABCI doesn't offer Key Management Service (KMS), so users should be careful.
For detailed information, see [Protecting Data Using Client-Side Encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingClientSideEncryption.html).

| CSE Type | Description |
| :-- | :-- |
| CSE-C | Encryption with key managed on client side by user. |
| CSE-KMS | Encryption with key registered to Key Management Service |

!!! note
    Since the start of operation, ABCI Cloud Storage has provided the create-encrypted-bucket command to create a bucket with activated enabled, but the create-encrypted-bucket command is scheduled to be discontinued by August 2022.
    Buckets previously created with the create-encrypted-bucket command can still be used. You can delete buckets or refer configuration with the aws-cli command.


## Enabling Default Bucket Encryption

You can set the default encryption befavior for a bucket. If you enable SSE for a bucket, all objects will have encryption when stored in the bucket.
To enable SSE for a bucket, run `aws s3api put-bucket-encryption`. Note that the bucket must be created beforehand.
The following example shows how to enable SSE for a bucket 'dataset-s0001'.

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
    The above is encrypted when storing the object on the server using the key stored on the storage side (decrypted when reading), it is not encrypted with information unique to the transmission request such as access key.

!!! note
    There is no change to the encryption of the objects that existed in the bucket before default encryption was enabled.


## Confirming Default Bucket Encryption

To confirm if a bucket is activated SSE, run `aws s3api get-bucket-encryption`.
The following example screens show bucket 'dataset-s0001' with SSE enabled. The bucket is activated default encryption because the string `"SSEAlgorithm": "AES256"` is listed. Unless the string is listed, the bucket is without default encryption.

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

In addition, you can run `aws s3api head-object` to confirm if object encryption is activated.
The following example screens meta data of 'cat.jpg' uploaded to the bucket 'dataset-s0001.' The object is uploaded with activated encryption because the string `"ServerSideEncryption": "AES256"` is listed.

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

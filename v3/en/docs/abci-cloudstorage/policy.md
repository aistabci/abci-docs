# Access Control (2) - Policy -

Other than ACL, Access Control Policy is also available to define permission for bucket and Cloud Storage account. Access Control Policy can control accessibility in different ways from the ones ACL offers.

Use "Bucket Policy" for "Access Control Policy".

* Bucket Policy: Set an access control policy for the bucket.

## Default Permission 

If no ACL is set, default setting grants an account full-control permission to the objects owned by the account. 

In case you use default setting, additional policy settings mentioned below is unnecessary. When detailed and complexed setting, such as granting specific Cloud Storage account only read permission, granting permission to only limited Cloud Storage accounts, are neeeded, the following instructions are helpful. 

## Common notes for Access Control Policy

The following are common notes for bucket and user policies.

- Endpoint is 'https://s3.v3.abci.ai'
- Ruling order does not matter, and Deny is prioritized over Allow. Even Denys in otner policy has priority.
- Although capital letters are available for the name of policies (i.e. names specified by '--policy-name'), it is highly recommended that you use small letters of alphabets and numbers and hyphen(0x2d).

## Setting Bucket Policy {#config-bucket-policy}

Bucket Policy sets access control policies for bucket. Bucket Policy can control accessibility on a per-bucket basis.

For bucket policy setting, access permissions are written in JSON format. In order to define what to allow, what to deny and judgement conditions, combinations of Effect, Action, Resource and Principal are used.

For Effect, 'Allow' and 'Deny' are available to define rules.

For Action, restrictions against requests or actions are written. As for downloading objects, for example, specify 's3:GetObject.' Wildcards (e.g. s3:*) are also available.

Action:

| Action | Description |
| :-- | :-- |
| s3:ListBucket | List buckets |
| s3:GetObject |Download objects |
| s3:PutObject | Upload objects |
| s3:DeleteObject | Delete objects |
| s3:GetObjectACL | Get ACL applied to object |
| s3:PutObjectACL | Apply ACL to objects |
| s3:AbortMultipartUpload           | Abort all the ongoing multiple part upload |
| s3:ListMultipartUploadParts       | List all the ongoing multiple part upload |
| s3:* or * (ALL OBJECT OPERATIONS) | All the operations above |


Resouce defines accessible resources. For example, "Resource": "sensor8" means the bucket 'sensor8'.

Principal defines accessible Cloud Storage account UUID. Using a wildcard can grant access to anyone on the internet. 
Note that NotPrincipal is not supported.

!!! caution
    Before you grant read access to everyone in the world, please read the following agreements carefully, and make sure it is appropriate to do so.
    
    * [ABCI Agreement and Rules](https://abci.ai/en/how_to_use/)
    * [ABCI Cloud Storage Terms of Use](https://abci.ai/en/how_to_use/data/cloudstorage-agreement.pdf)

!!! caution
    Please do not grant write access to everyone in the world due to the possibility of unintended use by a third party.

!!! note
    Condition is supported only fot IP address in bucket policy.


### Example 1:  Share bucket between ABCI Users {#share-bucket-between-users}

This part explains how to share a bucket between ABCI users.
In this example, two Cloud Storage accounts bbb00000.1 and bbb00001.1 are granted access to the 'share-bucket' bucket owned by user A.

Firstly, users to be granted the access execute the command `aws s3api list-buckets` to obtain ID(UUID) for the accounts bbb00000.1 and bbb00001.1.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api list-buckets
{
    "Buckets": [
        {
            "Name": "<>",
            "CreationDate": "2025-06-24T22:37:19.000Z"
        },
    ],
    "Owner": {
        "DisplayName": "UUID of the owner of the bucket",
        "ID": "UUID of the owner of the bucket>"
    }
}
```

Secondly, user A create a .json file the name of which is 'cross-access-pc.json', for example, as following. The name of a .json file can be arbitrary.

```
$cat cross-access-pc.json
{
    "Version": "2008-10-17",
    "Id": "AllowUser",
    "Statement": [
      {
        "Sid": "statement1_Allow",
        "Effect": "Allow",
        "Principal": {
          "DDN": [
            "<UUID of bbb00000.1>",
            "<UUID of bbb00001.1>",
          ]
        },
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
        ],
        "Resource": "share-bucket"
      }
    ]
}
```

It defines the policy that allows bbb00000.1 and bbb00001.1 read-only access to the bucket.

Apply the policy to the bucket 'share-bucket'.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket share-bucket --policy file://cross-access-pc.json
```

By applying the above rule, bbb00000.1 and bbb00001.1 can access the bucket 'share-bucket' and download objects in it.

To confirm the policy applied to the bucket, execute the command `aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket share-bucket`.

Besides, if you want to remove the policy, execute the command `aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket share-bucket`.


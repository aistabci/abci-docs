# Access Control (3) - Restricting Access by IP Address

You can restrict the IP addresses that can access a bucket by using bucket policies. Bucket policies are written in JSON format.

## Allowing Access Only from Specific IP Addresses {#allow-specific-ip-policy}

This section explains how to apply a bucket policy that allows access only from specific IP addresses and restricts access from other IP addresses.

!!! note
    ABCI Cloud Storage is only available within ABCI (login nodes and compute nodes) and is not currently available from external sources (such as the Internet). 

### Creating a Bucket Policy File

Create a JSON file (e.g., `allow-specific-ip-policy.json`) with the following content.
Replace `<bucket-name>` and the allowed IP address `"aws:SourceIp": ["10.0.90.3"]` according to your environment.

```json

{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificIP",
      "Effect": "Deny",
      "Principal": {
        "DDN": ["*"]
      },
      "Action": "s3:*",
      "Resource": "<bucket-name>",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["10.0.90.3"]
        }
      }
    }
  ]
}

```

### Applying the Bucket Policy

Apply the created JSON file to the bucket.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <bucket-name> --policy file://allow-specific-ip-policy.json
```

### Verifying the Bucket Policy

To verify the applied policy, execute the following command:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <bucket-name>
{
    "Policy": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"AllowSpecificIP\",\"Effect\":\"Deny\",\"Principal\":{\"DDN\":[\"*\"]},\"Action\":[\"s3:*\"],\"Resource\":\"<bucket-name>\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":[\"10.0.90.3\"]}}}]}"
}
```

After the policy is applied, users other than the bucket owner cannot access the target objects from IP addresses other than the specified one.
```
[username2@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://<bucket-name>/testfile testfile
download failed: s3://<bucket-name>/testfile to - An error occurred (403) when calling the HeadObject operation: Forbidden
```


### Removing the Bucket Policy

To remove the access restriction from specific IP addresses and delete the policy, execute the following command:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <bucket-name>
```

To verify that the policy has been deleted, execute the following command. An error message will appear if no policy exists.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <bucket-name>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```

## Denying Access from All IP Addresses {#deny-all-ip-policy}

This section explains how to deny access from all IP addresses. This setting denies all access from non-owner users.

### Creating a Bucket Policy File

Create a JSON file (e.g., `deny-all-ip-policy.json`) with the following content.
Replace `<bucket-name>` according to your environment.

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "DenyAllIP",
      "Effect": "Deny",
      "Principal": {
        "DDN": ["*"]
      },
      "Action": "s3:*",
      "Resource": "<bucket-name>",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["0.0.0.0/0"]
        }
      }
    }
  ]
}
```

### Applying the Bucket Policy

Apply the created JSON file to the bucket.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-policy --bucket <bucket-name> --policy file://deny-all-ip-policy.json
```

### Verifying the Bucket Policy

To verify the applied policy, execute the following command:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <bucket-name>
{
    "Policy": "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"DenyAllIP\",\"Effect\":\"Deny\",\"Principal\":{\"DDN\":[\"*\"]},\"Action\":[\"s3:*\"],\"Resource\":\"<bucket-name>\",\"Condition\":{\"IpAddress\":{\"aws:SourceIp\":[\"0.0.0.0/0\"]}}}]}"
}
```

After the policy is applied, users other than the bucket owner cannot access the target objects.
```
[username2@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://<bucket-name>/testfile testfile
download failed: s3://<bucket-name>/testfile to - An error occurred (403) when calling the HeadObject operation: Forbidden
```


### Removing the Bucket Policy

To remove the access denial from all IP addresses and delete the policy, execute the following command:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api delete-bucket-policy --bucket <bucket-name>
```

To verify that the policy has been deleted, execute the following command:

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-policy --bucket <bucket-name>
An error occurred (NoSuchBucketPolicy) when calling the GetBucketPolicy operation: The bucket policy does not exist
```
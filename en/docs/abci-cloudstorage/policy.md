# Access Control (2) - Policy -

Other than ACL, Access Control Policy is also available to define permission for bucket and ABCI Cloud Storage account. Access Control Policy can control accessibility in different ways from the ones ACL offers.

There are two types of "Access Control Policy": "Bucket Policy" and "User Policy".

* Bucket Policy: Set an access control policy for the bucket.
* User Policy: Set access control policies for your ABCI Cloud Storage account.

"Bucket Policy" can be set with the Cloud Storage Account for user, but Cloud Storage Account for manager is necessary to set "User Policy". If your ABCI Cloud Storage Account is which for Users, ask User Administrators to change the accessibility or to grant you appropriate permission.

## Default Permission 

Default setting grants all ABCI Cloud Storage accounts full-control permission to object of the group. 

In case you use default setting, additional policy settings mentioned below is unnecessary. When detailed and complexed setting, such as granting specific ABCI Cloud Storage account only read permission, granting permission to only limited ABCI Cloud Storage accounts, are neeeded, the following instructions are helpful. 

## Common notes for Access Control Policy

The following are common notes for bucket and user policies.

- Endpoint is 'https://s3.abci.ai'
- Ruling order does not matter, and Deny is prioritized over Allow. Even Denys in otner policy has priority.
- Although capital letters are available for the name of policies (i.e. names specified by '--policy-name'), it is highly recommended that you use small letters of alphabets and numbers and hyphen(0x2d).

## Setting Bucket Policy {#config-bucket-policy}

Bucket Policy sets access control policies for bucket. Bucket Policy can control accessibility on a per-bucket basis.

For bucket policy setting, access permissions are written in JSON format. In order to define what to allow, what to deny and judgement conditions, combinations of Effect, Action, Resource and Principal are used.

For Effect, 'Allow' and 'Deny' are available to define rules.

For Action, restrictions against requests or actions are written. As for downloading objects, for example, specify 's3:GetObject.' Wildcards (e.g. s3:*) are also available.

Action:

* Bucket

| Action | Description |
| :-- | :-- |
| s3:CreateBucket | Create buckets |
| s3:DeleteBucket | Delete buckets |
| s3:ListBucket | List buckets |
| s3:PutBucketACL | Apply ACL to buckets |
| s3:GetBucketACL | List ACLs applied to buckets |

* Object

| Action | Description |
| :-- | :-- |
| s3:GetObject |Download objects |
| s3:PutObject | Upload objects |
| s3:DeleteObject | Delete objects |
| s3:GetObjectACL | Get ACL applied to object |
| s3:PutObjectACL | Apply ACL to objects |
| s3:HeadObject | Get meta dafa of object |
| s3:CopyObject | Copy objects |

<!--
* Policy

| Action | Description |
| :-- | :-- |
| iam:ListUsers| Show a list of ABCI Cloud Storage account |
| iam:CreateGroup| Create a new subgroup |
| iam:DeleteGroup| Delete a subgroup |
| iam:ListGroups| Show a list of subgroups |
| iam:AddUserToGroup| Add ABCI Cloud Storage account to subgroup |
| iam:RemoveUserFromGroup| Remove ABCI Cloud Storage account from a sub-group |
| iam:ListGroupsForUser| Show subgroups to which a cloud storage user belongs |
| iam:Createpolicy| Create a new policy |
| iam:DeletePolicy| Delete a policy |
| iam:ListPolicies| Show a list of policies |
| iam:AttachGroupPolicy| Attach a policy to a subgroup |
| iam:DetachGroupPolicy| Detach a policy which attached to a subgroup |
| iam:ListAttachedGroupPolicies| Get a list of policies which attached to a subgroup |
| iam:AttachUserPolicy| Attach a policy to ABCI Cloud Storage account |
| iam:DetachUserPolicy| Detach a policy which attached to ABCI Cloud Storage account |
| iam:ListAttachedUserPolicies| Get a list of policies which attached ABCI Cloud Storage account |
-->

Resouce defines accessible resources. For example, 'arn:aws:s3:::sensor8' means the bucket 'sensor8.' The object in the bucket is written as 'arn:aws:s3:::sensor8/test.dat.' Wildcards are available.

Principal defines accessible ABCI Cloud Storage account. Using a wildcard can grant access to anyone on the internet. 
Note that NotPrincipal is not supported.

!!! caution
    Before you grant read access to everyone in the world, please read the following agreements carefully, and make sure it is appropriate to do so.
    
    * [ABCI Agreement and Rules](https://abci.ai/en/how_to_use/)
    * [ABCI Cloud Storage Terms of Use](https://abci.ai/en/how_to_use/data/cloudstorage-agreement.pdf)

!!! caution
    Please do not grant write access to everyone in the world due to the possibility of unintended use by a third party.

!!! note
    Condition is not supported in bucket policy. Therefore, for example, it is not possible to set conditions such as IP address limitation.


### Example 1:  Share bucket between ABCI Groups {#share-bucket-between-groups}

This part explains how to share a bucket between ABCI groups.
In this example, two ABCI cloud storage accounts bbb00000.1 and bbb00001.1 belonging to Group B are granted access to the 'share-bucket' bucket owned by Group A.

Firstly, a user in Group B executes the command `aws iam get-user` to obtain the Arn values for users bbb00000.1 and bbb00001.1 whose access is to be allowed.
To execute the command `aws iam get-user`, Cloud Storage Account for manager is necessary.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam get-user --user-name bbb00000.1 --query User.Arn
"arn:aws:iam::987654321098:user/bbb00000.1"
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam get-user --user-name bbb00001.1 --query User.Arn
"arn:aws:iam::987654321098:user/bbb00001.1"
```

Secondly, a user in group A create a .json file whose name is 'cross-access-pc.json', for example, as following. The name of a .json file can be arbitrary.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::987654321098:user/bbb00000.1",
                    "arn:aws:iam::987654321098:user/bbb00001.1"
                ]
            },
            "Action": [
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": [
                "arn:aws:s3:::share-bucket",
                "arn:aws:s3:::share-bucket/*"
            ]
        }
    ]
}
```

It defines the policy that allows bbb00000.1 and bbb00001.1 to read-only access the bucket.

Apply the policy to the bucket 'share-bucket'.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-policy --bucket share-bucket --policy file://cross-access-pc.json
```

By applying the above rules, bbb00000.1 and bbb00001.1 can access the bucket 'share-bucket'.

To clarify the bucket to which the policy is applied, execute the command `aws --endpoint-url https://s3.abci.ai s3api get-bucket-policy --bucket share-bucket`.

Also, if you want to remove the policy, execute the command `aws --endpoint-url https://s3.abci.ai s3api delete-bucket-policy --bucket share-bucket`.


## Setting User Policy {#config-user-policy}

<!--  Once "default-sub-group" is introdued, default access permision can be changed  -->

User Policy sets access control policies for ABCI Cloud Storage account. User Policy can control accessibility on a per ABCI Cloud Storage account basis.

For user policy setting, access permissions are written in JSON format. In order to define what to allow, what to deny and judgement conditions, combinations of Effect, Action, Resource and Condition are used.

For Effect, Action and Resource, please refer to [Setting Bucket Policy](policy.md#config-bucket-policy).

Condition determines condition operators and condition keys.

| Condition operator | Description |
| :-- | :-- |
| StringEquals | Checks if a string is identical to specified string |
| StringNotEquals | String condition operator that checks if a string is not identical to specified string |
| StringLike | String condition operator that checks if a string has specified pattern. The Wildcard for multiple letters '*' and the one for single letter '?' are available. |
| StringNotLike | String condition operator that checks if a string hos not specified pattern. The Wildcard for multiple letters '*' and the one for single letter '?' are available. |
| DateLessThan | Check if time is earlier than specified time. The format for date is '2019-09-27T01:30:00Z.' |
| DateGreaterThan | Check if a date is later than specified date. The format is same as DateLessThan |
| IpAddress | Check if an IP address is identical to specified IP address or is between specified IP address range. |
| NotIpAddress | Check if an IP address is not identical to specified IP address or is not between specified IP address range. |

| Condition Key | Description |
| :-- | :-- |
| aws:username | Name of ABCI Cloud Storage account (e.g. aaa00000.1) checked by string condition operators. |
| aws:SourceIp | Check source IP address, working with IP address operator. |
| aws:CurrentTime | Check current time, working with date operators. |
| aws:UserAgent | HTTP header of User-Agent. It is not appropriate for denying access because it can be camouflaged. An appropiate way of use is, for example, to deny unintended access to the buckets that are for specific applications. |

Here is an example.
Condition element can be omitted if it is unnecessary.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": "*",
            "Condition": {"StringLike": {"aws:UserAgent" : "aws-cli*"}}
        }
    ]
}
```

The following examples show how to control access by user policy.

### Example 1:  Limiting Bucket Access By Accounts

Four ABCI Cloud Storage accounts, aaa00000.1, aaa000001.1, aaa00002.1 and aaa00003.1, are created, for example, and there is a bucket whose name is 'sensor8'.Now we are showing how to allow only two users, aaa00000.1 and aaa00001.1, to access the bucket.

Firstly, create a .json file whose name is 'sensor8.json', for example, as following. The name of a .json file can be arbitrary.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": ["arn:aws:s3:::sensor8", "arn:aws:s3:::sensor8/*"],
            "Condition" : { "StringNotEquals" : { "aws:username" :
                ["aaa00002.1", "aaa00003.1"]}}
        }
    ]
}
```

It defines the policy that doesn't allow aaa00002.1 and aaa00003.1 to access the bucket.Because 'Deny' has priority, any other 'Allow' will be skipped.

Secondly, register this policy to ABCI Cloud Storage.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8policy --policy-document file://sensor8.json
{
    "Policy": {
        "PolicyName": "sensor8policy",
        "CreateDate": "2019-07-30T06:22:47Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "51OFYS8BQEFTP68KT4I63AAZYHNBPHHA",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8policy",
        "UpdateDate": "2019-07-30T06:22:47Z"
    }
}
```

The name of policy registered to ABCI Cloud Storage is 'sensor8policy' that includes what are written in 'sensor8.json' in the current working directory.
Take a memo and keep the value of 'Arn' which is necessary in the next step.

iLastly, apply the policy to the ABCI Cloud Storage accounts, aaa00002.1 and aaa00003.1.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00002.1
```

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/sensor8policy --user-name aaa00003.1
```

To clarify the ABCI Cloud Storage accounts to which the policy is applied, execute the command 'aws --endpoint-url https://s3.abci.ai iam list-attached-user-policies --user-name aaa00002.1.'

By applying the above rules, aaa00002.1 and aaa00003.1 can no longer access the bucket 'sensor8.' aaa00000.1 and aaa00001.1 can still access.

To clarify the ABCI Cloud Storage accounts to which the policy is applied, execute the command 'aws --endpoint-url https://s3.abci.ai iam list-attached-user-policies --user-name aaa00002.1.'

### Example 2:  Limiting Bucket Access By Hosts

The example below shows how to limit access from certain hosts. In the example, any access from hosts other than either external host whose IP address is 203.0.113.2 or internal network whose IP address range is 10.0.0.0/17 is denied.

Firstly, create 'src-ip-pc.json' as following.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": [
                        "10.0.0.0/17",
                        "203.0.113.2/32"
                    ]
                }
            }
        }
    ]
}
```

Secondly, register this policy to ABCI Cloud Storage.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name src-ip-pc --policy-document file://src-ip-pc.json
{
    "Policy": {
        "PolicyName": "src-ip-pc",
        "CreateDate": "2019-08-08T13:24:54Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "K9B9SFWR0JL4GSY8Z1K2441VJERSC2Q7",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::123456789012:policy/src-ip-pc",
        "UpdateDate": "2019-08-08T13:24:54Z"
    }
}
```

Secondly, register this policy to ABCI Cloud Storage. The follwing example applies the policy to ABCI Cloud Storage account 'aaa00004.1.' The value of 'ARN' had been shown already when registering the policy though, it can also be listed by executing the command 'aws --endpoint-url https://s3.abci.ai iam list-policies.'

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-user-policy --policy-arn arn:aws:iam::123456789012:policy/src-ip-pc --user-name aaa00004.1
```

By default setting, because no IP address limitation is defined, any ABCI Cloud Storage accounts to which the policy shown above is not applied has no limitation, regardless of sources' IP addresses. In order to list accounts in ABCI Cloud Storage, execute the command 'aws --endpoint-url https://s3.abci.ai iam list-users.'

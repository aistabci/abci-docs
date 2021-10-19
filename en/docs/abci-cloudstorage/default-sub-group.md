
# Access Control (3) - Group -

In the ABCI cloud storage service, a subgroup **default-sub-group** to which the accounts in the ABCI group belong is prepared in advance.
By setting a policy for this subgroup, you can control access to all accounts that belong to the subgroup.

The default-sub-group can be freely changed by the administrator cloud storage account.
By default, default-sub-group has full access to the cloud storage in the group.
You can also create a subgroup separate from the default-sub-group and control access for each subgroup.

This section describes how to manage subgroups and access control using subgroups.

## Managing subgroups

Use the AWS CLI to manage subgroups.
In addition, a cloud storage account for the administrator is required to manage the subgroup. If you do not have the authority, ask the person who has the storage account for the administrator, such as the user administrator of the group to which you belong, to set or grant the authority.

The main commands used to manage subgroups are:

| Command | Description |
| --       | --   |
| aws iam get-group | Display a list of cloud storage accounts that belong to the subgroup. |
| aws iam list-groups | Display a list of the subgroups. |
| aws iam create-group | Create a new subgroup. |
| aws iam delete-group | Delete the subgroup. |
| aws iam add-user-to-group | Add a cloud storage account to the subgroup. |
| aws iam remove-user-from-group | Remove a cloud storage account from the subgroup. |
| aws iam attach-group-policy | Attach an access control policy to the subgroup. |
| aws iam detach-group-policy | Detach an access control policy form the subgroup. |
| aws iam list-attached-group-policies | Display a list of access control policies attached to the subgroup. |
| aws iam list-groups-for-user | Display a list of groups to which the cloud storage account belongs. |

For example, use the `aws iam list-groups` command to display a list of subgroups.
By default, two groups, managed-group and default-sub-group, are displayed.

!!! note
    managed-group is a subgroup prepared by the operation team for management and cannot be changed by the user.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam list-groups
{
    "Groups": [
        {
            "Path": "/abci/",
            "GroupName": "managed-group",
            "GroupId": "GRPES2SG5PLA6UYFHWYA0M6VCEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:group/abci/managed-group",
            "CreateDate": "2020-04-01T02:04:45+00:00"
        },
        {
            "Path": "/",
            "GroupName": "default-sub-group",
            "GroupId": "GRP0L1H8JX1Z9GUXBFHRMFIWJEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:group/default-sub-group",
            "CreateDate": "2019-12-26T14:30:28+00:00"
        }
    ]
}
```

You can use the `aws iam get-group` command to display a list of the cloud storage account that belong to the specified subgroup.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam get-group --group-name default-sub-group
{
    "Users": [
        {
            "Path": "/",
            "UserName": "aaa00000.1",
            "UserId": "USRJY5ST1Z16OKRANCL9SZZGQEXAMPLE",
            "Arn": "arn:aws:iam::123456789012:user/aaa00000.1",
            "CreateDate": "2020-01-22T11:53:24+00:00"
        }
    ],
    "Group": {
        "Path": "/",
        "GroupName": "default-sub-group",
        "GroupId": "GRP0L1H8JX1Z9GUXBFHRMFIWJEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/default-sub-group",
        "CreateDate": "2019-12-26T14:30:28+00:00"
    }
}
```

To create a subgroup, specify the name of the group to be created in the `aws iam create-group` command as shown below.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name custom-group
{
    "Group": {
        "Path": "/",
        "GroupName": "custom-group",
        "GroupId": "GRPK7ONKO77EZKM7FVI3AFB8UEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/custom-group",
        "CreateDate": "2021-10-13T10:53:24+00:00"
    }
}
```

To delete a subgroup, specify the name of the group to be deleted in the `aws iam delete-group` command as shown below.
If you want to delete a subgroup, make sure that the account does not exist in the subgroup and that no policy is attached.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam delete-group --group-name custom-group
```

For detailed usage such as command options, check the help for each command (such as `aws iam create-group help`).


## Example 1: Limiting Bucket Access By Subgroups

It is assumed that two cloud storage accounts, aaa00000.1 and aaa00001.1, are created in the ABCI group and a sensor8 bucket exists.
In this example, we will create read-only and write-only subgroups of the object for the sensor8 bucket, and move the account from the default-sub-group subgroup to the newly created subgroup in order to control access.

First, we will create a subgroup. Use the `aws iam create-group` command to create a subgroup.
The name of the read-only subgroup is `sensor8-read-only-group`, and the name of the write-only subgroup is `sensor8-write-only-group`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name sensor8-read-only-group
{
    "Group": {
        "Path": "/",
        "GroupName": "sensor8-read-only-group",
        "GroupId": "GRP1P4AHW7GT7NDH3VNADCOGSEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/sensor8-read-only-group",
        "CreateDate": "2021-10-13T09:51:04+00:00"
    }
}
```

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-group --group-name sensor8-write-only-group
{
    "Group": {
        "Path": "/",
        "GroupName": "sensor8-write-only-group",
        "GroupId": "GRPYSWMCP4RFXPVK8QOVZ3S0REXAMPLE",
        "Arn": "arn:aws:iam::123456789012:group/sensor8-write-only-group",
        "CreateDate": "2021-10-13T09:51:43+00:00"
    }
}
```

Next, create a policy that only allows reading of objects for the sensor8 bucket.
Prepare a JSON file with the following contents. The file name is `sensor8-read-only.json`.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::sensor8/*"
        }
    ]
}
```

After preparing the JSON file, use the `aws iam create-policy` command to create a policy.
The policy name is `sensor8-read-only`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8-read-only --policy-document file://sensor8-read-only.json
{
    "Policy": {
        "PolicyName": "sensor8-read-only",
        "PolicyId": "PLCYI1ZEME36PS9E9G4NIBP2ZEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8-read-only",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:06:41+00:00",
        "UpdateDate": "2021-10-13T10:06:41+00:00"
    }
}
```

Next, create a policy that only allows writing of objects for the sensor8 bucket.
Prepare a JSON file with the following contents. The file name is `sensor8-write-only.json`.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::sensor8/*"
        }
    ]
}
```

After preparing the JSON file, use the `aws iam create-policy` command to create a policy.
The policy name is `sensor8-write-only`.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name sensor8-write-only --policy-document file://sensor8-write-only.json
{
    "Policy": {
        "PolicyName": "sensor8-write-only",
        "PolicyId": "PLCYA88HTRZ7N0D5VASY2LSJ8EXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/sensor8-write-only",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:11:36+00:00",
        "UpdateDate": "2021-10-13T10:11:36+00:00"
    }
}
```

After creating the subgroups and policies, attach the policies to each subgroup.
To attach a policy, use the `aws iam attach-group-policy` command.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name sensor8-read-only-group --policy-arn arn:aws:iam::123456789012:policy/sensor8-read-only
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name sensor8-write-only-group --policy-arn arn:aws:iam::123456789012:policy/sensor8-write-only
```

Finally, move the cloud storage accounts from the default-sub-group subgroup to the new subgroup.
Here we will move account aaa00000.1 to the read-only group and aaa00001.1 to the write-only group.

To move the account, first remove the account from the default-sub-group subgroup.
To remove an account from a subgroup, use the `aws iam remove-user-from-group` command.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam remove-user-from-group --user-name aaa00000.1 --group-name default-sub-group
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam remove-user-from-group --user-name aaa00001.1 --group-name default-sub-group
```

After removing the account from the default-sub-group subgroup, add the account to the new subgroup.
To add an account to a subgroup, use the `aws iam add-user-to-group` command.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam add-user-to-group --user-name aaa00000.1 --group-name sensor8-read-only-group
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam add-user-to-group --user-name aaa00001.1 --group-name sensor8-write-only-group
```

This completes the move of the accounts to the subgroups.
Now account aaa00000.1 will only be able to download objects in bucket sensor8, and aaa00001.1 will only be able to upload objects.


## Example 2: Limiting Bucket Access By Networks

As an example of restricting access by connection source IP address, we will explain how to add a setting to the default-sub-group subgroup to deny access outside the ABCI internal network (10.0.0.0/17).
Create a JSON file with the following contents. The file name is `deny-outside-abci.json`.

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
                        "10.0.0.0/17"
                    ]
                }
            }
        }
    ]
}
```

After preparing the JSON file, use the `aws iam create-policy` command to create the policy.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam create-policy --policy-name deny-outside-abci --policy-document file://deny-outside-abci.json
{
    "Policy": {
        "PolicyName": "deny-outside-abci",
        "PolicyId": "PLCYRASJDBNC4TCO8WDA6QKKEEXAMPLE",
        "Arn": "arn:aws:iam::123456789012:policy/deny-outside-abci",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-10-13T10:51:31+00:00",
        "UpdateDate": "2021-10-13T10:51:31+00:00"
    }
}
```

Next, attach the policy you have created to the default-sub-group subgroup.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai iam attach-group-policy --group-name default-sub-group --policy-arn arn:aws:iam::123456789012:policy/deny-outside-abci
```

As a result, the accounts in the default-sub-group subgroup can access the cloud storage only from inside ABCI.

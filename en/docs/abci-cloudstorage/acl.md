
# Access Control (1) - ACL -

By defining Access Control List (ACL), users manage groups who has accessibility to buckets and objects. The default ACL grants the resource owner accessibility to their group's data. By changing default setting, ACL grants control to specific ABCI groups or everyone.

!!! caution
    As of now, don't grant permission to everyone since the guideline has not been determined yet. We will make an announcement once it is established.

## What to Configure

For each bucket and object, ACL configures who is grantee and what permission is granted. 

The table below lists grantees. ABCI group is the smallest grantee unit. Therefore, specific single Cloud Storage Account can not be the grantee.

| Grantee | Description |
| :--| :--|
| ABCI group | Specific groups can be allowed to access buckets and object that belong to other groups. All accounts under the group obtain accessibility. |
| Everyone who has ABCI Storage Account | everyone who has ABCI Cloud Storage account can access resources. Access Key is required for authentication. |
| Anyone | Anyone can access with no authentication. |

Buckets and Objects have different lists of permissions.

Here is a table for buckets.

| Permission | Description |
| :--| :--|
| read | Allows grantee to list the objects in the bucket |
| write | Allows grantee to create, delete and overwrite objects in the bucket |
| read-acp | Allows grantee to overwrite the ACL of the bucket |
| write-acp | Allows grantee to overwrite the ACL of the bucket |
| full-control | Grants all permissions listed above to grantee |

The table below is for objetcs.

| Permission | Description |
| :--| :--|
| read| Allows grantee to read the object data |
| write| Not applicable | 
| read-acp| Allows grantee to read the ACL of the object |
| write-acp| Allows grantee to overwrite the ACL of the object |
| full-control| Grants all permissions listed above to grantee |

A default ACL grants full control to belonged ABCI group for the buckets and objects.

As for ACL includes typical pairs of grantees and permissions for general situation, such as opening to the internet, the standard ACLs are available. The standard ACLs are shown in later section.

## How to Set ACL (Example)

### Share Objects between ABCI Groups

This part explains how to share objects between ABCI groups.
For example, we grant the ABCI Group 'gaa11111' permission to the object 'testdata' under the ABCI group 'gaa0000'.

| Source ABCI group | Shared ABCI group |
| :--| :--|
| gaa00000 | gaa11111 |

Detail

| Bucket name | prefix | Object name |
| :--| :--| :--|
| test-share | test/ | testdata |

At first, the owner needs to get ID of the grantee. Ask the grantee to run the commaned 's3 list-bucket', obtain the ID and let the source know it.

```
$ aws --endpoint-url https://s3.abci.ai s3api list-buckets
{
    "Buckets": [
        {
            "Name": "gaa11111-bucket-1",
            "CreationDate": "2019-08-22T11:36:17.523Z"
        }
    ],
    "Owner": {
        "DisplayName": "gaa11111",
regular ID->"ID": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6"
    }
}
```

Then the source sets ACL of the object as shown below. To grant 'read', use option '--grant-read' and specify the grantee's ID.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-acl --grant-read id=1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6 --bucket test-share --key test/testdata
```

Confirm if it has been done successfully. As shown below, the Grants element indentifies 'gaa11111' as a grantee with permission 'READ'.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-acl --bucket test-share --key test/testdata
{
    "Owner": {
        "DisplayName": "gaa00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gaa11111",
                "ID": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6",
                "Type": "CanonicalUser"
            },
            "Permission": "READ"
        }
    ]
}
```

By setting ACL to private as following, user can retrieve default ACL setting.
```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-acl --acl private --bucket test-share --key test/testdata
```

### Open to All Accounts on ABCI Cloud Storage

In order to open a object to all accounts on ABCI Cloud Storage, specify `authenticated-read` for `--acl`.
The following example opens the object 'dataset.txt' under the bucket 'gaa00000-bucket-2' to the public.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-acl --acl authenticated-read  --bucket gaa00000-bucket-2 --key dataset.txt
```

When adding an object to a bucket by running the `aws s3api put-object`, acl setting mentioned above can be done simultaneously. See the help that is shown by `aws s3api put-object help`.

### Public Access

Two standard ACLs open buckets and objects to the public, which enable any internet users to access data. See the table below.

| Standard ACL| Bucket | Object |
| :--| :--| :--|
| public-read | Opens the list of objects under specified bucket to the internet. | Opens specified objects to the internet. Users with appropreate account can do this. |
| public-read-write | Anyone on the internet can read and overwite the objects under the bucket and set ACL of the bucket. | Anyone on the internet can read and overwite the objects and set ACL of the object. |

!!! caution
    We recommend not to use 'public-read-write' due to security concern. Be carefully consider both risks and necessity.

!!! caution
    As of now, don't grant permission to everyone since the guideline has not been determined yet. We will make an announcement once it is established.

Default standard ACL is set to be private. To terminate public access, use standard ACLs.


#### Open Buckets (public-read)

By applying the standard ACL 'public-read' to a bucket, the list of objects in the bucket is opened to public. Here is an example.

| ACL to be applied | Bucket to be opened |
| :--| :--|
| public-read | test-pub |

!!! caution
    As of now, don't grant permission to everyone since the guideline has not been determined yet. We will make an announcement once it is established.

Configure 'public-read' with 'put-bucket-acl'. To check the current configuration, run the command `get-bucket-acl`. Make sure that the grantee with URI "http://acs.amazonaws.com/groups/global/AllUsers" meaning public is added and permission 'READ' is given to it.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-acl --acl public-read --bucket test-pub
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-bucket-acl --bucket test-pub
{
    "Owner": {
        "DisplayName": "gxx00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gxx00000",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        },
        {
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AllUsers"
            },
            "Permission": "READ"
        }
    ]
}
```

To confirm if it works properly, access https://test-pub.s3.abci.ai by any internet browser.  If using Firefox, an XML including the list of objects will be shown.

The example following shows how to stop opening to the public and retrieve default setting.
Confirm that the grantee added before is deleted and the permission of the ABCI group is 'FULL_CONTROL'.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-acl --acl private --bucket test-pub
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-bucket-acl --bucket test-pub
{
    "Owner": {
        "DisplayName": "gxx00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gxx00000",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```


#### Open Objects (public-read)

By applying the standard ACL 'public-read' to an object, the object is opened to public. The following example shows the detail.

| ACL to be applied | Bucket | prefix | Object to be opened |
| :--| :--| :--| :--|
| public-read | test-pub2 | test/ | test.txt |

!!! caution
    As of now, don't grant permission to everyone since the guideline has not been determined yet. We will make an announcement once it is established.

Configure 'public-read' with 'put-object-acl'. To check the current configuration, run the command `get-object-acl`. Make sure that the grantee with URI "http://acs.amazonaws.com/groups/global/AllUsers" meaning public is added and permission 'READ' is given to it.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-acl --bucket test-pub2 --acl public-read --key test/test.txt
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-acl--bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "gxx00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda" 
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gxx00000",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser" 
            },
            "Permission": "FULL_CONTROL" 
        },
        {
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AllUsers" 
            },
            "Permission": "READ" 
        }
    ]
}
```

To confirm if it works properly, access https://test-pub2.s3.abci.ai/test/test.txt by any internet browser. If using Firefox, a list of objects will be shown.

The example following shows how to stop opening to the public and retrieve default setting.
Confirm that the grantee added before is deleted and the permission of the ABCI group is 'FULL_CONTROL'.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-object-acl --acl private --bucket  test-pub2 --key test/test.txt
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api get-object-acl --bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "gxx00000",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "gxx00000",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```

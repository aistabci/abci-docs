
# Access Control (1) - ACL -

By defining Access Control List (ACL), users can manage the users who have accessibility to buckets and objects. The initial ACL grants the resource owner accessibility to his/her data. By changing default setting, ACL grants controls to specific ABCI users or everyone.

## What to Configure {#what-to-configure}

For each bucket and object, ACL configures who is grantee and what permission is granted. 

The table below lists grantees. ABCI group cannot be specified.

| Grantee | Description |
| :--| :--|
| ABCI user | Specific users can be allowed to access buckets and objects. |
| Everyone who has Cloud Storage Account | everyone who has Cloud Storage account can access resources. Access Key is required for authentication. |
| Anyone | Anyone can access with no authentication. |

Buckets and Objects have different lists of permissions.

Here is a table for buckets.

| Permission | Description |
| :--| :--|
| read | Allows grantee to list the objects in the bucket |
| write | Allows grantee to create, delete and overwrite objects in the bucket |
| read-acp | Allows grantee to read the ACL of the bucket |
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

A default ACL grants full control to the owner of the buckets or the objects.

As for ACL includes typical pairs of grantees and permissions for general situation, such as opening to anyone, the standard ACLs are available. The standard ACLs are shown in later section.

## How to Set ACL (Examples) {#how-to-set-acl}

### Share Objects between ABCI Users

This part explains how to share objects between ABCI users.
For example, we grant the ABCI User 'aaa11111aa' permission to the object 'testdata' owned by the ABCI user 'aaa0000aa'.

| Source ABCI user | Shared ABCI user |
| :--| :--|
| aaa00000aa | aaa11111aa |

Detail

| Bucket name | prefix | Object name |
| :--| :--| :--|
| test-share | test/ | testdata |

At first, the owner needs to get UUID of the grantee. Ask the grantee to run the commaned 's3 list-bucket', obtain the Owner.ID and let the source know it.

```
$ aws --endpoint-url https://s3.v3.abci.ai s3api list-buckets
{
    "Buckets": [
        {
            "Name": "aaa11111aa-bucket-1",
            "CreationDate": "2025-08-22T11:36:17.523Z"
        }
    ],
    "Owner": {
        "DisplayName": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6",
        "ID": "1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6"
    }
}
```

Then the source sets ACL of the object as shown below. To grant 'read', use option '--grant-read' and specify the grantee's ID.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --grant-read id=1a2bc03fa4ee5ba678b90cc1a234f5f67f890f1f2341fa56a78901234cc5fad6 --bucket test-share --key test/testdata
```

Confirm if it has been done successfully. As shown below, the Grants element indentifies 'aaa11111aa' as a grantee with permission 'READ'.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket test-share --key test/testdata
{
    "Owner": {
        "DisplayName": "aaa00000aa",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "aaa11111aa",
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
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl private --bucket test-share --key test/testdata
```

If you give write permission to other group than yours and if a user from it puts objects on your bucket, your ABCI group is charged for the objects.

### Open to All Accounts on Cloud Storage {#open-to-all-accounts-on-abci-cloud-storage}

In order to open a object to all accounts on Cloud Storage, specify `authenticated-read` for `--acl`.
The following example opens the object 'dataset.txt' under the bucket 'aaa00000aa-bucket-2' to the public.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl authenticated-read  --bucket aaa00000aa-bucket-2 --key dataset.txt
```

### Public Access {#public-access}

Two standard ACLs open buckets and objects to the public, which enable any users to access data. See the table below.

| Standard ACL| Bucket | Object |
| :--| :--| :--|
| public-read | Opens the list of objects under specified bucket to any users. | Opens specified objects to any users. Users with appropreate account can modify them. |
| public-read-write | Anyone can read and overwrite the objects under the bucket and set ACL of the bucket. | Anyone can read and overwite the objects and set ACL of the object. |

!!! caution
    Before you grant read access to everyone, please read the following agreements carefully, and make sure it is appropriate to do so.
    
    * [ABCI Agreement and Rules](https://abci.ai/en/how_to_use/)
    * [ABCI Cloud Storage Terms of Use](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf) (Japanese version only)

!!! caution
    Please do not use 'public-read-write' due to the possibility of unintended use by a third party.

Default standard ACL is set to be private. To terminate public access, set it private.

#### Public Buckets {#public-buckets}

By applying the standard ACL 'public-read' to a bucket, the list of objects in the bucket is opened to public. Here is an example.

| ACL to be applied | Bucket to be opened |
| :--| :--|
| public-read | test-pub |

Configure 'public-read' with 'put-bucket-acl'. To check the current configuration, run the command `get-bucket-acl`. Make sure that the grantee with URI "http://acs.amazonaws.com/groups/global/AllUsers" meaning public is added and permission 'READ' is given to it.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-acl --acl public-read --bucket test-pub
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket test-pub
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
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

To confirm if it works properly, access 'https://s3.v3.abci.ai/(bucketname)' by curl command. For a bucket named test-pub, access as 'curl https://s3.v3.abci.ai/test-pub'.
(Currently, you cannot access through internet browser)

The example following shows how to stop opening to the public and retrieve default setting.
Confirm that the grantee added before is deleted and the permission of the ABCI group is 'FULL_CONTROL'.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-acl --acl private --bucket test-pub
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket test-pub
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


#### Public Objects {#public-objects}

By applying the standard ACL 'public-read' to an object, the object is opened to public. The following example shows the detail.

| ACL to be applied | Bucket | prefix | Object to be opened |
| :--| :--| :--| :--|
| public-read | test-pub2 | test/ | test.txt |

Configure 'public-read' with 'put-object-acl'. To check the current configuration, run the command `get-object-acl`. Make sure that the grantee with URI "http://acs.amazonaws.com/groups/global/AllUsers" meaning public is added and permission 'READ' is given to it.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --bucket test-pub2 --acl public-read --key test/test.txt
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
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

You can use curl command to confirm if it works properly. In this example, you can download text.txt by 'curl -o test.txt https://s3.v3.abci.ai/test-pub2/test/test.txt'.
(Currently, you cannot access through internet browser)

The example following shows how to stop opening to the public and retrieve default setting.
Confirm that the grantee added before is deleted and the permission of the ABCI group is 'FULL_CONTROL'.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-object-acl --acl private --bucket  test-pub2 --key test/test.txt
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-object-acl --bucket test-pub2 --key test/test.txt
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
```

### ACL Configuration Using a Configuration File
ACLs can be configured using a JSON configuration file of ACLs that was previously obtained with the get-bucket-acl command.
The current bucket ACL configuration can be exported to a file as shown below.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket bucket > bucket_acl.json
[username@login1 ~]$ cat bucket_acl.json
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        },
        {
            "Grantee": {
                "Type": "Group",
                "URI": "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
            },
            "Permission": "READ"
        }
    ]
}
```
The JSON configuration file of ACLs by get-bucket-acl using the above procedure can be applied to the bucket using put-bucket-acl.
In the following procedure, the public-read ACL configuration is applied to the bucket with default ACL settings by using bucket_acl_old.json.
```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket bucket 
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
                "Type": "CanonicalUser"
            },
            "Permission": "FULL_CONTROL"
        }
    ]
}
[username@login1 ~]$ cat bucket_acl_old.json
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
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
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-acl --bucket bucket --access-control-policy file://bucket_acl_old.json
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api get-bucket-acl --bucket bucket 
{
    "Owner": {
        "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
        "ID": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda"
    },
    "Grants": [
        {
            "Grantee": {
                "DisplayName": "f12d0fa66ea4df5418c0c6234fd5eb3a9f4409bf50b5a58983a30be8f9a42bda",
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
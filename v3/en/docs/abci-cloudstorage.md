# ABCI Cloud Storage

ABCI Cloud Storage Service offers an object storage service that has a compatible interface with Amazon Simple Storage Service (Amazon S3). We call the service as Cloud Storage hereafter.

Cloud Storage has unique capabilities.

- Amazon S3 interface compatibility

    Users store data into a globally unique bucket through the interface compatible with Amazon S3. Clients compatible with S3 such as AWS Command Line Interface (AWS CLI) and s3cmd are available. Users can also make client tools by using boto though some APIs are not supported. The example of usage of AWS CLI is shown in another section.

- Encryption

    Data transfers between clients and the storage are encrypted.

!!! note
    Users can access the storage only from the computate nodes or interactive nodes.
    Currently users cannot access from outside(internet). We will announce if it is prepared.

When using Cloud Storage, the user must agree to and comply with the [ABCI Cloud Storage Terms of Use](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf) (Japanese version only).

To start using Cloud Storage, the User Administrator of each ABCI group should apply for use on [ABCI User Portal](https://portal.v3.abci.ai/). If you are not the User Administrator, please contact to the User Administrators of your group. For details of the operation, refer to [ABCI Portal Guide](https://docs.abci.ai/v3/portal/en/). In addition, the User Administrator of the group must also apply to increase or decrease the amount. 

ABCI points are subtracted from the balance of the group's points based on the total size of Cloud Storage usage applied by the User Administrator of the group at ABCI User Portal. The users of the group can then store objects up to the allocated amount. Please apply for usage in 1TB increments via [ABCI User Portal](https://portal.v3.abci.ai/). Refer to [price list](https://abci.ai/en/how_to_use/tariffs.html) for ABCI point consumption per 1TB.

!!! note
    There is no charge for data transfer or API calls. Also, for minor usage such as system operation verification or functional testing, usage within 1MB is allowed without consuming ABCI points.

Users can check the total size of the stored data by [show_cs_quota](getting-started.md#checking-cloud-storage-usage).

| Page | Outline |
|:--|:--|
| [Accounts and Access Keys](abci-cloudstorage/cs-account.md) | This section explains accounts and access keys. |
| [Usage](abci-cloudstorage/usage.md) | This section shows basic usage. |
| [Access Control (1)](abci-cloudstorage/acl.md) | This section shows how to control accessibility by ACL. Data can be shared between groups. |
| [Access Control (2)](abci-cloudstorage/policy.md) | This section explains access control which is applicable to buckets and user accounts. It is possible to set access control that cannot be done with ACL. Access control settings for buckets can be done with a 'Cloud Storage Account for user', but 'Cloud Storage Account for manager' is necessary to set for access control settings for accounts. |

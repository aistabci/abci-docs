# ABCI Object Storage (Under Upadate)

ABCI Object Storage Service offers an object storage service that has a compatible interface with Amazon Simple Storage Service (Amazon S3).

ABCI Object Storage has unique capabilities.

- Compatibility

    Users store data into a globally unique bucket through the interface compatible with Amazon S3. Clients compatible with S3 such as AWS Command Line Interface (AWS CLI) and s3cmd are available. Users can also make client tools by using boto. Some APIs are not supported. The example of usage of AWS CLI is shown in another section.
    
- Accessibility

    Users can access the storage not only from the computational nodes or interactive nodes but also from outside ABCI. In other words, ABCI users can use the storage as a data transferring tool that allows users to transfer data for computational jobs from outside ABCI.

- Encryptability

    Users can encrypt data transfers between clients and the storage. Users can also encrypt data and store encrypted data in the storage.


ABCI points based on the total size of objects in buckets owned by your ABCI group are subtracted from your ABCI group's each day. There is no charge for data transfer or API calls. Users can check the total size by show_cs_usage. The calculation formula of ABCI points for using ABCI Object Storage is as follows.

```
ABCI point = the size of data stored in the storage of the previous day
           × charge coefficient of ABCI Object Storage
```

| Page | Outline |
|:--|:--|
| [Accounts and Access Keys](./account.md) | This section explains accounts and access keys. |
| [Usage](./usage.md) | This section shows basic usage. |
| Encryption | This section explains encryption. |
| Access Control (1) | This section shows how to control accessibility by ACL. Data can be shared between groups. |
| Access Control (2) | This section explains access control which is applicable to buckets and user accounts. It is possible to set access control that cannot be done with ACL. Access crontrol settings for buckets can be done with a 'Object Storage Account for user', but 'Oloud Storage Account for manager' is necessary to set for access control settings for accounts. |

# ABCI Cloud Storage

ABCI Cloud Storage Service offers an object storage service that has a compatible interface with Amazon Simple Storage Service (Amazon S3).

ABCI Cloud Storage has unique capabilities.

- Compatibility

    Users store data into a globally unique bucket through the interface compatible with Amazon S3. Clients compartible with S3 such as AWS Command Line Interface (AWS CLI) and s3cmd are available. Users can also make client tools by using boto. Some APIs are not supported. The example of usage of AWS CLI is shown in another section.
    
- Accessibility

    Users can access the storage not only from the computational nodes or interactive nodes but also from outside ABCI. In other words, ABCI users can use the storage as a data transferring tool that allows users to transfer data for computational jobs from outside ABCI.

- Encryptability

    Users can encrypt data transfers between clients and the storage. Users can also encrypt data and store encrypted data in the storage.

To start using ABCI Cloud Storage, Usage Manager of each ABCI group should apply for use on the ABCI User Portal.
If you are not a Usage Manager, please contact to Usage Managers of your group.

The fee for using the storage is based on the size of data stored in the storage. As for the fee, see this table (https://abci.ai/en/how_to_use/tariffs.html). The fee is not based on the data transfer size nor the number of times of calling APIs.

| Page | Outline |
|:--|:--|
| [Account and Access Key](abci-cloudstorage/cs-account.md) | This section explains accounts and access key. |
| [How To Use](abci-cloudstorage/usage.md) | This section shows basic usage. |
| [Encryption](abci-cloudstorage/encryption.md) | This section explains encryption. |
| [Access Control (1)](abci-cloudstorage/acl.md) | This section shows how to control accessibility by ACL. Data can be shared between groups. |
| [Access Control (2)](abci-cloudstorage/policy.md) | This section explains access control which is applicable to user accounts. It actualizes what ACL can not do though, Usage Mangers Account is necessary. |


# Accounts and Access Keys (Under Update)

## Object Storage Account

There are two types of accounts. The one is 'Object Storage Account for user' and the other is 'Object Storage Account for manager'. Object Storage Account for user is issued to each ABCI user per ABCI group. Both Object Storage Account for user and Object Storage Account for manager are issued to User Administrators.

### Object Storage Account for User

This account allows users to use ABCI Object Storage in general ways, such as uploading and downloading data. For example, 'aaa00000aa.1' is a name of a account.

If an ABCI user belongs to multiple groups and uses ABCI Object Storage from the other group, another Object Storage Account 'aaa0000aa.2' is given to the user.

Most of the time, having an Object Storage Account for a group is satisfying. However, if necessary, multiple Object Storage Accounts for a group are issued to a user. An additional Object Storage Account 'aaa00000aa.3', for example, is issued to the user for an application under development. ABCI users can not specify the name of accounts by themselves.

An ABCI user can own at most 10 Object Storage Accounts per group. If an ABCI user belongs to two groups, 20 Object Storage Accounts at most can be given to the user.

### Object Storage Account for Manager

This account is only given to User Administrators and allow them to control accessibility. 

Even though User Administrators can use the 'Object Storage Account for managers' in order to perform what 'Object Storage Account for users' can do such as uploading or downloading data, it is basically supposed to use rather 'Object Storage Account for user' than 'Object Storage Account for manager' to do so.

The Object Storage Account for Manager is issued to every single User Administrator. If a user is a User Administrator for two groups, two accounts are given to her/him.

## Access Key

An access key is issued to every Object Storage account. Access keys consist of an access key ID and a secret access key. Secret access keys are not allowed to be disclosed to third parties or put somewhere accessible by third parties.

Object Storage account can have a maximum of two access keys. When using different clients, creating different access keys for each client is highly recommended.

## Account deletion

ABCI User Portal does not have a feature to delete ABCI Object Storage accounts at this time. Although deleting access keys is a way to prevent a user from accessing ABCI Object Storage, you can also request your ABCI Object Storage account be deleted. Read the [Contact](../contact.md) page, then send the ABCI Object Storage account name to <abci3-qa@abci.ai>.

!!! note
    - Deleted accounts cannot be restored. Make sure that the Object Storage account name you wish to delete is correct.
    - The suffix numbers which were assigned to deleted accounts will be vacant permanently. Since you can create 10 accounts per group, if you belong to only one group and delete one account, the last account number is 11 (e.g. "aaa00000aa.11"), not 10.

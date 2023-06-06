
# Accounts and Access Keys

## Cloud Storage Account

There are two types of accounts. The one is 'Cloud Storage Account for user' and the other is 'Cloud Storage Account for manager'. Cloud Storage Account for user is issued to each ABCI user per ABCI group. Both Cloud Storage Account for user and Cloud Storage Account for manager are issued to User Administrators.

### Cloud Storage Account for User

This account allows users to use ABCI Cloud Storage in general ways, such as uploading and downloading data. For example, 'aaa00000aa.1' is a name of a account.

If an ABCI user belongs to multiple groups and uses ABCI Cloud Storage from the other group, another Cloud Storage Account 'aaa0000aa.2' is given to the user.

Most of the time, having an Cloud Storage Account for a group is satisfying. However, if necessary, multiple Cloud Storage Accounts for a group are issued to a user. An additional Cloud Storage Account 'aaa00000aa.3', for example, is issued to the user for an application under development. ABCI users can not specify the name of accounts by themselves.

An ABCI user can own at most 10 Cloud Storage Accounts per group. If an ABCI user belongs to two groups, 20 Cloud Storage Accounts at most can be given to the user.

### Cloud Storage Account for Manager

This account is only given to User Administrators and allow them to control accessibility. For more information, see [Access Control(2)](policy.md).

Even though Usage Managers can use this account in order to perform what users can do such as uploading or downloading data, they are basically supposed to use rather their Users Account than Usage Managers Account to do so.

The Cloud Storage Account for Manager is issued to every single User Administrator. If a user is a User Administrator for two groups, two accounts are given to her/him.

## Access Key

An access key is issued to every Cloud Storage account. Access keys consist of an access key ID and a secret access key. Secret access keys are not allowed to be disclosed to third parties or put somewhere accessible by third parties.

Cloud Storage account can have a maximum of two access keys. When using different clients, creating different access keys for each client is highly recommended.

## Account deletion

ABCI User Portal does not have a feature to delete ABCI Cloud Storage accounts at this time. Although deleting access keys is a way to prevent a user from accessing ABCI Cloud Storage, you can also request your ABCI Cloud Storage account be deleted. Read the [Contact](../contact.md) page, then send the ABCI Cloud Storage account name to <qa@abci.ai>.

!!! note
    - Deleted accounts cannot be restored. Make sure that the Cloud Storage account name you wish to delete is correct.
    - The suffix numbers which were assigned to deleted accounts will be vacant permanently. Since you can create 10 accounts per group, if you belong to only one group and delete one account, the last account number is 11 (e.g. "aaa00000aa.11"), not 10.

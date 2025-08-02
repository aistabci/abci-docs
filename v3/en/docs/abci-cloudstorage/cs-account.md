
# Claud Storage Account Directories and Access Keys

## Cloud Storage Account Directories

An Claud Storage Account Directory(ABCI group name + . + serial number) is provided for each ABCI group.
The user of the group can create buckets in it and store objects there.

### Cloud Storage Account Directory

This account allows users to use Cloud Storage in general ways, such as uploading and downloading data. For example, 'aaa00000aa.1' is a name of a account.

If an ABCI user belongs to multiple groups and uses Cloud Storage from the other group, another Cloud Storage Account 'bbb00000bb.1' is given to the user.

Most of the time, having an Cloud Storage Account for a group is satisfying. However, if necessary, multiple Cloud Storage Accounts for a group are issued to a user. An additional Cloud Storage Account 'aaa00000aa.2', for example, is issued to the user for an application under development. ABCI users can not specify the name of account by themselves.

An ABCI user can own at most 10 Cloud Storage Accounts per group. If an ABCI user belongs to two groups, 20 Cloud Storage Accounts at most can be given to the user.

## Access Key

An access key is issued to every Cloud Storage Account Directories. Access keys consist of an access key ID and a secret access key. Secret access keys are not allowed to be disclosed to third parties or put somewhere accessible by third parties.

The Cloud Storage Account Directory can have only one access key.

## Account deletion

Once a Cloud Storage Account Directory is created, it cannot be deleted.


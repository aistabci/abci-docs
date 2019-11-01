
# Accounts and Access Keys

## Cloud Storage Account

There are two types of accounts. The one is 'Cloud Storage Account for user' and the other is 'Cloud Storage Account for manager'. Cloud Storage Account for user is issued to each ABCI user per ABCI group. Both Cloud Storage Account for user and Cloud Storage Account for manager are issued to Usage Managers.

### Cloud Storage Account for User

This account allows users to use ABCI Cloud Storage in general ways, such as uploading and downloading data. For example, 'aaa00000aa.1' is a name of a account.

If an ABCI user belongs to multiple groups and uses ABCI Cloud Storage from the other group, another Cloud Storage Account 'aaa0000aa.2' is given to the user.

Most of the time, having an Cloud Storage Account for a group is satisfying. However, if necessary, multiple Cloud Storage Accounts for a group are issued to a user. An additional Cloud Storage Account 'aaa00000aa.3', for example, is issued to the user for an application under development. ABCI users can not specify the name of accounts by themselves.

An ABCI user can own at most 10 Cloud Storage Accounts per group. If an ABCI user belongs to two groups, 20 Cloud Storage Accounts at most can be given to the user.

### Cloud Storage Account for Manager

This account is only given to Usage Managers and allow them to control accessibiliy. For more information, see [Access Control(2)](policy.md).

Even though Usage Managers can use this account in order to perform what users can do such as uploading or downloading data, they are basically supposed to use rather their Users Account than Usage Managers Account to do so.

The Cloud Storage Account for Manager is issued to every single Usage Manager. If a user is a Usage Manager for two groups, two accounts are given to her/him.

## Access Key

Access Key issued built for every Cloud Storage Account. Access Key consists of an Access Key ID and a Secret Access Key. Secret Access Key is not allowed to be disclosed to third parties nor put somewhere accessible by third parties.

At most two Access Keys can be issued for single Cloud Storage Account. When using different clients, creating different Access Keys for each client is highly recommended.


<!--
## Sub group

Group created in group. Sub group is used when applying access policy.
-->

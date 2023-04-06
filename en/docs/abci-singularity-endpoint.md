# ABCI Singularity Endpoint

## Overview

ABCI Singularity Endpoint provides a singularity container service available within ABCI. This service consists of Remote Builder for remotely building container images using SingularityPRO and Container Library for storing and sharing the created container images. This service is available only within ABCI and cannot be accessed directly from outside of ABCI.

The following describes the basic operations for using this service in ABCI. See Sylabs [Document](https://sylabs.io/docs/) for more information.

## Preparation

### Loading environment module

In order to use this service, load the module of SingularityPRO as follows.

```
[username@es1 ~]$ module load singularitypro
```

### Creating Access Token

!!! note
    Due to an update to the ABCI Singularity endpoint, access tokens obtained before March 2023 are no longer available. Therefore, after obtaining the access token again, register the access token.

You need to obtain an access token to authenticate your requests. The access token can be created by using the `get_singularity_token` command on the interactive node with your ABCI password, which is used to log in to ABCI User Portal.

```
[username@es1 ~]$ get_singularity_token
ABCI portal password :
just a moment, please...
  (The generated access token will be displayed.)
```

Keep your access token in a safe place for a later registration step.

!!! note
    The access token is a very long single line of text, so be careful not to include unnecessary characters such as newlines.


### Checking remote endpoint

To check that ABCI Singularity Endpoint (cloud.se2.abci.local) is correctly configured as a remote endpoint, use `singularity remote list ` command.

```
[username@es1 ~]$ singularity remote list
Cloud Services Endpoints
========================

NAME         URI                   ACTIVE  GLOBAL  EXCLUSIVE  INSECURE
ABCI         cloud.se2.abci.local  YES     YES     NO         NO
SylabsCloud  cloud.sylabs.io       NO      YES     NO         NO

Keyservers
==========

URI                          GLOBAL  INSECURE  ORDER
https://keys.se2.abci.local  YES     NO        1*

* Active cloud services keyserver
[username@es1 ~]$
```

!!! note
    SylabsCloud is a public service endpoint operated by [Sylabs](https://sylabs.io/). It is available by signing in to <https://cloud.sylabs.io/> and obtaining an access token.


!!! note
    Singularity container images can also be retrieved using the Singularity Global Client. For details, refer to [Singularity Global Client](tips/sregistry-cli.md).


### Registering Access Token

To register the access token obtained above with your configuration, use `singularity remote login `command for ABCI Singularity Endpoint.

```
[username@es1 ~]$ singularity remote login ABCI
Generate an access token at https://cloud.se2.abci.local/auth/tokens, and paste it here.
Token entered will be hidden for security.
Access Token:
INFO:    Access Token Verified!
INFO:    Token stored in /home/username/.singularity/remote.yaml
[username@es1 ~]$
```

When you have created an access token again, use the above command to register it. The old access token is overwritten by the new one.

!!! note
    The validity period of access tokens is one year.

## Remote Builder

First, create a definition file to build a container image. The following example defines installation of additional packages to the container image and commands to be executed when the container image is run, based on Ubuntu container image from Docker Hub. For more information about definition files, see [Definition Files](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro37-user-guide/definition_files.html).

```
[username@es1 ~]$ vi ubuntu.def
[username@es1 ~]$ cat ubuntu.def
Bootstrap: docker
From: ubuntu:18.04

%post
    apt-get update
    apt-get install -y lsb-release

%runscript
    lsb_release -d

[username@es1 ~]$ 
```

Next, to create the container image "ubuntu.sif" by Remote Build with "ubuntu.def", specify `--remote` to the command `singularity build`.

```
[username@es1 ~]$ singularity build --remote ubuntu.sif ubuntu.def
INFO:    Remote "cloud.se2.abci.local" added.
INFO:    Access Token Verified!
INFO:    Token stored in /root/.singularity/remote.yaml
INFO:    Remote "cloud.se2.abci.local" now in use.
INFO:    Starting build...
:
:
INFO:    Build complete: ubuntu.sif
[username@es1 ~]$ 
```

You can run the container image with `singularity run` command as follows:

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run ubuntu.sif
Description:    Ubuntu 18.04.6 LTS
[username@g0001 ~]$ 
```

The `lsb_release -d` command specified in the definition file is executed and the result is printed.

## Container Library (Experimental)

You can push your container images to Container Library and make those available to other ABCI users. Each user can store up to a total of 100 GiB.

!!! note
    There is no access control function for the container images pushed to Container Library. This means that anyone who uses ABCI will be able to access them, so make sure the container images are appropriate.

### Creating and Registering Signing Keys for a Container Image

To push a container image to Container Library and publish it in ABCI, create a key pair and register the public key in Keystore.The author of the container image can sign the container image using the private key, and the user of the container image can verify the signature using the public key registered in Keystore.

#### Creating Key Pairs

To create key pairs, use `singularity key newpair` command.

```
[username@es1 ~]$ singularity key newpair
Enter your name (e.g., John Doe) : 
Enter your email address (e.g., john.doe@example.com) : 
Enter optional comment (e.g., development keys) : 
Enter a passphrase : 
Retype your passphrase :
Would you like to push it to the keystore? [Y,n] 
Generating Entity and OpenPGP Key Pair... done
```

Each input value is described as follows:

| item | value |
| :-- | :-- |
| Enter your name | Enter the ABCI account name. |
| Enter your email address | Although it says email address, enter the ABCI account name. |
| Enter optional comment | Enter comments you want to attach to this key pair. |
| Enter a passphrase | Determine your passphrase and enter it. It is going to be necessary when signing a container image. |
| Would you like to push it to the keystore? | Enter `Y` to upload the public key to Keystore. |

#### Listing Keys

To retrieve information about the public keys in your local keyring, including ones you created, use `singularity key list`.

```
[username@es1 ~]$ singularity key list
Public key listing (/home/username/.singularity/sypgp/pgp-public):
:
:
   --------
7) U: username (comment) <username>
   C: 2020-06-15 03:40:05 +0900 JST
   F: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   L: 4096
   --------
[username@es1 ~]$
```

To retrieve key information registered in Keystore, specify the ABCI account in `singularity key search -l`.

```
[username@es1 ~]$ singularity key search -l username
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>

[username@es1 ~]$
```

#### Registering a Public Key in Keystore

If you did not specify the option to upload a public key to Keystore, you can upload it later.

!!! warning
    Public keys registered in Keystore cannot be deleted.

```
[username@es1 ~]$ singularity key list
0) U: username (comment) username
   C: 2020-08-08 04:28:35 +0900 JST
   F: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
   L: 4096
   --------

```

To upload this public key number 0, specify the fingerprint shown in `F` as the `singularity key push`.

```
[username@es1 ~]$ singularity key push ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
public key `ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ' pushed to server successfully

[username@es1 ~]$ singularity key search -l username
Showing 1 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  RSA        4096  2020-06-15 03:40:05 +0900 JST  [ultimate]       [enabled]  username (comment) <username>
```

#### Getting Public Keys Registered in Keystore

Public keys registered in Keystore can be downloaded and stored in your keyring. The following example downloads and saves the public key found by searching for username2. You can also search for a string that matches the comment attached to the key. The last parameter of `singularity key pull AAAA....` is a fingerprint to specify which public key to download.

```bash hl_lines="1 7 9"
[username@es1 ~]$ singularity key search -l username2
Showing 2 results

FINGERPRINT                               ALGORITHM  BITS  CREATION DATE                  EXPIRATION DATE  STATUS     NAME/EMAIL
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  RSA        4096  2020-06-22 11:51:45 +0900 JST  [ultimate]       [enabled]  username2 (comment) <username2>

[username@es1 ~]$ singularity key pull AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
1 key(s) added to keyring of trust /home/username/.singularity/sypgp/pgp-public
[username@es1 ~]$ singularity key list
:
:
1) U: username2 (comment) <username2>
   C: 2020-08-10 11:51:45 +0900 JST
   F: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
   L: 4096
   --------
[username@es1 ~]$
```

#### Deleting Keys

You can remove a public key from your keyring by specifying a key fingerprint using `singularity key remove` command. Public keys registered in Keystore cannot be deleted.

```
[username@es1 ~]$ singularity key remove AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

### Uploading Container Images

Before uploading a container image to Container Library, sign the container image.
Check the key number by using the `singularity key list -s` command, and sign the container by using the `singularity sign` command with the `-k` option to specify the key number.
The following example uses the second key to sign `ubuntu.sif`.

```bash hl_lines="1 11"
[username@es1 ~]$ singularity key list -s
Public key listing (/home/username/.singularity/sypgp/pgp-secret):
:
:
   --------
2) U: username (comment) <username>
   C: 2020-06-15 03:40:05 +0900 JST
   F: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   L: 4096
   --------
[username@es1 ~]$ singularity sign -k 2 ./ubuntu.sif
Signing image: ./ubuntu.sif
Enter key passphrase : 
Signature created and applied to ./ubuntu.sif
```

The location of container images in Container Library is represented by a URI `library://username/collection/repository:tag`. Refer to the description of each component below to determine the URI.

| item | value |
| :-- | :-- |
| username | Specifies your ABCI account |
| collection | Specify collection name as any string |
| repository | Specify the repository name as any string. |
| tag | A string identifying the same container image. A string such as version, release date, revision number or `latest`. |

Here is an example of uploading the container image `ubuntu`, specifying the collection name `abci-lib` and the tag name `latest`:

```
[username@es1 ~]$ singularity push ubuntu.sif library://username/abci-lib/ubuntu:latest
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
 35.36 MiB / 35.36 MiB [===========================================================================================================================================================================================================] 100.00% 182.68 MiB/s 0s
[username@es1 ~]$
```

### Downloading Container Images

The container image uploaded to Container Library can be downloaded as follows:

```
[username@es1 ~]$ singularity pull library://username/abci-lib/ubuntu:latest
INFO:    Downloading library image
 35.37 MiB / 35.37 MiB [=============================================================================================================================================================================================================] 100.00% 353.47 MiB/s 0s
INFO:    Download complete: ubuntu_latest.sif
[username@es1 ~]$
```

If the signature cannot be verified, you will see a warning message similar to the following, but the download will continue.

```
WARNING: Skipping container verification
```

You can also use `singularity verify` to verify the signature after downloading it. 
The following example validates the signature with the public key that is registered in Keystore. The output is `LOCAL` rather than `REMOTE` if it is verified with the public key registered in your keyring. If it cannot be verified, a WARNING message is printed.

```
[username@es1 ~]$ singularity verify ubuntu_latest.sif
Verifying image: ubuntu_latest.sif
[REMOTE]  Signing entity: username (comment) <username>
[REMOTE]  Fingerprint: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Objects verified:
ID  |GROUP   |LINK    |TYPE
------------------------------------------------
1   |1       |NONE    |Def.FILE
2   |1       |NONE    |JSON.Generic
3   |1       |NONE    |FS
Container verified: ubuntu_latest.sif
```

!!! note
    You can still run the container image if validation fails, but it is recommended that you use a verifiable container image.

### Searching Container Images

To search for container images uploaded to Container Library by keyword, use `singularity search`.

```
[username@es1 ~]$ singularity search hello
No users found for 'hello'

No collections found for 'hello'

Found 1 containers for 'hello'
	library://username/abci-lib/helloworld
		Tags: latest
```


### Deleting Container Images

To delete a container image from Container Library, use `singularity delete`.

```
[username@es1 ~]$ singularity delete library://username/abci-lib/helloworld:latest
```

!!! note
    You can delete container images such as `library://username/abci-lib/helloworld:latest`, which are associated with at least one tag or ID, but you can not delete container names such as `library://username/abci-lib/helloworld`.


### Listing Container Images

You can view container image list information uploaded to the Container Library.
The collection name list can be viewed with `singularity enterprise get col`. Specify username as the argument.

```
[username@es1 ~]$ singularity enterprise get col username
ID                         Name            Num. Containers
username/tensorflow-test tensorflow-test 1
username/ubuntu-test     ubuntu-test     2
[username@es1 ~]$
```

The list of repositories in a collection can be viewed with `singularity enterprise get rep`. It takes an argument of the ID shown in `singularity enterprise get col`.

```
[username@es1 ~]$ singularity enterprise get rep username/ubuntu-test
ID                             Name    Description Images Tags Size      DownloadCount
username/ubuntu-test/ubuntu    ubuntu              1      0     64.0 MiB 3
username/ubuntu-test/ubuntu2   ubuntu2             1      0     67.0 MiB 5
[username@es1 ~]$
```

Container image information can be viewed with `singularity enterprise get img`. It takes an argument of ID shown in `singularity enterprise get rep`.

```
[username@es1 ~]$ singularity enterprise get img username/ubuntu-test/ubuntu2
ID                                                                                                     Tags              Arch  Description Size      Signed Encrypted Uploaded
username/ubuntu-test/ubuntu2:sha256.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   [20221118 latest] amd64              67.0 MiB true   false     true
[username@es1 ~]$
```

### Viewing Container Library Usage

You can view Container Library usage with `show_container_library_usage`. You must enter the ABCI password to show it.

```
[username@es1 ~]$ show_container_library_usage
ABCI portal password :
just a moment, please...
used(GiB) limit(GiB) num_of_repositories
3         100        6
```

## Access Tokens

This section describes the commands related to the obtained access token.

### Listing Access Tokens

You can list your access tokens with `list_singularity_tokens`. You must enter the ABCI password to display it.

```
[username@es1 ~]$ list_singularity_tokens
ABCI portal password :
just a moment, please...

Token ID: XXXXXXXXXXXXXXXXXXXXXXXX
Issued: Apr 5, 2023 at 6:55 pm JST
Expires: Apr 4, 2024 at 6:55 pm JST

Token ID: XXXXXXXXXXXXXXXXXXXXXXXX
Issued: Apr 6, 2023 at 12:14 pm JST
Expires: Apr 5, 2024 at 12:14 pm JST
```

### Revoking the Access Token

You can revoke the access token with `singularity enterprise delete token`. Specify the Token ID you want to remove as an argument from the list of access tokens displayed in `list_singularity_tokens` command.

```
[username@es1 ~]$ singularity enterprise delete token <Token ID>
INFO:    Revoking token XXXXXXXXXXXXXXXXXXXXXXXX
[username@es1 list_singularity_tokens]$
```


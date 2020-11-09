# ABCI Singularity Endpoint

## Overview


ABCI Singularity Endpoint provides a singularity container service available within ABCI. This service consists of Remote Builder for remotely building container images using SingularityPRO and Container Library for storing and sharing the created container images. This service is available only within ABCI and cannot be accessed directly from outside of ABCI.

!!! warning
    Container Library is an Experimental service. In particular, it is not possible to upload container images larger than 64 MB.

The following describes the basic operations for using this service in ABCI. See Sylabs [Document](https://sylabs.io/docs/) for more information.

## Preparation

### Loading environment module

In order to use this service, load the module of SingularityPRO as follows.

```
[username@es1 ~]$ module load singularitypro/3.5
```

!!! note
    Singularity 2.6.1 does not support this service.

### Creating Access Token

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

To check that ABCI Singularity Endpoint (cloud.se.abci.local) is correctly configured as a remote endpoint, use `singularity remote list ` command.

```
[username@es1 ~]$ singularity remote list
NAME         URI                  GLOBAL
[ABCI]       cloud.se.abci.local  YES
SylabsCloud  cloud.sylabs.io      YES
[username@es1 ~]$
```

The `ABCI` enclosed in "[ ]" is the current default endpoint.

!!! note
    SylabsCloud is a public service endpoint operated by [Sylabs](https://sylabs.io/). It is available by signing in to <https://cloud.sylabs.io/> and obtaining an access token.

 
!!! note
    Singularity container images can also be retrieved using the Singularity Global Client. For details, refer to [here](tips/sregistry-cli.md).


### Registering Access Token

To register the access token obtained above with your configuration, use `singularity remote login `command for ABCI Singularity Endpoint.

```
[username@es1 ~]$ singularity remote login ABCI
INFO:    Authenticating with remote: ABCI
Generate an API Key at https://cloud.se.abci.local/auth/tokens, and paste here:
API Key:
INFO:    API Key Verified!
[username@es1 ~]$
```

When you have created an access token again, use the above command to register it. The old access token is overwritten by the new one.

!!! note
    Access tokens currently expire in one month. When your access token has expired, create and register another access token again.

## Remote Builder

First, create a definition file to build a container image. The following example defines installation of additional packages to the container image and commands to be executed when the container image is run, based on Ubuntu container image from Docker Hub. For more information about definition files, see [Definition Files](https://repo.sylabs.io/c/0f6898986ad0b646b5ce6deba21781ac62cb7e0a86a5153bbb31732ee6593f43/guides/singularitypro35-user-guide/definition_files.html).

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
INFO:    Remote "default" added.
INFO:    Authenticating with remote: default
INFO:    API Key Verified!
INFO:    Remote "default" now in use.
INFO:    Starting build...
:
:
INFO:    Build complete: ubuntu.sif
[username@es1 ~]$ 
```

You can run the container image with `singularity run` command as follows:

```
[username@es1 ~]$ qrsh -g grpname -l rt_C.small=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro/3.5
[username@g0001 ~]$ singularity run ubuntu.sif
Description:	Ubuntu 18.04.5 LTS
[username@g0001 ~]$ 
```

The `lsb_release -d` command specified in the definition file is executed and the result is printed.

## Container Library (Experimental)

You can push your container images to Container Library and make those available to other ABCI users. Each user can store up to a total of 100 GiB.

!!! note
    There is no access control function for the container images pushed to Container Library. This means that anyone who uses ABCI will be able to access them, so make sure the container images are appropriate.

### Current Restrictions

* Uploading a container image of 64 MiB or more is not possible, but you can create a container image in a remote build.
* You cannot get a list of uploaded container images.

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

### Upload Container Image

Before uploading to Container Library, sign the container image.
Check the key number with `singularity key list -s`, and sign the container with `singularity sign` command specified the key number by `-k` option.
The following example uses the second key to sign `ubuntunt.sif`.

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

The location of container images in Container Library is represented by a URI `library://username/collection/container:tag`. Refer to the description of each component below to determine the URI.

| item | value |
| :-- | :-- |
| username | Specifies your ABCI account |
| collection | Specify collection name as any string |
| container | Specify the container image name as any string. |
| tag | A string identifying the same container image. A string such as version, release date, revision number or `latest`. |

Here is an example of uploading a collection named `abci-lib`, container image named `ubuntu`, and tag `latest`:

```
[username@es1 ~]$ singularity push ubuntu.sif library://username/abci-lib/ubuntu:latest
INFO:    Container is trusted - run 'singularity key list' to list your trusted keys
 35.36 MiB / 35.36 MiB [===========================================================================================================================================================================================================] 100.00% 182.68 MiB/s 0s
[username@es1 ~]$
```

### Pulling container image

The container image uploaded to Container Library can be downloaded as follows:

```
[username@es1 ~]$ singularity pull library://username/abci-lib/ubuntu:latest
INFO:    Downloading library image
 35.37 MiB / 35.37 MiB [=============================================================================================================================================================================================================] 100.00% 353.47 MiB/s 0s
INFO:    Download complete: ubuntu_latest.sif
[username@es1 ~]$
```

If the signature cannot be verified, WARNING message similar to the following, but the download will continue.

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

### Searching Container Image

To search for container images uploaded to Container Library by keyword, use `singularity search`.

```
[username@es1 ~]$ singularity search hello
No users found for 'hello'

No collections found for 'hello'

Found 1 containers for 'hello'
	library://username/abci-lib/helloworld
		Tags: latest
```


### Deleting Container Image

To delete container images uploaded to Container Library, use `singularity delete`.

```
[username@es1 ~]$ singularity delete library://username/abci-lib/helloworld:latest
```

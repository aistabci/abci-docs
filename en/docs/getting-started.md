# Getting Started ABCI

## Getting an ABCI account {#getting-an-account}

### Application for use of ABCI
To use an ABCI account, determine the research and development theme according to the agreements of use (rules or regulations) posted in the "Application Procedure", and submit a new "ABCI Application" on the ABCI User Portal. The ABCI application will be reviewed based on the terms of use, and if requirements are met, an ABCI group for which the application was made will be created and the applicant will be notified that the application has been adopted. After receiving notification, the applicant may start using the account.

Please refer to the price list in [ABCI USAGE FEES](https://abci.ai/en/how_to_use/tariffs.html) and purchase ABCI points to pay the usage fee. Please purchase ABCI points for each ABCI group. At the time of application, a minimum of 1,000 ABCI points must be purchased.

### Types of ABCI accounts {#account-type}
There are three types of ABCI accounts: "Responsible Person", "Usage Manager", "User".
To use the ABCI system, the "Responsible Person" must submit a new "ABCI application" on the [ABCI User Portal](https://portal.abci.ai/user/project_register_app.php?lang=en) and obtain an ABCI group and one or more ABCI accounts. See the [ABCI Portal Guide](https://docs.abci.ai/portal/en/) for more details.

!!! Note
    - An ABCI account will also be issued to the "Responsible Person".
    - The "Responsible Person" can change "User" to "Usage Manager" on the [ABCI User Portal](https://portal.abci.ai/user/).
    - The "Responsible Person" and "Usage Manager" can add "Usage Managers" or "Users" to the ABCI group.
    - The "Responsible Person" and "Usage Manager" can change the "Responsible Person" of the ABCI group.

### Uniqueness of the ABCI account {#account-uniqueness}
As a general rule, each person should have a unique ABCI account. For example, it is not allowed that a company gets one ABCI account with use shared among more than one employees. On the other hand, if one person belongs to multiple corporations, that person may obtain multiple ABCI accounts. In such cases, the ABCI account corresponding to each corporation must be used appropriately.

### Persons belonging to multiple ABCI groups {#multi-titled-person}
If one person is working on more than one themes in one corporation at the same time, instead of that person acquiring multiple ABCI accounts, such a person will belong to multiple ABCI groups with one ABCI account. In such cases, each ABCI group must be used appropriately according to the purpose of use. When unsure of which ABCI group to use, please contact the "Responsible Person" or "Usage Manager" of the ABCI group. The "Responsible Person" or "Usage Manager" of the ABCI group to which you belong will be displayed on the first screen after logging in to the [ABCI User Portal](https://portal.abci.ai/user/).

Since usage determines which ABCI group bears the usage fee, please use the appropriate ABCI group according to the instructions of the "Responsible Person" or "Usage Manager" of the ABCI group.

## Connecting to Interactive Node

To connect to the interactive node (*es*(for Compute Node (V)), *es-a*(for Compute Node (A))), the ABCI frontend, two-step SSH public key authentication is required.

1. Login to the access server (*as.abci.ai*) with SSH public key authentication, so as to create an *SSH tunnel* between your computer and *es*.
2. Login to the interactive node (*es* or *es-a*) with SSH public key authentication via the SSH tunnel.

In this document, ABCI server names are written in *italics*.

### Prerequisites

To connect to the interactive node, you will need the following in advance:

* An SSH client. Your computer most likely has an SSH client installed by default. If your computer is a UNIX-like system such as Linux and macOS, or Windows 10 version 1803 (April 2018 Update) or later, it should have an SSH client. You can also check for an SSH client, just by typing ``ssh`` at the command line.
* A secure SSH public/private key pair. ABCI only accepts the following public keys:
	* RSA keys, at least 2048bits
	* ECDSA keys, 256, 384, and 521bits
	* Ed25519 keys
* SSH protocol version. Only SSH protocol version 2 is supported.
* Registration of SSH public keys. Your first need to register your SSH public key on [ABCI User Portal](https://portal.abci.ai/user/). The instruction will be found at [Register Public Key](https://docs.abci.ai/portal/en/02/#23-register-public-key).

!!! note
    If you would like to use PuTTY as an SSH client, please read [PuTTY](tips/putty.md).

### Login using an SSH Client

In this section, we will describe two methods to login to the interactive node using a SSH client. The first one is creating an SSH tunnel on the access server first and connecting the interactive node via this tunnel next. The second one, much easier method, is connecting directly to the interactive node using ProxyJump implemented in OpenSSH 7.3 or later.

#### General method

Login to the access server (*as.abci.ai*) with following command:

Interactive Node (V)

```
[yourpc ~]$ ssh -i /path/identity_file -L 10022:es:22 -l username as.abci.ai
The authenticity of host 'as.abci.ai (0.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- Display only at the first login
Are you sure you want to continue connecting (yes/no)? <- Enter "yes"
Warning: Permanently added 'XX.XX.XX.XX' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- Enter passphrase
```

Interactive Node (A)

```
[yourpc ~]$ ssh -i /path/identity_file -L 10022:es-a:22 -l username as.abci.ai
The authenticity of host 'as.abci.ai (0.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- Display only at the first login
Are you sure you want to continue connecting (yes/no)?  <- yesを入力
Warning: Permanently added ‘XX.XX.XX.XX' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- Enter "yes"
```

Successfully logged in, the following message is shown on your terminal.

```
Welcome to ABCI access server.
Please press any key if you disconnect this session.
```

!!! warning
    Be aware! The SSH session will be disconnected if you press any key.

Launch another terminal and login to the interactive node using the SSH tunnel:

```
[yourpc ~]$ ssh -i /path/identity_file -p 10022 -l username localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- Display only at the first login
Are you sure you want to continue connecting (yes/no)? <- Enter "yes"
Warning: Permanently added 'localhost' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- Enter passphrase
[username@es1 ~]$
```

#### ProxyJump

You can log in to an interactive node with a single command using ProxyJump, which was introduced in OpenSSH version 7.3. ProxyJump can be used in Windows Subsystem for Linux (WSL) environment as well.

First, add the following configuration to your ``$HOME/.ssh/config``:

```
Host abci
     HostName es
     User username
     ProxyJump %r@as.abci.ai
     IdentityFile /path/to/identity_file
     HostKeyAlgorithms ssh-rsa

Host abci-a
     HostName es-a
     User username
     ProxyJump %r@as.abci.ai
     IdentityFile /path/to/identity_file

Host as.abci.ai
     IdentityFile /path/to/identity_file
```

After that, you can log in with the following command only:

```
[yourpc ~]$ ssh abci
```

ProxyJump does not work with OpenSSH_for_Windows_7.7p1 which is bundled with Windows 10 version 1803 and later. Use ProxyCommand instead. The following is an example of a config file using ProxyCommand. Please specify the absolute path for `ssh.exe`.

```
Host abci
     HostName es
     User username
     ProxyCommand C:\WINDOWS\System32\OpenSSH\ssh.exe -W %h:%p %r@as.abci.ai
     IdentityFile C:\path\to\identity_file

Host abci-a
     HostName es-a
     User username
     ProxyCommand C:\WINDOWS\System32\OpenSSH\ssh.exe -W %h:%p %r@as.abci.ai
     IdentityFile C:\path\to\identity_file

Host as.abci.ai
     IdentityFile C:\path\to\identity_file
```

## File Transfer to Interactive Node

When you transfer files between your computer and the ABCI system, create an SSH tunnel and run the `scp` (`sftp`) command.

```
[yourpc ~]$ scp -P 10022 local-file username@localhost:remote-dir
Enter passphrase for key: <- Enter passphrase
    
local-file    100% |***********************|  file-size  transfer-time
```

If you have OpenSSH 7.3 or later and already added the configuration to your ``$HOME/.ssh/config`` as described at [ProxyJump](#proxyjump), you can directly run the `scp` (`sftp`) command.

```
[yourpc ~]$ scp local-file abci:remote-dir
```

## Changing Password

The user accounts of the ABCI system are managed by the LDAP.
You do not need your password to login via SSH,
but you will need your password when you use the User Portal and change the login shell.
To change your password, use the `passwd` command.

```
[username@es1 ~]$ passwd
Changing password for user username.
Current Password: <- Enter the current password
New password: <- Enter the new password
Retype new password: <- Enter the new password again
passwd: all authentication tokens updated successfully.
```

!!! warning
    Password policies are as follows:

    - Specify a character string with more than 15 characters arranged randomly. For example, words in Linux dictionary cannot be used. We recommend generating it automatically by using password creation software.
    - Should contain all character types of lower-case letters, upper-case letters, numeric characters, and special characters.
	- As special characters, the following 33 types of characters can be used: (blank) ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
    - Do not contain multi-byte characters.

## Login Shell

GNU bash is the login shell be default on the ABCI system.
The tcsh and zsh are available as a login shell.
To change the login shell, use the `chsh` command.
The change become valid from the next login.
It will take 10 minutes to update the login shell.

```
$ chsh [option] <new_shell>
```

| Option | Description |
|:--|:--|
| -l | Display the list of available shells. |
| -s *new_shell* | Change the login shell. |

Example) Change the current login shell into tcsh

```
[username@es1 ~]$ chsh -s /bin/tcsh
Password for username@ABCI.LOCAL: <- Enter password
```

When you login to the ABCI system, user environment is automatically set. If you need to customize environment variables such as `PATH` or `LD_LIBRARY_PATH`, edit a user configuration file in the following table.

| Login shell | User configuration file |
|:-|:-|
| bash | $HOME/.bash_profile |
| tcsh | $HOME/.cshrc |
| zsh  | $HOME/.zshrc |

!!! warning
    Make sure to add a new path at the end of `PATH`. If you add the new path to the beginning, you may not use the system properly.

The original user configuration files (templates) are stored in /etc/skel.

## Checking ABCI Point

To display ABCI point usage and limitation, use the `show_point` command.
When your ABCI point usage ratio will reach 100%, a new job cannot be submitted, and queued jobs will become error state at the beginning. (Any running jobs are not affected.)

Example) Display ABCI point information.

```
[username@es1 ~]$ show_point
Group                 Disk            CloudStorage                    Used           Point   Used%
grpname                  5                  0.0124             12,345.6789         100,000      12
  `- username          -                         -                  0.1234               -       0
 
```

| Item | Description |
|:--|:--|
| Group | ABCI group name |
| Disk  | Disk assignment (TB) |
| CloudStorage | ABCI point usage of ABCI Cloud Storage |
| Used  | ABCI point usage |
| Point | ABCI point limit |
| Used% | ABCI point usage ratio |

To display ABCI point usage per monthly, use the `show_point_history` command.

Example) Display ABCI point usage per monthly.

```
[username@es1 ~]$ show_point_history -g grpname
                      Apr        May        Jun        Jul        Aug        Sep        Oct        Nov        Dec        Jan        Feb        Mar          Total
Disk           1,000.0000     0.0000     0.0000          -          -          -          -          -          -          -          -          -     1,000.0000
CloudStorage       1.0000     1.5000     0.5000          -          -          -          -          -          -          -          -          -         2.0000
Job              100.0000    50.0000    10.0000          -          -          -          -          -          -          -          -          -       160.0000
  |- username1    60.0000    40.0000     5.0000          -          -          -          -          -          -          -          -          -       105.0000
  `- username2    40.0000    10.0000     5.0000          -          -          -          -          -          -          -          -          -        55.0000
Total          1,101.0000    51.5000    10.5000          -          -          -          -          -          -          -          -          -     1,162.0000
```

| Item | Description |
|:--|:--|
| Disk  | ABCI point usage of Disk |
| CloudStorage | ABCI point usage of ABCI Cloud Storage |
| Job  | Total ABCI point usage of On-demand, Spot, and Reserved Services for all users in the group |
| Total(rows) | Total ABCI point usage of Disk, CloudStorage, and Job |

!!! note
    - For information on calculating point consumption per service, see [Accounting](job-execution.md#accounting).
    - The point usage of the job of Spot/On-demand service which executed across months is counted in the month in which the job was submitted. The repayment process after the end of the job is also performed for the point usage of the month in which the job was submitted.
    - The points usage of the Reserved service are counted in the month in which the reservation was made. If you cancel the reservation, it will be returned to the points used in the month you made the reservation.

## Checking Disk Quota

To display your disk usage and quota about home area and group area,
use the `show_quota` command

Example) Display disk information.

```
[username@es1 ~]$ show_quota
Disk quotas for user username
  Directory                     used(GiB)       limit(GiB)          nfiles
  /home                               100              200           1,234

Disk quotas for ABCI group grpname
  Directory                     used(GiB)       limit(GiB)          nfiles
  /groups/grpname                   1,024            2,048         123,456
```

| Item  | Description |
|:-|:-|
| Directory  | Assignment directory |
| used(GiB)  | Disk usage |
| limit(GiB) | Disk quota limit |
| nfiles     | Number of files |

## Checking ABCI Cloud Storage Usage

To display your ABCI Cloud Storage usage, use the `show_cs_usage` command

Example) Show the latest information of ABCI Cloud Storage for ABCI group grpname.
```
[username@es1 ~]$ show_cs_usage
Cloud Storage Usage for ABCI groups
Date           Group                   used(GiB)
2020/01/13     grpname                       162
```

Example) Specify the date with -d yyyymmdd for ABCI group grpname. 
```
[username@es1 ~]$ show_cs_usage -d 20191217
Cloud Storage Usage for ABCI groups
Date           Group                   used(GiB)
2019/12/17     grpname                       124
```

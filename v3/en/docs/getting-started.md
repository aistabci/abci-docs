# Getting Started ABCI

## Connecting to Interactive Node

To connect to the interactive node (*int*), the ABCI frontend, two-step SSH public key authentication is required.

1. Login to the access server (*as.v3.abci.ai*) with SSH public key authentication, so as to create an *SSH tunnel* between your computer and *int*.
2. Login to the interactive node (*int*) with SSH public key authentication via the SSH tunnel.

In this document, ABCI server names are written in *italics*.

### Prerequisites

To connect to the interactive node, you will need the following in advance:

* SSH client: Your computer most likely has an SSH client installed by default. If your computer is a UNIX-like system such as Linux and macOS, or Windows 10 version 1803 (April 2018 Update) or later, it should have an SSH client. You can also check for an SSH client, just by typing ``ssh`` at the command line.
* SSH protocol version: Only SSH protocol version 2 is supported.
* A secure SSH public/private key pair: ABCI only accepts the following public keys:
	* RSA keys, at least 2048bits
	* ECDSA keys, 256, 384, and 521bits
	* Ed25519 keys
* Please contact the operations team (abci3-qa@abci.ai ) for SSH public key registration.

!!! note
    Tera Term and PuTTY can be used as SSH clients.

### Login using an SSH Client

In this section, we will describe two methods to login to the interactive node using a SSH client. The first one is creating an SSH tunnel on the access server first and connecting the interactive node via this tunnel next. The second one, much easier method, is connecting directly to the interactive node using ProxyJump implemented in OpenSSH 7.3 or later.

#### General method

Login to the access server (*as.v3.abci.ai*) with following command:

```
[yourpc ~]$ ssh -i /path/identity_file -L 10022:int:22 -l username as.v3.abci.ai
The authenticity of host 'as.v3.abci.ai (0.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- Display only at the first login
Are you sure you want to continue connecting (yes/no)? <- Enter "yes"
Warning: Permanently added 'XX.XX.XX.XX' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- Enter passphrase
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
[username@int1 ~]$
```

#### ProxyJump

You can log in to an interactive node with a single command using ProxyJump, which was introduced in OpenSSH version 7.3. ProxyJump can be used in Windows Subsystem for Linux (WSL) environment as well.

First, add the following configuration to your ``$HOME/.ssh/config``:

```
Host abci
     HostName int
     User username
     ProxyJump %r@as.v3.abci.ai
     IdentityFile /path/to/identity_file
     HostKeyAlgorithms ssh-ed25519

Host as.v3.abci.ai
     IdentityFile /path/to/identity_file
```

After that, you can log in with the following command only:

```
[yourpc ~]$ ssh abci
```

ProxyJump does not work with OpenSSH_for_Windows_7.7p1 which is bundled with Windows 10 version 1803 and later. Use ProxyCommand instead. The following is an example of a config file using ProxyCommand. Please specify the absolute path for `ssh.exe`.

```
Host abci
     HostName int
     User username
     ProxyCommand C:\WINDOWS\System32\OpenSSH\ssh.exe -W %h:%p %r@as.v3.abci.ai
     IdentityFile C:\path\to\identity_file

Host as.v3.abci.ai
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

## Login Shell

The default login shell for the ABCI system is set to bash. For any changes to the login shell, please contact the operations team (abci3-qa@abci.ai ).

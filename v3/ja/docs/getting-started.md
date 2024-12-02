# ABCIの利用開始

## インタラクティブノードへの接続 {#connecting-to-interactive-node}

ABCIシステムのフロントエンドであるインタラクティブノード(ホスト名: *login*)に接続するには、二段階のSSH公開鍵認証による接続を行います。

1. SSH公開鍵認証を用いてアクセスサーバ(ホスト名: *as.v3.abci.ai*)にログインして、ローカルPCとインタラクティブノードの間にSSHポートフォワーディングによるトンネリング（以下「SSHトンネル」という）を作成
2. SSHトンネルを介して、SSH公開鍵認証を用いてインタラクティブノード(*login*)にログイン

なお本章では、ABCIのサーバ名は *イタリック* で表記します。

### 前提 {#prerequisites}

インタラクティブノードに接続するには、以下が必要になります。

* SSHクライアント: Linux、macOSを含むUNIX系OS、Windows 10 version 1803 (April 2018 Update)以降など、ほとんどのPCには、デフォルトでSSHクライアントがインストールされています。インストールされているかどうかを確認するには、コマンドラインから``ssh``コマンドを実行してください。
* SSHプロトコルバージョン: SSHプロトコルバージョン2のみサポートしています。
* 安全なSSH公開鍵・秘密鍵ペアの生成: ABCIで利用可能な鍵ペアは以下のとおりです。
	* RSA鍵 (2048bit以上)
	* ECDSA鍵 (256bit、384bit、または521bit)
	* Ed25519鍵
* SSH公開鍵の登録については、運用担当者（abci3-qa@abci.ai ）までご連絡ください。

!!! note
    SSHクライアントとして、Tera TermやPuTTYも利用可能です。

### SSHクライアントによるログイン {#login-using-an-ssh-client}

以下では、SSHクライアントを用いて、(1) アクセスサーバでSSHトンネルの作成後にインタラクティブノードにログインする方法と、(2) OpenSSH 7.3以降で実装されたProxyJumpを使ったより簡便なログイン方法を説明します。

#### 一般的なログイン方法 {#general-method}

以下のコマンドでアクセスサーバ(*as.v3.abci.ai*)にログインし、SSHトンネルを作成します。

```
[yourpc ~]$ ssh -i /path/identity_file -L 10022:login:22 -l username as.v3.abci.ai
The authenticity of host 'as.v3.abci.ai (0.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- 初回ログイン時のみ表示
Are you sure you want to continue connecting (yes/no)?  <- yesを入力
Warning: Permanently added ‘XX.XX.XX.XX' (RSA) to the list of known hosts.
Enter passphrase for key '/path/identity_file': <- パスフレーズ入力
```


アクセスサーバへのログインが成功すると、ターミナル上に下記のメッセージが表示されます。

```
Welcome to ABCI access server.
Please press any key if you disconnect this session.
```

!!! warning
    上記状態で何らかのキーを入力するとSSH接続が切断されてしますので注意してください。

続いて、別のターミナルを起動し、SSHトンネルを用いてインタラクティブノードにログインします。

```
[yourpc ~]$ ssh -i /path/identity_file -p 10022 -l username localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
RSA key fingerprint is XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX. <- 初回ログイン時のみ表示
Are you sure you want to continue connecting (yes/no)? <- yesを入力
Warning: Permanently added 'localhost' (RSA) to the list of known hosts.
Enter passphrase for key '-i /path/identity_file': <- パスフレーズ入力
[username@login1 ~]$
```

#### ProxyJumpの使用 {#proxyjump}

ここではOpenSSH 7.3で実装されたProxyJumpを使ったログイン方法を説明します。Windows Subsystem for Linux (WSL)でも同様のログイン方法が使えます。

まずローカルPCの``$HOME/.ssh/config``に以下の記述を行います。

```
Host abci
     HostName login
     User username
     ProxyJump %r@as.v3.abci.ai
     IdentityFile /path/to/identity_file
     HostKeyAlgorithms ssh-ed25519

Host as.v3.abci.ai
     IdentityFile /path/to/identity_file
```

以降は、以下のコマンドのみでログインできます。

```
[yourpc ~]$ ssh abci
```

Windows 10 バージョン 1803 以降に標準でバンドルされている OpenSSH_for_Windows_7.7p1 では ProxyJump が機能しないため、代わりに ProxyCommand を使用してください。以下に ProxyCommand を使った config ファイルの例を示します。ssh.exe は絶対パスで記述して下さい。

```
Host abci
     HostName login
     User username
     ProxyCommand C:\WINDOWS\System32\OpenSSH\ssh.exe -W %h:%p %r@as.v3.abci.ai
     IdentityFile C:\path\to\identity_file

Host as.v3.abci.ai
     IdentityFile C:\path\to\identity_file
```

## インタラクティブノードへのファイル転送 {#file-transfer-to-interactive-node}

ローカルPCとABCIシステム間でファイル転送をするには、`scp`(`sftp`)コマンドを利用します。この場合もSSHトンネルを介して行う必要があります。

SSHトンネルの設定後、以下のように実行します。

```
[yourpc ~]$ scp -i /path/identity_file -P 10022 local-file username@localhost:remote-dir
Enter passphrase for key: <- パスフレーズを入力
    
local-file    100% |***********************|  file-size  transfer-time
```

ProxyJumpが使える場合は、SSHトンネルを明示的に設定する必要はありません。[ProxyJumpの使用](#proxyjump)で説明したとおり``$HOME/.ssh/config``の設定がしてあれば、直接`scp` (`sftp`)コマンドでファイル転送が行えます。

```
[yourpc ~]$ scp local-file abci:remote-dir
```

## ログインシェル {#login-shell}

ABCIシステムのデフォルトログインシェルは、bashが設定されています。
ログインシェルの変更については、運用担当者（abci3-qa@abci.ai ）までご連絡ください。

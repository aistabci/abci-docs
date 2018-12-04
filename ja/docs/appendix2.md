# 付録2. 各種サービスの利用方法

## ABCIでのリモートデスクトップ利用

### 概要

ここではABCIでのリモートデスクトップの利用方法について説明します。リモートデスクトップを使うことで、計算ノードでGUIの利用が可能になります。

### 前準備

* ABCIにログインします。

ログインの方法は、ユーザガイドの2章を参照してください。

* vncserverを起動し、VNCサーバのパスワードなどの初期設定をします。

```

[abciuser@esX ~] $ vncserver

You will require a password to access your desktops.

Password:

Verify:

Would you like to enter a view-only password (y/n)? n

New 'esX.abci.local:1 (abciuser)' desktop is esX.abci.local:1

Creating default startup script /home/abciuser/.vnc/xstartup

Creating default config /home/abciuser/.vnc/config

Starting applications specified in /home/abciuser/.vnc/xstartup

Log file is /home/abciuser/.vnc/esX.abci.local:1.log

```

* 一旦終了します。

```

[user@gXXXX ~] vncserver -kill :1

```

* 設定ファイルをいくつか修正します。

$HOME/.vnc/xstartup を以下のとおり編集します。

```

#!/bin/sh

unset SESSION_MANAGER

unset DBUS_SESSION_BUS_ADDRESS

xrdb $HOME/.Xresources

startxfce4 &

```

必要に応じて $HOME/.vnc/config でスクリーンサイズを変更しておきます。

```

geometry=2000x1200

```

* （ログインしていない場合は）ABCIにログインします。

```

[user@localmachine] $ ssh -J %r@as.abci.ai abciuser@es

```

* On-demand、ノード専有でUGEから1ノード確保してログインします。

```

[abciuser@esX ~] $ qrsh -g abcigroup -l rt_F=1

```

* vncserverを起動します。

```

[user@gXXXX ~] vncserver

New 'gXXXX.abci.local:1 (abciuser)' desktop is gXXXX.abci.local:1

Starting applications specified in /home/abciuser/.vnc/xstartup

Log file is /home/abciuser/.vnc/gXXXX.abci.local:1.log

```

gXXXX.abci.local:1 が起動したVNCサーバのディスプレイ名です。このVNCサーバには5901というポート番号が割り当てられます。:2の場合は5902、:3の場合は5903、というようにディスプレイ番号に5900を加えたポートが割り当てられるようになっています。


### 起動手順

ここでは、よく利用される macOSとWindowsに分けて開始手順を説明します。

#### macOS系の場合

macOSでは、デフォルトでOpenSSH 7.4以降がインストールされ、FinderにVNCクライアントが統合されています。


* ローカルマシンからポートフォワードの設定を行います。

```

[user@localmachine] $ ssh -N -L 5901:XXX.abci.local:5901 -J %r@as.abci.ai abciuser@es

```

これでローカルマシンの5901にアクセスすると、VNCサーバに接続できるようになります。

* VNCクライアントを起動します。

```

[user@localmachine] $ open vnc://localhost:5901/

```

#### Windows系の場合

Tera Term や PuTTY などでログインしている場合は、ポート転送の設定を行います。

*   Tera Term の場合

    [設定] -> [SSH転送] をクリックしSSH転送のセットアップ画面を表示します。次に、[追加]をクリックして表示される SSH転送画面で以下を設定します。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/apdx2_vnc_portfw_teraterm_01.png"  width="480" title="teraterm:ssh tunnel" > |
	| ローカルのポート | システムで許されている任意のポート番号 （例:15901） |
	| リモート側ホスト | 計算ノード (例:g0001) |
	| リモート側ポート | VNCサーバのポート番号 （例:5901） |

*   PuTTY の場合

    タイトルバーで右クリックし、[Change Settings...]をクリックします。表示される設定メニューのCategoryから、SSH->Tunnelsを選択し、以下を設定します。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/apdx2_vnc_portfw_putty_01.png"  width="480" title="putty:ssh tunnel" > |
	| ローカルのポート | システムで許されている任意のポート番号 （例:15901） |
	| リモート側ホスト：ポート | 計算ノードとVNCサーバのポート番号 (例:g0123:5901) |

#### VNC client の起動

ポート転送の設定が完了したらでSSHVNC client を起動します。TigerVNC Client の例では、以下のようにlocalhostに"::"でポート番号つなげて入力します。

<div align="center">
<img src="/img/apdx2_vnc_viewer_01.png" width="480" title="vncviewer"><br>
</div>

### 終了手順

* VNCサーバを終了し、計算ノードからexitします。

```

[user@gXXXX ~]$ vncserver -list

TigerVNC server sessions:

X DISPLAY #     PROCESS ID
:1              5081

[user@gXXXX ~] vncserver -kill :1

[user@gXXXX ~] exit

[user@esX ~] exit

```


## AWS の利用

### 概要

AWSは、各利用者ごとにAWSコマンドラインインターフェイス（以下、awscli）をインストールして利用します。ここでは、awscliのインストールと各種利用方法を記載します。

### pyenvによるpip環境の構築 (参考)d
awscliはpythonのpipを使用してインストールしますので、ご利用の環境に合わせてpip環境をご用意ください。なお、ここでは pip環境の参考としてpyenvの環境構築方法を紹介します。

* pyenvのインストール

```
[username@es1 testdir]$ curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
[username@es1 testdir]$ echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
[username@es1 testdir]$ echo 'eval "$(pyenv init -)"' >> ~/.bashrc
[username@es1 testdir]$ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
```

* 再ログインまたは.bashrcリロード後、設定ファイルに以下を記載します。

```
[username@es1 testdir]$ pyenv versions
[username@es1 testdir]$ pyenv install 2.7.15
[username@es1 testdir]$ pyenv virtualenv 2.7.15 awscli-test
[username@es1 testdir]$ pyenv global awscli-test 
```

### AWSコマンドラインインターフェイス(awscli)のインストール

pipでインストールします。
```
[username@es1 testdir]$ pip install awscli
```

### アクセストークンの登録

入手済みのAWSアクセスキーを登録します。
```
[username@es1 testdir]$  aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]:
```

### 各種操作
ここでは、各種操作方法を説明します。

* バケットの作成
```
[username@es1 testdir]$ aws s3 mb s3://abci-access-test
make_bucket: abci-access-test
```

* ローカルのファイルをバケットに保存
```
[username@es1 testdir]$ ls -la 1gb.dat 
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  7 11:27 1gb.dat
$ aws s3 cp 1gb.dat s3://abci-access-test # 
upload: ./1gb.dat to s3://abci-access-test/1gb.dat                
```

* バケット内のファイルを表示(ls) 
```
[username@es1 testdir]$ aws s3 ls s3://abci-access-test 
2018-11-09 10:13:56 1073741824 1gb.dat
```

* バケット内のファイルを削除(rm)
```
[username@es1 testdir]$ aws s3 rm s3://abci-access-test/1gb.dat
delete: s3://abci-access-test/1gb.dat
[username@es1 testdir]$ ls -l dir-test/
total 2097152

-rw-r--r-- 1 aaa10003xb gaa50031   1073741824 Nov  9 10:16 1gb.dat.1
-rw-r--r-- 1 aaa10003xb gaa50031   1073741824 Nov  9 10:17 1gb.dat.2
```

* ディレクトリを含むファイルごとバケットにアップロード(sync)
```
[username@es1 testdir]$ aws s3 sync dir-test s3://abci-access-test/dir-test
upload: dir-test/1gb.dat.2 to s3://abci-access-test/dir-test/1gb.dat.2
upload: dir-test/1gb.dat.1 to s3://abci-access-test/dir-test/1gb.dat.1
```

* バケット内でディレクトリを含むファイルごとコピー(sync)
```
[username@es1 testdir]$ aws s3 sync s3://abci-access-test/dir-test s3://abci-access-test/dir-test2
copy: s3://abci-access-test/dir-test/1gb.dat.1 to s3://abci-access-test/dir-test2/1gb.dat.1
copy: s3://abci-access-test/dir-test/1gb.dat.2 to s3://abci-access-test/dir-test2/1gb.dat.2
[username@es1 testdir]$ aws s3 ls s3://abci-access-test/dir-test2/
2018-11-09 10:20:05 1073741824 1gb.dat.1
2018-11-09 10:20:06 1073741824 1gb.dat.2
```

* バケットからディレクトリを含むファイルごとダウンロード(sync)
```
[username@es1 testdir]$ aws s3 sync s3://abci-access-test/dir-test2 dir-test2
download: s3://abci-access-test/dir-test2/1gb.dat.2 to dir-test2/1gb.dat.2
download: s3://abci-access-test/dir-test2/1gb.dat.1 to dir-test2/1gb.dat.1
[username@es1 testdir]$ ls -l dir-test2
total 2097152
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  9 10:20 1gb.dat.1
-rw-r--r-- 1 aaa10003xb gaa50031 1073741824 Nov  9 10:20 1gb.dat.2
```

* バケット内のディレクトリを含むファイルごと削除
```
[username@es1 testdir]$ aws s3 rm --recursive s3://abci-access-test/dir-test
delete: s3://abci-access-test/dir-test/1gb.dat.2
delete: s3://abci-access-test/dir-test/1gb.dat.1
[username@es1 testdir]$ aws s3 rm --recursive s3://abci-access-test/dir-test2
delete: s3://abci-access-test/dir-test2/1gb.dat.2
delete: s3://abci-access-test/dir-test2/1gb.dat.1
```

* バケットを削除
```
[username@es1 testdir]$ aws s3 rb s3://abci-access-test
remove_bucket: abci-access-test
```





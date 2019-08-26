# リモートデスクトップの利用

ここでは、VNC (Virtual Network Computing) を用いた、ABCIでのリモートデスクトップの利用方法について説明します。リモートデスクトップを使うことで、計算ノードでGUIの利用が可能になります。

## 前準備 {#preparation}

* ABCIにログインします。

    ログインの方法は、[インタラクティブノードへのログイン](../02.md#login-to-interactive-node)を参照してください。

* vncserverを起動し、VNCサーバのパスワードなどの初期設定をします。

```
[username@es1 ~] $ vncserver
You will require a password to access your desktops.

Password:
Verify:
Would you like to enter a view-only password (y/n)? n

New 'es1.abci.local:1 (username)' desktop is es1.abci.local:1

Creating default startup script /home/username/.vnc/xstartup
Creating default config /home/username/.vnc/config
Starting applications specified in /home/username/.vnc/xstartup
Log file is /home/username/.vnc/es4.abci.local:1.log
```

* 一旦終了します。

```
[username@g0001 ~] vncserver -kill :1
```

* 設定ファイルをいくつか修正します。

$HOME/.vnc/xstartup を以下のとおり編集します。

```
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
#exec /etc/X11/xinit/xinitrc

xrdb $HOME/.Xresources
startxfce4 &
```

必要に応じて $HOME/.vnc/config でスクリーンサイズを変更しておきます。

```
geometry=2000x1200
```

* （ログインしていない場合は）ABCIにログインします。

```
[user@localmachine] $ ssh -J %r@as.abci.ai username@es
```

* On-demand、ノード専有で1ノード確保してログインします。

```
[username@g0001 ~] $ qrsh -g grpname -l rt_F=1
```

* vncserverを起動します。

```
[username@g0001 ~] vncserver

New 'g0001.abci.local:1 (username)' desktop is g0001.abci.local:1

Starting applications specified in /home/username/.vnc/xstartup
Log file is /home/username/.vnc/g0001.abci.local:1.log

[username@g0001 ~]
```

g0001.abci.local:1 が起動したVNCサーバのディスプレイ名です。このVNCサーバには5901というポート番号が割り当てられます。:2の場合は5902、:3の場合は5903、とディスプレイ番号に5900を加えたポートが割り当てられます。

## 起動手順 {#start-vnc}

ここでは、よく利用されるSSHクライアントでの起動手順と、Windowsで利用されるTera TermやPuTTYでの起動手順を説明します。

### SSHクライアントの利用 {#using-an-ssh-client}

Linux、macOSを含むUNIX系OS、Windows 10 version 1803 (April 2018 Update)以降など、ほとんどのPCには、デフォルトでSSHクライアントがインストールされています。インストールされているかどうかを確認するには、コマンドラインから``ssh``コマンドを実行するだけで済みます。

#### SSHトンネルの設定 {#create-an-ssh-tunnel}

ローカルPCのポート5901を使ってVNCサーバに接続できるようにする場合、``localhost:5901``と``g0001.abci.local:5901``の間のSSHトンネルを作成する必要があります。

ProxyJumpが利用可能なOpenSSH 7.3以降がインストールされている場合は、以下のように実行することでSSHトンネルを作成できます。

```
[user@localmachine] $ ssh -N -L 5901:g0001.abci.local:5901 -J %r@as.abci.ai username@es
```

ProxyJumpが利用できない場合は、以下のように実行すれば同様にSSHトンネルを作成できます。

```
[user@localmachine] $ ssh -L 10022:es:22 -l username as.abci.ai
[user@localmachine] $ ssh -p 10022 -N -L 5901:g0001.abci.local:5901 -l username localhost
```

#### VNCクライアントの起動 {#launch-vnc-client}

macOSでは、FinderにVNCクライアントが統合されているため、以下のコマンドで起動できます。

```
[user@localmachine] $ open vnc://localhost:5901/
```

macOS以外のOSでは、別途VNCクライアントをインストールする必要があります。

### Tera Term や PuTTYの利用 {#tera-term-and-putty}

#### SSHトンネルの設定 {#ssh-tunnel_1}

Tera Term や PuTTY などでログインしている場合は、ポート転送の設定を行います。

* Tera Term の場合

    [設定] -> [SSH転送] をクリックしSSH転送のセットアップ画面を表示します。次に、[追加]をクリックして表示される SSH転送画面で以下を設定します。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="vnc_portfw_teraterm_01.png"  width="480" title="teraterm:ssh tunnel" > |
	| ローカルのポート | システムで許されている任意のポート番号 （例:15901） |
	| リモート側ホスト | 計算ノード (例:g0001) |
	| リモート側ポート | VNCサーバのポート番号 （例:5901） |

* PuTTY の場合

    タイトルバーで右クリックし、[Change Settings...]をクリックします。表示される設定メニューのCategoryから、SSH->Tunnelsを選択し、以下を設定します。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="vnc_portfw_putty_01.png"  width="480" title="putty:ssh tunnel" > |
	| ローカルのポート | システムで許されている任意のポート番号 （例:15901） |
	| リモート側ホスト：ポート | 計算ノードとVNCサーバのポート番号 (例:g0123:5901) |

#### VNCクライアントの起動 {#run-vnc-client_1}

ポート転送の設定が完了したらVNCクライアントを起動します。TigerVNC Clientの例では、以下のようにlocalhostに"::"でポート番号つなげて入力します。

<div align="center">
<img src="vnc_viewer_01.png" width="480" title="vncviewer"><br>
</div>

## 終了手順 {#stop-vnc}

* VNCサーバを終了し、計算ノードからexitします。

```
[username@g0001 ~]$ vncserver -list
TigerVNC server sessions:
X DISPLAY #     PROCESS ID
:1              5081

[username@g0001 ~] vncserver -kill :1
Killing Xvnc process ID XXXXXX
[username@g0001 ~] exit
[username@es1 ~]
```

# Tera Term

ここでは、Tera Termを用いたインタラクティブノードへのログイン手順を示します。OpenSSHクライアントなどのSSHクライアントを利用したログイン手順は、[インタラクティブノードへの接続](../02.md#connecting-to-interactive-node)を参照してください。

インタラクティブノードへのログインは、以下手順で実施します。

1. Tera Termを起動し、SSHトンネル情報を設定
2. アクセスサーバ(*as.abci.ai*)にログインして、SSHトンネルを作成
3. 別のTera Term画面を起動して、SSHトンネルを用いてインタラクティブノードにログイン

!!! note
    事前に[ABCI利用ポータル](https://portal.abci.ai/user/)にて[SSH公開鍵の登録](https://portal.abci.ai/docs/portal/ja/02/#23)が必要です。

## SSHトンネル情報の設定 {#ssh-tunnel}

* Tera Term の起動

    Tera Term起動直後に表示される新しい接続画面は[キャンセル]ボタンで閉じ、未接続のTera Termを画面を残します。

<div align="center">
<img src="/img/02_login_teraterm_00_ja.png" width="480" title="cancel new connect" /><br />
↓<br />
<img src="/img/02_login_teraterm_99_ja.png" width="480" title="teraterm" />
</div>

* SSHポート転送画面の表示

    Tera Termの[設定]メニューを開き[SSH転送]を選択し、SSHポート転送画面を表示します。

<div align="center">
<img src="/img/02_login_teraterm_01_ja.png" width="640" title="Screenshot" />
</div>

* ポート転送の追加

    [追加]ボタンをクリックし、SSHポート転送の設定画面を表示してください。

<div align="center">
<img src="/img/02_login_teraterm_02_ja.png" width="560" title="Screenshot" />
</div>

* SSHポート転送の設定

    SSHポート転送の設定画面で以下の表の設定値を入力します。ローカルのポートはお使いのシステムで許容されているポート番号の中から任意の値を設定可能ですが、他設定は固定値です。設定が完了したら、[OK]ボタンをクリックして前の画面に戻ります。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/02_login_teraterm_03_ja.png"  width="480" title="teraterm:ssh tunnel" > |
	| ローカルのポート | システムで許されている任意のポート番号 (例: 10022) |
	| リモート側ホスト | *es.abci.local* または *es* （固定値）|
	| ポート | 22 （固定値）|
      
* 設定が追加されていることを確認し、[OK]ボタンをクリックしてTera Term の画面に戻ります。

<div align="center">
<img src="/img/02_login_teraterm_04_ja.png" width="560" title="Screenshot" />
</div>

!!! warning
    Tera Termの画面は閉じないでください。この画面を使って、次節でアクセスサーバへの接続を行います。

## アクセスサーバへの接続 {#login-to-access-server}

ここでは、アクセスサーバの接続手順を説明します。

* 接続情報の入力画面の表示

    前章で設定したTera Termの[ファイル]メニューを開き、[新しい接続]画面を表示します。

<div align="center">
<img src="/img/02_login_teraterm_05_ja.png"  width="640" title="Screenshot" />
</div>

* アクセスサーバへの新規接続

    接続先にアクセスサーバ（*as.abci.ai*）を指定し、SSHで接続します。設定は以下のとおりです。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/02_login_teraterm_06_ja.png"  width="480" title="login" /> |
	| ホスト | *as.abci.ai* |
	| TCPポート | 22 |
	| サービス | ssh |

    設定が完了したら、[OK]ボタンをクリックしてSSHの認証に移ります。

* 認証（アクセスサーバ）
<a name="teraterm:ssh-auth-as"></a>

    SSHの認証情報を入力します。設定は以下のとおりです。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/02_login_teraterm_07_ja.png"  width="480" title="ssh auth" /> |
	| ユーザ名 | ABCIアカウント |
	| パスフレーズ | 秘密鍵のパスフレーズ |
	| 認証方法 | RSA/DSA/ECDSA鍵をつかうにチェック |
	| 秘密鍵 | 登録した公開鍵の秘密鍵ファイルパス |

    設定が完了したら、[OK]ボタンをクリックしてアクセスサーバにログインします。ログインに成功すると以下の画面が表示されます。ABCIにログイン中は、このログインセッションを維持する必要があります。

<div align="center">
<img src="/img/02_login_teraterm_08_ja.png"  width="640" title="success login as" >
</div>

!!! warning
    画面上で何らかのキーを入力するとSSH接続が切断されてしますので注意してください。

## インタラクティブノードへの接続 {#login-to-interactive-node}

ここでは、インタラクティブノードへの接続手順を説明します。

* Tera Termの起動と接続設定

    新規にTera Termを起動し、インタラクティブノードに接続します。設定は以下のとおりです。

	| 項目 | 画面と設定値 |
	|:--|:--|
	| 設定画面 | <img src="/img/02_login_teraterm_09_ja.png"  width="480" title="connect es" /> |
	| ホスト | localhost(固定） |
	| TCPポート | [SSHトンネル情報の設定](#ssh-tunnel-with-teraterm)で設定したポート番号 (画面例: 10022) |
	| サービス | ssh （固定）|

    設定が完了したら、[OK]ボタンをクリックし、SSHの認証に移ります。

* 認証（インタラクティブノード）

    インタラクティブノードの認証は、アクセスサーバと同じです。[アクセスサーバの認証方法](#teraterm:ssh-auth-as)を参照し、SSHの認証情報を入力してください。

    設定が完了したら、[OK]ボタンをクリックしてインタラクティブノードにログインしてください。ログインに成功すると以下の画面が表示されます。

<div align="center">
<img src="/img/02_login_teraterm_10_ja.png"  width="640" title="success login es" >
</div>

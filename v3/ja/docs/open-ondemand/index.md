# Open OnDemand

## 概要 {#overview}

[Open OnDemand (OOD)](https://openondemand.org/)はWebブラウザからABCIを使用するためのポータルサイトです。

以下の機能がWebブラウザ上で利用できるようになり、より簡単にABCIを使えるようになります。

- インタラクティブノードでのコンソール操作
- ホーム領域、グループ領域のファイル操作
- Jupyter Lab等のWebアプリケーションの利用


## 初期パスワードの発行 {#initial-password}

Open OnDemandに初めてログインする場合、Open OnDemand用の初期パスワードが必要です。
初期パスワードの発行は、[お問い合わせ](../contact.md)ページを参照のうえ、<abci3-qa@abci.ai> までご依頼ください。

初期パスワードの変更については[初期パスワード変更方法](#how-to-change-the-initial-password)を参照してください。


## 初期パスワード変更方法 {#how-to-change-the-initial-password}

初期パスワードを変更するにはインタラクティブノードで、`passwd`コマンドを実行します。

```
[username@login1 ~]$ passwd
Changing password for user username.
Current Password:<初期パスワードの入力>
New password:<新しいパスワードの入力>
Retype new password:<新しいパスワードの再入力>
passwd: all authentication tokens updated successfully.
[username@login1 ~]$
```

!!! warning
    パスワード規約は以下の通りです。

    - 12文字以上。
    - 英小文字、英大文字、数字、記号の4種類をすべて含む。
    - 使用可能な記号は次の33種類。(空白) ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~

## ログイン方法 {#login}

Open OnDemandにログインするためにはまず、URL [https://ood.v3.abci.ai/](https://ood.v3.abci.ai/) にアクセスします。
ood.v3.abci.ai にアクセスした後、ABCIアカウント名とパスワードの入力が求められるので、ABCIアカウント名とパスワードを入力してください。

ABCIアカウント名とパスワードによる認証後、アクセスコードの入力が求められます。
アクセスコードは登録しているメールアドレス宛に送付されますので、アクセスコードを受信後、入力フォームにアクセスコードを入力してください。アクセスコードのタイムアウト時間は30分です。

!!! note
    アクセスコードを記載したメールが、迷惑メールフォルダに振り分けられる場合があります。メールが届かない場合は、迷惑メールフォルダのご確認をお願いいたします。

アクセスコードによる認証後、Open OnDemandへのログインが完了します。

!!! warning
    ログイン中にエラーが発生した場合は、管理者まで[お問合せ](../contact.md)ください。


## アプリケーション {#applications}

Open OnDemandが提供する機能には、画面上部のメニューからアクセスできます。

[![Open OnDemand Application Menu](ood-menu.png)](ood-menu.png)

1. **Files**: ファイル操作をブラウザ上で行えます

2. **Jobs**: ジョブ編集・管理をブラウザ上で行えます

3. **Clusters**: インタラクティブノードのコンソールが開きます

4. **Interactive Apps**: 計算ノード上でWebアプリケーションを起動し、その画面をWebブラウザに転送します。

<!--5. **AI Hub**: AI HubはABCI上で大規模な汎用学習済みモデルの再利用等を行うためのツールやサービス群です。AI Hubを構成する機能の1つである、MLflow Tracking Serverのデプロイを管理するアプリケーションを提供します。-->

!!! note
    **Clusters** のコンソール画面のタイムアウトは非アクティブの場合は100分、アクティブな場合は10時間です。


## ABCI 2.0との機能互換性 {#compatibility}

ABCI 2.0との機能互換性を以下に示します。

| サービス名 | ABCI 2.0 | ABCI 3.0 | 
|:--|:---:|:---:|
| ホーム領域、グループ領域のファイル操作 | 〇 | 〇 | 
| ジョブ編集・管理 | 〇 | 〇 | 
| インタラクティブノードでのコンソール操作 | 〇 | 〇 | 
| Jupyter notebook | 〇 | 〇 | 
| Qni | 〇 | ×[^1] | 
| AI Hub | 〇 | ×[^1] | 

[^1]: 今後の実装を予定しています。

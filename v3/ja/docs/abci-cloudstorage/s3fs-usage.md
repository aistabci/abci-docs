
# s3fs-fuseの利用

ABCIでは`s3fs-fuse`モジュールを提供しており、ABCIクラウドストレージのバケットをローカルのファイルシステムとしてマウントできます。
ここでは`s3fs-fuse`モジュールの使用方法を説明します。

## アクセスキー

s3fs-fuseを使うにあたり、アクセスキーが必要です。
アクセスキーの発行方法については [ABCI利用者ポータルガイド](https://docs.abci.ai/v3/portal/ja/02/#283-csad)を参照してください。
アクセスキーを発行したあとAWS CLIを使用しアクセスキーを設定します。アクセスキーの設定方法については[ABCIクラウドストレージの使い方](usage.md)を参照してください。

ここではアクセスキーを`default`プロファイルで設定しているものとします。

## モジュールのロード

インタラクティブノードにログイン後、`s3fs-fuse`モジュールをロードします。
```
[username@login1 ~]$ module load s3fs-fuse
```

## バケットの作成

マウントするためのバケットを作成します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mb s3://s3fs-bucket
make_bucket: s3fs-bucket
```

## バケットをマウントする

インタラクティブノードの`/tmp`、計算ノードの`/tmp`および、ジョブに割り当てられたローカルストレージ(`$PBS_LOCALDIR`)が`s3fs-fuse`のマウントポイントとして利用できます。
ただし、ジョブ内で`s3fs-fuse`を使用してバケットをマウントした場合、ジョブの終了時に自動でアンマウントされますのでご注意ください。

以下ではインタラクティブノードの`/tmp`を利用したバケットのマウント方法を説明します。

マウントポイントをTMPディレクトリ上に作成し、先ほど作成した`s3fs-bucket`バケットを`s3fs`コマンドでマウントします。

```
[username@login1 ~]$ mkdir /tmp/s3fs_dir
[username@login1 ~]$ s3fs s3fs-bucket /tmp/s3fs_dir -o url=https://s3.v3.abci.ai/ -o use_path_request_style
```

`default`プロファイル以外のアクセスキーを使いたい場合は`-o profile=プロファイル名`オプションを指定します。

```
[username@login1 ~]$ s3fs s3fs-bucket /tmp/s3fs_dir -o url=https://s3.v3.abci.ai/ -o profile=aaa00000.2 -o use_path_request_style
```

## マウントの確認

マウントが成功したことを確認するには、`df`コマンドを使用します。
先頭に「s3fs」が表示されている行が、s3fsでマウントされているファイルシステムです。

```
[username@login1 ~]$ df -hT | grep "^s3fs"
s3fs                    fuse.s3fs    64P     0   64P   0% /tmp/s3fs_dir
```

## ファイル操作

バケットをマウントした後は、ファイル操作と同じ方法でバケットへオブジェクトの追加、削除が行えます。

```
[username@login1 ~]$ cp ~/my-file /tmp/s3fs_dir/
[username@login1 ~]$ ls /tmp/s3fs_dir/my-file
[username@login1 ~]$ rm /tmp/s3fs_dir/my-file
```

## バケットをアンマウントする

バケットをアンマウントするには`fusermount`コマンドを使用します。

```
[username@login1 ~]$ fusermount -u /tmp/s3fs_dir
```

## アンマウントの確認

アンマウントが成功したことを確認するには、`df`コマンドを使用します。
s3fsで表示されていた行が消えていれば、アンマウントが成功しています。

```
[username@login1 ~]$ df -hT | grep "^s3fs"
[username@login1 ~]$
```

`s3fs-fuse`を利用してバケットをマウントした場合は、自動でアンマウントされないため、不要になったらアンマウントしてください。


## s3fsコマンドオプション

`s3fs`コマンドのオプションを以下に示します。詳細については`man s3fs`または[s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse)のWebサイトを参照してください。

| オプション   | 説明                              | 例                             |
|:--           |:--                                |:--                             |
| url          | 接続するエンドポイントURL。       | `-o url=https://s3.v3.abci.ai` |
| profile      | 認証に使用するプロファイル名。    | `-o profile=aaa00000.2`        |
| dbglevel     | デバッグメッセージレベル。        | `-o dbglevel=info`             |
| curldb       | libcurlデバッグメッセージの有効化 | `-o curldb`                    |

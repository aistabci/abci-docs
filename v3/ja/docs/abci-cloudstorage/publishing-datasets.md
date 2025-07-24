# データセットの公開

ABCIクラウドストレージを用いてデータセットを一般に公開することができます。[ABCI約款・規約](https://abci.ai/ja/how_to_use/) や [ABCIクラウドストレージ規約](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf) に改めて目を通し、そのデータセットの公開が本当に適切であるかをご確認の上、以下の手順に従って、データセットの公開設定と登録を行って下
さい。


## 1. 公開設定 {#publishing}

ABCIクラウドストレージにデータをアップロードし、[アクセス制御(1)](acl.md) を参考に公開設定（パブリックアクセスの設定
）を行って下さい。

以下では、ABCIクラウドストレージに example-dataset というバケットを作り、sensor1 というディレクトリに格納された複数のファイルをアップロードし、公開設定を行う例を示します。

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mb s3://example-dataset
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3api put-bucket-acl --acl public-read --bucket example-dataset
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp --acl public-read --recursive sensor1 s3://example-dataset/sensor1
upload: sensor1/0003.dat to s3://example-dataset/sensor1/0003.dat
upload: sensor1/0001.dat to s3://example-dataset/sensor1/0001.dat
upload: sensor1/0002.dat to s3://example-dataset/sensor1/0002.dat
:
```

上記ではアップロート時に `--acl public-read` を指定しているため、アップロードが完了後、ABCIの外部から `https://example-dataset.s3.abci.ai/sensor1/0001.dat` 等の URL でアクセスができるようになります。

<!-- データセットの利用者がダウンロードできるように、これらの URL のリストを用意して下さい。-->


## 2. 公開データセットの登録 {#registration}

公開設定を行ったデータセットは、こちら(データセット公開後にリンクします)の手順に従ってABCIデータセットへの登録を行って下さい。

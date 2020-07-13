
# データセットの公開

ABCIでは、ABCIクラウドストレージ上で公開しているデータセットを[リスト表示するためのページ](https://datasets.abci.ai/)を用意しています。 ここでは、ABCIクラウドストレージ上でデータセットを公開し、そのページに追加するまでの手順を説明します。

## データのアップロードと公開設定 {#upload-and-publish-data}

sensor1 と sensor2 というディレクトリに、データが記録されたファイルが複数入っているものとします。example-dataset というバケットを作り、そこにアップロードします。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mb s3://example-dataset
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read --recursive sensor1 s3://example-dataset/sensor1
upload: sensor1/0003.dat to s3://example-dataset/sensor1/0003.dat
upload: sensor1/0001.dat to s3://example-dataset/sensor1/0001.dat
upload: sensor1/0002.dat to s3://example-dataset/sensor1/0002.dat
:
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read --recursive sensor2 s3://example-dataset/sensor2
:
```

`--acl public-read` を指定しているため、データは公開設定されています。ABCI外部からは、`https://example-dataset.s3.abci.ai/sensor1/0001.dat` のように指定してアクセスすることができます。利用者がダウンロードできるように、これらの URL のリストを用意してください。

## データセットのメタデータの記述 {#write-metadata}

[こちら](https://datasets.abci.ai/dataset.yaml)のYAMLファイルをダウンロードし、[サンプルのページ](https://datasets.abci.ai/registration/)を参考に、各項目を記入してください。その後、ABCIクラウドストレージのバケットにアップロードし、公開設定を行ったら、URLを <abci-application-ml@aist.go.jp> までお知らせください。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read dataset.yaml s3://example-dataset/dataset.yaml
```

## 簡易WEBサイトの生成 (任意) {#make-simple-site}

データセットを紹介するプロジェクトのページをお持ちでない場合、以下のような作業で簡素なページを用意することができます。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp s3://admin/generate-simple-page generate-simple-page
[username@es1 ~]$ chmod 755 generate-simple-page
[username@es1 ~]$ wget -nv https://datasets.abci.ai/sha256sum.txt
2020-07-13 22:22:55 URL:https://datasets.abci.ai/sha256sum.txt [87/87] -> "sha256sum.txt" [1]
[username@es1 ~]$ sha256sum -c sha256sum.txt
generate-simple-page: OK
[username@es1 ~]$ ./generate-simple-page dataset.yaml > index.html
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read index.html s3://example-dataset/index.html
```

これでブラウザから `https://example-dataset.s3.abci.ai/index.html` を開いて確認できます。
以下の作業を行うと、`https://example-dataset.s3-website.abci.ai/` で同じページを返すようになります。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 website s3://example-dataset/ --index-document index.html
```


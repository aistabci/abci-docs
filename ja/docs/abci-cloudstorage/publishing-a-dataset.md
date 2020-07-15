
# データセットの公開

ABCIクラウドストレージを用いてデータセットを一般に公開することができます。xxxやxxxに改めて目を通し、そのデータセットの公開が本当に適切であるかをご確認の上、以下の手順に従って、データセットの公開設定と登録を行って下さい。

<!-- 削除: ABCIでは、ABCIクラウドストレージ上で公開しているデータセットを[リスト表示するためのページ](https://datasets.abci.ai/)を用意しています。 ここでは、ABCIクラウドストレージ上でデータセットを公開し、そのページに追加するまでの手順を説明します。-->


## 1. 公開設定 {#publishing}

<!-- 要修正: bucket を public にする例で書くこと。記述量は下記くらいの簡素なものとして、アクセス制御(1) と相互リンクにするので良いかもしれません。-->

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


## 2. 公開データセットの登録 {#registration}

[こちら](https://datasets.abci.ai/dataset.yaml)のYAMLファイルを手元にダウンロードし、公開データセットに関する基本情報を記入して下さい。

<!-- 要修正: サンプルは、リンクではなく、ここに書いてしまうこと。YAMLファイル名はdataset.yamlで固定されているべき？
[サンプルのページ](https://datasets.abci.ai/registration/)を参考に、各項目を記入してください。
  -->

次に、記入したYAMLファイルを用いて、データセットの公開ページ（index.html）を生成します。

<!-- 要修正：コマンドは短く "generate_page" 等として下さい。RDFa ないし JSON-LD でマークアップされていないように思います。これは重要なことなので対応して下さい。-->

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp s3://admin/generate-simple-page generate-simple-page
[username@es1 ~]$ chmod 755 generate-simple-page
[username@es1 ~]$ wget -nv https://datasets.abci.ai/sha256sum.txt
2020-07-13 22:22:55 URL:https://datasets.abci.ai/sha256sum.txt [87/87] -> "sha256sum.txt" [1]
[username@es1 ~]$ sha256sum -c sha256sum.txt
generate-simple-page: OK
[username@es1 ~]$ ./generate-simple-page dataset.yaml > index.html
```

HTMLファイルが問題なく生成されたら、データセットを公開しているバケットに、記入したYAMLファイルと生成したHTMLファイルの両方をアップロードして下さい。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read dataset.yaml s3://example-dataset/dataset.yaml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read index.html s3://example-dataset/index.html
```

アップロードしたHTMLファイルは、ブラウザから `https://example-dataset.s3.abci.ai/index.html` を開いて確認できます。以下の設定を行うと、`https://example-dataset.s3-website.abci.ai/` のリンクで同じページを開くことができます。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 website s3://example-dataset/ --index-document index.html
```

なお、生成したHTMLファイルには、YAMLファイルに記入した情報が構造化データ（xxx形式）として含まれています。データセットに関する基本情報を更新したい場合には再度、HTMLファイルの生成とアップロードを行って下さい。このファイルを直接変更したり、別のWebサイトに同等のページを用意したりすることも可能です。ただし、このファイルと同様の構造化データを保持するようにして下さい。

上記がすべて完了したら、以下のフォーマットで <abci-application-ml@aist.go.jp> までお知らせ下さい。
<!-- 要検討：URL 以外の必要情報 -->

登録が完了したデータセットは <https://datasets.abci.ai/> に一覧表示されます。


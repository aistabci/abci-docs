
# データセットの公開

ABCIクラウドストレージを用いてデータセットを一般に公開することができます。[ABCI約款・規約](https://abci.ai/ja/how_to_use/) や [ABCIクラウドストレージ規約](https://abci.ai/ja/how_to_use/data/cloudstorage-agreement.pdf) に改めて目を通し、そのデータセットの公開が本当に適切であるかをご確認の上、以下の手順に従って、データセットの公開設定と登録を行って下さい。


## 1. 公開設定 {#publishing}

ABCIクラウドストレージにデータをアップロードし、[アクセス制御(1)](acl.md) を参考に公開設定（パブリックアクセスの設定）を行って下さい。

以下では、ABCIクラウドストレージに example-dataset というバケットを作り、sensor1 というディレクトリに格納された複数のファイルをアップロードし、公開設定を行う例を示します。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mb s3://example-dataset
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3api put-bucket-acl --acl public-read --bucket example-dataset
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read --recursive sensor1 s3://example-dataset/sensor1
upload: sensor1/0003.dat to s3://example-dataset/sensor1/0003.dat
upload: sensor1/0001.dat to s3://example-dataset/sensor1/0001.dat
upload: sensor1/0002.dat to s3://example-dataset/sensor1/0002.dat
:
```

上記ではアップロート時に `--acl public-read` を指定しているため、アップロードが完了後、ABCIの外部から `https://example-dataset.s3.abci.ai/sensor1/0001.dat` 等の URL でアクセスができるようになります。

<!-- データセットの利用者がダウンロードできるように、これらの URL のリストを用意して下さい。-->


## 2. 公開データセットの登録 {#registration}

まず、[こちら](https://datasets.abci.ai/dataset.yaml)のYAMLファイルを手元にダウンロードし、下記を参考に公開データセットに関する基本情報を記入して下さい。

<!--UsageInfo には、後述の index.html または別途用意するページの URL を記入します。UsageInfo には、データファイルまたはデータファイルのリストが記載されているページの URL を記入します。-->

```yaml
# データセット名  *必須
Name: ABC Dataset

# データセットの概要 (50文字以上)  *必須
Description: This is a fictitious dataset ....

# データセットに関するキーワード (object detection, vehicle, action recognition, earth observation, etc.)
Keywords: image processing, health

# より詳細な情報を記した Web ページ　*必須
#  本YAMLから生成する index.html に詳細を追記する場合は、下記のように https://<バケット名>.s3-website.abci.ai/ を記入して下さい。
UsageInfo: https://example-dataset.s3-website.abci.ai/

# 配布方法
#  EncodingFormat:  XML, CSV, GeoTIFF, etc.
#  ContentURL: 公開データの URL　*必須
Distribution: # (do not fill in this line)
  EncodingFormat: DICOM
  ContentURL: https://example-dataset.s3.abci.ai/abc.zip

# 作成者
#  ContactPoint: Email or URL のいずれかは必須
Creator: # (do not fill in this line)
  Name: ABC Team
  URL: https://example.com/about/
  ContactPoint: # (do not fill in this line)
    Email: dataset@example.com
    URL: https://example.com/contact/

# ライセンス
#  Name: MIT License, CC-BY-SA 4.0, Custom License, etc.
License: # (do not fill in this line)
  Name: Custom License
  URL: https://example.com/dataset/LISENCE.txt

# バージョン
Version: 1.1b

# データ作成日、修正日、公開日
DateCreated: 2020-04-18
DateModified: 2020-04-20
DatePublished: 2020-04-19

# DOI 等の識別子
Identifier: https://doi.org/1234....

# 関連文献等の情報
Citation: 
```

次に、記入したYAMLファイルを用いて、データセットの公開ページ（index.html）を生成します。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp s3://tools/generate_page generate_page
[username@es1 ~]$ chmod 755 generate_page
[username@es1 ~]$ wget -nv https://datasets.abci.ai/sha256sum.txt
2020-07-13 22:22:55 URL:https://datasets.abci.ai/sha256sum.txt [87/87] -> "sha256sum.txt" [1]
[username@es1 ~]$ sha256sum -c sha256sum.txt
generate_page: OK
[username@es1 ~]$ ./generate_page dataset.yaml > index.html
```

HTMLファイルが問題なく生成されたら、データセットを公開しているバケットに、記入したYAMLファイルと生成したHTMLファイルの両方をアップロードして下さい。 `dataset.yaml` は、違うファイル名に変えても問題ありません。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read dataset.yaml s3://example-dataset/dataset.yaml
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read index.html s3://example-dataset/index.html
```

アップロードしたHTMLファイルは、ブラウザから `https://example-dataset.s3.abci.ai/index.html` を開いて確認できます。以下の設定を行うと、`https://example-dataset.s3-website.abci.ai/` でも同じページが表示されるようになります。

```
[username@es1 ~]$ module load aws-cli
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 website s3://example-dataset/ --index-document index.html
```

なお、生成したHTMLファイルには、YAMLファイルに記入した情報が構造化データ (JSON-LD形式) として含まれています。データセットに関する基本情報を更新したい場合には再度、HTMLファイルの生成とアップロードを行って下さい。このファイルを直接変更したり、別のWebサイトに同等のページを用意したりすることも可能です。ただし、このファイルと同様の構造化データを保持するようにして下さい。

上記がすべて完了したら、以下のフォーマットで <abci-application-ml@aist.go.jp> までお知らせ下さい。複数のABCIグループに所属している場合、データセットがアップロードされているバケットを所有しているABCIグループを記載してください。

```text
Subject: データセットの公開(<データセット名>)

申請者の氏名: 
ABCIグループ: 
申請者のメールアドレス: 
アップロードしたHTMLファイルのURL: 
```

登録が完了したデータセットは <https://datasets.abci.ai/> に一覧表示されます。

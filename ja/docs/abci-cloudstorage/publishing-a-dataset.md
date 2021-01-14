
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

まず、公開するデータセットに関する基本情報を記入したYAMLファイルを準備して下さい。[テンプレートファイル (dataset_info_template.yaml)](https://datasets.abci.ai/dataset_info_template.yaml) を手元にダウンロードし、下記を参考に記入して下さい。

<!--UsageInfo には、後述の index.html または別途用意するページの URL を記入します。UsageInfo には、データファイルまたはデータファイルのリストが記載されているページの URL を記入します。-->

```yaml
# データセット名  *必須
Name: ABC Dataset

# データセットの概要 (50文字以上)  *必須
Description: This is a fictitious dataset ....

# データセットに関するキーワード (object detection, vehicle, action recognition, earth observation, etc.)
Keywords: image processing, health

# より詳細な情報を記した Web ページ　*必須
#　本YAMLから生成する index.html に詳細を追記する場合は、以下の例のように https://<バケット名>.s3-website.abci.ai/ を記入して下さい。
#  そうでなく、別のサイトに Web ページを用意する場合は、その URL を記入して下さい。
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

次に、記入したYAMLファイルをクラウドストレージにアップロードして下さい。 `my_dataset_info.yaml` は違うファイル名でも問題ありません。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read my_dataset_info.yaml s3://example-dataset/my_dataset_info.yaml
```

完了したら、以下のフォーマットで <abci-application-ml@aist.go.jp> までお知らせ下さい。複数のABCIグループに所属している場合、データセットがアップロードされているバケットを所有しているABCIグループを記載して下さい。

```text
Subject: データセットの公開(<データセット名>)

申請者の氏名: 
ABCIグループ: 
申請者のメールアドレス: 
アップロードしたYAMLファイルのURL: 
```

登録が完了したデータセットは <https://datasets.abci.ai/> に一覧表示されます。


# ABCI データセット

ABCIデータセットは、ABCI利用者によって登録されたデータセットのカタログサービスです。ABCI利用者によって公開、および限定公開されたデータセットが登録されています。[ABCI Datasets](https://datasets.abci.ai)より利用できます。

ABCIデータセットへの登録は以下の手順で行うことができます。なお、データセットは[ABCIクラウドストレージ](abci-cloudstorage.md)、またはABCI以外を含む、他のストレージサービスに保存されていることを前提としています。前者の場合は、[データセットの公開](abci-cloudstorage/publishing-datasets.md)を参考にデータセットの公開設定を行って下さい。

!!! note
    ABCIデータセットへの登録に際しては、自身が該当データセットの所有権を有している等、データセット情報の公開に関して責任を負えることを十分にご確認下さい。


## 1. データセットの登録 {#registration}

まず、登録するデータセットに関する基本情報を記入したYAMLファイルを準備します。[テンプレートファイル (dataset_info_template.yaml)](https://datasets.abci.ai/dataset_info_template.yaml) を手元にダウンロードし、下記を参考に記入して下さい。

<!--UsageInfo には、後述の index.html または別途用意するページの URL を記入します。UsageInfo には、データファイルまたはデータファイルのリストが記載されているページの URL を記入します。-->

```yaml
# データセット名  *必須
Name: ABC Dataset

# データセットの概要 (50文字以上)  *必須
Description: This is a fictitious dataset ....

# データセットに関するキーワード (object detection, vehicle, action recognition, earth observation, etc.)  *必須
# 項目が1つであってもハイフンではじまるリスト形式で記入してください。
Keywords:
  - image processing
  - health

# より詳細な情報を記した Web ページ
UsageInfo: https://example-dataset.s3-website.abci.ai/

# 配布方法
#   EncodingFormat: XML, CSV, GeoTIFF, etc.
#   ContentURL: 公開データの URL
Distribution:
  EncodingFormat: DICOM
  ContentURL:  # 項目が1つであってもハイフンではじまるリスト形式で記入してください。
    - https://example-dataset.s3.abci.ai/abc1.zip
    - https://example-dataset.s3.abci.ai/abc2.zip

# 作成者
#   Name: 組織名(または個人名)  *必須
#   URL: 組織のWEBサイト(または個人のWEBサイト)
#   ContactPoint:
#     Email: 連絡先メールアドレス  *Email or URL のいずれかが必須
#     URL: 問い合わせ窓口のページ  *Email or URL のいずれかが必須
Creator:
  Name: ABC Team
  URL: https://example.com/about/
  ContactPoint:
    Email: dataset@example.com
    URL: https://example.com/contact/

# ライセンス
#   Name: MIT License, CC-BY-SA 4.0, Custom License, etc.  *必須
#   URL: ライセンスが記述されているページのURL
License:
  Name: Custom License
  URL: https://example.com/dataset/LISENCE.txt

# バージョン
Version: "1.1b"

# データ作成日、修正日、公開日
# 下記のような ISO 8601 フォーマットで記載してください。時間部分は省略可能です。
DateCreated: 2020-04-18
DateModified: 2020-04-20T22:30:10+09:00
DatePublished: 2020-04-19

# DOI 等の識別子
#Identifier: https://doi.org/1234....

# 関連文献等の情報。項目が1つであってもハイフンを使ったリスト形式で記入してください。
Citation: 
- John, Doe. "Example Paper 1," presented at Example Conf., Los Angeles, CA, USA, Oct. 8-10, 2020.
- John, Doe. "Example Paper 3," in 23rd Example Conf., London, U.K., Aug. 2015. [Online]. Available: https://example.com/papers/23-5.pdf

# 詳細な説明や追加情報等
# 上記指定項目以外の情報を記したい場合、UsageInfo で指定可能な Web ページを別途用意しない場合に、本項目に追加情報や詳細説明を自由に記述できます。
# マークダウン形式で記入できます。
#AdditionalInfo:
```

次に、記入したYAMLファイルをABCIクラウドストレージにアップロードします。ABCIクラウドストレージにデータセット本体を保存している場合は同じバケットに、そうでない場合はバケットを作成した上でアップロードして下さい。 `my_dataset_info.yaml` は違うファイル名でも問題ありません。

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read my_dataset_info.yaml s3://example-dataset/my_dataset_info.yaml
```


最後に、<datasets@abci.ai> に登録申請を行います。以下のフォーマットでご連絡下さい。複数のABCIグループに所属している場合、データセット本体、あるいは記入したYAMLファイルが保存されたバケットを所有しているABCIグループを記載して下さい。

```text
Subject: データセットの登録(<データセット名>)

申請者の氏名: 
ABCIグループ: 
申請者のメールアドレス: 
アップロードしたYAMLファイルのURL: 
```

登録が完了したデータセットは <https://datasets.abci.ai/> に一覧表示されます。


## 2. 登録情報の更新 {#update}

登録時にアップロードしたYAMLファイルを更新し、<datasets@abci.ai>  に登録情報の更新をご依頼下さい。


## 3. 登録情報の削除 {#delete}

登録時にアップロードしたYAMLファイルを削除し、<datasets@abci.ai>  に登録情報の削除をご依頼下さい。


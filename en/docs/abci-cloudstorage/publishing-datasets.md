
# Publishing Datasets

You can publish your dataset to the public with ABCI Cloud Storage.

Please read [ABCI Agreement/Rules](https://abci.ai/en/how_to_use/) and [ABCI Cloud Storage Terms of Use](https://abci.ai/en/how_to_use/data/Cloudstorage-agreement-en.pdf) through again and check if it is appropriate to publish the dataset. To publish the dataset, follow the procedure below.


## 1. Public Access Setting

Upload your data to ABCI Cloud Storage and allow public access to them, referencing [Access Control (1)](acl.md).

The following example makes `example-dataset` bucket, uploads files in `sensor1` directory and grants public read access to them.

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

Since `--acl public-read` option enables public read access, the data can be accessed by anyone from the outside of ABCI.


## 2. Registration Application

Firstly, prepare a YAML file, which contains basic information about your dataset. Download [the template file](https://datasets.abci.ai/dataset_info_template.yaml) and fill out it, referring to the following.

```yaml
# Your dataset name  *Required
Name: ABC Dataset

# Dataset description with more than 50 characters  *Required
Description: This is a ... [ProjectPage](https://example.com/).

# Related keywords (object detection, vehicle, action recognition, earth observation, etc.)  *Required
# Use a bullet list (block sequence) using "- ", even if there is only one item
Keywords:
  - image processing
  - object detection
  - health

# URL of your page providing more detailed information  *Optional
UsageInfo: https://example-dataset.s3-website.abci.ai/

# Downloadable form
#   EncodingFormat:  XML, CSV, GeoTIFF, etc.  *Optional
#   ContentURL: URLs of data or data list  *Required
Distribution:
  EncodingFormat: DICOM
  ContentURL:  # Use a bullet list (block sequence) using "- ", even if there is only one item
    - https://example-dataset.s3.abci.ai/abc.zip

# Creator
#   Name: Organization name (or individual name)  *Required
#   URL: Organization website (or individual website)  *Optional
#   ContactPoint:
#     Email: Contact point e-mail address  *At least one of Email and URL is required
#     URL: URL of a contact page  *At least one of Email and URL is required
Creator:
  Name: ABC Team
  ContactPoint:
    Email: dataset@example.com
    URL: https://example.com/contact/

# License
#   Name: MIT License, CC-BY-SA 4.0, Custom License, etc.  *Required
#   URL: URL of the license page  *Optional
License:
  Name: Custom License
  URL: https://example.com/dataset/LISENCE.txt

# Version of the dataset  *Optional
Version: "1.1b"

# Creation, update and publication dates of the dataset  *Optional
# Use ISO 8601 format. The time portion is optional
DateCreated: 2020-04-18
DateModified: 2020-04-20T22:30:10+09:00
DatePublished: 2020-04-19

# Identifier, such as DOI  *Optional
#Identifier: https://doi.org/10.1000/a0000

# References  *Optional
# Use a bullet list (block sequence) using "- ", even if there is only one item
Citation:
- John, Doe. "Example Paper 1," presented at Example Conf., Los Angeles, CA, USA, Oct. 8-10, 2020.
- John, Doe. "Example Paper 3," in 23rd Example Conf., London, U.K., Aug. 2015. [Online]. Available: https://example.com/papers/23-5.pdf

# More detailed description or additional information  *Optional
#AdditionalInfo:
```

Next, upload the YAML file to the bucket where your dataset is hosted:

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read my_dataset_info.yaml s3://example-dataset/my_dataset_info.yaml
```
where `my_dataset_info.yaml` can be an arbitrary name.

After that, send an e-mail to <abci-application-ml@aist.go.jp>, following the format below.
If you belong to multiple ABCI groups, please fill in with the group that owns the bucket containing the dataset.

```text
Subject: Dataset Registration Application (<YOUR DATASET NAME>)

Your name:
ABCI group:
Your e-mail address:
URL to the YAML:
```

Once the registration is completed, the dataset will be listed on <https://datasets.abci.ai/>.


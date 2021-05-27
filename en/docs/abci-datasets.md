
# ABCI Datasets

ABCI Datasets is a catalog service of the datasets registered by ABCI users.  The datasets are fully published or shared with limited users.  You can access the service from [ABCI Datasets](https://datasets.abci.ai).

The registration procedure of your dataset is as follows.  Your dataset should be stored on [ABCI Cloud Storage](abci-cloudstorage.md) or other storage services including non-ABCI services.  In the former case, please publish your dataset by referencing [Publishing Datasets](abci-cloudstorage/publishing-datasets.md).

!!! note
    Before registering a dataset to the ABCI Datasets and publishing information of the dataset, please make sure if you have right to do so (e.g., You are an owner of the dataset). 


## 1. Dataset Registration {#registration}

Firstly, prepare a YAML file, which contains basic information about your dataset.  Download [the template file](https://datasets.abci.ai/dataset_info_template.yaml) and fill it out, referring to the following.

```yaml
# Your dataset name  *Required
Name: ABC Dataset

# Dataset description with more than 50 characters  *Required
Description: This is a ... [ProjectPage](https://example.com/).

# Related keywords (object detection, vehicle, action recognition, earth observation, etc.)  *Required
# Use a bullet list (block sequence) using "- ", even if there is only one item.
Keywords:
  - image processing
  - object detection
  - health

# URL of your page providing more detailed information
UsageInfo: https://example-dataset.s3-website.abci.ai/

# Downloadable form
#   EncodingFormat:  XML, CSV, GeoTIFF, etc.
#   ContentURL: URLs of data or data list
Distribution:
  EncodingFormat: DICOM
  ContentURL:  # Use a bullet list (block sequence) using "- ", even if there is only one item.
    - https://example-dataset.s3.abci.ai/abc1.zip
    - https://example-dataset.s3.abci.ai/abc2.zip

# Creator
#   Name: Organization name (or individual name)  *Required
#   URL: Organization website (or individual website)
#   ContactPoint:
#     Email: Contact point e-mail address  * Either Email or URL is required.
#     URL: URL of a contact page  * Either Email or URL is required.
Creator:
  Name: ABC Team
  ContactPoint:
    Email: dataset@example.com
    URL: https://example.com/contact/

# License
#   Name: MIT License, CC-BY-SA 4.0, Custom License, etc.  *Required
#   URL: URL of the license page
License:
  Name: Custom License
  URL: https://example.com/dataset/LISENCE.txt

# Version of the dataset  *Optional
Version: "1.1b"

# Creation, update and publication dates of the dataset
# Use ISO 8601 format. The time portion is optional.
DateCreated: 2020-04-18
DateModified: 2020-04-20T22:30:10+09:00
DatePublished: 2020-04-19

# Identifier, such as DOI
#Identifier: https://doi.org/10.1000/a0000

# References
# Use a bullet list (block sequence) using "- ", even if there is only one item.
Citation:
- John, Doe. "Example Paper 1," presented at Example Conf., Los Angeles, CA, USA, Oct. 8-10, 2020.
- John, Doe. "Example Paper 3," in 23rd Example Conf., London, U.K., Aug. 2015. [Online]. Available: https://example.com/papers/23-5.pdf

# More detailed description or additional information
# This item is for describing additional information which are not shown in the above, and for the case that another web page specified by UsageInfo is not available.
# The description can be written in the Markdown format.
#AdditionalInfo:
```

Next, upload the YAML file to the ABCI Cloud Storage.  When the dataset is stored in the ABCI Cloud Storage, upload it to the same bucket as the dataset.  Otherwise, upload it to the newly created bucket.  Note that the file name of `my_dataset_info.yaml` is just an example.  You can use an arbitrary name.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 cp --acl public-read my_dataset_info.yaml s3://example-dataset/my_dataset_info.yaml
```

Finally, send an e-mail to <M-abci-datasets-ml@aist.go.jp> as a registry application, by using the following format.  If you belong to multiple ABCI groups, please include the ABCI group that owns the bucket where the dataset is stored or the YAML file has been just uploaded.

```text
Subject: Dataset Registration Application (<YOUR DATASET NAME>)

Your name:
ABCI group:
Your e-mail address:
URL to the YAML:
```

Once the registration is accepted, the dataset will be listed on <https://datasets.abci.ai/>.

## 2. Update of Existing Registration

Update the YAML file stored in the bucket of ABCI Cloud Storage, and then send the request to <M-abci-datasets-ml@aist.go.jp>.


## 3. Delete of Existing Registration

Delete the YAML file stored in the bucket of ABCI Cloud Storage, and then send the request to <M-abci-datasets-ml@aist.go.jp>.

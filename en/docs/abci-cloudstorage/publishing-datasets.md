
# Publishing Datasets

You can publish your dataset to the public with ABCI Cloud Storage.

Please read [ABCI Agreement/Rules](https://abci.ai/en/how_to_use/) and [ABCI Cloud Storage Terms of Use](https://abci.ai/en/how_to_use/data/Cloudstorage-agreement-en.pdf) through again and check if it is appropriate to publish the dataset. To publish the dataset, follow the procedure below.


## 1. Setting Public access

Upload your data to ABCI Cloud Storage and allow public access to it referencing [Access Control (1)](acl.md).

The following example makes `example-dataset` bucket, uploads files in `sensor1` directory and grants public read access to it.

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


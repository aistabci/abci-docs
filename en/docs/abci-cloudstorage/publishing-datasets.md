
# Publishing Datasets

You can publish your dataset to the public with ABCI Cloud Storage.

Please read through [ABCI Agreement/Rules](https://abci.ai/en/how_to_use/) and [ABCI Cloud Storage Terms of Use](https://abci.ai/en/how_to_use/data/Cloudstorage-agreement-en.pdf) again and check if it is appropriate to publish the dataset.  The publishing procedure is as follows.


## 1. Public Access Setting

Upload your data to ABCI Cloud Storage and set public access to them, referencing [Access Control (1)](acl.md).

The following example creates `example-dataset` bucket, uploads files in `sensor1` directory and grants public read access to them.

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

Since `--acl public-read` option enables public read access, the data can be accessed with URLs such as "https://example-dataset.s3.abci.ai/sensor1/0001.dat" by anyone from the outside of ABCI.


## 2. Registration Application

Please register your published dataset to the ABCI Datasets by following [this procedure](../abci-datasets.md).
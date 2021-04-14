# Singularity Global Clientの利用

Singularity Global Client (``sregistry``コマンド）はSingularityで使用するイメージを管理するためのソフトウェアです。レジストリからイメージの取得にも利用可能です。


## 利用方法 {#usage}
事前に次の手順を実施することで``sregistry``コマンドをABCIで利用できます。

```
[username@es1 ~]$ module load singularitypro python/3.6/3.6.12 sregistry-cli
```

```
[username@es1 ~]$ sregistry --help
usage: sregistry [-h] [--debug] [--quiet] [--version]
                 {version,backend,shell,images,inspect,get,add,mv,rename,rm,search,build,push,share,pull,labels,delete}
                 ...

Singularity Registry tools

optional arguments:
  -h, --help            show this help message and exit
  --debug               use verbose logging to debug.
  --quiet               suppress additional output.
  --version             suppress additional output.

actions:
  actions for Singularity Registry Global Client

  {version,backend,shell,images,inspect,get,add,mv,rename,rm,search,build,push,share,pull,labels,delete}
                        sregistry actions
    version             show software version
    backend             list, remove, or activate a backend.
    shell               shell into a Python session with a client.
    images              list local images, optionally with query
    inspect             inspect an image in your database
    get                 get an image path from your storage
    add                 add an image to local storage
    mv                  move an image and update database
    rename              rename an image in storage
    rm                  remove an image from the local database
    search              search remote images
    build               build an image using a remote.
    push                push one or more images to a registry
    share               share a remote image
    pull                pull an image from a registry
    labels              query for labels
    delete              delete an image from a remote.
```

利用するレジストリ毎にSingularity Global Clientの設定手順やサポートしているアクションが異なります。
詳しくは[クライアントチュートリアル](https://singularityhub.github.io/sregistry-cli/clients){:target="sregistry-cli_clients"}から利用希望のレジストリに関するページを参照してください。 


## 実行例 {#example}
実行例として、Amazon Elastic Container Registry (ECR) の``myrepos/tensorflow``レポジトリからlatest-gpuタグのイメージを取得し、カレントディレクトリに``mytensorflow.simg``ファイルとして保存する手順を示します。


!!! note
    手順は[AWS CLIの利用](/tips/awscli/){:target="aws_cli"}の[アクセストークンの登録](/tips/awscli/#_2){:target="aws_cli"}手順を完了していることを前提としています。


Singularity Global ClientとAmazon ECR利用に必要なモジュールの読み込みます。
```
[username@es1 ~]$ module load singularitypro python/3.6/3.6.12 sregistry-cli aws-cli
```


Amazon ECRを利用するための設定を行います。``aws ecr describe-repositories``コマンドで``<registryId>``と``<region>``を確認し、それぞれ環境変数に設定します。
```
[username@es1 ~]$ aws ecr describe-repositories --repository-name myrepos/tensorflow
{
    "repositories": [
        {
            "repositoryArn": "arn:aws:ecr:<region>:<registryId>:repository/myrepos/tensorflow",
            "registryId": "<registryId>",
            "repositoryName": "myrepos/tensorflow",
            "repositoryUri": "<registryId>.dkr.ecr.<region>.amazonaws.com/myrepos/tensorflow",
            "createdAt": 1572261978.0,
            "imageTagMutability": "MUTABLE"
        }
    ]
}
[username@es1 ~]$ export SREGISTRY_AWS_ID=<registryId>
[username@es1 ~]$ export SREGISTRY_AWS_ZONE=<region>
```

イメージを取得し、``mytensorflow.simg``ファイルとして保存します。次回以降は、モジュールの読み込みだけでイメージ取得できます。

```
[username@es1 ~]$ sregistry pull --name mytensorflow.simg --no-cache aws://myrepos/tensorflow:latest-gpu
```

* aws:// URIは次のようにタグ付けしたリポジトリ名を指定します。
  ```
aws://<repositoryName>:<imageTag>
  ```

取得したイメージをインタラクティブジョブとして実行します。
```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity shell --nv ./mytensorflow.simg
Singularity: Invoking an interactive shell within container...

Singularity mytensorflow.simg:~> 
```


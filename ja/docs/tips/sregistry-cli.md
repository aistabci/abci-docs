# Singularity Global Clientの利用

Singularity Global Client (``sregistry``コマンド）はSingularityで使用するイメージを管理するためのソフトウェアです。レジストリからイメージの取得にも利用可能です。


## 利用方法
事前に次の手順を実施することで``sregistry``コマンドをABCIで利用できます。

```
[username@es1 ~]$ module load singularity/2.6.1 sregistry-cli/0.2.31
```

* singularityモジュールとsregistryモジュールを読み込みます


## レジストリ毎のチュートリアル
利用するレジストリ毎にSingularity Global Clientの設定手順やサポートしているアクションが異なります。
詳しくは[クライアントチュートリアル](https://singularityhub.github.io/sregistry-cli/clients){:target="sregistry-cli_clients"}から利用希望のレジストリに関するページを参照してください。 


## 実行例
実行例として、Amazon ECRの``myrepos/tensorflow``レポジトリからlatest-gpuタグのイメージを取得し、カレントディレクトリに``mytensorflow.simg``ファイルとして保存する手順を示します。


!!! note
    手順は[AWS CLIの利用](/tips/awscli/){:target="aws_cli"}の[アクセストークンの登録](/tips/awscli/#_2){:target="aws_cli"}手順を完了していることを前提としています。


Singularity Global ClientとAmazon ECR利用に必要なモジュールの読み込みます。
```
[username@es1 ~]$ module load singularity/2.6.1 sregistry-cli/0.2.31 aws-cli/1.16.194
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

イメージを取得し、``mytensorflow.simg``ファイルとして保存します。
次回以降はモジュールの読み込みとumask変更だけで済みます。
```
[username@es1 ~]$ umask
0027
[username@es1 ~]$ umask 0022
[username@es1 ~]$ sregistry pull --name mytensorflow.simg --no-cache aws://myrepos/tensorflow:latest-gpu
[username@es1 ~]$ umask 0027
[username@es1 ~]$ umask
0027
```

* umaskの値で末尾が7の場合、プルしたコンテナの権限が足らずsingularityコマンドでこのイメージを利用するとエラーとなり利用できません。
その為、末尾が7の場合は``sregistry pull``コマンド実行前にその他ユーザが読み込み、実行できるようにumaskの値を設定してください。
* aws:// URIは次のようにタグ付けしたリポジトリ名を指定します。
  ```
aws://<repositoryName>:<imageTag>
  ```

取得したイメージをインタラクティブジョブとして実行します。
```
[username@es1 ~]$ qrsh -g <ABCI利用グループ> -l rt_F=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ singularity shell --nv ./mytensorflow.simg
Singularity: Invoking an interactive shell within container...

Singularity mytensorflow.simg:~> 
```


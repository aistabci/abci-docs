# Amazon ECR からコンテナ取得

SingularityPRO では、Amazon ECR からコンテナイメージを ``singularity`` コマンドを使って簡単にダウンロードすることが可能です。

## 利用方法 {#usage}
SingularityPRO と Amazon ECR の利用に必要なモジュールを読み込みます。

!!! note
    [AWS CLIの利用](/tips/awscli/){:target="aws_cli"}の[アクセストークンの登録手順](/tips/awscli/#_2){:target="aws_cli"}を完了していることを前提としています。

```
[username@es1 ~]$ module load singularitypro aws-cli
```

AWS の認証情報を環境変数に設定します。
```
$ export SINGULARITY_DOCKER_USERNAME=AWS
$ export SINGULARITY_DOCKER_PASSWORD=`aws ecr get-login-password`
```

次に、リポジトリのURLをシェル変数に設定します。
```
[username@es1 ~]$ repositoryUrl=`aws ecr describe-repositories --repository-names TEST/SAMPLE | jq -r '.repositories[0].repositoryUri'`
```

イメージの取得を行います。
```
[username@es1 ~]$ singularity pull docker://${repositoryUrl}
```



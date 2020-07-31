# Download container image from Amazon ECR

The container image in Amazon ECR can be easily obtained with ``singularity`` command of Singularity Pro.

!!! note
    refer to [Singularity Global Client](/tips/sregistry-cli/){:target="sregistry-cli"} when using Singularity 2.6.1.

## Usage {#usage}
load environment module to use Singularity Pro and Amazon ECR.

!!! note
    This procedure assumes that you have completed [Register access token](/tips/awscli/#register-access-token){:target="aws_cli"} in [AWS CLI](/tips/awscli/){:target="aws_cli"}.

```
[username@es1 ~]$ module load singularitypro/3.5　aws-cli/2.0
```

Set AWS authentication infromation in environment variable.
```
$ export SINGULARITY_DOCKER_USERNAME=AWS
$ export SINGULARITY_DOCKER_PASSWORD=`aws ecr get-login-password`
```

Set URL of repository in shell vaiable.
```
[username@es1 ~]$ repositoryUrl=`aws ecr describe-repositories --repository-names TEST/SAMPLE | jq -r '.repositories[0].repositoryUri'`
```

Get container image.
```
[username@es1 ~]$ singularity pull docker://${repositoryUrl}
```



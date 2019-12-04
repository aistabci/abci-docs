# Singularity Global Client

Singularity Global Client (``sregistry`` command) is software for managing images used in Singularity. It can also be used to get images from the registry.


## How to use
The sregistry command can be used with ABCI by performing the following procedure in advance.

```
[username@es1 ~]$ module load singularity/2.6.1 sregistry-cli/0.2.31
```

* Load singularity module and sregistry-cli module


## Client tutorials
Singularity Global Client setting procedure and supported actions differ depending on the registry used.
For details, please refer to the page about the registry you want to use from [client tutorials](https://singularityhub.github.io/sregistry-cli/clients){:target="sregistry-cli_clients"}.


## Use case
As an execution example, the following shows the procedure for pull the latest-gpu tag image from ``myrepos/tensorflow`` repository on the Amazon ECR and saving it as a ``mytensorflow.simg`` file in the current directory.


!!! note
    This procedure assumes that you have completed [Register access token](/tips/awscli/#register-access-token){:target="aws_cli"} in [AWS CLI](/tips/awscli/){:target="aws_cli"}.


Load modules necessary for using Singularity Global Client and Amazon ECR.
```
[username@es1 ~]$ module load singularity/2.6.1 sregistry-cli/0.2.31 aws-cli/1.16.194
```


Set up to use Amazon ECR. Check ``<registryId>`` and ``<region>`` with ``aws ecr describe-repositories`` command and set each to environment variable.
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

Get the image and save it as a ``mytensorflow.simg`` file.
From the next time, you only need to load the module and change the umask.
```
[username@es1 ~]$ umask
0027
[username@es1 ~]$ umask 0022
[username@es1 ~]$ sregistry pull --name mytensorflow.simg --no-cache aws://myrepos/tensorflow:latest-gpu
[username@es1 ~]$ umask 0027
[username@es1 ~]$ umask
0027
```

* If the umask value ends with 7, the pulled container has insufficient privileges, and using this image with the singularity command will result in an error and cannot be used. Therefore, if the end is 7, set the umask value so that other users can read and execute it before executing the ``sregistry pull`` command.
* The URI starting with ``aws://`` specifies the repository name tagged as follows.
  ```
aws://<repositoryName>:<imageTag>
  ```

Execute pulled image as interactive job.
```
[username@es1 ~]$ qrsh -g <ABCI user group> -l rt_F=1
[username@g0001 ~]$ module load singularity/2.6.1
[username@g0001 ~]$ singularity shell --nv ./mytensorflow.simg
Singularity: Invoking an interactive shell within container...

Singularity mytensorflow.simg:~> 
```

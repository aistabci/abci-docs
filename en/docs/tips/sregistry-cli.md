# Singularity Global Client

Singularity Global Client (``sregistry`` command) is software for managing images used in Singularity. It can also be used to get images from the registry.


## Usage {#usage}
The sregistry command can be used with ABCI by performing the following procedure in advance.

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

Singularity Global Client setting procedure and supported actions differ depending on the registry used.
For details, please refer to the page about the registry you want to use from [client tutorials](https://singularityhub.github.io/sregistry-cli/clients){:target="sregistry-cli_clients"}.


## Example {#example}
As an execution example, the following shows the procedure for pull the latest-gpu tag image from ``myrepos/tensorflow`` repository on Amazon Elastic Container Registry (ECR) and saving it as a ``mytensorflow.simg`` file in the current directory.


!!! note
    This procedure assumes that you have completed [Register access token](awscli.md#register-access-token){:target="aws_cli"} in [AWS CLI](awscli.md){:target="aws_cli"}.


Load modules necessary for using Singularity Global Client and Amazon ECR.
```
[username@es1 ~]$ module load singularitypro python/3.6/3.6.12 sregistry-cli aws-cli
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

Get the image and save it as a ``mytensorflow.simg`` file. From the next time, you only need to load the module.
```
[username@es1 ~]$ sregistry pull --name mytensorflow.simg --no-cache aws://myrepos/tensorflow:latest-gpu
```

* The URI starting with ``aws://`` specifies the repository name tagged as follows.
  ```
aws://<repositoryName>:<imageTag>
  ```

Execute pulled image as interactive job.
```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity shell --nv ./mytensorflow.simg
Singularity: Invoking an interactive shell within container...

Singularity mytensorflow.simg:~> 
```

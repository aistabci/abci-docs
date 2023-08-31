# Jupyter Notebook

Jupyter Notebook is a convenient tool that allows you to write code and get the results while creating a document on the browser. This document describes how to start Jupyter Notebook on ABCI and use it from your PC browser.

## Using Pip Install

This part explains how to install and use Jupyter Notebook with pip.

### Install by Pip

First, you need to occupy one compute node, create a Python virtual environment, and install `tensorflow-gpu` and` jupyter` with `pip`.
In this example, `tensorflow-gpu` and` jupyter` are installed into `~/jupyter_env` directory.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load module load gcc/9.3.0 python/3.10 cuda/11.2 cudnn/8.1
[username@g0001 ~]$ python3 -m venv ~/jupyter_env
[username@g0001 ~]$ source ~/jupyter_env/bin/activate
(jupyter_env) [username@g0001 ~]$ python3 -m pip install --upgrade pip
(jupyter_env) [username@g0001 ~]$ python3 -m pip install tensorflow jupyter numpy
```

From the next time on, you only need to load modules and activate `~/jupyter_env` as shown below.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load module load gcc/9.3.0 python/3.10 cuda/11.2 cudnn/8.1
[username@g0001 ~]$ source ~/jupyter_env/bin/activate
```

!!! note
    If you need other modules besides CUDA and cuDNN, you need to load them before starting Jupyter Notebook as well.

### Start Jupyter Notebook

Confirm the host name of the compute node as you will need it later.

```
(jupyter_env) [username@g0001 ~]$ hostname
g0001.abci.local
```

Next, start Jupyter Notebook as follows:

```
(jupyter_env) [username@g0001 ~]$ jupyter notebook --ip=`hostname` --port=8888 --no-browser
:
(snip)
:
[I 20:41:12.082 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 20:41:12.090 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/username/.local/share/jupyter/runtime/nbserver-xxxxxx-open.html
    Or copy and paste one of these URLs:
        http://g0001.abci.local:8888/?token=token_string
     or http://127.0.0.1:8888/?token=token_string
```

### Generate an SSH tunnel

Assume that the local PC port 100022 has been transferred to the interactive node (*es*) according to the procedure in [Login using an SSH Client::General method](../getting-started.md#general-method) in ABCI System User Environment.

Next, create an SSH tunnel that forwards port 8888 on the local PC to port 8888 on the compute node. For "*g0001*", specify the host name of the compute node confirmed when starting Jupyter Notebook.

```
[yourpc ~]$ ssh -N -L 8888:g0001:8888 -l username -i /path/identity_file -p 10022 localhost
```

### Connect to Jupyter Notebook

Open the following URL in a browser. For "*token_string*", specify the one displayed when starting Jupyter Notebook.

```
http://127.0.0.1:8888/?token=token_string
```

To check the operation, when the dashboard screen of Jupyter Notebook is displayed in the browser, create a new Python3 Notebook from the `New` button and execute it as follows.

```
import tensorflow
print(tensorflow.__version__)
print(tensorflow.config.list_physical_devices('GPU'))
```

For how to use Jupyter Notebook, please see the [Jupyter Notebook Documentation](https://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Notebook%20Basics.html).

### Terminate Jupyter Notebook

Jupyter Notebook will be terminated by the following steps:

1. (Local PC) Exit with the `Quit` button on the dashboard screen
2. (Local PC) Press `Control-C` and terminate SSH tunnel connection that was forwarding port 8888
3. (Compute Node) If `jupyter` program is not finished, quit with `Control-C`

## Using Singularity

Instead of installing pip, you can also use a container image with Jupyter Notebook installed. For example, the TensorFlow Docker image provided in [NVIDIA NGC](ngc.md) has Jupyter Notebook installed as well as TensorFlow.

### Build a container image

Get the container image. Here, the Docker image (``nvcr.io/nvidia/tensorflow:19.07-py3``) provided by NGC is used.

```
[username@es1 ~]$ module load singularitypro
[username@es1 ~]$ singularity pull docker://nvcr.io/nvidia/tensorflow:22.07-tf2-py3
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
Getting image source signatures
Copying blob a1d578e9bd9d done
:
(snip)
:
INFO:    Creating SIF file...
```

### Start Jupyter Notebook

First, you need to occupy one compute node. And, confirm the host name of the compute node as you will need it later.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ hostname
g0001.abci.local
```

Next, start Jupyter Notebook in the container image as shown below:

```
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run --nv ./tensorflow_22.07-tf2-py3.sif jupyter notebook --ip=`hostname` --port=8888 --no-browser


================
== TensorFlow ==
================

NVIDIA Release 22.07-tf2 (build 41650896)
TensorFlow Version 2.9.1

Container image Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
Copyright 2017-2022 The TensorFlow Authors.  All rights reserved.

:
(snip)
:
[I 17:34:25.645 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 17:34:25.654 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/username/.local/share/jupyter/runtime/nbserver-xxxxxx-open.html
    Or copy and paste one of these URLs:
        http://hostname:8888/?token=token_string
```

The subsequent steps are the same as for [Using Pip Install](#using-pip-install).

* [Generate an SSH tunnel](#generate-an-ssh-tunnel)
* [Connect to Jupyter Notebook](#connect-to-jupyter-notebook)
* [Terminate Jupyter Notebook](#terminate-jupyter-notebook)

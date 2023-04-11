# Jupyter Notebookの利用 {#jupyter-notebook}

Jupyter Notebookは、コードの記述とその結果の取得を、ブラウザ上でドキュメントを作成しながら行える便利なツールです。ここでは、ABCI上でJupyter Notebookを起動し、手元のPCのブラウザから利用する手順について説明します。

## pipインストールによる利用手順 {#using-pip-install}

ここでは、Jupyter Notebookをpipでインストールして利用する手順を説明します。

### インストール {#install-by-pip}

計算ノードを一台占有し、Python仮想環境を作成し、`pip`で`tensorflow`と`jupyter`をインストールします。
この例では`~/jupyter_env`ディレクトリの中にインストールしています。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.10 cuda/11.2 cudnn/8.1
[username@g0001 ~]$ python3 -m venv ~/jupyter_env
[username@g0001 ~]$ source ~/jupyter_env/bin/activate
(jupyter_env) [username@g0001 ~]$ python3 -m pip install --upgrade pip
(jupyter_env) [username@g0001 ~]$ python3 -m pip install tensorflow jupyter numpy
```

次回以降は、以下のようにモジュールの読み込みと`~/jupyter_env`のアクティベートだけで済みます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load gcc/9.3.0 python/3.10 cuda/11.2 cudnn/8.1
[username@g0001 ~]$ source ~/jupyter_env/bin/activate
```

!!! note
    CUDAやcuDNNの他に必要なモジュールがあれば、同様にJupyter Notebookの起動前にロードしておく必要があります。

### Jupyter Notebookの起動 {#start-jupyter-notebook}

あとで必要となるため、計算ノードのホスト名を確認しておきます。

```
(jupyter_env) [username@g0001 ~]$ hostname
g0001.abci.local
```

続いて、以下のようにJupyter Notebookを起動します。

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

### SSHトンネルの作成 {#generate-an-ssh-tunnel}

ABCIシステム利用環境の[SSHクライアントによるログイン::一般的なログイン方法](../getting-started.md#general-method)の手順に従い、ローカルPCの10022番ポートがインタラクティブノード(*es*)に転送されているものとします。

次に、ローカルPCの8888番ポートを計算ノードの8888番ポートに転送するSSHトンネルを作成します。「*g0001*」は、Jupyter Notebookの起動の際に確認した計算ノードのホスト名を指定してください。

```
[yourpc ~]$ ssh -N -L 8888:g0001:8888 -l username -i /path/identity_file -p 10022 localhost
```

### Jupyter Notebookへの接続 {#connect-to-jupyter-notebook}

ブラウザで以下のURLを開きます。「*token_string*」は、Jupyter Notebookの起動の際に表示されたものを指定してください。

```
http://127.0.0.1:8888/?token=token_string
```

動作確認するには、ブラウザにJupyter Notebookのダッシュボード画面が表示されたら、`New`ボタンから新しいPython3 Notebookを作成し、以下のように実行します。

```
import tensorflow
print(tensorflow.__version__)
print(tensorflow.config.list_physical_devices('GPU'))
```

Jupyter Notebookの使い方は、[Jupyter Notebook Documentation](https://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Notebook%20Basics.html)を参照してください。

### Jupyter Notebookの終了 {#terminate-jupyter-notebook}

以下の手順で終了します。

1. (ローカルPC) ダッシュボード画面の`Quit`ボタンで終了する
2. (ローカルPC) 8888番ポートを転送していたSSHトンネル接続を`Control-C`で終了する
3. (計算ノード) `jupyter`プログラムが終了していない場合は、`Control-C`で終了する

## Singularityを用いた利用手順 {#using-singularity}

pipインストールの代わりに、Jupyter Notebookがインストールされたコンテナイメージを利用することもできます。例えば、[NVIDIA NGC](ngc.md)で提供されているTensorFlowのDockerイメージには、TensorFlowだけではなくJupyter Notebookもインストールされています。

### コンテナイメージの生成 {#build-a-container-image}

コンテナイメージを取得します。ここでは、NGCが提供しているDockerイメージ(``nvcr.io/nvidia/tensorflow:19.07-py3``)を利用します。

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

### Jupyter Notebookの起動 {#start-jupyter-notebook_1}

計算ノードを一台占有します。あとで必要となるため、計算ノードのホスト名を確認しておきます。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ hostname
g0001.abci.local
```

続いて、以下のようにコンテナイメージの中のJupyter Notebookを起動します。

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

以降の手順はpipインストールの場合と共通です。

* [SSHトンネルの作成](#generate-an-ssh-tunnel)
* [Jupyter Notebookへの接続](#connect-to-jupyter-notebook)
* [Jupyter Notebookの終了](#terminate-jupyter-notebook)

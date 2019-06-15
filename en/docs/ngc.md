# Using NGC Image

This page explains how to use an NVIDIA GPU Cloud Image on ABCI.

----

## Using Unlocked Image

Guest users can download unlocked images. Community users can download locked images.
The latter is discussed in the next section.

The following example assumes that you are looking to use Tensorflow.

In your web browser, go to <https://ngc.nvidia.com>, type "tensorflow" in search box which says "Search Containers", then you'll find the Tensorflow icon.

Click the Tensorflow icon, and check the information where you can pull from. It's like this:
```
Pull Command
  docker pull nvcr.io/nvidia/tensorflow:19.05-py2
```

On the interactive node, download and import with "singularity pull"
```
es1$ module load singularity/2.6.1
es1$ singularity pull --name tensorflow.19.05-py2.simg docker://nvcr.io/nvidia/tensorflow:19.05-py2
```

Let's run a sample program.

Start an interactive job which uses one node exclusively.
```
es1$ qrsh -g <YOUR_GROUP> -l rt_F=1
g0001$
```

Run cnn_mnist.py.
It shows accuracy at the end of output.
```
g0001$ module load singularity/2.6.1
g0001$ singularity run --nv tensorflow-19.05-py2.simg python /opt/tensorflow/tensorflow/examples/tutorials/layers/cnn_mnist.py

:

{'loss': 0.10828217, 'global_step': 20000, 'accuracy': 0.9667}
```

Exit your interactive job.
```
g0001$ exit
logout
es1$
```

### With MPI

先ほど同じコンテナイメージを使用します。
Use the same image as 

Get the version of OpenMPI in the image.
```
es1$ singularity exec tensorflow-19.05-py2.simg mpirun --version
mpirun (Open MPI) 3.1.3

Report bugs to http://www.open-mpi.org/community/help/
```

Start an interactive job which uses one node exclusively.
```
es1$ qrsh -g <YOUR_GROUP> -l rt_F=2
g0001$
```

Load singularity module file.
```
$ module load singularity/2.6.1
```

先程確認したOpenMPIのバージョンに近いバージョンのモジュールファイルをロードします。
Load openmpi module file of 
少なくとも2.x.x系列であるか3.x.x系列であるかは合わせる必要があります。
At least, 2.x.x series   3.x.x series  
```
$ module load openmpi/3.1.3
```

Two nodes, 4 GPUs per node, so invoke mpirun like this.
It shows the progress.
```
$ mpirun -np 8 -npernode 4 singularity run --nv tensorflow-19.05-py2.simg python /opt/tensorflow/third_party/horovod/examples/tensorflow_mnist.py

:

INFO:tensorflow:loss = 2.1563044, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1480849, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1783454, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1527252, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1556997, step = 30 (0.152 sec)
INFO:tensorflow:loss = 2.1814752, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.190885, step = 30 (0.153 sec)
INFO:tensorflow:loss = 2.1524186, step = 30 (0.153 sec)
INFO:tensorflow:loss = 1.7863444, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7349662, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.8009219, step = 40 (0.153 sec)
INFO:tensorflow:loss = 1.7753524, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7744101, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7266351, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.7221795, step = 40 (0.154 sec)
INFO:tensorflow:loss = 1.8231221, step = 40 (0.154 sec)

:

```

Exit your interactive job.
```
g0001$ exit
logout
es1$
```

----

## Using Locked Image

This section assumes that you are looking to use Chainer.

At <https://ngc.nvidia.com/>, search "chainer".

Click Chainer icon, and check "Pull Command" information.
```
Pull Command
  Sign in to access the PULL feature of this repository.
```

To get the hidden information, get the Community User account(free).
Click "Sign in", click "Create an Account", and follow the instruction.

登録したメールアドレスにリンクが送られてきますので、そのリンクからログインします。

ログインしたら、
[Generating Your NGC API Key](https://docs.nvidia.com/ngc/ngc-getting-started-guide/index.html#generating-api-key)
のページを参考にAPI KEYを取得してください。
API KEYは後で必要になるので控えますが、パスワードと同じように、失くしたり他人に見せたりしてはいけません。

取得したら、左上の NVIDIA NGC のところをクリックしてトップページに戻り、
再度 chainer を検索します。
見つかったChainerのページを開くと、今度は Pull Command の内容が表示されていますので、
その情報を元に Singularity のイメージを作成します。
最初の環境変数に設定している $ マークのところは、そのまま $ マークを打ってください。何かに読み替えたり展開されることを意味 しているわけではありません。
```
es1$ export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
es1$ export SINGULARITY_DOCKER_PASSWORD=<取得したAPI KEY>
es1$ singularity pull -n chainer.simg docker://nvcr.io<確認した Pull Command の情報を元に続きを入力>
```

インタラクティブジョブでサンプルプログラムを実行してみます。

qrshを使い、GPUが1つ割り当てあられるインタラクティブジョブを開始します。
```
es1$ qrsh -g <YOUR_GROUP> -l rt_G.small=1
g0001$
```

Download a sample program.
(chainerのコンテナイメージのタグが4.0.0b1の場合です)
(the tag of that container image is 4.0.0b1)
```
g0001$ wget https://raw.githubusercontent.com/chainer/chainer/6733f15ffbc2f4a2275c09150fd94fc9ec791f75/examples/mnist/train_mnist.py
```

Run train_mnist.py.
Nomally it shows the information including accuracy.
```
g0001$ module load singularity/2.6.1
g0001$ singularity exec --nv chainer.simg python train_mnist.py -g 0

:

epoch       main/loss   validation/main/loss  main/accuracy  validation/main/accuracy  elapsed_time
1           0.192916    0.103601              0.9418         0.967                     9.05948
2           0.0748937   0.0690557             0.977333       0.9784                    10.951
3           0.0507463   0.0666913             0.983682       0.9804                    12.8735
4           0.0353792   0.0878195             0.988432       0.9748                    14.7425

:

```

Exit your interactive job.
```
g0001$ exit
logout
es1$
```


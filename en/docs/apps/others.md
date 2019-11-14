# Others

## Deep Learning Frameworks

To use Deep Learning Framework on the ABCI System,
user must install it to home or group area.
How to install Deep Learning Framework is following.

### Caffe

To install [Caffe](http://caffe.berkeleyvision.org/),
please follow the instructions below.

```
INSTALL_DIR : install path

[username@g0001 ~]$ cd INSTALL_DIR
[username@g0001 ~]$ module load python/2.7/2.7.15 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
[username@g0001 ~]$ git clone https://github.com/BVLC/caffe
[username@g0001 ~]$ cd caffe
[username@g0001 caffe]$ cp Makefile.config.example Makefile.config
[username@g0001 caffe]$ vi Makefile.config
[username@g0001 caffe]$ make all 2>&1 > log_make-all.txt
[username@g0001 caffe]$ make test 2>&1 > log_make-test.txt
[username@g0001 caffe]$ make runtest 2>&1 > log_make-runtest.txt
[username@g0001 caffe]$ pip install -r python/requirements.txt
[username@g0001 caffe]$ make pycaffe
[username@g0001 caffe]$ make distibute
```

### Caffe2

To install [Caffe2](https://caffe2.ai/),
please follow the instructions below.

```
INSTALL_DIR : install path

[username@g0001 ~]$ export PREFIX=INSTALL_DIR
[username@g0001 ~]$ module load python/3.6.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5 nccl/2.1/2.1.15-1
[username@g0001 ~]$ git clone https://github.com/gflags/gflags.git
[username@g0001 ~]$ mkdir gflags/build && cd gflags/build
[username@g0001 build]$ cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' -DCMAKE_INSTALL_PREFIX=$PREFIX .. 
[username@g0001 build]$ make -j 8 2>&1 | tee make.log 
[username@g0001 build]$ make install 2>&1 | tee make_install.log
[username@g0001 build]$ cd

[username@g0001 ~]$ git clone https://github.com/google/glog
[username@g0001 ~]$ cd glog
[username@g0001 glog]$ sh autogen.sh
[username@g0001 glog]$ CXXFLAGS="-fPIC -I$PREFIX/include" LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX 2>&1 | tee configure.log
[username@g0001 glog]$ make -j 8 2>&1 | tee make.log
[username@g0001 glog]$ make install 2>&1 | tee make_install.log
[username@g0001 glog]$ cd

[username@g0001 ~]$ pip3 install future graphviz hypothesis jupyter matplotlib numpy protobuf pydot python-nvd3 pyyaml requests scikit-image scipy six --prefix=$PREFIX
[username@g0001 ~]$ export CUDNN_INCLUDE_DIR=$CUDNN_HOME/include
[username@g0001 ~]$ export CUDNN_LIBRARY=$CUDNN_HOME/lib64/libcudnn.so.7.0.5
[username@g0001 ~]$ export NCCL_INCLUDE_DIR=$NCCL_HOME/include
[username@g0001 ~]$ export NCCL_LIBRARY=$NCCL_HOME/lib/libnccl.so.2.1.15
[username@g0001 ~]$ git clone --recursive https://github.com/pytorch/pytorch.git
[username@g0001 ~]$ cd pytorch && git submodule update --init
[username@g0001 pytorch]$ mkdir build && cd build
[username@g0001 build]$ cmake3 -DPYTHON_INCLUDE_DIR=/apps/python/3.6.5/include/python3.6m -DPYTHON_EXECUTABLE=/apps/python/3.6.5/bin/python3 -DPYTHON_LIBRARY=/apps/python/3.6.5/lib -DNCCL_INCLUDE_DIR=$NCCL_INCLUDE_DIR -DNCCL_LIBRARY=$NCCL_LIBRARY -DUSE_OPENCV=ON -DCMAKE_INSTALL_PREFIX=INSTALL_DIR .
[username@g0001 build]$ make install 2>&1 | tee make_install.log
```

### TensorFlow

To install [TensorFlow](https://www.tensorflow.org/),
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu
```

### Theano

Please refer to following page for how to install [Theano](http://deeplearning.net/software/theano/).

[How to install Theano](http://deeplearning.net/software/theano/)

### Torch

To install [Torch](http://torch.ch/),
please follow the instructions below.

```
INSTALL_DIR : install path
INSTALL_DIR_OPENBLAS : install path (OpenBLAS)

[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 ~]$ git clone https://github.com/xianyi/OpenBLAS.git
[username@g0001 ~]$ make TARGET=HASWELL NO_AFFINITY=1 USE_OPENMP=1 > log_make_20180621-00.txt 2>&1
[username@g0001 ~]$ make install PREFIX=INSTALL_DIR_OPENBLAS > log_make_inst_20180621-00.txt  2>&1
[username@g0001 ~]$ export LD_LIBRARY_PATH=INSTALL_DIR_OPENBLAS/lib:$LD_LIBRARY_PATH
[username@g0001 ~]$ git clone https://github.com/torch/distro.git ./torch --recursive
[username@g0001 ~]$ export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
[username@g0001 ~]$ TORCH_LUA_VERSION=LUA51 PREFIX=INSTALL_DIR ./install.sh
```

### PyTorch

To install [PyTorch](https://pytorch.org/),
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.1/9.1.85.3
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install torch torchvision
```

### CNTK

Please refer to following page for how to install [CNTK](https://www.microsoft.com/en-us/cognitive-toolkit/).

[How to install CNTK](https://www.microsoft.com/en-us/cognitive-toolkit/)

### MXNet

To install [MXNet](https://mxnet.apache.org/),
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.2/9.2.148.1
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install mxnet-cu92
```

### Chainer

To install [Chainer](https://chainer.org/),
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install cupy-cuda91 chainer
```

### Keras

To install [Keras](https://keras.io/) with TensorFlow backend,
please follow the instructions below.

```
NEW_VENV : python virtual environment or path to be installed

[username@g0001 ~]$ module load python/3.6/3.6.5 cuda/9.0/9.0.176.4 cudnn/7.2/7.2.1
[username@g0001 ~]$ export LD_LIBRARY_PATH=$CUDA_HOME/extras/CUPTI/lib64:$LD_LIBRARY_PATH
[username@g0001 ~]$ python3 -m venv NEW_VENV
[username@g0001 ~]$ source NEW_VENV/bin/activate
(NEW_VENV) [username@g0001 ~]$ pip3 install tensorflow-gpu
(NEW_VENV) [username@g0001 ~]$ pip3 install keras
```

More details can be found in [Keras](https://keras.io/).

## Big Data Analytics Frameworks

### Hadoop

Hadoop is available for ABCI System. When you use this framework, you need to set up user environment by `module` command.

Setting commands for Hadoop are the following.

```
$ module load openjdk/1.8.0.131
$ module load hadoop/2.9.1
```

Example) Running Hadoop on compute nodes.

```
[username@es1 ~]$ qrsh -l rt_F=1
[username@g0001~]$ module load openjdk/1.8.0.131
[username@g0001~]$ module load hadoop/2.9.1
[username@g0001~]$ mkdir input
[username@g0001~]$ cp /apps/hadoop/2.9.1/etc/hadoop/*.xml input
[username@g0001~]$ hadoop jar /apps/hadoop/2.9.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.1.jar grep input output 'dfs[a-z.]+'
[username@g0001~]$ cat output/part-r-00000
1       dfsadmin
```

# Others

## Deep Learning Frameworks

To use Deep Learning Framework on the ABCI System,
user must install it to home or group area.
How to install Deep Learning Framework is following.

### Caffe

To install [Caffe](http://caffe.berkeleyvision.org/), please follow the instructions below.

```
INSTALL_DIR : install path

[username@g0001 ~]$ cd $INSTALL_DIR
[username@g0001 ~]$ module load cuda/10.2/10.2.89 cudnn/7.6/7.6.5
[username@g0001 ~]$ git clone https://github.com/BVLC/caffe
[username@g0001 ~]$ cd caffe
[username@g0001 caffe]$ cp Makefile.config.example Makefile.config
[username@g0001 caffe]$ vi Makefile.config
(snip)
[username@g0001 caffe]$ diff -u Makefile.config.example Makefile.config
--- Makefile.config.example     2021-04-14 14:54:32.000000000 +0900
+++ Makefile.config     2021-04-14 15:00:58.000000000 +0900
@@ -2,7 +2,7 @@
 # Contributions simplifying and improving our build system are welcome!

 # cuDNN acceleration switch (uncomment to build with cuDNN).
-# USE_CUDNN := 1
+USE_CUDNN := 1

 # CPU-only switch (uncomment to build without GPU support).
 # CPU_ONLY := 1
@@ -27,7 +27,7 @@
 # CUSTOM_CXX := g++

 # CUDA directory contains bin/ and lib/ directories that we need.
-CUDA_DIR := /usr/local/cuda
+CUDA_DIR := $(CUDA_HOME)
 # On Ubuntu 14.04, if cuda tools are installed via
 # "sudo apt-get install nvidia-cuda-toolkit" then use this instead:
 # CUDA_DIR := /usr
@@ -36,9 +36,7 @@
 # For CUDA < 6.0, comment the *_50 through *_61 lines for compatibility.
 # For CUDA < 8.0, comment the *_60 and *_61 lines for compatibility.
 # For CUDA >= 9.0, comment the *_20 and *_21 lines for compatibility.
-CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
-               -gencode arch=compute_20,code=sm_21 \
-               -gencode arch=compute_30,code=sm_30 \
+CUDA_ARCH := -gencode arch=compute_30,code=sm_30 \
                -gencode arch=compute_35,code=sm_35 \
                -gencode arch=compute_50,code=sm_50 \
                -gencode arch=compute_52,code=sm_52 \
@@ -50,7 +48,7 @@
 # atlas for ATLAS (default)
 # mkl for MKL
 # open for OpenBlas
-BLAS := atlas
+BLAS := open
 # Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
 # Leave commented to accept the defaults for your choice of BLAS
 # (which should work)!
@@ -69,7 +67,7 @@
 # NOTE: this is required only if you will compile the python interface.
 # We need to be able to find Python.h and numpy/arrayobject.h.
 PYTHON_INCLUDE := /usr/include/python2.7 \
-               /usr/lib/python2.7/dist-packages/numpy/core/include
+               /usr/lib64/python2.7/site-packages/numpy/core/include
 # Anaconda Python distribution is quite popular. Include path:
 # Verify anaconda location, sometimes it's in root.
 # ANACONDA_HOME := $(HOME)/anaconda
@@ -83,7 +81,7 @@
 #                 /usr/lib/python3.5/dist-packages/numpy/core/include

 # We need to be able to find libpythonX.X.so or .dylib.
-PYTHON_LIB := /usr/lib
+PYTHON_LIB := /usr/lib64
 # PYTHON_LIB := $(ANACONDA_HOME)/lib

 # Homebrew installs numpy in a non standard path (keg only)
[username@g0001 caffe]$ make all 2>&1 | tee make_all.log
[username@g0001 caffe]$ make test 2>&1 | tee make_test.log
[username@g0001 caffe]$ make runtest 2>&1 | tee make_runtest.log
[username@g0001 caffe]$ virtualenv $INSTALL_DIR
[username@g0001 caffe]$ source $INSTALL_DIR/bin/activate
(caffe) [username@g0001 caffe]$ pip install -r python/requirements.txt
(caffe) [username@g0001 caffe]$ make pycaffe 2>&1 | tee make_pycaffe.log
(caffe) [username@g0001 caffe]$ make distibute 2>&1 | tee make_distribute.log
```

### Theano

Please refer to following page for how to install [Theano](http://deeplearning.net/software/theano/).

[How to install Theano](http://deeplearning.net/software/theano/)

### Torch

To install [Torch](http://torch.ch/), please follow the instructions below.

```
INSTALL_DIR : install path

[username@g0001 ~]$ mkdir $INSTALL_DIR
[username@g0001 ~]$ git clone https://github.com/torch/distro.git ~/torch --recursive
[username@g0001 ~]$ cd ~/torch
[username@g0001 torch]$ module load cuda/9.2/9.2.148.1
[username@g0001 torch]$ export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
[username@g0001 torch]$ ./install.sh 2>&1 | tee install.sh.log
```

### CNTK

Please refer to following page for how to install [CNTK](https://www.microsoft.com/en-us/cognitive-toolkit/).

[How to install CNTK](https://www.microsoft.com/en-us/cognitive-toolkit/)

## Big Data Analytics Frameworks

### Hadoop

Hadoop is available for ABCI System. When you use this framework, you need to set up user environment by `module` command.

Setting commands for Hadoop are the following.

```
$ module load openjdk/1.8.0.242
$ module load hadoop/3.3
```

Example) Running Hadoop on compute nodes.

```
[username@es1 ~]$ qrsh -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load openjdk/1.8.0.242
[username@g0001 ~]$ module load hadoop/3.3
[username@g0001 ~]$ mkdir input
[username@g0001 ~]$ cp $HADOOP_HOME/etc/hadoop/*.xml input
[username@g0001 ~]$ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar grep input output 'dfs[a-z.]+'
[username@g0001 ~]$ cat output/part-r-00000
1       dfsadmin
```

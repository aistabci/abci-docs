# Appendix1. How To Install Software

## Open MPI

### Open MPI 2.1.3 (for GCC)

#### Normal

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=/apps/openmpi/2.1.3/gcc4.8.5 \
  --enable-mpi-thread-multiple \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=/apps/openmpi/2.1.3/gcc4.8.5_cuda8.0.61.2 \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.2

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.0/9.0.176.2
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.0.176.2 \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.1.85.3 \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.88.1

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.2.88.1
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.2.88.1 \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
```

### Open MPI 3.1.0(for GCC)

#### Normal

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=/apps/openmpi/3.1.0/gcc4.8.5 \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> /apps/openmpi/3.1.0/gcc4.8.5/etc/openmpi-mca-params.conf
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=/apps/openmpi/3.1.0/gcc4.8.5_cuda8.0.61.2 \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> /apps/openmpi/3.1.0/gcc4.8.5_cuda8.0.61.2/etc/openmpi-mca-params.conf
```

#### CUDA 9.0.176.2

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.0/9.0.176.2
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.0.176.2 \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> /apps/openmpi/3.1.0/gcc4.8.5_cuda9.0.176.2/etc/openmpi-mca-params.conf
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.1.85.3 \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> /apps/openmpi/3.1.0/gcc4.8.5_cuda9.1.85.3/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.88.1

```
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.2/9.2.88.1
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.2.88.1 \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> /apps/openmpi/3.1.0/gcc4.8.5_cuda9.2.88.1/etc/openmpi-mca-params.conf
```

### MVAPICH2(for GCC)

#### Normal

```
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ ./configure --prefix=/app/mvapich2/2.3rc2/gcc4.8.5 2>&1 | tee configure.log
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/8.0/8.0.61.2
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda8.0.61.2\
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.2

```
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.0/9.0.176.2
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.0.176.2\
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.1/9.1.85.3
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.1.85.3\
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.88.1

```
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.2/9.2.88.1
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.2.88.1\
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

## Python

### Python 2.7.15

```
[username@g0001 ~]$ wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tar.xz
[username@g0001 ~]$ tar Jxf Python-2.7.15.tar.xz
[username@g0001 ~]$ cd Python-2.7.15
[username@g0001 Python-2.7.15]$ CXX=g++ ./configure --prefix=/apps/python/2.7.15 --enable-optimizations --enable-shared --with-ensurepip  --enable-unicode=ucs4 --with-dbmliborder=gdbm:ndbm:bdb --with-system-expat --with-system-ffi > configure.log 2>&1
[username@g0001 Python-2.7.15]$ make -j8 > make.log  2>&1
[username@g0001 Python-2.7.15]$ make test > make_test.log  2>&1
[username@g0001 Python-2.7.15]$ su
[root@g0001 Python-2.7.15]# make install 2>&1 | tee make_install.log
[root@g0001 Python-2.7.15]# export PATH=/apps/python/2.7.15/bin:$PATH
[root@g0001 Python-2.7.15]# pip install virtualenv
```

## R

### R 3.5.0

```
[username@g0001 ~]$ wget https://cran.ism.ac.jp/src/base/R-3/R-3.5.0.tar.gz
[username@g0001 ~]$ tar zxf R-3.5.0.tar.gz
[username@g0001 ~]$ cd R-3.5.0
[username@g0001 R-3.5.0]$ ./configure --prefix=/apps/R/3.5.0 2>&1 | tee configure.log
[username@g0001 R-3.5.0]$ make 2>&1 | tee make.log
[username@g0001 R-3.5.0]$ make check 2>&1 | tee make_check.log
[username@g0001 R-3.5.0]$ su
[username@g0001 R-3.5.0]# make install 2>&1 | tee make_install.log
```

## AI frameworks

### Caffe 1.0.0

```
[username@g0001 ~]$ module load load python/2.7.14 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
[username@g0001 ~]$ git clone https://github.com/BVLC/caffe
[username@g0001 ~]$ cd caffe
[username@g0001 caffe$ cp Makefile.config.example Makefile.config
[username@g0001 caffe]$ vi Makefile.config
[username@g0001 caffe]$ make all 2>&1 > log_make-all.txt
[username@g0001 caffe]$ make test 2>&1 > log_make-test.txt
[username@g0001 caffe]$ make runtest 2>&1 > log_make-runtest.txt
[username@g0001 caffe]$ pip install -r python/requirement.txt
[username@g0001 caffe]$ make pycaffe
[username@g0001 caffe]$ make distibute
```

### Caffe2
```
[username@g0001 ~]$ module load python/3.6.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5 nccl/2.1/2.1.15-1
[username@g0001 ~]$ git clone https://github.com/gflags/gflags.git
[username@g0001 ~]$ mkdir gflags/build && cd gflags/build
[username@g0001 ~]$ cmake3 -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS='-fPIC' -DCMAKE_INSTALL_PREFIX=$PREFIX ..
[username@g0001 ~]$ make -j 8 2>&1 | tee make.log
[username@g0001 ~]$ make install 2>&1 | tee make_install.log
[username@g0001 ~]$ cd

[username@g0001 ~]$ git clone https://github.com/google/glog
[username@g0001 ~]$ cd glog
[username@g0001 ~]$ sh autogen.sh
[username@g0001 ~]$ CXXFLAGS="-fPIC -I$PREFIX/include" LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX 2>&1 | tee configure.log
[username@g0001 ~]$ make -j 8 2>&1 | tee make.log
[username@g0001 ~]$ make install 2>&1 | tee make_install.log

[username@g0001 ~]$ pip3 install future graphviz hypothesis jupyter matplotlib numpy protobuf pydot python-nvd3 pyyaml requests scikit-image scipy six --prefix=$PREFIX
[username@g0001 ~]$ export CUDNN_INCLUDE_DIR=$CUDNN_HOME/include
[username@g0001 ~]$ export CUDNN_LIBRARY=$CUDNN_HOME/lib64/libcudnn.so.7.0.5
[username@g0001 ~]$ export NCCL_INCLUDE_DIR=$NCCL_HOME/include
[username@g0001 ~]$ export NCCL_LIBRARY=$NCCL_HOME/lib/libnccl.so.2.1.15
[username@g0001 ~]$ git clone --recursive https://github.com/pytorch/pytorch.git
[username@g0001 ~]$ cd pytorch && git submodule update --init
[username@g0001 pytorch]$ mkdir build && cd build
[username@g0001 buil]$ cmake3 -DPYTHON_INCLUDE_DIR=/apps/python/3.6.5/include/python3.6m -DPYTHON_EXECUTABLE=/apps/python/3.6.5/bin/python3 -DPYTHON_LIBRARY=/apps/python/3.6.5/lib -DNCCL_INCLUDE_DIR=$NCCL_INCLUDE_DIR -DNCCL_LIBRARY=$NCCL_LIBRARY -DUSE_OPENCV=ON -DCMAKE_INSTALL_PREFIX=$PREFIX .
[username@g0001 build]$ make install 2>&1 | tee make_install.log
```

### Tensorflow 1.8.0

```
[username@g0001 ~]$ module load cuda/9.0/9.0.176.2 cudnn/7.0/7.0.5
[username@g0001 ~]$ pip3 install tensorflow==1.8.0 --prefix=/apps/tensorflow/1.8.0/python3.6.5_cuda9.0.176.2_cudnn7.0.5
```

### Torch
```
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 ~]$ git clone https://github.com/xianyi/OpenBLAS.git
[username@g0001 ~]$ make TARGET=HASWELL NO_AFFINITY=1 USE_OPENMP=1 > log_make_20180621-00.txt 2>&1
[username@g0001 ~]$ make install PREFIX=/apps/torch/20180626_0219027/openblas > log_make_inst_20180621-00.txt  2>&1
[username@g0001 ~]$ export LD_LIBRARY_PATH=/apps/torch/20180626_0219027/openblas/lib:$LD_LIBRARY_PATH
[username@g0001 ~]$ git clone https://github.com/torch/distro.git ./torch --recursive
[username@g0001 ~]$ export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
[username@g0001 ~]$ TORCH_LUA_VERSION=LUA51 PREFIX=/apps/torch/20180621_0219027/cuda9.1.85.3/torch ./install.sh

```

### PyTorch
```
[username@g0001 ~]$ module load python/3.5.5 cuda/9.1/9.1.85.3
[username@g0001 ~]$ pip3 install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp35-cp35m-linux_x86_64.whl
[username@g0001 ~]$ pip3 install torchvision

```
### MXNet
```
[username@g0001 ~]$ git clone --recursive https://github.com/apache/incubator-mxnet.git
[username@g0001 ~]$ cd incubator-mxnet
[username@g0001 ~]$ module load mxnet
[username@g0001 ~]$ make -j 4 USE_BLAS=atlas USE_CUDA=1 USE_CUDA_PATH=${CUDA_PATH} USE_CUDNN=1 USE_NCCL=1 USE_NCCL_PATH=/apps/nccl/2.1.15-1/cuda9.1 USE_DIST_KVSTORE=1
```

### Chainer
```
[username@g0001 ~]$ module python/3.5.5 cuda/9.1/9.1.85.3 cudnn/7.0/7.0.5
[username@g0001 ~]$ pip3 install --prefix=/apps/chainer/4.1.0/python3.5.5_cuda9.1.85.3_cudnn7.0.5  numpy==1.13
[username@g0001 ~]$ pip3 install --prefix=/apps/chainer/4.1.0/python3.5.5_cuda9.1.85.3_cudnn7.0.5 cupy-cuda91
[username@g0001 ~]$ pip3 install --prefix=/apps/chainer/4.1.0/python3.5.5_cuda9.1.85.3_cudnn7.0.5 chainer
```

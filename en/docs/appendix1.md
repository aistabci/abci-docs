# Appendix1. Configuration of Installed Software

!!! note
    This section only includes a part of the configurations of the installed software.

## Open MPI

### Open MPI 2.1.3 (for GCC)

#### Normal

```
INSTALL_DIR=/apps/openmpi/2.1.3/gcc4.8.5

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 8.0.61.2

```
INSTALL_DIR=/apps/openmpi/2.1.3/gcc4.8.5_cuda8.0.61.2

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.0.176.2

```
INSTALL_DIR=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.0.176.2

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.0/9.0.176.2
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.1.85.3

```
INSTALL_DIR=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.1.85.3

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.88.1

```
INSTALL_DIR=/apps/openmpi/2.1.3/gcc4.8.5_cuda9.2.88.1

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.3.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.3
[username@g0001 ~]$ module load cuda/9.2.88.1
[username@g0001 openmpi-2.1.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.3]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-2.1.3]$ su
[root@g0001 openmpi-2.1.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.0(for GCC)

#### Normal

```
INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf

```

#### CUDA 8.0.61.2

```
INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5_cuda8.0.61.2

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5_cuda8.0.61.2
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.0.176.2

```
INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.0.176.2

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.0/9.0.176.2
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.1.85.3

```
INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.1.85.3

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.88.1

```
INSTALL_DIR=/apps/openmpi/3.1.0/gcc4.8.5_cuda9.2.88.1

[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-3.1.0.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.0
[username@g0001 ~]$ module load cuda/9.2/9.2.88.1
[username@g0001 openmpi-3.1.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --cuda=$CUDA_HOME
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.0]$ make -j8 > make.log 2>&1
[username@g0001 openmpi-3.1.0]$ su
[root@g0001 openmpi-3.1.0]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.0]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### MVAPICH2(for GCC)

#### Normal

```
INSTALL_DIR=/app/mvapich2/2.3rc2/gcc4.8.5

[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 mvapich2-2.3rc2]$ make -j8  > make.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ make check -j8 > make_check.log 2>&1
[username@g0001 mvapich2-2.3rc2]$ su
[root@g0001 mvapich2-2.3rc2]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
INSTALL_DIR=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda8.0.61.2

[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/8.0/8.0.61.2
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=$INSTALL_DIR \
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
INSTALL_DIR=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.0.176.2

[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.0/9.0.176.2
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=$INSTALL_DIR \
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
INSTALL_DIR=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.1.85.3

[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.1/9.1.85.3
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=$INSTALL_DIR \
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
INSTALL_DIR=/apps/mvapich2/2.3rc2/gcc4.8.5_cuda9.2.88.1

[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3rc2.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3rc2
[username@g0001 mvapich2-2.3rc2]$ module load cuda/9.2/9.2.88.1
[username@g0001 mvapich2-2.3rc2]$ ./configiure \
  --prefix=INSTALL_DIR \
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
INSTALL_DIR=/apps/python/2.7.15

[username@g0001 ~]$ wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tar.xz
[username@g0001 ~]$ tar Jxf Python-2.7.15.tar.xz
[username@g0001 ~]$ cd Python-2.7.15
[username@g0001 Python-2.7.15]$ CXX=g++ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-optimizations \
  --enable-shared \
  --with-ensurepip  \
  --enable-unicode=ucs4 \
  --with-dbmliborder=gdbm:ndbm:bdb \
  --with-system-expat \
  --with-system-ffi \
  > configure.log 2>&1
[username@g0001 Python-2.7.15]$ make -j8 > make.log  2>&1
[username@g0001 Python-2.7.15]$ make test > make_test.log  2>&1
[username@g0001 Python-2.7.15]$ su
[root@g0001 Python-2.7.15]# make install 2>&1 | tee make_install.log
[root@g0001 Python-2.7.15]# export PATH=$INSTALL_DIR/bin:$PATH
[root@g0001 Python-2.7.15]# pip install virtualenv
```

## R

### R 3.5.0

```
INSTALL_DIR=/apps/R/3.5.0

[username@g0001 ~]$ wget https://cran.ism.ac.jp/src/base/R-3/R-3.5.0.tar.gz
[username@g0001 ~]$ tar zxf R-3.5.0.tar.gz
[username@g0001 ~]$ cd R-3.5.0
[username@g0001 R-3.5.0]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 R-3.5.0]$ make 2>&1 | tee make.log
[username@g0001 R-3.5.0]$ make check 2>&1 | tee make_check.log
[username@g0001 R-3.5.0]$ su
[username@g0001 R-3.5.0]# make install 2>&1 | tee make_install.log
```

## NVIDIA Collective Communications Library (NCCL) 

### NCCL 1.3.5

#### CUDA 8.0.61.2

```
INSTALL_DIR=/apps/nccl/1.3.5/cuda8.0

[username@es1 ~]$ git clone https://github.com/NVIDIA/nccl.git
[username@es1 ~]$ cd nccl
[username@es1 nccl]$ module load cuda/8.0/8.0.61.2
[username@es1 nccl]$ make CUDA_HOME=$CUDA_HOME test
[username@es1 nccl]$ su
[root@es1 nccl]# mkdir -p $INSTALL_DIR
[root@es1 nccl]# make PREFIX=$INSTALL_DIR install
```

#### CUDA 9.0.176.2

```
INSTALL_DIR=/apps/nccl/1.3.5/cuda9.0

[username@es1 ~]$ git clone https://github.com/NVIDIA/nccl.git
[username@es1 ~]$ cd nccl
[username@es1 nccl]$ module load cuda/9.0/9.0.176.2
[username@es1 nccl]$ make CUDA_HOME=$CUDA_HOME test
[username@es1 nccl]$ su
[root@es1 nccl]# mkdir -p $INSTALL_DIR
[root@es1 nccl]# make PREFIX=$INSTALL_DIR install
```

#### CUDA 9.1.85.3

```
INSTALL_DIR=/apps/nccl/1.3.5/cuda9.1

[username@es1 ~]$ git clone https://github.com/NVIDIA/nccl.git
[username@es1 ~]$ cd nccl
[username@es1 nccl]$ module load cuda/9.1/9.1.85.3
[username@es1 nccl]$ make CUDA_HOME=$CUDA_HOME test
[username@es1 nccl]$ su
[root@es1 nccl]# mkdir -p $INSTALL_DIR
[root@es1 nccl]# make PREFIX=$INSTALL_DIR install
```

#### CUDA 9.2.88.1

```
INSTALL_DIR=/apps/nccl/1.3.5/cuda9.2

[username@es1 ~]$ git clone https://github.com/NVIDIA/nccl.git
[username@es1 ~]$ cd nccl
[username@es1 nccl]$ module load cuda/9.2/9.2.88.1
[username@es1 nccl]$ make CUDA_HOME=$CUDA_HOME test
[username@es1 nccl]$ su
[root@es1 nccl]# mkdir -p $INSTALL_DIR
[root@es1 nccl]# make PREFIX=$INSTALL_DIR install
```

## Deep Learning Framework

[Deep Learning Framework](11.md#111-deep-learning-framework) needs to be installed by user's privilege.

## Big Data

### Hadoop

```
INSTALL_DIR=/apps/hadoop/2.9.1

[username@g0001 ~]$ wget https://archive.apache.org/dist/hadoop/common/hadoop-2.9.1/hadoop-2.9.1.tar.gz
[username@g0001 ~]$ su
[root@g0001 ~]# mkdir -p $INSTALL_DIR
[root@g0001 ~]# tar xzf hadoop-2.9.1.tar.gz -C $INSTALL_DIR --strip=1
[root@g0001 ~]# chown -R root:root /apps/hadoop/2.9.1
```

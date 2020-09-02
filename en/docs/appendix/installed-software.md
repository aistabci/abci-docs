# Appendix. Configuration of Installed Software

!!! note
    This section only includes a part of the configurations of the installed software.

## Open MPI

### Open MPI 2.1.6 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda8.0.61.2
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda9.0.176.4
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/9.0/9.0.176.4
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda9.1.85.3
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar zxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda9.2.148.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda10.0.130.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda10.1.243
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/gcc4.8.5_cuda10.2.89
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-mpi-thread-multiple \
  --with-cuda=$CUDA_HOME \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-2.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.6 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/gcc4.8.5
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/gcc4.8.5_cuda9.2.148.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda9.2.148.1_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/gcc4.8.5_cuda10.0.130.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.0.130.1_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/gcc4.8.5_cuda10.1.243
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.1.243_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/gcc4.8.5_cuda10.2.89
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.2.89_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-3.1.6]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 4.0.3 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/gcc4.8.5
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-4.0.3]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/gcc4.8.5_cuda9.2.148.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda9.2.148.1_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-4.0.3]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/gcc4.8.5_cuda10.0.130.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.0.130.1_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-4.0.3]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/gcc4.8.5_cuda10.1.243
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.1.243_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-4.0.3]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/gcc4.8.5_cuda10.2.89
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-orterun-prefix-by-default \
  --with-cuda=$CUDA_HOME \
  --with-ucx=/apps/ucx/1.7.0/gcc4.8.5_cuda10.2.89_gdrcopy2.0 \
  --with-sge \
  2>&1 | tee configure.log 2>&1
[username@g0001 openmpi-4.0.3]$ make -j8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install 2>&1 | tee make_install.log
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 2.1.6 (for PGI 17.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi17.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/17.10
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi17.10_cuda9.2.148.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/17.10
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.6 (for PGI17.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/pgi17.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/17.10
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-3.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 4.0.3 (for PGI17.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/pgi17.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load pgi/17.10
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-4.0.3]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 2.1.6 (for PGI 18.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi18.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi18.10_cuda9.2.148.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi18.10_cuda10.0.130.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi18.10_cuda10.1.243
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi18.10_cuda10.2.89
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.6 (for PGI 18.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/pgi18.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-3.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 4.0.3 (for PGI 18.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/pgi18.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load pgi/18.10
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-4.0.3]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 2.1.6 (for PGI 19.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi19.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/19.10
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi19.10_cuda10.1.243
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/19.10
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/2.1.6/pgi19.10_cuda10.2.89
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-2.1.6.tar.gz
[username@g0001 ~]$ module load pgi/19.10
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ cd openmpi-2.1.6
[username@g0001 openmpi-2.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-mpi-thread-multiple \
    --with-cuda=$CUDA_HOME \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-2.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-2.1.6]$ su
[root@g0001 openmpi-2.1.6]# make install
[root@g0001 openmpi-2.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.6 (for PGI 19.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/pgi19.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/19.10
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-3.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 4.0.3 (for PGI 19.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/pgi19.10
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load pgi/19.10
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-4.0.3]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 3.1.6 (for PGI 20.1)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/3.1.6/pgi20.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-3.1.6.tar.bz2
[username@g0001 ~]$ module load pgi/20.1
[username@g0001 ~]$ cd openmpi-3.1.6
[username@g0001 openmpi-3.1.6]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-3.1.6]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-3.1.6]$ su
[root@g0001 openmpi-3.1.6]# make install
[root@g0001 openmpi-3.1.6]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

### Open MPI 4.0.3 (for PGI 20.1)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/openmpi/4.0.3/pgi20.1
[username@g0001 ~]$ wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ tar jxf openmpi-4.0.3.tar.bz2
[username@g0001 ~]$ module load pgi/20.1
[username@g0001 ~]$ cd openmpi-4.0.3
[username@g0001 openmpi-4.0.3]$ CPP=cpp ./configure \
    --prefix=$INSTALL_DIR \
    --enable-orterun-prefix-by-default \
    --with-sge \
    2>&1 | tee configure.log
[username@g0001 openmpi-4.0.3]$ make -j 8 2>&1 | tee make.log
[username@g0001 openmpi-4.0.3]$ su
[root@g0001 openmpi-4.0.3]# make install
[root@g0001 openmpi-4.0.3]# echo "btl_openib_allow_ib = 1" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
[root@g0001 openmpi-4.0.3]# echo "btl_openib_warn_default_gid_prefix = 0" >> $INSTALL_DIR/etc/openmpi-mca-params.conf
```

## MVAPICH2

### MVAPICH2 2.3.3 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda8.0.61.2
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/8.0/8.0.61.2
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda9.0.176.4
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.0/9.0.176.4
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda9.1.85.3
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.1/9.1.85.3
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda9.2.148.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.2/9.2.148.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda10.0.130.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.0/10.0.130.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda10.1.243
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.1/10.1.243
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/gcc4.8.5_cuda10.2.89
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.2/10.2.89
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log 2>&1
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.3 (for PGI 17.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi17.10
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/17.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.88.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi17.10_cuda9.2.88.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/17.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.2/9.2.88.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi17.10_cuda9.2.148.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/17.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.2/9.2.148.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.3 (for PGI 18.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.88.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10_cuda9.2.88.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.2/9.2.88.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10_cuda9.2.148.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/9.2/9.2.148.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10_cuda10.0.130.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.0/10.0.130.1
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10_cuda10.1.243
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.1/10.1.243
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi18.10_cuda10.2.89
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.2/10.2.89
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.3 (for PGI 19.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi19.10
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/19.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi19.10_cuda10.1.243
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/19.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.1/10.1.243
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi19.10_cuda10.2.89
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/19.10
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ module load cuda/10.2/10.2.89
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-cuda \
  --with-cuda=$CUDA_HOME \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.3 (for PGI 20.1)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.3/pgi20.1
[username@g0001 ~]$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.3.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.3
[username@g0001 mvapich2-2.3.3]$ module load pgi/20.1
[username@g0001 mvapich2-2.3.3]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.3]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.3]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.3]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.3]$ export CPP=cpp
[username@g0001 mvapich2-2.3.3]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.3]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.3]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.3]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.3]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.3]$ su
[root@g0001 mvapich2-2.3.3]# make install 2>&1 | tee make_install.log
```


### MVAPICH2 2.3.4 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.4/gcc4.8.5
[username@g0001 ~]$ wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.4
[username@g0001 mvapich2-2.3.4]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.4]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.4]$ su
[root@g0001 mvapich2-2.3.4]# make install 2>&1 | tee -a make_install.log
```

### MVAPICH2 2.3.4 (for PGI 17.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.4/pgi17.10
[username@g0001 ~]$ wget wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.4
[username@g0001 mvapich2-2.3.4]$ module load pgi/17.10
[username@g0001 mvapich2-2.3.4]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.4]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.4]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.4]$ export CPP=cpp
[username@g0001 mvapich2-2.3.4]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.4]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.4]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.4]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.4]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.4]$ su
[root@g0001 mvapich2-2.3.4]# make install 2>&1 | tee make_install.log
```


### MVAPICH2 2.3.4 (for PGI 18.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.4/pgi18.10
[username@g0001 ~]$ wget wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.4
[username@g0001 mvapich2-2.3.4]$ module load pgi/18.10
[username@g0001 mvapich2-2.3.4]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.4]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.4]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.4]$ export CPP=cpp
[username@g0001 mvapich2-2.3.4]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.4]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.4]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.4]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.4]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.4]$ su
[root@g0001 mvapich2-2.3.4]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.4 (for PGI 19.10)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.4/pgi19.10
[username@g0001 ~]$ wget wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.4
[username@g0001 mvapich2-2.3.4]$ module load pgi/19.10
[username@g0001 mvapich2-2.3.4]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.4]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.4]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.4]$ export CPP=cpp
[username@g0001 mvapich2-2.3.4]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.4]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.4]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.4]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.4]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.4]$ su
[root@g0001 mvapich2-2.3.4]# make install 2>&1 | tee make_install.log
```

### MVAPICH2 2.3.4 (for PGI 20.1)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/mvapich2/2.3.4/pgi20.1
[username@g0001 ~]$ wget wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ tar zxf mvapich2-2.3.4.tar.gz
[username@g0001 ~]$ cd mvapich2-2.3.4
[username@g0001 mvapich2-2.3.4]$ module load pgi/20.1
[username@g0001 mvapich2-2.3.4]$ export FC=$PGI/bin/pgf90
[username@g0001 mvapich2-2.3.4]$ export FCFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export F77=$PGI/bin/pgfortran
[username@g0001 mvapich2-2.3.4]$ export FFLAGS=-noswitcherror
[username@g0001 mvapich2-2.3.4]$ export CXXFLAGS="-noswitcherror -fPIC -g"
[username@g0001 mvapich2-2.3.4]$ export CPP=cpp
[username@g0001 mvapich2-2.3.4]$ export CPPFLAGS=-g
[username@g0001 mvapich2-2.3.4]$ export LDFLAGS="-lstdc++"
[username@g0001 mvapich2-2.3.4]$ export MPICHLIB_CFLAGS=-O0
[username@g0001 mvapich2-2.3.4]$ ./configure \
  --prefix=$INSTALL_DIR \
  2>&1 | tee configure.log
[username@g0001 mvapich2-2.3.4]$ make -j8 2>&1 | tee make.log
[username@g0001 mvapich2-2.3.4]$ su
[root@g0001 mvapich2-2.3.4]# make install 2>&1 | tee make_install.log
```

## Python

### Python 2.7.15

```
[username@g0001 ~]$ INSTALL_DIR=/apps/python/2.7.15
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

### Python 3.7.6

```
[username@g0001 ~]$ INSTALL_DIR=/apps/python/3.7.6
[username@g0001 ~]$ wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
[username@g0001 ~]$ tar zxf Python-3.7.6.tgz
[username@g0001 ~]$ cd Python-3.7.6
[username@g0001 Python-3.7.6]$ module load gcc/7.4.0
[username@g0001 Python-3.7.6]$ ./configure \
    --prefix=$INSTALL_DIR \
    --enable-optimizations \
    --enable-shared \
    --disable-ipv6 2>&1 | tee configure.log
[username@g0001 Python-3.7.6]$ make -j8 2>&1 | tee make.log
[username@g0001 Python-3.7.6]$ make test 2>&1 | tee make_test.log
[username@g0001 Python-3.7.6]$ su
[root@g0001 Python-3.7.6]# module load gcc/7.4.0
[root@g0001 Python-3.7.6]# make install 2>&1 | tee make_install.log
```

### Python 3.8.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/python/3.8.2
[username@g0001 ~]$ wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz
[username@g0001 ~]$ tar zxf Python-3.8.2.tgz
[username@g0001 ~]$ cd Python-3.8.2
[username@g0001 Python-3.8.2]$ module load gcc/7.4.0
[username@g0001 Python-3.8.2]$ ./configure \
    --prefix=$INSTALL_DIR \
    --enable-optimizations \
    --enable-shared \
    --disable-ipv6 2>&1 | tee configure.log
[username@g0001 Python-3.8.2]$ make -j8 2>&1 | tee make.log
[username@g0001 Python-3.8.2]$ make test 2>&1 | tee make_test.log
[username@g0001 Python-3.8.2]$ su
[root@g0001 Python-3.8.2]# module load gcc/7.4.0
[root@g0001 Python-3.8.2]# make install 2>&1 | tee make_install.log
```

## R

### R 3.5.0

```
[username@g0001 ~]$ INSTALL_DIR=/apps/R/3.5.0
[username@g0001 ~]$ wget https://cran.ism.ac.jp/src/base/R-3/R-3.5.0.tar.gz
[username@g0001 ~]$ tar zxf R-3.5.0.tar.gz
[username@g0001 ~]$ cd R-3.5.0
[username@g0001 R-3.5.0]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 R-3.5.0]$ make 2>&1 | tee make.log
[username@g0001 R-3.5.0]$ make check 2>&1 | tee make_check.log
[username@g0001 R-3.5.0]$ su
[username@g0001 R-3.5.0]# make install 2>&1 | tee make_install.log
```

### R 3.6.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/R/3.6.3
[username@g0001 ~]$ wget https://cran.ism.ac.jp/src/base/R-3/R-3.6.3.tar.gz
[username@g0001 ~]$ tar zxf R-3.6.3.tar.gz
[username@g0001 ~]$ cd R-3.6.3
[username@g0001 R-3.6.3]$ ./configure --prefix=$INSTALL_DIR 2>&1 | tee configure.log
[username@g0001 R-3.6.3]$ make 2>&1 | tee make.log
[username@g0001 R-3.6.3]$ make check 2>&1 | tee make_check.log
[username@g0001 R-3.6.3]$ su
[username@g0001 R-3.6.3]# make install 2>&1 | tee make_install.log
```

## GDRcopy

### GDRcopy 2.0 (for GCC 4.8.5)

#### Kernel Module

```
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0/packages
[username@g0001 packages]$ module load gcc/4.8.5
[username@g0001 packages]$ module load cuda/10.2/10.2.89
[username@g0001 packages]$ CUDA=$CUDA_HOME ./build-rpm-packages.sh 2>&1 | tee build-rpm-packages.log
[username@g0001 packages]$ su
[root@g0001 packages]# rpm -ivh gdrcopy-kmod-2.0-3.x86_64.rpm
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda8.0.61.2
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/8.0/8.0.61.2
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda9.0.176.4
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/9.0/9.0.176.4
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda9.1.85.3
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/9.1/9.1.85.3
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda9.2.148.1
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/9.2/9.2.148.1
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda10.0.130.1
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/10.0/10.0.130.1
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda10.1.243
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/10.1/10.1.243
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc4.8.5_cuda10.2.89
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/4.8.5
[username@g0001 gdrcopy-2.0]$ module load cuda/10.2/10.2.89
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

### GDRcopy 2.0 (for GCC 7.4.0)

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda8.0.61.2
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/8.0/8.0.61.2
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda9.0.176.4
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/9.0/9.0.176.4
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda9.1.85.3
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/9.1/9.1.85.3
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda9.2.148.1
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/9.2/9.2.148.1
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda10.0.130.1
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/10.0/10.0.130.1
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda10.1.243
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/10.1/10.1.243
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/gdrcopy/2.0/gcc7.4.0_cuda10.2.89
[username@g0001 ~]$ wget https://github.com/NVIDIA/gdrcopy/archive/v2.0.tar.gz
[username@g0001 ~]$ tar zxf v2.0.tar.gz
[username@g0001 ~]$ cd gdrcopy-2.0
[username@g0001 gdrcopy-2.0]$ module load gcc/7.4.0
[username@g0001 gdrcopy-2.0]$ module load cuda/10.2/10.2.89
[username@g0001 gdrcopy-2.0]$ export CC=gcc
[username@g0001 gdrcopy-2.0]$ make PREFIX=$INSTALL_DIR CUDA=$CUDA_HOME all 2>&1 | tee make_all.log
[username@g0001 gdrcopy-2.0]$ su
[root@g0001 gdrcopy-2.0]# make PREFIX=$PREFIX CUDA=$CUDA_HOME install 2>&1 | tee make_install.log
```

## UCX

### UCX 1.7.0 (for GCC 4.8.5)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda8.0.61.2_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda9.0.176.4_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/9.0/9.0.176.4
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda9.1.85.3_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda9.2.148.1_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda10.0.130.1_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda10.1.243_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc4.8.5_cuda10.2.89_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

### UCX 1.7.0 (for GCC 7.4.0)

#### w/o CUDA

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 8.0.61.2

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda8.0.61.2_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/8.0/8.0.61.2
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.0.176.4

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda9.0.176.4_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/9.0/9.0.176.4
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.1.85.3

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda9.1.85.3_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/9.1/9.1.85.3
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 9.2.148.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda9.2.148.1_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/9.2/9.2.148.1
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.0.130.1

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda10.0.130.1_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.1.243

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda10.1.243_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/10.1/10.1.243
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

#### CUDA 10.2.89

```
[username@g0001 ~]$ INSTALL_DIR=/apps/ucx/1.7.0/gcc7.4.0_cuda10.2.89_gdrcopy2.0
[username@g0001 ~]$ wget https://github.com/openucx/ucx/releases/download/v1.7.0/ucx-1.7.0.tar.gz
[username@g0001 ~]$ tar zxf ucx-1.7.0.tar.gz
[username@g0001 ~]$ module load gcc/7.4.0
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ module load gdrcopy/2.0
[username@g0001 ~]$ cd ucx-1.7.0
[username@g0001 ucx-1.7.0]$ ./configure \
  --prefix=$INSTALL_DIR \
  --with-cuda=$CUDA_HOME \
  --with-gdrcopy=$GDRCOPY_PATH \
  --enable-optimizations \
  --disable-logging \
  --disable-debug \
  --disable-assertions \
  --enable-mt \
  --disable-params-check \
  2>&1 | tee configure.log 2>&1
[username@g0001 ucx-1.7.0]$ make -j8 2>&1 | tee make.log
[username@g0001 ucx-1.7.0]$ su
[root@g0001 ucx-1.7.0]# make install 2>&1 | tee make_install.log
```

## NVIDIA Collective Communications Library (NCCL)

### NCCL 1.3.5

#### CUDA 8.0.61.2

```
[username@es1 ~]$ INSTALL_DIR=/apps/nccl/1.3.5/cuda8.0
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
[username@es1 ~]$ INSTALL_DIR=/apps/nccl/1.3.5/cuda9.0
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
[username@es1 ~]$ INSTALL_DIR=/apps/nccl/1.3.5/cuda9.1
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
[username@es1 ~]$ INSTALL_DIR=/apps/nccl/1.3.5/cuda9.2
[username@es1 ~]$ git clone https://github.com/NVIDIA/nccl.git
[username@es1 ~]$ cd nccl
[username@es1 nccl]$ module load cuda/9.2/9.2.88.1
[username@es1 nccl]$ make CUDA_HOME=$CUDA_HOME test
[username@es1 nccl]$ su
[root@es1 nccl]# mkdir -p $INSTALL_DIR
[root@es1 nccl]# make PREFIX=$INSTALL_DIR install
```

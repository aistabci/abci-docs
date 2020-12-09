# Spackによるソフトウェア管理

[Spack](https://spack.io/)とは、Lawrence Livermore National Laboratoryで開発されている高性能計算向けのソフトウェアパッケージ管理システムです。
Spackを使うことにより、同一ソフトウェアをバージョン、設定、コンパイラを様々に変えて複数ビルドし、切り替えて使うことができます。
ABCI上でSpackを使うことにより、ABCIが標準でサポートしていないソフトウェアを簡単にインストールすることができるようになります。

!!! note
    動作確認は2020年12月3日に行っており、その時の最新のバージョンである0.16.0を使用しています。

!!! caution
    Spackは、独自のパッケージフォーマットでパッケージングされたHPC向けのソフトウェアを導入するためのツールであり、Linuxディストリビューションが提供するパッケージとの互換性はありません。そのためyum,aptなどのコマンドの代替として利用することはできません。

!!! caution
    Spackは、Spackをインストールしたディレクトリ以下にソフトウェアをインストールします。
    多数のソフトウェアを導入すると多くの容量を消費しますので、使わなくなったソフトウェアはアンインストールするなどの管理をしてください。


## Spack環境設定 {#setup-spack}

### インストール {#install}

GitHubからcloneし、使用するバージョンをcheckoutすることで、Spackをインストールすることができます。

```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.16.0
```

以降はターミナル上で、Spackを有効化するスクリプトを読み込めば使えます。

```
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

### ABCI用設定 {#configuration-for-abci}

#### コンパイラの登録 {#adding-compilers}

Spackで使用するコンパイラをSpackに登録します。
登録されたコンパイラは`spack compiler list`コマンドで確認できます。

GCC 4.4.7と4.8.5は標準のパス（/usr/bin）に入っているため、Spackが自動的に見つけます。

```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@4.8.5  gcc@4.4.7
```

ABCIが提供しているGCC 4.8.5並びに7.4.0の設定ファイル(compilers.yaml)を配置しておりますので、以下のようにユーザ環境にコピーすることでコンパイラを利用することが可能です。

```
[username@es1 ~]$ cp /bb/apps/spack/compilers.yaml ${HOME}/.spack/linux/
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5
```

compilers.yaml
```
compilers:
- compiler:
    paths:
      cc: /apps/gcc/7.4.0/bin/gcc
      cxx: /apps/gcc/7.4.0/bin/g++
      f77: /apps/gcc/7.4.0/bin/gfortran
      fc: /apps/gcc/7.4.0/bin/gfortran
    operating_system: centos7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths:
      - /apps/gcc/7.4.0/lib64
    flags: {}
    spec: gcc@7.4.0
(snip)
```


#### ABCIソフトウェアの登録 {#adding-abci-software}

Spackはソフトウェアの依存関係を解決して、依存するソフトウェアも自動的にインストールします。
標準の設定では、CUDAやOpenMPIなど、ABCIが既に提供しているソフトウェアも利用者ごとにインストールされます。
ディスクスペースの浪費となりますので、ABCIが提供するソフトウェアは、Spackから*参照する*ように設定することをお勧めします。

Spackが参照するソフトウェアの設定は`$HOME/.spack/linux/packages.yaml`に定義します。
ABCIで提供するCUDA、OpenMPI、Mvapich2、cmakeの設定を記載した設定ファイル(packages.yaml)をユーザ環境にコピーすることでABCIのソフトウェアを*参照する*ことができます。

```
[username@es1 ~]$ cp /bb/apps/spack/packages.yaml ${HOME}/.spack/linux/
```

packages.yaml
```
packages:
  cuda:
    buildable: false
    externals:
    - spec: cuda@8.0.61.2%gcc@4.8.5
      modules:
      - cuda/8.0/8.0.61.2
    - spec: cuda@8.0.61.2%gcc@7.4.0
      modules:
      - cuda/8.0/8.0.61.2
(snip)
```

例えば、`spec: cuda@8.0.61.2%gcc@4.8.5`,`modules:`,`- cuda/8.0/8.0.61.2`では、SpackでCUDAのバージョン8.0.61.2のインストールを実行すると、実際にはインストールはせずに、Environment Modulesの`cuda/8.0/8.0.61.2`を使用することを意味します。
CUDAセクションでのみ記述されている`buildable: False`は、Spackにここで指定しているバージョン以外のCUDAをインストールさせないことを意味しています。
ABCIが提供していないバージョンのCUDAをSpackでインストールしたい場合は、この記述を削除してください。

`packages.yaml`ファイルの設定の詳細は[公式ドキュメント](https://spack.readthedocs.io/en/latest/build_settings.html)を参照ください。


## Spack 基本操作 {#basic-of-spack}

Spackの基本操作についてまとめます。
詳細は[公式ドキュメント](https://spack.readthedocs.io/en/latest/basic_usage.html)を参照ください。

### コンパイラ関連 {#compiler-operations}

Spackに登録されているコンパイラ一覧は`compiler list`サブコマンドで確認できます。
```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5
```

特定コンパイラの詳細情報を確認するには、`compiler info`サブコマンドを実行します。
```
[username@es1 ~]$ spack compiler info gcc@4.8.5
gcc@4.8.5:
	paths:
		cc = /usr/bin/gcc
		cxx = /usr/bin/g++
		f77 = /usr/bin/gfortran
		fc = /usr/bin/gfortran
	Extra rpaths:
		/usr/lib/gcc/x86_64-redhat-linux/4.8.5
	modules  = []
	operating system  = centos7
```

### ソフトウェア管理関連 {#software-management-operations}

#### インストール {#install}

OpenMPIのSpack標準バージョンは、以下の通りにインストールできます。
`schedulers=sge`と`fabrics=auto`の意味は[導入事例](#cuda-aware-openmpi)を参照ください。
```
[username@es1 ~]$ spack install openmpi schedulers=sge fabrics=auto
```

バージョンを指定する場合は、`@`で指定します。
```
[username@es1 ~]$ spack install openmpi@3.1.4 schedulers=sge fabrics=auto
```

コンパイラを指定する場合は`%`で指定します。
以下の例では、コンパイラのバージョンも指定しています。
```
[username@es1 ~]$ spack install openmpi@3.1.4 %gcc@7.4.0 schedulers=sge fabrics=auto
```

#### アンインストール {#uninstall}

`uninstall`サブコマンドで、インストール済みのソフトウェアをアンインストールできます。
インストール同様に、バージョンを指定してアンインストールできます。
```
[username@es1 ~]$ spack uninstall openmpi
```

ソフトウェアのハッシュを指定してアンインストールすることもできます。
`/`に続いてハッシュを指定します。
ハッシュは[情報確認](#information)に示す通り、`find`サブコマンドで取得できます。
```
[username@es1 ~]$ spack uninstall /ffwtsvk
```

インストールした全てのソフトウェアを一括して削除するには以下の通りに実行します。
```
[username@es1 ~]$ spack uninstall --all
```

#### 情報確認 {#information}

Spackでインストールできるソフトウェア一覧は、`list`サブコマンドで確認できます。
```
[username@es1 ~]$ spack list
abinit
abyss
(snip)
```

キーワードを指定することで、キーワードを名前の一部に含むソフトウェアのみを表示できます。
以下では`mpi`をキーワードとして指定しています。
```
[username@es1 ~]$ spack list mpi
==> 21 packages.
compiz       mpifileutils  mpix-launch-swift  r-rmpi        vampirtrace
fujitsu-mpi  mpilander     openmpi            rempi
intel-mpi    mpileaks      pbmpi              spectrum-mpi
mpibash      mpip          pnmpi              sst-dumpi
mpich        mpir          py-mpi4py          umpire
```

インストールしたソフトウェア一覧は`find`サブコマンドで確認できます。
```
[username@es1 ~]$ spack find
==> 49 installed packages
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
autoconf@2.69    gdbm@1.18.1          libxml2@2.9.9  readline@8.0
(snip)
```

インストールしたソフトウェアのハッシュ、依存関係は`find`サブコマンドに`-dl`オプションを指定することで確認できます。
```
[username@es1 ~]$ spack find -dl openmpi
-- linux-centos7-skylake_avx512 / gcc@7.4.0 ---------------------
6pxjftg openmpi@3.1.1
ahftjey     hwloc@1.11.11
vf52amo         cuda@9.0.176.4
edtwt6g         libpciaccess@0.16
bt74u75         libxml2@2.9.10
qazxaa4             libiconv@1.16
jb22kvg             xz@5.2.5
pkmj6e7             zlib@1.2.11
2dq7ece         numactl@2.0.14
```

特定のソフトウェアの詳細情報を確認するには、`info`サブコマンドを使用します。
```
[username@es1 ~]$ spack info openmpi
AutotoolsPackage:   openmpi

Description:
    An open source Message Passing Interface implementation. The Open MPI
    Project is an open source Message Passing Interface implementation that
(snip)
```

特定ソフトウェアの、インストール可能なバージョン一覧は`versions`サブコマンドで確認できます。
```
[username@es1 ~]$ spack versions openmpi
==> Safe versions (already checksummed):
  develop  3.0.3  2.1.1   1.10.5  1.8.5  1.7.2  1.5.5  1.4.2  1.2.8  1.1.5
  4.0.1    3.0.2  2.1.0   1.10.4  1.8.4  1.7.1  1.5.4  1.4.1  1.2.7  1.1.4
  4.0.0    3.0.1  2.0.4   1.10.3  1.8.3  1.7    1.5.3  1.4    1.2.6  1.1.3
  3.1.4    3.0.0  2.0.3   1.10.2  1.8.2  1.6.5  1.5.2  1.3.4  1.2.5  1.1.2
  3.1.3    2.1.6  2.0.2   1.10.1  1.8.1  1.6.4  1.5.1  1.3.3  1.2.4  1.1.1
  3.1.2    2.1.5  2.0.1   1.10.0  1.8    1.6.3  1.5    1.3.2  1.2.3  1.1
  3.1.1    2.1.4  2.0.0   1.8.8   1.7.5  1.6.2  1.4.5  1.3.1  1.2.2  1.0.2
  3.1.0    2.1.3  1.10.7  1.8.7   1.7.4  1.6.1  1.4.4  1.3    1.2.1  1.0.1
  3.0.4    2.1.2  1.10.6  1.8.6   1.7.3  1.6    1.4.3  1.2.9  1.2    1.0
```


### ソフトウェア利用方法 {#use-of-installed-software}

Spackでインストールしたソフトウェアは`spack load`コマンドで使用可能です。
ABCIが提供するモジュール同様に、ロードして使用できます。
```
[username@es1 ~]$ spack load xxxxx
```



## ソフトウェア導入事例 {#example-software-installation}

### CUDA-aware OpenMPI {#cuda-aware-openmpi}

ABCIでは、CUDA-aware OpenMPIをモジュールで提供していますが、全てのコンパイラ、CUDA、OpenMPIの組み合わせで提供しているわけではありません（[参考](https://docs.abci.ai/ja/08/#open-mpi)）。
使用したい組み合わせがモジュール提供されていない場合は、Spackでインストールするのが簡単です。

#### インストール方法 {#how-to-install}

CUDA 10.1.243を使用するOpenMPI 3.1.1をインストールする場合の例です。
GPUを搭載する計算ノード上で作業を行います。
```
[username@g0001 ~]$ spack install cuda@10.1.243
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@10.1.243
[username@g0001 ~]$ spack find --paths openmpi@3.1.1
==> 1 installed package
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
openmpi@3.1.1  ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v
[username@g0001 ~]$ echo "btl_openib_warn_default_gid_prefix = 0" >> ${SPACK_ROOT}/opt/spack/linux-centos7-haswell/gcc-4.8.5/openmpi-3.1.1-4mmghhfuk5n7my7g3ko2zwzlo4wmoc5v/etc/openmpi-mca-params.conf
```
1行目では、ABCIが提供するCUDAを使用するよう、CUDAのバージョン`10.1.243`をインストールします。
2行目では、[このページ](../appendix/installed-software.md#open-mpi)と同様の設定で、OpenMPIをインストールしています。
インストールオプションの意味は以下の通りです。

- `+cuda`: CUDAを有効にしてビルドします。
- `schedulers=sge`: MPIプロセスを起動する手段を指定しています。ABCIではSGE互換のUGEを使っているため、sgeを指定します。
- `fabrics=auto`: 通信ライブラリを選択します。この例では自動判別としています。
- `^cuda@10.1.243`: 使用するCUDAを指定します。`^`は依存するソフトウェアを指定するときに使います。

4行目では実行時の警告を消すため、設定ファイルを編集しています（任意）。
そのため、3行目でOpenMPIがインストールされたパスを確認しています。

Spackでは、同一ソフトウェアを異なる設定で複数インストールし、管理することができます。
ここでは、CUDA 9.0.176.4を使用するOpenMPI 3.1.1を追加インストールします。
```
[username@g0001 ~]$ spack install cuda@9.0.176.4
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge fabrics=auto ^cuda@9.0.176.4
```

#### 使い方 {#how-to-use}

「CUDA 10.1.243を使用するOpenMPI 3.1.1」を使う場合の利用方法を説明します。

`spack load`実行時にOpenMPIのバージョン並びにCUDAの依存関係を指定することで、特定のバージョンを利用することが可能です。
```
[username@es1 ~]$ spack load openmpi@3.1.1 ^cuda@10.1.243
```

計算ノード上でプログラムをコンパイルする場合は、SpackでインストールしたOpenMPIを利用してからMPIを起動します。
```
[username@g0001 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
[username@g0001 ~]$ spack load openmpi@3.1.1 ^cuda@10.1.243
[username@g0001 ~]$ mpicc ...
```

ジョブスクリプトでは、以下のように使用します。
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load openmpi@3.1.1 ^cuda@10.1.243

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIOPTS="-n ${NUM_PROCS} -map-by ppr:${NUM_GPUS_PER_NODE}:node -x PATH -x LD_LIBRARY_PATH"
mpiexec ${MPIOPTS} YOUR_PROGRAM
```

不要になった場合は、バージョン並びに依存関係を指定してアンインストールします。
```
[username@es1 ~]$ spack uninstall openmpi@3.1.1 ^cuda@10.1.243
```


### CUDA-aware MVAPICH2 {#cuda-aware-mvapich2}

ABCIが提供するMVAPICH2モジュールはCUDA対応していません。
CUDA-aware MVAPICH2を使用する場合は、以下を参考にSpackでインストールしてください。

GPUを搭載する計算ノード上で作業を行います。
[OpenMPIと同様](#cuda-aware-openmpi)に、使用するCUDAをインストールしたのちに、CUDAオプション（`+cuda`）、通信ライブラリ（`fabrics=mrail`）、およびCUDAの依存関係（`^cuda@10.1.243`）を指定してMVAPICH2をインストールします。
```
[username@g0001 ~]$ spack install cuda@10.1.243
[username@g0001 ~]$ spack install mvapich2@2.3.2 +cuda fabrics=mrail ^cuda@10.1.243
```

使い方もOpenMPIと同様に、インストールしたMVAPICH2をロードして使います。
以下にジョブスクリプト例を示します。
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mvapich2@2.3.2 ^cuda@10.1.243

NUM_NODES=${NHOSTS}
NUM_GPUS_PER_NODE=4
NUM_PROCS=$(expr ${NUM_NODES} \* ${NUM_GPUS_PER_NODE})
MPIE_ARGS="-genv MV2_USE_CUDA=1"
MPIOPTS="${MPIE_ARGS} -np ${NUM_PROCS} -ppn ${NUM_GPUS_PER_NODE}"

mpiexec ${MPIOPTS} YOUR_PROGRAM
```


### MPIFileUtils {#mpifileutils}

[MPIFileUtils](https://hpc.github.io/mpifileutils/)は、MPIを用いたファイル転送ツールです。
複数のライブラリに依存するため、マニュアルでインストールするのは面倒ですが、Spackを用いると簡単にインストールできます。

以下の例では、ABCIがモジュール提供するOpenMPI 2.1.6を使用して、MPIFileUtilsをインストールします。
該当するOpenMPIをインストールした後で（1行目）、それへの依存を指定してMPIFileUtilsをインストールします（2行目）。
```
[username@es1 ~]$ spack install openmpi@2.1.6
[username@es1 ~]$ spack install mpifileutils ^openmpi@2.1.6
```

使うときには、MPIFileUtilsのモジュールをロードします。
MPIFileUtilsのモジュールをロードすると、`dbcast`などのプログラムへのパスがセットされます。
以下にジョブスクリプト例を示します。

```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source ${HOME}/spack/share/spack/setup-env.sh
spack load mpifileutils@0.10.1 ^openmpi@2.1.6

NPPN=5
NMPIPROC=$(( $NHOSTS * $NPPN ))
SRC_FILE=name_of_file
DST_FILE=name_of_file

mpiexec -n ${NMPIPROC} -map-by ppr:${NPPN}:node dbcast $SRC_FILE $DST_FILE
```

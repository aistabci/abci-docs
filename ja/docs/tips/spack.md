# Spackによるソフトウェア管理

[Spack](https://spack.io/)とは、Lawrence Livermore National Laboratoryで開発されている高性能計算向けのソフトウェアパッケージ管理システムです。
Spackを使うことにより、同一ソフトウェアをバージョン、設定、コンパイラを様々に変えて複数ビルドし、切り替えて使うことができます。
ABCI上でSpackを使うことにより、ABCIが標準でサポートしていないソフトウェアを簡単にインストールすることができるようになります。

!!! note
    動作確認は2019年12月13日に行っており、その時の最新のバージョンである0.13.2を使用しています。

!!! caution
    Spackは利用者のホーム領域やグループ領域にソフトウェアをインストールします。
    多数のソフトウェアを導入すると多くの容量を消費しますので、使わなくなったソフトウェアはアンインストールするなどの管理をしてください。


## Spack環境設定 {#setup}

### インストール {#setup_install}

GitHubからCloneし、使用するバージョンをcheckoutすればインストール完了です。

```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd spack
[username@es1 ~/spack]$ git checkout v0.13.2
```

以降はターミナル上で、Spackを有効化するスクリプトを読み込めば使えます。

```
[username@es1 ~]$ source spack/share/spack/setup-env.sh
```

### ABCI用設定 {#setup_configure}

#### コンパイラの登録 {#setup_configure_compiler}

Spackで使用するコンパイラをSpackに登録します。
`spack compiler find`コマンドで登録できます。

ここでは、ABCIが提供するGCC 4.4.7と4.8.5、7.4.0を登録します。
GCC 4.4.7と4.8.5は標準のパス（/usr/bin）に入っているため、Spackが自動的に見つけます。
GCC 7.4.0はモジュールとして提供されているため、`module load`する必要があります。

```
[username@es1 ~]$ module load gcc/7.4.0
[username@es1 ~]$ spack compiler find
[username@es1 ~]$ module purge
```

Spackに登録されているコンパイラを表示するコマンド`spack compiler list`を実行し、以下のように出力されれば、登録されていることが確認できます。

```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5  gcc@4.4.7
```

標準で使用するコンパイラは設定ファイル`$HOME/.spack/linux/packages.yaml`で設定できます。
以下の例では標準コンパイラをgcc 4.8.5に設定しています。

```
packages:
  all:
    compiler: [gcc@4.8.5]
```

#### ABCIソフトウェアの登録 {#setup_configure_packages}

Spackはソフトウェアの依存関係を解決して、依存するソフトウェアも自動的にインストールします。
標準の設定では、CUDAやOpenMPIなど、ABCIが既に提供しているソフトウェアも利用者ごとにインストールされます。
ディスクスペースの浪費となりますので、ABCIが提供するソフトウェアは、Spackから*参照する*ように設定することをお勧めします。

Spackが参照するソフトウェアの設定は`$HOME/.spack/linux/packages.yaml`に定義します。
以下の内容で、そのファイルを作成してください（標準コンパイラの設定も含まれています）。

```
packages:
  cuda:
    paths:
      cuda@abci-8.0.61.2:   /apps/cuda/8.0.61.2
      cuda@abci-9.0.176.4:  /apps/cuda/9.0.176.4
      cuda@abci-9.1.85.3:   /apps/cuda/9.1.85.3
      cuda@abci-9.2.148.1:  /apps/cuda/9.2.148.1
      cuda@abci-10.0.130.1: /apps/cuda/10.0.130.1
      cuda@abci-10.1.243:   /apps/cuda/10.1.243
      cuda@abci-10.2.89:    /apps/cuda/10.2.89
    buildable: False
  openmpi:
    paths:
      openmpi@abci-2.1.6-nocuda%gcc@4.8.5: /apps/openmpi/2.1.6/gcc4.8.5
      openmpi@abci-3.1.3-nocuda%gcc@4.8.5: /apps/openmpi/3.1.3/gcc4.8.5
  mvapich2:
    paths:
      mvapich2@abci-2.3-nocuda%gcc@4.8.5:   /apps/mvapich2/2.3/gcc4.8.5
      mvapich2@abci-2.3.2-nocuda%gcc@4.8.5: /apps/mvapich2/2.3.2/gcc4.8.5
  cmake:
    paths:
      cmake@abci-3.11.4: /apps/cmake/3.11.4
  all:
    compiler: [gcc@4.8.5]
```

ここでは、CUDAとOpenMPI、MVAPICH、CMakeの設定をしています。
例えば、`cuda@abci-8.0.61.2: /apps/cuda/8.0.61.2`では、SpackでCUDAのバージョンabci-8.0.61.2のインストールを実行すると、実際にはインストールはせずに、`/apps/cuda/8.0.61.2`としてインストールされているものを使用することを意味します。
CUDAセクションでのみ記述されている`buildable: False`は、Spackにここで指定しているバージョン以外のCUDAをインストールさせないことを意味しています。
ABCIが提供していないバージョンのCUDAをSpackでインストールしたい場合は、この記述を削除してください。

`packages.yaml`ファイルの設定の詳細は[公式ドキュメント](https://spack.readthedocs.io/en/latest/build_settings.html)を参照ください。


## Spack 基本操作 {#usage}

Spackの基本操作についてまとめます。
詳細は[公式ドキュメント](https://spack.readthedocs.io/en/latest/basic_usage.html)を参照ください。

### コンパイラ関連 {#usage_compiler}

Spackに登録されているコンパイラ一覧は`compiler list`サブコマンドで確認できます。
```
[username@es1 ~]$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5  gcc@4.4.7
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
	modules  = []
	operating system  = centos7
```

### ソフトウェア管理関連 {#usage_package}

#### インストール {#usage_package_install}

OpenMPIのSpack標準バージョンは、以下の通りにインストールできます。
`schedulers=sge`の意味は[導入事例](#example_openmpi)を参照ください。
```
[username@es1 ~]$ spack install openmpi schedulers=sge
```

バージョンを指定する場合は、`@`で指定します。
```
[username@es1 ~]$ spack install openmpi@3.1.4 schedulers=sge
```

コンパイラを指定する場合は`%`で指定します。
以下の例では、コンパイラのバージョンも指定しています。
```
[username@es1 ~]$ spack install openmpi@3.1.4 %gcc@7.3.0 schedulers=sge
```

#### アンインストール {#usage_package_uninstall}

`uninstall`サブコマンドで、インストール済みのソフトウェアをアンインストールできます。
インストール同様に、バージョンを指定してアンインストールできます。
```
[username@es1 ~]$ spack uninstall openmpi
```

ソフトウェアのハッシュを指定してアンインストールすることもできます。
`/`に続いてハッシュを指定します。
ハッシュは[情報確認](#usage_package_info)に示す通り、`find`サブコマンドで取得できます。
```
[username@es1 ~]$ spack uninstall /ffwtsvk
```

インストールした全てのソフトウェアを一括して削除するには以下の通りに実行します。
```
[username@es1 ~]$ spack uninstall --all
```

#### 情報確認 {#usage_package_info}

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
sif5fzv openmpi@3.1.4
xqsp4xn     hwloc@1.11.11
3movoj3         libpciaccess@0.13.5
d6xghgt         libxml2@2.9.9
zydtv5a             libiconv@1.16
y6e4zi2             xz@5.2.4
kv37bl2             zlib@1.2.11
onnjyv2         numactl@2.0.12
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


## ソフトウェア利用方法 {#how_to_use}

SpackでインストールしたソフトウェアはEnvironment Modulesに自動的に登録されます。
ABCIが提供するモジュール同様に、ロードして使用できます。
```
[username@es1 ~]$ module load xxxxx
```

インストールした全ソフトウェアのモジュールを更新するには、次のコマンドを実行します。
```
[username@es1 ~]$ spack module tcl refresh
```

インストールしたソフトウェアのモジュールを削除するには、次のコマンドを実行します。
```
[username@es1 ~]$ spack module tcl rm
```

!!! note
    ソフトウェアをインストールしてもモジュールに登録されない場合は、モジュールの更新や、Spackの環境設定スクリプトの読み込みを行ってみてください。

    ```
    [username@es1 ~]$ source spack/share/spack/setup-env.sh
    ```

    ```
    [username@es1 ~]$ spack module tcl refresh
    ```


## ソフトウェア導入事例 {#example}

### CUDA-aware OpenMPI {#example_openmpi}

ABCIでは、CUDA-aware OpenMPIをモジュールで提供していますが、全てのコンパイラ、CUDA、OpenMPIの組み合わせで提供しているわけではありません（[参考](https://docs.abci.ai/ja/08/#open-mpi)）。
使用したい組み合わせがモジュール提供されていない場合は、Spackでインストールするのが簡単です。

#### インストール方法 {#example_openmpi_install}

CUDA 10.1.243を使用するOpenMPI 3.1.1をインストールする場合の例です。
GPUを搭載する計算ノード上で作業を行います。
```
[username@g0001 ~]$ spack install cuda@abci-10.1.243
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge ^cuda@abci-10.1.243
```
1行目では、ABCIが提供するCUDAを使用するよう、CUDAのバージョン`abci-10.1.243`をインストールします。
2行目でOpenMPI 3.1.1をインストールしています。
オプションの意味は以下の通りです。

- `+cuda`: CUDAを有効にしてビルドします。
- `schedulers=sge`: MPIプロセスを起動する手段を指定しています。ABCIではSGE互換のUGEを使っているため、sgeを指定します。
- `^cuda@abci-10.1.243`: 使用するCUDAを指定します。`^`は依存するソフトウェアを指定するときに使います。

3行目で、インストールしたOpenMPIをEnvironment Modulesに登録しています。

Spackでは、同一ソフトウェアを異なる設定で複数インストールし、管理することができます。
ここでは、CUDA 9.0.176.4を使用するOpenMPI 3.1.1を追加インストールします。
```
[username@g0001 ~]$ spack install cuda@abci-9.0.176.4
[username@g0001 ~]$ spack install openmpi@3.1.1 +cuda schedulers=sge ^cuda@abci-9.0.176.4
```

#### 使い方 {#example_openmpi_use}

「CUDA 10.1.243を使用するOpenMPI 3.1.1」を使う場合の利用方法を説明します。

2種類のOpenMPI 3.1.1がインストールされていますので、次のようにモジュールが見えます。
```
[username@es1 ~]$ module avail openmpi
------------------------- $HOME/spack/share/spack/modules/linux-centos7-haswell -------------------------
openmpi-3.1.1-gcc-4.8.5-4b7ssot openmpi-3.1.1-gcc-4.8.5-ffwtsvk
(snip)
```

まず、使用するOpenMPIのモジュールを判別します。
Spackにより生成されるモジュールは、(1)ソフトウェア名、(2)ソフトウェアバージョン、(3)コンパイラ、(4)コンパイラバージョン、(5)ハッシュ、による名前が付けられています。
今回は(1) ~ (4)が等しいため、(5)のハッシュで判別する必要があります。

OpenMPIの依存関係を確認し、CUDA 10.1.243を使用しているOpenMPIのハッシュを取得します。
```
[username@es1 ~]$ spack find -dl openmpi
==> 2 installed packages
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
4b7ssot openmpi@3.1.1
abxq4dx     hwloc@1.11.11
j56z2n2         cuda@9.0.176.4
(snip)

ffwtsvk openmpi@3.1.1
q6crewe     hwloc@1.11.11
aksjp4j         cuda@10.1.243
(snip)
```

ハッシュ`ffwtsvk`を持つOpenMPIが使用したいOpenMPIですので、モジュール`openmpi-3.1.1-gcc-4.8.5-ffwtsvk`を使用すれば良いとわかります。

以下に「CUDA 10.1.243を使用するOpenMPI 3.1.1」を利用するジョブスクリプト例を示します。
```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load cuda/10.1/10.1.243
module load openmpi-3.1.1-gcc-4.8.5-ffwtsvk

mpiexec -n 2 YOUR_PROGRAM
```

### CUDA-aware MVAPICH2 {#example_mvapich2}

ABCIが提供するMVAPICH2モジュールはCUDA対応していません。
CUDA-aware MVAPICH2を使用する場合は、以下を参考にSpackでインストールしてください。

GPUを搭載する計算ノード上で作業を行います。
[OpenMPIと同様](#example_openmpi)に、使用するCUDAをインストールしたのちに、CUDAオプション（`+cuda`）、およびCUDAの依存関係（`^cuda@abci-10.1.243`）を指定してMVAPICH2をインストールします。
```
[username@g0001 ~]$ spack install cuda@abci-10.1.243
[username@g0001 ~]$ spack install mvapich2@2.3 +cuda ^cuda@abci-10.1.243
```

使い方もOpenMPIと同様に、CUDAとインストールしたMVAPICH2をロードして使います。

### MPIFileUtils {#example_mpifileutils}

[MPIFileUtils](https://hpc.github.io/mpifileutils/)は、MPIを用いたファイル転送ツールです。
複数のライブラリに依存するため、マニュアルでインストールするのは面倒ですが、Spackを用いると簡単にインストールできます。

以下の例では、ABCIがモジュール提供するOpenMPI 2.1.6を使用して、MPIFileUtilsをインストールします。
該当するOpenMPIをインストールした後で（1行目）、それへの依存を指定してMPIFileUtilsをインストールします（2行目）。
```
[username@es1 ~]$ spack install openmpi@abci-2.1.6-nocuda
[username@es1 ~]$ spack install mpifileutils ^openmpi@abci-2.1.6-nocuda
```

使うときには、OpenMPI 2.1.6とMPIFileUtilsのモジュールをロードします。
MPIFileUtilsのモジュールをロードすると、`dbcast`などのプログラムへのパスがセットされます。
以下にジョブスクリプト例を示します。

```
#!/bin/bash
#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load openmpi/2.1.6
module load mpifileutils-0.9.1-gcc-4.8.5-qdv7523

NPPN=5
NMPIPROC=$(( $NHOSTS * $NPPN ))
SRC_FILE=name_of_file
DST_FILE=name_of_file

mpiexec -n ${NMPIPROC} -map-by ppr:${NPPN}:node dbcast $SRC_FILE $DST_FILE
```

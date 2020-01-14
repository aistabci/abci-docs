# Spackによるソフトウェア管理

[Spack](https://spack.io/)とは、Lawrence Livermore National Laboratoryで開発されている高性能計算向けのソフトウェアパッケージ管理システムです。
Spackを使うことにより、同一ソフトウェアをバージョン、設定、コンパイラを様々に変えて複数ビルドし、切り替えて使うことができます。
ABCI上でSpackを使うことにより、ABCIが標準でサポートしていないソフトウェアを簡単にインストールすることができるようになります。

動作確認は2019年12月13日に行っており、その時の最新のバージョンである0.13.2を使用しています。


## Spack環境設定

### インストール

SpackはGitHubからCloneするだけで利用できますが、本ドキュメントではバージョンをv0.13.2に固定して説明します。

```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd spack
[username@es1 ~/spack]$ git checkout v0.13.2
```

以降はターミナル上で、Spackを有効化するスクリプトを読み込めば使えます。

```
[username@es1 ~]$ source spack/share/spack/setup-env.sh
```

### ABCI用設定

#### コンパイラの登録

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

#### ABCIソフトウェアの登録

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
      cuda@abci-9.2.88.1:   /apps/cuda/9.2.88.1
      cuda@abci-9.2.148.1:  /apps/cuda/9.2.148.1
      cuda@abci-10.0.130.1: /apps/cuda/10.0.130.1
      cuda@abci-10.1.168:   /apps/cuda/10.1.168
      cuda@abci-10.1.243:   /apps/cuda/10.1.243
    buildable: False
  openmpi:
    paths:
      openmpi@abci-2.1.6-nocuda%gcc@4.8.5: /apps/openmpi/2.1.6/gcc4.8.5
      openmpi@abci-3.1.4-nocuda%gcc@4.8.5: /apps/openmpi/3.1.4/gcc4.8.5
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


## Spack 基本操作

### コンパイラ関連

コンパイラ一覧確認
```
$ spack compiler list
==> Available compilers
-- gcc centos7-x86_64 -------------------------------------------
gcc@7.4.0  gcc@4.8.5  gcc@4.4.7
```

特定コンパイラの情報確認
```
$ spack compiler info gcc@4.8.5
gcc@4.8.5:
	paths:
		cc = /usr/bin/gcc
		cxx = /usr/bin/g++
		f77 = /usr/bin/gfortran
		fc = /usr/bin/gfortran
	modules  = []
	operating system  = centos7
```

### パッケージ関連

#### インストール

パッケージインストール
```
$ spack install openmpi schedulers=sge 　　　　(標準バージョンをインストール)
$ spack install openmpi@3.1.4 schedulers=sge (バージョン指定してインストール)
$ spack install openmpi@3.1.4 %gcc@7.3.0 schedulers=sge (コンパイラを指定してインストール)
```

#### アンインストール

パッケージアンインストール
```
$ spack uninstall openmpi
```

全アンインストール
```
$ spack uninstall --all
```
#### 情報確認
パッケージ一覧
```
$ spack list
abinit
abyss
(snip)
```

キーワードを指定して、インストールできるパッケージを表示
```
$ spack list mpi
==> 21 packages.
compiz       mpifileutils  mpix-launch-swift  r-rmpi        vampirtrace
fujitsu-mpi  mpilander     openmpi            rempi
intel-mpi    mpileaks      pbmpi              spectrum-mpi
mpibash      mpip          pnmpi              sst-dumpi
mpich        mpir          py-mpi4py          umpire
```

特定のパッケージの詳細情報確認
```
$ spack info openmpi
AutotoolsPackage:   openmpi

Description:
    An open source Message Passing Interface implementation. The Open MPI
    Project is an open source Message Passing Interface implementation that
(snip)
```

spack installでインストール可能なパッケージのバージョン一覧
```
$ spack versions openmpi
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

Spackから利用可能なインストール済みパッケージ一覧
```
$ spack find
==> 49 installed packages
-- linux-centos7-haswell / gcc@4.8.5 ----------------------------
autoconf@2.69    gdbm@1.18.1          libxml2@2.9.9  readline@8.0
(snip)
```

特定のインストール済みパッケージの依存関係を確認
```
$ spack find -dl openmpi
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

## パッケージ利用方法

Spakcパッケージ用module fileに登録・更新
```
$ spack module tcl refresh
```

Spackでインストールされたパッケージもmoduleコマンドで参照可能
```
$ module avail
```

モジュールをロードして使用
```
$ module load xxxxx
```


Spackパッケージ用モジュールを削除
```
$ spack module tcl rm
```


## パッケージ導入事例

### CUDA-aware OpenMPI

ABCIでは、CUDA-aware OpenMPIをモジュールで提供していますが、全てのコンパイラ、CUDA、OpenMPIの組み合わせで提供しているわけではありません（[参考](https://docs.abci.ai/ja/08/#open-mpi)）。
使用したい組み合わせがモジュール提供されていない場合は、Spackでインストールするのが便利です。


インストール方法

CUDA 10.1.243を使用するOpenMPI 3.1.1
```
$ spack install cuda@10.1.243
$ spack install openmpi@3.1.1 +cuda schedulers=sge ^cuda@10.1.243 (+はオプション、^は依存を指定)
$ spack module tcl refresh
```

CUDA 9.0.176.4を使用するOpenMPI 3.1.1
```
$ spack install cuda@9.0.176.4
$ spack install openmpi@3.1.1 +cuda schedulers=sge ^cuda@9.0.176.4 (+はオプション、^は依存を指定)
$ spack module tcl refresh
```


使い方

「CUDA 10.1.243を使用するOpenMPI 3.1.1」を使う場合。
パッケージのハッシュでのみ、OpenMPIの違いを区別できる。
$ spack find -dl openmpiでハッシュを確認。
```
$ spack find -dl openmpi
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
$module availで対応するモジュールを確認。
```
$ module avail openmpi
----------------------------------------------- $HOME/spack/share/spack/modules/linux-centos7-haswell -----------------------------------------------
openmpi-3.1.1-gcc-4.8.5-4b7ssot openmpi-3.1.1-gcc-4.8.5-ffwtsvk
```
-> openmpi-3.1.1-gcc-4.8.5-ffwtsvkモジュールと判明

以下、「CUDA 10.1.243を使用するOpenMPI 3.1.1」を利用するジョブスクリプト例です。
```
#!/bin/bash

#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load openmpi-3.1.1-gcc-4.8.5-ffwtsvk
mpiexec -n 8 ./a.out
```


### CUDA-aware MVAPICH2

ABCIが提供するMVAPICH2モジュールはCUDA対応していません。
CUDA-aware MVAPICH2を使用する場合は、以下を参考にして、Spackでインストールしてください。

インストール方法
```
$ spack install cuda@9.2.148.1
$ spack install mvapich2@2.3 +cuda ^cuda@10.1.243
```

使い方

複数バージョンインストールした場合はopenmpiと同様にモジュール名を確認してください。
以下、ジョブスクリプト例です。
```
#!/bin/bash

#$-l rt_F=2
#$-j y
#$-cwd

source /etc/profile.d/modules.sh
source ${HOME}/spack/share/spack/setup-env.sh
module load mvapich2-2.3-gcc-4.8.5-oghcpn7

mpiexec -n 8 ./a.out
```

### MPIFileUtils

[MPIFileUtils](https://hpc.github.io/mpifileutils/)は、MPIを用いた高速ファイル転送ツールです。
複数のライブラリに依存するため、マニュアルでインストールするのは面倒ですが、Spackを用いると簡単にインストールできます。

ABCI提供のOpenMPI 2.1.6を使用
```
$ spack install openmpi@nocuda-2.1.6
$ spack install mpifileutils ^openmpi@nocuda-2.1.6
```

v0.13.1ではインストールはできるが、mpifileutilsのmodule file生成に失敗している。
(OpenMPIなど全て1からビルドしても同じ。v0.13.2ではどうか、確認)

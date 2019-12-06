# Spackによるソフトウェア管理

[Spack](https://spack.io/)とは、Lawrence Livermore National Laboratoryで開発されている高性能計算向けのソフトウェアパッケージ管理システムです。
Spackを使うことにより、同一ソフトウェアをバージョン、設定、コンパイラを様々に変えて複数ビルドし、切り替えて使うことができます。
ABCI上でSpackを使うことにより、ABCIが標準でサポートしていないソフトウェアを簡単にインストールすることができるようになります。

動作確認は2019年12月13日に行っています。


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

### ABCI向け設定

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

#### ABCIソフトウェアの登録

Spackはソフトウェアの依存関係を解決して、依存するソフトウェアも自動的にインストールします。
標準の設定では、CUDAやOpenMPIなど、ABCIが既に提供しているソフトウェアも利用者ごとにインストールされます。
ディスクスペースの浪費となりますので、ABCIが提供するソフトウェアは、Spackから*参照する*ように設定することをお勧めします。

Spackが参照するソフトウェアの設定は`$HOME/.spack/linux/packages.yaml`に定義します。
以下の内容で、そのファイルを作成してください。

*[滝澤]CUDAとCMAKEについて、%gcc@4.8.5をつけるべきか検討*

*[滝澤]ファイルで定義している内容の簡単な説明を追加*

```
packages:
  cuda:
    paths:
      cuda@8.0.61.2%gcc@4.8.5:   /apps/cuda/8.0.61.2
      cuda@9.0.176.4%gcc@4.8.5:  /apps/cuda/9.0.176.4
      cuda@9.1.85.3%gcc@4.8.5:   /apps/cuda/9.1.85.3
      cuda@9.2.88.1%gcc@4.8.5:   /apps/cuda/9.2.88.1
      cuda@9.2.148.1%gcc@4.8.5:  /apps/cuda/9.2.148.1
      cuda@10.0.130.1%gcc@4.8.5: /apps/cuda/10.0.130.1
      cuda@10.1.168%gcc@4.8.5:   /apps/cuda/10.1.168
      cuda@10.1.243%gcc@4.8.5:   /apps/cuda/10.1.243
    buildable: False
  openmpi:
    paths:
      openmpi@nocuda-2.1.6%gcc@4.8.5: /apps/openmpi/2.1.6/gcc4.8.5
      openmpi@nocuda-3.1.4%gcc@4.8.5: /apps/openmpi/3.1.4/gcc4.8.5
  mvapich2:
    paths:
      mvapich2@nocuda-2.3%gcc@4.8.5:   /apps/mvapich2/2.3/gcc4.8.5
      mvapich2@nocuda-2.3.2%gcc@4.8.5: /apps/mvapich2/2.3.2/gcc4.8.5
  cmake:
    paths:
      cmake@3.11.4%gcc@4.8.5: /apps/cmake/3.11.4
```


## Spack 基本操作

*[坂部]本セクション執筆*

*いくつかコマンドを書いてありますが、説明不要だったり、他に追記すべきものもあると思います。章構成も見直してください。*

### コンパイラ関連

コンパイラ一覧確認
```
$ spack compiler list
```

特定コンパイラの情報確認
```
$ spack compiler info gcc@4.8.5
```

### パッケージ関連

#### 情報確認

Spackでインストールできるパッケージ一覧を表示
```
$ spack list
```

キーワードを指定して、インストールできるパッケージを表示
```
$ spack list mpi
```

特定のパッケージの詳細情報確認
```
$ spack info openmpi
```

特定のパッケージのインストール可能なバージョンを確認
```
$ spack info openmpi
```

インストール済みパッケージ一覧確認
```
$ spack find
```

特定のインストール済みパッケージの依存関係を確認
```
$ spack find -dl openmpi
```

#### インストール

パッケージインストール
```
$ spack install openmpi schedulers=sge 　　　　(標準バージョンをインストール)
$ spack install openmpi@3.1.4 schedulers=sge (バージョン指定してインストール)
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


## パッケージ利用方法

*[坂部]本セクション執筆*

Spackでインストールされたパッケージは自動的にmodule fileが作成されている。
```
$ module avail (確認)
```

モジュールをロードして使用
```
$ module load xxxxx
```

必要に応じて、Spakcパッケージ用module fileを更新
```
$ spack module tcl refresh
```

Spackパッケージ用モジュールを削除
```
$ spack module tcl rm
```


## パッケージ導入事例

*[坂部]本セクション執筆*

### CUDA-aware OpenMPI

ABCIでは、CUDA-aware OpenMPIをモジュールで提供していますが、全てのコンパイラ、CUDA、OpenMPIの組み合わせで提供しているわけではありません（[参考](https://docs.abci.ai/ja/08/#open-mpi)）。
使用したい組み合わせがモジュール提供されていない場合は、Spackでインストールするのが便利です。



複数のバージョンを共存せてインストールする方法、バージョンを切り替えて使用する方法を書く

インストール方法

CUDA 10.1.243を使用するOpenMPI 3.1.1
```
$ spack install cuda@10.1.243
$ spack install openmpi +cuda schedulers=sge ^cuda@10.1.243
```

CUDA 9.0.176.4を使用するOpenMPI 3.1.1
```
$ spack install cuda@9.0.176.4
$ spack install openmpi +cuda schedulers=sge ^cuda@9.0.176.4

$ spack module tcl refresh
```


使い方（ジョブスクリプト例含む）

「CUDA 10.1.243を使用するOpenMPI 3.1.1」を使う場合。
パッケージのハッシュでのみ、OpenMPIの違いを区別できる。
$ spack find -dl openmpiでハッシュを確認。
-> openmpi-3.1.1-gcc-4.8.5-ffwtsvkモジュールと判明


### CUDA-aware MVAPICH2

ABCIが提供するMVAPICH2モジュールはCUDA対応していません。
CUDA-aware MVAPICH2を使用する場合は、以下を参考にして、Spackでインストールしてください。

バージョンを切り替えて使用する方法を書く

インストール方法
```
$ spack install cuda@9.2.148.1
$ spack install mvapich2@2.3 +cuda
```

異なるバージョンのCUDAを使うには、現状ではアンインストールが必要(少なくともv0.13.1では。v0.13.2で確認)
```
$ spack uninstall mvapich2@2.3
$ spack uninstall cuda@9.2.148.1
```


使い方（ジョブスクリプトも）


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

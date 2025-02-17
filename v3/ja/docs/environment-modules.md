# Environment Modules

ABCIでは、[ソフトウェア](system-overview.md#software)で挙げた、さまざまな開発環境、MPI、ライブラリ、ユーティリティ等を提供しています。利用者はこれらのソフトウェアを「モジュール」として、組み合わせて利用できます。

[Environment Modules](http://modules.sourceforge.net/)は、これらのモジュールを利用するのに必要な環境設定を柔軟かつ動的に行う機能を提供します。

## 利用方法 {#usage}

利用者は、`module`コマンドを用いて環境の設定を行えます。

```
$ module [options] <sub-command> [sub-command options]
```

以下にサブコマンドの一覧を示します。

| サブコマンド | 説明 |
|:--|:--|
| list | ロード済みのモジュールの一覧表示 |
| avail | 利用可能なモジュールの一覧表示 |
| show *module* | *module*の設定内容の表示 |
| load *module* | *module*のロード |
| unload *module* | *module*のアンロード |
| switch *moduleA* *moduleB* | モジュールの切り替え（*moduleA*を*moduleB*に置き換える） |
| purge | ロード済みのすべてのモジュールをアンロード（初期化） |
| help *module* | *module*の使用方法の表示 |

## 実行例 {#use-cases}

### モジュールのロード {#load-modules}

```
[username@login1 ~]$ module load cuda/12.6/12.6.1 cudnn/9.5/9.5.1
```

### ロード済みのモジュールの一覧表示 {#list-loaded-modules}

```
[username@login1 ~]$ module list
Currently Loaded Modulefiles:
 1) cuda/12.6/12.6.1   2) cudnn/9.5/9.5.1
```

### モジュールの設定内容の表示 {#display-the-configuration-of-modules}

```
[username@login1 ~]$ module show cuda/12.6/12.6.1
-------------------------------------------------------------------
/apps/modules/modulefiles/rhel9/gpgpu/cuda/12.6/12.6.1:

module-whatis   {cuda 12.6.1}
conflict        cuda
prepend-path    CUDA_HOME /apps/cuda/12.6.1
prepend-path    CUDA_PATH /apps/cuda/12.6.1
prepend-path    PATH /apps/cuda/12.6.1/bin
prepend-path    LD_LIBRARY_PATH /apps/cuda/12.6.1/extras/CUPTI/lib64
prepend-path    LD_LIBRARY_PATH /apps/cuda/12.6.1/lib64
prepend-path    CPATH /apps/cuda/12.6.1/extras/CUPTI/include
prepend-path    CPATH /apps/cuda/12.6.1/include
prepend-path    LIBRARY_PATH /apps/cuda/12.6.1/lib64
prepend-path    MANPATH /apps/cuda/12.6.1/doc/man
prepend-path    PATH /apps/cuda/12.6.1/gds/tools
prepend-path    MANPATH /apps/cuda/12.6.1/gds/man
-------------------------------------------------------------------
```

### ロード済みのすべてのモジュールをアンロード（初期化） {#unload-all-loaded-modules-initialize}

```
[username@login1 ~]$ module purge
[username@login1 ~]$ module list
No Modulefiles Currently Loaded.
```

### 依存関係のあるモジュールのロード {#load-dependent-modules}

```
[username@login1 ~]$ module load cudnn/9.5/9.5.1
WARNING: cudnn/9.5/9.5.1 cannot be loaded due to missing prereq.
HINT: the following modules must be loaded first: cuda/12.6

Loading cudnn/9.5/9.5.1
  ERROR: Module evaluation aborted
```

依存関係があるため、`cuda/12.6`のモジュールを先にロードしないと`cudnn/9.5/9.5.1`をロードできません。

```
[username@login1 ~]$ module load cuda/12.6/12.6.1
[username@login1 ~]$ module load cudnn/9.5/9.5.1
```

### 排他関係にあるモジュールのロード {#load-exclusive-modules}

同一ライブラリの異なるバージョンのモジュールなど、排他関係にあるモジュールは同時に利用することはできません。

```
[username@login1 ~]$ module load cuda/12.5/12.5.1
[username@login1 ~]$ module load cuda/12.6/12.6.1
Loading cuda/12.6/12.6.1
  ERROR: Module cannot be loaded due to a conflict.
    HINT: Might try "module unload cuda" first.
```

### モジュールの切り替え {#switch-modules}

```
[username@login1 ~]$ module load cuda/12.5/12.5.1
[username@login1 ~]$ module switch cuda/12.5/12.5.1 cuda/12.6/12.6.1
```


## ジョブスクリプトでの利用方法 {#usage-in-a-job-script}

バッチ利用時のジョブスクリプトで`module`コマンドを利用する場合には、以下のように初期設定を加える必要があります。

sh, bashの場合:

```
source /etc/profile.d/modules.sh
module load cuda/12.6/12.6.1
```

csh, tcshの場合:

```
source /etc/profile.d/modules.csh
module load cuda/12.6/12.6.1
```

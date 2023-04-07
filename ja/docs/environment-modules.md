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
[username@es1 ~]$ module load cuda/11.7/11.7.1 cudnn/8.4/8.4.1
```

### ロード済みのモジュールの一覧表示 {#list-loaded-modules}

```
[username@es1 ~]$ module list
Currently Loaded Modulefiles:
 1) cuda/11.7/11.7.1   2) cudnn/8.4/8.4.1
```

### モジュールの設定内容の表示 {#display-the-configuration-of-modules}

```
[username@es1 ~]$ module show cuda/11.7/11.7.1
-------------------------------------------------------------------
/apps/modules/modulefiles/rocky8/gpgpu/cuda/11.7/11.7.1:

module-whatis   {cuda 11.7.1}
conflict        cuda
prepend-path    CUDA_HOME /apps/cuda/11.7.1
prepend-path    CUDA_PATH /apps/cuda/11.7.1
prepend-path    PATH /apps/cuda/11.7.1/bin
prepend-path    LD_LIBRARY_PATH /apps/cuda/11.7.1/extras/CUPTI/lib64
prepend-path    LD_LIBRARY_PATH /apps/cuda/11.7.1/lib64
prepend-path    CPATH /apps/cuda/11.7.1/extras/CUPTI/include
prepend-path    CPATH /apps/cuda/11.7.1/include
prepend-path    LIBRARY_PATH /apps/cuda/11.7.1/lib64
prepend-path    MANPATH /apps/cuda/11.7.1/doc/man
-------------------------------------------------------------------
```

### ロード済みのすべてのモジュールをアンロード（初期化） {#unload-all-loaded-modules-initialize}

```
[username@es1 ~]$ module purge
[username@es1 ~]$ module list
No Modulefiles Currently Loaded.
```

### 依存関係のあるモジュールのロード {#load-dependent-modules}

```
[username@es1 ~]$ module load cudnn/8.4/8.4.1
WARNING: cudnn/8.4/8.4.1 cannot be loaded due to missing prereq.
HINT: at least one of the following modules must be loaded first: cuda/10.2 cuda/11.0 cuda/11.1 cuda/11.2 cuda/11.3 cuda/11.4 cuda/11.5 cuda/11.6 cuda/11.7

Loading cudnn/8.4/8.4.1
  ERROR: Module evaluation aborted
```

依存関係があるため、`cuda/10.2`、`cuda/11.0`から`cuda/11.7`のいずれかのモジュールを先にロードしないと`cudnn/8.4/8.4.1`をロードできません。

```
[username@es1 ~]$ module load cuda/11.7/11.7.1
[username@es1 ~]$ module load cudnn/8.4/8.4.1
```

### 排他関係にあるモジュールのロード {#load-exclusive-modules}

同一ライブラリの異なるバージョンのモジュールなど、排他関係にあるモジュールは同時に利用することはできません。

```
[username@es1 ~]$ module load cuda/11.7/11.7.1
[username@es1 ~]$ module load cuda/12.0/12.0.0
Loading cuda/12.0/12.0.0
  ERROR: cuda/12.0/12.0.0 cannot be loaded due to a conflict.
    HINT: Might try "module unload cuda" first.
```

### モジュールの切り替え {#switch-modules}

```
[username@es1 ~]$ module load cuda/11.7/11.7.1
[username@es1 ~]$ module switch cuda/11.7/11.7.1 cuda/12.0/12.0.0
```

インタラクティブノード(A)、計算ノード(A)環境では依存関係があると切り替えがうまくできない場合があります。

```
[username@es-a1 ~]$ module load cuda/11.0/11.0.3
[username@es-a1 ~]$ module load cudnn/8.4/8.4.1
[username@es-a1 ~]$ module switch cuda/11.0/11.0.3 cuda/11.2/11.2.2
[username@es-a1 ~]$ echo $LD_LIBRARY_PATH
/apps/cuda/11.2.2/lib64:/apps/cuda/11.2.2/extras/CUPTI/lib64:/apps/cudnn/8.4.1/cuda11.0/lib64
```

CUDA11.2と、CUDA11.0用のcuDNNがロードされた状態になっています。

なお、インタラクティブノード(V)、計算ノード(V)環境では依存関係がある場合は`module switch`コマンドがエラーを返します。

```
[username@es1 ~]$ module load cuda/11.0/11.0.3
[username@es1 ~]$ module load cudnn/8.4/8.4.1
[username@es1 ~]$ module switch cuda/11.0/11.0.3 cuda/11.2/11.2.2
Unloading cuda/11.0/11.0.3
  ERROR: cuda/11.0/11.0.3 cannot be unloaded due to a prereq.
    HINT: Might try "module unload cudnn/8.4/8.4.1" first.

Switching from cuda/11.0/11.0.3 to cuda/11.2
  ERROR: Unload of switched-off cuda/11.0/11.0.3 failed
```

インタラクティブノード(A)、計算ノード(A)環境では以下のように、対象のモジュールに依存しているモジュールを事前にアンロードし、切り替え後に再度ロードしてください。

```
[username@es-a1 ~]$ module load cuda/11.0/11.0.3 cudnn/8.4/8.4.1
[username@es-a1 ~]$ module unload cudnn/8.4/8.4.1
[username@es-a1 ~]$ module switch cuda/11.0/11.0.3 cuda/11.2/11.2.2
[username@es-a1 ~]$ module load cudnn/8.4/8.4.1
[username@es-a1 ~]$ echo $LD_LIBRARY_PATH
/apps/cudnn/8.4.1/cuda11.2/lib64:/apps/cuda/11.2.2/lib64:/apps/cuda/11.2.2/extras/CUPTI/lib64
```

## ジョブスクリプトでの利用方法 {#usage-in-a-job-script}

バッチ利用時のジョブスクリプトで`module`コマンドを利用する場合には、以下のように初期設定を加える必要があります。

sh, bashの場合:

```
source /etc/profile.d/modules.sh
module load cuda/10.2/10.2.89
```

csh, tcshの場合:

```
source /etc/profile.d/modules.csh
module load cuda/10.2/10.2.89
```

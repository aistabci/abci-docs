# システム更新履歴

<!--
## 2019-XX-XX

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | CentOS | 7.X | 7.4 |
| Add | CUDA | 10.0.X | |
-->

## 2019-01-31

### qstatコマンドの出力の変更

ジョブスケジューラの設定変更を実施し、qstat コマンドの出力において、ユーザ/グループ/ジョブ名がマスク表示されるようにしました。

自身のジョブの場合のみ上記の情報は表示され、そうでない場合はこれらの情報は'*'でマスクされます。以下に表示例を示します。

```
[username@es1 ~]$ qstat -u '*' | head
job-ID     prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID
------------------------------------------------------------------------------------------------------------------------------------------------
    123456 0.28027 run.sh     username     r     01/31/2019 12:34:56 gpu@g0001                                                        80
    123457 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0002                                                        80
    123458 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0003                                                        80
    123450 0.28027 ********** **********   r     01/31/2019 12:34:56 gpu@g0004                                                        80
```

## 2018-12-18

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Add | NCCL | 2.3.7-1 | |
| Add | cuDNN | 7.4.2 | |
| Add | Open MPI | 3.0.3, 3.1.3 | |
| Add | MVAPICH2-GDR | 2.3 | |
| Add | Hadoop | 2.9.2 | |
| Add | Spark | 2.3.2, 2.4.0 | |
| Add | Go | 1.11.2 | |
| Add | Intel MKL | 2018.2.199 | |

### NCCL 2.3.7-1

NVIDIA Collective Communications Library (NCCL) 2.3.7-1 をインストールしました。

リリースノート: [NCCL Release 2.3.7](https://docs.nvidia.com/deeplearning/sdk/nccl-release-notes/index.html)

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load nccl/2.3/2.3.7-1
```

### cuDNN 7.4.2

NVIDIA CUDA Deep Neural Network library (cuDNN) 7.4.2 をインストールしました。

リリースノート: [cuDNN Release Notes v7.4.2](https://docs.nvidia.com/deeplearning/sdk/cudnn-release-notes/rel_742.html)

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load cudnn/7.4/7.4.2
```

### Open MPI 3.0.3, 3.1.3

Open MPI (without --cuda option) 3.0.3, 3.1.3 をインストールしました。

利用環境の設定:

```
$ module load openmpi/3.1.3
```

### MVAPICH2-GDR 2.3

MVAPICH2-GDR 2.3 をインストールしました。

利用環境の設定:

```
$ module load cuda/9.2/9.2.148.1
$ module load mvapich/mvapich2-gdr/2.3
```

### Hadoop 2.9.2

Apache Hadoop 2.9.2 をインストールしました。

利用環境の設定:

```
$ module load openjdk/1.8.0.131
$ module load hadoop/2.9.1
```

### Spark 2.3.2, 2.4.0

Apache Spark 2.3.2, 2.4.0 をインストールしました。

利用環境の設定:

```
$ module load spark/2.4.0
```

### Go 1.11.2

Go 言語 1.11.2 をインストールしました。

利用環境の設定:

```
$ module load go/1.11.2
```

### Intel MKL 2018.2.199

Intel Math Kernel Library (MKL) 2018.2.199 をインストールしました。

利用環境の設定:

```
$ module load intel-mkl/2018.2.199
```

## 2018-12-14

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Singularity | 2.6.1 | 2.6.0 |
| Delete | Singularity | 2.5.2 | |

### Singularity 2.6.1

Singularity 2.6.1 をインストールしました。使用方法は以下の通りです。

```
$ module load singularity/2.6.1
$ singularity run image_path
```

アップデート情報については、以下のページを参照ください。

[Singularity 2.6.1](https://github.com/sylabs/singularity/releases/tag/2.6.1)

また、ソフトウェアの脆弱性 ([CVE-2018-19295](https://cve.mitre.org/cgi-bin/cvename.cgi?name=2018-19295)) が報告されたため、Singularity 2.5.2, 2.6.0 はアンインストールしました。ジョブスクリプト内で、バージョンを指定して Singularity 環境を設定している場合（`singularity/2.5.2`, `singularity/2.6.0`など）、バージョン指定を `singularity/2.6.1` に修正ください。

```
ex) module load singularity/2.5.2 -> module load singularity/2.6.1
```

# 開発ツール

## GNU Compiler Collection (GCC)

ABCIシステムではGCCが利用可能です。

コンパイル/リンクコマンド一覧:

| 種別 | 言語処理系 | コマンド |
|:--|:--|:--|
| 逐次 | Fortran | gfortran |
| | C | gcc |
| | C++ | g++ |
| MPI並列 | Fortran | mpifort |
| | C | mpicc |
| | C++ | mpic++ |

## Intel Parallel Studio XE

ABCIシステムではIntel Parallel Studio XEが利用可能です。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
計算ノードで`module`コマンドを用いて利用環境を設定すると、コンパイル用環境変数に
ヘッダファイルおよびライブラリのサーチパスが自動で設定され、実行用環境変数も自動で設定されます。

Intel Parallel Studio XEの環境設定:

```
[username@g0001 ~]$ module load intel/2022.0.2
```

コンパイル/リンクコマンド一覧:

| 言語処理系 | コマンド |
|:--|:--|
| Fortran | ifort |
| C | icc |
| C++ | icpc |

## PGI

ABCIシステムではPGIが利用可能です。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
計算ノードで`module`コマンドを用いて利用環境を設定すると、コンパイル用環境変数に
ヘッダファイルおよびライブラリのサーチパスが自動で設定され、実行用環境変数も自動で設定されます。

PGIの環境設定:

```
[username@g0001 ~]$ module load pgi/20.4
```

コンパイル/リンクコマンド一覧:

| 言語処理系 | コマンド |
|:--|:--|
| Fortran | pgf90 |
| C | pgcc |
| C++ | pgc++ |

## OpenMP

ABCIシステムで用意されているコンパイラは、OpenMPを用いたスレッド並列化機能が実装されています。
OpenMPを有効化する場合、コンパイル/リンク時に以下のようにオプションを指定する必要があります。

| | オプション |
|:--|:--|
| GCC | -fopenmp |
| Intel Parallel Studio | -qopenmp |
| PGI | -mp |

## CUDA

ABCIシステムではCUDAが利用可能です。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
計算ノードで`module`コマンドを用いて利用環境を設定すると、コンパイル用環境変数に
ヘッダファイルおよびライブラリのサーチパスが自動で設定され、実行用環境変数も自動で設定されます。

| 言語処理系 | コマンド |
|:--|:--|
| C++ | nvcc |

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

## Intel oneAPI

ABCIシステムではIntel oneAPIが利用可能です。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
計算ノードで`module`コマンドを用いて利用環境を設定すると、コンパイル用環境変数に
ヘッダファイルおよびライブラリのサーチパスが自動で設定され、実行用環境変数も自動で設定されます。

Intel oneAPIの環境設定:

```
[username@login1 ~]$ module load intel/2024.2.1
```

コンパイル/リンクコマンド一覧:

| 言語処理系 | コマンド |
|:--|:--|
| Fortran | ifx |
| C | icx |
| C++ | icpx |

## OpenMP

ABCIシステムで用意されているコンパイラは、OpenMPを用いたスレッド並列化機能が実装されています。
OpenMPを有効化する場合、コンパイル/リンク時に以下のようにオプションを指定する必要があります。

| | オプション |
|:--|:--|
| GCC | -fopenmp |
| Intel oneAPI | -qopenmp |

## CUDA

ABCIシステムではCUDAが利用可能です。
利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
計算ノードで`module`コマンドを用いて利用環境を設定すると、コンパイル用環境変数に
ヘッダファイルおよびライブラリのサーチパスが自動で設定され、実行用環境変数も自動で設定されます。

| 言語処理系 | コマンド |
|:--|:--|
| C++ | nvcc |
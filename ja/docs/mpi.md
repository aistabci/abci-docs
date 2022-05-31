# MPI

ABCIシステムでは、以下のMPIを利用できます。

* [Open MPI](https://www.open-mpi.org/)
* [Intel MPI](https://software.intel.com/en-us/intel-mpi-library)

利用するためには事前に`module`コマンドを用いて利用環境を設定する必要があります。
インタラクティブノードで`module`コマンドを用いると、コンパイル用環境変数（ヘッダファイルおよびライブラリのサーチパス）が自動で設定されます。
計算ノードで`module`コマンドを用いると、コンパイル用環境変数に加え、実行用環境変数も自動で設定されます。

```
[username@es1 ~]$ module load openmpi/4.0.5
```

```
[username@es1 ~]$ module load intel-mpi/2021.5
```

以下では、ABCIシステムに導入されているMPIのバージョン一覧を示します。

## Open MPI

計算ノード(V):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/4.8.5     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/4.8.5     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

計算ノード(A):

| openmpi/ | Compiler version | w/o CUDA |
|:--|:--|:--|
| 4.0.5  | gcc/8.3.1     | Yes |
| 4.0.5  | gcc/9.3.0     | Yes |
| 4.0.5  | gcc/11.2.0    | Yes |
| 4.0.5  | pgi/20.4      | Yes |
| 4.1.3  | gcc/8.3.1     | Yes |
| 4.1.3  | gcc/9.3.0     | Yes |
| 4.1.3  | gcc/11.2.0    | Yes |
| 4.1.3  | pgi/20.4      | Yes |

## Intel MPI

| intel-mpi/ | Compute Node (V) | Compute Node (A) |
|:--|:--|:--|
| 2021.5 | Yes | Yes |

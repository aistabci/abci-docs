# GPU

ABCIシステムでは、NVIDIAが提供する以下のライブラリが利用できます。

* [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit)
* [NVIDIA CUDA Deep Neural Network library (cuDNN)](https://developer.nvidia.com/cudnn)
* [NVIDIA Collective Communications Library (NCCL)](https://developer.nvidia.com/nccl)
* [GDRCopy: A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology](https://github.com/NVIDIA/gdrcopy)

これらのライブラリを利用するためには、事前に`module`コマンドを用いて利用環境を設定する必要があります。`module`コマンドを用いると、`PATH`などの実行用環境変数や、ヘッダファイルやライブラリのサーチパスなどのコンパイル用環境変数を自動的に設定できます。

```
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.4/7.4.2
[username@g0001 ~]$ module load nccl/2.4/2.4.8-1
```

以下では、ABCIシステムで利用可能なCUDA Toolkit、cuDNN、NCCLの一覧を示します。

## CUDA Toolkit

| Major version | Minor version | Available from NVIDIA | Available on Compute Node (V) | Available on Compute Node (A) |
|:--|:--|:--|:--|:--|
| cuda/9.0 | 9.0.176.1   | Yes | Yes | -   |
| cuda/9.1 | 9.1.85.3    | Yes | Yes | -   |
| cuda/9.2 | 9.2.148.1   | Yes | Yes | -   |
| cuda/10.0 | 10.0.130.1 | Yes | Yes | Yes[^1] |
| cuda/10.1 | 10.1.243   | Yes | Yes | Yes[^1] |
| cuda/10.2 | 10.2.89    | Yes | Yes | Yes[^1] |
| cuda/11.0 | 11.0.3     | Yes | Yes | Yes |
| cuda/11.1 | 11.1.1     | Yes | Yes | Yes |
| cuda/11.2 | 11.2.2     | Yes | Yes | Yes |
| cuda/11.3 | 11.3.1     | Yes | Yes | Yes |
| cuda/11.4 | 11.4.4     | Yes | Yes | Yes |
| cuda/11.5 | 11.5.2     | Yes | Yes | Yes |
| cuda/11.6 | 11.6.2     | Yes | Yes | Yes |

[^1]: 試験用に提供しています。NVIDIA A100は、CUDA 11以降でサポートされます。

## cuDNN

計算ノード(V):

| Version | cuda/8.0 | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 7.0.5  | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.1.4  | -   | Yes | -   | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.2.1  | -   | Yes | -   | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.3.1  | -   | Yes | -   | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.4.2  | -   | Yes | -   | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.5.1  | -   | Yes | -   | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.6.5  | -   | Yes | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 8.0.5  | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   | -   |
| 8.1.1  | -   | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   |
| 8.2.4  | -   | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | -   | -   |
| 8.3.3  | -   | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

計算ノード(A):

| Version | cuda/10.0[^1] | cuda/10.1[^1] | cuda/10.2[^1] | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 7.3.1  | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.4.2  | Yes | -   | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.5.1  | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   |
| 7.6.5  | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 8.0.5  | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   | -   |
| 8.1.1  | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   |
| 8.2.4  | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | -   | -   |
| 8.3.3  | -   | -   | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

## NCCL

計算ノード(V):

| Version | cuda/8.0 | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.4.8-1  | -   | -   | -   | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   |
| 2.5.6-1  | -   | Yes | -   | -   | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 2.6.4-1  | -   | -   | -   | -   | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 2.7.8-1  | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   | -   |
| 2.8.4-1  | -   | -   | -   | -   | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   |
| 2.9.9-1  | -   | -   | -   | -   | -   | -   | Yes | Yes | -   | -   | Yes | -   | -   | -   |
| 2.10.3-1 | -   | -   | -   | -   | -   | -   | Yes | Yes | -   | -   | -   | Yes | -   | -   |
| 2.11.4-1 | -   | -   | -   | -   | -   | -   | Yes | Yes | -   | -   | -   | Yes | Yes | Yes |
| 2.12.7-1 | -   | -   | -   | -   | -   | -   | Yes | Yes | -   | -   | -   | -   | -   | Yes |

計算ノード(A):

| Version | cuda/10.0[^1] | cuda/10.1[^1] | cuda/10.2[^1] | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.4.8-1  | Yes | Yes | -   | -   | -   | -   | -   | -   | -   | -   |
| 2.5.6-1  | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 2.6.4-1  | Yes | Yes | Yes | -   | -   | -   | -   | -   | -   | -   |
| 2.7.8-1  | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   | -   |
| 2.8.4-1  | -   | -   | Yes | Yes | Yes | Yes | -   | -   | -   | -   |
| 2.9.9-1  | -   | -   | Yes | Yes | -   | -   | Yes | -   | -   | -   |
| 2.10.3-1 | -   | -   | Yes | Yes | -   | -   | -   | Yes | -   | -   |
| 2.11.4-1 | -   | -   | Yes | Yes | -   | -   | -   | Yes | Yes | Yes |
| 2.12.7-1 | -   | -   | Yes | Yes | -   | -   | -   | -   | -   | Yes |

## GDRCopy

計算ノード(V):

| Version | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.3 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

計算ノード(A):

| Version | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.3 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

## GPU Compute Modeの変更 {#changing-gpu-compute-mode}

ジョブ実行オプション `-v GPU_COMPUTE_MODE=num` を用いて、GPUのCompute Modeを変更することができます。以下の3つのCompute Modeが指定可能です。

| オプション | 説明 |
|:--|:--|
|-v GPU\_COMPUTE\_MODE=0 | DEFAULTモード。<br>1つのGPUを複数のプロセスから同時に利用できます。 |
|-v GPU\_COMPUTE\_MODE=1 | EXCLUSIVE\_PROCESSモード。<br>1つのGPUを1プロセスのみが利用できます。1プロセスから複数スレッドの利用は可能です。 |
|-v GPU\_COMPUTE\_MODE=2 | PROHIBITEDモード。<br>GPUへのプロセス割り当てを禁止します。 |

インタラクティブ利用時の実行例:

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00 -v GPU_COMPUTE_MODE=1
```

バッチ利用時の実行例:

```bash
#!/bin/bash

#$ -l rt_F=1
#$ -l h_rt=1:00:00
#$ -j y
#$ -cwd
#$ -v GPU_COMPUTE_MODE=1
/usr/bin/nvidia-smi
```

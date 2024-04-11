# 7. GPU

The following libraries provided by NVIDIA are available on the ABCI System:

* [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit)
* [NVIDIA CUDA Deep Neural Network library (cuDNN)](https://developer.nvidia.com/cudnn)
* [NVIDIA Collective Communications Library (NCCL)](https://developer.nvidia.com/nccl)
* [GDRCopy: A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology](https://github.com/NVIDIA/gdrcopy)

To use these libraries, it is necessary to set up the users environment using the `module` command in advance. The `module` command allows users to automatically set environment variables for execution, such as` PATH`, and environment variables for compilation, such as search paths for header files and libraries.

```
[username@g0001 ~]$ module load cuda/10.2/10.2.89
[username@g0001 ~]$ module load cudnn/7.6/7.6.5
[username@g0001 ~]$ module load nccl/2.5/2.5.6-1
```

The following is a list of CUDA Toolkit, cuDNN, and NCCL that can be used with the ABCI system.

## CUDA Toolkit

| Major version | Minor version | Available from NVIDIA | Available on Compute Node (V) | Available on Compute Node (A) |
| :------------ | :------------ | :-------------------- | :---------------------------- | :---------------------------- |
| cuda/11.2     | 11.2.2        | Yes                   | Yes[^1]                       | Yes                           |
| cuda/11.6     | 11.6.2        | Yes                   | Yes[^1]                       | Yes                           |
| cuda/11.7     | 11.7.1        | Yes                   | Yes                           | Yes                           |
| cuda/11.8     | 11.8.0        | Yes                   | Yes                           | Yes                           |
| cuda/12.1     | 12.1.1        | Yes                   | Yes                           | Yes                           |
| cuda/12.2     | 12.2.0        | Yes                   | Yes                           | Yes                           |
| cuda/12.3     | 12.3.2        | Yes                   | Yes                           | Yes                           |
| cuda/12.4     | 12.4.0        | Yes                   | Yes                           | Yes                           |

[^1]: Provided only for experimental use. Rocky Linux 8.6 is supported with CUDA 11.7.1 or later.

## cuDNN

Compute Node (V):

| Version | cuda/11.2[^1] | cuda/11.6[^1] | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
| ------- | ------------- | ------------- | --------- | --------- | --------- | --------- | --------- | --------- |
| 8.1.1   | Yes           | -             | -         | -         | -         | -         | -         | -         |
| 8.3.3   | Yes           | Yes           | -         | -         | -         | -         | -         | -         |
| 8.4.1   | Yes           | Yes           | Yes       | Yes       | -         | -         | -         | -         |
| 8.6.0   | Yes           | Yes           | Yes       | Yes       | -         | -         | -         | -         |
| 8.7.0   | Yes           | Yes           | Yes       | Yes       | -         | -         | -         | -         |
| 8.8.1   | Yes           | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 8.9.7   | Yes           | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 9.0.0[^2] | Yes           | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |

Compute Node (A):

| Version | cuda/11.2 | cuda/11.6 | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
| :------ | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 8.1.1   | Yes       | -         | -         | -         | -         | -         | -         | -         |
| 8.3.3   | Yes       | Yes       | -         | -         | -         | -         | -         | -         |
| 8.4.1   | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 8.6.0   | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 8.7.0   | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 8.8.1   | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 8.9.7   | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 9.0.0[^2] | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |

[^2]: We have confirmed that when cuDNN 9.0.0 is used with CUDA 11.0 to CUDA 11.3, an error occurs when calling the `cudnnRNNBackwardWeights_v8` function.

## NCCL

Compute Node (V):

| Version   | cuda/11.2[^1] | cuda/11.6[^1] | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
| --------- | ------------- | ------------- | --------- | --------- | --------- | --------- | --------- | --------- |
| 2.8.4-1   | Yes           | -             | -         | -         | -         | -         | -         | -         |
| 2.11.4-1  | -             | Yes           | -         | -         | -         | -         | -         | -         |
| 2.12.12-1 | -             | Yes           | -         | -         | -         | -         | -         | -         |
| 2.13.4-1  | -             | -             | Yes       | -         | -         | -         | -         | -         |
| 2.14.3-1  | -             | -             | Yes       | -         | -         | -         | -         | -         |
| 2.15.5-1  | -             | -             | -         | Yes       | -         | -         | -         | -         |
| 2.16.2-1  | -             | -             | -         | Yes       | -         | -         | -         | -         |
| 2.17.1-1  | -             | -             | -         | -         | Yes       | -         | -         | -         |
| 2.18.5-1  | -             | -             | -         | -         | -         | Yes       | -         | -         |
| 2.19.3-1  | -             | -             | -         | -         | -         | Yes       | Yes       | -         |
| 2.20.5-1  | -             | -             | -         | -         | -         | Yes       | -         | Yes       |

Compute Node (A):

| Version   | cuda/11.2 | cuda/11.6 | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
| :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 2.8.4-1   | Yes       | -         | -         | -         | -         | -         | -         | -         |
| 2.11.4-1  | -         | Yes       | -         | -         | -         | -         | -         | -         |
| 2.12.12-1 | -         | Yes       | -         | -         | -         | -         | -         | -         |
| 2.13.4-1  | -         | -         | Yes       | -         | -         | -         | -         | -         |
| 2.14.3-1  | -         | -         | Yes       | -         | -         | -         | -         | -         |
| 2.15.5-1  | -         | -         | -         | Yes       | -         | -         | -         | -         |
| 2.16.2-1  | -         | -         | -         | Yes       | -         | -         | -         | -         |
| 2.17.1-1  | -         | -         | -         | -         | Yes       | -         | -         | -         |
| 2.18.5-1  | -         | -         | -         | -         | -         | Yes       | -         | -         |
| 2.19.3-1  | -         | -         | -         | -         | -         | Yes       | Yes       | -         |
| 2.20.5-1  | -         | -         | -         | -         | -         | Yes       | -         | Yes       |

## GDRCopy

Compute Node (V):

| Version | gcc | cuda/11.2 | cuda/11.6 | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.4.1 | 8.5.0 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.4.1 | 13.2.0 | - | - | - | - | - | - | - | Yes |

Compute Node (A):

| Version | gcc | cuda/11.2 | cuda/11.6 | cuda/11.7 | cuda/11.8 | cuda/12.1 | cuda/12.2 | cuda/12.3 | cuda/12.4 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.4.1 | 8.3.1 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| 2.4.1 | 13.2.0 | - | - | - | - | - | - | - | Yes |

## Changing GPU Compute Mode {#changing-gpu-compute-mode}

You can change GPU Compute Mode by using `-v GPU_COMPUTE_MODE=num` option. The following three Compute Modes can be specified.

| Option | Description |
|:--|:--|
|-v GPU\_COMPUTE\_MODE=0 | DEFAULT mode.<br>Multiple contexts are allowed per device. |
|-v GPU\_COMPUTE\_MODE=2 | PROHIBITED mode.<br>No contexts are allowed per device (no compute apps). |
|-v GPU\_COMPUTE\_MODE=3 | EXCLUSIVE\_PROCESS mode.<br>Only one context is allowed per device, usable from multiple threads at a time. |

Execution example in an interactive job:

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00 -v GPU_COMPUTE_MODE=3
```

Execution example in a batch job:

```bash
#!/bin/bash

#$ -l rt_F=1
#$ -l h_rt=1:00:00
#$ -j y
#$ -cwd
#$ -v GPU_COMPUTE_MODE=3
/usr/bin/nvidia-smi
```

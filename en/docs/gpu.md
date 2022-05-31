# 7. GPU

The following libraries provided by NVIDIA are available on the ABCI System:

* [CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit)
* [NVIDIA CUDA Deep Neural Network library (cuDNN)](https://developer.nvidia.com/cudnn)
* [NVIDIA Collective Communications Library (NCCL)](https://developer.nvidia.com/nccl)
* [GDRCopy: A fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology](https://github.com/NVIDIA/gdrcopy)

To use these libraries, it is necessary to set up the users environment using the `module` command in advance. The `module` command allows users to automatically set environment variables for execution, such as` PATH`, and environment variables for compilation, such as search paths for header files and libraries.

```
[username@g0001 ~]$ module load cuda/10.0/10.0.130.1
[username@g0001 ~]$ module load cudnn/7.4/7.4.2
[username@g0001 ~]$ module load nccl/2.4/2.4.8-1
```

The following is a list of CUDA Toolkit, cuDNN, and NCCL that can be used with the ABCI system.

## CUDA Toolkit

| Major version | Minor version | Available from NVIDIA | Available on Compute Node (V) | Available on Compute Node (A) |
| :------------ | :------------ | :-------------------- | :---------------------------- | :---------------------------- |
| cuda/9.0      | 9.0.176.1     | Yes                   | Yes                           | -                             |
| cuda/9.1      | 9.1.85.3      | Yes                   | Yes                           | -                             |
| cuda/9.2      | 9.2.148.1     | Yes                   | Yes                           | -                             |
| cuda/10.0     | 10.0.130.1    | Yes                   | Yes                           | Yes[^1]                       |
| cuda/10.1     | 10.1.243      | Yes                   | Yes                           | Yes[^1]                       |
| cuda/10.2     | 10.2.89       | Yes                   | Yes                           | Yes[^1]                       |
| cuda/11.0     | 11.0.3        | Yes                   | Yes                           | Yes                           |
| cuda/11.1     | 11.1.1        | Yes                   | Yes                           | Yes                           |
| cuda/11.2     | 11.2.2        | Yes                   | Yes                           | Yes                           |
| cuda/11.3     | 11.3.1        | Yes                   | Yes                           | Yes                           |
| cuda/11.4     | 11.4.4        | Yes                   | Yes                           | Yes                           |
| cuda/11.5     | 11.5.2        | Yes                   | Yes                           | Yes                           |
| cuda/11.6     | 11.6.2        | Yes                   | Yes                           | Yes                           |

[^1]: Provided only for experimental use. NVIDIA A100 is supported on CUDA 11＋.

## cuDNN

Compute Node (V):

| Version | cuda/8.0 | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
| :------ | :------- | :------- | :------- | :------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 7.0.5   | Yes      | Yes      | Yes      | -        | -         | -         | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.1.4   | -        | Yes      | -        | Yes      | -         | -         | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.2.1   | -        | Yes      | -        | Yes      | -         | -         | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.3.1   | -        | Yes      | -        | Yes      | Yes       | -         | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.4.2   | -        | Yes      | -        | Yes      | Yes       | -         | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.5.1   | -        | Yes      | -        | Yes      | Yes       | Yes       | -         | -         | -         | -         | -         | -         | -         | -         |
| 7.6.5   | -        | Yes      | -        | Yes      | Yes       | Yes       | Yes       | -         | -         | -         | -         | -         | -         | -         |
| 8.0.5   | -        | -        | -        | -        | -         | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         | -         |
| 8.1.1   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 8.2.4   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | -         | -         |
| 8.3.3   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 8.4.0   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |

Compute Node (A):

| Version | cuda/10.0[^1] | cuda/10.1[^1] | cuda/10.2[^1] | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
| :------ | :------------ | :------------ | :------------ | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 7.3.1   | Yes           | -             | -             | -         | -         | -         | -         | -         | -         | -         |
| 7.4.2   | Yes           | -             | -             | -         | -         | -         | -         | -         | -         | -         |
| 7.5.1   | Yes           | Yes           | -             | -         | -         | -         | -         | -         | -         | -         |
| 7.6.5   | Yes           | Yes           | Yes           | -         | -         | -         | -         | -         | -         | -         |
| 8.0.5   | -             | Yes           | Yes           | Yes       | Yes       | -         | -         | -         | -         | -         |
| 8.1.1   | -             | -             | Yes           | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 8.2.4   | -             | -             | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | -         | -         |
| 8.3.3   | -             | -             | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |
| 8.4.0   | -             | -             | Yes           | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       | Yes       |

## NCCL

Compute Node (V):

| Version   | cuda/8.0 | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
| :-------- | :------- | :------- | :------- | :------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 2.4.8-1   | -        | -        | -        | Yes      | Yes       | Yes       | -         | -         | -         | -         | -         | -         | -         | -         |
| 2.5.6-1   | -        | Yes      | -        | -        | Yes       | Yes       | Yes       | -         | -         | -         | -         | -         | -         | -         |
| 2.6.4-1   | -        | -        | -        | -        | Yes       | Yes       | Yes       | -         | -         | -         | -         | -         | -         | -         |
| 2.7.8-1   | -        | -        | -        | -        | -         | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         | -         |
| 2.8.4-1   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 2.9.9-1   | -        | -        | -        | -        | -         | -         | Yes       | Yes       | -         | -         | Yes       | -         | -         | -         |
| 2.10.3-1  | -        | -        | -        | -        | -         | -         | Yes       | Yes       | -         | -         | -         | Yes       | -         | -         |
| 2.11.4-1  | -        | -        | -        | -        | -         | -         | Yes       | Yes       | -         | -         | -         | Yes       | Yes       | Yes       |
| 2.12.10-1 | -        | -        | -        | -        | -         | -         | Yes       | Yes       | -         | -         | -         | -         | -         | Yes       |

Compute Node (A):

| Version   | cuda/10.0[^1] | cuda/10.1[^1] | cuda/10.2[^1] | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
| :-------- | :------------ | :------------ | :------------ | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| 2.4.8-1   | Yes           | Yes           | -             | -         | -         | -         | -         | -         | -         | -         |
| 2.5.6-1   | Yes           | Yes           | Yes           | -         | -         | -         | -         | -         | -         | -         |
| 2.6.4-1   | Yes           | Yes           | Yes           | -         | -         | -         | -         | -         | -         | -         |
| 2.7.8-1   | -             | Yes           | Yes           | Yes       | Yes       | -         | -         | -         | -         | -         |
| 2.8.4-1   | -             | -             | Yes           | Yes       | Yes       | Yes       | -         | -         | -         | -         |
| 2.9.9-1   | -             | -             | Yes           | Yes       | -         | -         | Yes       | -         | -         | -         |
| 2.10.3-1  | -             | -             | Yes           | Yes       | -         | -         | -         | Yes       | -         | -         |
| 2.11.4-1  | -             | -             | Yes           | Yes       | -         | -         | -         | Yes       | Yes       | Yes       |
| 2.12.10-1 | -             | -             | Yes           | Yes       | -         | -         | -         | -         | -         | Yes       |

## GDRCopy

Compute Node (V):

| Version | cuda/9.0 | cuda/9.1 | cuda/9.2 | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.3 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

Compute Node (A):

| Version | cuda/10.0 | cuda/10.1 | cuda/10.2 | cuda/11.0 | cuda/11.1 | cuda/11.2 | cuda/11.3 | cuda/11.4 | cuda/11.5 | cuda/11.6 |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 2.3 | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |

## Changing GPU Compute Mode {#changing-gpu-compute-mode}

You can change GPU Compute Mode by using `-v GPU_COMPUTE_MODE=num` option. The following three Compute Modes can be specified.

| Option | Description |
|:--|:--|
|-v GPU\_COMPUTE\_MODE=0 | DEFAULT mode.<br>Multiple contexts are allowed per device. |
|-v GPU\_COMPUTE\_MODE=1 | EXCLUSIVE\_PROCESS mode.<br>Only one context is allowed per device, usable from multiple threads at a time. |
|-v GPU\_COMPUTE\_MODE=2 | PROHIBITED mode.<br>No contexts are allowed per device (no compute apps). |

Execution example in an interactive job:

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00 -v GPU_COMPUTE_MODE=1
```

Execution example in a batch job:

```bash
#!/bin/bash

#$ -l rt_F=1
#$ -l h_rt=1:00:00
#$ -j y
#$ -cwd
#$ -v GPU_COMPUTE_MODE=1
/usr/bin/nvidia-smi
```

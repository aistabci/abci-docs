
# Using GDS

[GPUDirect&reg; Storage (GDS)](https://developer.nvidia.com/gpudirect-storage) is available on the ABCI Compute Node (H).
GDS creates a direct data path between storage and GPU memory. By enabling a direct memory access (DMA) engine near the network adapter or storage, it allows data transfers to and from GPU memory without burdening the CPU.


## Using GDS

To use GDS, load the CUDA modules on Compute Node (H):

```
[username@hnode001 ~] module load cuda/12.6/12.6.1
```


### Example using GDS

The following is an example of GDS using a sample code of [MagnumIO](https://github.com/NVIDIA/MagnumIO).

First, load the CUDA modules and download the MagnumIO on Compute Node.

```
[username@login1 ~] qsub -I -P grpname -q rt_HG -l select=1 -l walltime=01:00:00
[username@hnode001 ~] module load cuda/12.6/12.6.1
[username@hnode001 ~] git clone https://github.com/NVIDIA/MagnumIO.git
```

Compile and run `cufile_sample_001.cc` using the `nvcc` command. Export environment variables as needed.

```
[username@hnode001 ~] cd MagnumIO/gds/samples/
[username@hnode001 ~] nvcc cufile_sample_001.cc -lcuda -lcufile -o cufile_sample_001
[username@hnode001 ~] export CUFILE_FORCE_COMPAT_MODE=false
[username@hnode001 ~] export CUFILE_ALLOW_COMPAT_MODE=false
[username@hnode001 ~] ./cufile_sample_001 testfile 0
opening file testfile
registering device memory of size :131072
writing from device memory
written bytes :131072
deregistering device memory
[username@hnode001 ~]
[username@hnode001 ~] head cufile.log
 06-02-2025 18:40:12:767 [pid=2528915 tid=2528915] INFO   0:314 Lib being used for urcup concurrency :  liburcu-bp.so.6
 06-02-2025 18:40:12:768 [pid=2528915 tid=2528915] INFO   0:152 Lib being used for concurrency :  liburcu-cds.so.6
 06-02-2025 18:40:12:768 [pid=2528915 tid=2528915] INFO   cufio_core:650 Loaded successfully URCU library
 06-02-2025 18:40:12:770 [pid=2528915 tid=2528915] INFO   0:163 nvidia_fs driver open invoked
 06-02-2025 18:40:12:774 [pid=2528915 tid=2528915] INFO   cufio-drv:408 GDS release version: 1.11.1.6
 06-02-2025 18:40:12:774 [pid=2528915 tid=2528915] INFO   cufio-drv:411 nvidia_fs version:  2.22 libcufile version: 2.12
 06-02-2025 18:40:12:774 [pid=2528915 tid=2528915] INFO   cufio-drv:415 Platform: x86_64
 06-02-2025 18:40:12:774 [pid=2528915 tid=2528915] INFO   cufio-drv:297 NVMe: driver support OK
 06-02-2025 18:40:12:774 [pid=2528915 tid=2528915] INFO   cufio-drv:328 DDN EXAScaler: lustre driver support OK
```


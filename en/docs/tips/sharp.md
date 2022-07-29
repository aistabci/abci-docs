
# Using SHARP

ABCI provides Scalable Hierarchical Aggregation and Reduction Protocol (SHARP)&trade;.

Using SHARP improves the performance of collective operations in MPI and machine learning, offloading collective operations from the CPU or GPU to the network, and eliminating the need to repeatedly send data between endpoints.


## Using SHARP with NVIDIA NCCL

You can use SHARP with NVIDIA NCCL. To use SHARP with NVIDIA NCCL, use the NCCL-SHARP plugin.

ABCI provides the NCCL-SHARP plugin as a module for the Compute Node (A).
The corresponding module of the plugin changes depending on the version of NCCL. Refer to the following table for the correspondence between plugins and NCCL.

!!! note
    The NCCL-SHARP plugin is provided on a trial basis and performance and operation are not guaranteed.

| NCCL-SHARP plugin module                 | NCCL versions        |
| ---------------------------------------- | -------------------- |
| `nccl-rdma-sharp-plugins/v2.1.x-5f238fb` | 2.8、2.9、2.10、2.11 |
| `nccl-rdma-sharp-plugins/v2.2.x-5e6ed3e` | 2.12                 |

To use SHARP with NCCL, load the CUDA, NCCL and NCCL SHARP plugin modules and set the following environment variables:

```
[username@es-a1 ~] module load cuda/11.0 nccl/2.8 nccl-rdma-sharp-plugins/v2.1.x-5f238fb
```

* `NCCL_COLLNET_ENABLE=1`
* `SHARP_COLL_LOCK_ON_COMM_INIT=1`
* `SHARP_COLL_NUM_COLL_GROUP_RESOURCE_ALLOC_THRESHOLD=0`
* (Optional) `SHARP_COLL_LOG_LEVEL=3`

### Example using nccl-tests

The following is an example of enabling SHARP on NCCL using [nccl-tests](https://github.com/NVIDIA/nccl-tests)).

First, download nccl-tests, enable MPI support, and then build.

```
[username@es-a1 ~] module load openmpi/4.1.3 cuda/11.0 nccl/2.8
[username@es-a1 ~] git clone https://github.com/NVIDIA/nccl-tests.git
[username@es-a1 ~] cd nccl-tests
[username@es-a1 ~] make MPI=1 MPI_HOME=${OMPI_HOME} CUDA_HOME=${CUDA_HOME} NCCL_HOME=${NCCL_HOME}
```

After building, a binary will be generated under the `build` directory, so execute this using `mpirun`.

```
[username@es-a1 ~] qrsh -g group -l rt_AF=2 -l h_rt=01:00:00
[username@a0000 ~] module load openmpi/4.1.3 cuda/11.0 nccl/2.8 nccl-rdma-sharp-plugins/v2.1.x-5f238fb
[username@a0000 ~] cd nccl-tests
[username@a0000 ~] mpirun -np 16 -map-by ppr:8:node \
-x UCX_TLS=dc,shm,self \
-x LD_LIBRARY_PATH=${LD_LIBRARY_PATH} \
-x NCCL_COLLNET_ENABLE=1 \
-x SHARP_COLL_LOCK_ON_COMM_INIT=1 \
-x SHARP_COLL_NUM_COLL_GROUP_RESOURCE_ALLOC_THRESHOLD=0 \
-x SHARP_COLL_LOG_LEVEL=3 \
./build/all_reduce_perf -b 8 -e 2G -f 2 -g 1 -w 50 -n 50

# nThread 1 nGpus 1 minBytes 8 maxBytes 2147483648 step: 2(factor) warmup iters: 50 iters: 50 validation: 1 
#
# Using devices
#   Rank  0 Pid 2916721 on      a0000 device  0 [0x27] NVIDIA A100-SXM4-40GB
#   Rank  1 Pid 2916722 on      a0000 device  1 [0x2a] NVIDIA A100-SXM4-40GB
#   Rank  2 Pid 2916723 on      a0000 device  2 [0x51] NVIDIA A100-SXM4-40GB
#   Rank  3 Pid 2916724 on      a0000 device  3 [0x57] NVIDIA A100-SXM4-40GB
#   Rank  4 Pid 2916725 on      a0000 device  4 [0x9e] NVIDIA A100-SXM4-40GB
#   Rank  5 Pid 2916726 on      a0000 device  5 [0xa4] NVIDIA A100-SXM4-40GB
#   Rank  6 Pid 2916727 on      a0000 device  6 [0xc7] NVIDIA A100-SXM4-40GB
#   Rank  7 Pid 2916728 on      a0000 device  7 [0xca] NVIDIA A100-SXM4-40GB
#   Rank  8 Pid 3868300 on      a0001 device  0 [0x27] NVIDIA A100-SXM4-40GB
#   Rank  9 Pid 3868301 on      a0001 device  1 [0x2a] NVIDIA A100-SXM4-40GB
#   Rank 10 Pid 3868302 on      a0001 device  2 [0x51] NVIDIA A100-SXM4-40GB
#   Rank 11 Pid 3868303 on      a0001 device  3 [0x57] NVIDIA A100-SXM4-40GB
#   Rank 12 Pid 3868304 on      a0001 device  4 [0x9e] NVIDIA A100-SXM4-40GB
#   Rank 13 Pid 3868305 on      a0001 device  5 [0xa4] NVIDIA A100-SXM4-40GB
#   Rank 14 Pid 3868306 on      a0001 device  6 [0xc7] NVIDIA A100-SXM4-40GB
#   Rank 15 Pid 3868307 on      a0001 device  7 [0xca] NVIDIA A100-SXM4-40GB
[a0000:0:2916721 - context.c:589] INFO job (ID: 2838387367436317) resource request quota: ( osts:0 user_data_per_ost:0 max_groups:0 max_qps:1 max_group_channels:1, num_trees:1)
[a0000:0:2916721 - context.c:759] INFO tree_info: type:LLT tree idx:0 treeID:0x0 caps:0x6 quota: ( osts:167 user_data_per_ost:1024 max_groups:167 max_qps:1 max_group_channels:1)
--(snip)--
#
#                                                       out-of-place                       in-place          
#       size         count      type   redop     time   algbw   busbw  error     time   algbw   busbw  error
#        (B)    (elements)                       (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)       
           8             2     float     sum    22.54    0.00    0.00  4e-07    24.94    0.00    0.00  4e-07
          16             4     float     sum    23.66    0.00    0.00  4e-07    24.72    0.00    0.00  1e-07
          32             8     float     sum    24.62    0.00    0.00  1e-07    23.51    0.00    0.00  1e-07
          64            16     float     sum    24.10    0.00    0.00  1e-07    23.54    0.00    0.01  1e-07
         128            32     float     sum    22.98    0.01    0.01  1e-07    22.58    0.01    0.01  1e-07
         256            64     float     sum    24.35    0.01    0.02  1e-07    24.08    0.01    0.02  1e-07
         512           128     float     sum    25.48    0.02    0.04  1e-07    25.99    0.02    0.04  1e-07
        1024           256     float     sum    34.96    0.03    0.05  4e-07    35.66    0.03    0.05  4e-07
        2048           512     float     sum    35.83    0.06    0.11  4e-07    34.95    0.06    0.11  4e-07
        4096          1024     float     sum    35.33    0.12    0.22  5e-07    34.38    0.12    0.22  5e-07
        8192          2048     float     sum    37.07    0.22    0.41  5e-07    35.50    0.23    0.43  5e-07
       16384          4096     float     sum    39.64    0.41    0.77  5e-07    39.44    0.42    0.78  5e-07
       32768          8192     float     sum    45.63    0.72    1.35  5e-07    44.35    0.74    1.39  5e-07
       65536         16384     float     sum    52.22    1.26    2.35  5e-07    50.17    1.31    2.45  5e-07
      131072         32768     float     sum    63.21    2.07    3.89  5e-07    59.93    2.19    4.10  5e-07
      262144         65536     float     sum    78.91    3.32    6.23  5e-07    77.77    3.37    6.32  5e-07
      524288        131072     float     sum    118.5    4.43    8.30  5e-07    117.8    4.45    8.34  5e-07
     1048576        262144     float     sum    177.0    5.93   11.11  5e-07    174.8    6.00   11.25  5e-07
     2097152        524288     float     sum    215.2    9.75   18.28  5e-07    215.7    9.72   18.23  5e-07
     4194304       1048576     float     sum    275.5   15.22   28.55  5e-07    275.3   15.24   28.57  5e-07
     8388608       2097152     float     sum    387.0   21.67   40.64  5e-07    382.6   21.92   41.11  5e-07
    16777216       4194304     float     sum    549.8   30.51   57.21  5e-07    548.9   30.56   57.30  5e-07
    33554432       8388608     float     sum    870.1   38.56   72.31  5e-07    866.8   38.71   72.58  5e-07
    67108864      16777216     float     sum   1491.4   45.00   84.37  5e-07   1487.8   45.11   84.58  5e-07
   134217728      33554432     float     sum   2587.4   51.87   97.26  5e-07   2581.4   51.99   97.49  5e-07
   268435456      67108864     float     sum   5207.5   51.55   96.65  5e-07   5194.4   51.68   96.90  5e-07
   536870912     134217728     float     sum   9979.3   53.80  100.87  5e-07   9930.5   54.06  101.37  5e-07
  1073741824     268435456     float     sum    19340   55.52  104.10  5e-07    19335   55.53  104.13  5e-07
  2147483648     536870912     float     sum    38180   56.25  105.46  5e-07    38163   56.27  105.51  5e-07
# Out of bounds values : 0 OK
# Avg bus bandwidth    : 29.0317 
#
```


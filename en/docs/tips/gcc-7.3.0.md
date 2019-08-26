# GCC 7.3.0

ABCI provides GCC 4.8.5 (default) and GCC 7.3.0 (experimental), but [Environment Modules](../05.md) does not support the latter version (As of May 2019).

To enable GCC 7.3.0, you need to explicitly set environment variables as follows:

```
[username@g0001 ~]$ export PATH=/apps/gcc/7.3.0/bin:$PATH
[username@g0001 ~]$ export LD_LIBRARY_PATH=/apps/gcc/7.3.0/lib64:$LD_LIBRARY_PATH
```

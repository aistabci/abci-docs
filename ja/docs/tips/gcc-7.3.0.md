# GCC 7.3.0 の利用

ABCIには標準のGCC 4.8.5の他に、GCC 7.3.0が試験的にインストールされていますが、[Environment Modules](../05.md)が提供されていません（2019年5月時点）。

下記のように明示的に環境変数を設定することで、GCC 7.3.0を利用することができます。

```
[username@g0001 ~]$ export PATH=/apps/gcc/7.3.0/bin:$PATH
[username@g0001 ~]$ export LD_LIBRARY_PATH=/apps/gcc/7.3.0/lib64:$LD_LIBRARY_PATH
```

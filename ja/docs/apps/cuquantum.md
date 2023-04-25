
# cuQuantum Appliance

## cuQuantum Applianceについて

NVIDIA cuQuantumは、量子回路シミュレーションをGPUで加速できるソフトウェア開発キットです。
量子回路シミュレーションとしては、IBM Qiskit Aer、Google Cirq qsimに対応しています。

NVIDIA cuQuantum Applianceは、NVIDIA cuQuantumを簡単に利用できるようデプロイ可能なソフトウェアとしてコンテナ化されたもので、複数のGPUと複数のノードを活用して量子回路シミュレーションを実行することができます。

本ドキュメントでは、次の流れに沿ってcuQuantum Applianceの使い方について説明します。

1. cuQuantum ApplianceをABCIで実行可能なSingularityイメージに変換する。
2. IBM Qiskit Aerの状態ベクトルシミュレーションをシングルノード・マルチGPUで実行する。
3. CUDA-aware Open MPIを用いて、状態ベクトルシミュレーションをマルチノード・マルチGPUで実行する。

## cuQuantum ApplianceをSingularityイメージに変換する

NVIDIA NGC(以下「NGC」という)で公開されているcuQuantum ApplianceのDockerイメージからSingularityイメージを作成します。

まず、インタラクティブジョブを投入し計算ノードにログインします。
計算ノードにログインした後、`singularitypro`モジュールをロードします。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
```

次に、NGCが提供するcuQuantum Appliance Dockerイメージを、`cuquantum-appliance.img`(名前は任意)として、`singularity pull`します。

```
[username@g0001 ~]$ SINGULARITY_TMPDIR=$SGE_LOCALDIR singularity pull cuquantum-appliance.img docker://nvcr.io/nvidia/cuquantum-appliance:23.03
```

singularity build/pullコマンドは一時ファイルの作成場所として`/tmp`を使用します。
cuQuantum Applianceは、イメージサイズの大きいコンテナで、計算ノード上でsingularity build/pullする際に`/tmp`の容量が足りずエラーになります。
そこで、ローカルスクラッチを使用するよう`SINGULARITY_TMPDIR`環境変数を設定しています。

作成したSingularityイメージ`cuquantum-appliance.img`を利用する方法は以下のとおりです。

```
[username@g0001 ~]$ singularity run ./cuquantum-appliance.img
```

以下のように、cuQuantum Applianceが起動します。

```
================================
== NVIDIA cuQuantum Appliance ==
================================

NVIDIA cuQuantum Appliance 23.03

Copyright (c) NVIDIA CORPORATION & AFFILIATES.  All rights reserved.

Singularity>
```

## シングルノード・マルチGPUで実行する

### バッチジョブでの実行

cuQuantum ApplianceのDockerコンテナには、Open MPIがインストールされています。
シングルノードでは、それを使って、マルチGPUでシミュレーションが実行できます。

ここでは、cuQuantum Applianceのドキュメントに掲載されている[サンプルプログラム](https://docs.nvidia.com/cuda/cuquantum/appliance/qiskit.html#getting-started)を、`ghz.py`として保存したものを実行しています。

```python
from qiskit import QuantumCircuit, transpile
from qiskit import Aer

def create_ghz_circuit(n_qubits):
    circuit = QuantumCircuit(n_qubits)
    circuit.h(0)
    for qubit in range(n_qubits - 1):
        circuit.cx(qubit, qubit + 1)
    return circuit

simulator = Aer.get_backend('aer_simulator_statevector')
circuit = create_ghz_circuit(n_qubits=20)
circuit.measure_all()
circuit = transpile(circuit, simulator)
job = simulator.run(circuit)
result = job.result()

if result.mpi_rank == 0:
    print(result.get_counts())
    print(f'backend: {result.backend_name}')
```

バッチスクリプト`job.sh`(名前は任意)を用意し、ジョブを投入します。

```
[username@es1 ~]$ cat job.sh
#!/bin/sh
#$-l rt_F=1
#$-j y
#$-cwd
source /etc/profile.d/modules.sh
module load singularitypro
export UCX_WARN_UNUSED_ENV_VARS=n # suppress UCX warning
singularity exec --nv cuquantum-appliance.img mpiexec -n 4 python3 ghz.py

[username@es1 ~]$ qsub -g grpname job.sh
```

結果は、以下の通りです。

```
{'11111111111111111111': 501, '00000000000000000000': 523}
backend: cusvaer_simulator_statevector
```


## マルチノード・マルチGPUで実行する

ABCIが提供しているOpen MPIは、cuQuantum Applianceに同梱されているCUDA-aware Open MPIと互換性がありません。
マルチノードでの実行を行うには、同一バージョンのCUDA-aware Open MPIが必要になります。
CUDA-aware Open MPIをソースコードからコンパイル、インストールするためにSpackを利用します。

### SpackによるCUDA-aware Open MPIのインストール

[Spackによるソフトウェア管理](../tips/spack.md)にもとづいて、CUDA-aware Open MPIをインストールします。

#### Spack環境設定

SpackをGitHubからcloneし、使用するバージョンをcheckoutします。

```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.19.2
```

!!! note
    2023年4月時点の最新バージョンである v0.19.2を用います。

以降はターミナル上で、Spackを有効化するスクリプトを読み込めば、Spackが使えます。

```
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

次に、コンパイラを見つけます。

```
[username@es1 ~]$ spack compiler find
==> Added 2 new compilers to /home/username/.spack/linux/compilers.yaml
    gcc@8.5.0  clang@13.0.1
==> Compilers are defined in the following files:
    /home/username/.spack/linux/compilers.yaml
```

#### ABCIソフトウェアの登録

Spackはソフトウェアの依存関係を解決して、依存するソフトウェアも自動的にインストールします。
ディスクスペースの浪費となりますので、ABCIが提供するソフトウェアは、Spackから参照するように設定します。

Spackが参照するソフトウェアの設定は`$HOME/.spack/linux/packages.yaml`に定義します。
ABCIで提供するCUDA、cmake等の設定を記載した設定ファイル(packages.yaml)をユーザ環境にコピーすることでABCIのソフトウェアを参照することができます。

計算ノード(V):

```
[username@es1 ~]$ cp /apps/spack/vnode/packages.yaml ${HOME}/.spack/linux/
```

計算ノード(A):

```
[username@es-a1 ~]$ cp /apps/spack/anode/packages.yaml ${HOME}/.spack/linux/
```

#### CUDA-aware Open MPIのインストール

GPUを搭載する計算ノード上でインストール作業を行うため、インタラクティブジョブを投入し計算ノードにログインします。

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
```

CUDAとcuQuantum Applianceが必要とする通信ライブラリUCXを、バージョンを指定してインストールします。

```
[username@g0001 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
[username@g0001 ~]$ spack install cuda@11.8.0
[username@g0001 ~]$ spack install ucx@1.13.1
```

Open MPIを、CUDA-awareでインストールします。スケジューラは`SGE`、通信ライブラリは、`UCX`を指定します。

```
[username@g0001 ~]$ spack install openmpi@4.1.4 +cuda schedulers=sge fabrics=ucx ^cuda@11.8.0 ^ucx@1.13.1
```

### バッチジョブでの実行


ここでは、cuQuantum Applianceのドキュメントに掲載されている[サンプルプログラム](https://docs.nvidia.com/cuda/cuquantum/appliance/cusvaer.html#mpi4py-label)を、`ghz_mpi.py` として保存したものを実行しています。

```python
from qiskit import QuantumCircuit, transpile
from cusvaer.backends import StatevectorSimulator
# import mpi4py here to call MPI_Init()
from mpi4py import MPI

options = {
  'cusvaer_global_index_bits': [2, 1],
  'cusvaer_p2p_device_bits': 2,
  'precision': 'single'
}

def create_ghz_circuit(n_qubits):
    ghz = QuantumCircuit(n_qubits)
    ghz.h(0)
    for qubit in range(n_qubits - 1):
        ghz.cx(qubit, qubit + 1)
    ghz.measure_all()
    return ghz

circuit = create_ghz_circuit(33)

# Create StatevectorSimulator instead of using Aer.get_backend()
simulator = StatevectorSimulator()
simulator.set_options(**options)
circuit = transpile(circuit, simulator)
job = simulator.run(circuit)
result = job.result()

print(f"Result: rank: {result.mpi_rank}, size: {result.num_mpi_processes}")
```

計算ノード(V)2台を用いたジョブスクリプト `job.sh` を用意し、ジョブを投入します。

```
[username@es1 ~]$ cat job.sh
#!/bin/sh
#$-l rt_F=2
#$-j y
#$-cwd
source /etc/profile.d/modules.sh
module load singularitypro
source ${HOME}/spack/share/spack/setup-env.sh
spack load openmpi@4.1.4
export UCX_WARN_UNUSED_ENV_VARS=n # suppress UCX warning
MPIOPTS="-np 8 -map-by ppr:4:node -hostfile $SGE_JOB_HOSTLIST"
mpiexec $MPIOPTS singularity exec --nv cuquantum-appliance.img python3 ghz_mpi.py

[username@es1 ~]$ qsub -g grpname job.sh
```

結果は、以下の通りです。

```
Result: rank: 3, size: 8
Result: rank: 1, size: 8
Result: rank: 7, size: 8
Result: rank: 5, size: 8
Result: rank: 4, size: 8
Result: rank: 6, size: 8
Result: rank: 2, size: 8
Result: rank: 0, size: 8
```

ここでは、`rt_F=2`として、計算ノード(V)を資源タイプFullで2台起動しています。
それに対応して、以下のようにオプションを設定しています。

```
options = {
  'cusvaer_global_index_bits': [2, 1],
  'cusvaer_p2p_device_bits': 2,
  'precision': 'single' 
}
```

#### cusvaer_global_index_bits

> `cusvaer_global_index_bits`オプションは、ノード間のネットワーク構造を表す正の整数のリストです。
>
> クラスタ内で8ノードが高速通信を行うと仮定し、32ノードのシミュレーションを行った場合、cusvaer_global_index_bitsの値は`[3, 2]`です。
> 最初の3は`log2(8)`で、高速通信を行う8ノードを表し、状態ベクトルの3量子ビットに相当します。
> 2番目の2は、32ノードの中に4つの8ノードグループがあることを意味します。
> global_index_bitsの要素の合計は5であり、これはノードの数が`32 = 2^5`であることを意味します。

計算ノード(V)では、1ノードにGPUが4台搭載されています。
ここで言われているクラスタ内で4ノードが高速通信をしています。
計算ノード(V)を2ノード起動していますので、2つの4ノードグループがあることになります。
したがって、`'cusvaer_global_index_bits': [2, 1]` と設定しています。


#### cusvaer_p2p_device_bits

> cusvaer_p2p_device_bitsオプションは、GPUDirect P2Pを使用して通信できるGPUの数を指定します。
>
> DGX A100などの8GPUノードの場合、`log2(8) = 3`となります。
>
> GPUDirectのP2Pネットワークはクラスタ内で最も高速であるため、cusvaer_p2p_device_bitsの値は通常、cusvaer_global_index_bitsの最初の要
素と同じです。

計算ノード(V)は、1ノードにGPUが4台搭載されているので、`'cusvaer_p2p_device_bits': 2` となります。

また、演算精度は、 `'precision': 'single'` として、`complex64`を使用しています。

オプションの詳細は、[cuQuantum Applianceのドキュメント](https://docs.nvidia.com/cuda/cuquantum/appliance/cusvaer.html#specifying-device-network-structure)を参照してください。


## 参考

1. [NVIDIA cuQuantum Appliance](https://docs.nvidia.com/cuda/cuquantum/appliance/index.html)
2. [NVIDIA cuQuantum Appliance で大規模にクラス最高の量子回路シミュレーションを実現](https://developer.nvidia.com/ja-jp/blog/best-in-class-quantum-circuit-simulation-at-scale-with-nvidia-cuquantum-appliance/)
3. [ABCI 2.0 User Guide | Spackによるソフトウェア管理](https://docs.abci.ai/ja/tips/spack/)

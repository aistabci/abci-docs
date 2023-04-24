
# cuQuantum Appliance

## About cuQuantum Appliance

NVIDIA cuQuantum is a software development kit that enables acceleration of quantum circuit simulations on GPUs.
It supports IBM Qiskit Aer and Google Cirq qsim as quantum circuit simulation frameworks.

The NVIDIA cuQuantum Appliance is a containerized software that makes it easy to use NVIDIA cuQuantum and enables execution of quantum circuit simulations using multiple GPUs and nodes.

This document explains how to use cuQuantum Appliance according to the following flow.

1. Convert cuQuantum Appliance to Singularity image executable by ABCI.
2. Run it in an interactive job.
3. Run IBM Qiskit Aer state vector simulations on a single node and multiple GPUs.
4. Run state vector simulations with CUDA-aware Open MPI on multi-node multi-GPUs.

## Creating Singularity Images

Create a Singularity image from the cuQuantum Appliance Docker image available at NVIDIA NGC (hereafter referred to as NGC).

First, load the singularitypro module.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
```


Next, pull the cuQuantum Appliance Docker image provided by NGC as `cuquantum-appliance.img` (any name).

```
[username@g0001 ~]$ SINGULARITY_TMPDIR=$SGE_LOCALDIR singularity pull cuquantum-appliance.img docker://nvcr.io/nvidia/cuquantum-appliance:23.03
```

The singularity build/pull command uses `/tmp` as the location for temporary files.
The cuQuantum Appliance is a large container and singularity build/pull on a compute node will fail due to insufficient space in `/tmp`.
So we set the `SINGULARITY_TMPDIR` environment variable to use local scratch.

## Execution in interactive jobs

The following is how to use the created Singularity image `cuquantum-appliance.img` from an interactive job.

```
[username@es1 ~]$ qrsh -g grpname -l rt_F=1 -l h_rt=1:00:00
[username@g0001 ~]$ module load singularitypro
[username@g0001 ~]$ singularity run ./cuquantum-appliance.img
```

The cuQuantum Appliance will start as follows.

```
================================
== NVIDIA cuQuantum Appliance ==
================================

NVIDIA cuQuantum Appliance 23.03

Copyright (c) NVIDIA CORPORATION & AFFILIATES.  All rights reserved.

Singularity>
```

## Single node multi-GPU execution

### Execution in batch jobs

Open MPI is installed in the docker container of the cuQuantum Appliance.
On a single node, simulations can be run on multiple GPUs using it.

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

Here we are running [the sample program](https://docs.nvidia.com/cuda/cuquantum/appliance/qiskit.html#getting-started) from the cuQuantum Appliance documentation, saved as `ghz.py`.

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

The results are as follows.

```
{'11111111111111111111': 501, '00000000000000000000': 523}
backend: cusvaer_simulator_statevector
```


## Multi-node multi-GPU execution

The Open MPI provided by ABCI is not compatible with the CUDA-aware Open MPI included in the cuQuantum Appliance.
To perform multi-node execution, the same version of CUDA-aware Open MPI is required.
Using Spack, CUDA-aware Open MPI is compiled and installed from source code.

### Installing CUDA-aware Open MPI with Spack

Install Open MPI based on [Software Management with Spack](../tips/spack.md).

#### Build a Spack environment

Clone Spack from GitHub and checkout the version to be used.

```
[username@es1 ~]$ git clone https://github.com/spack/spack.git
[username@es1 ~]$ cd ./spack
[username@es1 ~/spack]$ git checkout v0.19.2
```

!!! note
    The latest version as of April 2023, v0.19.2, will be used.

After that, you can use Spack by loading the script that activates Spack on the terminal.

```
[username@es1 ~]$ source ${HOME}/spack/share/spack/setup-env.sh
```

Next, find a compiler.

```
[username@es1 ~]$ spack compiler find
==> Added 2 new compilers to /home/username/.spack/linux/compilers.yaml
    gcc@8.5.0  clang@13.0.1
==> Compilers are defined in the following files:
    /home/username/.spack/linux/compilers.yaml
```

#### Refer to the software in ABCI

Spack resolves software dependencies and automatically installs dependent software as well.
Since this is a waste of disk space, set up the software provided by ABCI to be referenced by Spack.

The configuration for the software referenced by Spack is defined in `$HOME/.spack/linux/packages.yaml`.
By copying the configuration file (packages.yaml) that includes settings for software such as CUDA and cmake provided by ABCI to the user environment, and setting it to reference ABCI's software.

Compute node (V):

```
[username@es1 ~]$ cp /apps/spack/vnode/packages.yaml ${HOME}/.spack/linux/
```

Compute node (A):

```
[username@es-a1 ~]$ cp /apps/spack/anode/packages.yaml ${HOME}/.spack/linux/
```

#### Installing CUDA-aware Open MPI

!!! note
    Work on a compute node equipped with a GPU.

Install CUDA and UCX, the communication library required by cuQuantum Appliance, specifying the version.

```
[username@g0001 ~]$ spack install cuda@11.8.0
[username@g0001 ~]$ spack install ucx@1.13.1
```


Install Open MPI with CUDA-aware. Specify `SGE` as the scheduler and `UCX` as the communication library.

```
[username@g0001 ~]$ spack install openmpi@4.1.4 +cuda schedulers=sge fabrics=ucx ^cuda@11.8.0 ^ucx@1.13.1
```

### Execution in batch jobs

An example job script using two compute nodes (V) is shown below.

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
mpiexec $MPIOPTS  singularity exec --nv cuquantum-appliance.img python3 ghz_mpi.py

[username@es1 ~]$ qsub -g grpname job.sh
```

Here we are running [the sample program](https://docs.nvidia.com/cuda/cuquantum/appliance/cusvaer.html#mpi4py-label) from the cuQuantum Appliance documentation, saved as `ghz_mpi.py`.

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

The results are as follows.

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

Here, the script starts two Full nodes in the compute node (V) with `rt_F=2`. Correspondingly, the options are set as follows:

```
options = {
  'cusvaer_global_index_bits': [2, 1],
  'cusvaer_p2p_device_bits': 2,
  'precision': 'single'
}
```

#### cusvaer_global_index_bits

`cusvaer_global_index_bits` is a list of positive integers that represents the inter-node network structure.

Assuming 8 nodes has faster communication network in a cluster, and running 32 node simulation, the value of `cusvaer_global_index_bits` is `[3, 2]`.
The first `3` is log2(8) representing **8** nodes with fast communication which corresponding to 3 qubits in the state vector.
The second `2` means **4** 8-node groups in 32 nodes.
The sum of the global_index_bits elements is 5, which means the number of nodes is `32 = 2^5`.

In a compute node (V), there are four GPUs per node.
The 4 nodes in the cluster are communicating at the high speeds mentioned in the description above.
Since we have two compute nodes (V) activated, we have two 4-node groups.
Therefore, we set `'cusvaer_global_index_bits': [2, 1]`.

#### cusvaer_p2p_device_bits

`cusvaer_p2p_device_bits` option is to specify the number of GPUs that can communicate by using GPUDirect P2P.

For compute nodes (V), `'cusvaer_p2p_device_bits': 2` since there are 4 GPUs on each node.
For 8 GPU node such as Compute Node (A), the number is `log2(8) = 3`.

The value of `cusvaer_p2p_device_bits` is typically the same as the first element of `cusvaer_global_index_bits` as the GPUDirect P2P network is typically the fastest in a cluster.

Also, for the calculation precision, `'precision': 'single'` is used, and `complex64` is used.

For more information on options, see [cuQuantum Appliance documentation](https://docs.nvidia.com/cuda/cuquantum/appliance/cusvaer.html#specifying-device-network-structure).


## Reference

1. [NVIDIA cuQuantum Appliance](https://docs.nvidia.com/cuda/cuquantum/appliance/index.html)
2. [Best-in-Class Quantum Circuit Simulation at Scale with NVIDIA cuQuantum Appliance](https://developer.nvidia.com/blog/best-in-class-quantum-circuit-simulation-at-scale-with-nvidia-cuquantum-appliance/)
3. [Software Management by Spack](../tips/spack.md)

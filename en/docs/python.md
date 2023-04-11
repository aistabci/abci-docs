# Python

## Available Python versions

[Python](https://www.python.org/) is available on the ABCI System.

To show available Python versions with using `module` command:

```
[username@es1 ~]$ module avail python

------------------ /apps/modules/modulefiles/rocky8/devtools ------------------
python/3.10/3.10.10 python/3.11/3.11.2
```

To set up one of available versions with using `module` command:

Example) Python 3.10.10:

```
[username@es1 ~]$ module load python/3.10/3.10.10
[username@es1 ~]$ python3 --version
Python 3.10.10
```

When using Python in the Memory-intensive Node environment, load the `gcc/12.2.0` module before the python module.

```
[username@m01 ~]$ module load gcc/12.2.0
[username@m01 ~]$ module load python/3.10/3.10.10
[username@m01 ~]$ python3 --version
Python 3.10.10
```

!!! note
    Users can install any python distributions (c.f., pyenv, conda) into their own home or group area. Please kindly note that such distributions are not eligible for the ABCI System support.

## Python Virtual Environments

The ABCI System does not allow users to modify the system environment. Instead, it supports users to create Python virtual environments and install necessary modules into them.

On ABCI, `venv` modules provide support for creating lightweight "virtual environments" with their own site directories, optionally isolated from system site directories.
Each virtual environment has its own Python binary (which matches the version of the binary that was used to create this environment) and can have its own independent set of installed Python packages in its site directories.

Creating virtual environments, we use `venv` for Python 3.

!!! note
    The Python virtual environment is not compatible between compute nodes (V) and compute nodes (A) because the compute nodes (V) and compute nodes (A) have different OS and software configurations.
    Therefore, the virtual environment used in the compute node (V) must be built in the compute node (V) (or interactive node (es)), and the environment used in the compute node(A) must be built in the compute node (A) (or interactive node (es-a)).

### venv

Below are examples of executing `venv`:

Example) Creation of a virtual environment

```
[username@es1 ~]$ module load python/3.10/3.10.10
[username@es1 ~]$ python3 -m venv work
```

Example) Activating a virtual environment

```
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ which python3
~/work/bin/python3
(work) [username@es1 ~]$ which pip3
~/work/bin/pip3
```

Example) Installing `numpy` to a virtual environment

```
(work) [username@es1 ~]$ pip3 install numpy
```

Example) Deactivating a virtual environment

```
(work) [username@es1 ~]$ deactivate
[username@es1 ~]$
```

## pip

[pip](https://pip.pypa.io/en/stable/) in the package management system for Python. You can use pip to install packages from [the Python Pakcage Index (PyPI)](https://pypi.org/), a repository of Python software.

```
$ pip <sub-command> [options]
```

| sub command | description |
|:--|:--|
| install *package* | install package |
| update *package* | update package |
| uninstall *package* | remove package |
| search *package* | search package |
| list | list installed packages |

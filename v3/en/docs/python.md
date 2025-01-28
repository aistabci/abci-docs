# Python

## Available Python versions

The system-installed [Python](https://www.python.org/) is available on the ABCI System.

To show available Python versions, use `python --version` command:

```
[username@login1 ~]$ python --version
Python 3.9.18
```

!!! note
    Users can install any python distributions (c.f., pyenv, conda) into their own home or group area. Please kindly note that such distributions are not eligible for the ABCI System support.

## Python Virtual Environments

The ABCI System does not allow users to modify the system environment. Instead, it supports users to create Python virtual environments and install necessary modules into them.

On ABCI, `venv` modules provide support for creating lightweight "virtual environments" with their own site directories, optionally isolated from system site directories.
Each virtual environment has its own Python binary (which matches the version of the binary that was used to create this environment) and can have its own independent set of installed Python packages in its site directories.

Creating virtual environments, we use `venv` for Python 3.

### venv

Below are examples of executing `venv`:

Example) Creation of a virtual environment

```
[username@login1 ~]$ python -m venv work
```

Example) Activating a virtual environment

```
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ which python
~/work/bin/python
(work) [username@login1 ~]$ which pip
~/work/bin/pip
```

Example) Installing `numpy` to a virtual environment

```
(work) [username@login1 ~]$ pip install numpy
```

Example) Deactivating a virtual environment

```
(work) [username@login1 ~]$ deactivate
[username@login1 ~]$
```

## pip

[pip](https://pip.pypa.io/en/stable/) in the package management system for Python. You can use pip to install packages from [the Python Pakcage Index (PyPI)](https://pypi.org/), a repository of Python software.

```
$ pip <sub-command> [options]
```

| sub command | description |
|:--|:--|
| install *package* | install package |
| install --upgrade *package* | upgrade package |
| uninstall *package* | remove package |
| list | list installed packages |

Below are examples of executing `pip`. Please execute the `pip` command within a [Python virtual environment](#python-virtual-environments).

Example) Installing a package with a specified version

```
$ pip install numpy==2.0.2
Collecting numpy==2.0.2
  Using cached numpy-2.0.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (19.5 MB)
Installing collected packages: numpy
Successfully installed numpy-2.0.2
```

Example) Listing installed packages

```
$ pip list
Package    Version
---------- -------
numpy      2.0.2
pip        21.2.3
setuptools 53.0.0
```
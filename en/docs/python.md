# Python

## Available Python versions

[Python](https://www.python.org/) is available on the ABCI System.

To show available Python versions with using `module avail` command:

```
[username@es1 ~]$ module avail python

------------------ /apps/modules/modulefiles/centos7/devtools ------------------
python/2.7/2.7.18  python/3.10/3.10.4 python/3.7/3.7.13  python/3.8/3.8.13
```

To set up one of available versions with using `module` command:

Example) Python 2.7.18:

```
[username@es1 ~]$ module load python/2.7/2.7.18
[username@es1 ~]$ python --version
Python 2.7.18
```

Example) Python 3.8.13:

For Compute (V) environment, load the `gcc/11.2.0` module first.

```
[username@es1 ~]$ module load gcc/11.2.0
[username@es1 ~]$ module load python/3.8/3.8.13
[username@es1 ~]$ python3 --version
Python 3.8.13
```

For Compute (A) environment, it is not necessary to load the gcc module.

```
[username@es-a1 ~]$ module load python/3.8/3.8.13
[username@es-a1 ~]$ python3 --version
Python 3.8.13
```

!!! note
    Users can install any python distributions (c.f., pyenv, conda) into their own home or group area. Please kindly note that such distributions are not eligible for the ABCI System support.

## Python Virtual Environments

The ABCI System does not allow users to modify the system environment. Instead, it supports users to create Python virtual environments and install necessary modules into them.

On ABCI, `virtualenv` and `venv` modules provide support for creating lightweight "virtual environments" with their own site directories, optionally isolated from system site directories.
Each virtual environment has its own Python binary (which matches the version of the binary that was used to create this environment) and can have its own independent set of installed Python packages in its site directories.

Creating virtual environments, we use `virtualenv` for Python 2 and `venv` for Python 3, respectively.

!!! note
    The Python virtual environment is not compatible between compute nodes (V) and compute nodes (A) because the compute nodes (V) and compute nodes (A) have different OS and software configurations.
    Therefore, the virtual environment used in the compute node (V) must be built in the compute node (V) (or interactive node (es)), and the environment used in the compute node(A) must be built in the compute node (A) (or interactive node (es-a)).

### virtualenv

Below are examples of executing `virtualenv`:

Example) Creation of a virtual environment

```
[username@es1 ~]$ module load python/2.7/2.7.18
[username@es1 ~]$ virtualenv env1
created virtual environment CPython2.7.18.final.0-64 in 1862ms
  creator CPython2Posix(dest=/home/username/env1, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, wheel=bundle, setuptools=bundle, via=copy, app_data_dir=/home/username/.local/share/virtualenv)
    added seed packages: pip==20.3.4, setuptools==44.1.1, wheel==0.36.2
  activators PythonActivator,CShellActivator,FishActivator,PowerShellActivator,BashActivator
```

Example) Activating a virtual environment

```
[username@es1 ~]$ source env1/bin/activate
(env1) [username@es1 ~]$
(env1) [username@es1 ~]$ which python
~/env1/bin/python
(env1) [username@es1 ~]$ which pip
~/env1/bin/pip
```

Example) Installing `numpy` to a virtual environment

```
(env1) [username@es1 ~]$ pip install numpy
```

Example) Deactivating a virtual environment

```
(env1) [username@es1 ~]$ deactivate
[username@es1 ~]$
```

### venv

Below are examples of executing `venv`:

Example) Creation of a virtual environment

```
[username@es1 ~]$ module load gcc/11.2.0 python/3.8/3.8.13
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

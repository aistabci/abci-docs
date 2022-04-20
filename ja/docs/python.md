# Python

## 利用できるPythonのバージョン {#available-python-versions}

ABCIシステムでは[Python](https://www.python.org/)を利用可能です。

利用できるPythonのバージョンは`module`コマンドで確認できます。

```
[username@es1 ~]$ module avail python

------------------ /apps/modules/modulefiles/centos7/devtools ------------------
python/2.7/2.7.18  python/3.10/3.10.4 python/3.7/3.7.13  python/3.8/3.8.13
```

以下のように利用環境を設定することで利用可能になります。

例) Python 2.7.18を利用する場合:

```
[username@es1 ~]$ module load python/2.7/2.7.18
[username@es1 ~]$ python --version
Python 2.7.18
```

例) Python 3.10.4を利用する場合:

計算ノード(V)環境でPython 3.8以上を利用する場合、`gcc/11.2.0`モジュールをpythonモジュールより先にロードしてください。

```
[username@es1 ~]$ module load gcc/11.2.0
[username@es1 ~]$ module load python/3.10/3.10.4
[username@es1 ~]$ python3 --version
Python 3.10.4
```

なお、計算ノード(A)環境の場合、gccモジュールのロードは不要です。

```
[username@es-a1 ~]$ module load python/3.10/3.10.4
[username@es-a1 ~]$ python3 --version
Python 3.10.4
```

!!! note
    pyenvやcondaなどのPythonディストリビューションを利用者のホーム領域やグループ領域にインストールすることも可能です。この場合はサポート範囲外となりますのでご了承ください。

## Python仮想環境 {#python-virtual-environments}

ABCIではシステム全体で使うPython実行環境に利用者が変更を加えることはできません。その代わりに、利用者はPython仮想環境を使って必要なモジュールを追加して利用することができます。

ABCIが提供する`virtualenv`や`venv`を使って、軽量な仮想環境を作ることできます。
このPython仮想環境には、仮想環境ごとのsiteディレクトリがあり、これはシステムのsiteディレクトリから分離させることができます。
それぞれの仮想環境には、固有の (仮想環境を作成するのに使ったバイナリのバージョンと同一の) Pythonバイナリがあり、
仮想環境ごとのsiteディレクトリに独立したPythonパッケージ群をインストールできます。

仮想環境を構築するには、Python 2系では`virtualenv`、Python 3系では`venv`モジュールをそれぞれ利用します。

!!! note
     計算ノード(V)と計算ノード(A)ではOSおよびソフトウェア構成が異なるため、Python仮想環境に互換性はありません。<br>
     そのため、計算ノード(V)で使用する仮想環境は計算ノード(V)(またはインタラクティブノード(es))で、計算ノード(A)で使用する環境は計算ノード(A)(またはインタラクティブノード(es-a))で構築する必要があります。

### virtualenv

`virtualenv`の使用例を以下に示します。

例) 仮想環境の作成

```
[username@es1 ~]$ module load python/2.7/2.7.18
[username@es1 ~]$ virtualenv env1
created virtual environment CPython2.7.18.final.0-64 in 1862ms
  creator CPython2Posix(dest=/home/username/env1, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, wheel=bundle, setuptools=bundle, via=copy, app_data_dir=/home/username/.local/share/virtualenv)
    added seed packages: pip==20.3.4, setuptools==44.1.1, wheel==0.37.0
  activators PythonActivator,CShellActivator,FishActivator,PowerShellActivator,BashActivator
```

例) 仮想環境の有効化

```
[username@es1 ~]$ source env1/bin/activate
(env1) [username@es1 ~]$
(env1) [username@es1 ~]$ which python
~/env1/bin/python
(env1) [username@es1 ~]$ which pip
~/env1/bin/pip
```

例) 仮想環境へ`numpy`をインストール

```
(env1) [username@es1 ~]$ pip install numpy
```

例) 仮想環境の無効化

```
(env1) [username@es1 ~]$ deactivate
[username@es1 ~]$
```

### venv

`venv`モジュールの使用例を以下に示します。

例) 仮想環境の作成

```
[username@es1 ~]$ module load gcc/11.2.0 python/3.10/3.10.4
[username@es1 ~]$ python3 -m venv work
```

例) 仮想環境の有効化

```
[username@es1 ~]$ source work/bin/activate
(work) [username@es1 ~]$ which python3
~/work/bin/python3
(work) [username@es1 ~]$ which pip3
~/work/bin/pip3
```

例) 仮想環境へ`numpy`をインストール

```
(work) [username@es1 ~]$ pip3 install numpy
```

例) 仮想環境の無効化

```
(work) [username@es1 ~]$ deactivate
[username@es1 ~]$
```

## pip

[pip](https://pip.pypa.io/en/stable/)はPythonのパッケージ管理ツールです。
利用者は、`pip`コマンドを用いることで容易にPythonソフトウェアのリポジトリ[the Python Pakcage Index (PyPI)](https://pypi.org/)からPythonパッケージをインストールできます。

```
$ pip <sub-command> [options]
```

| サブコマンド | 説明 |
|:--|:--|
| install *package* | パッケージをインストールする。 |
| update *package* | パッケージをアップデートする。 |
| uninstall *package* | パッケージをアンインストールする。 |
| search *package* | パッケージを検索する。 |
| list | インストール済みパッケージを表示する。 |

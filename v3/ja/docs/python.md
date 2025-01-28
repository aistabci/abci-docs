# Python

## 利用できるPythonのバージョン {#available-python-versions}

ABCIシステムではシステムにインストールされた[Python](https://www.python.org/)を利用可能です。

Pythonのバージョンは`python --version`で確認できます。

```
[username@login1 ~]$ python --version
Python 3.9.18
```

!!! note
    pyenvやcondaなどのPythonディストリビューションを利用者のホーム領域やグループ領域にインストールすることも可能です。この場合はサポート範囲外となりますのでご了承ください。

## Python仮想環境 {#python-virtual-environments}

ABCIではシステム全体で使うPython実行環境に利用者が変更を加えることはできません。その代わりに、利用者はPython仮想環境を使って必要なモジュールを追加して利用することができます。

ABCIが提供する`venv`を使って、軽量な仮想環境を作ることができます。
このPython仮想環境には、仮想環境ごとのsiteディレクトリがあり、これはシステムのsiteディレクトリから分離させることができます。
それぞれの仮想環境には、固有の (仮想環境を作成するのに使ったバイナリのバージョンと同一の) Pythonバイナリがあり、
仮想環境ごとのsiteディレクトリに独立したPythonパッケージ群をインストールできます。

仮想環境を構築するには、Python 3系では`venv`モジュールを利用します。

### venv

`venv`モジュールの使用例を以下に示します。

例) 仮想環境の作成

```
[username@login1 ~]$ python -m venv work
```

例) 仮想環境の有効化

```
[username@login1 ~]$ source work/bin/activate
(work) [username@login1 ~]$ which python
~/work/bin/python
(work) [username@login1 ~]$ which pip
~/work/bin/pip
```

例) 仮想環境へ`numpy`をインストール

```
(work) [username@login1 ~]$ pip install numpy
```

例) 仮想環境の無効化

```
(work) [username@login1 ~]$ deactivate
[username@login1 ~]$
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
| install --upgrade *package* | パッケージをアップグレードする。 |
| uninstall *package* | パッケージをアンインストールする。 |
| list | インストール済みパッケージを表示する。 |

`pip`コマンドの使用例を以下に示します。`pip`コマンドは、[Python仮想環境](#python-virtual-environments)上でご実施ください。

例) バージョンを指定してパッケージをインストール

```
$ pip install numpy==2.0.2
Collecting numpy==2.0.2
  Using cached numpy-2.0.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (19.5 MB)
Installing collected packages: numpy
Successfully installed numpy-2.0.2
```

例) インストール済みパッケージの表示

```
$ pip list
Package    Version
---------- -------
numpy      2.0.2
pip        21.2.3
setuptools 53.0.0
```
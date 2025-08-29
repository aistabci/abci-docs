# JupyterLabにPython仮想環境を追加する方法

ABCIのJupyterLabでは、自身で作成したPython仮想環境をメニューに追加・削除することが可能です。

ここではOpen OnDemand(OOD)のJupyterLabにPython仮想環境を追加する方法を示します。

## JupyterLabの起動 {#launch-jupyterlab}

OODにログインし、Interactive Apps：Jupyter(Normal)を実行します。
<img src="ood-jl-001.png" width="800">

ジョブを投入します。

<img src="ood-jl-002.png" width="800">

<img src="ood-jl-003.png" width="800">


ジョブが実行されましたら。「Connect to Jupyter」ボタンを押下します。
<img src="ood-jl-004.png" width="800">


ブラウザの新しいタブにJupyterLabが表示されます。
<img src="ood-jl-005.png" width="800">


## JupyterLabのメニューにPython仮想環境を追加 {#add-venv}

例としてPython仮想環境「work」を作成し、仮想環境「work」に「numpy」をインストールします。

JupyterLabのメニューより、「Other」-> 「Terminal」を起動します。
<img src="ood-jl-006.png" width="800">
<img src="ood-jl-007.png" width="800">

「Terminal」より以下のように実行し、仮想環境「work」を作成します。

Python仮想環境を作成します。
```
$ python3 -m venv work
$ source work/bin/activate
(work) $ pip install --upgrade pip
```
!!! Note
	カレントディレクトリに「work」ディレクトリが作成され、「work」ディレクトリ配下に仮想環境が構築されます。
<img src="ood-jl-008.png" width="800">


作成した仮想環境にipykernelをインストールし、JupyterLabメニューに表示されるように設定します。
```
(work) $ python3 -m pip install ipykernel
(work) $ python3 -m ipykernel install --user --name=work --display-name="Python 3 (work)" 
```

例として、作成した仮想環境「work」に「numpy」パッケージをインストールします。
```
(work) $ pip install numpy==2.2.2
```
<img src="ood-jl-009.png" width="800">

ブラウザのJupyterLabのタブをリロードすると作成した仮想環境「work」がメニューに表示されます。
<img src="ood-jl-010.png" width="800">
<br><br>

以下は、Python3 (ipykernel)でのnumpyプログラムの実行例です。

「Notebook」->「Python3 (ipykernel)」をクリックしNotebookを開きます。
Notebookを開いたあと次のPythonプログラムを入力してください。

```
# numpyライブラリをインポート
import numpy as np

# 整数型の配列を用意
arr_int32 = np.array([100, 200, 300, 400, 500], dtype=np.int32)
print(arr_int32)

# 浮動小数点数型の配列を用意
arr_float = np.array([0.1, 0.2, 0.3, 0.4, 0.5], dtype=np.float64)
print(arr_float)

# 配列同士の計算を + で表現できます
arr_sum = arr_int32 + arr_float
print(arr_sum)
```

Shift + Enterでプログラムを実行します。ただし、Python3 (ipykernel)環境ではnumpyをインストールしていないためエラーになります。

<img src="ood-jl-011.png" width="800">
<br><br>

次に、作成した仮想環境Python3 (work)でプログラムを実行します。

メニュー画面から今度は「Notebook」->「Python3 (work)」をクリックします。
Notebookを開いたあと先ほどのプログラムを入力してください。

Shift + Enterでプログラムを実行後、Python3 (work)環境にはnumpyをインストールしているのでプログラムが正しく実行されます。

<img src="ood-jl-012.png" width="800">
<br><br>

## JupyterLabのメニューからPython仮想環境を削除 {#del-venv}

JupyterLabのメニューからPython仮想環境を削除するには、以下のコマンドを実行することで削除できます。
```
jupyter kernelspec uninstall 仮想環境名
```


「Terminal」より以下のように実行し、仮想環境「work」を削除します。
```
$ jupyter kernelspec uninstall work
```

!!! Note
	仮想環境一覧を表示するには以下のコマンドを使用します。
	
	```
	$ jupyter kernelspec list
	```

ブラウザのJupyterLabのタブをリロードすると仮想環境「work」がメニューから削除されています。
<img src="ood-jl-013.png" width="800">

## Python仮想環境を削除 {#rm-venv}

「Python仮想環境を作成」で作成されたディレクトリを削除すると、完全に削除することができます。


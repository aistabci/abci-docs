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

Python仮想環境の作成
```
$ python3 -m venv work
$ source work/bin/activate
(work) $ pip install --upgrade pip
```
!!! Note
	カレントディレクトリに「work」ディレクトリが作成され、「work」ディレクトリ配下に仮想環境が構築されます。
<img src="ood-jl-008.png" width="800">


作成した仮想環境にipykernelをインストールし、JupyterLabメニューに表示されるように設定
```
(work) $ python3 -m pip install ipykernel
(work) $ python3 -m ipykernel install --user --name=work --display-name="Python 3 (work)" 
```

例として仮想環境に「numpy」をインストール
```
(work) $ pip install numpy==2.2.2
```
<img src="ood-jl-009.png" width="800">

ブラウザのJupyterLabのタブをリロードすると作成した仮想環境「work」がメニューに表示されます。
<img src="ood-jl-010.png" width="800">
<br><br>

python3(ipykernel)でのnumpyサンプルプログラム実行例


※numpyがインストールされていないので実行できない。
<img src="ood-jl-011.png" width="800">
<br><br>


作成した仮想環境python3(work)でのnumpyサンプルプログラム実行例

※numpyがインストールされているので実行できる。
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


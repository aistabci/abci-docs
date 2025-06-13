# Interactive Apps

インタラクティブアプリとは、ABCI計算ノード上で実行されるアプリケーションを、ブラウザ上で対話的に操作する仕組みです。

インタラクティブアプリ起動時には、ABCIグループと、ABCIの資源タイプを指定します。
インタラクティブアプリは、指定されたABCIグループのABCIポイントを消費して、指定された資源タイプの計算資源を使用する、バッチジョブとして起動されます。

ABCIの Open OnDemand では以下のインタラクティブアプリを提供します。

## Jupyter Lab {#jupyter}

対話型の開発環境である[Jupyter Lab](https://jupyter.org/)を提供します。
ABCIの計算ノードでJupyter Labを起動し、手元の作業PCのブラウザから操作できるようになります。

!!! caution
    Jupyter Lab起動のたびに、ホームディレクトリ以下の以下のパスに、Jupyter Lab起動のためのPython仮想環境を作成します。定期的に削除してください。

```
~/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/jupyter_app/output/
```


## VSCode {#vscode}

[VSCode(Visual Studio Code)](https://azure.microsoft.com/ja-jp/products/visual-studio-code)を提供します。ABCIの計算ノード上でVSCode serverを起動し、手元の作業PCのブラウザから操作できるようになります。

## Interactive Desktop {#interactive_desktop}

[Interactive Desktop(Xfce)](https://www.xfce.org/?lang=ja)環境を提供します。 ABCIの計算ノード上でvncserverを起動し、手元の作業PCのブラウザから操作できるようになります。
!!!info
    Interactive Desktopに接続後、ターミナルを起動しターミナルから以下の手順でGPUレンダリングが可能です。

    ```
    module load turbovnc;
    vglrun -d egl<GPU番号> <OpenGLコマンド>
    ```


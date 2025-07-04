# Interactive Apps

インタラクティブアプリとは、ABCI計算ノード上で実行されるアプリケーションを、ブラウザ上で対話的に操作する仕組みです。

インタラクティブアプリを利用するには、まずアプリ画面を表示し、ABCIグループと、ABCIの資源タイプ等を指定して「Launch」をクリックします。
インタラクティブアプリは、指定されたABCIグループのABCIポイントを消費するバッチジョブとして計算ノードで起動されます。
インタラクティブアプリのジョブが起動されると接続のためのリンクが画面に表示され、そのリンクをクリックすることで利用できます。

ABCIの Open OnDemand では以下のインタラクティブアプリを提供します。

## Jupyter Lab {#jupyter}

対話型の開発環境である[Jupyter Lab](https://jupyter.org/)を提供します。
ABCIの計算ノードでJupyter Labを起動し、手元の作業PCのブラウザから操作できるようになります。

!!! caution
    Jupyter Lab起動のたびに、ホームディレクトリ以下の以下のパスに、Jupyter Lab起動のためのPython仮想環境を作成します。定期的に削除してください。

    ```
    ~/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/jupyter_app/output/
    ```


## code-server {#code-server}

[code-server](https://github.com/coder/code-server)は[VS Code](https://github.com/Microsoft/vscode)をWebブラウザで利用できるようにするソフトウェアです。
ABCIの計算ノード上でcode-serverを起動し、手元の作業PCのブラウザから操作できるようになります。

## Interactive Desktop {#interactive_desktop}

[Interactive Desktop(Xfce)](https://www.xfce.org/?lang=ja)環境を提供します。 ABCIの計算ノード上でvncserverを起動し、手元の作業PCのブラウザから操作できるようになります。
!!!info
    Interactive Desktopに接続後、ターミナルを起動しターミナルから以下の手順でGPUレンダリングが可能です。

    ```
    module load turbovnc;
    vglrun -d egl<GPU番号> <OpenGLコマンド>
    ```


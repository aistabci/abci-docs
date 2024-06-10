# Interactive Apps

ABCIの Open OnDemand では以下のインタラクティブアプリを提供します。

## Jupyter Lab {#jupyter}

対話型の開発環境である[Jupyter Lab](https://jupyter.org/)を提供します。
ABCIの計算ノードでJupyter Labを起動し、手元の作業PCのブラウザから操作できるようになります。

!!! caution
    Jupyter Lab起動のたびに、ホームディレクトリ以下の以下のパスに、Jupyter Lab起動のためのPython仮想環境を作成します。定期的に削除してください。

    ```
    ~/ondemand/data/sys/dashboard/batch_connect_sys/jupyter/output/
    ```


## Qni {#qni}

ブラウザ上で動作する、対話型の量子回路設計・シミュレータである[Qni](https://qniapp.net/)を提供します。
ABCI上のQniは、ABCI計算ノードのGPUを用いたシミュレーションを提供します。

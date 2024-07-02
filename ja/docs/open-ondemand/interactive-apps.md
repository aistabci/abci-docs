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
    ~/ondemand/data/sys/dashboard/batch_connect_sys/jupyter/output/
    ```


## Qni {#qni}

ブラウザ上で動作する、対話型の量子回路設計・シミュレータである[Qni](https://qniapp.net/)を提供します。
ABCI上のQniは、ABCI計算ノードのGPUを用いたシミュレーションを提供します。

!!! caution
    QniはGPUを搭載した資源タイプでのみ動作します。

    Qniは1 GPUのみ使用します。複数GPU搭載する資源タイプを指定した場合、残りのGPUは使用されません。

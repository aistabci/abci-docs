# Open OnDemand

## 概要 {#overview}

[Open OnDemand (OOD)](https://openondemand.org/)はWebブラウザからABCIを使用するためのポータルサイトです。

以下の機能がWebブラウザ上で利用できるようになり、従来より簡単にABCIを使えるようになります。

- インタラクティブノードでのコンソール操作
- ホーム領域、グループ領域のファイル操作
- Jupyter Lab等のWebアプリケーションの利用


< TODO: 管理者向けメニューを取り除いた、OODトップページのスクリーンショット >


!!! caution
    Open OnDemandは試験的機能として公開しています。
    予告なくサービス変更したり、問い合わせには答えられない場合があります。


## ログイン方法 {#login}

< TODO: スクリーンショットを交えて説明 >


## アプリケーション {#applications}

Open OnDemandが提供する機能には、画面上部のメニューからアクセスできます。

[![Open OnDemand Application Menu](ood-menu.png)](ood-menu.png)

1. Files: ファイル操作をブラウザ上で行えます

2. Jobs: ジョブ編集・管理をブラウザ上で行えます

2. Clusters: インタラクティブノードのコンソールが開きます

3. Interactive Apps: 計算ノード上でWebアプリケーションを起動し、その画面をWebブラウザに転送します。<br>
   以下のアプリケーションを提供します。

     - [Jupyter Lab](https://jupyter.org/): 対話型の開発環境
     - [Qni](https://qniapp.net/): ブラウザ上で動作する、対話型の量子回路設計・シミュレータ。ABCI上のQniは、ABCI計算ノードのGPUを用いたシミュレーションを提供します。

4. AIHub: [AIHubのアプリケーション](aihub.md)

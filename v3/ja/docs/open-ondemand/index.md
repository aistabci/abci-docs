# Open OnDemand　（更新中）

## 概要 {#overview}

[Open OnDemand (OOD)](https://openondemand.org/)はWebブラウザからABCIを使用するためのポータルサイトです。

以下の機能がWebブラウザ上で利用できるようになり、より簡単にABCIを使えるようになります。

- インタラクティブノードでのコンソール操作
- ホーム領域、グループ領域のファイル操作
- Jupyter Lab等のWebアプリケーションの利用

![Open OnDemandトップページ](img/ondemand-top-page.png){width=640}

!!! caution
    Open OnDemandは試験的機能として公開しています。
    予告なくサービス変更する場合や、問い合わせへの回答に時間を要する場合があります。


## アプリケーション {#applications}

Open OnDemandが提供する機能には、画面上部のメニューからアクセスできます。

[![Open OnDemand Application Menu](ood-menu.png)](ood-menu.png)

1. **Files**: ファイル操作をブラウザ上で行えます

2. **Jobs**: ジョブ編集・管理をブラウザ上で行えます

3. **Clusters**: インタラクティブノードのコンソールが開きます

4. **Interactive Apps**: 計算ノード上でWebアプリケーションを起動し、その画面をWebブラウザに転送します。

5. **AI Hub**: AI HubはABCI上で大規模な汎用学習済みモデルの再利用等を行うためのツールやサービス群です。AI Hubを構成する機能の1つである、Mlflow Tracking Serverのデプロイを管理するアプリケーションを提供します。


## ABCI 2.0との機能互換性 {#compatibility}

ABCI 2.0との機能互換性を以下に示します。

| サービス名 | ABCI 2.0 | ABCI 3.0 | 
|:--|:---:|:---:|
| ホーム領域、グループ領域のファイル操作 | 〇 | 〇 | 
| ジョブ編集・管理 | 〇 | 〇 | 
| インタラクティブノードでのコンソール操作 | 〇 | 〇 | 
| Jupyter notebook | 〇 | 〇 | 
| Qni | 〇 | ×[^1] | 
| AI Hub | 〇 | ×[^1] | 

[^1]: 今後の実装を予定しています。
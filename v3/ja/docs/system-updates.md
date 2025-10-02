# システム更新履歴

## 2025-08-26 {#2025-08-26}

次のソフトウェアを追加しました。

* CUDA Toolkit 12.9.1
* cuDNN 9.12.0
* firefox (計算ノード)

一般利用者による NVIDIA GPU Performance Counters の利用を許可しました。

## 2025-08-08 {#2025-08-08}

GCC 13.2.0 を追加しました。

## 2025-08-05 {#2025-08-05}

ABCIクラウドストレージの説明文章を追記しました。

※ サービス開始は8月下旬を予定しています。サービス開始時点では、ABCI内部（ログインノードや計算ノード）からのみ利用可能で、外部（インターネットなど）からは利用できません。外部からの利用につきましては、準備が整い次第、改めてご案内申し上げます。

## 2025-07-25 {#2025-07-25}

qalter コマンドの利用者による使用を抑止しました。

## 2025-07-11 {#2025-07-11}

軽量版のqgstatである`qgstat_l`コマンドを提供しました。

## 2025-06-20 {#2025-06-20}

Open OnDemand のインタラクティブアプリに、次のアプリケーションを追加しました。

* code-server
* Interactive Desktop(Xfce)

## 2025-04-15 {#2025-04-15}

次の機能の実装をしました。

* ジョブ投入時のSSHアクセス制御オプション
    * `qsub`コマンドのオプション追加により、ジョブ実行中の計算ノードへのSSHログイン制御ができるようになりました。使い方の詳細は[ジョブ実行オプション](job-execution.md#job-execution-options)を参照してください。
* Open OnDemand Job Composer

以下のソフトウェア・アップデートを行いました。

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Lustre-client | 2.14.0_ddn196 | 2.14.0_ddn172 |
| Update | python (インタラクティブノード) | 3.9.21 | 3.9.18 |
| Add | python | 3.12.9 | |
| Add | python | 3.13.2 | |

データ移行のためにマウントしていたABCI 2.0のホーム領域(`/home-2.0`)を提供終了に伴いアンマウントしました。

## 2025-03-03 {#2025-03-03}

SingularityPROが利用可能となりました。使い方の詳細は[SingularityPROの利用方法](containers.md#how-to-use-singularitypro)を参照してください。

## 2025-01-31 {#2025-01-31}

`qrstat --available=grpname`機能の追加により、ノードの予約の空き状況を参照できるようになりました。使い方の詳細は[予約状態の確認](job-execution.md#show-the-status-of-reservations)を参照してください。

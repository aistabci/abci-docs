# システム更新履歴

## 2025-04-15 {#2025-04-15}

`qsub`コマンドのオプション追加により、ジョブ実行中の計算ノードへのSSHログイン制御ができるようになりました。使い方の詳細は[ジョブ実行オプション](job-execution.md#job-execution-options)を参照してください。

次の機能の実装を予定しています。

* ジョブ投入時のSSHアクセス制御オプション
* Open OnDemand Job Composer
* 下記Lustre clientのupdate

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Lustre-client | 2.14.0_ddn196 | 2.14.0_ddn172 |

## 2025-03-03 {#2025-03-03}

SingularityPROが利用可能となりました。使い方の詳細は[SingularityPROの利用方法](containers.md#how-to-use-singularitypro)を参照してください。

## 2025-01-31 {#2025-01-31}

`qrstat --available=grpname`機能の追加により、ノードの予約の空き状況を参照できるようになりました。使い方の詳細は[予約状態の確認](job-execution.md#show-the-status-of-reservations)を参照してください。

# はじめに

[AI橋渡しクラウド（AI Bridging Cloud Infrastructure、以下「ABCI」という）](https://abci.ai/ja/)は、[国立研究開発法人 産業技術総合研究所](https://www.aist.go.jp/)が構築・運用する、AI技術開発・橋渡しのためのオープンな計算インフラストラクチャです。ABCIは、2018年8月に本格運用を開始しました。

![ABCI Overview](img/abci_dc.jpg)

このユーザガイドは、ABCIの技術的詳細や利用方法について説明しています。ABCIを利用する方は是非ご一読ください。ABCIシステムについての理解を深めるのに役立ちます。

  - 利用手引き:
    - [1. ABCIシステムの概要](01.md)
    - [2. ABCIシステム利用環境](02.md)
    - [3. ジョブ実行環境](03.md)
    - [4. ストレージ](04.md)
    - [5. Environment Modules](05.md)
    - [6. Python](06.md)
    - [7. GPU](07.md)
    - [8. MPI](08.md)
    - [9. Linuxコンテナ](09.md)
    - [10. プログラム開発環境](10.md)
    - [付録. インストール済みソフトウェアの構成](appendix/installed-software.md)
    - [付録. HPCIによるABCIシステム利用](appendix/using-abci-with-hpci.md)
    - [付録. 外部ネットワークとの通信](appendix/external-networks.md)
  - 各種アプリケーション:
    - [概要](apps/index.md)
    - [TensorFlow](apps/tensorflow.md)
    - [TensorFlow Keras](apps/tensorflow-keras.md)
    - [PyTorch](apps/pytorch.md)
    - [MXNet](apps/mxnet.md)
    - [Chainer](apps/chainer.md)
    - [その他](apps/others.md)
  - Tips:
    - [リモートデスクトップの利用](tips/remote-desktop.md)
    - [AWS CLIの利用](tips/awscli.md)
    - [Tera Termの利用](tips/tera-term.md)
    - [PuTTYの利用](tips/putty.md)
    - [Jupyter Notebookの利用](tips/jupyter-notebook.md)
    - [Singularity Global Clientの利用](tips/sregistry-cli.md)
    - [Spackによるソフトウェア管理](tips/spack.md)
    - [データセットの利用](tips/datasets.md)
    - [Amazon ECR からコンテナ取得](tips/dl-amazon-ecr.md)
  - [NVIDIA NGC](ngc.md)
  - ABCI クラウドストレージ:
    - [概要](abci-cloudstorage.md)
    - [アカウントとアクセスキー](abci-cloudstorage/cs-account.md)
    - [使い方](abci-cloudstorage/usage.md)
    - [データの暗号化](abci-cloudstorage/encryption.md)
    - [アクセス制御（1）](abci-cloudstorage/acl.md)
    - [アクセス制御（2）](abci-cloudstorage/policy.md)
    - [データセットの公開](abci-cloudstorage/publishing-a-dataset.md)
  - [ABCI Singularity エンドポイント](abci-singularity-endpoint.md)
  - [FAQ](faq.md)
  - [既知の問題](known-issues.md)
  - [システム更新履歴](system-updates.md)
  - [運転状況](https://abci.ai/ja/about_abci/info.html)
  - [お問い合わせ](contact.md)

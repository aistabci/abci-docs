# 既知の問題

|日時|内容|状況|
|:--|:--|:--|
|2019/04/10|ジョブスケジューラのアップデート(8.5.4 -> 8.6.3)に伴い、以下のジョブ投入オプションは引数が必須になりました。<BR>リソースタイプ(-l rt_F等)<BR>$ qsub -g GROUP -l rt_F=1<BR>  $ qsub -g GROUP -l rt_G.small=1|対応完了|
|2019/04/10|ジョブスケジューラのアップデート(8.5.4 -> 8.6.3)に伴い、以下のジョブ投入オプションは引数が必須になりました。BEEOND使用する場合は、-l USE_BEEONDオプションに"1"を省略せず指定してください。<BR>BEEOND 実行 (-l USE_BEEOND)<BR>$ qsub -g GROUP -l rt_F=2 -l USE_BEEOND=1|対応完了|
|2019/04/05|通常計算ノードで rt_C.small/rt_G.small はそれぞれ最大で4ジョブまで実行されますが、ジョブスケジューラの不具合により、それぞれ最大2ジョブまでしか実行できない事象が発生しています。<br>Reservedサービスでも同様の事象が発生しており、rt_C.small/rt_G.small を使用の場合はご注意ください。<BR>$ qsub -ar ARID -l rt_G.small=1 -g GROUP run.sh (x 3回) <BR>$ qstat<BR>job-ID     prior   name       user         state<BR>--------<BR>    478583 0.25586 sample.sh  username   r<BR>    478584 0.25586 sample.sh  username   r<BR>    478586 0.25586 sample.sh  username   qw|対応中|

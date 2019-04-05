# 制限事項

|日時|制限事項|状況|
|:--|:--|:--|
|2019/04/05|通常計算ノードで rt_C.small/rt_G.small はそれぞれ最大で4ジョブまで実行されますが、ジョブスケジューラの不具合により、それぞれ最大2ジョブまでしか実行できない事象が発生しています。<br>Reservedサービスでも同様の事象が発生しており、rt_G.small/rt_G.small を使用の場合はご注意ください。<BR>$ qsub -ar ARID -l rt_G.small=1 -g GROUP run.sh (x 3回) <BR>$ qstat<BR>job-ID     prior   name       user         state<BR>--------<BR>    478583 0.25586 sample.sh  username   r<BR>    478584 0.25586 sample.sh  username   r<BR>    478586 0.25586 sample.sh  username   qw:待ち |対応中|

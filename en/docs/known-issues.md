# Known Issues

|date|content|status|
|:--|:--|:--| 
|2019/04/10| The following qsub option requires to specify argument due to job scheduler update (8.5.4 -> 8.6.3).<BR>resource type ( -l rt_F etc)<BR>$ qsub -g GROUP -l rt_F=1<BR>$ qsub -g GROUP -l rt_G.small=1|close|
|2019/04/10| The following qsub option requires to specify argument due to job scheduler update (8.5.4 -> 8.6.3).<BR>use BEEOND ( -l USE_BEEOND)<BR>$ qsub -g GROUP -l rt_F=2 -l USE_BEEOND=1|close|
|2019/04/05| Due to job scheduler update (8.5.4 -> 8.6.3), a comupte node can execute only up to 2 jobs each resource type "rt_G.small" and "rt_C.small" (normally up to 4 jobs ).This situation also occures with Reservation service, so to be careful when you submit job with "rt_G.small" or "rt_C.small".<BR>$ qsub -ar ARID -l rt_G.small=1 -g GROUP run.sh (x 3 times)<BR>$ qstat <BR>job-ID prior name user state<BR> --------<BR> 478583 0.25586 sample.sh username r<BR> 478584 0.25586 sample.sh username r<BR> 478586 0.25586 sample.sh username qw|open|


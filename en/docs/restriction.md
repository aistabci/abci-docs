# Restriction

|date|restriction|status|
|:--|:--|:--| 
|2019/04/05|Because of job scheduler trouble, a comupte node can execute only up to 2 jobs each resource type "rt_G.small" and "rt_C.small" (normally up to 4 jobs ).This situation also occures with Reservation service, so to be careful when you submit job with "rt_G.small" or "rt_C.small".<BR>$ qsub -ar ARID -l rt_G.small=1 -g GROUP run.sh (x 3 times)<BR>$ qstat <BR>job-ID prior name user state<BR> --------<BR> 478583 0.25586 sample.sh username r<BR> 478584 0.25586 sample.sh username r<BR> 478586 0.25586 sample.sh username qw|open|



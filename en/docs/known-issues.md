# Known Issues

| date | content | status |
|:--|:--|:--|
| 2019/10/04 | MPI_Allreduce provided by MVAPICH2-GDR 2.3.2 raises floating point exceptions in the following combinations of nodes, GPUs and message sizes when reduction between GPU memories is conducted.<BR>Nodes: 28, GPU/Node: 4, Message size: 256KB<BR>Nodes: 30, GPU/Node: 4, Message size: 256KB<BR>Nodes: 33, GPU/Node: 4, Message size: 256KB<BR>Nodes: 34, GPU/Node: 4, Message size: 256KB | Will be solved in the next version |
| 2019/04/10 | The following qsub option requires to specify argument due to job scheduler update (8.5.4 -> 8.6.3).<BR>resource type ( -l rt_F etc)<BR>$ qsub -g GROUP -l rt_F=1<BR>$ qsub -g GROUP -l rt_G.small=1 | close |
| 2019/04/10 | The following qsub option requires to specify argument due to job scheduler update (8.5.4 -> 8.6.3).<BR>use BEEOND ( -l USE_BEEOND)<BR>$ qsub -g GROUP -l rt_F=2 -l USE_BEEOND=1 | close |
| 2019/04/05 | Due to job scheduler update (8.5.4 -> 8.6.3), a comupte node can execute only up to 2 jobs each resource type "rt_G.small" and "rt_C.small" (normally up to 4 jobs ).This situation also occures with Reservation service, so to be careful when you submit job with "rt_G.small" or "rt_C.small".<BR>$ qsub -ar ARID -l rt_G.small=1 -g GROUP run.sh (x 3 times)<BR>$ qstat <BR>job-ID prior name user state<BR> --------<BR> 478583 0.25586 sample.sh username r<BR> 478584 0.25586 sample.sh username r<BR> 478586 0.25586 sample.sh username qw | 2019/10/04<br>close |

# System Updates

## 2025-10-23 {#2025-10-23}

Due to high job volume, we have temporarily adjusted the number of available nodes for reservation. We plan to revert them once the congestion eases.

| Item | Normal Setting Value | Setting Value for Peak Time | Notes |
|:--|:--|:--|:--|
| Minimum reservation days | 1 day | 1 day | No change |
| Maximum reservation days | 60 days | 60 days | No change |
| Maximum number of nodes can be reserved at once per ABCI group | 32 nodes | 16 nodes | |
| Maximum number of nodes can be reserved at once per system | 640 nodes | 16 nodes | |
| Minimum reserved nodes per reservation | 1 node | 1 node | No change |
| Maximum reserved nodes per reservation | 32 nodes | 16 nodes | |
| Maximum reserved node time per reservation | 10,752 nodes x hours | 5,376 nodes x hours | 16 nodes x 24 hours x 14 days = 5,376 |

## 2025-08-05 {#2025-08-05}

We have added a description for ABCI Cloud Storage to the manual.

\* The open day of the service for the users is expected to be in late August. Please note that ABCI Cloud Storage is only available within ABCI (login nodes and compute nodes) and is not currently available from external sources (such as the Internet). We will provide further information on external use as soon as it becomes available.

## 2025-07-25 {#2025-07-25}

Disabled the usage of qalter command by the users.

## 2025-07-11 {#2025-07-11}

We installed `qgstat_l` which is the lightweight version of qgstat.

## 2025-06-20 {#2025-06-20}

We have added the following applications as Open OnDemand Interactive Apps.

* code-server
* Interactive Desktop(Xfce)

## 2025-04-15 {#2025-04-15}

We implemented the following features:

* SSH access control option when submitting jobs
    * With the addition of the `qsub` command option, you can now control SSH login to compute nodes while a job is running. For detailed, please refer to [Job Execution Options](job-execution.md#job-execution-options).
* Open OnDemand Job Composer

The following software has been updated:

| Add / Update / Delete | Software | Version | Previous version |
|:--|:--|:--|:--|
| Update | Lustre-client | 2.14.0_ddn196 | 2.14.0_ddn172 |
| Update | python (Interactive Node) | 3.9.21 | 3.9.18 |
| Add | python | 3.12.9 | |
| Add | python | 3.13.2 | |

The ABCI 2.0 home area (`/home-2.0`) that was mounted for data migration has been unmounted due to the end of provision.

## 2025-03-03 {#2025-03-03}

SingularityPRO is now available. For detailed usage instructions, please refer to [How to use SingularityPRO](containers.md#how-to-use-singularitypro).

## 2025-01-31 {#2025-01-31}

With the addition of the `qrstat --available=grpname` feature, you can now check the availability of node reservations. For more details on how to use this feature, please refer to [show the status of reservations](job-execution.md#show-the-status-of-reservations).

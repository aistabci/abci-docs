
# Using /local on interactive nodes

On ABCI interactive nodes, /local is available as a local scratch area.
A directory called /local/groups/{ABCI group name} is created for each group, and users can create and use directories and files as needed under the directory of their group.

!!!note
    Note that /local exists for each interactive node and is not shared between interactive nodes (login1-login5) and compute nodes.

## Structure of /local

In addition to the user area (group directory), /local also contains areas used by the system, which are as follows:

| Path | Area | Description |
| :-- | :-- | :-- |
| /local/groups | User Area | Group directory |
| /local/pcc.groups | System Area | LPCC directory (LPCC: Hierarchical Persistent Client Caching for Lustre) |

Group directories are created under /local/groups.

## Group Directory

Each group directory is created under /local/groups, with the owner set to root, the group set to the group ID, and permissions set to 02770 (rwxrws---).
For example, the group directory for group gaa50000 is /local/groups/gaa50000.

```
[username@login1 ~]$ ls -ld /local/groups/gaa50000
drwxrws--- 5 root gaa50000 4096 Dec 15  2025 /local/groups/gaa50000
```

Since the set-group-ID permission is set, the group ID of new files created in the group directory inherits the group ID of the parent directory.

## Usage Limits (Quotas)

Each group directory has XFS project quotas to prevent unlimited use.

| Limit | Value | Description |
| :-- | :-- | :-- |
| bhard | 1TB | Hard limit on usable blocks. Users cannot use more blocks than the limit. |
| bsoft | N/A | Soft limit on usable blocks. Users can temporarily use more blocks than the limit. |
| ihard | N/A | Hard limit on usable inodes. Users cannot use more inodes than the limit. |
| isoft | N/A | Soft limit on usable inodes. Users can temporarily use more inodes than the limit. |

Due to the bhard limit, the total disk usage of files within each group directory cannot exceed 1TB.
Attempting to exceed this limit will result in an ENOSPC error (No space left on device (POSIX.1-2001)).

Please use it to avoid bhard limitations.
If you get stuck with the bhard limit, delete old or unnecessary files.

## How to check usage

Use the du command to check the usage of the group directory.

Example:
```
[username@login1 ~]$ du -sk /local/groups/gaa50000
```

## Automatic File Deletion

To optimize /local usage, monitor /local usage periodically and delete old files when the threshold is exceeded.

Currently, get /local utilization every hour and if it is greater than 75%, delete all files that have access times older than 7 days.

!!!note
    Deletion will not stop even if the usage drops below a certain level during deletion.
    On the other hand, old files will not be deleted unless usage rate exceeds 75%.

## How to Check File Access Time

You can check the file access time using the following methods:

(1) Using stat

```
$ stat file
```

Example:
```
[username@login1 gaa50000]$ stat sample.txt
  File: sample.txt
  Size: 0         	Blocks: 0          IO Block: 4194304 regular empty file
Device: 84f0b5a2h/2230367650d	Inode: 270216711578435798  Links: 1
Access: (0640/-rw-r-----)  Uid: (10000/username)   Gid: (50000/gaa50000)
Access: 2025-12-15 15:14:46.000000000 +0900
Modify: 2025-12-15 15:14:29.000000000 +0900
Change: 2025-12-15 15:14:40.000000000 +0900
 Birth: 2025-12-15 15:10:15.000000000 +0900
```

Access: This line shows the access time.

(2) Using ls

```
$ ls -l -u file
```

The -u option shows the access time rather than the modify time.

Example: Show access time
```
[username@login1 gaa50000]$ ls -l -u sample.txt
-rw-r----- 1 username gaa50000 0 Dec 15 15:14 sample.txt
```

Ref: Show modify time
```
[username@login1 gaa50000]$ ls -l sample.txt
-rw-r----- 1 username gaa50000 0 Dec 15 15:14 sample.txt
```

You can also specify the --full-time option to show the full time.

Example: Show the full access time.

```
[username@login1 gaa50000]$ ls -l -u --full-time sample.txt
-rw-r----- 1 username gaa50000 0 2025-12-15 15:14:46.000000000 +0900 sample.txt
```

Ref: Show the full modify time.
```
[username@login1 gaa50000]$ ls -l --full-time sample.txt
-rw-r----- 1 username gaa50000 0 2025-12-15 15:14:29.000000000 +0900 sample.txt
```

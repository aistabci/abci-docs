
# Using s3fs-fuse

ABCI provides an `s3fs-fuse` module that allows you to mount your ABCI Cloud Storage bucket as a local file system.
This section describes how to use the `s3fs-fuse` module.

## Access Key

An access key is required to use s3fs-fuse.

Please refer to [the ABCI Portal Guide](https://docs.abci.ai/v3/portal/ja/02/#283-csad) for how to issue an access key.
After issuing the access key, use the AWS CLI to set the access key. Please refer to [How to Use ABCI Cloud Storage](usage.md) for how to set the access key.

Here, it is assumed that the access key is set in the `default` profile.

## Loading module

After logging in to the interactive node, load the `s3fs-fuse` module.

```
[username@login1 ~]$ module load s3fs-fuse
```

## Creating bucket

Create a bucket for mounting.

```
[username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 mb s3://s3fs-bucket
make_bucket: s3fs-bucket
```

## Mounting bucket

`/tmp` on interactive nodes, `/tmp` on compute nodes, and local storage allocated to jobs (`$PBS_LOCALDIR`) can be used as mount points for `s3fs-fuse`.
Please use `/tmp` or the local storage allocated to the job (`$PBS_LOCALDIR`) as the mount point.


For the mount point, use `/tmp` or the local storage allocated to the job (`$PBS_LOCALDIR`).

The following explains how to mount a bucket using `/tmp` on the interactive node.

Create a mount point on the TMP directory and mount the `s3fs-bucket` bucket with the `s3fs` command.

```
[username@login1 ~]$ mkdir /tmp/s3fs_dir
[username@login1 ~]$ s3fs s3fs-bucket /tmp/s3fs_dir -o url=https://s3.v3.abci.ai/ -o use_path_request_style
```

If you want to use an access key other than the `default` profile, specify the` -o profile = profile name` option.

```
[username@login1 ~]$ s3fs s3fs-bucket /tmp/s3fs_dir -o url=https://s3.v3.abci.ai/ -o profile=aaa00000.2 -o use_path_request_style
```

## Verifying mount

To verify that the mount was successful, use the `df` command.
A line with "s3fs" at the beginning is a file system mounted with s3fs.

```
[username@login1 ~]$ df -hT | grep "^s3fs"
s3fs                    fuse.s3fs    64P     0   64P   0% /tmp/s3fs_dir
```

## File operations

After mounting the bucket, you can add and remove objects from the bucket in the same way as you would with a file.

```
[username@login1 ~]$ cp ~/my-file /tmp/s3fs_dir/
[username@login1 ~]$ ls /tmp/s3fs_dir/my-file
[username@login1 ~]$ rm /tmp/s3fs_dir/my-file
```

## Unmounting bucket

Use the `fusermount` command to unmount the bucket.

```
[username@login1 ~]$ fusermount -u /tmp/s3fs_dir
```

## Verifying unmount

To verify that the unmount was successful, use the `df` command.
If the line that was displayed for s3fs has disappeared, the unmount was successful.

```
[username@login1 ~]$ df -hT | grep "^s3fs"
[username@login1 ~]$
```

When you use `s3fs-fuse` to mount a bucket, it will not be unmounted automatically, so unmount it when you no longer need it.

## s3fs command options

The options for the `s3fs` command are shown below. See the `man s3fs` or [s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse) website for more information.

| Option       | Description                           | Example                        |
|:--           |:--                                    |:--                             |
| url          | Endpoint URL used to connect.         | `-o url=https://s3.v3.abci.ai` |
| profile      | Profile name used for authentication. | `-o profile=aaa00000.2`        |
| dbglevel     | Debug message level.                  | `-o dbglevel=info`             |
| curldb       | Enabling libcurl debug messages.      | `-o curldb`                    |


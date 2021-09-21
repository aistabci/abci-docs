
# Using s3fs-fuse

ABCI provides an `s3fs-fuse` module that allows you to mount your ABCI Cloud Storage bucket as a local file system.
This section describes how to use the `s3fs-fuse` module.

## Access Key

An access key is required to use s3fs-fuse.

Please refer to [the ABCI Portal Guide](https://docs.abci.ai/portal/en/02/#282) for how to issue an access key.
After issuing the access key, use the AWS CLI to set the access key. Please refer to [How to Use ABCI Cloud Storage](usage.md) for how to set the access key.

Here, it is assumed that the access key is set in the `default` profile.

## Loading module

After logging in to the interactive node, load the `s3fs-fuse` module. Also load the `aws-cli` module to create a bucket and so on.

```
[username@es1 ~]$ module load aws-cli s3fs-fuse
```

## Creating bucket

Create a bucket for mounting.

```
[username@es1 ~]$ aws --endpoint-url https://s3.abci.ai s3 mb s3://s3fs-bucket
make_bucket: s3fs-bucket
```

## Mounting bucket

Create a mount point on the HOME directory and mount the `s3fs-bucket` bucket with the `s3fs` command.

```
[username@es1 ~]$ mkdir s3fs_dir
[username@es1 ~]$ s3fs s3fs-bucket ~/s3fs_dir -o url=https://s3.abci.ai/ -o use_path_request_style
```

If you want to use an access key other than the `default` profile, specify the` -o profile = profile name` option.

```
[username@es1 ~]$ s3fs s3fs-bucket ~/s3fs_dir -o url=https://s3.abci.ai/ -o profile=aaa00000.2 -o use_path_request_style
```

## File operations

After mounting the bucket, you can add and remove objects from the bucket in the same way as you would with a file.

```
[username@es1 ~]$ cp ~/my-file ~/s3fs_dir/
[username@es1 ~]$ ls ~/s3fs_dir/my-file
[username@es1 ~]$ rm ~/s3fs_dir/my-file
```

## Unmounting bucket

Use the `fusermount` command to unmount the bucket.

```
[username@es1 ~]$ fusermount -u ~/s3fs_dir
```

If you mount a bucket using `s3fs-fuse` in a job obtained by the On-demand or Spot service, it will be automatically unmounted at the end of the job.
However, if you mount the bucket using `s3fs-fuse` on the interactive node, it will not be unmounted automatically, so unmount it when you no longer need it.

## s3fs command options

The options for the `s3fs` command are shown below. See the `man s3fs` or [s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse) website for more information.

| Option       | Description                           | Example                     |
|:--           |:--                                    |:--                          |
| url          | Endpoint URL used to connect.         | `-o url=https://s3.abci.ai` |
| profile      | Profile name used for authentication. | `-o profile=aaa00000.2`     |
| dbglevel     | Debug message level.                  | `-o dbglevel=info`          |
| curldb       | Enabling libcurl debug messages.      | `-o curldb`                 |


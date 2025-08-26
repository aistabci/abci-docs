# Cautions for Using Cloud Storage

## Failure of MPU {#notice-mpu-fail}

Data may be left in the temporary area when data uploading by Multipart Upload (MPU) fails.
If an unsuccessful data upload satisfies the following conditions, please stop the MPU completely 
following the procedure described [here](usage.md#abort-mpu).

* Uploading data whose data size exceeds the threshold of MPU defined by the client application such as AWS CLI or s3cmd, and
* Failed to upload data, for example, by forcing the client application to stop or it failed unintendedly.

!!! note 
    The default data size which MPU applies is [8MB](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#multipart-threshold) for aws-cli and [15MB](https://s3tools.org/kb/item13.htm) for s3cmd.

### Details of MPU Failure

Cloud Storage supports Multipart Uload (MPU), which speeds up data uploads by sending splite data in parallel.
MPU is effective automatically for the data whose size exceeds the threshold defined by a client application. For example, threshold of AWS CLI is 8MB by default.
While data uploading by MPU, the divided data is stored in a temporary area on the server and then moved to the specified path as an object after the upload is complete.

This situation does not occur with properly stop operation, such as stopping AWS CLI with 'CTRL-C' but may occurs due to the forced termination of the client or disconnect communication unexpectedly.

If MPU fails, data may be left in the temporary area. You need to stop MPU completely by yourself. The procedure for aborting MPU is described [here](usage.md#abort-mpu) .

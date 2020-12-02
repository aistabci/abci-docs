# Cautions for Using ABCI Cloud Storage

## Charge for MPU Failed {#notice-mpu-fail}

ABCI points may be charged when data uploading by Multipart Upload (MPU) fails, so a solution is described here.
If you encounter the following items during data upload, please check this instruction.

* Uploading data whose data size exceeds the threshold of MPU defined by the client application, and
* Failed to upload data, such as by forcing the client application to stop,

!!! note 
    The default data size which MPU applies is [8MB](https://docs.aws.amazon.com/cli/latest/topic/s3-config.html#multipart-threshold) for aws-cli and [15MB](https://s3tools.org/kb/item13.htm) for s3cmd.

### Details of MPU Failure and Charging

ABCI Cloud Storage supports Multipart Uload (MPU), which speeds up data uploads by sending splite data in parallel.
MPU is effective automatically for the data whose size exceeds the threshold defined by a client application, for example, threshold of aws-cli is 8MB by default.
While data uploading by MPU, the divided data is stored in a temporary area on the server and then moved to the specified path as an object after the upload is complete.

The temporary area is subject to accounting, so you need to be careful when MPU fails.
This situation does not occur with properly stop operation, such as stopping aws-cli with 'CTRL-C' but may occurs due to the forced termination of the client or disconnect communication unexpectedly.
At this time, data stored in the temporary area is not deleted automatically, so unintended charges may occur.

To avoid the unintended charge, aborting manually MPU by yourself. The procedure for aborting MPU is described [here](usage.md#abort-mpu) .

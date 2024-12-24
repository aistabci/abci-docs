# AI Hub (Under Update)

## Overview

AI Hub is a collection of tools and services for reusing large-scale pre-trained models on the ABCI, and from Open OnDemand, you can use the `App for MLflow Server`.

The `App for MLflow Server` is an application that deploys the MLflow Tracking Server, an experiment management tool, in a way that allows it to be used on an ABCI group basis and managed from a web UI.

The deployed MLflow Tracking Server can be used by teams for recording and sharing training histories and training models in model development from the compute nodes of the ABCI or Jupyter Lab in Open OnDemand.

!!! caution
    The `App for MLflow Server` is released as an experimental feature.
    The service may change without notice, and responses to inquiries may take some time.

## Prerequisites

* An ABCI Cloud Storage bucket and an access key (When creating an MLflow Tracking Server)
	* Please refer to [How to Use ABCI Cloud Storage](../abci-cloudstorage/usage.md) for the creation method.

## Using AI Hub

To start the `App for MLflow Server`, click `AI Hub` and then `MLflow Server` from the menu.

When you start the `App for MLflow Server`, the following screen will be displayed.

![Screenshot of App for MLflow Server](img/app_for_mlflow_server.png){width=640}

#### Creating MLflow Tracking Server

* Based on the screen instructions, enter the following items and click the `Create Service` button.

	| Item | Description |
	| -- | -- |
	| `group_name` | ABCI Group |
	| `env_name` | Environment Name |
	| `cloud_storage_bucket_name` | Bucket Name |
	| `cloud_storage_accesskey_ID` | Access Key ID |
	| `cloud_storage_secret_accesskey` | Secret Access Key ID |

* Upon successful creation of the service, the "Operational status for requests" section will display "Service created".

#### Using MLflow Tracking Server

* Click the `Service List Update` button to display a list of available "Service List".
* You can start, stop, or delete services by operating the buttons under "Control Service".
	* The status of the operation will be displayed in the "Operational status for requests" section.
    * Please stop or delete services when they are no longer needed to conserve resources.
* If you need to configure Basic Authentication for the "MLflow Tracking Server", click the `Update Auth Info` button for the service.
	* You need to have a YAML file in a specified location beforehand in the following format.

		`{'user_name':'<username for Basic Authentication>', 'pass':'<password for Basic Authentication>'}`

* To access the MLflow UI, click on the URL under `URL for access from outside ABCI`.
	* Enter your Basic Authentication username and password to log in.
* Please use the running MLflow Tracking Server.
	* It can be accessed from the HPC Cluster's job services or Jupyter Lab in Open OnDemand.
	* By specifying `URL for access from inside ABCI` as the MLflow API tracking URI, you can record AI model training histories and models in the model registry.
	* For specific usage of MLflow Tracking Server, please refer to the [MLflow documentation](https://mlflow.org/docs/latest/index.html).

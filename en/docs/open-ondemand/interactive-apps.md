# Interactive Apps

Interactive apps are applications that run on the ABCI compute nodes and can be interactively operated in the web browser.

When launching an interactive app, you specify an ABCI group and a type of ABCI resources.
The interactive app is launched as a batch job that consumes ABCI points from the specified group and uses computational resources of the specified resource type.

Open OnDemand for ABCI provides the following interactive apps:

## Jupyter Lab

Open OnDemand for ABCI provide [Jupyter Lab](https://jupyter.org/), an interactive development environment.
Jupyter Lab is launched on the compute nodes, allowing you to operate it from the browser of your local workstation.

!!! caution
    Each time Jupyter Lab is launched, a Python virtual environment for Jupyter Lab will be created in the following path under your home directory. Please delete it periodically.

    ```
    ~/ondemand/data/sys/dashboard/batch_connect_sys/jupyter/output/
    ```

## Qni

Open OnDemand for ABCI provide [Qni](https://qniapp.net/), an interactive quantum circuit design and simulator that operates in the web browser.
Qni on the ABCI offers simulations using the GPUs of ABCI compute nodes.

!!! caution
    Qni operates on resource types equipped with GPUs.

    Qni uses only one GPU. If you specify a resource type with multiple GPUs, the remaining GPUs will not be used.

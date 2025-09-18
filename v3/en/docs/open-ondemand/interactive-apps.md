# Interactive Apps

Interactive apps are applications that run on the ABCI compute nodes and can be interactively operated in the web browser.

To launch an interactive app, you open the app, specify an ABCI group and a type of ABCI resource, and click the "Launch" button.
The interactive app is launched as a batch job that consumes ABCI points from the specified group.
Once the interactive app is launched, the link to connect to it is displayed, by clicking which you can use the app.

Open OnDemand for ABCI provides the following interactive apps:

## Jupyter Lab

Open OnDemand for ABCI provides [Jupyter Lab](https://jupyter.org/), an interactive development environment.
Jupyter Lab is launched on the compute nodes, allowing you to operate it from the browser of your local workstation.

!!! caution
    Each time Jupyter Lab is launched, a Python virtual environment for Jupyter Lab will be created in the following path under your home directory. Please delete it periodically.

    ```
    ~/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/jupyter_app/output/
    ```

## code-server {#code-server}

Open OnDemand for ABCI provides [code-server](https://github.com/coder/code-server), allowing you to use [VSCode](https://github.com/Microsoft/vscode) on the compute node through web browser on your side by selecting "Code Server" in Open OnDemand Dashboard and launching a job with an approriate resource type specified.

## Interactive Desktop {#interactive_desktop}

Open OnDemand for ABCI provides [Interactive Desktop(Xfce)](https://www.xfce.org/?lang=en), allowing you to operate on the compute node through your web browser on your side by selecting "Interactive Desktop" in Open OnDemand Dashboard and launching vncserver.

!!!info
    Connecting to Interactive Desktop and opening terminal, you can practice the GPU rendering following the commands below.

    ```
    module load turbovnc;
    vglrun -d egl<GPUID> <OpenGL command>
    ```



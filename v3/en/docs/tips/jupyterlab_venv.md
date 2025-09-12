# How to Add a Python Virtual Environment to JupyterLab

In ABCI's JupyterLab, you can add or remove Python virtual environments you've created as kernels. These environments will then be available for selection in the JupyterLab Launcher.

This section shows how to add a Python virtual environment to JupyterLab on Open OnDemand (OOD).

## Launching JupyterLab {#launch-jupyterlab}

Log in to OOD and run "Interactive Apps: Jupyter (Normal)".
<img src="ood-jl-001.png" width="800">

Submit your job.

<img src="ood-jl-002.png" width="800">

<img src="ood-jl-003.png" width="800">


Once the job is running, press the "Connect to Jupyter" button.
<img src="ood-jl-004.png" width="800">


JupyterLab will open in a new browser tab.
<img src="ood-jl-005.png" width="800">


## Adding a Python virtual environments to the JupyterLab Launcher {#add-venv}

As an example, create a Python virtual environment named "work" and install numpy in the "work" virtual environment.

From the JupyterLab Launcher, start "Other" -> "Terminal".
<img src="ood-jl-006.png" width="800">
<img src="ood-jl-007.png" width="800">

!!! Note
	If JupyterLab Launcher screen does not appear initially, launch it from [File] - [New Launcher].


Execute the following in the Terminal to create the "work" virtual environment.

Create the Python virtual environment.
```
$ python3 -m venv work
$ source work/bin/activate
(work) $ pip install --upgrade pip
```
!!! Note
	A directory named "work" will be created in the current directory, and the virtual environment will be constructed under the "work" directory.
<img src="ood-jl-008.png" width="800">

Install ipykernel in the created virtual environment and configure it to appear in the JupyterLab Launcher.
```
(work) $ python3 -m pip install ipykernel
(work) $ python3 -m ipykernel install --user --name=work --display-name="Python 3 (work)" 
```

Install numpy package in the virtual environment "work" you created.
```
(work) $ pip install numpy==2.2.2
```
<img src="ood-jl-009.png" width="800">

Reload the JupyterLab browser tab and the newly created "work" virtual environment will appear in the JupyterLab Launcher.
<img src="ood-jl-010.png" width="800">


Below is an example of running a numpy program in Python3 (ipykernel).

Click "Notebook" -> "Python3 (ipykernel)" to open a Notebook.
After opening the Notebook, enter the following Python program:

```
# Import numpy library
import numpy as np

# Prepare an integer array
arr_int32 = np.array([100, 200, 300, 400, 500], dtype=np.int32)
print(arr_int32)

# Prepare a floating-point array
arr_float = np.array([0.1, 0.2, 0.3, 0.4, 0.5], dtype=np.float64)
print(arr_float)

# You can express array calculations with +
arr_sum = arr_int32 + arr_float
print(arr_sum)
```

Press "Shift + Enter" to run the program. An error occurs because numpy is not installed in Python3 (ipykernel).

<img src="ood-jl-011.png" width="800">


Next, execute the program using the created Python3 (work).

Click "Notebook" -> "Python3 (work)" to open a Notebook.
After opening the Notebook, enter the same program as before.

Press "Shift + Enter" to run the program. Since numpy is installed in the Python3 (work), the program executes correctly.

<img src="ood-jl-012.png" width="800">


## Removing a Python Virtual Environment from the JupyterLab Launcher {#del-venv}

To remove a Python virtual environment from the JupyterLab Launcher, execute the following command.
```
jupyter kernelspec uninstall [environment name]
```


To remove the "work" environment, execute the following from the Terminal.
```
$ jupyter kernelspec uninstall work
```

!!! Note
	To display the list of virtual environments, use the following command:
	
	```
	$ jupyter kernelspec list
	```

Reload the JupyterLab browser tab, and the "work" environment will be removed from the JupyterLab Launcher.
<img src="ood-jl-013.png" width="800">

## Deleting the Python Virtual Environment {#rm-venv}

To completely delete the virtual environment, remove the directory created during "Create the Python virtual environment".


# Open OnDemand

## Overview

[Open OnDemand (OOD)](https://openondemand.org/) is a portal site for using ABCI through a web browser.

The following features is available on the web browser, making it easier to use ABCI than ever before:

* Console operations on interactive nodes
* File operations in the home areas and the group areas
* Use of web applications such as Jupyter Lab


## Initial password {#initial-password}

When you login to Open OnDemand for the first time, you need initial password for it.
For your initial password, please contact <abci3-qa@abci.ai> refering to [Contact](../contact.md).

Please refer to [How to change the initial password](#how-to-change-the-initial-password) for changing initial password.


## How to change the initial password {#how-to-change-the-initial-password}

To change the initial password, execute the `passwd` command on the interactive node.

```
[username@login1 ~]$ passwd
Changing password for user username.
Current Password:<Entering the initial password>
New password:<Entering the new password>
Retype new password:<Re-entering the new password>
passwd: all authentication tokens updated successfully.
[username@login1 ~]$
```

!!! warning
    Password policies are as follows:

    - Specify a character string with more than 12 characters arranged randomly. We recommend generating it automatically by using password creation software.
    - Should contain all character types of lower-case letters, upper-case letters, numeric characters, and special characters.
    - As special characters, the following 33 types of characters can be used: (blank) ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~

## Login

To log in to the Open OnDemand, first open the URL [https://ood.v3.abci.ai/](https://ood.v3.abci.ai/).
After accessing `ood.v3.abci.ai`, you will be prompted to enter your username and password.
Please enter the ABCI account name and password.
After authenticating with your username and password, you will be asked to enter an access code.
The access code will be sent to your registered email address, so please enter the access code into the input form after receiving it. The access code is valid for 30 minutes after issuance.

!!! note
    The email containing the access code may be sorted into your spam/junk mail folder. If you do not receive the email, please check your spam/junk mail folder.

After authenticating with the access code, you will be logged in to the Open OnDemand.

!!! warning
    If an error occurs during login, please [contact](../contact.md) the administrator.


## Applications

You can access the features provided by the Open OnDemand from the menu at the top of the screen.

[![Open OnDemand Application Menu](ood-menu.png)](ood-menu.png)

1. **Files**: Perform file operations in the browser.

2. **Jobs**: Edit and manage jobs in the browser.

3. **Clusters**: Open the console for the interactive nodes.

4. **Interactive Apps**: Launch web applications on the compute nodes and transfer the screen to the web browser.

<!-- 5. **AI Hub**: AI Hub is a collection of tools and services for reusing large-scale pre-trained models on the ABCI. It provides an application to manage the deployment of the MLflow Tracking Server, one of the features that constitute AI Hub.-->

!!! note
    Time-out period of console in **Clusters** is 100 minutes if inactive, 10 hours if active.


## Compatibility with ABCI 2.0 

The feature compatibility with ABCI 2.0 is shown below.

| Service Name | ABCI 2.0 | ABCI 3.0 | 
|:--|:---:|:---:|
| File operations in the home areas and the group areas | 〇 | 〇 | 
| Job management | 〇 | 〇 | 
| Console operations on interactive nodes | 〇 | 〇 | 
| Jupyter notebook | 〇 | 〇 | 
| Qni | 〇 | ×[^1] | 
| AI Hub | 〇 | ×[^1] | 

[^1]: This feature is scheduled for future implementation.

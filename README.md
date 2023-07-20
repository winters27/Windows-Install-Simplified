# Fresh Windows Install, Simplified
Use and modify this tutorial to streamline your own Windows reinstallations.


## How to Install Programs and Optimize Windows using CMD and PowerShell

In this tutorial, we will guide you through the process of installing software and optimizing your Windows system using the Command Prompt (CMD) and PowerShell. We will use Chocolatey for software installation and some helpful PowerShell commands to optimize your system.

### CMD:

**Step 1: Install Chocolatey**

Chocolatey is a package manager for Windows that allows you to easily install various software packages. To install Chocolatey, follow these steps:

1. Open the Command Prompt (CMD) with administrator privileges.
2. Copy and paste the following command into the CMD window and press Enter:

```shell
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
```


**Step 2: Install Programs using Chocolatey**

Once you have Chocolatey installed, you can use it to install your desired programs efficiently. Here's how you can install multiple programs at once using Chocolatey through CMD:

1. Open the CMD with administrator privileges.
2. After modifying which programs you want, copy and paste the following command into the CMD window and press Enter:

```shell
choco install googlechrome discord bitwarden steam geforce-experience amd-ryzen-master equalizerapo 7zip f.lux qbittorrent vscode everything wiztree joytokey revo-uninstaller ea-app epicgameslauncher -y
```

**Note:** If there are programs you want to install that are not on the list, you can search for them and add them from the Chocolatey community packages website: [https://community.chocolatey.org/packages?q=](https://community.chocolatey.org/packages?q=)



### PowerShell:

**Step 3: Activate Windows 8.1/10/11**

In this step, we will activate your Windows operating system using PowerShell. Follow these steps:

1. Open PowerShell with administrator privileges.
2. Copy and paste the following command into the PowerShell window and press Enter:

```shell
irm https://massgrave.dev/get | iex
```


**Step 4: Remove Bloatware using PowerShell**

To remove bloatware from your system, follow these steps:

1. Open PowerShell with administrator privileges.
2. Copy and paste the following command into the PowerShell window and press Enter:

```shell
iwr -useb https://git.io/debloat | iex
```


Congratulations! You have successfully installed various programs using Chocolatey through CMD and performed some system optimizations using PowerShell.

Remember to be cautious when running scripts from the internet, and always make sure to use trusted sources. If you encounter any issues, you can refer to the official documentation of Chocolatey or PowerShell for additional support.

Enjoy your newly installed software and optimized Windows system!

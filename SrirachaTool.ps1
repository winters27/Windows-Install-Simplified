Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$SrirachaTool = New-Object System.Windows.Forms.Form
$SrirachaTool.ClientSize = New-Object System.Drawing.Point(500, 700)
$SrirachaTool.Text = "SrirachaTool"
$SrirachaTool.TopMost = $false
$SrirachaTool.ShowIcon = $false
$SrirachaTool.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252525")
$SrirachaTool.AcceptButton = $null

$ProgramListTextBox = New-Object system.Windows.Forms.TextBox
$ProgramListTextBox.Multiline = $true
$ProgramListTextBox.Width = 395
$ProgramListTextBox.Height = 254
$ProgramListTextBox.Location = New-Object System.Drawing.Point(50, 50)
$ProgramListTextBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$ProgramListTextBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#39FF14")
$ProgramListTextBox.BackColor = [System.Drawing.Color]::Black  # Set the background color to black
$ProgramListTextBox.ScrollBars = "Vertical"

# Default program list
$global:defaultProgramList = @(
    "googlechrome",
    "discord",
    "bitwarden",
    "steam",
    "geforce-experience",
    "amd-ryzen-master",
    "equalizerapo",
    "7zip",
    "f.lux",
    "qbittorrent",
    "vscode",
    "joytokey",
    "revo-uninstaller"
)

# Function to save the program list to an XML file
# Get the script's directory path
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Function to save the program list to an XML file in the script's directory
function Save-ProgramListToXml {
    $programList = $ProgramListTextBox.Text -split [Environment]::NewLine
    $xmlFilePath = Join-Path $scriptDirectory "program_list.xml"
    $programList | Export-Clixml -Path $xmlFilePath
}


# Function to load the program list from the XML file or use the default list
function Load-ProgramListFromXml {
    $xmlFilePath = Join-Path $scriptDirectory "program_list.xml"
    if (Test-Path $xmlFilePath) {
        $programList = Import-Clixml -Path $xmlFilePath
        $ProgramListTextBox.Text = $programList -join [Environment]::NewLine
    } else {
        $ProgramListTextBox.Text = $global:defaultProgramList -join [Environment]::NewLine
    }
}


# Call the Load-ProgramListFromXml function to load the saved list when the application starts
Load-ProgramListFromXml

$SaveListButton = New-Object system.Windows.Forms.Button
$SaveListButton.Text = "Save List"
$SaveListButton.AutoSize = $true
$SaveListButton.Location = New-Object System.Drawing.Point(339, 320)
$SaveListButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$SaveListButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Event handler for the "Save List" button click
$SaveListButton.Add_Click({
    Save-ProgramListToXml
    # Optional: Show a message box indicating that the list has been saved.
    [System.Windows.Forms.MessageBox]::Show("Program list has been saved.", "Save List", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

$Label1 = New-Object system.Windows.Forms.Label
$Label1.Text = "Add or remove programs from the installation list:"
$Label1.AutoSize = $true
$Label1.Width = 25
$Label1.Height = 10
$Label1.Location = New-Object System.Drawing.Point(104, 15)
$Label1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$Label1.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Label2 = New-Object system.Windows.Forms.Label
$Label2.Text = "by Winters"
$Label2.AutoSize = $true
$Label2.Width = 25
$Label2.Height = 10
$Label2.Location = New-Object System.Drawing.Point(430, 681)
$Label2.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$Label2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#04d9ff")

$SrirachaTool.Controls.Add($WindowsActivationButton)
$SrirachaTool.Controls.Add($SaveListButton)
$SrirachaTool.Controls.Add($WindowsDebloaterButton)
$SrirachaTool.Controls.Add($InstallProgramListButton)
$SrirachaTool.Controls.Add($UninstallProgramsButton)
$SrirachaTool.Controls.Add($Label1)
$SrirachaTool.Controls.Add($Label2)
$SrirachaTool.Controls.Add($ProgramListTextBox)


#region Logic

# Function to run the Windows activator command
function Run-WindowsActivator {
    # Execute the PowerShell command
    Invoke-Expression (Invoke-RestMethod -Uri "https://massgrave.dev/get")
}

$WindowsActivationButton = New-Object system.Windows.Forms.Button
$WindowsActivationButton.Text = "Run Windows Activator"
$WindowsActivationButton.Width = 320
$WindowsActivationButton.Height = 49
$WindowsActivationButton.Location = New-Object System.Drawing.Point(90, 523)
$WindowsActivationButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$WindowsActivationButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Event handler for the "Run Windows Activator" button click
$WindowsActivationButton.Add_Click({
    Run-WindowsActivator
})

$SrirachaTool.Controls.Add($WindowsActivationButton)

# Function to run the Windows Debloater command
function Run-WindowsDebloater {
    # Execute the PowerShell command
    Invoke-Expression (Invoke-WebRequest -Uri "https://git.io/debloat" -UseBasicParsing).Content
}

$WindowsDebloaterButton = New-Object system.Windows.Forms.Button
$WindowsDebloaterButton.Text = "Run Windows Debloater"
$WindowsDebloaterButton.Width = 320
$WindowsDebloaterButton.Height = 49
$WindowsDebloaterButton.Location = New-Object System.Drawing.Point(90, 609)
$WindowsDebloaterButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$WindowsDebloaterButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Event handler for the "Run Windows Debloater" button click
$WindowsDebloaterButton.Add_Click({
    Run-WindowsDebloater
})

$SrirachaTool.Controls.Add($WindowsDebloaterButton)

# Function to check if Chocolatey is already installed
function Is-ChocolateyInstalled {
    $chocoPath = Get-Command choco -ErrorAction SilentlyContinue
    if ($chocoPath) {
        return $true
    }
    return $false
}

# Function to install Chocolatey
function Install-Chocolatey {
    if (-Not (Is-ChocolateyInstalled)) {
        # Run installation script for Chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

        # Pause the script briefly to allow Chocolatey to complete the installation
        Start-Sleep -Seconds 3
    }
}

# Function to check if a program is already installed
function Is-ProgramInstalled {
    param([string]$programName)

    # Check if the program is installed through Chocolatey
    $chocoOutput = choco list --local-only --exact $programName
    if ($chocoOutput -match "$programName\s+\|") {
        return $true
    }

    # Add other checks here for other means of installation, e.g., registry checks, etc.

    return $false
}

# Function to install programs from the list
function Install-Programs {
    $ProgramList = $ProgramListTextBox.Text -split [Environment]::NewLine

    # Loop through the list and install each program if not already installed
    foreach ($program in $ProgramList) {
        $program = $program.Trim()
        if ($program -ne "") {
            if (-Not (Is-ProgramInstalled $program)) {
                Write-Host "Installing $program..."
                choco install $program -y
            } else {
                Write-Host "Skipping installation of $program as it is already installed."
            }
        }
    }

    Write-Host "Program installation completed."
}



# Event handler for the Install Programs button click
$InstallProgramListButton = New-Object system.Windows.Forms.Button
$InstallProgramListButton.Text = "Install Programs"
$InstallProgramListButton.Width = 320
$InstallProgramListButton.Height = 49
$InstallProgramListButton.Location = New-Object System.Drawing.Point(90, 368)
$InstallProgramListButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$InstallProgramListButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#7ed321")
$InstallProgramListButton.Add_Click({
    Install-Chocolatey
    Install-Programs
})

$UninstallProgramsButton = New-Object system.Windows.Forms.Button
$UninstallProgramsButton.Text = "Uninstall Programs"
$UninstallProgramsButton.Width = 320
$UninstallProgramsButton.Height = 49
$UninstallProgramsButton.Location = New-Object System.Drawing.Point(90, 444)
$UninstallProgramsButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$UninstallProgramsButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#d0021b") # Red color

function Uninstall-Programs {
    $ProgramList = $ProgramListTextBox.Text -split [Environment]::NewLine

    foreach ($program in $ProgramList) {
        $program = $program.Trim()
        if ($program -ne "") {
            # Try uninstalling via Chocolatey first
            $chocoOutput = choco uninstall $program -y 2>&1
            if ($chocoOutput -match "has been uninstalled") {
                Write-Host "$program has been uninstalled via Chocolatey."
            } else {
                Write-Host "Uninstalling $program using general method..."
                # Use a general method to uninstall the program (e.g., using msiexec.exe)
                $uninstallArgs = "/x $program /quiet"
                Start-Process -FilePath "msiexec.exe" -ArgumentList $uninstallArgs -Wait
                Write-Host "$program has been uninstalled using the general method."
            }

            # Remove the desktop shortcut
            $desktopPath = [Environment]::GetFolderPath("Desktop")
            $shortcutPath = Join-Path $desktopPath "$program.lnk"
            if (Test-Path $shortcutPath) {
                Remove-Item -Path $shortcutPath -Force
                Write-Host "Desktop shortcut for $program has been removed."
            }
        }
    }

    Write-Host "Program uninstallation and shortcut removal completed."
}



$UninstallProgramsButton.Add_Click({
    Uninstall-Programs
})

$SrirachaTool.controls.AddRange(@($WindowsActivationButton, $SaveListButton, $WindowsDebloaterButton, $InstallProgramListButton, $UninstallProgramsButton, $Label1, $Label2, $ProgramListTextBox))



#endregion

[void]$SrirachaTool.ShowDialog()

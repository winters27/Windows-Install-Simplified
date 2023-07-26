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
    "bitwarden",
    "discord",
    "googlechrome",
    "steam",
    "geforce-experience",
    "amd-ryzen-master",
    "equalizerapo",
    "7zip",
    "f.lux",
    "qbittorrent",
    "vscode",
    "joytokey",
    "revo-uninstaller",
    "ea-app",
    "via",
    "samsung-magician",
    "streamlabs-obs",
    "epicgameslauncher",
    "python"
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

$SaveListButton = New-Object System.Windows.Forms.Button
$SaveListButton.Text = "Save List"
$SaveListButton.AutoSize = $true
$SaveListButton.Location = New-Object System.Drawing.Point(339, 320)
$SaveListButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12)
$SaveListButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")  # Set text color

$originalSaveListColor = [System.Drawing.Color]::FromArgb([System.Int32]::Parse("eeeeee", [System.Globalization.NumberStyles]::HexNumber))

$SaveListButton.Add_MouseEnter({
    $SaveListButton.ForeColor = (ChangeBrightness -color $originalSaveListColor -factor 0.8)  # Darken the color on hover
    $SaveListButton.Cursor = [System.Windows.Forms.Cursors]::Hand
})

$SaveListButton.Add_MouseLeave({
    $SaveListButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")  # Restore the original color
    $SaveListButton.Cursor = [System.Windows.Forms.Cursors]::Default
})

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

$WindowsActivationButton = New-Object System.Windows.Forms.Button
$WindowsActivationButton.Text = "Run Windows Activator"
$WindowsActivationButton.Width = 320
$WindowsActivationButton.Height = 49
$WindowsActivationButton.Location = New-Object System.Drawing.Point(90, 523)
$WindowsActivationButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12, [System.Drawing.FontStyle]::Bold)  # Set font to bold
$WindowsActivationButton.BackColor = "White"  # Set background color to white
$WindowsActivationButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#0074D9")  # Blue color
$WindowsActivationButton.FlatStyle = "Flat"
$WindowsActivationButton.FlatAppearance.BorderSize = 0
$WindowsActivationButton.AutoSize = $true

$originalActivationColor = [System.Drawing.Color]::FromArgb([System.Int32]::Parse("0074D9", [System.Globalization.NumberStyles]::HexNumber))

$WindowsActivationButton.Add_MouseEnter({
    $WindowsActivationButton.BackColor = (ChangeBrightness -color $originalActivationColor -factor 1.2)  # Lighten the color on hover
    $WindowsActivationButton.Cursor = [System.Windows.Forms.Cursors]::Hand
})

$WindowsActivationButton.Add_MouseLeave({
    $WindowsActivationButton.BackColor = [System.Drawing.Color]::White  # Restore the original color (white background)
    $WindowsActivationButton.Cursor = [System.Windows.Forms.Cursors]::Default
})

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

$WindowsDebloaterButton = New-Object System.Windows.Forms.Button
$WindowsDebloaterButton.Text = "Run Windows Debloater"
$WindowsDebloaterButton.Width = 320
$WindowsDebloaterButton.Height = 49
$WindowsDebloaterButton.Location = New-Object System.Drawing.Point(90, 609)
$WindowsDebloaterButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12, [System.Drawing.FontStyle]::Bold)  # Set font to bold
$WindowsDebloaterButton.BackColor = "White"  # Set background color to white
$WindowsDebloaterButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FF851B")  # Orange color
$WindowsDebloaterButton.FlatStyle = "Flat"
$WindowsDebloaterButton.FlatAppearance.BorderSize = 0
$WindowsDebloaterButton.AutoSize = $true

$originalDebloaterColor = [System.Drawing.Color]::FromArgb([System.Int32]::Parse("FF851B", [System.Globalization.NumberStyles]::HexNumber))

$WindowsDebloaterButton.Add_MouseEnter({
    $WindowsDebloaterButton.BackColor = (ChangeBrightness -color $originalDebloaterColor -factor 1.2)  # Lighten the color on hover
    $WindowsDebloaterButton.Cursor = [System.Windows.Forms.Cursors]::Hand
})

$WindowsDebloaterButton.Add_MouseLeave({
    $WindowsDebloaterButton.BackColor = [System.Drawing.Color]::White  # Restore the original color (white background)
    $WindowsDebloaterButton.Cursor = [System.Windows.Forms.Cursors]::Default
})

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



# Function to adjust the brightness of a color
function ChangeBrightness {
    param(
        [System.Drawing.Color]$color,
        [double]$factor
    )
    $newColor = $color.GetBrightness() * $factor
    return [System.Drawing.Color]::FromArgb($color.A, $color.R * $newColor, $color.G * $newColor, $color.B * $newColor)
}

$InstallProgramListButton = New-Object System.Windows.Forms.Button
$InstallProgramListButton.Text = "Install Programs"
$InstallProgramListButton.Width = 320
$InstallProgramListButton.Height = 49
$InstallProgramListButton.Location = New-Object System.Drawing.Point(90, 368)
$InstallProgramListButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12, [System.Drawing.FontStyle]::Bold)
$InstallProgramListButton.BackColor = "#7ED321"  # Starting color
$InstallProgramListButton.ForeColor = "Black"
$InstallProgramListButton.FlatStyle = "Flat"
$InstallProgramListButton.FlatAppearance.BorderSize = 0
$InstallProgramListButton.AutoSize = $true

$originalColor = [System.Drawing.Color]::FromArgb([System.Int32]::Parse("7ED321", [System.Globalization.NumberStyles]::HexNumber))

$InstallProgramListButton.Add_MouseEnter({
    $InstallProgramListButton.BackColor = (ChangeBrightness -color $originalColor -factor 1.2)  # Lighten the color on hover
    $InstallProgramListButton.Cursor = [System.Windows.Forms.Cursors]::Hand
})

$InstallProgramListButton.Add_MouseLeave({
    $InstallProgramListButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#7ED321")  # Restore the original color
    $InstallProgramListButton.Cursor = [System.Windows.Forms.Cursors]::Default
})
$InstallProgramListButton.Add_Click({
    Install-Chocolatey
    Install-Programs
})

$UninstallProgramsButton = New-Object System.Windows.Forms.Button
$UninstallProgramsButton.Text = "Uninstall Programs"
$UninstallProgramsButton.Width = 320
$UninstallProgramsButton.Height = 49
$UninstallProgramsButton.Location = New-Object System.Drawing.Point(90, 444)
$UninstallProgramsButton.Font = New-Object System.Drawing.Font('Yu Gothic UI', 12, [System.Drawing.FontStyle]::Bold)
$UninstallProgramsButton.BackColor = "#d0021b"  # Red color
$UninstallProgramsButton.ForeColor = "Black"     # Set text color to white for better contrast
$UninstallProgramsButton.FlatStyle = "Flat"
$UninstallProgramsButton.FlatAppearance.BorderSize = 0
$UninstallProgramsButton.AutoSize = $true

$originalUninstallColor = [System.Drawing.Color]::FromArgb([System.Int32]::Parse("d0021b", [System.Globalization.NumberStyles]::HexNumber))

$UninstallProgramsButton.Add_MouseEnter({
    $UninstallProgramsButton.BackColor = (ChangeBrightness -color $originalUninstallColor -factor 1.2)  # Lighten the color on hover
    $UninstallProgramsButton.Cursor = [System.Windows.Forms.Cursors]::Hand
})

$UninstallProgramsButton.Add_MouseLeave({
    $UninstallProgramsButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#d0021b")  # Restore the original color
    $UninstallProgramsButton.Cursor = [System.Windows.Forms.Cursors]::Default
})

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

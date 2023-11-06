<#
.Synopsis
  This PowerShell script automates the process of uninstalling the TeamViewer application from
  a Windows computer. It stops the TeamViewer service, waits for a specified
  duration, uninstalls the application silently using msiexec, removes uninstallation
  entries from the Windows Registry, and checks for the existence of the application's
  installation folders (both 64-bit and 32-bit) to delete them if they are found.


.DESCRIPTION
  The PowerShell script is designed to simplify the process of uninstalling the TeamViewer application from a Windows computer.
  It provides a set of actions that automate the uninstallation process and clean up any remaining artifacts.


.NOTES
  Name: Uninstall-TeamViewer.ps1 
  Author: Valentino Chetty | ZA
  Version: 1.0
  DateCreated: Oct 2023
  
   
.LINK
  https://tech-logic.co.za

#>


# Stop the TeamViewer service
Stop-Service -Name "TeamViewer"

# Wait for 10 seconds
Start-Sleep -Seconds 10

# Define the name of the application you want to uninstall
$applicationName = "TeamViewer"

# Uninstall the application using msiexec silently
Start-Process -Wait -FilePath "msiexec" -ArgumentList "/x $applicationName /qn"

# Check the Windows Registry for uninstallation entries
Remove-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$applicationName" -Force

# Check if the installation folder exists and delete it
$installFolder = "C:\Program Files\$applicationName"
if (Test-Path -Path $installFolder) {
    Remove-Item -Path $installFolder -Recurse -Force
    Write-Host "Deleted $installFolder."
} else {
    Write-Host "$installFolder does not exist."
}

# Check the (x86) folder for a 32-bit application (if necessary)
$installFolder86 = "C:\Program Files (x86)\$applicationName"
if (Test-Path -Path $installFolder86) {
    Remove-Item -Path $installFolder86 -Recurse -Force
    Write-Host "Deleted $installFolder86."
} else {
    Write-Host "$installFolder86 does not exist."
}

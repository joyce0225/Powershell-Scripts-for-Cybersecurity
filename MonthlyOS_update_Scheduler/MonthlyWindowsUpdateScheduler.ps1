
<#
.SYNOPSIS
    This PowerShell script schedules Windows updates to be checked and installed every 1st day of the month.

.DESCRIPTION
    The script uses the Task Scheduler to set up a monthly trigger to run Windows updates automatically.
    It utilizes the PSWindowsUpdate module to check for, download, and install updates.

.NOTES
    Author: PulsR AI
    Version: 1.0
    Requires: PowerShell 5.0 or higher and PSWindowsUpdate module
#>

# Ensure running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run PowerShell as an Administrator."
    Break
}

# Check if PSWindowsUpdate module is installed, if not install it
If (-Not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Try {
        Install-Module -Name PSWindowsUpdate -Force
    } Catch {
        Write-Error "Failed to install the PSWindowsUpdate module. Please install it manually."
        Break
    }
}

# Register to use Microsoft Update Service
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false

# Define the action to be taken by the task (Windows Update)
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-NoProfile -WindowStyle Hidden -Command "& {Import-Module PSWindowsUpdate; Get-WUInstall -MicrosoftUpdate -AcceptAll -AutoReboot -ScheduleJob}"'

# Define the trigger for the 1st day of every month
$Trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth 1

# Define the principal with highest privileges
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -TaskName "MonthlyWindowsUpdate" -Description "Automates the checking and installation of Windows updates every 1st day of the month."

Write-Output "Scheduled task created successfully. Windows will now check for updates every 1st day of the month."

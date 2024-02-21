
# PowerShell script for System Configuration Checks and Security Event Tracking

# Check for Administrator rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Warning: This script requires Administrator rights to run some of the checks." -ForegroundColor Yellow
}

# System Information Checks
Write-Host "Gathering System Information..."
$systemInfo = Get-WmiObject -Class Win32_OperatingSystem
$ipAddresses = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress -ne $null}
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name

# Displaying basic system information
Write-Host "System Version: $($systemInfo.Version)"
Write-Host "Logged-in User: $currentUser"
Write-Host "System IPv4 Addresses: $($ipAddresses.IPAddress | Where-Object {$_ -match '\d+\.\d+\.\d+\.\d+'})"
Write-Host "System IPv6 Addresses: $($ipAddresses.IPAddress | Where-Object {$_ -match ':'})"

# Check Windows Update Configuration
Write-Host "Checking Windows Update Configuration..."
$autoUpdate = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
Write-Host "Auto Update Enabled: $($autoUpdate.AUOptions -eq 4)"

# Check for Missing Critical and Important Updates
Write-Host "Checking for Missing Updates..."
$missingUpdates = Get-HotFix -Description "Security Update", "Update Rollup" -ErrorAction SilentlyContinue
if ($missingUpdates) {
    Write-Host "Missing Security Updates: $($missingUpdates.Count)"
}
else {
    Write-Host "No Missing Security Updates Found."
}

# PowerShell Event Log Settings
Write-Host "Checking PowerShell Event Log Settings..."
# Code to check PowerShell event log settings goes here

# PowerShell Configuration Settings
Write-Host "Checking PowerShell Configuration..."
$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $psVersion"

# Remote Access Configurations
Write-Host "Checking Remote Access Configurations..."
# Code to check RDP settings goes here

# Local Administrator Accounts Check
Write-Host "Checking Local Administrator Accounts..."
$localAdmins = Get-LocalGroupMember -Group "Administrators"
Write-Host "Number of Local Administrators: $($localAdmins.Count)"

# Security Event Tracking
Write-Host "Tracking Security Events..."
# Track failed login attempts (Event ID 4625)
$failedLogins = Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} -MaxEvents 10 -ErrorAction SilentlyContinue
Write-Host "Recent Failed Login Attempts: $($failedLogins.Count)"

# Code to extract and analyze specific event properties from the security logs goes here
# Code to use XML templates to process structure of security events goes here

Write-Host "Script Execution Completed." -ForegroundColor Green

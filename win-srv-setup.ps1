# Display current server name
Write-Host "Current server name: $env:COMPUTERNAME"
# Prompt for new server name
$newName = Read-Host "Enter the new server name"
# Rename the computer
Rename-Computer -NewName $newName -Force
Write-Host "Server name has been changed to $newName."

# Set timezone to Central Standard
Set-TimeZone -Id "Central Standard Time" -PassThru
Write-Host "Time zone set to Central Standard time"

# Enable all firewalls
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True
Write-Host "All firewalls have been enabled"

# Function to set network profile
function Set-NetworkProfile {
    param (
        [string]$ProfileName
    )   
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory $ProfileName
    Write-Host "All network connections have been set to $ProfileName profile."
}
# Main script
Write-Host "Select the network profile you want to set:"
Write-Host "1. Public"
Write-Host "2. Private"
Write-Host "3. Domain"
$choice = Read-Host "Enter your choice (1-3)"
switch ($choice) {
    "1" {
        Set-NetworkProfile -ProfileName "Public"
    }
    "2" {
        Set-NetworkProfile -ProfileName "Private"
    }
    "3" {
        Set-NetworkProfile -ProfileName "DomainAuthenticated"
    }
    default {
        Write-Host "Invalid choice. No changes were made."
    }
}

# Disable IE Enhanced Security Configuration for Administrators
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
# Force the system to recognize the change immediately
Rundll32 iesetup.dll, IEHardenLMSettings
Rundll32 iesetup.dll, IEHardenUser
Rundll32 iesetup.dll, IEHardenAdmin
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled for Administrators."

#Disable Automatic Windows Updates
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name AUOptions -Value 1

# Function to enable RDP with Network Level Authentication
function Enable-RDP {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1
    Write-Host "Remote Desktop has been enabled with Network Level Authentication."
}
# Function to disable RDP
function Disable-RDP {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1
    Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Write-Host "Remote Desktop has been disabled."
}
# Main script
$response = Read-Host "Do you want to enable Remote Desktop? (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    Enable-RDP
} elseif ($response -eq "N" -or $response -eq "n") {
    Disable-RDP
} else {
    Write-Host "Invalid input. No changes were made."
}

# Rename adapter - use Get-NetAdapter to list adapters
Get-NetAdapter -Name {Old Name CHANGEME} | Rename-NetAdapter -NewName {New Name CHANGEME}

# Disable IPv6 on all network interfaces
Get-NetAdapterBinding -ComponentID ms_tcpip6 | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }

Write-Host "Script execution completed."

# Prompt the user for input
$response = Read-Host "Do you want to restart your computer? (Y/N)"

# Convert the response to lowercase for easier comparison
$response = $response.ToLower()

# Check the user's response
if ($response -eq "y" -or $response -eq "yes") {
    Write-Host "Restarting the computer in 10 seconds. Press Ctrl+C to cancel."
    Start-Sleep -Seconds 10
    Restart-Computer -Force
}
elseif ($response -eq "n" -or $response -eq "no") {
    Write-Host "Restart cancelled. The computer will not restart."
}
else {
    Write-Host "Invalid input."
}
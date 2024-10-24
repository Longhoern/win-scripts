# RDP Restoration Script
# Run as Administrator

# Function to log actions
function Write-Log {
    param($Message)
    Write-Host $Message
}

Write-Log "Starting RDP restoration..."

# 1. Enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Write-Log "Enabled RDP connections"

# 2. Enable Remote Desktop firewall rules
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Log "Enabled RDP firewall rules"

# 3. Reset RDP Security Settings to Default
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "SecurityLayer" -Value 1
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "MinEncryptionLevel" -Value 2
Write-Log "Reset RDP security settings to default values"

# 4. Restart the Remote Desktop Services
Restart-Service UmRdpService -Force
Restart-Service TermService -Force
Write-Log "Restarted Remote Desktop services"

Write-Log "RDP restoration completed. Please try connecting again."

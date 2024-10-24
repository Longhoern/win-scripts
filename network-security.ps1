# Windows Server 2022 Network Security Configuration Script
# Run as Administrator
# This script implements network security best practices

# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run this script as Administrator"
    exit 1
}

# Function to log actions
function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Write-Host $logMessage
    Add-Content -Path "$env:SystemDrive\SecurityConfig.log" -Value $logMessage
}

Write-Log "Starting security configuration..."

# 1. Configure Windows Firewall
#Write-Log "Configuring Windows Firewall..."
#Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
#Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log -LogMaxSizeKilobytes 32768 -LogAllowed True -LogBlocked True

# 2. Enable Network Security Settings
Write-Log "Configuring Network Security..."

# Enable SMB Signing
$regPath = "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters"
Set-ItemProperty -Path $regPath -Name "RequireSecuritySignature" -Value 1
Set-ItemProperty -Path $regPath -Name "EnableSecuritySignature" -Value 1

# Disable SMBv1
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Enable SMBv2/v3 encryption
Set-SmbServerConfiguration -EncryptData $True -Force

# 3. Configure TCP/IP Security
Write-Log "Configuring TCP/IP Security..."

# Enable Windows Defender Firewall Security Features
netsh advfirewall set allprofiles settings inboundusernotification enable
netsh advfirewall set allprofiles settings unicastresponsetomulticast disable

# 4. Configure IPSec Policies
Write-Log "Configuring IPSec..."

# Enable IPSec
$ipsecPolicy = New-NetIPSecRule -DisplayName "Require Encryption" -InboundSecurity Require -OutboundSecurity Require -Protocol TCP

# 5. Disable unnecessary network services
Write-Log "Disabling unnecessary network services..."
$servicesToDisable = @(
    "Browser",          # Computer Browser
    "SSDPSRV",         # SSDP Discovery
    "upnphost",        # UPnP Device Host
    "lmhosts"          # TCP/IP NetBIOS Helper
)

foreach ($service in $servicesToDisable) {
    Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Log "Disabled service: $service"
}

# 6. Configure Network Access Protection
Write-Log "Configuring Network Access Protection..."

# Set network access restrictions
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
Set-ItemProperty -Path $regPath -Name "RestrictAnonymous" -Value 1
Set-ItemProperty -Path $regPath -Name "RestrictAnonymousSAM" -Value 1
Set-ItemProperty -Path $regPath -Name "EveryoneIncludesAnonymous" -Value 0

# 7. Configure RDP Security
Write-Log "Configuring RDP Security..."

# Enable Network Level Authentication
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Set minimum encryption level
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "MinEncryptionLevel" -Value 3

# 8. Configure DNS Security
Write-Log "Configuring DNS Security..."

# Enable DNS over HTTPS (DoH)
#if (Get-Command "Set-DnsClientDohServerAddress" -ErrorAction SilentlyContinue) {
#    Set-DnsClientDohServerAddress -ServerAddress "1.1.1.1" -AutoUpgrade $true
#}

# 9. Configure TLS Settings
Write-Log "Configuring TLS Settings..."

# Disable old TLS/SSL versions
$protocols = @(
    "SSL 2.0",
    "SSL 3.0",
    "TLS 1.0",
    "TLS 1.1"
)

$regKeys = @(
    "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
)

foreach ($protocol in $protocols) {
    foreach ($regKey in $regKeys) {
        $key = "$regKey\$protocol"
        if (!(Test-Path $key)) {
            New-Item -Path $key -Force | Out-Null
        }
        New-Item -Path "$key\Server" -Force | Out-Null
        New-Item -Path "$key\Client" -Force | Out-Null
        Set-ItemProperty -Path "$key\Server" -Name "Enabled" -Value 0
        Set-ItemProperty -Path "$key\Server" -Name "DisabledByDefault" -Value 1
        Set-ItemProperty -Path "$key\Client" -Name "Enabled" -Value 0
        Set-ItemProperty -Path "$key\Client" -Name "DisabledByDefault" -Value 1
    }
}

# Enable TLS 1.2 and 1.3
foreach ($version in @("TLS 1.2", "TLS 1.3")) {
    $key = "$regKeys\$version"
    if (!(Test-Path $key)) {
        New-Item -Path $key -Force | Out-Null
    }
    New-Item -Path "$key\Server" -Force | Out-Null
    New-Item -Path "$key\Client" -Force | Out-Null
    Set-ItemProperty -Path "$key\Server" -Name "Enabled" -Value 1
    Set-ItemProperty -Path "$key\Server" -Name "DisabledByDefault" -Value 0
    Set-ItemProperty -Path "$key\Client" -Name "Enabled" -Value 1
    Set-ItemProperty -Path "$key\Client" -Name "DisabledByDefault" -Value 0
}

Write-Log "Security configuration completed. A system restart is recommended."

# Output final message
Write-Host "`nNetwork security configuration completed. Please review the log file at $env:SystemDrive\SecurityConfig.log"
Write-Host "It is recommended to restart the server for all changes to take effect."

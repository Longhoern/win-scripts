# Enable all firewall profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Function to get valid firewall profile input
function Get-ValidFirewallProfile {
    $validProfiles = @('Domain', 'Private', 'Public')
    while ($true) {
        $profile = Read-Host "Enter the firewall profile you want to configure (Domain/Private/Public)"
        if ($validProfiles -contains $profile) {
            return $profile
        }
        Write-Host "Invalid profile. Please enter Domain, Private, or Public."
    }
}

# Get user's preferred firewall profile
$selectedProfile = Get-ValidFirewallProfile

# Allow RDP through the selected firewall profile
New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -Profile $selectedProfile

# Allow ICMPv4 (ping) through the selected firewall profile
New-NetFirewallRule -DisplayName "Allow ICMPv4" -Protocol ICMPv4 -IcmpType 8 -Action Allow -Profile $selectedProfile

Write-Host "Firewall configuration completed successfully."
Write-Host "RDP and ICMPv4 have been allowed through the $selectedProfile firewall profile."

function Set-ICMPv4Firewall {
    [CmdletBinding()]
    param()

    begin {
        # Check if running with administrator privileges
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        if (-not $isAdmin) {
            throw "This cmdlet requires administrator privileges. Please run PowerShell as an administrator."
        }
    }

    process {
        # Prompt user for choice
        $userChoice = Read-Host "Do you want to enable or disable ICMPv4 on all firewall profiles? (Enable/Disable)"
        
        $firewallProfiles = @("Domain", "Private", "Public")

        if ($userChoice -eq "Enable" -or $userChoice -eq "enable") {
            try {
                foreach ($profile in $firewallProfiles) {
                    # Enable ICMPv4 Echo Request (incoming)
                    New-NetFirewallRule -DisplayName "Allow ICMPv4 Echo Request (Incoming)" `
                        -Direction Inbound `
                        -Protocol ICMPv4 `
                        -IcmpType 8 `
                        -Action Allow `
                        -Profile $profile `
                        -ErrorAction Stop

                    Write-Host "ICMPv4 Echo Request has been enabled for $profile profile."
                }

                Write-Host "ICMPv4 has been successfully enabled on all firewall profiles."
            }
            catch {
                Write-Error "An error occurred while enabling ICMPv4: $_"
            }
        }
        elseif ($userChoice -eq "Disable" -or $userChoice -eq "disable") {
            try {
                foreach ($profile in $firewallProfiles) {
                    # Remove existing ICMPv4 Echo Request rules
                    Remove-NetFirewallRule -DisplayName "Allow ICMPv4 Echo Request (Incoming)" -ErrorAction SilentlyContinue

                    # Create a new blocking rule
                    New-NetFirewallRule -DisplayName "Block ICMPv4 Echo Request (Incoming)" `
                        -Direction Inbound `
                        -Protocol ICMPv4 `
                        -IcmpType 8 `
                        -Action Block `
                        -Profile $profile `
                        -ErrorAction Stop

                    Write-Host "ICMPv4 Echo Request has been disabled for $profile profile."
                }

                Write-Host "ICMPv4 has been successfully disabled on all firewall profiles."
            }
            catch {
                Write-Error "An error occurred while disabling ICMPv4: $_"
            }
        }
        else {
            Write-Host "Invalid choice. Please run the cmdlet again and enter either 'Enable' or 'Disable'."
        }
    }
}

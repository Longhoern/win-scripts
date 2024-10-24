# Define the list of servers
$servers = @(
    "SERVERX",
    "SERVERX",
    "SERVERX"
)

# Store credentials securely for the HyperVUtility account
$cred = Get-Credential -UserName "USERNAME" -Message "Enter user account credentials"

# Create sessions to all servers simultaneously
$sessions = New-PSSession -ComputerName $servers -Credential $cred

# Execute the command on all servers in parallel
Invoke-Command -Session $sessions -ScriptBlock {
    Set-Content -Path "C:\README.txt" -Value "Get Gooder"
}

# Clean up by removing all sessions
Remove-PSSession $sessions

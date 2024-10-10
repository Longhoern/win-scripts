# Get all Hyper-V VMs
$vms = Get-VM

# Display list of VMs
Write-Host "Available Hyper-V VMs:"
$vms | ForEach-Object { Write-Host "$($_.VMId): $($_.Name)" }

# Get user input for VM selection
$selectedVMs = Read-Host "Enter the VM IDs you want to configure (comma-separated, or 'all' for all VMs)"

# Process user input
if ($selectedVMs -eq "all") {
    $selectedVMs = $vms
} else {
    $selectedVMIds = $selectedVMs -split "," | ForEach-Object { $_.Trim() }
    $selectedVMs = $vms | Where-Object { $_.VMId -in $selectedVMIds }
}

# Get available virtual switches
$switches = Get-VMSwitch

# Display list of virtual switches
Write-Host "`nAvailable virtual switches:"
$switches | ForEach-Object { Write-Host "$($_.Id): $($_.Name)" }

# Get user input for switch selection
$selectedSwitchId = Read-Host "Enter the ID of the virtual switch you want to use"

# Get the selected switch
$selectedSwitch = $switches | Where-Object { $_.Id -eq $selectedSwitchId }

if ($selectedSwitch -eq $null) {
    Write-Host "Invalid switch ID. Exiting script."
    exit
}

# Configure VMs to use the selected switch
foreach ($vm in $selectedVMs) {
    try {
        $vm | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $selectedSwitch.Name
        Write-Host "Successfully configured $($vm.Name) to use $($selectedSwitch.Name)"
    } catch {
        Write-Host "Failed to configure $($vm.Name): $_"
    }
}

Write-Host "`nConfiguration complete."

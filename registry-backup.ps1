# Script to backup Windows Registry with timestamp

# Create timestamp for the filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HH.mm"

# Set the backup directory
$backupDir = "C:\Backups\Registry"

# Create the backup directory if it doesn't exist
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
}

# Set the full path for the backup file with timestamp
$backupFile = Join-Path $backupDir "RegistryBackup_$timestamp.reg"

# Backup the entire HKLM registry hive
Write-Host "Backing up Windows Registry..."
reg export HKLM $backupFile /y

# Check if the backup was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Registry backup completed successfully."
    Write-Host "Backup file location: $backupFile"
} else {
    Write-Host "Registry backup failed. Please ensure you're running this script as an administrator."
}
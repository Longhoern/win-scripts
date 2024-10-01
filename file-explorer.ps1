# PowerShell script to show hidden files and file extensions in Windows Explorer

# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

# Show file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Restart Windows Explorer to apply changes
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Hidden files and file extensions are now visible in Windows Explorer."
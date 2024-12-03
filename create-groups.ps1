# Import required module
Import-Module ActiveDirectory

# Function to create AD group if it doesn't exist
function Create-ADGroupIfNotExists {
    param (
        [string]$GroupName,
        [string]$GroupCategory = "Security",
        [string]$GroupScope = "Global"
    )
    
    if (-not (Get-ADGroup -Filter {Name -eq $GroupName})) {
        New-ADGroup -Name $GroupName -GroupCategory $GroupCategory -GroupScope $GroupScope
        Write-Host "Created group: $GroupName"
    }
    else {
        Write-Host "Group $GroupName already exists"
    }
}

# Function to add group member safely
function Add-GroupMemberSafely {
    param (
        [string]$ParentGroup,
        [string]$ChildGroup
    )
    
    try {
        Add-ADGroupMember -Identity $ParentGroup -Members $ChildGroup
        Write-Host "Added $ChildGroup under $ParentGroup"
    }
    catch {
        Write-Error "Error adding $ChildGroup to $ParentGroup: $_"
    }
}

# Create all groups first
$allGroups = @(
    "Full_Time_Employees",
    "Part_Time_Employees",
    "IT_Admins",
    "Network_Admins",
    "Developers",
    "Support_Engineers",
    "Database_Admins",
    "Helpdesk_Staff",
    "Executive_Board",
    "Operations_Team",
    "Security_Team",
    "Finance_Team",
    "Customer_Service",
    "Project_Managers",
    "Remote_Workers",
    "Marketing_Staff",
    "Sales_Leads",
    "Product_Designers",
    "Research_Analysts",
    "QA_Testers",
    "HR_Managers",
    "Training_Staff",
    "Legal_Department",
    "Contractors",
    "Interns"
)

foreach ($group in $allGroups) {
    Create-ADGroupIfNotExists -GroupName $group
}

# Setup Full_Time_Employees hierarchy
Write-Host "`nSetting up Full_Time_Employees hierarchy..."

# IT_Admins branch
Add-GroupMemberSafely -ParentGroup "Full_Time_Employees" -ChildGroup "IT_Admins"
$itAdminsChildren = @("Network_Admins", "Developers", "Support_Engineers", "Database_Admins", "Helpdesk_Staff")
foreach ($child in $itAdminsChildren) {
    Add-GroupMemberSafely -ParentGroup "IT_Admins" -ChildGroup $child
}

# Executive_Board branch
Add-GroupMemberSafely -ParentGroup "Full_Time_Employees" -ChildGroup "Executive_Board"
Add-GroupMemberSafely -ParentGroup "Executive_Board" -ChildGroup "Operations_Team"
$opsTeamChildren = @("Security_Team", "Finance_Team", "Customer_Service", "Project_Managers", "Remote_Workers")
foreach ($child in $opsTeamChildren) {
    Add-GroupMemberSafely -ParentGroup "Operations_Team" -ChildGroup $child
}

# Marketing_Staff branch
Add-GroupMemberSafely -ParentGroup "Full_Time_Employees" -ChildGroup "Marketing_Staff"
Add-GroupMemberSafely -ParentGroup "Marketing_Staff" -ChildGroup "Sales_Leads"

# Product_Designers branch
Add-GroupMemberSafely -ParentGroup "Full_Time_Employees" -ChildGroup "Product_Designers"
$productDesignersChildren = @("Research_Analysts", "QA_Testers")
foreach ($child in $productDesignersChildren) {
    Add-GroupMemberSafely -ParentGroup "Product_Designers" -ChildGroup $child
}

# HR_Managers branch
Add-GroupMemberSafely -ParentGroup "Full_Time_Employees" -ChildGroup "HR_Managers"
$hrManagersChildren = @("Training_Staff", "Legal_Department")
foreach ($child in $hrManagersChildren) {
    Add-GroupMemberSafely -ParentGroup "HR_Managers" -ChildGroup $child
}

# Setup Part_Time_Employees hierarchy
Write-Host "`nSetting up Part_Time_Employees hierarchy..."
Add-GroupMemberSafely -ParentGroup "Part_Time_Employees" -ChildGroup "Operations_Team"
$partTimeChildren = @("Contractors", "Interns")
foreach ($child in $partTimeChildren) {
    Add-GroupMemberSafely -ParentGroup "Operations_Team" -ChildGroup $child
}

# Verify the configuration
Write-Host "`nVerifying group hierarchy..."

function Get-ADGroupStructure {
    param (
        [string]$GroupName,
        [int]$Level = 0
    )
    
    $indent = "    " * $Level
    Write-Host "$indent$GroupName"
    $members = Get-ADGroupMember -Identity $GroupName | Where-Object {$_.objectClass -eq "group"}
    foreach ($member in $members) {
        Get-ADGroupStructure -GroupName $member.name -Level ($Level + 1)
    }
}

Write-Host "`nFull group hierarchy:"
Get-ADGroupStructure -GroupName "Full_Time_Employees"
Get-ADGroupStructure -GroupName "Part_Time_Employees"

Write-Host "`nGroup hierarchy configuration completed"

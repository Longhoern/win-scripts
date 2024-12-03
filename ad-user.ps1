# Import required module
Import-Module ActiveDirectory

# First, create all the AD groups if they don't exist
$groups = @(
    "IT_Admins", "HR_Managers", "Finance_Team", "Marketing_Staff", "Sales_Leads",
    "Developers", "QA_Testers", "Support_Engineers", "Project_Managers", "Executive_Board",
    "Interns", "Remote_Workers", "Contractors", "Full_Time_Employees", "Part_Time_Employees",
    "Network_Admins", "Database_Admins", "Security_Team", "Helpdesk_Staff", "Operations_Team",
    "Legal_Department", "Research_Analysts", "Product_Designers", "Customer_Service", "Training_Staff"
)

foreach ($group in $groups) {
    if (-not (Get-ADGroup -Filter {Name -eq $group})) {
        New-ADGroup -Name $group -GroupScope Global -GroupCategory Security
        Write-Host "Created group: $group"
    }
}

# Create a function to generate a secure password
function Generate-SecurePassword {
    $length = 12
    $nonAlphaChars = 5
    Add-Type -AssemblyName 'System.Web'
    $password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
    return (ConvertTo-SecureString -String $password -AsPlainText -Force)
}

# Create an array of users with their information
$users = @(
    @{
        FirstName = "John"; LastName = "Doe"
        Email = "john.doe@example.com"
        Phone = "(555) 123-4567"
        Address = "123 Maple Street"
        City = "Springfield"; State = "IL"; PostalCode = "62701"
        Groups = @("IT_Admins", "Full_Time_Employees")
    }
    # Add more users here in the same format
)

# Function to create a user in Active Directory
function Create-ADUser {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$UserInfo
    )
    
    $samAccountName = "$($UserInfo.FirstName.ToLower()).$($UserInfo.LastName.ToLower())"
    $userPrincipalName = "$samAccountName@example.com"
    
    try {
        if (-not (Get-ADUser -Filter {SamAccountName -eq $samAccountName})) {
            $params = @{
                Name = "$($UserInfo.FirstName) $($UserInfo.LastName)"
                GivenName = $UserInfo.FirstName
                Surname = $UserInfo.LastName
                SamAccountName = $samAccountName
                UserPrincipalName = $userPrincipalName
                EmailAddress = $UserInfo.Email
                StreetAddress = $UserInfo.Address
                City = $UserInfo.City
                State = $UserInfo.State
                PostalCode = $UserInfo.PostalCode
                OfficePhone = $UserInfo.Phone
                Enabled = $true
                AccountPassword = (Generate-SecurePassword)
                ChangePasswordAtLogon = $true
            }
            
            New-ADUser @params
            Write-Host "Created user: $($UserInfo.FirstName) $($UserInfo.LastName)"
            
            # Add user to specified groups
            foreach ($group in $UserInfo.Groups) {
                Add-ADGroupMember -Identity $group -Members $samAccountName
                Write-Host "Added $samAccountName to group: $group"
            }
        }
        else {
            Write-Host "User $samAccountName already exists"
        }
    }
    catch {
        Write-Error "Error creating user $samAccountName : $_"
    }
}

# Import all users
foreach ($user in $users) {
    Create-ADUser -UserInfo $user
}

Write-Host "User import process completed"

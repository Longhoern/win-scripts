# Import required module
Import-Module ActiveDirectory

# Create a function to generate a secure password
function Generate-SecurePassword {
    $length = 12
    $nonAlphaChars = 5
    Add-Type -AssemblyName 'System.Web'
    $password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
    return (ConvertTo-SecureString -String $password -AsPlainText -Force)
}

# Users 1-10
$users = @(
    @{
        FirstName = "John"; LastName = "Doe"
        Email = "john.doe@example.com"
        Phone = "(555) 123-4567"
        Address = "123 Maple Street"
        City = "Springfield"; State = "IL"; PostalCode = "62701"
        Groups = @("IT_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Jane"; LastName = "Smith"
        Email = "jane.smith@example.com"
        Phone = "(555) 234-5678"
        Address = "456 Oak Avenue"
        City = "Austin"; State = "TX"; PostalCode = "73301"
        Groups = @("HR_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Michael"; LastName = "Johnson"
        Email = "michael.johnson@example.com"
        Phone = "(555) 345-6789"
        Address = "789 Pine Road"
        City = "Denver"; State = "CO"; PostalCode = "80201"
        Groups = @("Finance_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Emily"; LastName = "Davis"
        Email = "emily.davis@example.com"
        Phone = "(555) 456-7890"
        Address = "101 Birch Lane"
        City = "Seattle"; State = "WA"; PostalCode = "98101"
        Groups = @("Marketing_Staff", "Full_Time_Employees")
    },
    @{
        FirstName = "David"; LastName = "Brown"
        Email = "david.brown@example.com"
        Phone = "(555) 567-8901"
        Address = "202 Cedar Street"
        City = "Miami"; State = "FL"; PostalCode = "33101"
        Groups = @("Sales_Leads", "Full_Time_Employees")
    },
    @{
        FirstName = "Sarah"; LastName = "Wilson"
        Email = "sarah.wilson@example.com"
        Phone = "(555) 678-9012"
        Address = "303 Elm Drive"
        City = "Boston"; State = "MA"; PostalCode = "02101"
        Groups = @("Developers", "Full_Time_Employees")
    },
    @{
        FirstName = "James"; LastName = "Taylor"
        Email = "james.taylor@example.com"
        Phone = "(555) 789-0123"
        Address = "404 Walnut Avenue"
        City = "San Francisco"; State = "CA"; PostalCode = "94101"
        Groups = @("QA_Testers", "Full_Time_Employees")
    },
    @{
        FirstName = "Laura"; LastName = "Martinez"
        Email = "laura.martinez@example.com"
        Phone = "(555) 890-1234"
        Address = "505 Chestnut Road"
        City = "Chicago"; State = "IL"; PostalCode = "60601"
        Groups = @("Support_Engineers", "Full_Time_Employees")
    },
    @{
        FirstName = "Robert"; LastName = "Anderson"
        Email = "robert.anderson@example.com"
        Phone = "(555) 901-2345"
        Address = "606 Maple Boulevard"
        City = "Houston"; State = "TX"; PostalCode = "77001"
        Groups = @("Project_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Linda"; LastName = "Thomas"
        Email = "linda.thomas@example.com"
        Phone = "(555) 012-3456"
        Address = "707 Oak Street"
        City = "Phoenix"; State = "AZ"; PostalCode = "85001"
        Groups = @("Executive_Board", "Full_Time_Employees")
    }
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

# Import users
foreach ($user in $users) {
    Create-ADUser -UserInfo $user
}

Write-Host "User import process completed for users 1-10"

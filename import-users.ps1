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
        @{
        FirstName = "William"; LastName = "Jackson"
        Email = "william.jackson@example.com"
        Phone = "(555) 123-4567"
        Address = "808 Pine Avenue"
        City = "Philadelphia"; State = "PA"; PostalCode = "19101"
        Groups = @("Network_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Patricia"; LastName = "White"
        Email = "patricia.white@example.com"
        Phone = "(555) 234-5678"
        Address = "909 Birch Road"
        City = "Atlanta"; State = "GA"; PostalCode = "30301"
        Groups = @("Database_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Charles"; LastName = "Harris"
        Email = "charles.harris@example.com"
        Phone = "(555) 345-6789"
        Address = "1010 Cedar Lane"
        City = "Dallas"; State = "TX"; PostalCode = "75201"
        Groups = @("Security_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Barbara"; LastName = "Clark"
        Email = "barbara.clark@example.com"
        Phone = "(555) 456-7890"
        Address = "1111 Elm Street"
        City = "San Diego"; State = "CA"; PostalCode = "92101"
        Groups = @("Helpdesk_Staff", "Full_Time_Employees")
    },
    @{
        FirstName = "Joseph"; LastName = "Lewis"
        Email = "joseph.lewis@example.com"
        Phone = "(555) 567-8901"
        Address = "1212 Walnut Drive"
        City = "Orlando"; State = "FL"; PostalCode = "32801"
        Groups = @("Operations_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Nancy"; LastName = "Walker"
        Email = "nancy.walker@example.com"
        Phone = "(555) 678-9012"
        Address = "1313 Maple Street"
        City = "Springfield"; State = "IL"; PostalCode = "62701"
        Groups = @("Legal_Department", "Full_Time_Employees")
    },
    @{
        FirstName = "Steven"; LastName = "Hall"
        Email = "steven.hall@example.com"
        Phone = "(555) 789-0123"
        Address = "1414 Oak Avenue"
        City = "Austin"; State = "TX"; PostalCode = "73301"
        Groups = @("Research_Analysts", "Full_Time_Employees")
    },
    @{
        FirstName = "Karen"; LastName = "Young"
        Email = "karen.young@example.com"
        Phone = "(555) 890-1234"
        Address = "1515 Pine Road"
        City = "Denver"; State = "CO"; PostalCode = "80201"
        Groups = @("Product_Designers", "Full_Time_Employees")
    },
    @{
        FirstName = "Brian"; LastName = "King"
        Email = "brian.king@example.com"
        Phone = "(555) 901-2345"
        Address = "1616 Birch Lane"
        City = "Seattle"; State = "WA"; PostalCode = "98101"
        Groups = @("Customer_Service", "Full_Time_Employees")
    },
    @{
        FirstName = "Lisa"; LastName = "Scott"
        Email = "lisa.scott@example.com"
        Phone = "(555) 012-3456"
        Address = "1717 Cedar Street"
        City = "Miami"; State = "FL"; PostalCode = "33101"
        Groups = @("Training_Staff", "Full_Time_Employees")
    }
        @{
        FirstName = "Kevin"; LastName = "Green"
        Email = "kevin.green@example.com"
        Phone = "(555) 123-4567"
        Address = "1818 Elm Drive"
        City = "Boston"; State = "MA"; PostalCode = "02101"
        Groups = @("IT_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Michelle"; LastName = "Adams"
        Email = "michelle.adams@example.com"
        Phone = "(555) 234-5678"
        Address = "1919 Walnut Avenue"
        City = "San Francisco"; State = "CA"; PostalCode = "94101"
        Groups = @("HR_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Jason"; LastName = "Baker"
        Email = "jason.baker@example.com"
        Phone = "(555) 345-6789"
        Address = "2020 Chestnut Road"
        City = "Chicago"; State = "IL"; PostalCode = "60601"
        Groups = @("Finance_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Rebecca"; LastName = "Nelson"
        Email = "rebecca.nelson@example.com"
        Phone = "(555) 456-7890"
        Address = "2121 Maple Boulevard"
        City = "Houston"; State = "TX"; PostalCode = "77001"
        Groups = @("Marketing_Staff", "Full_Time_Employees")
    },
    @{
        FirstName = "Eric"; LastName = "Carter"
        Email = "eric.carter@example.com"
        Phone = "(555) 567-8901"
        Address = "2222 Oak Street"
        City = "Phoenix"; State = "AZ"; PostalCode = "85001"
        Groups = @("Sales_Leads", "Full_Time_Employees")
    },
    @{
        FirstName = "Laura"; LastName = "Mitchell"
        Email = "laura.mitchell@example.com"
        Phone = "(555) 678-9012"
        Address = "2323 Pine Avenue"
        City = "Philadelphia"; State = "PA"; PostalCode = "19101"
        Groups = @("Developers", "Full_Time_Employees")
    },
    @{
        FirstName = "Ryan"; LastName = "Perez"
        Email = "ryan.perez@example.com"
        Phone = "(555) 789-0123"
        Address = "2424 Birch Road"
        City = "Atlanta"; State = "GA"; PostalCode = "30301"
        Groups = @("QA_Testers", "Full_Time_Employees")
    },
    @{
        FirstName = "Megan"; LastName = "Roberts"
        Email = "megan.roberts@example.com"
        Phone = "(555) 890-1234"
        Address = "2525 Cedar Lane"
        City = "Dallas"; State = "TX"; PostalCode = "75201"
        Groups = @("Support_Engineers", "Full_Time_Employees")
    },
    @{
        FirstName = "Joshua"; LastName = "Turner"
        Email = "joshua.turner@example.com"
        Phone = "(555) 901-2345"
        Address = "2626 Elm Street"
        City = "San Diego"; State = "CA"; PostalCode = "92101"
        Groups = @("Project_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Stephanie"; LastName = "Phillips"
        Email = "stephanie.phillips@example.com"
        Phone = "(555) 012-3456"
        Address = "2727 Walnut Drive"
        City = "Orlando"; State = "FL"; PostalCode = "32801"
        Groups = @("Executive_Board", "Full_Time_Employees")
    }
        @{
        FirstName = "Kevin"; LastName = "Green"
        Email = "kevin.green@example.com"
        Phone = "(555) 123-4567"
        Address = "1818 Elm Drive"
        City = "Boston"; State = "MA"; PostalCode = "02101"
        Groups = @("IT_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Michelle"; LastName = "Adams"
        Email = "michelle.adams@example.com"
        Phone = "(555) 234-5678"
        Address = "1919 Walnut Avenue"
        City = "San Francisco"; State = "CA"; PostalCode = "94101"
        Groups = @("HR_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Jason"; LastName = "Baker"
        Email = "jason.baker@example.com"
        Phone = "(555) 345-6789"
        Address = "2020 Chestnut Road"
        City = "Chicago"; State = "IL"; PostalCode = "60601"
        Groups = @("Finance_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Rebecca"; LastName = "Nelson"
        Email = "rebecca.nelson@example.com"
        Phone = "(555) 456-7890"
        Address = "2121 Maple Boulevard"
        City = "Houston"; State = "TX"; PostalCode = "77001"
        Groups = @("Marketing_Staff", "Full_Time_Employees")
    },
    @{
        FirstName = "Eric"; LastName = "Carter"
        Email = "eric.carter@example.com"
        Phone = "(555) 567-8901"
        Address = "2222 Oak Street"
        City = "Phoenix"; State = "AZ"; PostalCode = "85001"
        Groups = @("Sales_Leads", "Full_Time_Employees")
    },
    @{
        FirstName = "Laura"; LastName = "Mitchell"
        Email = "laura.mitchell@example.com"
        Phone = "(555) 678-9012"
        Address = "2323 Pine Avenue"
        City = "Philadelphia"; State = "PA"; PostalCode = "19101"
        Groups = @("Developers", "Full_Time_Employees")
    },
    @{
        FirstName = "Ryan"; LastName = "Perez"
        Email = "ryan.perez@example.com"
        Phone = "(555) 789-0123"
        Address = "2424 Birch Road"
        City = "Atlanta"; State = "GA"; PostalCode = "30301"
        Groups = @("QA_Testers", "Full_Time_Employees")
    },
    @{
        FirstName = "Megan"; LastName = "Roberts"
        Email = "megan.roberts@example.com"
        Phone = "(555) 890-1234"
        Address = "2525 Cedar Lane"
        City = "Dallas"; State = "TX"; PostalCode = "75201"
        Groups = @("Support_Engineers", "Full_Time_Employees")
    },
    @{
        FirstName = "Joshua"; LastName = "Turner"
        Email = "joshua.turner@example.com"
        Phone = "(555) 901-2345"
        Address = "2626 Elm Street"
        City = "San Diego"; State = "CA"; PostalCode = "92101"
        Groups = @("Project_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Stephanie"; LastName = "Phillips"
        Email = "stephanie.phillips@example.com"
        Phone = "(555) 012-3456"
        Address = "2727 Walnut Drive"
        City = "Orlando"; State = "FL"; PostalCode = "32801"
        Groups = @("Executive_Board", "Full_Time_Employees")
    }
    @{
        FirstName = "Daniel"; LastName = "Morgan"
        Email = "daniel.morgan@example.com"
        Phone = "(555) 123-4567"
        Address = "3838 Pine Avenue"
        City = "Philadelphia"; State = "PA"; PostalCode = "19101"
        Groups = @("IT_Admins", "Full_Time_Employees")
    },
    @{
        FirstName = "Victoria"; LastName = "Bell"
        Email = "victoria.bell@example.com"
        Phone = "(555) 234-5678"
        Address = "3939 Birch Road"
        City = "Atlanta"; State = "GA"; PostalCode = "30301"
        Groups = @("HR_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Christopher"; LastName = "Murphy"
        Email = "christopher.murphy@example.com"
        Phone = "(555) 345-6789"
        Address = "4040 Cedar Lane"
        City = "Dallas"; State = "TX"; PostalCode = "75201"
        Groups = @("Finance_Team", "Full_Time_Employees")
    },
    @{
        FirstName = "Samantha"; LastName = "Bailey"
        Email = "samantha.bailey@example.com"
        Phone = "(555) 456-7890"
        Address = "4141 Elm Street"
        City = "San Diego"; State = "CA"; PostalCode = "92101"
        Groups = @("Marketing_Staff", "Full_Time_Employees")
    },
    @{
        FirstName = "Anthony"; LastName = "Rivera"
        Email = "anthony.rivera@example.com"
        Phone = "(555) 567-8901"
        Address = "4242 Walnut Drive"
        City = "Orlando"; State = "FL"; PostalCode = "32801"
        Groups = @("Sales_Leads", "Full_Time_Employees")
    },
    @{
        FirstName = "Elizabeth"; LastName = "Cooper"
        Email = "elizabeth.cooper@example.com"
        Phone = "(555) 678-9012"
        Address = "4343 Maple Street"
        City = "Springfield"; State = "IL"; PostalCode = "62701"
        Groups = @("Developers", "Full_Time_Employees")
    },
    @{
        FirstName = "Jonathan"; LastName = "Richardson"
        Email = "jonathan.richardson@example.com"
        Phone = "(555) 789-0123"
        Address = "4444 Oak Avenue"
        City = "Austin"; State = "TX"; PostalCode = "73301"
        Groups = @("QA_Testers", "Full_Time_Employees")
    },
    @{
        FirstName = "Kimberly"; LastName = "Cox"
        Email = "kimberly.cox@example.com"
        Phone = "(555) 890-1234"
        Address = "4545 Pine Road"
        City = "Denver"; State = "CO"; PostalCode = "80201"
        Groups = @("Support_Engineers", "Full_Time_Employees")
    },
    @{
        FirstName = "Timothy"; LastName = "Howard"
        Email = "timothy.howard@example.com"
        Phone = "(555) 901-2345"
        Address = "4646 Birch Lane"
        City = "Seattle"; State = "WA"; PostalCode = "98101"
        Groups = @("Project_Managers", "Full_Time_Employees")
    },
    @{
        FirstName = "Melissa"; LastName = "Ward"
        Email = "melissa.ward@example.com"
        Phone = "(210) 486-1007"
        Address = "1819 N. Main Ave."
        City = "San Antonio"; State = "TX"; PostalCode = "78212"
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

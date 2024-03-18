# Import the CSV file containing the list of users
$userList = Import-Csv "C:\Path\To\File.csv"

# Initialize an array to store new users
$newUsers = @()

# Define the default password for new users
$password = "$password$"

# Import the CSV file containing the security group assignments
$sgAssignments = Import-Csv "C:\Path\To\File.csv"

# Define the path for the new users CSV file
$newUsersCsvPath = "C:\Path\To\File.csv"


# Loop through each user in the user list
foreach ($user in $userList) {
    $i = 0
    do {
        # Generate the SamAccountName and UserPrincipalName for the user
        $samAccountName = ($user.'Last Name' + $user.'First Name'[$i]).ToLower()
        $userPrincipalName = ($user.'Last Name' + $user.'First Name'[$i] + '@ecorp.org').ToLower()

        # Generate the email address
        if ($i -gt 0) {
            $emailAddress = ($user.'First Name' + '.' + $user.'Last Name' + $user.'First Name'[$i] + '@ecorp.org').ToLower()
        } else {
            $emailAddress = ($user.'First Name' + '.' + $user.'Last Name' + '@ecorp.org').ToLower()
        }


        # Check if the user already exists in Active Directory
        $existingUser = Get-ADUser -Filter {(SamAccountName -eq $samAccountName) -or (UserPrincipalName -eq $userPrincipalName)} 
        if ($null -eq $existingUser) {
            # Define the properties for the new user
            $userProps = @{
                'Path'              = 'OU=USERS,OU=' + $user.'Location' + ',OU=LOCATIONS,DC=ecorp,DC=local'
                'SamAccountName'    = $samAccountName
                'UserPrincipalName' = $userPrincipalName
                'Name'              = ($user.'First Name' + ' ' + $user.'Last Name')
                'Displayname'       = ($user.'First Name' + ' ' + $user.'Last Name')
                'GivenName'         = $user.'First Name'
                'Surname'           = $user.'Last Name'
                'EmployeeID'        = $user.'Employee ID'
                'Title'             = $user.'Job Title'
                'Department'        = $user.'Department'
                'Manager'           = $user.'Reporting Manager '
                'Description'       = $user.'Job Title' + ' - ' + $user.'Location'
                'Office'            = $user.'Location'
                'Company'           = 'Clinica Sierra Vista'
            }

            # Create the new user in Active Directory
            New-AdUser @userProps

            # Get the security groups for the user's job title
            $title = $user.'Job Title'
            $sgs = $sgAssignments | Where-Object { $_.'JOB_TITLES' -eq $title }

            # Split the 'Security_Groups' string into an array
            $securityGroups = $sgs.'Security_Groups' -split ','

            # Add the user to each security group
            foreach ($sg in $securityGroups) {
                Add-ADGroupMember -Identity $sg.Trim() -Members $samAccountName
            }

            # Get the manager's name and split it into first and last name
            $managerName = $user.'Reporting Manager' -split ' ', 2
            if ($managerName.Count -eq 2) {
                $managerFirstName = $managerName[0] -replace '[^a-zA-Z]', '' 
                $managerLastName = $managerName[1] -replace '[^a-zA-Z]', '' 

                # Get the manager's user object from Active Directory
                $filter = "GivenName -eq '$managerFirstName' -and Surname -eq '$managerLastName'"
                $manager = Get-ADUser -Filter $filter

                # If the manager exists, set the manager for the user
                if ($null -ne $manager) {
                    $managerDN = $manager.DistinguishedName
                    Set-AdUser -Identity $samAccountName -Manager $managerDN
                } else {
                    Write-Output "Manager's name $($user.'Reporting Manager') is not properly formatted, not setting manager for user $samAccountName"
                }
            } else {
                Write-Output "Manager's name $($user.'Reporting Manager') is not properly formatted, not setting manager for user $samAccountName"
            }

            # Set the user's password
            $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
            Set-AdAccountPassword -Identity $samAccountName -NewPassword $securePassword -Reset

            # Require the user to change their password at next logon
            Set-AdUser $samAccountName -ChangePasswordAtLogon $true

            # Set the user's proxy addresses
            if ($i -gt 0) {
                $proxyAddresses = 'smtp:' + $samAccountName + '@ecorp.org',"," + 'SMTP:' + ($user.'First Name' + '.' + $user.'Last Name' + $user.'First Name'[$i] + '@ecorp.org').ToLower() -split ","
            } else {
                $proxyAddresses = 'SMTP:' + ($user.'First Name' + '.' + $user.'Last Name' + '@ecorp.org').ToLower(),"," + 'smtp:' + ($user.'Last Name' + $user.'First Name'[0] + '@ecorp.org').ToLower() -split ","
            }
            Set-AdUser -Identity $samAccountName -Add @{ProxyAddresses = $proxyAddresses}
            # Set the user's email address
            Set-ADUser -Identity $samAccountName -EmailAddress $emailAddress

            # Enable the user account
            Enable-ADAccount -Identity $samAccountName

            # Add the new user to the new users array
            $newUsers += New-Object PSObject -Property @{
                'Name'              = $userProps['Name']
                'SamAccountName'    = $samAccountName
                'UserPrincipalName' = $userPrincipalName
                'EmployeeID'        = $userProps['EmployeeID']
                'Password'          = "$password$"
            }

            break
        } else {
            Write-Output "User $samAccountName or $userPrincipalName already exists, trying next letter"
            $i++
        }

    } while ($i -lt $user.'First Name'.Length)
    if ($i -eq $user.'First Name'.Length) {
        Write-Output "All letters in the first name have been used, could not create a unique SamAccountName or UserPrincipalName for user $user.'First Name' $user.'Last Name'"
    }
}

# Export the new users to a CSV file
$newUsers | Export-Csv -Path $newUsersCsvPath -NoTypeInformation
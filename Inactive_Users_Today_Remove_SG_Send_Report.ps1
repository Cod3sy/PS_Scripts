# Set the path to the CSV file

$csvPath = "C:\Your\File\Path.csv"

# Set the destination OU where users will be moved

$destinationOU = "OU=Your,DC=Sepcified,DC=Organizational Unit"

# Set the email configuration
$smtpServer = "Email Server"
$fromAddress = "Email Address Sender"
$toAddress = "Email Address Recipient"
$subject = "Inactivated Users Report"
$body = ""

# Import the CSV file

$users = Import-Csv -Path $csvPath

# Iterate through each user in the CSV file

foreach ($user in $users) {

    # Get the username and end date from the CSV

    $username = $user.Username

    $endDate = $user.EndDate

 

    try {

        # Find the user by username

        $adUser = Get-ADUser -Filter "SamAccountName -eq '$username'"

 

        # Check if the user was found

        if ($adUser) {

            # Check if the user is already disabled

            if (-not $adUser.Enabled) {

                # Check if the end date is in the future

                if ($endDate -gt (Get-Date)) {

                    # Move the user to the destination OU

                    Move-ADObject -Identity $adUser.DistinguishedName -TargetPath $destinationOU

                    $body += "User $username moved to Your Specified OU`n"

 

                    # Remove all security groups except "Domain Users"

                    $securityGroups = Get-ADUser $adUser | Get-ADPrincipalGroupMembership

                    foreach ($group in $securityGroups) {

                        if ($group.Name -ne "Domain Users") {

                            Remove-ADGroupMember -Identity $group.Name -Members $adUser -Confirm:$false

                            $body += "Removed user $username from group $($group.Name)`n"

                        }

                    }

                } else {

                    $body += "User $username end date has passed. Not moving or modifying groups.`n"

                }

            } else {

                $body += "User $username is not disabled. Not moving or modifying groups.`n"

            }

        } else {

            $body += "User $username not found in Active Directory.`n"

        }

    } catch {

        $body += "An error occurred while processing user $username :`n$($($_.Exception).Message)`n"

    }

}

# Send email with the report

Send-MailMessage -SmtpServer $smtpServer -From $fromAddress -To $toAddress -Subject $subject -Body $body

# Set the path to the CSV file
$csvPath = "C:\Your\File\Path.csv"

# Set the name of the security group to add the users to
$groupName = "Your Security Group Name"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Iterate through each user in the CSV file
foreach ($user in $users) {
    # Get the username from the CSV
    $username = $user.Username

    try {
        # Find the user by username
        $adUser = Get-ADUser -Filter "SamAccountName -eq '$username'"

        # Check if the user was found
        if ($adUser) {
            # Add the user to the security group
            Add-ADGroupMember -Identity $groupName -Members $adUser
            Write-Host "User $username added to group $groupName"
        } else {
            Write-Host "User $username not found in Active Directory."
        }
    } catch {
        Write-Host "An error occurred while processing user $username :`n$($($_.Exception).Message)"
    }
}
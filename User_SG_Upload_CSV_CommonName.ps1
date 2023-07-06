# Set the path to the CSV file
$csvPath = "C:\Your\File\Path.csv"

# Set the name of the security group to add the users to
$groupName = "Your Security Group Name"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Iterate through each user in the CSV file
foreach ($user in $users) {
    # Get the Common Name (CN) from the CSV
    $cn = $user.CN

    try {
        # Find the user by Common Name (CN)
        $adUser = Get-ADUser -Filter "CN -eq '$cn'"

        # Check if the user was found
        if ($adUser) {
            # Add the user to the security group
            Add-ADGroupMember -Identity $groupName -Members $adUser
            Write-Host "User $cn added to group $groupName"
        } else {
            Write-Host "User $cn not found in Active Directory."
        }
    } catch {
        Write-Host "An error occurred while processing user $cn :`n$($($_.Exception).Message)"
    }
}

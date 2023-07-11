# Specify the name of the security group
$groupName = "Your Security Group Name"

try {
    # Get the users in the security group
    $group = Get-ADGroupMember -Identity $groupName | Where-Object {$_.objectClass -eq "user"}

    # Create an array to store the user information
    $users = @()

    # Iterate through each user and retrieve their properties
    foreach ($user in $group) {
        $userInfo = Get-ADUser -Identity $user.SamAccountName -Properties DisplayName, SamAccountName, EmailAddress
        $users += $userInfo
    }

    # Export the user information to a CSV file
    $exportPath = "C:\Your\File\Path.csv"
    $users | Select-Object DisplayName, SamAccountName, EmailAddress | Export-Csv -Path $exportPath -NoTypeInformation

    Write-Host "User information exported to $exportPath"
}
catch {
    Write-Host "An error occurred while retrieving or exporting user information:"
    Write-Host $_.Exception.Message
}




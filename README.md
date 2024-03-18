# PS_Scripts

# Why
  * These scripts were written to help me perform my daily job tasks as a Information Systems Specialist with a primary function of account provisioning. 
  * I use them on a daily basis to make life easier and because PowerShell is awesome. 
  * They are not complex by any means, but I hope they can be of use to those of us who spend our lives buried in Microsoft’s proprietary software to support our end users. 

# AD_User_Automation_v1.ps1
* This script creates a user account in Active Directory with the specified user attributes and permissions when the required CSV files are given. This is a verison 1 and our hope is to expand this script into an interactive application with a UI option. 

# User_SG_Upload_CSV_CommonName
* This script allows you to upload multiple users into a Security Group from a CSV file utilizing the users First and Last Name (CN, Common Name)
  
  # How to Find CN (Common Name)
  * This can be located in the users Attribute Editor tab under the user's properties in AD (Active Directory) or ADAC (Active Directory Administrative Center).
  * If in AD, first ensure you are logged into a server on the domain containing Active Directory with the "Advanced Features" option checked under the view tab. After confirming location, navigate to the desired user, right click on the user’s name, click properties, click on "Attribute Editor" and scroll down to "CN".
  * If in ADAC, simply navigate to the desired user, right click on the user’s name, click properties, scroll down to the bottom of the dialogue box, click on "Attribute Editor" and scroll down to "CN".


# User_SG_Upload_CSV_Username
* This script allows you to upload multiple users into a Security Group from a CSV file utilizing the user’s username (User Logon Name (Pre-Windows 2000), sAMAccountName)
  
  # How to Find username
  * This can be located in the users Account tab under the user's properties in AD (Active Directory) or ADAC (Active Directory Administrative Center).
  * If in AD, navigate to the desired user, right click on the user’s name, click properties, click on the account tab. 
  * If in ADAC, navigate to the desired user, right click on the user’s name and click properties.
 
 # SG_Export_CSV_Name_Name_Username_Email
 * This script will pull a user's username (User Logon Name (Pre-Windows 2000), sAMAccountName), email (User Logon Name), First and Last Name (CN, Common Name) and export this information into a CSV with the specification of the target security group.

# Inactive_Users_Today_Remove_SG_Send_Report ~ ***WIP*** ~
* This script can be used in conjunction with a csv file containing a username (User Logon Name (Pre-Windows 2000), sAMAccountName) and an end date to disable a user, remove their security groups and finally move them to an OU containing an organization’s inactive users. This script is meant to be used with a rolling csv file to remove all access from a user at a specified time. This can automate a part of an organizations offboarding procedure if used with a scheduled task on a domain connected server. It can also be used for a large offboarding of users at once if the user data is pulled into a CSV.

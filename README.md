# PS_Scripts

# Why
  * These scripts were written to help me perform my daily job tasks as a Information Systsems Specialist with a primary function of account provisioning. 
  * I use them on a daily basis to make life easier and because powershell is awesome. 
  * They are not complex by any means, but I hope they can be of use to those of us who spend our lives buried in Microsofts's proprietary software to suport our end users. 


# User_SG_Upload_CSV_CommonName
* This script allows you to upload multiple users into a Security Group from a CSV file utilizing the users First and Last Name (CN, Common Name)
  
  # How to Find CN (Common Name)
  * This can be located in the users Attribute Edditor tab under the user's properties in AD (Active Directory) or ADAC (Active Directory Administrative Center).
  * If in AD, first ensure you are logged into a server on the domain containing Active Directory with the "Advanced Features" option checked under the view tab. After confirming location, navigate to the desired user, right click on the users name, click poperties, click on "Attribute Edditor" and scroll down to "CN".
  * If in ADAC, simply navigate to the desired user, right click on the users name, click poperties, scroll down to the bottom of the dialogue box, click on "Attribute Edditor" and scroll down to "CN".


# User_SG_Upload_CSV_Username
* This script allows you to upload multiple users into a Security Group from a CSV file utilizing the users username (User Logon Name (Pre-Windows 2000), sAMAccountName)
  
  # How to Find username
  * This can be located in the users Account tab under the user's properties in AD (Active Directory) or ADAC (Active Directory Administrative Center).
  * If in AD, navigate to the desired user, right click on the users name, click poperties, click on the account tab. 
  * If in ADAC, navigate to the desired user, right click on the users name and click poperties.
 
 # SG_Export_CSV_Name_Name_Username_Email
 * This script will pull a user's username (User Logon Name (Pre-Windows 2000), sAMAccountName), email (User Logon Name), First and Last Name (CN, Common Name) and export this information into a CSV with the specification of the target security group.

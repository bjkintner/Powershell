Import-Module ActiveDirectory

function QueryUsers {
  C:\scripts\powershell\query_users.ps1
  # do
  # {
  #   Write-Host "What branch do you want to query?"
  #   Write-Host "1) Branch 1 - Sullivan"
  #   Write-Host "1) Branch 2 - Franklinton"
  #   Write-Host "1) Branch 4 - Cumberland"
  #   Write-Host "1) Branch 6 - Angie"
  #   Write-Host "1) Branch 7 - Covington"
  #   Write-Host "1) Branch 9 - Ops Center"
  #   Write-Host "1) Branch 411 - All branches"
  #   Write-Host "0) Quit"
  #   $result = Read-Host "Please make a selection: "
  #   switch ($result) {
  #     1 {

  #     } 2 {

  #     } 4 {

  #     } 6 {

  #     } 7 {

  #     } 9 {

  #     } 411 {

  #     }
  #   }
  # } until ($result -eq '0')
  Write-Output "Returning to main menu"
}

function SearchLocked {
  $lockedUsers = Search-ADAccount -LockedOut -UsersOnly | Sort-Object -Property Name | Format-Table Name,SamAccountName
  if (!$lockedUsers) {
    "There are no users currently locked out"
  } else {
    "The following users are locked out:"
  }
  return $lockedUsers
}

function ListImpaired {
  do
  {
    Write-Host "Which accounts do you want to list?"
    Write-Host "1) Enabled"
    Write-Host "2) Disabled"
    Write-Host "3) Expired"
    Write-Host "4) Inactive"
    Write-Host "5) Locked out"
    Write-Host "0) Main menu"
    $result = Read-Host "Please make a selection: "
    switch ($result)
    {
      1 {
        Write-Host "The following accounts are enabled:"
        Get-ADUser -Filter * -Properties SamAccountName | Where-Object { $_.Enabled -eq $True} | Sort-Object -Property Name | Format-Table Name,SamAccountName
      } 2 {
        $disabledUsers = Search-ADAccount -AccountDisabled -UsersOnly | Sort-Object -Property Name | Format-Table Name,SamAccountName
        if (!$disabledUsers) {
          "There are no users currently disabled"
        } else {
          "The following users are disabled:"
          $disabledUsers
        }
      } 3 {
        $expiredUsers = Search-ADAccount -AccountExpired -UsersOnly | Sort-Object -Property Name | Format-Table Name,SamAccountName
        if (!$expiredUsers) {
          "There are no users currently expired"
        } else {
          "The following users are expired:"
          $expiredUsers
        }
      } 4 {
        $inactiveUsers = Search-ADAccount –AccountInActive –TimeSpan 30:00:00:00 | Sort-Object -Property Name | Format-Table Name,SamAccountName
        if (!$inactiveUsers) {
          "There are no users currently inactive"
        } else {
          "The following users have not logged in for 30 days:"
          $inactiveUsers
        }
      } 5 {
        $lockedUsers = Search-ADAccount -LockedOut -UsersOnly | Sort-Object -Property Name | Format-Table Name,SamAccountName
        if (!$lockedUsers) {
          "There are no users currently locked out"
        } else {
          "The following users are locked out:"
          $lockedUsers
        }
      } 0 {
        Write-Output 'Returning to main menu'
      }
    } pause
  } until ($result -eq '0')
  
  Write-Output "Returning to main menu"
}

function ResetPassword { 
  $userID = Read-Host -Prompt 'Please enter the User ID for the account you want to reset password'
  try {
    Get-ADUser -Identity $userID | Sort-Object -Property Name | Format-Table Name,SamAccountName
    try {
      $newPassword = convertto-securestring "Citizens1" -asplaintext -force
      Set-ADAccountPassword -Identity $userID -NewPassword $newPassword -Confirm
      Set-ADUser -Identity $userID -ChangePasswordAtLogon $true
      "The account password for $userID has been reset"
    } catch {
      "Could not reset password for the user"
    }
  } catch {
    "The user does not exist. Please enter a valid User ID."
  }
}

function UnlockAccount {
  $lockedUsers = Search-ADAccount -LockedOut -UsersOnly | Sort-Object -Property Name | Format-Table Name,SamAccountName
  if (!$lockedUsers) {
    "There are no users currently locked out"
  } else {
    Search-ADAccount -LockedOut | ForEach-Object {
      Write-Output ('Employee: {0}' -f $_.Name)
      Write-Output ('Login Name: {0}' -f $_.SamAccountName)
      $confirmUnlock = Read-Host -Prompt "Unlock user? 1=yes, 2=no"
      if ($confirmUnlock -eq "1") {
        Unlock-ADAccount <# -Credential bjkintner #> -Identity $_ 
        $userChoice = Read-Host -Prompt "The user has been unlocked. Do you want to reset the user password? 1=yes, 2=no"
        if ($userChoice -eq "1") {
          $newPassword = convertto-securestring "Citizens1" -asplaintext -force
          Set-ADAccountPassword -Identity $_ -NewPassword $newPassword
          Set-ADUser -Identity $_ -ChangePasswordAtLogon $true
          $userID = $_.SamAccountName
          "The account password for $userID has been reset"
        } else {
          "User password was not reset."
        }
      } else {
        "The user was not unlocked."
      }
    }
  }
}


function ListUsers {
#  Get-ADUser -Server CSB | Format-Table Name,SamAccountName
Get-ADGroupMember "Citizens Savings Bank" | Sort-Object -Property Name | Format-Table Name,SamAccountName
}

function DisableUser {
  $userID = Read-Host -Prompt 'Please enter the User ID for the account you want to disable'
  try {
    Get-ADUser -Identity $userID | Sort-Object -Property Name | Format-Table Name,SamAccountName
    Disable-ADAccount -Identity $userID -Confirm
  } catch {
    "The user you entered does not exist. Please enter a valid User ID."
  }
}

function EnableUser {
  $userID = Read-Host -Prompt 'Please enter the User ID for the account you want to enable'
  try {
    Get-ADUser -Identity $userID | Sort-Object -Property Name | Format-Table Name,SamAccountName
    Enable-ADAccount -Identity $userID -Confirm
  } catch {
    "The user you entered does not exist. Please enter a valid User ID."
  }
}

function DeleteUser {
  $userID = Read-Host -Prompt 'Please enter the User ID for the account you want to delete'
  try {
    Get-ADUser -Identity $userID | Sort-Object -Property Name | Format-Table Name,SamAccountName
    Remove-ADUser -Identity $userID -Confirm
  } catch {
    "The user you entered does not exist. Please enter a valid User ID."
  }
}

function CreateUser {
  # Get list of users to copy from
$teller = New-Object System.Management.Automation.Host.ChoiceDescription '&Teller', 'Job title: Teller'
$loan_proc = New-Object System.Management.Automation.Host.ChoiceDescription '&Loan Processor', 'Job title: Loan Processor'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($teller, $loan_proc)

$title = 'User selection'
$message = 'The new user has which job title?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

switch ($result) {
    0 {
        # list teller users
        Get-ADUser -Filter "Description -like '*Teller*'" | Format-Table Name, SamAccountName
    } 1 {
        # list loan proc users
        Get-ADUser -Filter "Description -like '*Processor*'" | Format-Table Name, SamAccountName
    }
}

# Choose user to copy
$samaccount_to_copy = Read-Host -Prompt "Type the account name for the user to copy"

$new_samaccountname = $null
$new_firstname = Read-Host -Prompt "First Name"
$new_middleinitial = Read-Host -Prompt "Middle Initial"
$new_lastname = Read-Host -Prompt "Last Name"
$new_displayname = "$new_firstname " + "$new_middleinitial " + $new_lastname
$full_name = Read-Host -Prompt "Enter display name"
$fInitial = $new_firstname.Substring(0,1)
$newUserPrincipleName = $null
$new_password = 'Citizens1'
$new_description = Get-ADUser -Identity $samaccount_to_copy -Properties Description | Select-Object -ExpandProperty Description
$new_department = Get-ADUser -Identity $samaccount_to_copy -Properties Department | Select-Object -ExpandProperty Department
$enable_user_after_creation = $true
$password_never_expires = $false
$cannot_change_password = $false
$change_at_logon = $true
$new_scriptpath = Get-ADUser -Identity $samaccount_to_copy -Properties scriptPath | Select-Object -ExpandProperty scriptPath


"Description is $new_description"
"Department is $new_department"

#username
$new_samaccountname = $fInitial + $new_lastname
if ([bool] (!(Get-ADUser -Filter { SamAccountName -eq $new_samaccountname }))) {
  "Username is available. Username is $new_samaccountname."
} else { 
  "User $new_samaccountname already exists. Modifying user name..."
  $new_samaccountname = $fName.Substring(0,1) + $mInitial + $lName
  if ([bool] (!(Get-ADUser -Filter { SamAccountName -eq $new_samaccountname }))) {
  "Username is available. Username is $new_samaccountname."
  } else {
    "User $new_samaccountname already exists. Modifying user name..."
    $new_samaccountname = $fName.Substring(0,2) + $mInitial + $lName
    "Username is $new_samaccountname."
    }
}

#email
$email = $new_samaccountname + "@citizenssb.com"
"Setting email..."
"User email address is $email" 

#misc fields
$newUserPrincipleName = $new_samaccountname + "@csb.local"


#Set variable $user to selected user to copy
$user = Get-ADUser -Identity $samaccount_to_copy -Properties company,department,description,scriptPath,title
$user.UserPrincipalName=$newUserPrincipleName


#Create new user
New-ADUser -SamAccountName $new_samaccountname -GivenName $new_firstname -Surname $new_lastname -Initials $new_middleinitial `
            -PasswordNeverExpires $password_never_expires -CannotChangePassword $cannot_change_password `
            -Enabled $enable_user_after_creation -UserPrincipalName $newUserPrincipleName -Name $full_name `
            -AccountPassword (ConvertTo-SecureString -AsPlainText $new_password -Force) -ChangePasswordAtLogon $change_at_logon `
            -DisplayName $new_displayname -Department $new_department -Description $new_description -ScriptPath $new_scriptpath `
            

# Copy group memberships
$CopyFromUser = Get-ADUser $samaccount_to_copy -prop MemberOf
$CopyToUser = Get-ADUser $new_samaccountname -prop MemberOf
$CopyFromUser.MemberOf | Where-Object{$CopyToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $CopyToUser

# Move to operations OU
$initial_ou = Get-ADUser -Identity $new_samaccountname | Select-Object -ExpandProperty distinguishedName
$old_ou = Get-ADUser -Identity $samaccount_to_copy -Properties CanonicalName
$new_ou = "OU="+($old_ou.DistinguishedName -split ",OU=",2)[1]
Move-ADObject $initial_ou -TargetPath $new_ou

}

function Show-Menu {
  param (
      [string]$Title = 'Active Directory Accounts')
      ([string]$Choice1 = '1) List locked-out accounts')
      ([string]$Choice2 = '2) Unlock accounts')
      ([string]$Choice3 = '3) Reset account passwords')
      ([string]$Choice4 = '4) List all users')
      ([string]$Choice5 = '5) List other impaired accounts')
      ([string]$Choice6 = '6) Enable user')
      ([string]$Choice7 = '7) Disable user')
      ([string]$Choice8 = '8) Create new user')
      ([string]$Choice9 = '9) Delete user')
      ([string]$Choice10 = '10) Query logged-on computers')
      ([string]$Choice0 = '0) Quit')
      

  Clear-Host
  Write-Host "================ $Title ================="
  Write-Host "$Choice1"
  Write-Host "$Choice2"
  Write-Host "$Choice3"
  Write-Host "$Choice4"
  Write-Host "$Choice5"
  Write-Host "$Choice6"
  Write-Host "$Choice7"
  Write-Host "$Choice8"
  Write-Host "$Choice9"
  Write-Host "$Choice10"
  Write-Host "$Choice0"
}

do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
      SearchLocked
    } '2' {
      UnlockAccount
    } '3' {
      ResetPassword
    } '4' {
      ListUsers
    } '5' {
      ListImpaired
    } '6' {
      EnableUser
    } '7' {
      DisableUser
    } '8' {
      CreateUser
    } '9' {
      DeleteUser
    } '10'{
      QueryUsers
    }
    }
    pause
 }

#  ([string]$Choice1 = '1) List locked-out accounts')
#       ([string]$Choice2 = '2) Unlock accounts')
#       ([string]$Choice3 = '3) Reset account passwords')
#       ([string]$Choice4 = '4) List all users')
#       ([string]$Choice5 = '5) List other impaired accounts')
#       ([string]$Choice6 = '6) Enable user')
#       ([string]$Choice7 = '7) Disable user')
#       ([string]$Choice8 = '8) Create new user')
#       ([string]$Choice9 = '9) Delete user')
#       ([string]$Choice10 = '10) Query logged-on computers')
#       ([string]$Choice0 = '0) Quit')

 until ($selection -eq '0')

 "Goodbye."

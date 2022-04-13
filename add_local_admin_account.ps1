<# 
.SYNOPSIS 
 Create and update Local admin account.    
.DESCRIPTION 
 Create and update Local admin account.
.PARAMETER Company
 Name of Company script is used for. Used for logging folders
#> 

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False)] $LocalAdmin = "jmagee"
    # [Parameter(Mandatory=$False)] [SecureString] $Adminpassword = "19C0ViNgT0N90"
)

$scriptName = "Change_Local_Admin_Account"
if (-not (Test-Path "C:\scripts\$scriptName"))
{
    Mkdir "C:\scripts\$scriptName"
}

# Start logging
Start-Transcript "C:\scripts\$scriptName\$scriptName.log"

$ExpectedLocalUser = $LocalAdmin
$Password = ConvertTo-SecureString "19C0ViNgT0N90" -AsPlainText -Force

Function Create_LocalAdmin
{
    New-LocalUser $ExpectedLocalUser -Password $Password -FullName $ExpectedLocalUser -Description "Local Administrator account."
    Add-LocalGroupMember -Group "Administrators" -Member $ExpectedLocalUser
    Set-LocalUser -Name $ExpectedLocalUser -PasswordNeverExpires:$true
}

Try
{
    ## Catch if not found
    Get-LocalUser -Name $ExpectedLocalUser -ErrorAction Stop 

    ## If an account is found update the password
    Set-LocalUser -Name $ExpectedLocalUser -Password $Password -PasswordNeverExpires:$true
    Write-Host "Account $ExpectedLocalUser already exists, updating password."
}
Catch
{
    Create_LocalAdmin
    Write-Host "Account $ExpectedLocalUser created."
}
Stop-Transcript
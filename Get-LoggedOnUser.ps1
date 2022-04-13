# function Get-LoggedOnUser
# {
# 	<#
# 	.SYNOPSIS
# 		This function queries CIM on the local or a remote computer and returns the user (local or Active Directory) that is currently
# 		logged on.
	
# 	.EXAMPLE
# 		PS> Get-LoggedOnUser
	
# 		This would query the local computer and return the user logged on.
		
# 	.EXAMPLE
# 		PS> Get-LoggedOnUser -ComputerName CLIENT
	
# 		This would query the remote computer CLIENT and return the user logged on.
	
# 	.PARAMETER ComputerName
# 		The name of the computer you'd like to run this function against.
	
# 	#>
# 	[OutputType([pscustomobject])]
# 	[CmdletBinding()]
# 	param
# 	(
# 		[Parameter()]
# 		[ValidateNotNullOrEmpty()]
# 		[string[]]$ComputerName = $env:COMPUTERNAME
# 	)
# 	begin
# 	{
# 		$ErrorActionPreference = 'Stop'
# 	}
# 	process
# 	{
# 		try
# 		{
# 			foreach ($comp in $ComputerName)
# 			{
# 				$output = @{ 
# 					ComputerName = $comp 
# 					UserName = 'Unknown'
# 					ComputerStatus = 'Offline'
# 				}
# 				if (Test-Connection -ComputerName $comp -Count 1 -Quiet) {
# 					$output.UserName = (Get-CimInstance -Class win32_computersystem -ComputerName $comp).UserName
# 					$output.ComputerStatus = 'Online'
# 				}
# 				[pscustomobject]$output
# 			}
# 		}
# 		catch
# 		{
# 			$PSCmdlet.ThrowTerminatingError($_)
# 		}
# 	}
# }

# Get-LoggedOnUser -ComputerName OPS202


Import-Module ActiveDirectory
 
Get-RDUserSession -ConnectionBroker connection-broker-name
{
$dcs = Get-ADDomainController -Filter {Name -like "*"}
$users = Get-ADUser -LDAPFilter "(&(objectCategory=person)(objectClass=user))"
$time = 0
$exportFilePath = "c:\scripts\lastLogon.csv"
$columns = "name,username,datetime"
Out-File -filepath $exportFilePath -force -InputObject $columns
foreach($user in $users)
{
foreach($dc in $dcs)
{ 
$hostname = $csb.local
$currentUser = Get-ADUser $user.SamAccountName | Get-ADObject -Server $hostname -Properties lastLogon
if($currentUser.LastLogon -gt $time) 
{
$time = $currentUser.LastLogon
}
}
if($time -eq 0){
$row = $user.Name+","+$user.SamAccountName+",Never"
}
else {
$dt = [DateTime]::FromFileTime($time)
$row = $user.Name+","+$user.SamAccountName+","+$dt
}
Out-File -filepath $exportFilePath -append -noclobber -InputObject $row
$time = 0
}
}


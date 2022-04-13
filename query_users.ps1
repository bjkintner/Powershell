# query user /server:ops201
$computers = Get-Content "C:\scripts\powershell\pc_list.txt"

function SearchSullivan {
  foreach ($computer in $computers) {
    if ($computer -like "bog1*" -or $computer -eq "br01-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
         Write-Host "$computer       NULL"
         }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}
function SearchFranklinton {
  foreach ($computer in $computers) {
    if ($computer -like "fra*" -or $computer -eq "br02-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
          Write-Host "$computer       NULL"
        }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}
function SearchCumberland {
  foreach ($computer in $computers) {
    if ($computer -like "bog2*" -or $computer -eq "br04-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
          Write-Host "$computer       NULL"
        }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}
function SearchAngie {
  foreach ($computer in $computers) {
    if ($computer -like "ang*" -or $computer -eq "br06-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
          Write-Host "$computer       NULL"
        }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}
function SearchCovington {
  foreach ($computer in $computers) {
    if ($computer -like "cov*" -or $computer -eq "br07-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
          Write-Host "$computer       NULL"
        }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}
function SearchOperations {
  foreach ($computer in $computers) {
    if ($computer -like "ops*" -or $computer -eq "ops-capture") {
      if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1 -ea silentlycontinue)) 
      {
      Write-Warning "$computer is offline"; continue 
      } 
      $stringOutput = quser /server:$computer 2>$null
         If (!$stringOutput)
         {
          Write-Host "$computer       NULL"
        }
         ForEach ($line in $stringOutput){
            If ($line -match "logon time") 
            {Continue}
   
            [PSCustomObject]@{
             ComputerName    = $computer
             Username        = $line.SubString(1, 20).Trim()
             SessionName     = $line.SubString(23, 17).Trim()
             ID             = $line.SubString(42, 2).Trim()
             State           = $line.SubString(46, 6).Trim()
             #Idle           = $line.SubString(54, 9).Trim().Replace('+', '.')
             #LogonTime      = [datetime]$line.SubString(65)
            }
        }
    }
  }
}

function SearchAll {
  "Querying Sullivan PCs"  
  SearchSullivan
  "Querying Ops Center PCs"  
  SearchOperations
  "Querying Franklinton PCs"  
  SearchFranklinton
  "Querying Cumberland PCs"  
  SearchCumberland
  "Querying Angie PCs"  
  SearchAngie
  "Querying Covington PCs"  
  SearchCovington
}

function Show-Menu {
    param (
        [string]$Title = 'Query logged-in users')
        ([string]$Choice1 = '1) Branch 1 - Sullivan')
        ([string]$Choice2 = '2) Branch 2 - Franklinton')
        ([string]$Choice3 = '4) Branch 4 - Cumberland')
        ([string]$Choice4 = '6) Branch 6 - Angie')
        ([string]$Choice5 = '7) Branch 7 - Covington')
        ([string]$Choice6 = '9) Operations Center')
        ([string]$Choice7 = '411) All Branches')
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
    Write-Host "$Choice0"
  }

  do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    { '1' {
      SearchSullivan  | Select-Object Computername,Username | Format-Table
    } '2' {
      SearchFranklinton  | Select-Object Computername,Username | Format-Table
    } '4' {
      SearchCumberland  | Select-Object Computername,Username | Format-Table
    } '6' {
      SearchAngie  | Select-Object Computername,Username | Format-Table
    } '7' {
      SearchCovington  | Select-Object Computername,Username | Format-Table
    } '9' {
      SearchOperations  | Select-Object Computername,Username | Format-Table
    } '411' {
      SearchAll  | Select-Object Computername,Username | Format-Table
    }
    }
    pause
 }
 until ($selection -eq '0')

 "Goodbye."

$compName = Read-Host -prompt "What is the computer name?"

Copy-Item "S:\Computer Setup\scripts\startup_join_domain.bat" `
-Destination "\\$compName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

Copy-Item "S:\Computer Setup\scripts\Join Domain.ps1" `
-Destination "\\$compName\C$"

Start-Sleep -s 10

Remove-Computer -ComputerName $compName -UnjoinDomaincredential csb.local\jlmagee -PassThru -Verbose -Restart

Restart-Computer -ComputerName $compName 

Start-Sleep -s 120

ping $compName -t


$computers = Get-Content "C:\scripts\powershell\PC_list_XE_add.txt"
$icon = "C:\temp\HfsResN.dll"

foreach ($computer in $computers) {
    $Session = New-PSSession -ComputerName "$computer"
    Copy-Item "$icon" -Destination "\\$computer\C:\Temp\" -ToSession $Session
}
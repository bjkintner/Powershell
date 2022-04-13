# Redirect all output to log file
# try {
#     & '.\powershell\device agent shortcut.ps1' 1> Device_agent_shortcut.log
# } catch {
#     "Writing output to log file."
# }
# List of computers you want to copy files/folders to
$computers = Get-Content "C:\scripts\powershell\PC_list_XE_add.txt"

# Audit file 
# $auditFile = "C:\Horizon XE\TEST_LIST.txt"

# File/folder(s) you want to copy to the computers in the $computer variable
#$sourceFolder = "C:\Horizon XE\"
$XE_old_link = "C:\Horizon XE\Horizon-XE-core.lnk"
$XE_script = "C:\Horizon XE\Horizon.bat"
$existingScript = "C$\Users\Public\Desktop\Horizon-XE.lnk"
$FIS_location = "C:\ProgramData\FIS\"

# The destination location you want the file/folder(s) to be copied to
$tempDir = "c$\"
$tempDestination = "c$\Horizon XE"
# $desktopDestination = "C$\Users\Public\Desktop"
# $desktopDestinationFile = "C$\Users\Public\Desktop\Horizon.bat"

# Delete existing shortcut if exists
foreach ($computer in $computers) {
    if (Test-Path "\\$computer\C$\Users\Public\Desktop\Horizon-XE.lnk") {
        Remove-Item "\\$computer\$existingScript"
        if (Test-Path "\\$computer\C$\Users\Public\Desktop\Horizon-XE.lnk") {
            "$computer failed to remove shortcut."
        } else {
            "$computer successfully removed shortcut."
    }
} else {
    "$computer could not find shortcut."
}

}

# Create destination directory if it does not already exist
foreach ($computer in $computers) {
    if (!(Test-Path -Path \\$computer\$tempDestination)) {
        Copy-Item -Path '.\c$\Horizon XE' -Destination "\\$computer\$tempDir" -Force
        # "$computer successfully created new directory."
    }
}

# Copy Horizon XE shortcut to temp folder
foreach ($computer in $computers) {
    Copy-Item -Path $XE_old_link -Destination "\\$computer\$tempDestination" -Force
#    Out-File -FilePath $auditFile -Append
    # if (Test-Path -Path \\$computer\$sourceXE) {
    #     "$computer : OLD XE link copied successfully."
    # } else {
    #     "$computer : OLD XE link copy failed."
    # }
} 

# Copy script to temp folder
foreach ($computer in $computers) {
    Copy-Item -Path $XE_script -Destination "\\$computer\$tempDestination" -Force
#    Out-File -FilePath $auditFile -Append
    # if (Test-Path -Path \\$computer\$sourceXEnew) {
    #     "$computer : NEW XE link copied successfully."
    # } else {
    #     "$computer : NEW XE link copy failed."
    # }
} 

# Create script shortcut to Public Users Desktop
foreach ($computer in $computers) {
    $shell = New-Object -ComObject ("WScript.Shell")
    $shortcut = $Shell.CreateShortcut("\\$computer\C$\Users\Public\Desktop\Horizon-XE.lnk")
    $shortcut.TargetPath="C:\Horizon XE\Horizon.bat"
    $shortcut.WorkingDirectory = "$XE_script"
    $shortcut.IconLocation = "explorer.exe,18"
    $shortcut.Save()
} 

# Copy configuration file
foreach ($computer in $computers) {
    #Copy FIS folder
    if (!(Test-Path -Path \\$computer\$FIS_location)) {
        Copy-Item -Path "C:\ProgramData\FIS" -Destination "\\$computer\C:\ProgramData" -Force
        Copy-Item -Path "$XE_script" -Destination `
        "\\$computer\C:\ProgramData\FIS\XE Device Agent\Settings\DeviceAgent.xml" -Force
    }
}


    # $location = \\$computer\$desktopDestination
    # $shortcut = $shell.CreateShortcut("$Location\Horizon-XE.lnk")
    # $shortcut.TargetPath = "\\$computer\$XE_script"
    # $shortcut.IconLocation = "%windir%\explorer.exe,17"
    # $shortcut.Save()


# Copy new Horizon XE script to Public Users Desktop
#foreach ($computer in $computers) {
#    Copy-Item $sourceScript -Destination $desktopDestination -Verbose
#    Export-Csv -Path "C:\scripts\device_agent_list.csv" -Append
#}

# Audit processes
foreach ($computer in $computers) {
# Check directory
    if (Test-Path -path "\\$computer\C$\Horizon XE") {
    "$computer successfully created temp directory"        
    } else {
        "$computer failed to create temp directory"
    }

# Check actual XE link
    if (Test-Path -path "\\$computer\C$\Horizon XE\Horizon-XE-core.lnk") {
        "$computer successfully created XE link"        
    } else {
        "$computer failed to create XE link"
    }

#Check XE script
    if (Test-Path -path "\\$computer\C$\Horizon XE\Horizon.bat") {
        "$computer successfully created XE script"
    } else {
        "$computer failed to create XE script"
    }

#Check XE script shortcut
    if (Test-Path -path "\\$computer\C$\Users\Public\Desktop\Horizon-XE.lnk") {
        "$computer successfully created script shortcut on desktop"        
    } else {
        "$computer failed to create script shortcut on desktop"
    }
}
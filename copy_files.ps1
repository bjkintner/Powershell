$computers = Get-Content "C:\scripts\powershell\PC_list_test.txt"

# File/folder(s) you want to copy to the computers in the $computer variable
$copyFile = ""   # "C:\source\file.ext"
$copyFolder = "" # "C:\source\*"
$oldFile = ""    # "C:\newDir\oldFile.ext"

# Destination and originating directories
$fromDir = "" # "C:\fromDir\"
$toDir = ""   # "C:\toDir\"

# Delete existing file if exists
foreach ($computer in $computers) {
    if (Test-Path "\\$computer\$toDir\$oldFile") {
        Remove-Item "\\$computer\$toDir\$oldFile"
        if (Test-Path "\\$computer\$toDir\$oldFile") {
            "$computer failed to remove file."
        } else {
            "$computer successfully removed file."
        }
    } else {
    "$computer could not find existing file."
    }
}

# Create destination directory if it does not already exist
foreach ($computer in $computers) {
    if (!(Test-Path -Path "\\$computer\$toDir")) {
        Copy-Item -Path '$fromDir' -Destination "\\$computer\$toDir" -Force
        # "$computer successfully created new directory."
        if (Test-Path -Path "\\$computer\$toDir\$oldFile") {
            "$computer successfully created new directory."
        } else {
            "$computer could not create new directory."
        }

    }
}

# Copy file
foreach ($computer in $computers) {
    Copy-Item -Path "$fromDir" -Destination "\\$computer\$tempDestination" -Force
} 

# Copy folder
foreach ($computer in $computers) {
    Copy-Item -Path "$fromDir" -Destination "\\$computer\$tempDestination" -Force
} 


# Audit processes
foreach ($computer in $computers) {
# Check directory
    if (Test-Path -path "\\$computer\$toDir\$copyFile") {
    "$computer successfully created directory"        
    } else {
        "$computer failed to create directory"
    }
}
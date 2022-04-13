# $computers = Get-Content "C:\scripts\powershell\PC_list_test.txt"

# File/folder(s) you want to copy to the computers in the $computer variable
$horizonFile = "\\BR01PF\Shares\Scripting\Misc\Horizon.bat"
$classicFile = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Horizon Classic.lnk"

# Destination and originating directories
$fromDir = "\\BR01PF\Shares\Scripting\Start menu shortcuts\*" # "C:\fromDir\" or "C:\fromDir\*" for contents
$toDir = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"   # "C:\toDir"
$horizonDest = "C:\Horizon XE\"
$classicDest = "C:\Users\Public\Desktop"

# Copy Programs
Copy-Item -Path $fromDir -Destination $toDir -Force

# Copy Horizon batch script
Copy-Item -Path $horizonFile -Destination $horizonDest -Force

# Copy Horizon Classic shortcut
Copy-Item -Path $classicFile -Destination $classicDest -Force


# # Audit processes
# foreach ($computer in $computers) {
# # Check directory
#     if (Test-Path -path "\\$computer\$toDir\$copyFile") {
#     "$computer successfully created directory"        
#     } else {
#         "$computer failed to create directory"
#     }
# }

# Delete existing file if exists
# foreach ($computer in $computers) {
#     if (Test-Path "\\$computer\$toDir\$oldFile") {
#         Remove-Item "\\$computer\$toDir\$oldFile"
#         if (Test-Path "\\$computer\$toDir\$oldFile") {
#             "$computer failed to remove file."
#         } else {
#             "$computer successfully removed file."
#         }
#     } else {
#     "$computer could not find existing file."
#     }
# }

# # Create destination directory if it does not already exist
# foreach ($computer in $computers) {
#     if (!(Test-Path -Path "\\$computer\$toDir")) {
#         Copy-Item -Path '$fromDir' -Destination "\\$computer\$toDir" -Force
#         # "$computer successfully created new directory."
#         if (Test-Path -Path "\\$computer\$toDir\$oldFile") {
#             "$computer successfully created new directory."
#         } else {
#             "$computer could not create new directory."
#         }

#     }
# }
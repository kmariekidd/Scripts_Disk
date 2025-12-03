# Script to find specific folders on the C:\ drive

# List of folders to search for
$foldersToFind = @(
    "C:\Windows.old",
    "C:\$Windows.~BT",
    "C:\Windows10Upgrade",
    "C:\HP",
    "C:\Dell",
    "C:\Drivers"
)

# Additional search for leftover game/installer folders directly under C:\
$additionalSearchPattern = "C:\*"

# Check for specific folders
Write-Host "Searching for specific folders..."
foreach ($folder in $foldersToFind) {
    if (Test-Path -Path $folder) {
        Write-Host "Found: $folder"
    } else {
        Write-Host "Not found: $folder"
    }
}

# Check for leftover game/installer folders directly under C:\
Write-Host "`nSearching for leftover game/installer folders..."
Get-ChildItem -Path $additionalSearchPattern -Directory | ForEach-Object {
    $folderName = $_.Name
    if ($folderName -match "game|install|setup") {
        Write-Host "Potential leftover folder found: $($_.FullName)"
    }
}
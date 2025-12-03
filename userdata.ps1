# Define the base path
$basePath = "C:\Users\kaymk"

# Function to get folder size
function Get-FolderSize {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        (Get-ChildItem -Path $Path -Recurse -Force | Measure-Object -Property Length -Sum).Sum / 1MB
    } else {
        return "Folder does not exist"
    }
}

# Calculate sizes
$results = @()
$results += [PSCustomObject]@{ Folder = "Whole Folder"; SizeMB = Get-FolderSize -Path $basePath }
$results += [PSCustomObject]@{ Folder = "Desktop"; SizeMB = Get-FolderSize -Path "$basePath\Desktop" }
$results += [PSCustomObject]@{ Folder = "Documents"; SizeMB = Get-FolderSize -Path "$basePath\Documents" }
$results += [PSCustomObject]@{ Folder = "Downloads"; SizeMB = Get-FolderSize -Path "$basePath\Downloads" }
$results += [PSCustomObject]@{ Folder = "Pictures"; SizeMB = Get-FolderSize -Path "$basePath\Pictures" }
$results += [PSCustomObject]@{ Folder = "Videos"; SizeMB = Get-FolderSize -Path "$basePath\Videos" }
$results += [PSCustomObject]@{ Folder = "Music"; SizeMB = Get-FolderSize -Path "$basePath\Music" }
$results += [PSCustomObject]@{ Folder = "AppData\Local"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Local" }
$results += [PSCustomObject]@{ Folder = "AppData\Roaming"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Roaming" }
$results += [PSCustomObject]@{ Folder = "AppData\Local\Temp"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Local\Temp" }

# Output results
$results | Format-Table -AutoSize
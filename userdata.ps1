# Define the base path
$basePath = "C:\Users\kaymk"

# Function to get folder size efficiently
# Performance: SilentlyContinue prevents error messages from cluttering output
function Get-FolderSize {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        $sum = (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | 
                Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        if ($null -eq $sum) { return 0 }
        return $sum / 1MB
    } else {
        return "Folder does not exist"
    }
}

# Calculate sizes - Use efficient ArrayList instead of array concatenation
$results = [System.Collections.ArrayList]::new()
[void]$results.Add([PSCustomObject]@{ Folder = "Whole Folder"; SizeMB = Get-FolderSize -Path $basePath })
[void]$results.Add([PSCustomObject]@{ Folder = "Desktop"; SizeMB = Get-FolderSize -Path "$basePath\Desktop" })
[void]$results.Add([PSCustomObject]@{ Folder = "Documents"; SizeMB = Get-FolderSize -Path "$basePath\Documents" })
[void]$results.Add([PSCustomObject]@{ Folder = "Downloads"; SizeMB = Get-FolderSize -Path "$basePath\Downloads" })
[void]$results.Add([PSCustomObject]@{ Folder = "Pictures"; SizeMB = Get-FolderSize -Path "$basePath\Pictures" })
[void]$results.Add([PSCustomObject]@{ Folder = "Videos"; SizeMB = Get-FolderSize -Path "$basePath\Videos" })
[void]$results.Add([PSCustomObject]@{ Folder = "Music"; SizeMB = Get-FolderSize -Path "$basePath\Music" })
[void]$results.Add([PSCustomObject]@{ Folder = "AppData\Local"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Local" })
[void]$results.Add([PSCustomObject]@{ Folder = "AppData\Roaming"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Roaming" })
[void]$results.Add([PSCustomObject]@{ Folder = "AppData\Local\Temp"; SizeMB = Get-FolderSize -Path "$basePath\AppData\Local\Temp" })

# Output results
$results | Format-Table -AutoSize
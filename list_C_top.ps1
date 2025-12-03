<<<<<<< SEARCH
Get-ChildItem -Path C:\ -Force | ForEach-Object {
    $size = if ($_.PSIsContainer) {
        # Calculate folder size
        (Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    } else {
        # File size
        $_.Length
    }
    [PSCustomObject]@{
        Name = $_.Name
        Path = $_.FullName
        Size = $size
        Type = if ($_.PSIsContainer) { "Folder" } else { "File" }
    }

# Output the results to a text file in the same folder as this script
} | Sort-Object -Property Size -Descending | Out-File -FilePath (Join-Path -Path $PSScriptRoot -ChildPath "top_level_files_and_folders.txt")
# Display live scanning output
Write-Host "Scanning completed. Total items processed: $((Get-ChildItem -Path C:\ -Force).Count)"
=======
# Warn about scan time
Write-Host "Scanning C:\. This may take a long time, especially for large folders..."

Get-ChildItem -Path C:\ -Force | ForEach-Object {
    $size = 0
    if ($_.PSIsContainer) {
        try {
            # Calculate folder size
            $size = (Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction Stop | Measure-Object -Property Length -Sum).Sum
        } catch {
            Write-Warning "Could not access folder: $($_.FullName). Error: $($_.Exception.Message)"
            $size = 0
        }
    } else {
        # File size
        $size = $_.Length
    }
    [PSCustomObject]@{
        Name = $_.Name
        Path = $_.FullName
        Size = $size
        Type = if ($_.PSIsContainer) { "Folder" } else { "File" }
    }
} | Sort-Object -Property Size -Descending | Out-File -FilePath (
    if ($PSScriptRoot) {
        Join-Path -Path $PSScriptRoot -ChildPath "top_level_files_and_folders.txt"
    } else {
        "C:\top_level_files_and_folders.txt"
    }
)
Write-Host "Scanning completed. Total items processed: $((Get-ChildItem -Path C:\ -Force).Count)"
>>>>>>> REPLACE

# List all top-level contents on C:\ and their sizes in descending order
# Performance: Uses streaming pipeline to avoid memory issues with large folders

Write-Host "Scanning C:\. This may take a long time, especially for large folders..."

Get-ChildItem -Path C:\ -Force | ForEach-Object {
    $size = 0
    if ($_.PSIsContainer) {
        try {
            # Calculate folder size using streaming pipeline
            $size = (Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | 
                     Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
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
Write-Host "Scanning completed."

# List all top-level files and folders in the C:\ drive, including hidden, read-only, etc., and display their size.

Get-ChildItem -Path C:\ -Force -File -Directory | ForEach-Object {
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
} | Format-Table -AutoSize
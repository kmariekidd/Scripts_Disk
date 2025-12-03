# Script to find single giant files on C: drive
# Categories: Game installers, ISO images, Old backups, Dump files, VMs/VHDXs
# Performance: Uses ArrayList for efficient collection and pipeline filtering

# Define the minimum file size (configurable)
$minSize = 1GB
$minSizeDisplay = "1GB"

# Define file extensions for the categories
$fileExtensions = @(
    ".exe",  # Game installers
    ".iso",  # ISO images
    ".bak",  # Old backups
    ".dmp",  # Dump files
    ".vhd", ".vhdx"  # VMs/VHDXs
)

Write-Host "Starting scan of C:\ drive..." -ForegroundColor Cyan
Write-Host "Looking for files over $minSizeDisplay with extensions: $($fileExtensions -join ', ')" -ForegroundColor Yellow
Write-Host ""

# Use ArrayList for efficient appending (O(1) instead of O(n) for each append)
$foundFiles = [System.Collections.ArrayList]::new()
$foldersScanned = 0

# Search for files on C: drive, including hidden and system files
Get-ChildItem -Path C:\ -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
    # Show progress every 1000 files
    if ($foldersScanned % 1000 -eq 0) {
        Write-Host "Scanning: $($_.DirectoryName)" -ForegroundColor Gray
    }
    $foldersScanned++
    
    # Check if file matches criteria
    if ($_.Length -ge $minSize -and $fileExtensions -contains $_.Extension) {
        $sizeGB = [math]::Round($_.Length / 1GB, 2)
        Write-Host "FOUND: $($_.FullName) - $sizeGB GB" -ForegroundColor Green
        [void]$foundFiles.Add($_)
    }
}

Write-Host "`n=== Scan Complete ===" -ForegroundColor Cyan
Write-Host "Files scanned: $foldersScanned" -ForegroundColor Yellow
Write-Host "Large files found: $($foundFiles.Count)" -ForegroundColor Green

if ($foundFiles.Count -gt 0) {
    Write-Host "`n=== Results ===" -ForegroundColor Cyan
    $foundFiles | Select-Object @{Name = 'Path'; Expression = { $_.FullName } },
    @{Name = 'File Name'; Expression = { $_.Name } },
    @{Name = 'Approx Size (GB)'; Expression = { [math]::Round($_.Length / 1GB, 2) } } |
    Format-Table -AutoSize
}
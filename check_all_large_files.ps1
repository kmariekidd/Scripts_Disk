# Quick check: Find ALL files over 2GB regardless of extension
Write-Host "Finding all files over 2GB on C:\ ..." -ForegroundColor Cyan
Write-Host ""

$foundFiles = @()
$foldersScanned = 0

Get-ChildItem -Path C:\ -Recurse -File -Force -ErrorAction Stop |
Where-Object { $_.Length -ge 2GB } |
Select-Object @{Name = 'Path'; Expression = { $_.FullName } },
@{Name = 'File Name'; Expression = { $_.Name } },
Extension,
@{Name = 'Size (GB)'; Expression = { [math]::Round($_.Length / 1GB, 2) } } |
Sort-Object 'Size (GB)' -Descending |
Format-Table -AutoSize

Write-Host "`nIf nothing appears above, you have no files over 2GB on C:\" -ForegroundColor Yellow

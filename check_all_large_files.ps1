# Quick check: Find ALL files over 2GB regardless of extension
# Performance: Uses efficient pipeline streaming without intermediate storage

Write-Host "Finding all files over 2GB on C:\ ..." -ForegroundColor Cyan
Write-Host ""

Get-ChildItem -Path C:\ -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -ge 2GB } |
    Select-Object @{Name = 'Path'; Expression = { $_.FullName } },
        @{Name = 'File Name'; Expression = { $_.Name } },
        Extension,
        @{Name = 'Size (GB)'; Expression = { [math]::Round($_.Length / 1GB, 2) } } |
    Sort-Object 'Size (GB)' -Descending |
    Format-Table -AutoSize

Write-Host "`nIf nothing appears above, you have no files over 2GB on C:\" -ForegroundColor Yellow

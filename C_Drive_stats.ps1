# Get drive information for C:
$drive = Get-PSDrive -Name C

# Calculate used space
$usedSpace = $drive.Used

# Output the results
[PSCustomObject]@{
    Drive      = $drive.Name
    TotalSize  = [math]::Round($drive.Used + $drive.Free / 1GB, 2)
    FreeSpace  = [math]::Round($drive.Free / 1GB, 2)
    UsedSpace  = [math]::Round($usedSpace / 1GB, 2)
}
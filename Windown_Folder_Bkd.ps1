# List all top-level contents under C:\Windows (including hidden, read-only, system files and folders) and their sizes in descending order
# Performance: Uses streaming pipeline with SilentlyContinue for better error handling

Get-ChildItem -Path C:\Windows -Force | 
    Select-Object FullName, 
        @{Name="SizeMB";Expression={
            if ($_.PSIsContainer) { 
                $sum = (Get-ChildItem $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | 
                        Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                if ($null -eq $sum) { 0 } else { $sum / 1MB }
            } else { 
                $_.Length / 1MB 
            }
        }}, 
        @{Name="Type";Expression={if ($_.PSIsContainer) {"Folder"} else {"File"}}}, 
        Attributes | 
    Sort-Object SizeMB -Descending
function codegrep {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Pattern,

        [Parameter(Mandatory = $false)]
        [string]$Directory = ".",

        [Parameter(Mandatory = $false)]
        [string]$Extension,

        [switch]$Code
    )

    if (-not $Pattern) {
        Write-Host "Usage: codegrep -Pattern <text> [-Directory <path>] [-Extension <.ext>] [-Code]" -ForegroundColor Yellow
        Write-Host "Search for a string in files within a directory." -ForegroundColor Green
        Write-Host "Example: codegrep -Pattern 'TODO' -Directory 'C:\Projects' -Extension '.txt' -Code" -ForegroundColor DarkGray
        return
    }

    try {
        # Get files recursively
        $files = if ($Extension) {
            $Extension = $Extension.TrimStart(".")
            Get-ChildItem -Path $Directory -Recurse -File -Include "*.$Extension" -ErrorAction SilentlyContinue
        } else {
            Get-ChildItem -Path $Directory -Recurse -File -ErrorAction SilentlyContinue
        }

        if (-not $files) {
            Write-Host "No files found in directory '$Directory'" -ForegroundColor DarkGray
            return
        }

        # Search for pattern
        $matches = $files | Select-String -Pattern $Pattern -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty Path -Unique

        if (-not $matches) {
            Write-Host "No matches found for '$Pattern'" -ForegroundColor DarkGray
            return
        }

        foreach ($file in $matches) {
            Write-Host $file -ForegroundColor Cyan
        }

        if ($Code) {
            $matches | ForEach-Object { code $_ }
        }

    } catch {
        Write-Error "Error: $_"
    }
}

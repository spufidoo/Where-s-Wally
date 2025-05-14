function codefind {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Pattern,

        [Parameter(Mandatory = $false)]
        [string]$Directory = ".",

        [switch]$Regex,  # Enable regex search

        [switch]$Code
    )

    if (-not $Pattern) {
        Write-Host "Usage: codefind -Pattern <filename or regex> [-Directory <path>] [-Regex] [-Code]" -ForegroundColor Yellow
        Write-Host "Search for file names matching a pattern in a directory." -ForegroundColor Green
        Write-Host "Example: codefind -Pattern 'TODO' -Directory 'C:\Projects' -Regex -Code" -ForegroundColor DarkGray
        return
    }

    $matches = if ($Regex) {
        Get-ChildItem -Path $Directory -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match $Pattern } |
            Select-Object -ExpandProperty FullName
    }
    else {
        Get-ChildItem -Path $Directory -Recurse -File -Filter $Pattern -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty FullName
    }

    if (-not $matches) {
        Write-Host "No files found matching '$Pattern'" -ForegroundColor DarkGray
        return
    }

    foreach ($file in $matches) {
        Write-Host $file -ForegroundColor Green
    }

    if ($Code) {
        $matches | ForEach-Object { code $_ }
    }
}

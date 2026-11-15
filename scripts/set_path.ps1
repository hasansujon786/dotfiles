<#
.SYNOPSIS
    Safely adds or removes a directory from the Windows User PATH environment variable.

.DESCRIPTION
    Updates the persistent User-level PATH in the Windows Registry using .NET's
    [Environment] class (avoiding setx's 1,024-character truncation limit and
    preventing System PATH duplication). Also updates the active terminal session's
    $env:Path immediately so changes take effect without restarting PowerShell.

.PARAMETER Path
    The directory path to add to or remove from the User PATH.
    Trailing backslashes and case differences are normalized automatically.

.PARAMETER Remove
    Removes the specified directory from the User PATH instead of adding it.

.EXAMPLE
    .\update-path.ps1 "C:\tools\bin"
    Appends C:\tools\bin to the User PATH and the current terminal session.

.EXAMPLE
    .\update-path.ps1 -Path "C:\flutter\bin"
    Appends C:\flutter\bin using the named -Path parameter.

.EXAMPLE
    .\update-path.ps1 "C:\tools\bin" -Remove
    Removes C:\tools\bin from both the User PATH and the current terminal session.

.NOTES
    Run `Get-Help .\update-path.ps1 -Examples` in PowerShell to view usage examples.
#>

param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias("newPath")]
    [string]$Path,

    [switch]$Remove
)

# Normalize input: trim whitespace and trailing backslashes (except root drives like C:\)
$normalizedTarget = $Path.Trim().TrimEnd('\')
if ($normalizedTarget -match '^[a-zA-Z]:$') { $normalizedTarget += '\' }

# Retrieve current User-level Path entries as a clean, non-empty array
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
$pathEntries = @()
if (-not [string]::IsNullOrWhiteSpace($currentPath)) {
    $pathEntries = $currentPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
}

# Check for an exact case-insensitive match (ignoring trailing slashes)
$exists = $pathEntries | Where-Object { $_.TrimEnd('\') -ieq $normalizedTarget.TrimEnd('\') }

if ($Remove) {
    if ($exists) {
        # Filter out matching directory and update Registry
        $filteredEntries = $pathEntries | Where-Object { $_.TrimEnd('\') -ine $normalizedTarget.TrimEnd('\') }
        $updatedPath = $filteredEntries -join ';'
        [Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::User)

        # Update active PowerShell session immediately
        $sessionEntries = ($env:Path -split ';') | Where-Object {
            -not [string]::IsNullOrWhiteSpace($_) -and ($_.TrimEnd('\') -ine $normalizedTarget.TrimEnd('\'))
        }
        $env:Path = $sessionEntries -join ';'

        Write-Host "Path removed successfully: $normalizedTarget" -ForegroundColor Green
    } else {
        Write-Host "Path not found in User Path: $normalizedTarget" -ForegroundColor Yellow
    }
} else {
    if (-not $exists) {
        # Append directory and update Registry
        $updatedPath = ($pathEntries + $normalizedTarget) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::User)

        # Update active PowerShell session immediately
        $env:Path = ($env:Path.TrimEnd(';') + ";" + $normalizedTarget).TrimStart(';')
        Write-Host "Path updated successfully: $normalizedTarget" -ForegroundColor Green
    } else {
        Write-Host "Path already exists: $normalizedTarget" -ForegroundColor Yellow
    }
}

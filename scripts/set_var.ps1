<#
.SYNOPSIS
    Sets or updates a persistent Windows User environment variable.

.DESCRIPTION
    Writes a User-level environment variable to the Windows Registry using .NET's
    [Environment] class and immediately exposes it in the active PowerShell session.

.PARAMETER varName
    The name of the environment variable to set.

.PARAMETER varValue
    The value to assign to the environment variable.

.EXAMPLE
    .\set_var.ps1 ANDROID_HOME "$env:LOCALAPPDATA\Android\Sdk"
#>

param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$varName,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$varValue
)

# Guard against unexpanded shell variables (e.g. "$LOCALAPPDATA\..." evaluating to "\...")
if ($varValue.StartsWith('\') -and -not $varValue.StartsWith('\\')) {
    Write-Warning "Value '$varValue' starts with a single backslash - did you use `$LOCALAPPDATA instead of `$env:LOCALAPPDATA?"
}

# Set the persistent User environment variable in the Registry
[Environment]::SetEnvironmentVariable($varName, $varValue, [EnvironmentVariableTarget]::User)

# Apply immediately to the current PowerShell session
[Environment]::SetEnvironmentVariable($varName, $varValue, [EnvironmentVariableTarget]::Process)

# Confirm the change
$updatedValue = [Environment]::GetEnvironmentVariable($varName, [EnvironmentVariableTarget]::User)
Write-Host "`$env:${varName} updated to: ${updatedValue}" -ForegroundColor Green

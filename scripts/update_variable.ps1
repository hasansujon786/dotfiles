param (
    [string]$varName,
    [string]$varValue
)

# Set the user environment variable
[Environment]::SetEnvironmentVariable($varName, $varValue, [EnvironmentVariableTarget]::User)

# Confirm the change
$updatedValue = [Environment]::GetEnvironmentVariable($varName, [EnvironmentVariableTarget]::User)
Write-Host "`$$varName updated to: $updatedValue"

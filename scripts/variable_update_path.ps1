param (
    [string]$newPath
)

# Get the current user-level Path
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

# Check if the new path already exists
if ($currentPath -notlike "*$newPath*") {
    $updatedPath = $currentPath + ";" + $newPath
    [Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::User)
    Write-Host "Path updated successfully: $newPath"
} else {
    Write-Host "Path already exists: $newPath"
}

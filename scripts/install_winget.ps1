# get latest download url
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"
# download
Invoke-WebRequest -Uri $URL -OutFile "Winget.msix" -UseBasicParsing
# install
Add-AppxPackage -Path "Winget.msix"
# delete file
Remove-Item "Winget.msix"

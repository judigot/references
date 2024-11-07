if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$portableFolderName = "apportable"
$rootDir = "C:\$portableFolderName"
$portableGitInstallationDir = "$rootDir\Programming"

# Load PATH from github and use it in powershell session
$paths = ((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/judigot/references/main/PATH").Content)
$pathsWindows = $paths -replace '\n', ';'
$pathsLinux = $paths -replace '\n', ':' -replace '\\', '/' -replace 'C:', '/c'
$env:PATH += ";$pathsWindows"

# Create "Programming" folder if it doesn't exist
if (!(Test-Path -Path "$portableGitInstallationDir")) {
    New-Item -Path "$portableGitInstallationDir" -ItemType Directory
}

#==========SSH AGENT==========#
Set-Service -Name ssh-agent -StartupType Automatic # Enable and start the SSH Agent service on Windows startup.
Start-Service -Name ssh-agent # SSH Agent will be used by Terraform
#==========SSH AGENT==========#

#==========7-ZIP==========#
$downloadURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
$7ZipInstallationDir = "$portableGitInstallationDir\7-Zip"
$installerPath = Join-Path $env:TEMP "7zip-portable.exe"
# Download the 7-Zip portable version
Invoke-WebRequest $downloadURL -OutFile $installerPath
# Extract the installer
Start-Process -FilePath $installerPath -Args "/S /D=$7ZipInstallationDir" -Verb RunAs -Wait
# Cleanup the downloaded installer
Remove-Item $installerPath
#==========7-ZIP==========#

#==========GIT==========#
# API Version
# $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }
# # Extract the latest version tag (e.g., v2.47.0.windows.1)
# $latestVersion = $latestRelease.tag_name
# # Remove the '.windows.*' part to get the core version (e.g., v2.47.0)
# $coreVersion = $latestVersion -replace '\.windows.*', ''
# # Construct the download URL for the latest 64-bit Portable Git based on the version
# $portableGitDownloadLink = "https://github.com/git-for-windows/git/releases/download/$latestVersion/PortableGit-$($coreVersion -replace 'v','')-64-bit.7z.exe"

# HTML Content Extraction Version
$url = "https://git-scm.com/downloads/win"
$htmlContent = Invoke-WebRequest -Uri $url -UseBasicParsing | Select-Object -ExpandProperty Content
$pattern = '<a href="([^"]*PortableGit[^"]*)">64-bit Git for Windows Portable<\/a>'
if (-not ($htmlContent -match $pattern)) {
    Write-Output "Git download link not found."
}
$portableGitDownloadLink = $matches[1]

# Echo the constructed Portable Git download link to ensure it's correct
# Write-Host "Constructed URL for Portable Git: $portableGitDownloadLink"

# Define the portable Git file name
$portableGitFilename = "PortableGit.exe"

# Install PortableGit
curl -O $portableGitInstallationDir\$portableGitFilename $portableGitDownloadLink

# Use 7-Zip to extract the Portable Git installer to the desired directory
& "$7ZipInstallationDir\7z.exe" x "$portableGitInstallationDir\$portableGitFilename" -o"$portableGitInstallationDir\PortableGit" -aoa
#==========GIT==========#

#==========RUN APPORTABLE==========#
curl.exe -L https://raw.githubusercontent.com/judigot/references/main/Apportable.sh | C:/apportable/Programming/PortableGit/bin/bash.exe
#==========RUN APPORTABLE==========#

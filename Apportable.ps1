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

#==========.BASHRC==========#
$bashrc_content = ((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/judigot/references/main/.bashrc").Content)
$filename = ".bashrc"
$file_path = Join-Path $env:USERPROFILE -ChildPath $filename
Set-Content -Path $file_path -Value $bashrc_content
Write-Host "$filename created successfully at: $file_path"
#==========.BASHRC==========#

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
# Fetch the latest Git release using GitHub API
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }

# Extract the latest version tag (e.g., v2.47.0.windows.1)
$latestVersion = $latestRelease.tag_name

# Remove the '.windows.*' part to get the core version (e.g., v2.47.0)
$coreVersion = $latestVersion -replace '\.windows.*', ''

# Construct the download URL for the latest 64-bit Portable Git based on the version
$portableGitDownloadLink = "https://github.com/git-for-windows/git/releases/download/$latestVersion/PortableGit-$($coreVersion -replace 'v','')-64-bit.7z.exe"

# Echo the constructed Portable Git download link to ensure it's correct
Write-Host "Constructed URL for Portable Git: $portableGitDownloadLink"

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

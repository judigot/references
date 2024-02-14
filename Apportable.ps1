$portableFolderName = "apportable"
$rootDir = "C:\$portableFolderName"
$portableGitInstallationDir = "$rootDir\Programming"

# Load PATH from github and use it in powershell session 
$pathsLinuxFormat = ((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/judigot/references/main/PATH").Content -replace '\r?\n', '')
$pathsWindowsFormat = ($pathsLinuxFormat -split ':' | ForEach-Object { $_ -replace '^/c', 'C:' -replace '/', '\' } | Where-Object { $_ -ne '' }) -join ';'
$env:PATH += ";$pathsWindowsFormat"

# Create "Programming" folder if it doesn't exist
if (!(Test-Path -Path "$portableGitInstallationDir")) {
    New-Item -Path "$portableGitInstallationDir" -ItemType Directory
}

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
# Extract href attribute for the latest portable git
$htmlContent = Invoke-WebRequest -Uri "https://git-scm.com/download/win"
# Define the text content you're searching for in a variable
$textContent = '64-bit Git for Windows Portable'
# Use the textContent variable to filter the links and extract the href attribute
$portableGitDownloadLink = ($htmlContent.Links | Where-Object { $_.innerText -eq $textContent }).href
$portableGitFilename = "PortableGit.exe"
# Install PortableGit
curl -O $portableGitInstallationDir\$portableGitFilename $portableGitDownloadLink
& "$7ZipInstallationDir\7z.exe" x "$portableGitInstallationDir\$portableGitFilename" -o"$portableGitInstallationDir\PortableGit" -aoa
#==========GIT==========#

#==========.BASHRC==========#
$filename = ".bashrc"
$file_path = Join-Path $env:USERPROFILE -ChildPath $filename
$file_content = @"
#!/bin/bash
export PATH="`$PATH:$($pathsLinuxFormat)"
"@
Set-Content -Path $file_path -Value $file_content
Write-Host "$filename created successfully at: $file_path"
#==========.BASHRC==========#

#==========RUN APPORTABLE==========#
curl.exe -L https://raw.githubusercontent.com/judigot/references/main/Apportable.sh | C:/apportable/Programming/PortableGit/bin/bash.exe
#==========RUN APPORTABLE==========#
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

#==========POWERSHELL PROFILE==========#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

$profileDir = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell"
if (!(Test-Path -Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory | Out-Null
}

$mainProfilePath = Join-Path $env:USERPROFILE "profile.ps1"
$profileContent = @"
`$paths = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/judigot/references/main/PATH" -UseBasicParsing).Content
`$pathsWindows = (`$paths -split "``n" | Where-Object { `$_.Trim() -ne "" }) -join ";"
`$env:PATH += ";`$pathsWindows"

`$env:NVM_HOME = "C:\apportable\Programming\nvm"
`$env:NVM_SYMLINK = "C:\apportable\Programming\nodejs"
`$env:NVM_DIR = "`$env:USERPROFILE\.nvm"

`$env:SDKMAN_DIR = "C:\apportable\Programming\sdkman"
"@
Set-Content -Path $mainProfilePath -Value $profileContent

$loaderContent = @"
if (Test-Path "`$env:USERPROFILE\profile.ps1") {
    . "`$env:USERPROFILE\profile.ps1"
}
"@

$currentHostProfile = Join-Path $profileDir "Microsoft.PowerShell_profile.ps1"
$allHostsProfile = Join-Path $profileDir "profile.ps1"

Set-Content -Path $currentHostProfile -Value $loaderContent
Set-Content -Path $allHostsProfile -Value $loaderContent
#==========POWERSHELL PROFILE==========#

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
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }
$latestVersion = $latestRelease.tag_name
$coreVersion = $latestVersion -replace '\.windows.*', ''
$portableGitDownloadLink = "https://github.com/git-for-windows/git/releases/download/$latestVersion/PortableGit-$($coreVersion -replace 'v','')-64-bit.7z.exe"

if ([string]::IsNullOrEmpty($portableGitDownloadLink)) {
    Write-Host "Failed to construct Git download link." -ForegroundColor Red
    exit 1
}

$portableGitFilename = "PortableGit.exe"
$portableGitFilePath = Join-Path $portableGitInstallationDir $portableGitFilename

Invoke-WebRequest -Uri $portableGitDownloadLink -OutFile $portableGitFilePath

# Use 7-Zip to extract the Portable Git installer to the desired directory
& "$7ZipInstallationDir\7z.exe" x "$portableGitInstallationDir\$portableGitFilename" -o"$portableGitInstallationDir\PortableGit" -aoa
#==========GIT==========#

#==========RUN APPORTABLE==========#
$bashPath = Join-Path $portableGitInstallationDir "PortableGit\bin\bash.exe"
curl.exe -L https://raw.githubusercontent.com/judigot/references/main/Apportable.sh | & $bashPath
#==========RUN APPORTABLE==========#
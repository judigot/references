# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$portableFolderName = "apportable"
$rootDir = "C:\$portableFolderName"
$portableGitInstallationDir = "$rootDir\Programming"
$sevenZipInstallationDir = "$portableGitInstallationDir\7-Zip"

function main {
    load_path_from_github
    setup_powershell_profile
    create_programming_folder
    setup_ssh_agent
    install_7zip
    install_git
    run_apportable
    # run_apportable -useLocalScript $true
}

function load_path_from_github {
    $PATH_REMOTE_URL = "https://raw.githubusercontent.com/judigot/references/main/PATH"
    $PATH_LOCAL_FILE = "$env:USERPROFILE\PATH"
    
    if (Test-Path -Path $PATH_LOCAL_FILE) {
        $paths = Get-Content -Path $PATH_LOCAL_FILE -Raw
    } else {
        try {
            $paths = (Invoke-WebRequest -Uri $PATH_REMOTE_URL -UseBasicParsing -ErrorAction Stop).Content
        } catch {
            Write-Host "Warning: Could not load PATH from remote or local cache." -ForegroundColor Yellow
            return
        }
    }
    
    $pathsWindows = $paths -replace '\n', ';'
    $pathsLinux = $paths -replace '\n', ':' -replace '\\', '/' -replace 'C:', '/c'
    
    $currentPaths = $env:PATH -split ';' | Where-Object { $_.Trim() -ne '' }
    $newPaths = $pathsWindows -split ';' | Where-Object { $_.Trim() -ne '' }
    
    $pathsToAdd = $newPaths | Where-Object { $currentPaths -notcontains $_ }
    
    if ($pathsToAdd.Count -gt 0) {
        $env:PATH += ';' + ($pathsToAdd -join ';')
    }
    
    Start-Job -ScriptBlock {
        $tmpFile = "$using:PATH_LOCAL_FILE.tmp"
        try {
            $response = Invoke-WebRequest -Uri $using:PATH_REMOTE_URL -UseBasicParsing -ErrorAction Stop
            if ($response.Content.Trim().Length -gt 0) {
                Set-Content -Path $tmpFile -Value $response.Content -NoNewline
                Move-Item -Path $tmpFile -Destination $using:PATH_LOCAL_FILE -Force
            } else {
                Remove-Item -Path $tmpFile -ErrorAction SilentlyContinue
            }
        } catch {
            Remove-Item -Path $tmpFile -ErrorAction SilentlyContinue
        }
    } | Out-Null
}

#==========POWERSHELL PROFILE==========#
function setup_powershell_profile {
    $url = "https://raw.githubusercontent.com/judigot/references/main/profile.ps1"
    $dest = "$env:USERPROFILE\profile.ps1"
    Invoke-WebRequest -Uri $url -OutFile $dest
    Write-Host "Downloaded profile.ps1 to $dest"
}
#==========POWERSHELL PROFILE==========#

function create_programming_folder {
    if (!(Test-Path -Path "$portableGitInstallationDir")) {
        New-Item -Path "$portableGitInstallationDir" -ItemType Directory
    }
}

#==========SSH AGENT==========#
function setup_ssh_agent {
    Set-Service -Name ssh-agent -StartupType Automatic
    Start-Service -Name ssh-agent
}
#==========SSH AGENT==========#

#==========7-ZIP==========#
function install_7zip {
    if (Test-Path -Path "$sevenZipInstallationDir\7z.exe") {
        return
    }
    
    $downloadURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
    $installerPath = Join-Path $env:TEMP "7zip-portable.exe"
    Invoke-WebRequest -Uri $downloadURL -OutFile $installerPath -UseBasicParsing
    Start-Process -FilePath $installerPath -Args "/S /D=$sevenZipInstallationDir" -Verb RunAs -Wait
    Remove-Item $installerPath
}
#==========7-ZIP==========#

#==========GIT==========#
function install_git {
    $portableGitPath = Join-Path $portableGitInstallationDir "PortableGit\bin\git.exe"
    if (Test-Path -Path $portableGitPath) {
        return
    }
    
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
    Invoke-WebRequest -Uri $portableGitDownloadLink -OutFile $portableGitFilePath -UseBasicParsing
    & "$sevenZipInstallationDir\7z.exe" x "$portableGitInstallationDir\$portableGitFilename" -o"$portableGitInstallationDir\PortableGit" -aoa
}
#==========GIT==========#

#==========RUN APPORTABLE==========#
function run_apportable {
    param(
        [bool]$useLocalScript = $true
    )
    
    $bashPath = Join-Path $portableGitInstallationDir "PortableGit\bin\bash.exe"
    
    if ($useLocalScript) {
        $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
        $apportableShPath = Join-Path $scriptDir "Apportable.sh"
        
        if (Test-Path -Path $apportableShPath) {
            & $bashPath $apportableShPath
        } else {
            Write-Host "Apportable.sh not found at: $apportableShPath" -ForegroundColor Red
            Write-Host "Falling back to GitHub version..." -ForegroundColor Yellow
            curl.exe -L "https://raw.githubusercontent.com/judigot/references/main/Apportable.sh" | & $bashPath
        }
    } else {
        curl.exe -L "https://raw.githubusercontent.com/judigot/references/main/Apportable.sh" | & $bashPath
    }
}
#==========RUN APPORTABLE==========#

main

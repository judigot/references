$portableFolderName = "apportable"
$rootDir = "C:\$portableFolderName"

# Get git version; get git lates version
$url = "https://git-scm.com/downloads"
$class = "version"
$element = "span"
$htmlContent = (Invoke-WebRequest -Uri $url).Content -replace '\s', ''

# Use regex to find the content within the specified class, considering potential whitespace
$pattern = "<$element[^>]*class=`"$class`"[^>]*>(.*?)</$element>"
$gitLatestVersion = [regex]::Match($htmlContent, $pattern).Groups[1].Value

# Install PortableGit
$portableGitInstallationDir = "$rootDir\Programming"
$portableGitFilename = "PortableGit.exe"
if (!(Test-Path -Path "$portableGitInstallationDir")) {
    New-Item -Path "$portableGitInstallationDir" -ItemType Directory
    curl -O $portableGitInstallationDir\$portableGitFilename https://github.com/git-for-windows/git/releases/download/v$gitLatestVersion.windows.1/PortableGit-$gitLatestVersion-64-bit.7z.exe
    Start-Process $portableGitInstallationDir\$portableGitFilename
}

# Set up .bashrc
$filename = ".bashrc"
$file_path = Join-Path $env:USERPROFILE -ChildPath $filename
$file_content = @'
#!/bin/bash
export PATH="$PATH:/c/apportable/Programming/deno:/c/apportable/Programming/jdk/bin:/c/apportable/Programming/PortableGit/cmd:/c/apportable/Programming/Terraform:/c/apportable/Programming/nvm:/c/apportable/Programming/nodejs:/c/apportable/Programming/nodejs/node_modules/npm/bin:/c/apportable/Programming/sqlite:/c/Program Files/Docker/Docker/resources/bin:/c/ProgramData/DockerDesktop/version-bin:/c/Users/Admin/AppData/Local/ComposerSetup/bin:/c/Users/Admin/AppData/Roaming/Composer/vendor/bin"
'@
Set-Content -Path $file_path -Value $file_content
Write-Host "File created successfully at: $file_path"
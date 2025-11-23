#!/bin/bash

portableFolderName="apportable"
rootDir="C:/$portableFolderName"

#==========PROGRAMMING==========#
environment="Programming"
HOME="C:/Users/$USERNAME" # Set the custom home directory dynamically using $USER
# HOME="C:/apportable/Programming/msys64/home/$USERNAME" # Set the custom home directory dynamically using $USER
_7zip_path="$rootDir/$environment/7-Zip"

# Create "apportable" directory if it doesn't exist
[ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment"

#=====MSYS2=====#
# URL of the releases page
msys2_url="https://github.com/msys2/msys2-installer/releases"

# Desired h2 index
h2Index=3

# Fetch the page content
page_content=$(curl -s "$msys2_url")

# Extract the innerText of the h2 tag specified by h2Index using awk
h2_text=$(echo "$page_content" | awk -v indexer="$h2Index" 'BEGIN{RS="</h2>"; IGNORECASE=1} NR==indexer{gsub(/.*<h2[^>]*>/,""); print}')
latest_release_date="$h2_text"
latest_release_date_without_hyphens=$(echo "$latest_release_date" | tr -d '-')

# Construct the final URL
mysys2_URL="https://github.com/msys2/msys2-installer/releases/download/$latest_release_date/msys2-base-x86_64-$latest_release_date_without_hyphens.tar.xz"

# Define the path where the tar file will be downloaded
tarFile="$rootDir/$environment/msys64.tar.xz"
# Download the tar.xz file
curl -L -o "$tarFile" "$mysys2_URL"

# Destination directory for extraction
destinationDir="$rootDir/$environment/msys64_temp"

# Check if the tar file exists
if [ -f "$tarFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"

    # Step 1: Extract the tar.xz file (just the .tar part)
    "$_7zip_path/7z.exe" x -y "$tarFile" -o"$destinationDir"

    # Step 2: Extract the contents of the .tar file directly into $destinationDir
    # Get the tar filename without the .xz extension
    tarFileExtracted="$destinationDir/$(basename "$tarFile" .xz)"
    
    # Extract the .tar file into the destination directory without creating an additional nested folder
    "$_7zip_path/7z.exe" x -y "$tarFileExtracted" -o"$destinationDir" -aoa

    # Remove the intermediate .tar file after extraction, if desired
    rm -f "$tarFileExtracted"

    echo "Extraction complete."
else
    echo "Tar file not found: $tarFile"
fi

# Assuming there's only one directory in the extracted content
extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
# Move and rename the extracted content
mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/msys64"
# Delete the temporary folder
rm -rf "$destinationDir"
#=====MSYS2=====#

#=====RC FILES=====#
curl -sL https://raw.githubusercontent.com/judigot/references/main/.bashrc -o "$HOME/.bashrc"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.profile -o "$HOME/.profile"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc"
#=====RC FILES=====#

#=====GIT CONFIG=====#
# Set "main" as default branch
git config --global init.defaultBranch main

# Use LF (Unix) instead of CRLF (Windows)
git config --global core.autocrlf input

# Use Vim as default Git editor
git config --global core.editor "vim"

# Use Windows' SSH since Git's SSH has problems cloning repositories
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
#=====GIT CONFIG=====#

#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#
BAT_PATH="$rootDir/$environment/Bash.bat"
cat << EOF > "$BAT_PATH"
@echo off

set HOME=%USERPROFILE%
@REM set HOME=C:\apportable\Programming\msys64\home\%USERNAME%
set BASH_ENV=%HOME%\.bashrc

:: Check if a script file is passed as an argument
if "%~1"=="" (
    C:/apportable/Programming/msys64/usr/bin/bash.exe --login -i -c "source '%BASH_ENV%'; exec bash"
) else (
    cd /d %~dp1
    C:/apportable/Programming/msys64/usr/bin/bash.exe --login -c "source '%BASH_ENV%'; cd '%~dp1'; bash '%~f1'"
)
EOF
echo "Bash.bat has been created successfully."
#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#

#=====BATCH FILE TO OPEN ZSH SHELL=====#
BAT_PATH="$rootDir/$environment/Zsh.bat"
cat << EOF > "$BAT_PATH"
@echo off

set HOME=%USERPROFILE%
@REM set HOME=C:\apportable\Programming\msys64\home\%USERNAME%
set BASH_ENV=%HOME%\.bashrc

:: Check if a script file is passed as an argument
if "%~1"=="" (
    C:/apportable/Programming/msys64/usr/bin/bash.exe --login -i -c "source '%BASH_ENV%'; exec zsh"
) else (
    cd /d %~dp1
    C:/apportable/Programming/msys64/usr/bin/bash.exe --login -c "source '%BASH_ENV%'; cd '%~dp1'; zsh '%~f1'"
)
EOF
echo "Zsh.bat has been created successfully."
#=====BATCH FILE TO OPEN ZSH SHELL=====#

#=====DENO=====#
repository="https://github.com/denoland/deno"
HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'

# Fetch HTML content and extract the version string
versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
    $0 ~ pattern {
        match($0, />[^<]+</);  # Find the first occurrence of text between > and <
        print substr($0, RSTART + 1, RLENGTH - 2);  # Extract and print the text, excluding > and <
        exit;
    }')

# Check if versionString is not empty
if [[ -z "$versionString" ]]; then
    echo "Failed to fetch the version string."
    exit 1
fi

# Download the Deno zip file
curl -L -o "$rootDir/$environment/deno.zip" "https://github.com/denoland/deno/releases/download/$versionString/deno-x86_64-pc-windows-msvc.zip"

# Path to the zip file
zipFile="$rootDir/$environment/deno.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/deno"

# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file using 7-Zip
    "$_7zip_path/7z.exe" x -y "$zipFile" -o"$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
    exit 1
fi
#=====DENO=====#

#=====NVM=====#
repository="https://github.com/coreybutler/nvm-windows"
HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
# Fetch HTML content and extract the version string
versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
    $0 ~ pattern {
        match($0, />[^<]+</);  # Find the first occurrence of text between > and <
        print substr($0, RSTART + 1, RLENGTH - 2);  # Extract and print the text, excluding > and <
        exit;
    }')

# Remove first character "v" to get the version number
# nvmLatestVersion="${versionString:1}"
nvmLatestVersion="1.2.2"

curl -L -o "$rootDir/$environment/nvm-noinstall.zip" "https://github.com/coreybutler/nvm-windows/releases/download/$nvmLatestVersion/nvm-noinstall.zip"
# Path to the zip file
zipFile="$rootDir/$environment/nvm-noinstall.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/nvm"
# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file
    unzip "$zipFile" -d "$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
fi
# Initialize variables
NVM_HOME="$destinationDir"
NVM_SYMLINK="$rootDir/$environment/nodejs"
# Set environment variables
export NVM_HOME
export NVM_SYMLINK
echo "" >"$NVM_HOME/PATH.txt"
echo "" >"$NVM_HOME/settings.txt"
# Update PATH environment variable
echo "PATH=$PATH" >"$NVM_HOME/PATH.txt"
export PATH="$PATH:$NVM_HOME:$NVM_SYMLINK"
# System architecture detection
if [ -d "/c/Program Files (x86)" ]; then
    SYS_ARCH=64
else
    SYS_ARCH=32
fi
# Create settings file
echo "root: $NVM_HOME" >"$NVM_HOME/settings.txt"
echo "path: $NVM_SYMLINK" >>"$NVM_HOME/settings.txt"
echo "arch: $SYS_ARCH" >>"$NVM_HOME/settings.txt"
echo "proxy: none" >>"$NVM_HOME/settings.txt"

# Install and use latest Node.js version & PNPM
nvm install lts
nvm use lts
npm config set script-shell "$rootDir/$environment/PortableGit/bin/bash.exe" # Use Git Bash for running scripts in VS Code NPM Scripts panel
npm install -g bun pnpm
#=====NVM=====#

#=====PHP=====#
versionString=$(curl -s https://www.php.net/releases/feed.php | awk -F'<php:version>|</php:version>' '/<php:version>/{print $2; exit}')

# Check if versionString is not empty
if [[ -z "$versionString" ]]; then
    echo "Failed to fetch the version string."
    exit 1
fi

# Download the php zip file
curl -L -o "$rootDir/$environment/php.zip" "https://windows.php.net/downloads/releases/php-$versionString-nts-Win32-vs16-x64.zip"

# Path to the zip file
zipFile="$rootDir/$environment/php.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/php"

# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file using 7-Zip
    "$_7zip_path/7z.exe" x -y "$zipFile" -o"$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
    exit 1
fi
#=====PHP=====#

#=====COMPOSER=====#
composerDir="$rootDir/$environment/composer"  # Set the directory for Composer

# Create Composer directory if it doesn't exist
[ -d "$composerDir" ] || mkdir -p "$composerDir"

# Download Composer using the provided URL
curl -L -o "$composerDir/composer.phar" "https://getcomposer.org/download/latest-stable/composer.phar"

# Ensure Composer is executable
chmod +x "$composerDir/composer.phar"

# Create "composer" file
# cat << 'EOF' > "$composerDir/composer"
# #!/bin/bash

# # Get the directory of the script
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# # Call composer.phar from the script directory
# php "$SCRIPT_DIR/composer.phar" "$@"
# EOF

cat << 'EOF' > "$composerDir/composer"
#!/bin/sh

dir=$(cd "${0%[/\\]*}" > /dev/null; pwd)

if [ -d /proc/cygdrive ]; then
    case $(which php) in
        $(readlink -n /proc/cygdrive)/*)
            # We are in Cygwin using Windows php, so the path must be translated
            dir=$(cygpath -m "$dir");
            ;;
    esac
fi

php "${dir}/composer.phar" "$@"
EOF

cat << 'EOF' > "$composerDir/composer.bat"
@echo OFF
:: in case DelayedExpansion is on and a path contains ! 
setlocal DISABLEDELAYEDEXPANSION
php "%~dp0composer.phar" %*
EOF

# Ensure the "composer" script is executable
chmod +x "$composerDir/composer"
#=====COMPOSER=====#

#=====PHP.INI=====#
php_ini_path="$rootDir/$environment/php/php.ini"  # Path to the php.ini file
php_ini_development="$rootDir/$environment/php/php.ini-development"  # Path to the development ini file

# Recreate php.ini from php.ini-development
cp "$php_ini_development" "$php_ini_path"

# Append required PHP extensions and custom settings
{
    echo ""
    cat <<EOF
;=====CUSTOM=====;
; Enable extensions directory
extension_dir = "ext"
zend_extension=opcache

; Extensions to enable
;extension=bcmath
;extension=calendar
;extension=xmlrpc

extension=openssl
extension=fileinfo
extension=gettext
extension=mysqli
extension=pdo_mysql
extension=pgsql
extension=pdo_pgsql
extension=sqlite3
extension=pdo_sqlite
extension=curl
extension=mbstring
extension=exif
extension=zip
extension=gd
extension=intl
extension=soap

; Overrides
date.timezone = "Asia/Manila"
post_max_size = 200M
max_file_uploads = 200M
upload_max_filesize = 2000M
max_execution_time = 200
max_input_time = 200
;=====CUSTOM=====;
EOF
} >> "$php_ini_path"
#=====PHP.INI=====#

#=====UNZIP & ZIP=====#
zipDir="$rootDir/$environment/zip"
[ -d "$zipDir/bin" ] || mkdir -p "$zipDir/bin"

curl -L -o "$zipDir/bin/unzip.exe" "https://stahlworks.com/dev/unzip.exe"
curl -L -o "$zipDir/bin/zip.exe" "https://stahlworks.com/dev/zip.exe"

if [ -f "$zipDir/bin/unzip.exe" ] && [ -f "$zipDir/bin/zip.exe" ]; then
    chmod +x "$zipDir/bin/unzip.exe"
    chmod +x "$zipDir/bin/zip.exe"
    echo "Unzip and zip downloaded successfully."
else
    echo "Failed to download unzip or zip."
    exit 1
fi
#=====UNZIP & ZIP=====#

#=====SDKMAN=====#
sdkmanDir="$rootDir/$environment/sdkman"
export SDKMAN_DIR="$sdkmanDir"

curl -s "https://get.sdkman.io" | bash -s

if [ -f "$sdkmanDir/bin/sdkman-init.sh" ]; then
    source "$sdkmanDir/bin/sdkman-init.sh"
    sdk install java
    sdk install maven
    echo "SDKMAN installed and Java/Maven installed via SDKMAN."
else
    echo "SDKMAN installation failed."
    exit 1
fi
#=====SDKMAN=====#

#==========TERRAFORM==========#
repository="https://github.com/hashicorp/terraform"
HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
# Fetch HTML content and extract the version string
versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
    $0 ~ pattern {
        match($0, />[^<]+</);  # Find the first occurrence of text between > and <
        print substr($0, RSTART + 1, RLENGTH - 2);  # Extract and print the text, excluding > and <
        exit;
    }')

# Remove first character "v" to get the version number
versionNumber="${versionString:1}"
curl -L -o "$rootDir/$environment/terraform.zip" "https://releases.hashicorp.com/terraform/$versionNumber/terraform_${versionNumber}_windows_386.zip"
# Path to the zip file
zipFile="$rootDir/$environment/terraform.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/terraform"
# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file
    unzip "$zipFile" -d "$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
fi
#==========TERRAFORM==========#

#=====DBEAVER=====#
URL="https://dbeaver.io/download/"
htmlContent=$(curl -L --silent "$URL")
innerHTML="Windows (zip)" # Keep the full innerHTML text, including spaces and parentheses
targetAttribute="href"

hrefValue=$(echo "$htmlContent" | awk -v innerHTML="$innerHTML" -v attr="$targetAttribute" '
BEGIN { RS="<a "; FS=">"; OFS="" }
{
    /* Use the index function for a literal substring search */
    if (index($0, innerHTML) > 0) {
        for (i = 1; i <= NF; i++) {
            /* Construct the regex to match the desired attribute */
            attrRegex = attr "=\"[^\"]+\""
            if (match($i, attrRegex)) {
                /* Extract the target attribute */
                attrStart = RSTART + length(attr) + 2
                attrLength = RLENGTH - length(attr) - 3
                hrefValue = substr($i, attrStart, attrLength)
                print hrefValue
                exit
            }
        }
    }
}')
dbeaver_URL="https://dbeaver.io$hrefValue"

# Download the zip file
curl -L -o "$rootDir/$environment/dbeaver.zip" "$dbeaver_URL"
# Path to the zip file
zipFile="$rootDir/$environment/dbeaver.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/dbeaver_temp"
# Check if the zip file exists and extract
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file
    unzip "$zipFile" -d "$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
fi
# Find the extracted folder name
extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
# Move and rename the extracted content
mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/dbeaver"
# Delete temporary folder
rm -rf "$destinationDir"
#=====DBEAVER=====#

#=====HEIDISQL=====#
repository="https://github.com/HeidiSQL/HeidiSQL"
HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
# Fetch HTML content and extract the version string
versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
    $0 ~ pattern {
        match($0, />[^<]+</);  # Find the first occurrence of text between > and <
        print substr($0, RSTART + 1, RLENGTH - 2);  # Extract and print the text, excluding > and <
        exit;
    }')

# Remove first character "v" to get the version number
heidisqlLatestVersion=$(echo "$versionString" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+') # 12.13.0.7147

# Extract the first href
JDK_URL="https://github.com/HeidiSQL/HeidiSQL/releases/download/v12.13.0.7147/HeidiSQL_12.13_64_Portable.zip"

curl -L -o "$rootDir/$environment/heidisql.zip" $JDK_URL
# Path to the zip file
zipFile="$rootDir/$environment/heidisql.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/heidisql"
# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    # Extract the zip file
    unzip "$zipFile" -d "$destinationDir"
    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
fi
#=====HEIDISQL=====#

#==========PROGRAMMING==========#

#==========AUDIO PRODUCTION==========#
environment="Audio Production"

# #=====REAPER=====#
# Clone audio-production
# [ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment" && cd "$_" || return
# git clone git@github.com:judigot/audio-production.git .
# # Clone "reaper"
# [ -d "$rootDir/$environment/REAPER" ] || mkdir -p "$rootDir/$environment/REAPER" && cd "$_" || return
# git clone git@github.com:judigot/reaper.git .
# URL="https://www.reaper.fm/download.php"
# htmlContent=$(curl -L --silent "$URL")
# reaperDownloadLink="https://www.reaper.fm/$(echo "$htmlContent" | awk '/x64-install\.exe/ && /href=/{print}' | sed -n 's/.*href="\([^"]*x64-install\.exe[^"]*\).*/\1/p')"
# # Download REAPER
# curl -L -o "$rootDir/$environment/reaper-install.exe" $reaperDownloadLink
# powershell.exe -Command "Start-Process -FilePath '\"$rootDir/$environment/reaper-install.exe\"'"
# reaperInstallationPath="$(echo "$rootDir/$environment/REAPER"  | sed 's|/|\\\\|g')"
# echo -e "\e[32mREAPER Portable Installation Directory:\n\n$reaperInstallationPath\e[0m" # Green
# #=====REAPER=====#

#==========AUDIO PRODUCTION==========#
#!/bin/bash

portableFolderName="apportable"
rootDir="C:/$portableFolderName"

#==========PROGRAMMING==========#
environment="Programming"

_7zip_path="$rootDir/$environment/7-Zip"

# Create "apportable" directory if it doesn't exist
[ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment"

#=====.BASHRC=====#
bashrc_url="https://raw.githubusercontent.com/judigot/references/main/.bashrc"
curl -L "$bashrc_url" -o "$HOME/.bashrc"
if [[ -f "$HOME/.bashrc" ]]; then
    echo ".bashrc created successfully at: $HOME/.bashrc"
else
    echo "Failed to create .bashrc."
    exit 1
fi
#=====.BASHRC=====#

#=====GIT CONFIG=====#
# Set "main" as default branch
git config --global init.defaultBranch main

# Use LF (Unix) instead of CRLF (Windows)
git config --global core.autocrlf input

# Use Vim as default Git editor
git config --global core.editor "vim"
#=====GIT CONFIG=====#

#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#
BAT_PATH="$rootDir/$environment/Bash.bat"
cat << EOF > "$BAT_PATH"
@echo off

@REM set HOME=%USERPROFILE%
set HOME=C:\apportable\Programming\msys64\home\%USERNAME%
set BASH_ENV=%HOME%\.bashrc

:: Check if a script file is passed as an argument
if "%~1"=="" (
    $rootDir/$environment/msys64/usr/bin/bash.exe --login
) else (
    set FULL_PATH=%~f1
    cd /d %~dp1
    $rootDir/$environment/msys64/usr/bin/bash.exe --login -c "cd '%~dp1' && bash '%~f1'"
)
EOF
echo "Bash.bat has been created successfully."
#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#

#=====BATCH FILE TO OPEN ZSH SHELL=====#
BAT_PATH="$rootDir/$environment/Zsh.bat"
cat << EOF > "$BAT_PATH"
@echo off
set HOME=%USERPROFILE%
set BASH_ENV=%USERPROFILE%\.bashrc

:: Check if a script file is passed as an argument
if "%~1"=="" (
    $rootDir/$environment/msys64/usr/bin/zsh.exe --login
) else (
    set FULL_PATH=%~f1
    cd /d %~dp1
    $rootDir/$environment/msys64/usr/bin/zsh.exe --login -c "cd '%~dp1' && zsh '%~f1'"
)
EOF
echo "Zsh.bat has been created successfully."
#=====BATCH FILE TO OPEN ZSH SHELL=====#

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
    # Extract the tar.xz file using 7-Zip
    "$_7zip_path/7z.exe" x -y "$tarFile" -o"$destinationDir"
    # Continue extracting the inner tar file
    "$_7zip_path/7z.exe" x -y "$destinationDir/$(basename "$tarFile" .xz)" -o"$destinationDir"
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
nvmLatestVersion="${versionString:1}"

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
npm install -g pnpm
#=====NVM=====#

#=====JAVA OPENJDK=====#
URL="https://jdk.java.net/21/"
htmlContent=$(curl -L --silent "$URL")
innerHTML="zip" # Keep the full innerHTML text, including spaces and parentheses
targetAttribute="href"

JDK_URL=$(echo "$htmlContent" | awk -v innerHTML="$innerHTML" -v attr="$targetAttribute" '
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

curl -L -o "$rootDir/$environment/jdk.zip" $JDK_URL
# Path to the zip file
zipFile="$rootDir/$environment/jdk.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/jdk_temp"
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
extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
# Move and rename
mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/jdk"
# Delete temporary folder
rm -rf $destinationDir
#=====JAVA OPENJDK=====#

#=====APACHE MAVEN=====#
repository="https://github.com/apache/maven"
HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
# Fetch HTML content and extract the version string
versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
    $0 ~ pattern {
        match($0, />[^<]+</);  # Find the first occurrence of text between > and <
        print substr($0, RSTART + 1, RLENGTH - 2);  # Extract and print the text, excluding > and <
        exit;
    }')

# Remove first character "v" to get the version number
mavenVersionNumber="${versionString}"

curl -L -o "$rootDir/$environment/apache-maven.zip" https://dlcdn.apache.org/maven/maven-3/$mavenVersionNumber/binaries/apache-maven-$mavenVersionNumber-bin.zip

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

zipFile="$rootDir/$environment/apache-maven.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/apache-maven_temp"
# Check if the zip file exists
if [ -f "$zipFile" ]; then
    # Create the destination directory if it doesn't exist
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"

    # Extract the zip file using available extraction tool
    if command_exists unzip; then
        unzip "$zipFile" -d "$destinationDir"
    elif command_exists 7z; then
        7z x $zipFile -o"$destinationDir" -aoa
    elif command_exists winrar; then
        winrar x $zipFile .
    elif command_exists winzip; then
        winzip -e $zipFile .
    else
        echo "Error: No suitable extraction tool found (unzip, 7z, winrar, winzip)."
        exit 1
    fi

    echo "Extraction complete."
else
    echo "Zip file not found: $zipFile"
fi

extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

# Move and rename
mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/apache-maven"
# Delete temporary folder
rm -rf $destinationDir
#=====APACHE MAVEN=====#

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
heidisqlLatestVersion="$versionString"

# Extract the first href
JDK_URL="https://www.heidisql.com/downloads/releases/HeidiSQL_${heidisqlLatestVersion}_64_Portable.zip"
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

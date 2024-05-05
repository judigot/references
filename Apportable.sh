#!/bin/bash

portableFolderName="apportable"
rootDir="C:/$portableFolderName"

#==========PROGRAMMING==========#
environment="Programming"

# Create "apportable" directory if it doesn't exist
[ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment"


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
set BASH_ENV=C:/Users/Jude/.bashrc
set FULL_PATH=%~f1
cd /d %~dp1
C:/$portableFolderName/$environment/msys64/usr/bin/bash.exe --login -c "cd '%~dp1' && bash '%~f1'"
EOF
echo "Bash.bat has been created successfully."
#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#

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

# Remove first character "v" to get the version number
denoLatestVersion="$versionString"

curl -L -o "$rootDir/$environment/deno.zip" "https://github.com/denoland/deno/releases/download/$denoLatestVersion/deno-x86_64-pc-windows-msvc.zip"
# Path to the zip file
zipFile="$rootDir/$environment/deno.zip"
# Destination directory for extraction
destinationDir="$rootDir/$environment/deno"
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
[ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment" && cd "$_" || return
git clone git@github.com:judigot/audio-production.git .
# Clone "reaper"
[ -d "$rootDir/$environment/REAPER" ] || mkdir -p "$rootDir/$environment/REAPER" && cd "$_" || return
git clone git@github.com:judigot/reaper.git .
URL="https://www.reaper.fm/download.php"
htmlContent=$(curl -L --silent "$URL")
reaperDownloadLink="https://www.reaper.fm/$(echo "$htmlContent" | awk '/x64-install\.exe/ && /href=/{print}' | sed -n 's/.*href="\([^"]*x64-install\.exe[^"]*\).*/\1/p')"
# Download REAPER
curl -L -o "$rootDir/$environment/reaper-install.exe" $reaperDownloadLink
powershell.exe -Command "Start-Process -FilePath '\"$rootDir/$environment/reaper-install.exe\"'"
reaperInstallationPath="$(echo "$rootDir/$environment/REAPER"  | sed 's|/|\\\\|g')"
echo -e "\e[32mREAPER Portable Installation Directory:\n\n$reaperInstallationPath\e[0m" # Green
# #=====REAPER=====#

#==========AUDIO PRODUCTION==========#

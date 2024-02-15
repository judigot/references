#!/bin/bash

#==========PROGRAMMING==========#
environment="Programming"
portableFolderName="apportable"
rootDir="C:/$portableFolderName"

# Set "main" as default branch
git config --global init.defaultBranch main

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
zipFile="C:/apportable/Programming/deno.zip"
# Destination directory for extraction
destinationDir="C:/apportable/Programming/deno"
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
zipFile="C:/apportable/Programming/nvm-noinstall.zip"
# Destination directory for extraction
destinationDir="C:/apportable/Programming/nvm"
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
npm config set script-shell "C:/apportable/Programming/PortableGit/bin/bash.exe" # Use Git Bash for running scripts in VS Code NPM Scripts panel
npm install -g pnpm
#=====NVM=====#

#=====JAVA OPENJDK=====#
URL="https://jdk.java.net/21/"
html_content=$(curl -s "$URL")
# Extract the first href
JDK_URL="$(echo "$html_content" | grep -oP 'href="\K[^"]*(?=.*zip)' | head -1)zip"
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

#=====DBEAVER=====#
URL="https://dbeaver.io/download/"
html_content=$(curl -s "$URL")
# Extract the href attributes of the element containing the text "Windows (zip)"
# Update the regular expression to target links with "Windows (zip)"
dbeaver_URL=$(echo "$html_content" | grep -oP 'href="\K[^"]*(?=.*Windows \(zip\))' | head -1)
# Complete URL construction (if needed)
dbeaver_URL="https://dbeaver.io$dbeaver_URL"
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
URL="https://www.heidisql.com/download.php"
html_content=$(curl -s "$URL")
heidisqlVersion=$(echo "$html_content" | grep -oE 'Download HeidiSQL [0-9]+\.[0-9]+' | cut -d' ' -f3)
# Extract the first href
JDK_URL="https://www.heidisql.com/downloads/releases/HeidiSQL_${heidisqlVersion}_64_Portable.zip"
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
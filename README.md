<h1 align="center">References (Cheat Sheet)</h1>

# =====================================
# Markdown Cheat Sheet

## Link

[judigot.com](https://judigot.com)

## Heading

    Content

## Bold

**Bold** text.

## Italic

*Italic* text.

## Quote

`Highlighted` text.

## Code

```
const x = "123";
```
```js
const x = "123";
```

## Ordered List

1. Item 1
2. Item 2

## Unordered List

- Item 1
- Item 2

## Checklist

- [x] completed
- [ ] incomplete

## Line break

---

## Table

| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ |:---------------:| -------------:|
| 1             | First Name      | Last Name     |

# =====================================
# Apportable.ps1

```powershell
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
```

# =====================================

## Apportable.sh

```bash
#!/bin/bash

#==========PROGRAMMING==========#
environment="Programming"
portableFolderName="apportable"
rootDir="C:/$portableFolderName"

#=====DENO=====#
denoLatestVersion=$(curl -s "https://api.github.com/repos/denoland/deno/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
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
nvmLatestVersion=$(curl -s "https://api.github.com/repos/coreybutler/nvm-windows/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
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
PATH_ENTRY=$(reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v Path 2>nul | awk 'NR==3 {print $3}')
export PATH="$PATH_ENTRY:$NVM_HOME:$NVM_SYMLINK"
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
```

# =====================================

# Authentication Flow

    Server:
    Enable CORS in backend
    Create auth route
        - get the form values from client
        - check if the user exists
        - if user exists
            - verify password
                - if login is successful:
                    sign jwt
        - if user doesn't exists
            - send error

**Front-End Application**: The user interface where the user enters their email and password for authentication.

↓

**User (Initiates Authentication Request)**: The user submits their login credentials (email and password) through the front-end application.

↓

**authRoutes.js (Routes: Handle Authentication Endpoints)**: Defines the API endpoints for authentication, such as /login, and directs requests to the appropriate controller.

↓

**authController.js (Controllers: Manage Authentication Requests)**: Receives the login request, extracts the credentials, and calls the authentication service to process them.

↓

**authService.js (Services: Process Authentication Logic)**: Contains the core logic for authentication. Validates the user's credentials and, if valid, generates an authentication token (e.g., JWT (HTTP-Only Cookies)).

↓

**userModel.js (Models: User Data Interaction)**: Interacts with the database to retrieve and validate user information against the provided credentials.

**okenUtils.js (Utils: Token Generation and Validation)**: Utility functions for generating and validating authentication tokens.

**passwordUtils.js (Utils: Password Hashing and Validation)**: Utility functions for secure password hashing and comparison.

↓

**authMiddleware.js (Middleware: Token Validation for Protected Routes)**: Middleware that verifies the authentication token in subsequent requests to protected routes.

↓

**env (Environment Variables: Configuration Settings)**: Stores sensitive configuration data, such as secret keys for token generation, used by various components in the authentication process.

↓

**User (Response: Authentication Token or Error Message)**: The user receives a response from the server, which is either an authentication token upon successful login or an error message if authentication fails.

↓

**Front-End Application (Receives and Processes Response)**: The front-end application receives the server's response. If authentication is successful, it may store the token for future requests, or handle the error message accordingly.

# =====================================

# Amazon Web Services (AWS)

## AWS Virtual Machine Scaffolding
1. Create instance
2. Create elastic IP and assign to a network


## AWS EC2 for the application

## AWS RDS for the database

## Infastructure-as-code tools
- AWS CDK
- Terraform (open-source)

## Jenkins Configuration as Code (JCaC)

# =====================================

# Batch Scripting

```batch
@echo off

@REM Get IP address
  ipconfig /all
  
#REM Clear DNS Cache (website loads on mobile but not on PC)
  ipconfig /flushdns
```

# =====================================

# Bash Scripting

## Generate SSH Key for GitHub
```shellscript
ssh-keygen -f ~/.ssh/id_rsa -P "" && clear && echo -e "Copy and paste the public key below to your GitHub account:\n\n\e[32m$(cat ~/.ssh/id_rsa.pub) \e[0m\n" # Green
```

## Test SSH Key
```shellscript
ssh -T git@github.com -o StrictHostKeyChecking=no # Skip answering yes
```

## Generate SSL using Certbot - HTTPS; 443
```shellscript
apt install -y python3-certbot-nginx
certbot --nginx -d example.com
certbot --nginx -d app.example.com
# *keys are located in /etc/letsencrypt
```

## Check Linux Distro and Version
```shellscript
cat /etc/*-release
```

## Copy Files and Directories
### Copy Files
```shellscript
cp src/* dest
```

### Copy with Warning Before Overwriting
```shellscript
cp -i src/* dest
```

## Delete Folders and Contents
### Delete a Specific Folder
```shellscript
rm -rf (folder name)
```

### Delete All Files in Current Directory
```shellscript
rm -rf *
```

### Delete Excluding Specific Folders
```shellscript
rm -rf !(dont-delete-this)
```

## Move Files
```shellscript
mv folder/* .
mv src/* dest
```

## Permissions and Ownership
### Allow Write Permission
```shellscript
sudo chmod -R 777 /var/docker/*
```

### Change Owner
```shellscript
sudo chown -R <user> /var
sudo chown -R ubuntu /var
```

## Network and SSH
### Get Server IP Address
```shellscript
hostname -I
```

### Generate SSH Key
```shellscript
ssh-keygen -t ed25519
ssh-keygen -t ed25519 -f C:\Users\Jude\.ssh\key_name
```

### SSH to AWS
```shellscript
ssh -i ~/.ssh/<key-name> ubuntu@<domain name or public IP address>
ssh -i C:/Users/<user>/.ssh/<key-name> ubuntu@<public-IP-address>
```

## Downloading and Executing Files
### Download File
```shellscript
curl -O http://example.com/test.txt

wget example.com/test.txt
```

### Download and Rename File
```shellscript
curl -L -o renamed.txt http://example.com/test.txt

wget -O renamed.txt example.com/test.txt
```

### Execute Remote Script from GitHub
```shellscript
curl -L https://raw.githubusercontent.com/username/repository/script.sh | bash
```

### Download with Original Filename
Download file with original filename
```shellscript
curl -O example.com/test.txt
# Check if file exists
IF NOT EXIST php-8.0.27-Win32-vs16-x64.zip (
  curl -O https://windows.php.net/downloads/releases/php-8.0.27-Win32-vs16-x64.zip
)
```

### Extract Zip Files (7zip)
```shellscript
SET PATH=%PATH%;C:\Program Files\7-Zip
7z x php.zip -ophp # Extract to "php" folder
7z x mysql.zip -o. # Extract to current directory
```

## System Administration
### Login as Root User
```shellscript
sudo -s
```

### Get and Install PHP Version
```shellscript
PHP_VERSION=$($(php -v) | cut -d " " -f 2 | cut -c 1-3)
PHP_FPM=$(echo php${PHP_VERSION}-fpm)
apt install $PHP_FPM
```

### Package Management
#### Install Package
```shellscript
apt install <package>
apt install <package> -y # Say yes to all prompts
```

#### Show Installation Status
```shellscript
apt show <package>
```

#### Uninstall Package
```shellscript
apt remove <package>
apt remove <package>* # Remove all related to the package
apt remove <package> -y # Say yes to all prompts
```

#### List All Installed Packages
```shellscript
apt list --installed
```

### Service Management
#### Start a Service
```shellscript
service <service-name> start
```

#### Restart a Service
```shellscript
service <service-name> restart
```

#### Stop a Service
```shellscript
service <service-name> stop
```

#### Show Service Status
```shellscript
service <service-name> status
```

#### Show Running Services and Processes
```shellscript
service --status-all
ss -ltnp # Show running ports
```

#### Kill Process Using PID
```shellscript
kill <PID>
```

## Environment Variables
### Create and Set Variables
```shellscript
VARIABLE_NAME=value
VARIABLE_NAME=$(command that outputs a string) # Set variable value to command output
export VARIABLE_NAME=$(command that outputs a string) # *export makes the variable available to subprocess
```

### List Environment Variables
```shellscript
env
printenv
```

### Include Command Output in Echo
```shellscript
echo NVM version: $(nvm -v)
echo Node.js version: $(node -v)
```
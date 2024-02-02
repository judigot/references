<h1 align="center">References (Cheat Sheet)</h1>

# =====================================
# Markdown

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
```tsx
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
# Apportable.sh

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

```bat
@echo off

@REM Get IP address
  ipconfig /all
  
#REM Clear DNS Cache (website loads on mobile but not on PC)
  ipconfig /flushdns
```

# =====================================
# Bash Scripting

## HTTP Request

Tags: `fetch`, `curl`
```bash
result=$(
    URL="http://localhost:3000/api/v1/snippets"
    response=$(curl -X \
        GET \
        "$URL" \
        -H "Accept: application/json, text/plain, */*" \
        -H "Content-Type: application/json" \
        -d '{"key1":"value1", "key2":"value2"}') # For POST, PATCH, and PUT requests
    exitStatus=$?
    [ $exitStatus -ne 0 ] && echo -e "\e[31mError in curl request with exit status: $exitStatus\e[0m" >&2 && exit 1 || echo $response
)
echo "$result"
```

## Delete Folder if It Exists; Check if a Folder Exists
```bash
([ ! -d dist ] || rm -r dist)
```

## Generate SSH Key for GitHub
```bash
ssh-keygen -f ~/.ssh/id_rsa -P "" && clear && echo -e "Copy and paste the public key below to your GitHub account:\n\n\e[32m$(cat ~/.ssh/id_rsa.pub) \e[0m\n" # Green
```

## Test SSH Key
```bash
ssh -T git@github.com -o StrictHostKeyChecking=no # Skip answering yes
```

## Generate SSL using Certbot - HTTPS; 443
```bash
apt install -y python3-certbot-nginx
certbot --nginx -d example.com
certbot --nginx -d app.example.com
# *keys are located in /etc/letsencrypt
```

## Check Linux Distro and Version
```bash
cat /etc/*-release
```

## Copy Files and Directories
### Copy Files
```bash
cp src/* dest
```

### Copy with Warning Before Overwriting
```bash
cp -i src/* dest
```

## Delete Folders and Contents
### Delete a Specific Folder
```bash
rm -rf (folder name)
```

### Delete All Files in Current Directory
```bash
rm -rf *
```

### Delete Excluding Specific Folders
```bash
rm -rf !(dont-delete-this)
```

## Move Files
```bash
mv folder/* .
mv src/* dest
```

## Permissions and Ownership
### Allow Write Permission
```bash
sudo chmod -R 777 /var/docker/*
```

### Change Owner
```bash
sudo chown -R <user> /var
sudo chown -R ubuntu /var
```

## Network and SSH
### Get Server IP Address
```bash
hostname -I
```

### Generate SSH Key
```bash
ssh-keygen -t ed25519
ssh-keygen -t ed25519 -f C:\Users\Jude\.ssh\key_name
```

### SSH to AWS
```bash
ssh -i ~/.ssh/<key-name> ubuntu@<domain name or public IP address>
ssh -i C:/Users/<user>/.ssh/<key-name> ubuntu@<public-IP-address>
```

## Downloading and Executing Files
### Download File
```bash
curl -O http://example.com/test.txt

wget example.com/test.txt
```

### Download and Rename File
```bash
curl -L -o renamed.txt http://example.com/test.txt

wget -O renamed.txt example.com/test.txt
```

### Execute Remote Script from GitHub
```bash
curl -L https://raw.githubusercontent.com/username/repository/script.sh | bash
```

### Download with Original Filename
Download file with original filename
```bash
curl -O example.com/test.txt
# Check if file exists
IF NOT EXIST php-8.0.27-Win32-vs16-x64.zip (
  curl -O https://windows.php.net/downloads/releases/php-8.0.27-Win32-vs16-x64.zip
)
```

### Extract Zip Files (7zip)
```bash
SET PATH=%PATH%;C:\Program Files\7-Zip
7z x php.zip -ophp # Extract to "php" folder
7z x mysql.zip -o. # Extract to current directory
```

## System Administration
### Login as Root User
```bash
sudo -s
```

### Get and Install PHP Version
```bash
PHP_VERSION=$($(php -v) | cut -d " " -f 2 | cut -c 1-3)
PHP_FPM=$(echo php${PHP_VERSION}-fpm)
apt install $PHP_FPM
```

### Package Management
#### Install Package
```bash
apt install <package>
apt install <package> -y # Say yes to all prompts
```

#### Show Installation Status
```bash
apt show <package>
```

#### Uninstall Package
```bash
apt remove <package>
apt remove <package>* # Remove all related to the package
apt remove <package> -y # Say yes to all prompts
```

#### List All Installed Packages
```bash
apt list --installed
```

### Service Management
#### Start a Service
```bash
service <service-name> start
```

#### Restart a Service
```bash
service <service-name> restart
```

#### Stop a Service
```bash
service <service-name> stop
```

#### Show Service Status
```bash
service <service-name> status
```

#### Show Running Services and Processes
```bash
service --status-all
ss -ltnp # Show running ports
```

#### Kill Process Using PID
```bash
kill <PID>
```

## Environment Variables
### Create and Set Variables
```bash
VARIABLE_NAME=value
VARIABLE_NAME=$(command that outputs a string) # Set variable value to command output
export VARIABLE_NAME=$(command that outputs a string) # *export makes the variable available to subprocess
```

### List Environment Variables
```bash
env
printenv
```

### Include Command Output in Echo
```bash
echo NVM version: $(nvm -v)
echo Node.js version: $(node -v)
```

# =====================================
# Big Bang Next.js

```bash
#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="bigbang"

readonly PRODUCTION_DEPENDENCIES=(
    "axios"
    "bootstrap"
    "dotenv"
)

readonly DEV_DEPENDENCIES=(
    "cross-env"
    "dotenv-cli"
    "prettier"
    "styled-components"
    "tailwindcss"
    "ts-node"
    "vite-tsconfig-paths"
    "vitest"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"

function main() {
    echo -e "\e[32mInitializing...\e[0m" &&
        downloadNextJS &&
        createEnv &&
        deleteFiles "css" &&
        codeToBeRemoved=("import { Inter } from 'next/font/google'" "import './globals.css'" " className={inter.className}") &&
        removeTextContent "codeToBeRemoved[@]" &&
        # codeToBeRemoved=("import reactLogo from './assets/react.svg'" "import viteLogo from '/vite.svg'") &&
        # removeTextContent "codeToBeRemoved[@]" &&
        directories=("components" "helpers" "styles" "tests" "types" "utils") &&
        createDirectories "$PROJECT_DIRECTORY/src" "directories[@]" &&
        removeBoilerplate &&
        removeLayoutBoilerplate &&
        installDefaultPackages &&
        installPackages "development" "DEV_DEPENDENCIES[@]" &&
        installPackages "production" "PRODUCTION_DEPENDENCIES[@]" &&

        # ==========CUSTOM SETTINGS========== #

        # Strict mode
        # createAppTSX &&
        createPrettierRc &&
        modifyESLintConfig &&
        codeToBeRemoved=(".tsx") &&
        removeTextContent "codeToBeRemoved[@]" &&
        installStrictPackages &&

        # tsconfig.node.json
        addStrictNullChecks &&

        # Testing
        # Jest
        local jestPackages=("jest" "@types/jest" "jest-environment-jsdom" "@testing-library/react" "@testing-library/jest-dom") &&
        installPackages "development" "jestPackages[@]" &&
        createJestConfig &&

        # Vitest
        # local vitestPackages=("vitest" "@vitejs/plugin-react" "jsdom" "@testing-library/react") &&
        # installPackages "development" "vitestPackages[@]" &&
        # createJestConfig &&

        # Prisma
        local prismaPackages=("prisma") &&
        installPackages "development" "prismaPackages[@]" &&
        local prismaPackages=("@prisma/client") &&
        installPackages "production" "prismaPackages[@]" &&
        prependToTextContent "$PROJECT_DIRECTORY/package.json" "\"dependencies\": {" "$(
            cat <<EOF
"prisma": {
    "seed": "ts-node --compilerOptions {\"module\":\"CommonJS\"} ./src/prisma/seed/seed.ts",
    "schema": "src/prisma/schema.prisma"
},
EOF
        )" &&
        cd "$PROJECT_DIRECTORY" && pnpm prisma init --datasource-provider postgresql &&
        mv "$PROJECT_DIRECTORY/prisma" "$PROJECT_DIRECTORY/src" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset-with-data" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push && pnpm dotenv -e .env.local -- pnpm run db:seed" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:seed" "pnpm dotenv -e .env.local -- pnpm prisma db seed" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:drop" "pnpm dotenv -e .env.local -- ts-node --compilerOptions \\\\\"{\\\\\\\\\\\\\"module\\\\\\\\\\\\\":\\\\\\\\\\\\\"CommonJS\\\\\\\\\\\\\"}\\\\\" ./src/prisma/scripts/DeleteTables.ts" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:push" "pnpm dotenv -e .env.local -- pnpm prisma db push && pnpm prisma generate" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:pull" "pnpm dotenv -e .env.local -- pnpm prisma db pull && pnpm prisma generate" &&

        # ==========CUSTOM SETTINGS========== #
        formatCode &&
        echo -e "\e[32mBig Bang was successfully scaffolded.\e[0m"
}

function editJSON() {
    local filename="$1"
    local action="$2" # "prepend" or "append"
    local key="$3"
    local property="$4"
    local value="$5"
    local tempFile="${filename}.tmp"

    # Use awk to process the file
    awk -v action="$action" -v key="$key" -v prop="$property" -v val="$value" '
    BEGIN { foundKey=0; propertyExists=0; }
    {
        if ($0 ~ "\"" key "\": {") {
            foundKey=1;
            print $0;
            next;
        }
        if (foundKey && $0 ~ "\"" prop "\":") {
            propertyExists=1;
        }
        if (foundKey && $0 ~ /}/) {
            if (action == "append" && !propertyExists) {
                print "    ,\"" prop "\": \"" val "\"";
            }
            foundKey=0;
            propertyExists=0;  # Reset for next key if any
        }
        if (action == "prepend" && foundKey && !propertyExists) {
            print "    \"" prop "\": \"" val "\",";
            propertyExists=1;  # Prevent further prepend
        }
        print $0;
    }' "$filename" >"$tempFile" && mv "$tempFile" "$filename"
}

function prependToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local prependText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and prepend the text
        while IFS= read -r line || [[ -n $line ]]; do
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$prependText" >>"$tmpfile"
            fi
            echo "$line" >>"$tmpfile"
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text prepended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function createJestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="jest.config.ts"

    content=$(
        cat <<EOF
import type { Config } from 'jest'
import nextJest from 'next/jest.js'
 
const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files in your test environment
  dir: './',
})
 
// Add any custom config to be passed to Jest
const config: Config = {
  coverageProvider: 'v8',
  testEnvironment: 'jsdom',
  // Add more setup options before each test is run
  // setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
}
 
// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
export default createJestConfig(config)
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function createVitestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="vitest.config.ts"

    content=$(
        cat <<EOF
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
 
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
  },
})
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function addStrictNullChecks() {
    cd "$PROJECT_DIRECTORY" || return

    replaceLineAfterMatch "tsconfig.json" '"compilerOptions": {' ""strictNullChecks": true,"
}

function addVitestReference() {
    cd "$PROJECT_DIRECTORY" || return

    prependToPreviousLineIndex "vite.config.ts" 0 "$(
        cat <<EOF
/// <reference types="vitest" />
EOF
    )"

}

function installStrictPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm add -D \
        @typescript-eslint/eslint-plugin \
        @typescript-eslint/parser \
        eslint \
        eslint-config-prettier \
        eslint-plugin-jsx-a11y \
        eslint-plugin-prettier \
        eslint-plugin-react \
        eslint-plugin-react-hooks \
        eslint-plugin-react-refresh \
        prettier
}

function createAppTSX() {
    cd "$PROJECT_DIRECTORY/src/app" || return

    local content=""
    local fileName="App.tsx"

    content=$(
        cat <<EOF
import React from 'react';

function App(): JSX.Element {
  const [count, setCount] = React.useState<number>(0);

  return (
    <div style={{zoom: '500%', textAlign: 'center'}}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={(): void => setCount((count: number) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function createPrettierRc() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".prettierrc"

    content=$(
        cat <<EOF
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "trailingComma": "all",
  "jsxBracketSameLine": false,
  "arrowParens": "always",
  "bracketSpacing": true
}
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function modifyESLintConfig() {
    # rm .eslintrc.cjs

    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".eslintrc.cjs"

    content=$(
        cat <<EOF
module.exports = {
  root: true,
  env: {browser: true, es2020: true},
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',

    //
    'next/core-web-vitals',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    //
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: [
    'react-refresh',
    //
    'react',
    '@typescript-eslint',
    'react-hooks',
    'jsx-a11y',
    //
  ],
  //
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
  },
  //
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      {allowConstantExport: true},
    ],

    //
    'no-restricted-syntax': [
      'error',
      {
        selector: 'TSEnumDeclaration',
        message: 'Enums are not allowed. Use object literals instead.',
      },
    ],
    'no-alert': ['error'],
    'no-console': ['error', { allow: ['warn', 'error'] }],
    'arrow-body-style': ['error', 'as-needed'],
    'react/react-in-jsx-scope': 'off',
    // '@typescript-eslint/explicit-function-return-type': 'error',
    '@typescript-eslint/no-unnecessary-boolean-literal-compare': ['error'],
    '@typescript-eslint/no-unused-vars': [
      'error',
      { args: 'all', argsIgnorePattern: '^_' },
    ],
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/strict-boolean-expressions': 'error',
    // complexity: ['error', 10],
    // 'max-depth': ['error', 4],
    // 'max-lines': ['error', 300],
    'react/jsx-props-no-spreading': 'error',
    'react/jsx-filename-extension': [1, {extensions: ['.tsx']}],
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'error',
  },
};
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function createFile() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName="index.html"
    local content=""
    content=$(
        cat <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

function downloadNextJS() {
    cd "$ROOT_DIRECTORY" || return

    # Check if the project already exists
    if [ -d "$PROJECT_NAME" ]; then
        rm -rf $PROJECT_NAME
    fi

    pnpm create next-app $PROJECT_NAME --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/*

    # Check if the file was created successfully
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "\e[32mProject $PROJECT_NAME was successfully scaffolded.\e[0m" # Green
    else
        echo -e "\e[31mProject $PROJECT_NAME failed to scaffold.\e[0m" # Red
    fi
}

function deleteFiles() {
    cd "$PROJECT_DIRECTORY/src" || return

    local fileExtension="$1"

    while IFS= read -r -d $'\0' file; do
        rm "$file"

        # Check the exit status of the 'rm' command
        if [ $? -eq 0 ]; then
            echo -e "\e[32mThe file $file was deleted successfully.\e[0m" # Green
        else
            echo -e "\e[31mFailed to delete $file.\e[0m" # Red
        fi
    done < <(find $directory -type f -name "*.$fileExtension" -print0)

}

function removeTextContent() {
    cd "$PROJECT_DIRECTORY" || return

    local directory="src"
    local textToRemove=("${!1}")

    local stringToRemove=""
    # Iterate through the array elements and concatenate them
    for value in "${textToRemove[@]}"; do
        stringToRemove="$stringToRemove\|$value"
    done

    # Remove the leading space
    stringToRemove="${stringToRemove# }"

    # Define an empty array to store the filenames
    local fileArray=()

    # Use the find command to search for .tsx files in the chosen directory
    # and append each filename to the array
    while IFS= read -r -d $'\0' file; do
        fileArray+=("$file")
    done < <(find $directory -type f -name "*.tsx" -print0)

    # Print the contents of the array
    for file in "${fileArray[@]}"; do
        local replacement=""

        # Create a temporary file for editing
        local tempFile="tempfile.txt"

        # Use sed to remove the specified string from the file and save the stringToRemove in the temp file
        sed -e "s%\($stringToRemove\)%$replacement%g" "$file" >"$tempFile"
        # Replace the original file with the temp file
        mv "$tempFile" "$file"

        echo -e "\e[32mRemoved unused code from file $file.\e[0m" # Green
    done

}

function removeBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="page.tsx"
    local content=""

    content=$(
        cat <<EOF
"use client";

import { useState } from "react";

export default function Home() {
  const [count, setCount] = useState(0);

  return (
    <div style={{ zoom: "500%", textAlign: "center" }}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/app/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/app/$fileName" ]; then
        echo -e "\e[32mBoilerplate in $fileName was successfully removed.\e[0m" # Green
    else
        echo -e "\e[31mFailed to remove boilerplate in $fileName.\e[0m" # Red
    fi
}

function removeLayoutBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="layout.tsx"
    local content=""

    content=$(
        cat <<EOF
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Create Next App',
  description: 'Generated by create next app',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/app/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/app/$fileName" ]; then
        echo -e "\e[32mBoilerplate in $fileName was successfully removed.\e[0m" # Green
    else
        echo -e "\e[31mFailed to remove boilerplate in $fileName.\e[0m" # Red
    fi
}

function createDirectories() {
    cd "$PROJECT_DIRECTORY/src" || return

    local directories=("${!2}")

    for value in "${directories[@]}"; do
        mkdir "$value"
        touch "$value/.gitkeep"

        echo -e "\e[32mFolder \e[33m$value\e[0m was successfully created.\e[0m" # Green

    done

}

function installDefaultPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm install

    echo -e "\e[32mDefault packages were successfully installed.\e[0m" # Green

}

function installPackages() {
    cd "$PROJECT_DIRECTORY" || return

    local packageType="$1"
    local packages=("${!2}")
    local packagesConcatenated=""

    for value in "${packages[@]}"; do
        packagesConcatenated="$packagesConcatenated $value"
    done

    packagesConcatenated="${packagesConcatenated# }"

    if [ "$packageType" == "development" ]; then
        pnpm install -D $packagesConcatenated
    else
        pnpm install $packagesConcatenated
    fi
}

function formatCode() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm prettier --write . --log-level silent

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSuccessfully formatted files.\e[0m" # Green
    else
        echo -e "\e[31mFailed to format files.\e[0m" # Red
    fi

}

function removeSetting() {
    cd "$PROJECT_DIRECTORY" || return

    local settingID="$1"
    local file="vite.config.ts"
    local text=""

    text=$(cat $file)

    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # Find the positions of the delimiters
    local start_pos="${text%%"$startDelimiter"*}"
    local end_pos="${text##*"$endDelimiter"}"

    # Remove the text between the delimiters
    local result="${start_pos}${end_pos}"

    echo "$result" >"$PROJECT_DIRECTORY/$file"
}

function vite.config.ts__________addBasePath() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="basepath"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        base: "./", // Resolve asset paths after building
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # Line number to append text (change this to the line number you want)
            local line_number=6

            # Create a temporary file
            tempFile="tempfile"

            # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            head -n "$((line_number - 1))" "$file" >"$tempFile"

            # Append the multi-line string to the temporary file
            echo -e "$textToAppend" >>"$tempFile"

            # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            tail -n "+$line_number" "$file" >>"$tempFile"

            # Replace the original file with the temporary file
            mv "$tempFile" "$file"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

function vite.config.ts__________addTestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="testConfig"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        test: {
            globals: true,
            environment: 'jsdom',
        },
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # # Line number to append text (change this to the line number you want)
            # local line_number=7

            # # Create a temporary file
            # tempFile="tempfile"

            # # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            # head -n "$((line_number - 1))" "$file" >"$tempFile"

            # # Append the multi-line string to the temporary file
            # echo -e "$textToAppend" >>"$tempFile"

            # # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            # tail -n "+$line_number" "$file" >>"$tempFile"

            # # Replace the original file with the temporary file
            # mv "$tempFile" "$file"

            #=====USAGE=====#
            appendToTextContentIndex "vite.config.ts" 1 "defineConfig" "$(
                cat <<EOF
            $textToAppend
EOF
            )"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

# ====================HELPER FUNCTIONS==================== #
function replaceLineAfterMatch() {
    #=====USAGE=====#
    # replaceLineAfterMatch "folderName/example.txt" "matchString" "newStringAfterMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceLineAfterMatch \"folderName/example.txt\" \"matchString\" \"newStringAfterMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "/$match/s/$match.*/$match$newString/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content after match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content after match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

function prependToPreviousLineIndex() {
    #=====USAGE=====#
    #     prependToPreviousLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToPreviousLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Insert multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print txt; print; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text inserted after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to insert multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToTextContentIndex() {
    #=====USAGE=====#
    #     appendToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: appendToTextContentIndex <file> <index> <text to match> <text to append>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local appendText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to append text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$appendText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = $i txt;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function createEnv() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName=".env"
    local content=""
    content=$(
        cat <<EOF
# Environment variables declared in this file are automatically made available to Prisma.
# See the documentation for more detail: https://pris.ly/d/prisma-schema#accessing-environment-variables-from-the-schema

# Prisma supports the native connection string format for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB and CockroachDB.
# See the documentation for all the connection string options: https://pris.ly/d/connection-strings

# Supabase
DATABASE_URL="postgresql://postgres:<password>@db.<host>.supabase.co:5432/<database>"

# Local MySQL
# DATABASE_URL="mysql://root:123@localhost:3306/<databasename>"

# Local PostgreSQL
# DATABASE_URL="postgresql://root:123@localhost:5432/<databasename>"

VITE_API_URL="http://localhost:3000/api/v1"

ACCESS_TOKEN_SECRET=
REFRESH_TOKEN_SECRET=
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}
# ====================HELPER FUNCTIONS==================== #

main
```

# =====================================
# Big Bang Vite

```bash
#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="bigbang"

readonly PRODUCTION_DEPENDENCIES=(
    "axios"
    "bootstrap"
    "dotenv"
)

readonly DEV_DEPENDENCIES=(
    "cross-env"
    "dotenv-cli"
    "prettier"
    "styled-components"
    "tailwindcss"
    "ts-node"
    "vite-tsconfig-paths"
    "vitest"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"

function main() {
    echo -e "\e[32mInitializing...\e[0m" &&
        downloadVite &&
        createEnv &&
        deleteFiles "css" &&
        codeToBeRemoved=("import './index.css'" "import './App.css'") &&
        removeTextContent "codeToBeRemoved[@]" &&
        codeToBeRemoved=("import reactLogo from './assets/react.svg'" "import viteLogo from '/vite.svg'") &&
        removeTextContent "codeToBeRemoved[@]" &&
        directories=("components" "helpers" "styles" "tests" "types" "utils") &&
        createDirectories "$PROJECT_DIRECTORY/src" "directories[@]" &&
        removeBoilerplate &&
        installDefaultPackages &&
        installPackages "development" "DEV_DEPENDENCIES[@]" &&
        installPackages "production" "PRODUCTION_DEPENDENCIES[@]" &&

        # ==========CUSTOM SETTINGS========== #
        vite.config.ts__________addBasePath true && # Ensures that assets are imported after building

        # Import shorthand (@)
        addImportShorthand &&

        # Strict mode
        createAppTSX &&
        createPrettierRc &&
        modifyESLintConfig &&
        codeToBeRemoved=(".tsx") &&
        removeTextContent "codeToBeRemoved[@]" &&
        installStrictPackages &&

        # tsconfig.node.json
        addStrictNullChecks &&

        # Testing
        local testPackages=("jest" "@types/jest" "jsdom" "@testing-library/react" "@testing-library/jest-dom") &&
        installPackages "development" "testPackages[@]" &&
        addVitestReference &&
        vite.config.ts__________addTestConfig true &&

        # Express Server
        local serverPackages=("express" "cors") &&
        installPackages "production" "serverPackages[@]" &&
        local serverPackages=("@types/express" "@types/cors" "concurrently" "nodemon" "tsx") &&
        installPackages "development" "serverPackages[@]" &&
        vite.config.ts__________newBuildOutput true &&
        addDevAndStartScripts &&
        editTSConfig &&
        createServerEntryPoint &&
        createComponentWithAPICall &&

        # ==========CUSTOM SETTINGS========== #
        formatCode &&
        echo -e "\e[32mBig Bang was successfully scaffolded.\e[0m"
}

function createServerEntryPoint() {
    cd "$PROJECT_DIRECTORY/src" || return

    local htmlFileName="index.ts"
    local content=""
    content=$(
        cat <<EOF
import express, { Request, Response } from 'express';
import cors from 'cors';
import path from 'path';

const app = express();
const PORT = process.env.PORT || 3000;
const platform: string = process.platform;
let __dirname = path.dirname(decodeURI(new URL(import.meta.url).pathname));

if (platform === 'win32') {
  __dirname = __dirname.substring(1);
}

const publicDirectory = path.join(__dirname, 'public');

// Enable CORS and serve static files
app.use(cors());
app.use(express.static(publicDirectory));

// Define routes
app.get('/', (_req, res) => res.sendFile(publicDirectory));

app.get('/api', (_req: Request, res: Response) =>
  res.json({ message: path.join(publicDirectory, 'index.html') }),
);

// Start server
app.listen(PORT, () => {
  console.log(\`\${platform.charAt(0).toUpperCase() + platform.slice(1)} is running on http://localhost:\${PORT}\`);
});
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

function createComponentWithAPICall() {
    cd "$PROJECT_DIRECTORY/src" || return

    local htmlFileName="App.tsx"
    local content=""
    content=$(
        cat <<EOF
import React, { useEffect } from 'react';

function App(): JSX.Element {
  const [data, setData] = React.useState<{ message: string } | undefined>(
    undefined,
  );

  useEffect(() => {
    fetch('http://localhost:3000/api', {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
    })
      .then((response) => response.json())
      .then((result) => {
        // Success
        if (result) {
          setData(result);
        }
      })
      .catch((error) => {
        // Failure
        throw new Error(error);
      });
  }, []);

  return (
    <div style={{ zoom: '500%', textAlign: 'center' }}>
      <pre>
        <code>{JSON.stringify(data, null, 4)}</code>
      </pre>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

function editTSConfig() {
    cd "$PROJECT_DIRECTORY" || return
    replaceLineAfterMatch "./tsconfig.json" '"noEmit":' "false,"
    replace "tsconfig.json" '"allowImportingTsExtensions": true,' '\/\/ "allowImportingTsExtensions": true,'
    replaceLineAfterMatch "tsconfig.json" '\"compilerOptions\": {' "\\n\/\/ <server>\\n\"baseUrl\": \".\/src\", \"rootDir\": \".\/src\", \"outDir\": \".\/dist\", \"allowSyntheticDefaultImports\": true, \"esModuleInterop\": true,\\n\/\/ <server\/>"
    replaceLineAfterMatch "tsconfig.json" '\"include\": \[\"src\"\],' '\"exclude\": \[\"**\/*.tsx\"\],'
}

function vite.config.ts__________newBuildOutput() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="newBuildOutput"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        build: {
            outDir: 'dist/public',
        },
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # Line number to append text (change this to the line number you want)
            local line_number=8

            # Create a temporary file
            tempFile="tempfile"

            # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            head -n "$((line_number - 1))" "$file" >"$tempFile"

            # Append the multi-line string to the temporary file
            echo -e "$textToAppend" >>"$tempFile"

            # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            tail -n "+$line_number" "$file" >>"$tempFile"

            # Replace the original file with the temporary file
            mv "$tempFile" "$file"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

function addDevAndStartScripts() {
    cd "$PROJECT_DIRECTORY" || return
    appendToTextContentIndex "package.json" 1 "build" '"start": "node dist/index.js",'
    replaceLineAfterMatch "package.json" '"dev":' '"concurrently vite \\\"nodemon --exec tsx src\/index.ts\\\"",'
}

function addImportShorthand() {
    appendToTextContent "$PROJECT_DIRECTORY/tsconfig.json" "\"compilerOptions\": {" "$(
        cat <<EOF
"paths": {
    "@/*": ["./src/*"]
},
EOF
    )" &&
        appendToTextContent "$PROJECT_DIRECTORY/vite.config.ts" "import react from \"@vitejs/plugin-react\";" "$(
            cat <<EOF
import tsconfigPaths from "vite-tsconfig-paths";
EOF
        )" &&
        replace "$PROJECT_DIRECTORY/vite.config.ts" "react()" "react(), tsconfigPaths()"
}

replace() {
    # Usage:
    # replace "folderName/*.txt" "matchString" "replacementString"
    # replace "folderName" "matchString" "replacementString"
    # replace "folderName/example.txt" "matchString" "replacementString"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replace \"folderName/*.txt\" \"matchString\" \"replacementString\""
        echo "       replace \"folderName\" \"matchString\" \"replacementString\""
        echo "       replace \"folderName/example.txt\" \"matchString\" \"replacementString\""
        return 1
    fi

    local path="$1"
    local match="$2"
    local replacement="$3"

    # Replace string in a file
    replace_in_file() {
        sed -i "s/$match/$replacement/g" "$path" &&
            echo -e "\n\e[32mSuccessfully replaced '$match' with '$replacement' in $path.\e[0m" ||
            echo -e "\n\e[31mFailed to replace '$match' in $path.\e[0m"
    }

    # Check if the path is a directory, a file, or a pattern
    if [ -d "$path" ]; then
        # Replace in all files within the directory
        for file in "$path"/*; do
            if [ -f "$file" ]; then
                replace_in_file "$file"
            fi
        done
    elif [ -f "$path" ]; then
        # Replace in a single file
        replace_in_file "$path"
    else
        # Handle as a glob pattern
        shopt -s nullglob
        local files=("$path")
        if [ ${#files[@]} -gt 0 ]; then
            for file in "${files[@]}"; do
                if [ -f "$file" ]; then
                    replace_in_file "$file"
                fi
            done
        else
            echo -e "\n\e[31mNo files found matching the pattern $path.\e[0m\n"
            return 1
        fi
        shopt -u nullglob
    fi
}

appendToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: appendToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local appendText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and append the text
        while IFS= read -r line || [[ -n $line ]]; do
            echo "$line" >>"$tmpfile"
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$appendText" >>"$tmpfile"
            fi
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text appended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function addStrictNullChecks() {
    cd "$PROJECT_DIRECTORY" || return

    replaceLineAfterMatch "tsconfig.node.json" '"compilerOptions": {' ""strictNullChecks": true,"
}

function addVitestReference() {
    cd "$PROJECT_DIRECTORY" || return

    prependToPreviousLineIndex "vite.config.ts" 0 "$(
        cat <<EOF
/// <reference types="vitest" />
EOF
    )"

}

function installStrictPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm add -D \
        @typescript-eslint/eslint-plugin \
        @typescript-eslint/parser \
        eslint \
        eslint-config-prettier \
        eslint-plugin-jsx-a11y \
        eslint-plugin-prettier \
        eslint-plugin-react \
        eslint-plugin-react-hooks \
        eslint-plugin-react-refresh \
        prettier
}

function createAppTSX() {
    cd "$PROJECT_DIRECTORY/src" || return

    local content=""
    local fileName="App.tsx"

    content=$(
        cat <<EOF
import React from 'react';

function App(): JSX.Element {
  const [count, setCount] = React.useState<number>(0);

  return (
    <div style={{zoom: '500%', textAlign: 'center'}}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={(): void => setCount((count: number) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function createPrettierRc() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".prettierrc"

    content=$(
        cat <<EOF
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "trailingComma": "all",
  "jsxBracketSameLine": false,
  "arrowParens": "always",
  "bracketSpacing": true
}
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function modifyESLintConfig() {
    # rm .eslintrc.cjs

    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".eslintrc.cjs"

    content=$(
        cat <<EOF
module.exports = {
  root: true,
  env: {browser: true, es2020: true},
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',

    //
    // 'plugin:@typescript-eslint/strict-type-checked', // Very strict!
    'next/core-web-vitals',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    //
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: [
    'react-refresh',
    //
    'react',
    '@typescript-eslint',
    'react-hooks',
    'jsx-a11y',
    //
  ],
  //
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
  },
  //
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      {allowConstantExport: true},
    ],

    //
    'no-restricted-syntax': [
      'error',
      {
        selector: 'TSEnumDeclaration',
        message: 'Enums are not allowed. Use object literals instead.',
      },
    ],
    'no-alert': ['error'],
    'no-console': ['error'],
    'no-console': ['error', { allow: ['warn', 'error'] }],
    'react/react-in-jsx-scope': 'off',
    // '@typescript-eslint/explicit-function-return-type': 'error',
    '@typescript-eslint/no-unnecessary-boolean-literal-compare': ['error'],
    '@typescript-eslint/no-unused-vars': [
      'error',
      { args: 'all', argsIgnorePattern: '^_' },
    ],
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/strict-boolean-expressions': 'error',
    // complexity: ['error', 10],
    // 'max-depth': ['error', 4],
    // 'max-lines': ['error', 300],
    'react/jsx-props-no-spreading': 'error',
    'react/jsx-filename-extension': [1, {extensions: ['.tsx']}],
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'error',
  },
};
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

function createFile() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName="index.html"
    local content=""
    content=$(
        cat <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

function downloadVite() {
    cd "$ROOT_DIRECTORY" || return

    # Check if the project already exists
    if [ -d "$PROJECT_NAME" ]; then
        rm -rf $PROJECT_NAME
    fi

    pnpm create vite $PROJECT_NAME --template react-ts

    # Check if the file was created successfully
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "\e[32mProject $PROJECT_NAME was successfully scaffolded.\e[0m" # Green
    else
        echo -e "\e[31mProject $PROJECT_NAME failed to scaffold.\e[0m" # Red
    fi
}

function deleteFiles() {
    cd "$PROJECT_DIRECTORY" || return

    local fileExtension="$1"

    while IFS= read -r -d $'\0' file; do
        rm "$file"

        # Check the exit status of the 'rm' command
        if [ $? -eq 0 ]; then
            echo -e "\e[32mThe file $file was deleted successfully.\e[0m" # Green
        else
            echo -e "\e[31mFailed to delete $file.\e[0m" # Red
        fi
    done < <(find $directory -type f -name "*.$fileExtension" -print0)

}

function removeTextContent() {
    cd "$PROJECT_DIRECTORY" || return

    local directory="src"
    local textToRemove=("${!1}")

    local stringToRemove=""
    # Iterate through the array elements and concatenate them
    for value in "${textToRemove[@]}"; do
        stringToRemove="$stringToRemove\|$value"
    done

    # Remove the leading space
    stringToRemove="${stringToRemove# }"

    # Define an empty array to store the filenames
    local fileArray=()

    # Use the find command to search for .tsx files in the chosen directory
    # and append each filename to the array
    while IFS= read -r -d $'\0' file; do
        fileArray+=("$file")
    done < <(find $directory -type f -name "*.tsx" -print0)

    # Print the contents of the array
    for file in "${fileArray[@]}"; do
        local replacement=""

        # Create a temporary file for editing
        local tempFile="tempfile.txt"

        # Use sed to remove the specified string from the file and save the stringToRemove in the temp file
        sed -e "s%\($stringToRemove\)%$replacement%g" "$file" >"$tempFile"
        # Replace the original file with the temp file
        mv "$tempFile" "$file"

        echo -e "\e[32mRemoved unused code from file $file.\e[0m" # Green
    done

}

function removeBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="App.tsx"
    local content=""

    content=$(
        cat <<EOF
import { useState } from "react";

function App() {
  const [count, setCount] = useState(0);

  return (
    <div style={{ zoom: "500%", textAlign: "center" }}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/$fileName" ]; then
        echo -e "\e[32mBoilerplate in $fileName was successfully removed.\e[0m" # Green
    else
        echo -e "\e[31mFailed to remove boilerplate in $fileName.\e[0m" # Red
    fi
}

function createDirectories() {
    cd "$PROJECT_DIRECTORY/src" || return

    local directories=("${!2}")

    for value in "${directories[@]}"; do
        mkdir "$value"
        touch "$value/.gitkeep"

        echo -e "\e[32mFolder \e[33m$value\e[0m was successfully created.\e[0m" # Green

    done

}

function installDefaultPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm install

    echo -e "\e[32mDefault packages were successfully installed.\e[0m" # Green

}

function installPackages() {
    cd "$PROJECT_DIRECTORY" || return

    local packageType="$1"
    local packages=("${!2}")
    local packagesConcatenated=""

    for value in "${packages[@]}"; do
        packagesConcatenated="$packagesConcatenated $value"
    done

    packagesConcatenated="${packagesConcatenated# }"

    if [ "$packageType" == "development" ]; then
        pnpm install -D $packagesConcatenated
    else
        pnpm install $packagesConcatenated
    fi
}

function formatCode() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm prettier --write . --log-level silent

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSuccessfully formatted files.\e[0m" # Green
    else
        echo -e "\e[31mFailed to format files.\e[0m" # Red
    fi

}

function removeSetting() {
    cd "$PROJECT_DIRECTORY" || return

    local settingID="$1"
    local file="vite.config.ts"
    local text=""

    text=$(cat $file)

    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # Find the positions of the delimiters
    local start_pos="${text%%"$startDelimiter"*}"
    local end_pos="${text##*"$endDelimiter"}"

    # Remove the text between the delimiters
    local result="${start_pos}${end_pos}"

    echo "$result" >"$PROJECT_DIRECTORY/$file"
}

function vite.config.ts__________addBasePath() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="basepath"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        base: "./", // Resolve asset paths after building
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # Line number to append text (change this to the line number you want)
            local line_number=6

            # Create a temporary file
            tempFile="tempfile"

            # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            head -n "$((line_number - 1))" "$file" >"$tempFile"

            # Append the multi-line string to the temporary file
            echo -e "$textToAppend" >>"$tempFile"

            # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            tail -n "+$line_number" "$file" >>"$tempFile"

            # Replace the original file with the temporary file
            mv "$tempFile" "$file"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

function vite.config.ts__________addTestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="testConfig"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        test: {
            globals: true,
            environment: 'jsdom',
        },
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # # Line number to append text (change this to the line number you want)
            # local line_number=7

            # # Create a temporary file
            # tempFile="tempfile"

            # # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            # head -n "$((line_number - 1))" "$file" >"$tempFile"

            # # Append the multi-line string to the temporary file
            # echo -e "$textToAppend" >>"$tempFile"

            # # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            # tail -n "+$line_number" "$file" >>"$tempFile"

            # # Replace the original file with the temporary file
            # mv "$tempFile" "$file"

            #=====USAGE=====#
            appendToTextContentIndex "vite.config.ts" 1 "defineConfig" "$(
                cat <<EOF
            $textToAppend
EOF
            )"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

# ====================HELPER FUNCTIONS==================== #
function replaceLineAfterMatch() {
    #=====USAGE=====#
    # replaceLineAfterMatch "folderName/example.txt" "matchString" "newStringAfterMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceLineAfterMatch \"folderName/example.txt\" \"matchString\" \"newStringAfterMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "/$match/s/$match.*/$match$newString/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content after match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content after match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

function prependToPreviousLineIndex() {
    #=====USAGE=====#
    #     prependToPreviousLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToPreviousLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Insert multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print txt; print; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text inserted after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to insert multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToTextContentIndex() {
    #=====USAGE=====#
    #     appendToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: appendToTextContentIndex <file> <index> <text to match> <text to append>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local appendText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to append text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$appendText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = $i txt;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function createEnv() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName=".env"
    local content=""
    content=$(
        cat <<EOF
# Environment variables declared in this file are automatically made available to Prisma.
# See the documentation for more detail: https://pris.ly/d/prisma-schema#accessing-environment-variables-from-the-schema

# Prisma supports the native connection string format for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB and CockroachDB.
# See the documentation for all the connection string options: https://pris.ly/d/connection-strings

# Supabase
# DATABASE_URL="postgresql://postgres:<password>@db.<host>.supabase.co:<port>/<database>"

# Local MySQL
DATABASE_URL="mysql://<username>:<password>@<host>:<port>/<database>"

# Local PostgreSQL
# DATABASE_URL="postgresql://root:123@localhost:5432/bigbang"

VITE_API_URL="http://localhost:3000/api/v1"

ACCESS_TOKEN_SECRET=
REFRESH_TOKEN_SECRET=
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}
# ====================HELPER FUNCTIONS==================== #

main

```

# =====================================
# Big Bang Spring Boot

```bash
#!/bin/bash

curl https://start.spring.io/starter.zip \
    -d type=maven-project \
    -d language=java \
    -d bootVersion=3.2.1 \
    -d baseDir=bigbang \
    -d groupId=com.example \
    -d artifactId=bigbang \
    -d name=BigBang \
    -d description="Demo project for Spring Boot Backend" \
    -d packageName=com.example.bigbang \
    -d packaging=jar \
    -d javaVersion=21 \
    -d dependencies=web,data-jpa,security,devtools,actuator,lombok,validation,postgresql \
    -o bigbang.zip

read -p "Please ENTER to exit..."
```

# =====================================
# Build & Run Java

```bash
#!/bin/bash

# Build java files; run java files;
# find . -name "*.java" -print0 | xargs -0 javac && find . -name "*.class" -exec sh -c 'classname=$(echo "{}" | sed "s|^\./||" | sed "s|\.class$||" | tr "/" "."); if javap -cp . -public "$classname" | grep -q "public static void main(java.lang.String\[])"; then java -cp . "$classname"; exit 0; fi' \;

# Find all Java files and store them in an array
echo "Finding Java files..."
if ! mapfile -t java_files < <(find . -name "*.java"); then
    echo "Failed to find Java files."
    exit 1
fi

# Check if any Java files were found
if [ ${#java_files[@]} -eq 0 ]; then
    echo "No Java files found."
    exit 1
fi

# Compile all Java files
echo "Compiling Java files..."
if ! javac "${java_files[@]}"; then
    echo "Compilation failed."
    exit 1
fi

echo "Compilation successful."

# Assuming your main class is Main and it's not in a package
echo "Running Main class..."
java Main
```

# =====================================
# ChatGPT Prompts

## Convert Instructions to Markdown

```
Convert the text below to markdown.
Detect the programming syntax for the commands and use it in the code block.
Use @@@ instead of ``` for the code block.
Use @@@shellscript for scripting.
Use only # and ## for headings.
Don't remove lines with asterisks (*) as they are additional information.
Put everything in a single block of text for easy copying.
Don't remove any anything from the original text.
Convert some comments into headings. Use ##.
```

## Snippet Helper

```
Convert everything that I paste in this chat into a VS Code snippet.
Always add a comma at the end of the snippet so that I can paste it as is.
Add a scope depending on the programming language.
Treat typescript and javascript as one.
Don't add the programming language (e.g., " (Bash)") at the end of the description.
Add a description.
Use the examples below as your reference:

Expected output for TypeScript/JavaScript:

"Fast For Loop (TypeScript/JavaScript)": {
  "prefix": "forLoop",
  "body": [
    "for (let i = 0, arrayLength = ${1:array.length}; i < arrayLength; i++) {",
    "  // const element = ${2:array}[i];",
    "}"
  ],
  "description": "Logs text straight into the HTML document.",
  "scope": "typescript, javascript, typescriptreact, javascriptreact"
},

Expected output for Shell Script or Bash:

"Shell Script - Check File Existence (Bash)": {
    "prefix": "exists",
    "body": [
        "exists() {",
        "    local fileOrDirectory=\"\"",
        "    [ -e \"$fileOrDirectory\" ]",
        "",
        "    # Usage",
        "    # if exists \".env\"; then",
        "    #     echo -e \"\\e[32mIt exists!\\e[0m\" # Green",
        "    # else",
        "    #     echo -e \"\\e[31mIt doesn't exist!\\e[0m\" # Red",
        "    # fi",
        "}"
    ],
    "description": "Shell Script - Check if a file or directory exists",
    "scope": "shellscript"
},
```

# =====================================
# Coding Conventions & Best Practices

## Dos
- Object Parameter instead of individual arguments for readability

  Don't:
  ```tsx
  function calculateRectangleArea(length: number, width: number): number {
    return length * width;
  }
  
  // Unclear usage; values lack context and purpose
  const area = calculateRectangleArea(5, 10);
  ```
  
  Do:
  ```tsx
  function calculateRectangleArea({ length, width }: { length: number, width: number }): number {
      return length * width;
  }

  // Clear usage; values provide context and purpose
  const area2 = calculateRectangleArea({ length: 5, width: 10 });
  ```

- Self-documenting code: dot notation to reference object values
- Guard clauses or early returns
- Null guards
- IFFEs (Immediately Invoked Function Expression)
- Heredoc, EOF, multi-line strings
- Ternary operators
- Logical operators:

  Nullish coalescing operator (?? or ||): execute "first" if true. Else, fallback to "second"
  ```tsx
  
  console.log("first" || "second");
  
  ```

  Execute "second" if left argument is true
  ```tsx
  
  console.log("first" && "second");
  
  ```
  
  Chaining: assign the first true to the variable
  ```tsx
  
  const x = false || false || "last condition";
  console.log(x); // Will output "last condition"
  
  ```
  
  
- Method chaining or builder pattern
  
  Class:
  ```tsx
  class Calculator {
    private result: number;

    constructor(initialValue: number) {
      this.result = initialValue;
    }

    add(value: number): Calculator {
      this.result += value;
      return this;
    }
    subtract(value: number): Calculator {
      this.result -= value;
      return this;
    }
    multiply(value: number): Calculator {
      this.result *= value;
      return this;
    }
    divide(value: number): Calculator {
      this.result /= value;
      return this;
    }
    getResult(): number {
      return this.result;
    }
  }

  const initialValue = 10;
  console.log(
    new Calculator(initialValue)
      .add(5)
      .multiply(2)
      .subtract(10)
      .divide(5)
      .getResult()
  );

  ```

  Function:
  ```tsx
  const calculator = (initialValue: number) => {
    let result = initialValue;
    
    const builder = {
      add: (value: number) => {
        result += value;
        return builder;
      },
      subtract: (value: number) => {
        result -= value;
        return builder;
      },
      multiply: (value: number) => {
        result *= value;
        return builder;
      },
      divide: (value: number) => {
        result /= value;
        return builder;
      },
      getResult: () => result,
    };
    return builder;
  };

  const initialValue = 10;
  console.log(
    calculator(initialValue).add(5).multiply(2).subtract(10).divide(5).getResult()
  );
  ```
  
  ```tsx
  const modifyString = (initialValue: string) => {
    let result: string = initialValue;

    const builder = {
      get: () => result,
      capitalize: () => {
        result = result.toUpperCase();
        return builder;
      },
      append: (str: string) => {
        result += str;
        return builder;
      },
    };
    return builder;
  };
  console.log(
    modifyString("Hello")
      .capitalize()
      .append(", world")
      .capitalize()
      .append("!")
      .capitalize()
      .get()
  );
  ```

- State logic: see React's useReducer
- Async/await
  
## Don'ts
- Nested ternary
- Global namespace pollution
- Callback hell - use async/await
- If/else hell: avoid nested if/else statements. Keep the code linear


# =====================================
# CSS

```html
/* https://google.github.io/styleguide/htmlcssguide.html */

/* Center an element vertically and horizontally; center an element horizontally and vertically */
/* Center element vertically and horizontally; center element horizontally and vertically */

<!-- WHOLE DOCUMENT CENTERED -->
<body style="display: grid; place-items: center; height: 100vh;">
	<div>Centered Element</div>
</body>

<!-- SCOPED STYLE -->
<div style="display: grid; place-items: center;">
	<div>Centered Element</div>
</div>

//==========INHERIT PARENT WIDTH; DROPDOWN POSITION==========//
.parent {
  position: relative;
}
.child {
  position: absolute;
  width: 100%;
}
//==========INHERIT PARENT WIDTH; DROPDOWN POSITION==========//

//==========CENTER ELEMENT VERTICALLY==========//
/* Shorthand: top, right, bottom, left */
margin: 0% auto 0% auto;

margin-left: auto;
margin-right: auto;
//==========CENTER ELEMENT VERTICALLY==========//

//==========CENTER ELEMENT HORIZONTALLY==========//
/* Shorthand: top, right, bottom, left */
margin: auto 0% auto 0%;

margin-top: auto;
margin-bottom: auto;
//==========CENTER ELEMENT HORIZONTALLY==========//


Center element:
width: 50%;
margin: auto;

Toggle Switch:

CSS:
/*====================Toggle Switch====================*/

HTML:
<label class="switch">
    <input type="checkbox" checked>
    <span class="slider round"></span>
  </label>
  
/*Size*/
.switch {
    zoom: 50%;
}
/*Transition Duration*/
.slider, .slider:before {
	transition: .5s;
}
/*True*/
input:checked + .slider {
  background-color: green;
}
/*True Transition*/
input:checked + .slider:before {
  transform: translateX(26px);
}
/*False*/
.slider {
  background-color: orange;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  cursor: pointer;
  position: absolute;
}
/*Middle Switch*/
.slider:before {
	content: "";
  background-color: white;
  bottom: 4px;
  left: 4px;
  height: 26px;
  width: 26px;
  position: absolute;
}
/*Container*/
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}
/*Middle Switch Radius*/
.slider.round:before {
  border-radius: 50% !important;
}
/*Container Radius*/
.slider.round {
  border-radius: 50px !important;
}
/*====================Toggle Switch====================*/

NEVER USE IDs WHEN STYLING. 

":" and "::" difference:
":" = pseudo-element (hover, active, focus)
"::" = pseudo-selector (first-child, last-child)

Triangle div:
------------------------------------------------------------------------------------
<!DOCTYPE html><html lang="en"><head><title>Blank HTML</title><style>.triangle{zoom:20%;border-color:black;height:0% !important;width:0% !important;border-top:0%;border-bottom:86.6px solid;border-left:50px solid transparent !important;border-right:50px solid transparent !important}</style></head><body><div class="triangle"></div></body></html>
------------------------------------------------------------------------------------

Center the sidebar and main content area along the vertical axis:
html, body {
height: 100%;
}
body {
align-items: center;
}

CSS grid/Display elements side by side:
*See Quickform/home layout

#content {
    display: grid;
    
    /*First element/column is 200px, 2nd element (1fr) takes up the remaining space*/
    grid-template-columns: 200px 1fr;
    
    /*2 columns*/
    grid-template-columns: repeat(2, 1fr);
}

#first {
    height: 100%;
    position: fixed;
}

Element placement:
float: right;

Bootstrap button:
-------------------------
.btn,
.btn:focus {
    color: #62ACED;
    border: 1px solid #62ACED;
    outline: none !important;
    background-color: white;
    transition: all 0.5s ease-in-out;
}
.btn:hover {
    color: white;
    background-color: #62ACED;
}
.btn:active {
    box-shadow: inset 0 5px 20px -2px rgba(0, 0, 0, 0.5);
}

.green,
.green:focus {
    color: #B2BA3A;
    border-color: #B2BA3A;
}
.green:hover {
    color: white;
    background-color: #B2BA3A;
}
-------------------------

-------------------------
Bootstrap modal:
*remove "fade" from class="modal fade" to remove default animation
*target modal backdrop color by ".in" class
*add title bar <div> under "modal-dialog" (before "modal-content") <div>
*modal-dialog overrides: shadow, border-radius

.modal-header {
    text-align: center;
    border-color: #DDDDDD;
}
.modal-content {
    border: none;
    background-color: #EEEEEE;
}
.modal-footer {
    border-color: #DDDDDD;
}
-------------------------

Center div/Custom modal:
------------------------------------------------------------------------------------
<!DOCTYPE html><html lang="en"><head><style>#modal-backdrop,#modal-body{top:50%;left:50%;position:fixed;transform:translate(-50%,-50%)}#modal-backdrop{height:100%;width:100%;background-color:rgba(0,0,0,0.5)}#modal-body{height:400px;width:400px;background-color:red}</style></head><body><div id="modal-backdrop"><div id="modal-body"></div></div></body></html>
------------------------------------------------------------------------------------

Background image:
body {
    background-image: url("http://bit.ly/2eUrF3s");
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center; 
    background-attachment: fixed;
}

Bootstrap button:
.btn {
    border: none;
    transition: all 0.5s;
}

Set general border radius:
* {
  border-radius: 0 !important;
}

Shadow:
element {
    box-shadow: 0px 0px 10px 1px #AAAAAA;
}
"box-shadow": "0px 0px 10px 1px #AAAAAA",

Center Fix Elements:
element {
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}

Center Inline elements (<span>,<a>):
element {
        display: block;
        text-align: center;
}
```

# =====================================
# Custom Fetch API

## Custom Fetch

**customFetch.ts**
```tsx
type DataBody = BodyInit;

const FALLBACK_URL = 'http://localhost:3000/api/v1';

const API_URL: string =
  typeof import.meta.env.API_URL === 'string'
    ? import.meta.env.API_URL
    : FALLBACK_URL;

export interface FetchOptions extends RequestInit {
  timeout?: number;
  body?: DataBody;
}

export type RequestInterceptor = (
  url: string,
  options: FetchOptions,
) => FetchOptions;
export type ResponseInterceptor = (response: Response) => Response;

const defaultOptions: FetchOptions = {
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json, text/plain, */*',
  },
};

const requestInterceptors: RequestInterceptor[] = [];
const responseInterceptors: ResponseInterceptor[] = [];

export const addRequestInterceptor = (
  interceptor: RequestInterceptor,
): void => {
  requestInterceptors.push(interceptor);
};

export const addResponseInterceptor = (
  interceptor: ResponseInterceptor,
): void => {
  responseInterceptors.push(interceptor);
};

const applyRequestInterceptors = (
  url: string,
  options: FetchOptions,
): FetchOptions =>
  requestInterceptors.reduce(
    (acc, interceptor) => interceptor(url, acc),
    options,
  );

const applyResponseInterceptors = (response: Response): Response =>
  responseInterceptors.reduce((acc, interceptor) => interceptor(acc), response);

const determineContentType = (body: DataBody): string => {
  if (body instanceof FormData) {
    return 'multipart/form-data';
  }
  if (typeof body === 'object') {
    return 'application/json';
  }
  return 'text/plain';
};

const customFetchInternal = async <T>(
  url: string,
  options: FetchOptions = {},
): Promise<T> => {
  if (!url || typeof url !== 'string') {
    throw new Error('URL must be a valid string');
  }

  const mergedOptions: FetchOptions = { ...defaultOptions, ...options };

  const finalOptions: FetchOptions = applyRequestInterceptors(
    url,
    mergedOptions,
  );

  // Ensure headers object exists
  if (!finalOptions.headers) {
    finalOptions.headers = {};
  }

  // Now TypeScript knows headers is an object, so we can safely add properties
  if (
    finalOptions.body !== undefined &&
    !(finalOptions.headers as Record<string, string>)['Content-Type']
  ) {
    (finalOptions.headers as Record<string, string>)['Content-Type'] =
      determineContentType(finalOptions.body);
  }

  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), finalOptions.timeout ?? 5000);
  finalOptions.signal = controller.signal;

  try {
    let response: Response = await fetch(`${API_URL}${url}`, finalOptions);
    clearTimeout(id);

    if (!response.ok) {
      throw new Error(
        `There was an HTTP Error with a status code ${response.status}.`,
      );
    }

    response = applyResponseInterceptors(response);
    return await (response.json() as Promise<T>);
  } catch (error) {
    console.error(
      'Error:',
      error instanceof Error ? error.message : String(error),
    );
    throw error;
  }
};

export const customFetch = {
  get: async <T>(params: {
    url: string;
    options?: FetchOptions;
  }): Promise<T> => {
    const { url, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'GET' });
  },
  post: async <T>(params: {
    url: string;
    body: DataBody;
    options?: FetchOptions;
  }): Promise<T> => {
    const { url, body, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'POST', body });
  },
};
```

## Usage Example

**useFetchAPI.ts**
```tsx
import { customFetch } from "./customFetch";

// Example usage of the get method
const readData = async () => {
  try {
    const userData = await customFetch.get({
      url: `http://localhost:3000/api/v1/languages`,
    });
    console.log(userData);
  } catch (error) {
    console.error('Error fetching user data:', error);
  }
};

// Example usage of the post method
const createData = async (userData: {name: string; email: string}) => {
  try {
    const response = await customFetch.post<{success: boolean}>({
      url: `https://api.example.com/users`,
      body: JSON.stringify(userData),
    });
    console.log(response);
  } catch (error) {
    console.error('Error creating user:', error);
  }
};

// Call the functions as needed
readData()
  .catch((error) => {
    if (typeof error === `string`) throw Error(`There was an error: error`);
    if (error instanceof Error)
      throw Error(`There was an error: ${error.message}`);
  })
  .finally(() => {});

createData({name: 'Jane Doe', email: 'jane@example.com'})
  .then(() => {})
  .catch((error) => {
    if (typeof error === `string`) throw Error(`There was an error: error`);
    if (error instanceof Error)
      throw Error(`There was an error: ${error.message}`);
  })
  .finally(() => {});
```

# =====================================
# Dev Environment Setup

```bash
#!/bin/bash

# Initial Setup
sudo apt update

#
apt install -y git curl jq mkcert

# ASDF Installation
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo ". \"$HOME/.asdf/asdf.sh\"" >>~/.bashrc
echo ". \"$HOME/.asdf/completions/asdf.bash\"" >>~/.bashrc

# Node.js Installation
asdf plugin-add nodejs
asdf install nodejs 18.17.0
asdf global nodejs 18.17.0

# SSH Generation
ssh-keygen -t ed25519 -C "igot.judefrancis@seedtech.ph" -f ~/.ssh/jude -P ""

# Run SSH every start
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/jude
echo "eval $(ssh-agent)" >>~/.bashrc
echo "ssh-add ~/.ssh/jude" >>~/.bashrc
# ssh -T git@github.com
```

# =====================================
# Directory Tree Cloner

```bat
:: https://pureinfotech.com/exclude-files-folders-robocopy-windows-10/

@echo off

SET SOURCE="%cd%\A"
SET DESTINATION="%cd%\B"

:: Clone directory including files
:: robocopy %SOURCE% %DESTINATION% /e

:: Clone directory
:: robocopy %SOURCE% %DESTINATION% /e /xf *

:: Exclude folders
:: robocopy %SOURCE% %DESTINATION% /e /xf * /xd folder1* folder2*

:: Exclude a file extension
:: robocopy %SOURCE% %DESTINATION% /e /xf *.json

:: Exclude a filename
:: robocopy %SOURCE% %DESTINATION% /e /xf filename*

:: Copy and paste a file to a directory
:: robocopy %SOURCE% %DESTINATION% copy_this.txt

pause
```

# =====================================
# Docker Commands

## Containerization Steps
1. Build images
2. Create containers from images

## Remove & Rebuild Container and Images
```shellscript
docker stop nginx && docker container rm nginx && docker image rm server-nginx
docker compose up --force-recreate
```

## Delete All Unused Images
```shellscript
docker image prune -a
```

## Re-dockerize Application
```shellscript
docker stop app && docker container rm app && docker image rm custom-image-name
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Custom Container Name)
```shellscript
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Random Container Name)
```shellscript
docker build -t custom-image-name .
docker run -p 3000:3000 --restart=always custom-image-name
```

## Create Container Without Starting; Create Container from an Image
```shellscript
docker container create --name custom-container-name custom-image-name
```

## Dockerize Application (Dockerfile)
```shellscript
docker build -t app .
docker run -p 3000:3000 --restart=always app
```

## Start Container
```shellscript
docker start <container-name>
```

## Rename Container
```shellscript
docker rename old new
```

## Stop Container
```shellscript
docker stop <container-name>
```

## Restart Container
```shellscript
docker restart <container-name>
```

## Update Certificates (Composer Error)
```shellscript
update-ca-certificates
```

## Go to Container's Terminal
```shellscript
docker exec -it <container_name> bash
```

## Build Docker Compose
```shellscript
docker compose up
docker compose build
docker compose up --force-recreate
docker compose build --no-cache
```

## Build Container
* -t to give a docker image a name
* . means the current directory; reference the current directory
```shellscript
docker build -t app .
docker build --no-cache -t app .
```

## Run Docker App/Container
```shellscript
docker run -p 3000:3000 app
```

## Download Image in Docker Hub
```shellscript
docker pull <username>/hello-world
```

## Run Docker Image
```shellscript
docker run hello-world
```

## Show All Running Containers
```shellscript
docker ps
```

## Show All Containers
```shellscript
docker ps -a
```

## Delete Docker Container; Force Delete
* add -f at the end to force delete
```shellscript
docker container rm container-name
```

## Show Docker Images
```shellscript
docker images
```

## Delete Docker Image; Force Delete
* add -f at the end to force delete
```shellscript
docker image rm *first-3-characters-of-the-image-id
```

# =====================================
# Edit Context Menu

## Remove Context Menu Items

Registry Jumper.vbs
```vbs
Set WshShell = CreateObject("WScript.Shell")
Dim JumpToKey
JumpToKey=Inputbox("Enter registry key:")
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Lastkey",JumpToKey,"REG_SZ"
WshShell.Run "regedit", 1,True
Set WshShell = Nothing
```

## Download Registry Jumper

https://drive.google.com/drive/folders/1RJuiTjfTbJYc-3Ty4u3QmaF6S4H3QaAA

## Registries
Double click "(Default)" and add "-" at the beginning of the value

### Default Contex Menu
```
HKEY_CLASSES_ROOT\Directory\Background\shell
```

### Folder Context Menu
```
HKEY_CLASSES_ROOT\Directory\shell
```

### AMD Catalyst Control Center:
```
HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\ACE
```

# =====================================
# TypeScript/JavaScript

## React.js
```tsx
/*
These will not invoke the function on render:
✔️ onClick={functionName}
✔️ onClick={ () => { functionName("value"); } }

//==========TIMER==========//
let timerRef = React.useRef<NodeJS.Timeout>();
React.useEffect(() => {
  clearTimeout(timerRef.current as NodeJS.Timeout);
  timerRef.current = setTimeout(function () {
    // Reset state
    setMessage(``);
  }, 2000);
});
//==========TIMER==========//

This will invoke the function on render:
❌ onClick={functionName("value")}
*/

// Destructure useref; destructure ref; destructure react useref; destructure react ref
const {
  current: { value: message },
} = messageRef;

// Runs only once after the component initially renders
useEffect(() => {
  // Code
}, []);

// Runs on every state change or render
useEffect(() => {
  // Code
});

useEffect(() => {
  // Prevent running on initial render
  if (number !== initialStateValue) {
    console.log("This console log runs after changing number state.");
  }
}, [number]);

// Think of it as a "state listener"
// Runs ONCE after initial rendering
// and after every state or prop change
useEffect(() => {
  // Code
}, [prop, state]);

// Iterate data:
// Iterate an object; iterate an array of objects; iterate array of objects
    {data?.map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an object; iterate object; iterate an object literal; iterate object literal
  const animalsKeys = {
    CAT: "CAT",
    DOG: "DOG",
  } as const;

  const animals: {
    [K in keyof typeof animalsKeys]: string;
  } = {
    [animalsKeys.CAT]: "Felis catus",
    [animalsKeys.DOG]: "Canis lupus familiaris",
  } as const;

  // TSX
  {Object.entries(animals).map(([animalEng, animalLatin]: [string, string], i: number) => (
    <option key={animalEng}>{animalLatin}</option>	
  ))}

  // Raw
  Object.entries(animals).forEach(([animalEng, animalLatin]: [string, string], i: number) => (
    <option key={animalEng}>{animalLatin}</option>	
  ))

// Iterate a number of times
// Loop 5 times
    {[...Array(5)].map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an array
    {["value 1", "value 2", "value 3"].map(({id, firstName}, i) => (
      <div key={id}>{row}</div>
    ))}

// Iterate an array of object using a function
// Usage: <>{GradesItems}</>
    const Items = Data.map(({id, firstName}, i) => (
      <div key={id}>{firstName}</div>
    ));
```

## Jotai
```tsx
import { atom, useAtom } from "@/lib/jotai";

interface Props {
  name: string;
}

const pageAtom = atom<string>("HOME");

export default function App({ name }: Props) {
  const [page, setPage] = useAtom(pageAtom);
  return (
    <>
      Hey, {name}. Current Page: {page}
    </>
  );
}
```

## Common
```tsx
// Pick & Omit to select or remove attributes from object interface/types. Used for reusing interfaces/types

// Copy to clipboard; copy text to clipboard
(async () => {
  try {
    await navigator.clipboard.writeText("Text to copy");
  } catch (error) {
    console.error('Failed to copy text to clipboard:', error);
  }
})().catch(() => {});

//==========FILTER DATA; FILTER OBJECT==========//
const StudentYears = {
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
  };
  
  const schools = {
    schoolA: "School A",
    schoolB: "School B",
    schoolC: "School C",
  } as const;
  
  const Genders = {
    MALE: "MALE",
    FEMALE: "FEMALE",
  } as const;
  
  type Person = {
    schoolType: "all" | (typeof schools)[keyof typeof schools];
    grade: "all" | (typeof StudentYears)[keyof typeof StudentYears];
    gender: "all" | (typeof Genders)[keyof typeof Genders];
  };
  
  const Data: Person[] = [
    { schoolType: schools.schoolA, grade: 1, gender: Genders.MALE },
    { schoolType: schools.schoolB, grade: 2, gender: Genders.FEMALE },
    { schoolType: schools.schoolC, grade: 1, gender: Genders.MALE },
  ];
  
  // User selections
  const schoolType: "all" | Person["schoolType"] = "all";
  const grade: "all" | Person["grade"] = "all";
  const gender: "all" | Person["gender"] = Genders.MALE;
  
  const filteredData = Data.filter(
    (row) =>
      (schoolType === "all" || row.schoolType === schoolType) &&
      (grade === "all" || row.grade === grade) &&
      (gender === "all" || row.gender === gender)
  );
  
  console.log(filteredData);
//==========FILTER DATA; FILTER OBJECT==========//

// Interface keys as type; interface key as type; interface properties as type; interface property as type; interface attributes as type; interface attribute as type
interface Data {
  namae: string;
}
// ...
console.log(row[key as keyof Data]);

//====================CREATE DYNAMIC OBJECT LITERALS====================//
const createObjectLiteral = <T extends string>(
  keys: T[]
): Readonly<Record<T, string>> =>
  Object.freeze(
    keys.reduce((obj, key) => ({ ...obj, [key]: key }), {} as Record<T, T>)
  );

type Page = keyof typeof Pages;
const Pages = createObjectLiteral(["FORM", "CONFIRMATION", "COMPLETED"]);
Pages.FORM = "NEW VALUE"; // This will LITERALLY throw an error
console.log(Pages);
//====================CREATE DYNAMIC OBJECT LITERALS====================//
//====================OBJECT LITERAL EXAMPLE====================//
export const GendersKeys = {
  MALE: "MALE",
  FEMALE: "FEMALE",
} as const;

// Use GenderKeys values for consistency
// Mapped types; object keys as type; object keys as keys; object key as key
export const Genders: { [K in keyof typeof GendersKeys]: string } = {
  [GendersKeys.MALE]: "男子",
  [GendersKeys.FEMALE]: "女子",
} as const;
//====================OBJECT LITERAL EXAMPLE====================//
//====================OBJECT LITERAL SHORTHAND====================//
const keys = ["FORM", "CONFIRMATION", "COMPLETED"] as const;
const Pages = Object.freeze(
  keys.reduce(
    (acc, key) => ({
      ...acc,
      [key]: key,
    }),
    {} as Record<(typeof keys)[number], string>,
  ),
);
Pages.FORM = "NEW VALUE"; // This will LITERALLY throw an error
console.log(Pages.FORM); // Access using dot notation
//====================OBJECT LITERAL SHORTHAND====================//

//====================CONSTANTS; ENUM ALTERNATIVE; OBJECT LITERALS====================//
// Object keys as type; object attributes as type
type Page = keyof typeof Pages;

// Object values as type; object value as type; value as type; use when keys and values differ
// type PageValues = (typeof Pages)[keyof typeof Pages];

const Pages = {
  FORM: "FORM",
  CONFIRMATION: "CONFIRMATION",
  COMPLETED: "COMPLETED",
} as const;

const currentPage: Page = Pages.FORM;

console.log(currentPage);
//====================CONSTANTS; ENUM ALTERNATIVE; OBJECT LITERALS====================//

// Object type parameter; Unknown keys
const functionName = (result: { [key: string]: string }[]) => {
  // Code
}

//====================DYNAMIC KEYS; DYNAMIC OBJECTS; ITERATE OBJECT; LOOP OBJECT====================//
const data = {
  first_name: "John",
  last_name: "Doe",
  birthday: new Date("January 1, 2000"),
};
for (let i = 0, arrayLength = Object.keys(data).length; i < arrayLength; i++) {
  const key = (Object.keys(data) as (keyof typeof data)[])[i];
  const value = data[key];

  console.log(value);
}
//====================DYNAMIC KEYS; DYNAMIC OBJECTS; ITERATE OBJECT; LOOP OBJECT====================//

//====================ASSIGN DYNAMIC KEYS; DYNAMIC OBJECTS====================//
/* Element implicitly has an 'any' type because expression of type 'string' can't be used to index type 'Datatype'.
No index signature with a parameter of type 'string' was found on type 'Datatype'. */

export interface Person {
  first_name: string;
  last_name: string;
  birthday: Date;
  // [key: string]: string | number | Date | undefined; // Uncomment to fix console.log error
  // [index: number]: string | number | Date | undefined; // For assigning dynamic indexes (number)
}

// Usage
const x: Record<string, string> = {
  first_name: "First Name",
  last_name: "Last Name",
  birthday: "Birthday",
};

const data: Person[] = [
  {
    first_name: "John",
    last_name: "Doe",
    birthday: new Date("January 1, 2000"),
  },
];

for (let i = 0, arrayLength = data.length; i < arrayLength; i++) {
  const key: string[] = Object.keys(x);
  const row = data[i];
  console.log(row[key[i]]); // Uncomment "[key: string]: string | number | Date;" in Person interface
}
//====================ASSIGN DYNAMIC KEYS; DYNAMIC OBJECTS====================//

// Omit type; reuse interface; remove interface property; omit interface property
interface SuperUser {
  userId: number;
  macAddress: string;
  username: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  roles: ("Admin" | "Editor" | "Author")[];
}

interface NormalUser extends Omit<SuperUser, "roles" | "username" | "userId"> {}

const normalUser: NormalUser = {
  userId: 1,
  macAddress: "string",
  username: "string",
  email: "string",
  password: "string",
  firstName: "string",
  lastName: "string",
};

// Types:
// Array of objects: rows: [{ [key: string]: string }]

// Form handling; get form data; get form entries; get form values;
onSubmit={(e) => {
  e.preventDefault();
  const formValues = new FormData(e.currentTarget);
  const data = Object.fromEntries(formValues.entries());
  console.log(JSON.stringify(data));
}}

//==========FILTER OBJECTS; FILTER DATA; SEARCH OBJECTS; SEARCH DATA==========//
const people = [
  {
    name: "John Doe",
    gender: "male",
  },
  {
    name: "Jane Doe",
    gender: "female",
  },
];
const males = people.filter((person) => person.gender === "male");

// Filter first result; get first result; filter first object; get first object
const firstMales = people.find((person) => person.gender === "male");
console.log(males);
//==========FILTER OBJECTS; FILTER DATA; SEARCH OBJECTS; SEARCH DATA==========//

// Capitalize first letter of a string
const string = "hello";
const capitalizedFirstLetter = string.alias.charAt(0).toUpperCase() + string.slice(1);

// Get vowel count; get consonant count
const string = "Test";
const vowelsCount = string.match(/[aeiou]/gi)!.length;
const consonantsCount = string.length - vowelsCount;
console.log(vowelsCount);
console.log(consonantsCount);

// Search array for matches; Filter array for matches
const array = ["Cat", "Dog"]; // Haystack
const query = "cat"; // Needle
const matches: string[] = [];

if (query) {
  for (let i = 0, arrayLength = array.length; i < arrayLength; i++) {
    const element = array[i];
    if (element.toUpperCase().match(query.toUpperCase())) {
      matches.push(element);
    }
  }
  console.log(matches);
} else {
  console.log(matches);
}

const promise = (parameter) => {
  return new Promise((resolve, reject) => {
    if (true) {
      resolve({ message: "Success", data: parameter });
    } else {
      reject(new Error(parameter));
    }
  });
};

const anotherPromise = (parameter) => {
  return new Promise((resolve, reject) => {
    if (false) {
      resolve({ message: "Success", data: parameter });
    } else {
      reject(new Error(parameter));
    }
  });
};

// Promise.all for resolving multiple promises
Promise.all([promise("param1"), anotherPromise("param2")]).then((result) => {
  console.log(result[0]); // promise()
  console.log(result[1]); // anotherPromise()
});

// Filter table rows; filter rows; row filter; search table; search rows; search table rows
function filterRows() {
  const searchQuery: string = query.current.value.toUpperCase();

  const rows = document.querySelector("#myTable")!.getElementsByTagName("tr");

  for (let i = 0, arrayLength = rows.length; i < arrayLength; i++) {
    const rowContent = rows[i].textContent || rows[i].innerText;
    if (rowContent.toUpperCase().includes(searchQuery)) {
      rows[i].style.display = "";
    } else {
      rows[i].style.display = "none";
    }
  }
}

//==========SORT OBJECTS; SORT ARRAY OF OBJECTS==========//
const sort = (orderBy: string) => {
  const sortedObject = [
    { id: 4, age: 5, score: 15 },
    { id: 2, age: 5, score: 35 },
    { id: 4, age: 3, score: 45 },
    { id: 1, age: 3, score: 56 },
    { id: 4, age: 9, score: 65 },
    { id: 3, age: 4, score: 23 },
    { id: 4, age: 9, score: 23 },
  ];

  const sortByID = "id"; // 1st priority
  const sortByAge = "age"; // 2nd priority
  const sortByScore = "score"; // 3rd priority

  // const sortByRank = {
  //   key: "id",
  //   orderBy: "asc",
  // };
  // sortedObject.sort((a: any, b: any) => {
  //   return (
  //     (sortByRank.orderBy === "asc" ? 1 : -1) * // Negate result for descending
  //     (a[sortByRank.key] - b[sortByRank.key])
  //   );
  // });

  sortedObject.sort((a: any, b: any) => {
    return (
      (orderBy === "asc" ? 1 : -1) * // Negate result for descending
      (a[sortByID] - b[sortByID] || // Main priority
        a[sortByAge] - b[sortByAge] || // Use another category if the former category values are equal
        a[sortByScore] - b[sortByScore]) // Use another category if the former category values are equal
    );
  });

  return sortedObject;
};
console.log(JSON.stringify(sort("asc"), null, 4));
//==========SORT OBJECTS; SORT ARRAY OF OBJECTS==========//

Format object:
JSON.stringify({ message: "Hello, World!" }, null, 2);

//==========ADD CLASS TO AN ELEMENT==========//
element.classList.add("hidden");

// Usage
Array.prototype.forEach.call(
  document.querySelectorAll(".someClass"),
  function (element, i) {
    element.classList.add("hidden");
  }
);
//==========ADD CLASS TO AN ELEMENT==========//

//==========REMOVE CLASS FROM AN ELEMENT==========//
element.classList.remove("hidden");

// Usage
Array.prototype.forEach.call(
  document.querySelectorAll(".someClass"),
  function (element, i) {
    element.classList.remove("hidden");
  }
);
//==========REMOVE CLASS FROM AN ELEMENT==========//

// Clone object; clone array
const array = [1, 2, 3];
const object = { message: "💩" };
const arrayClone = structuredClone(array);
const objectClone = structuredClone(object);

// Check if value exists in an array; check if value exists in array
if (["string", "number"].includes(typeof value)) {
  console.log(true);
}

//==========TYPE CHECKER==========//
// Datatypes; check datatypes; datatype checker; data types; check what type; check type; typeof

const object = { x: 1 };
const array = [0, 1, 2, 3];
const date = new Date();
const int = 14.0;
const float = 14.14;

const value = float;

// PostgreSQL Prisma
// import { Decimal } from "@prisma/client/runtime/library";
// if (value instanceof Decimal) {
//   rows[key] = parseFloat(value as unknown as string);
//   console.log("Numeric");
// }

// Integer
if (Number(value) === value && value % 1 === 0) {
  console.log("Integer");
}

// Float
if (Number(value) === value && value % 1 !== 0) {
  console.log("Float");
}

// Date/Datetime
if (
  new Date(value) instanceof Date &&
  new Date(value).constructor.name === "Date" &&
  Object.prototype.toString.call(new Date(value)) === "[object Date]" &&
  !isNaN(new Date(value)) &&
  new Date(value).getDate()
) {
  console.log("Date");
}

// Array
if (
  value instanceof Array &&
  Array.isArray(value) &&
  value.constructor.name === "Array"
) {
  console.log("Array");
}

// Object
if (
  value instanceof Object &&
  !Array.isArray(value) &&
  value.constructor.name === "Object"
) {
  console.log("Object");
}
//==========TYPE CHECKER==========//


// Async/await; async await
(async () => {
  try {
    const data: object = await getData();
    return data;
  } catch (error: unknown) {
    if (typeof error === "string") {
      throw new Error(error);
    }
    if (error instanceof Error) {
      throw new Error(error.message);
    }
  }
})();

const asyncFunction = async () => {
  try {
    if (true) {
      const a = await firstPromise();
      const b = await secondPromise(a);
      const c = await thirdPromise(b);
      return c;
    } else {
      throw new Error("Error 1");
    }
    if (false) {
      throw new Error("Error 2");
    }
  } catch (error) {
    return error;
  }
};

//====================CONVERT LOCAL DATETIME TO UTC====================//
const localDatetime = new Date();
const timezoneDifference = Math.abs(localDatetime.getTimezoneOffset()) / 60;
const UTCDatetime = new Date(new Date().setUTCHours(timezoneDifference));
console.log(UTCDatetime);
//====================CONVERT LOCAL DATETIME TO UTC====================//

//====================CONVERT UTC TO LOCAL DATETIME====================//
const UTCDatetime = "2023-02-20 17:07:00";
const localDatetime = new Date(`${UTCDatetime} UTC`);
console.log(localDatetime);
//====================CONVERT UTC TO LOCAL DATETIME====================//

//====================DOWNLOAD FILE====================//
// Download file in javascript (client side):
const fileName = "User Data";
const fileExtension = "csv";

const rows = [
  ["id", "firstName", "lastName"],
  ["1", "Jude", "Igot"],
];

let fileContent = `data:text/${fileExtension};charset=utf-8,`;

switch (fileExtension) {
  case "csv":
    fileContent += rows
      .map((array) =>
        array
          .map((value) => {
            // Escape , and "
            return (value.includes(`"`) || value.includes(`,`)) ? `"${value.replace(/"/g, `""`)}"` : value;
          })
          .join(",")
      )
      .join("\n");
    break;
  default:
    break;
}

const encodedURI = encodeURI(fileContent);
const link = document.createElement("a");
link.setAttribute("href", encodedURI);
link.setAttribute("download", `${fileName}.${fileExtension}`);
document.body.appendChild(link);
link.click();
link.remove();
//====================DOWNLOAD FILE====================//

function recursion(param: number): number {
  // Base Case
  if (param === 10) {
    return param;
  }

  // Recursive Case
  return recursion(param + 1);
}
console.log(recursion(1));

// Get second to the last value of array; Get array element starting from the last element
const array = [1, 2, 3, 4, 5];
console.log(array.at(-2)); // Will output 4

//==========TIMER==========//
// Timer instantiation should be at the top or global level
let timer: NodeJS.Timeout | undefined = undefined;

clearTimeout(timer);
timer = setTimeout(function () {
  // Execute action
}, 1000);
//==========TIMER==========//


//==========ITERATE DATA; ITERATE OBJECT; EXTRACT OBJECT; EXTRACT COLUMN NAMES & EXTRACT ROW VALUES==========//
const columnNames = Object.keys(array[0]);
const rowValues = array.map(row => Object.values(row));

console.log(columnNames);
console.log(rowValues);
//==========ITERATE DATA; ITERATE OBJECT; EXTRACT OBJECT; EXTRACT COLUMN NAMES & EXTRACT ROW VALUES==========//

// Get cookie value
const cookieValue = document.cookie
  .split("; ")
  .find((row) => row.startsWith("cookieName="))
  ?.split("=")[1];

// Check if a query is saved in document cookies
if (cookieValue) {
  console.log(cookieValue);
}

// Set cookie
document.cookie = "cookieName=Cookie Value"

// Select all elements
const allElements = document.getElementsByTagName("*");
for (var i = 0; i < allElements.length; i++) {
  allElements[i].style.color = "green";
}

// Convert array to string (comma-separated):
console.log(array1 + `,` + array2);

// Combine arrays; combine two arrays; combine 2 arrays; merge two arrays;
const mergedArrays = array1.concat(array2);

// Combine arrays; combine two arrays; combine 2 arrays; merge two arrays;
// Manual
const a1 = ["one", "two"];
const a2 = ["three", "four", "five"];
for (let i = 0, initialArray1Length = a1.length; i < a2.length; i++) {
  a1[a1.length - (a1.length - initialArray1Length) + i] = a2[i];
}
console.log(a1);

// Append object to another object:
const object1 = {};
const object2 = {};
for (let i = 0; i < object2.length; i++) {
  object1[object1.length + (i + 1)] = object2[i];
}

// AJAX

const url = new URL("https://example.com");
url.searchParams.append("animals", encodeURIComponent("cat"));
url.searchParams.append("animals", encodeURIComponent("dog"));
url.searchParams.append("person", "John Doe");
console.log(url.searchParams.getAll("animals"));
console.log(url.searchParams.get(decodeURIComponent("person")));
console.log(url);

/*
Output:
[ 'cat', 'dog' ]
John Doe
*/

export const ajax = async (): Promise<object | object[] | undefined> => {
  let data: object | object[] | undefined = undefined;
  try {
    const response = await fetch('https://example.com', {
      // *GET, POST, PATCH, PUT, DELETE
      method: 'GET',
      headers: {
        Accept: 'application/json, text/plain, */*', // Same as axios
        'Content-Type': 'application/json',
      },
      // For POST, PATCH, and PUT requests
      // body: JSON.stringify(formData),
    });
    if (response?.ok) {
      data = response.json();
    } else {
      throw new Error(`HTTP Error`);
    }
  } catch (error: unknown) {
    if (typeof error === `string`) {
      throw new Error(`There was an error: ${error}`);
    }
    if (error instanceof Error) {
      throw new Error(`There was an error: ${error.message}`);
    }
    if (error instanceof SyntaxError) {
      // Unexpected token < in JSON
      throw new Error(`Syntax Error`);
    }
  } finally {
    // Ensure cleanup, even if an exception occurred
  }

  // Success
  if (data) {
    return data;
  }
};

fetch(	
  `https://url.com/api/users`,	

  // prettier-ignore	
  // `https://url.com/api/users`                // GET	
  // `https://url.com/api/users/${resource}`    // GET	

  // `https://url.com/api/users`                // POST	

  // `https://url.com/api/users/${resource}`    // PATCH, PUT, DELETE	
  // `https://url.com/api/users/${resource}`    // PUT	
  // `https://url.com/api/users/${resource}`    // DELETE	
  {	
  // *GET, POST, PATCH, PUT, DELETE	
  method: "GET",	
  headers: {	
    Accept: "application/json",	
    "Content-Type": "application/json",	
  },	
  // For POST, PATCH, and PUT requests	
  // body: JSON.stringify(formData),	
})	
.then((response) => response.json())	
.then((result) => {	
  // Success	
})	
.catch((error) => {	
  // Failure	
  throw new Error(error);	
});

axios
.post("/login", {
  username: username,
  password: password,
})
.then((res) => {
  if (res.status == 200 && res.statusText === "OK") {
    // Success
    const data: { [key: string]: boolean } = res.data;
  }
})
.catch((error) => {
  // Fail
  throw new Error(error);
})
.finally(() => {
  // Finally
});

//========================================//
// Extract paths from tsconfig.json and convert to aliases
import tsconfig from "./tsconfig.json";
const paths: any = tsconfig.compilerOptions.paths;
let aliases: any = {};
for (let i = 0; i < Object.keys(paths).length; i++) {
  const key = Object.keys(paths)[i];

  // Remove / and * from the string
  const alias = key.replace(/\/\*/g, "");
  
  // Webpack.config.js
  const pathToFolder = paths[key][0].replace(/\*/g, "");
  aliases[alias] = path.resolve(__dirname, `${entryFolder}/${pathToFolder}/`);
  
  // Babel.config.js
  // const pathToFolder = paths[key][0].replace(/\*/g, "").slice(0, -1);
  // aliases[alias] = `./src/${pathToFolder}/`;
}

// Add aliases in resolve property in webpack build or in babel config plugins property
const build = {
  resolve: {
    alias: aliases, // Path aliases are extracted from tsconfig.json
  },
};
//========================================//
//========================================//
const string1 = "bad";
const string2 = "badassness";
const string4 = "123badass456";
const string3 = "abc";
const string5 = "ssadab";
const string6 = "bababababadbabasdzx";

//  Without predefined method tests
console.log(withoutPredefinedMethod(string1, string1)); // true
console.log(withoutPredefinedMethod(string1, string2)); // true
console.log(withoutPredefinedMethod(string1, string3)); // false
console.log(withoutPredefinedMethod(string1, string4)); // true
console.log(withoutPredefinedMethod(string1, string5)); // false
console.log(withoutPredefinedMethod(string1, string6)); // true

function withoutPredefinedMethod(needle, haystack) {
  let matchedChars = needle[0] + "";
  for (let i = 0; i < haystack.length; i++) {
    if (needle[0] === haystack[i]) {
      for (let j = 1; j < needle.length; j++) {
        if (needle[j] === haystack[i + j]) {
          matchedChars += haystack[i + j];
        } else {
          matchedChars = needle[0] + "";
          break;
        }
      }
      if (needle === matchedChars) {
        return true;
      }
    }
  }
  return false;
}

//========================================//

// Question #1: 3 + 3 = 6 minutes
// Question #2: 10 + 33 = 33 minutes
// Question #3: 30 + 15 + 18 + 8 + 40 = (111 min) 1 hour and 51 minutes
// Question #4: 15 + 35 + 5 = 55 minutes
// Question #5: 35 minutes
// Total = (240 min) 4 hours

console.log("Question #1: Reverse String\n");
const reverseString = (string) => {
  return string.split(" ").reverse().join(" ");
};

console.log(reverseString("This is Valhalla"));
console.log("\n"); //========================================//

console.log("Question #2: Get Highest and Lowest Numbers\n");
const getHighestAndLowest = (numbers) => {
  let lowest = numbers[0];
  let highest = numbers[0];
  for (let i = 0; i < numbers.length; i++) {
    const currentNum = numbers[i];
    if (currentNum < lowest) {
      lowest = currentNum;
    }
    if (currentNum > highest) {
      highest = currentNum;
    }
  }
  return {
    highest: highest,
    lowest: lowest,
  };
};
const result = getHighestAndLowest([34, 7, 23, 32, 5, 62, -1]);
console.log(`Highest: ${result.highest}\nLowest: ${result.lowest}`);
console.log("\n");
//========================================//

console.log("Question #3: Sort Array of Numbers\n");
const sortArray = (numbers) => {
  for (let i = 0; i < numbers.length; i++) {
    const currentElement = numbers[i];
    const nextElement = numbers[i + 1];
    if (currentElement > nextElement) {
      numbers[i] = nextElement;
      numbers[i + 1] = currentElement;
      sortArray(numbers);
    }
  }
  return numbers;
};
const sortedArray = sortArray([34, 7, 23, 32, 5, 62]);
console.log(sortedArray);
console.log("\n");
//========================================//

console.log("Question #4: Get First Recurring Character\n");
function getFirstRecurringCharacter(string) {
  const stringChars = [];
  for (let i = 0; i < string.length; i++) {
    const char = string[i];
    stringChars.push(char);
  }
  var set = new Set();
  return stringChars.find((v) => set.has(v) || !set.add(v)) || null;
}
console.log(getFirstRecurringCharacter("ABCA"));
console.log(getFirstRecurringCharacter("CABDBA"));
console.log(getFirstRecurringCharacter("CBAD"));
console.log("\n");
//========================================//

console.log("Question #5: Find Addends That Equal To 8\n");
const isEqualToEight = (numbers) => {
  if (numbers.length !== 0) {
    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[0];
      const nextNum = numbers[i + 1];
      if (nextNum !== undefined) {
        if (num + nextNum == 8) {
          return true;
        }
      }
    }
    numbers.shift();
    return isEqualToEight(numbers);
  }
  return false;
};
console.log(isEqualToEight([1, 2, 3, 4]));
console.log(isEqualToEight([4, 2, 4, 1]));
console.log(isEqualToEight([7, 2, 4, 6, 7]));


//====================FIND A WORD IN A STRING====================//
const string1 = "bad";
const string2 = "badassness";
const string4 = "123badass456";
const string3 = "abc";
const string5 = "ssadab";
const string6 = "bababababadbabasdzx";

//  Without predefined method tests
console.log(withoutPredefinedMethod(string1, string1)); // true
console.log(withoutPredefinedMethod(string1, string2)); // true
console.log(withoutPredefinedMethod(string1, string3)); // false
console.log(withoutPredefinedMethod(string1, string4)); // true
console.log(withoutPredefinedMethod(string1, string5)); // false
console.log(withoutPredefinedMethod(string1, string6)); // true

function withoutPredefinedMethod(needle, haystack) {
  let matchedChars = needle[0] + "";
  for (let i = 0; i < haystack.length; i++) {
    if (needle[0] === haystack[i]) {
      for (let j = 1; j < needle.length; j++) {
        if (needle[j] === haystack[i + j]) {
          matchedChars += haystack[i + j];
        } else {
          matchedChars = needle[0] + "";
          break;
        }
      }
      if (needle === matchedChars) {
        return true;
      }
    }
  }
  return false;
}

//====================FIND A WORD IN A STRING====================//

// Get element using attribute
document.querySelectorAll(`input[name=paymentid]`)[0].value

// Bookmarklet - run javascript on a page
javascript: alert("Hello, World!");

javascript: (function () {
  alert("Hello, World!");
})();

javascript: (function () {
  var name = prompt("Please enter your name", "John Doe");
  if (name) {
    alert(name);
  }
})();

// Prompt; pop up; popup; javascript text input; javascript input
var name = prompt("Please enter your name", "John Doe");
if (name) {
  alert(name);
}

//====================FORWARD TRAVERSAL====================//

const parentDiv = document.querySelectorAll(`div[class=container]`)[0];

// Get the children element using the parent element; get children element using parent element; select the children element using the parent element; select children element using parent element
const child = parentDiv.querySelector("a"); // Select anchor child <a></a>

const grandparent = document.querySelector(".grandparent");

const parents = Array.from(grandparent.children); // Stores elements into an array; with this, you don't need a loop

const parentOne = parents[0];

const children = parentOne.children;

// Children skipping (grandparent to grandchildren)

const grandChildOne = grandparent.querySelector(".child");

const grandChildren = grandparent.querySelectorAll(".child");

// Form; get elements by type; get form input elements; ; get form input names; get input names
const formNode = document.querySelectorAll("form");
const inputs = formNode?.querySelectorAll("input");
const inputIDs: string[] = [];
if (inputs?.length) {
  for (let i = 0, arrayLength = inputs.length; i < arrayLength; i += 1) {
    const input = inputs[i];
    const id = input.getAttribute("id");
    if (typeof id === "string") {
      inputIDs.push(id);
    }
  }
}

//====================BACKWARD TRAVERSAL====================//

const grandChildOne = grandparent.querySelector("#childOne");

const parent = grandChildOne.parentElement;

// Parent skipping (grandchildren to grandparent)

const grandParent = grandChildOne.closest(".grandparent");

//====================SIDE-BY-SIDE TRAVERSAL====================//

const childOne = document.querySelector("#childeOne");

const childTwo = childOne.nextElementSibling;

const childOne = childTwo.previousElementSibling;

// Select element by a specific attribute value
var element = document.querySelector(
  `[class="fome6x0j tkqzz1yd aodizinl fjf4s8hc f7vcsfb0"]`
);

// Get keydowns:
document.addEventListener("keydown", function (e) {
    alert(e.key);
});

// Document onload:
document.addEventListener("DOMContentLoaded", function (e) {
    alert("Hello, world!");
});

window.onload = function () {
    alert("Hello, world!");
};
window.onload = () => {
    alert("Hello, world!");
};

// Multiple elements in a single event listener:
['element1', 'element2'].forEach(function (element) {
    document.querySelector(`#${element}`).addEventListener("click", function () {
        alert("Hello, world!");
    });
});

// Multiple event listeners in a single element:
['keyup', 'change', 'paste'].forEach(function (event) {
    document.querySelector(`#element`).addEventListener(event, functionName, false);
});

// Event listener:
document.querySelector("#id").addEventListener("click", functionName);
document.querySelector("#id").addEventListener("click", function (e) {
    alert("Hello, world!");
});

// Loop each element:
Array.prototype.forEach.call(document.querySelectorAll("tbody tr"), function (element, i) {
});

Array.prototype.forEach.call(document.querySelectorAll(".class-name"), function (element, i) {
    alert(element.getAttribute("value"));
});

// Get Element by XPath:
function getElementByXPath(path) {
    return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
const element = getElementByXPath(`//html[1]/body[1]/div[1]`);
element.remove();

// Add commas to numbers:
string = string.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

// Confirmation box:
if (confirm("Are you sure you want to delete this?")) {
    alert("Deleted.");
} else {
    alert("Cancelled.");
}

// Parse / Parse / Run javascript string:
eval("alert('Hello, world!')");

// JSON HTML attribute:
dataJson = '[{"integer":1,"string":"value","nullSample":null},{"integer":1,"string":"value","object":{"options":["option1","option2"]}}]'

// Reload current page:
window.location.reload();

// HTTP redirect to a page:
window.location.replace("home.php");

// Replace string:
string.replace(/blue/g, "red");

// Replace URL:
window.history.replaceState({}, "", "urlString");

// Add page changes to history / back button:
window.history.replaceState({}, "", "urlString");

// Play audio:
// ------------------------------------------------------------------------------------
custom_playAudio("sound.wav");

function custom_playAudio(source) {
    var sound = new Audio(source).play();
    if (sound !== undefined) {
        sound.then(_ => {
        }).catch(error => {
        });
    }
}
// ------------------------------------------------------------------------------------

// Simulate link click event:
window.location.href = "home.php";

// Filter HTML / special characters:
var rawValue = $("#oldOptions").find("input").eq(i).val();
var regex = /<|>|"|'|&/gi;
//var regex = /&lt;|&gt;|&quot;|&#039;|&amp;/gi;
var newValue = rawValue.replace(regex, function (char) {
    var specialCharacters = {
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;",
        "&": "&amp;",
        "&lt;": "<",
        "&gt;": ">",
        "&quot;": "\"",
        "&#039;": "'",
        "&amp;": "&"
    };
    return specialCharacters[char];
});
alert(newValue);

jQuery Conditions:

Detect Filled/Not Empty Input:
if ($("#element").replace(/\s/g, '').length !== 0) {
}

Filter Space/Detect Blank Input:
if (!$("#element").val().replace(/\s/g, '').length) {
}

Detect Focusout:
if ($("#element").is(":focus") === false) {
}

// Remove part of a string:
"Hello, world!".replace(", world", ""); // Result is "Hello!"

// Animation Functions:
// easings.net
$("element").hide("drop", { direction: "up" }, 100, function () {
});

// Set IDs for children elements:
$("#editTextFieldFields").find("[id]").each(function () {
    if (this.id.match(".*\\d.*")) {
        if (this.id.replace(/\D/g, '') !== gfm_editField) {
            this.id = this.id.slice(0, -1);
            this.id = this.id + gfm_editField;
        }
    } else {
        this.id = this.id + gfm_editField;
    }
});

// Document onload:
$(function () {
});

// Detect input element changes:
$(document).on("input", "input", function (e) {
});

// Custom events:
$(document).on("customEvent", function () {
});
$(document).trigger("customEvent");
// --------
$(document).on("customEvent", {
    name: "Jude"
}, function (e, var1, var2) {
    alert(e.data.name + " " + var1 + " " + var2);
});
$(document).trigger("customEvent", ["Francis", "Igot"]);

// Generate random value from array:
var color = ["red", "green", "blue"];
alert(color[Math.floor(Math.random() * color.length)]);
var position = ["left", "right"][Math.floor(Math.random() * ["left", "right"].length)]

// Notify.js:
$.notify("Notify.js", {
    position: "top center",
    className: "success"
});

// Toggle animation:
// See jQuery toggle effects
$("#element").toggle("drop", {
    direction: "right"
}, 1000);

// Check element visibility:
!$("#element").is(":visible") ? $("#element").show(100) : $("#element").hide(100);
if ($("#element").is(":visible")) {
}

// Select specific attribute from all children elements:
$("#parent").find("[id]").each(function () {
    alert(this.id);
});

// Check if array contains value:
// returns the index of the matched value in the array. 
// returns "-1" if no matches found
["1", "2", "3"].indexOf("2"); // returns "1" since "2" is in [1]

// Check if a string contains any number:
if ("abcde1".match(".*\\d.*")) {
}

// Count immediate child elements:
$("#parent >").length
// Specific Element:
$("#parent > div").length

// Find parent element:
$(this).parents().find("[data-sample]").attr("data-value")

// Target Closest / Parent Element:
$(this).closest("div").remove();

// Target child element:
$("#parent").children("div").attr("class");

// Detect if element is not focused:
if ($(".edit-box, .edit-fee").is(":focus") === false) {
}

// Mouse click:
$(document).on("click", "#element", function (e) {
});

// Whole page mouse click:
$(document).on("click", function (e) {
});

// Exclude an element from an event:
$(document).on("click", "#element1:not(#element2)", function (e) {
});

// Keyboard: (Use keyup when checking for field values; see mcci registration add attendee)

// Keyboard combinations:
$(document).on("keydown", function (e) {
    var key = { a: 65, b: 66, c: 67, d: 68, e: 69, f: 70, g: 71, h: 72, i: 73, j: 74, k: 75, l: 76, m: 77, n: 78, o: 79, p: 80, q: 81, r: 82, s: 83, t: 84, u: 85, v: 86, w: 87, x: 88, y: 89, z: 90 };
    if (e.ctrlKey && e.shiftKey && e.altKey && e.keyCode === key.z) {
        e.preventDefault();
        alert("Ctrl + Shift + Alt + Z");
    }
});

$(document).on("keydown", "#element", function (e) {
    // Enter key
    if (e.keyCode === 13) {
    }
});

// Disable Context Menu / Right Click:
$(document).on("contextmenu", function (e) {
    return false;
});

// Get Get variable:
alert(location.href.substr(location.href.lastIndexOf('/') + 1));

// Focus on an Element / Field:
$("#element").focus();

// Load a Page on an Element:
$("#target").load("url.php");

// Target Current Element / Get Element Attribute:
$(this).attr("class");

// Add Attributes to an Element:
$("#element").attr("placeholder", "some place holder");

// Show Modal:
$("#myModal").modal("show");
$("#myModal").modal({ backdrop: 'static' });

// Hide Modal:
$("#myModal").modal("hide");

// CSS
$("#element").css({ "color": "red" });

// Set Interval:
setInterval(function () {
}, 1000);

// Set timeout:
setTimeout(function () {
}, 1000);

// Ajax:
$.ajax({
    url: "url.php",
    type: "POST",
    dataType: "json",
    data: {
        read: "getData",
        data: {
            email: "example@gmail.com",
            password: "123"
        }
    }
}).done(function (result) {
    // Parse AJAX database result:
    var data = JSON.parse(result);
}).fail(function (error) {
});


// Date format; Time format
const date = new Date(dataUpdatedAt);

const dayOfTheWeek = date.getDay();
const year = date.getFullYear();
const day = date.getDate();
const month = date.toLocaleString("default", {
  month: "long",
});

const time = new Date(dataUpdatedAt).toLocaleString("en-US", {
  // year: "numeric",
  // month: "numeric",
  // day: "numeric",
  hour: "numeric",
  minute: "numeric",
  second: "numeric",
  hour12: true,
});

console.log(`${month} ${day}, ${year} at ${time}`);

// See: spread syntax, object mutation

// Destructuring nested objects; double destructuring; destructure nested objects
const { data: { username } }: any = await graphql({ schema: gql(schema), source: query, rootValue });
console.log(username);

//==========CHANGE VALUES MULTIPLE OBJECTS==========//
 interface Person {
  firstName: string;
  age?: number;
  active: boolean;
}
const data: Person[] = [
  {
    firstName: "John Doe",
    active: true,
  },
  {
    firstName: "Jane Doe",
    active: true,
  },
];
const editedRows = data.map((row: Person) => {
  delete row.age;
  row.active = false;
  return row;
});
//==========CHANGE VALUES MULTIPLE OBJECTS==========//

//==========CHANGE VALUES OF AN OBJECT==========//
// Version 1
const object = {
  firstName: "John Doe",
  active: true,
};
const newValues = {
  active: false,
};
const mutatedObject = { ...object, ...newValues };

// Version 2
const object = {
  firstName: "John Doe",
  active: true,
};
const mutatedObject = { ...object };
mutatedObject.active = false;

/* New value
{
  firstName: "John Doe",
  active: false,
}
*/
//==========CHANGE VALUES OF AN OBJECT==========//

// Destructure; destructuring; shorthand; shortcut; destructure object

// Access object values without initializing a variable
const { name } = {name: "John Doe"};
console.log(name);

// Renaming keys
const { name: fullName } = {name: "John Doe"};
console.log(fullName);


//=====FUNCTIONS=====//
// Functions - this syntax allows you to use functions before they are declared
functionName(); // Calling a function before its declaration
function functionName(){
  // Code here
}
//=====FUNCTIONS=====//

const functionName = () => {
  // Code here
};

const functionName = () => console.log("One-liner function");

//====================//
// Override object; combine object properties; object mutation; mutate object; add property to object; add attribute to object
// Change object property; modify object property; change object attribute; modify object attribute
const originalObject = {
  a: "1",
  b: "2",
  c: "3", // This property will be overridden by mutation's c: property
};
const mutation = {
  c: "new value",
  d: "4",
};
const mutatedObject = { ...originalObject, ...mutation };
console.log(mutatedObject);
//====================//

//==========MUTATE NESTED OBJECTS==========//
const originalObject = {
  a: "1",
  b: "2",
  c: {
    d: "3",
    e: "4",
  },
};
const mutation = {
  c: {
    ...originalObject.c,
    e: "new value",
  },
};
const mutatedObject = { ...originalObject, ...mutation };
console.log(mutatedObject);
//==========MUTATE NESTED OBJECTS==========//


// Extract keys from an object; Extract properties from an object
let { firstName: firstName, lastName: lastName } = person;

// Exclude keys from an object; Exclude properties from an object; filter an object; remove object property; remove object key; mutate object; exclude object key; exclude object property
let { removeThis, removeThisAsWell, ...newObject } = originalObject;
```

# =====================================
# React.js Learning Roadmap

```
React.js:

Front end topics:
Component
Component nesting
States
Props

use cases:
access children states (quickform form maker when clicking submit)

steps:
high level overview
core principles

What i did:
read latest book
watched tutorials
watched talk on react:
	understand the abstractions of a framework/library
Watched conferences on react


react learning curve:
core principles:
	declarative programming
		imperative - driving on your own; telling car how to drive
		declarative - riding a taxi; driver does the imperative work
	composition
		create components and make them work together
		component heirarchy
	data flow
		parent to child - unidirectional data flow; top to bottom

_____
functional components - component inside a component; modular components
props - pass in arguments to a react components

Functional. Components 

- Props 
- Events 

- onClick
- onBIur 
- onChange 

- Hooks 
- useState 


useMemo - cache unchanged values to avoid unnecessary rerenders; useful when running a slow function
	- returns value from the function
	
useCallback = same as useMemo, but returns the callback/function instead of a return value
	- returns the callback (the whole function)
	
*see difference between useMemo and useCallback (https://youtu.be/_AyFP5s69N4?t=285)
	
useEffect - asynchronous; "state listener"
useLayoutEffect - synchronous version of the useEffect
useRef - used to get the value from input fields
useReducer - used when changing multiple states between multiple actions/conditions (e.g.: default, succes, error)
	- useful for login systems (https://youtu.be/o-nCM1857AQ)
	- grouping actions together for cleaner code
	- inspired by redux
useContext - global data/state listener; manage state globally
	- solves the props drilling problem: when you have to pass down props from parents to children

-----------
React best practices:
Component lifecycle
dynamic component insertion

Difference between main react library and react-dom
the main react library only takes care of the diffing. It doesn't know that youre generating HTML
react is compatible with any DOM insertion tool (https://youtu.be/i793Qm6kv3U?t=1455)
the element insertion to the DOM is handled by react DOM

use custom hooks to fetch data

always add a unique key (id) to elements (e.g. lists, comments, etc.)
use uuid to generate unique random keys

components must be functional components (class components is old)

props/proponents - data that can be used by the componen (e.g. names)

Hot module replacement:
if (module.hot) {
	module.hot.accept();
}

function vs arrow functions, optional return statement

super(props) - to ensure that the React. Component 's constructor() function gets called
			 - put in every constructor
			 - When having a constructor in your ES6 class component, it is mandatory to call super();

constructor - initial state of the component

use function useState to avoid constructors

named exports vs default exports

const [stateGetter, stateSetter] = React.useState(state);			 
use stateSetter when changing state
setState has a callback function

useEffect - a component can have multiple useEffects for isolation
		  - runs after the initial render
		  - runs after every update
		  - runs on every state change???
		  - subscribe and unsubscribe (return a function inside useEffect to unsubscribe/cleanup listeners)
		  - "state listener"; runs when you want to execute code after a state changes

		  
https://www.youtube.com/watch?v=dpw9EHDh2bM&ab_channel=ReactConf
		  
custom hooks - should start with the word "use"	(e.g. useWindowWidth) for convention
			 - declare custom hooks below the component
			 
Lazy loading
Concurrent mode
Defer

Avoid:
Wrapper hell

Don'ts:
Don't modify a state variable directly. Create a copy before modifying it, then use that copy to set the new state

Iterate data in a component:
render() {
return (
<div className="App">
{list.map(function(item) {
return <div>{item.title}</div>;
})}
</div>
);
}

Syntax:
event listeners must be inline
JSX
const - immutable; cannot be changed
let - normal variable; can be changed; alternative to var
using
Use const whenever you can
conditional rendering
css should be camel case
```



# =====================================
# File Handling Cheat Sheet

File Handling CheatSheet.ts
```tsx
import fs from "fs";
import path from "path";

// Read file contents
const fileContents = fs.readFileSync(path.resolve(__dirname, `package.json`));

// Create a file; create file; Write a file; Write file
let fileName: string = "filename.txt";
fs.writeFile(fileName, fileContents, (error) => {
  if (error) return console.log(error);
});

// Check if a directory exists
const folderName = "foldername2";
if (fs.existsSync(folderName)) {
  console.log("The path exists.");
} else {
  // Create a folder in the current directory; create folder; create a directory
  fs.mkdir(folderName, (error) => {
    if (error) return console.log(error);
  });
}

// Delete a folder recursively; delete a directory recursively
fs.rmSync("filename.json", { recursive: true, force: true });

// Copy file
const fileClone = "filename.json";
fs.copyFile("package.json", fileClone, (error) => {
  if (error) return console.log(error);
});

// Check if file exists; Check if a file exists
if (fs.existsSync("filename.txt")) {
  console.log("The file exists.");

  // Delete file; delete a file
  fs.rm("filename.json", (error) => {
    if (error) console.log(error);
  });
}

// Filter certain types
const jsonFiles: string[] = [];

// Loop all files in current directory; Get all files in current directory; Get all files in a directory
fs.readdirSync(path.resolve(__dirname, ``)).map((fileName) => {
  //==========FILTER FILE TYPES==========//
  let targetFileType = "json";

  // Extract filename
  const fileNameWithoutExtension = fileName.substring(
    0,
    fileName.length - targetFileType.length - 1
  );

  // Get file extension; extract file extension
  const fileExtension = fileName.split(".").pop();

  if (fileExtension!.includes(targetFileType)) {
    jsonFiles.push(fileName);
  }
  //==========FILTER FILE TYPES==========//
     javascriptFiles.push(`${file}`);
});
console.log(jsonFiles);

exists "file name or folder name"

Create:
createFile "example.txt" "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog."
createFolder "folderName"
getFileContents "directory or file name"

// Should append or prepend to multiple lines e.b. if there are multiple "src: {", then append or prepend to all "src: {" 
appendToTextContent "example.txt" "text to append" "text to match"
prependToTextContent "example.txt" "text to prepend" "text to match"

// Only append or prepend to the nth match e.g. if there are multiple "src: {", only append or prepend to the 2nd "src: {"

// This should append to the first text that matches "fox":
appendToTextContentIndex "example.txt" 0 "src: {"

// This should prepend to the second text that matches "fox":
prependToTextContentIndex "example.txt" 2 "src: {"

appendToNextLine "example.txt" 5 "text to append"
prependToPreviousLine "example.txt" 2 "text to append"

appendToFile "example.txt" "this text should append to the last character of the last line of file"
prependToFile "example.txt" "this text should prepend to the first character of the first line"

appendToLine "example.txt" 5 "this text should append to the last character of the 5th line"
prependToLine "example.txt" 5 "this text should prepend to the last character of the 5th line"

appendToNextLine "example.txt" 5 "this should be appended to the next line"
prependToNextLine "example.txt" 2 "this should be prepended to the previous line"

// The end parameter should be optional
removeLines(start, end?) "example.txt" 2 3

replaceTextBetweenLines(start, end) "example.txt" 2 3
replaceText "example.txt" 2 3
replaceTextUsingDelimeters "example.txt" 2 3
getContentsByDelimeter "example.txt" "<start>" "</end>"
            
// This should return an array with the file names and their contents
getFileInfo("directoryName")

getFileNames("directoryName")

getFilesByExtension(["html", "js"])

copyPasteFileOrFolder()
replaceLineAfterMatch() // for changing variable values e.g. .env values
replaceLineBeforeMatch() // for changing variable values e.g. .env values
replace
duplicateFileOrFolder()
moveFileOrFolder(source, destination)

// Returns the text content between lines. 1 is the starting line, 2 is the end line. The end parameter should be optional
getLineContents 1, 2

// Returns the starting and endline line of a multi-line text
getLineRangeByTextContent "example.txt" "text content"

Read:

Update:

Delete:
```

# =====================================
# File Handling Scripts

File Handling Scripts.sh

```bash
#!/bin/bash

# accept nested directory and filename e.g. foldername/example.txt
# accept multi-line text
# use zero-based indexing for line numbers
# include expected output after running the function
# preserve line breaks
# produce errors if delimeters are not found
# include directory as first parameter

function main() {
    echo -e "\e[32mHello, World!\e[0m" # Green
}

function editJSON() {
    # editJSON "$PROJECT_DIRECTORY/package.json" "prepend" "scripts" "prepended" "newPropertyValue" &&
    # editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "appended" "newPropertyValue"

    local filename="$1"
    local action="$2" # "prepend" or "append"
    local key="$3"
    local property="$4"
    local value="$5"
    local tempFile="${filename}.tmp"

    # Use awk to process the file
    awk -v action="$action" -v key="$key" -v prop="$property" -v val="$value" '
    BEGIN { foundKey=0; propertyExists=0; }
    {
        if ($0 ~ "\"" key "\": {") {
            foundKey=1;
            print $0;
            next;
        }
        if (foundKey && $0 ~ "\"" prop "\":") {
            propertyExists=1;
        }
        if (foundKey && $0 ~ /}/) {
            if (action == "append" && !propertyExists) {
                print "    ,\"" prop "\": \"" val "\"";
            }
            foundKey=0;
            propertyExists=0;  # Reset for next key if any
        }
        if (action == "prepend" && foundKey && !propertyExists) {
            print "    \"" prop "\": \"" val "\",";
            propertyExists=1;  # Prevent further prepend
        }
        print $0;
    }' "$filename" >"$tempFile" && mv "$tempFile" "$filename"
}

function replace() {
    # Usage:
    # replace "folderName/*.txt" "matchString" "replacementString"
    # replace "folderName" "matchString" "replacementString"
    # replace "folderName/example.txt" "matchString" "replacementString"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replace \"path/pattern\" \"matchString\" \"xxxxxxxxxx\""
        return 1
    fi

    local path="$1"
    local match="$2"
    local replacement="$3"

    # Function to escape special characters for sed
    function escape_for_sed() {
        echo "$1" | sed -e 's/[]\/$*.^|[]/\\&/g'
    }

    local escaped_match=$(escape_for_sed "$match")
    local escaped_replacement=$(escape_for_sed "$replacement")

    # Replace string in files
    function replace_in_file() {
        local file=$1
        sed -i "s/$escaped_match/$escaped_replacement/g" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced '$match' with '$replacement' in $file.\e[0m" ||
            echo -e "\n\e[31mFailed to replace '$match' in $file.\e[0m"
    }

    # Handle different path inputs
    if [ -d "$path" ]; then
        # Directory: Replace in all files within the directory
        for file in "$path"/*; do
            [ -f "$file" ] && replace_in_file "$file"
        done
    elif [ -f "$path" ]; then
        # Single file
        replace_in_file "$path"
    else
        # Pattern
        for file in $path; do
            [ -f "$file" ] && replace_in_file "$file"
        done
    fi
}

function replaceTextAfterMatch() {
    #=====USAGE=====#
    # replaceTextAfterMatch "folderName/example.txt" "matchString" "newStringAfterMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceTextAfterMatch \"folderName/example.txt\" \"matchString\" \"newStringAfterMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "/$match/s/$match.*/$match$newString/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content after match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content after match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

function replaceLineBeforeMatch() {
    #=====USAGE=====#
    # replaceLineBeforeMatch "folderName/example.txt" "matchString" "newStringBeforeMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceLineBeforeMatch \"folderName/example.txt\" \"matchString\" \"newStringBeforeMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "s/^.*$match/$newString$match/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content before match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content before match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

function copyPasteFileOrFolder() {
    #=====USAGE=====#
    # copyPasteFileOrFolder "example.txt" "copied.txt"
    # copyPasteFileOrFolder "folder/example.txt" "anotherFolder/copied.txt"
    # copyPasteFileOrFolder "folder" "anotherFolder"

    if [ "$#" -ne 2 ]; then
        echo -e "\e[31mUsage: copyPasteFileOrFolder <source file/folder> <destination file/folder>\e[0m" # Red
        return 1
    fi

    local source="$1"
    local destination="$2"

    if [ ! -e "$source" ]; then
        echo -e "\e[31mThe source $source does not exist.\e[0m" # Red
        return 1
    fi

    # Create the destination directory if it does not exist
    local destDir=$(dirname "$destination")
    if [ ! -d "$destDir" ]; then
        mkdir -p "$destDir"
    fi

    # Copy the file or directory to the new location
    cp -r "$source" "$destination"

    if [ $? -eq 0 ]; then
        echo -e "\e[32mCopied $source to $destination successfully.\e[0m" # Green
    else
        echo -e "\e[31mFailed to copy $source to $destination.\e[0m" # Red
        return 1
    fi
}

function getFilesByExtensionRecursive() {
    #=====USAGE=====#
    # local fileTypes=(".sh" ".txt")
    # local files="$(getFilesByExtensionRecursive "." "fileTypes[@]")"
    # echo -e "$files"

    if [ "$#" -ne 2 ]; then
        echo "Usage: getFilesByExtension <directory> <array of extensions>"
        return 1
    fi

    local directory="$1"
    local extensions=("${!2}")
    local files=()

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    for ext in "${extensions[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$(basename "$file")")
        done < <(find "$directory" -type f -name "*$ext" -print0)
    done

    printf "%s\n" "${files[@]}"
}

function getFilesByExtension() {
    #=====USAGE=====#
    # local fileTypes=(".sh" ".txt")
    # local files="$(getFilesByExtension "." "fileTypes[@]")"
    # echo -e "$files"

    if [ "$#" -ne 2 ]; then
        echo "Usage: getFilesByExtension <directory> <array of extensions>"
        return 1
    fi

    local directory="$1"
    local extensions=("${!2}")
    local files=()

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    for ext in "${extensions[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$(basename "$file")")
        done < <(find "$directory" -maxdepth 1 -type f -name "*$ext" -print0)
    done

    printf "%s\n" "${files[@]}"
}

function getFileNamesByExtensionRecursive() {
    #=====USAGE=====#
    # names="$(getFileNamesByExtensionRecursive "." "*" true)"
    # echo -e "All .txt files in current directory and subdirectories:\n${names[*]}"

    if [ "$#" -ne 3 ]; then
        echo "Usage: getFileNamesByExtensionRecursive <directory> <extension> <include extension (true/false)>"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local includeExtension="$3"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$includeExtension" = true ]; then
        find "$directory" -type f -name "*$extension" -printf "%f\n"
    else
        find "$directory" -type f -name "*$extension" -printf "%f\n" | sed 's/\.[^.]*$//'
    fi
}

function getFileNamesByExtension() {
    #=====USAGE=====#
    # names="$(getFileNamesByExtension "folder/anotherFolder" "*" true)"
    # echo "Files in the specified directory: ${names[*]}"
    # names="$(getFileNamesByExtension "folder/anotherFolder" ".txt" false)"
    # echo "TXT files in the specified directory: ${names[*]}"

    if [ "$#" -ne 3 ]; then
        echo "Usage: getFileNamesByExtension <directory> <extension> <include extension (true/false)>"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local includeExtension="$3"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$extension" = "*" ]; then
        if [ "$includeExtension" = true ]; then
            find "$directory" -maxdepth 1 -type f -printf "%f\n"
        else
            find "$directory" -maxdepth 1 -type f -printf "%f\n" | sed 's/\.[^.]*$//'
        fi
    else
        if [ "$includeExtension" = true ]; then
            find "$directory" -maxdepth 1 -type f -name "*$extension" -printf "%f\n"
        else
            find "$directory" -maxdepth 1 -type f -name "*$extension" -printf "%f\n" | sed 's/\.[^.]*$//'
        fi
    fi
}

function getFileCountByExtensionRecursive() {
    #=====USAGE=====#
    # count=$(getFileCountByExtensionRecursive "folder/anotherFolder" ".txt")

    if [ "$#" -ne 2 ]; then
        echo "0"
        return 1
    fi

    local directory="$1"
    local extension="$2"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    # Use find to count files with the specified extension recursively
    local count=$(find "$directory" -type f -name "*$extension" | wc -l)

    echo $count
}

function getFileCountByExtension() {
    #=====USAGE=====#
    # count=$(getFileCountByExtension "folder/anotherFolder" "*")
    # count=$(getFileCountByExtension "folder/anotherFolder" ".txt")

    if [ "$#" -ne 2 ]; then
        echo "0"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local count=0

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$extension" = "*" ]; then
        count=$(find "$directory" -maxdepth 1 -type f | wc -l)
    else
        count=$(find "$directory" -maxdepth 1 -type f -name "*$extension" | wc -l)
    fi

    echo $count
}

function getContentsBetweenDelimeters() {
    #=====USAGE=====#
    # local content="$(getContentsBetweenDelimeters "example.txt" "<startDelimiter>" "<endDelimiter/>")"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: getContentsBetweenDelimeters <file> <start delimiter> <end delimiter>\e[0m\n" >&2
        return 1
    fi

    local file="$1"
    local startDelimiter="$2"
    local endDelimiter="$3"

    if [ ! -e "$file" ]; then
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" >&2
        return 1
    fi

    # Check if the delimiters exist in the file
    if ! grep -q "$startDelimiter" "$file"; then
        echo -e "\n\e[31mStart delimiter '$startDelimiter' not found in file.\e[0m\n" >&2
        return 1
    fi

    if ! grep -q "$endDelimiter" "$file"; then
        echo -e "\n\e[31mEnd delimiter '$endDelimiter' not found in file.\e[0m\n" >&2
        return 1
    fi

    # Extract and print the contents between the delimiters
    awk -v startDelim="$startDelimiter" -v endDelim="$endDelimiter" \
        'BEGIN {capture=0} 
          ~ startDelim {capture=1; next} 
          ~ endDelim {capture=0} 
         capture && !( ~ endDelim) {print}' "$file"
}

function replaceTextBetweenDelimiters() {
    #=====USAGE=====#
    # replaceTextBetweenDelimiters "folder/example.txt" "<startDelimiter>" "<endDelimiter/>" "$(
    #     cat <<EOF
    # Replacement 1
    # Replacement 2
    # EOF
    # )"

    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: replaceTextBetweenDelimiters <file> <start delimiter> <end delimiter> <replacement text>\e[0m\n"
        return 1
    fi

    local file="$1"
    local startDelimiter="$2"
    local endDelimiter="$3"
    local replacementText="$4"

    if [ ! -e "$file" ]; then
        echo -e "\n\e[31mFile does not exist.\e[0m\n"
        return 1
    fi

    # Check if the delimiters exist in the file
    if ! grep -qF "$startDelimiter" "$file"; then
        echo -e "\n\e[31mStart delimiter not found in file.\e[0m\n"
        return 1
    fi

    if ! grep -qF "$endDelimiter" "$file"; then
        echo -e "\n\e[31mEnd delimiter not found in file.\e[0m\n"
        return 1
    fi

    awk -v s="$startDelimiter" -v e="$endDelimiter" -v r="$replacementText" '
{
    if ($0 ~ s) {
        print;
        print r;
        skip = 1;
    } else if ($0 ~ e) {
        skip = 0;
    }

    if (!skip || $0 ~ e) print;
}' "$file" >temp && mv temp "$file" && echo -e "\n\e[32mText replaced successfully.\e[0m\n" || echo -e "\n\e[31mFailed to replace text.\e[0m\n"
}

function replaceTextBetweenLines() {
    #=====USAGE=====#
    # replaceTextBetweenLines "folder/example.txt" 2 3 "$(
    #         cat <<EOF
    # Replacement 1
    # Replacement 2
    # EOF
    #     )"

    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: replaceTextBetweenLines <file> <start line index> <end line index> <'multi-line replacement text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local startIndex="$2"
    local endIndex="$3"
    local replacementText="$4"

    if [ -e "$file" ]; then
        # Convert from zero-based to one-based indexing
        let "startIndex++"
        let "endIndex++"

        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and replace the text
        awk -v start="$startIndex" -v end="$endIndex" -v replace="$replacementText" 'NR==start, NR==end { if(NR==start) print replace; next } 1' "$file" >"$tmpfile" && mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText replaced successfully between lines $((startIndex - 1)) and $((endIndex - 1)).\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to replace text in the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function removeLines() {
    #=====USAGE=====#
    # removeLines "example.txt" 1
    # removeLines "example.txt" 1 2

    if [ "$#" -lt 2 ]; then
        echo -e "\n\e[31mUsage: removeLines <file> <start index> [end index]\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local startIndex="$2"
    local endIndex=${3:-$startIndex}

    # Adjusting for zero-based indexing
    let "startIndex++"
    let "endIndex++"

    if [ -e "$file" ]; then
        # Use sed to remove lines from startIndex to endIndex
        sed -i "${startIndex},${endIndex}d" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mLines removed successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to remove lines from the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToFile() {
    #=====USAGE=====#
    #     prependToFile "folder/example.txt" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 2 ]; then
        echo -e "\n\e[31mUsage: prependToFile <file> <'text to prepend'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local prependText="$2"

    if [ -e "$file" ]; then
        # Read the file content
        local content=$(cat "$file")

        # Prepend the text to the content
        echo -n "$prependText$content" >"$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText prepended successfully to the beginning of the file.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend text to the beginning of the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToFile() {
    #=====USAGE=====#
    #     appendToFile "folder/example.txt" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 2 ]; then
        echo -e "\n\e[31mUsage: appendToFile <file> <'text to append'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local appendText="$2"

    if [ -e "$file" ]; then
        # Read the file content
        local content=$(cat "$file")

        # Append the text to the content
        echo -n "$content$appendText" >"$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the end of the file.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the end of the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToPreviousLineIndex() {
    #=====USAGE=====#
    #     prependToPreviousLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToPreviousLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Insert multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print txt; print; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text inserted after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to insert multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToNextLineIndex() {
    #=====USAGE=====#
    #     appendToNextLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: appendToNextLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Append multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print; print txt; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text appended after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToTextContentIndex() {
    #=====USAGE=====#
    #     prependToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: prependToTextContentIndex <file> <index> <text to match> <text to prepend>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local prependText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to prepend text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$prependText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = txt $i;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText prepended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToTextContentIndex() {
    #=====USAGE=====#
    #     appendToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: appendToTextContentIndex <file> <index> <text to match> <text to append>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local appendText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to append text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$appendText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = $i txt;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local prependText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and prepend the text
        while IFS= read -r line || [[ -n $line ]]; do
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$prependText" >>"$tmpfile"
            fi
            echo "$line" >>"$tmpfile"
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text prepended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: appendToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local appendText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and append the text
        while IFS= read -r line || [[ -n $line ]]; do
            echo "$line" >>"$tmpfile"
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$appendText" >>"$tmpfile"
            fi
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text appended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function getFileContents() {
    #=====USAGE=====#
    # fileContents=$(getFileContents "folderName/example.txt")

    # Check if an argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: getFileContents \"folderName/example.txt\""
        return 1
    fi

    local file="$1"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Read and print the contents of the file
        cat "$file"

        # Check if the file reading was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mFile contents read successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to read file contents.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function createFolders() {
    #=====USAGE=====#
    # createFolders "parentFolder/childFolder"

    # Check if an argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: createFolders \"parentFolder/childFolder\""
        return 1
    fi

    # Extract the folder path from the argument
    local folderPath="$1"

    # Create the folders
    mkdir -p "$folderPath"

    # Check if the folders were created successfully
    if [ $? -eq 0 ]; then
        echo -e "\n\e[32mFolders created successfully: $folderPath\e[0m\n" # Green
    else
        echo -e "\n\e[31mFailed to create folders: $folderPath\e[0m\n" # Red
        return 1
    fi
}

function createFile() {
    #=====USAGE=====#
    # createFile "nonexistentFolder/example.txt" "$(
    #         cat <<EOF
    # Multiline
    # text
    # EOF
    #     )"

    # Check if both file and content arguments are provided
    if [ $# -lt 2 ]; then
        echo "Usage: createFile \"nonexistentFolder/example.txt\" \"\$(
            cat <<EOF
Multiline
text
EOF
        )\""
        return 1
    fi

    local file="$1"
    local content="$2"

    # Extract the directory path from the file
    dir=$(dirname "$file")

    # Create the directory if it doesn't exist
    mkdir -p "$dir"

    # Create the file with the specified content
    echo "$content" >"$file"

    # Check if the file was created successfully
    if [ -e "$file" ]; then
        echo -e "\n\e[32mFile $file was successfully created.\e[0m\n" # Green
    else
        echo -e "\n\e[31mFailed to create $file.\e[0m\n" # Red
    fi
}

main
```

# =====================================
# React Form
## Form 1
```tsx
import React, { useState } from "react";

interface FormData {
  textInput: string;
  textareaInput: string;
  selectInput: string;
  radioInput: string;
  checkboxInput1: boolean;
  checkboxInput2: boolean;
}

export function Form() {
  const [formData, setFormData] = useState<FormData>({
    textInput: "",
    textareaInput: "",
    selectInput: "",
    radioInput: "radioOption1",
    checkboxInput1: false,
    checkboxInput2: false,
  });

  const selectOptions = {
    option1: "Option 1",
    option2: "Option 2",
    option3: "Option 3",
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value, type } = e.target;
    const checked = type === "checkbox" ? (e.target as HTMLInputElement).checked : undefined;

    setFormData((prevData) => ({
      ...prevData,
      [name]: type === "checkbox" ? !!checked : value,
    }));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const areAllInputsFilled = Object.values(formData).every(
      (value) =>
        value !== undefined && value !== null && value !== '',
    );

    if (areAllInputsFilled) {
      // Submit the form
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Text Input */}
      <label htmlFor="textInput">
        Text Input:
        <input
          type="text"
          id="textInput"
          name="textInput"
          value={formData.textInput}
          onChange={handleChange}
          aria-label="Text Input"
        />
      </label>

      <br />

      {/* Textarea Input */}
      <label htmlFor="textareaInput">
        Textarea Input:
        <textarea
          id="textareaInput"
          name="textareaInput"
          value={formData.textareaInput}
          onChange={handleChange}
          aria-label="Textarea Input"
        />
      </label>

      <br />

      {/* Select Dropdown */}
      <label htmlFor="selectInput">
        Select Dropdown:
        <select
          id="selectInput"
          name="selectInput"
          value={formData.selectInput}
          onChange={handleChange}
          aria-label="Select Dropdown"
        >
          <option value="">Select an option</option>
          {Object.entries(selectOptions).map(([key, option]) => (
            <option key={key} value={key}>
              {option}
            </option>
          ))}
        </select>
      </label>

      <br />

      {/* Radio Buttons */}
      <div>
        {Object.entries(selectOptions).map(([key, option]) => (
          <label key={key} htmlFor={`radio${key}`}>
            <input
              type="radio"
              id={`radio${key}`}
              name="radioInput"
              value={key}
              checked={formData.radioInput === key}
              onChange={handleChange}
              aria-label={`Select ${option}`}
            />
            {`Select ${option}`}
          </label>
        ))}
      </div>

      <br />

      {/* Checkboxes */}
      <div>
        {Object.entries(selectOptions).map(([key, option]) => (
          <label key={key} htmlFor={`checkbox${key}`}>
            <input
              type="checkbox"
              id={`checkbox${key}`}
              name={`checkbox${key}`}
              checked={!!formData[`checkbox${key}` as keyof FormData]} // Ensure boolean value
              onChange={handleChange}
              aria-label={`Toggle ${option}`}
            />
            {`Toggle ${option}`}
          </label>
        ))}
      </div>

      <br />

      {/* Submit Button */}
      <button type="submit">Submit</button>
    </form>
  );
}
```


## Form 2
```tsx
// React form; basic react form; basic form; react form handling;
import React from "react";

interface Form {
  username: string;
  password: string;
}

const LoginForm = () => {
  const [formData, setFormData] = React.useState<Form>({
    username: "",
    password: "",
  });

  const [message, setMessage] = React.useState<string>("");

  const handleInputChange = (e: React.FormEvent<HTMLInputElement>) => {
    const { name, value } = e.currentTarget;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const areAllInputsFilled = Object.values(formData).every(
      (value) =>
        value !== undefined && value !== null && value !== '',
    );

    if (areAllInputsFilled) {
      // Submit the form
    }
  };

  return (
    <div className="login-form">
      <form
        onSubmit={(e) => {
          handleSubmit(e);
        }}
      >
        <label>Username</label>
        <input
          autoFocus
          required
          type="text"
          name="username"
          onChange={handleInputChange}
        />

        <label>Password</label>
        <input
          required
          type="password"
          name="password"
          onChange={handleInputChange}
        />

        <button type="submit">Login</button>

        {message && <p>{message}</p>}
      </form>
    </div>
  );
};

export default LoginForm;
```

# =====================================
# Get Git Version

```bat
@echo off
setlocal EnableDelayedExpansion

:: ====================GET THE LATEST GIT VERSION====================
:: Use curl to fetch the JSON data from GitHub API for Git tags

:: Parse the JSON data and extract the latest Git version
for /f "tokens=3 delims=:, " %%v in ('curl -s https://api.github.com/repos/git/git/tags') do (
    set "git_version=%%v"
    goto VersionFound
)

:VersionFound
:: Remove leading and trailing double quotes
set "git_version=!git_version:"=!"

for /f "tokens=*" %%a in ("!git_version!") do (
  set "gitLatestVersion=%%~nxa"
  set gitLatestVersion=!gitLatestVersion:~1!
)

echo !gitLatestVersion!
pause
:: Now you can use the variable !git_version! in your script
:: ====================GET THE LATEST GIT VERSION====================
```

# =====================================
# Get Git Version Bash

```bash
#!/bin/bash

# URL of the webpage
url="https://git-scm.com/downloads"

# Class name of the element you want to extract
className="version"

# Use curl to fetch the webpage content and extract the version using awk
version=$(curl -s "$url" | awk -F'<[^>]*>' "/class=\"$className\"/{getline; gsub(/[[:space:]]/, \"\"); print }")

# Print the type of element and the extracted version
echo "Git version: $version"
```

# =====================================
# Git Commands

```bash
# Git

Change parent branch; apply another branch's changes to another branch (switch to the branch you are working on):
 git rebase origin/feature/youre/working/on

Update feature branch with changes from the main branch:
 git merge origin/main

Run after installing Git:
Set main as initial branch, rather than master
git config --global init.defaultBranch main

Setup/Generate SSH key using git bash:

List all remote branches; list all branches:
 git branch -r

Push a new branch:
*-u is shorthsnd for --set-upstream
git push -u origin <new-branch>

Create and checkout to a new branch:
git checkout -b <new-branch>

# Create a new branch without files; Create a blank branch
```
git checkout --orphan <new-branch>
```

# Change commit message: change a commit message after pushing
```
git commit --amend -m "New commit message"
git push --force
git status
```


Rename a branch (must be in the branch you want to rename):
git branch -m <new-branch-name>

Upload a renamed brach to the repository:
git push origin HEAD:<renamed-branch>
 
Clone a repository to current folder:
  git clone <repository> .
  
Clone a repository to a named folder:
  git clone <repository> <folder name>

Merge a branch to production:
git checkout main
git merge <new-branch>

List all remote branches:
git branch -a

Create a new branch from an existing branch; create a new branch from an existing branch; create new branch from an existing branch:
git checkout -b new-branch parent-branch

Delete a local branch; delete local branch (checkout to another branch before deleting):
*checkout to another branch before deleting
*"Safe" delete (prevents you from deleting the branch if it has unmerged changes)
git branch -d <delete-this-branch>

Force delete a branch, even if it has unmerged changes
git branch -D <delete-this-branch>

Delete a remote branch:
git push origin -d <delete-this-branch>

Switch to another branch
git switch branch-to-use

Upload branch to remote
git add .
git commit -m "Commit"
git push -u origin <new-branch>
git status

Set Global Credentials:
git init
git config --global user.name "<username>"
git config --global user.email "<username>@github.com"

Set Local Credentials (on a specific project):
git init
git config user.name "<username>"
git config user.email "<username>@gmail.com"

Upload Project Folder Files/Override Repository:
git init
git add .
git commit -m "Commit"
git remote add origin https://github.com/<username>/repository
git remote -v
git push -f origin main
git status

Download Files/Repository:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git status
 
Revert back to main; hard reset; remove all changes:
```
git checkout target-branch
git fetch origin main
git pull origin main
git reset --hard origin/main
git push origin target-branch --force
```

Reset/remove all changes:
git stash -u

Reapply changes after resetting:
git stash pop

Remove stashes:
git stash drop

Save Changes:
git add .
git commit -m "Commit"
git push -f origin main
git status

Delete All Files:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git rm -r *
git commit -m "Delete"
git push -f origin main
git status

Delete Individual Files:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git rm file.txt
git commit -m "Delete"
git push -f origin main
git status
```

# =====================================
# GraphQL

```tsx
import { PrismaClient } from "@prisma/client";
import DatatypeParser from "@utilities/DatatypeParser";
import { graphql, buildSchema as gql } from "graphql";

const prisma = new PrismaClient();

const schema = /* GraphQL */ `
  type Order {
    order_id: ID!
    orderProducts: [OrderedProducts!]!
  }
  type OrderedProducts {
    id: ID!
    order_id: Int!
    product_id: Int!
    quantity: Int!
  }
  type Query {
    getHelloWorld(parameter: ID!): String
    getOrder(id: ID!): Order
  }
`;

// The rootValue provides a resolver function for each API endpoint
var rootValue = {
  getHelloWorld: ({ parameter }: { [key: string]: number }) => {
    return "Hello, World!";
  },
  getOrder: async ({ id }: { id: string }) => {
    const result: any = await prisma.order.findUnique({
      select: {
        order_id: true,
        orderProducts: {
          select: {
            id: true,
            order_id: true,
            product_id: true,
            quantity: true,
          },
        },
      },
      where: {
        order_id: parseInt(id),
      },
    });
    return DatatypeParser(result);
  },
};

const order = async () => {
  const orderId = 1;
  const query = /* GraphQL */ `
      query {
        getOrder(id: ${orderId}) {
          order_id
          orderProducts {
            id
            order_id
            product_id
            quantity
          }
        }
      }
    `;
  try {
    // prettier-ignore
    // Destructuring nested objects
    const { data: { getOrder: order } }: any = await graphql({ schema: gql(schema), source: query, rootValue });
    return order;
  } catch (error) {
    return error;
  }
};
```

# =====================================
# Jenkins Commands

## Setup

- Allow local builds
    ```
    JAVA_OPTS=-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true
    ```
    Docker compose:
    
    ```yml
    environment:
      - JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true"

- Install NodeJS Plugin

        1. Go to Dashboard > Manage Jenkins > Manage Plugins > Available plugins

        2. Search for "NodeJS"

        3. Check the NodeJS Plugin by npm

        4. Click "Download now and install after restart"
        
        5. Check "Restart Jenkins when installation is complete and no jobs are running"
        
        6. After restart, go to Dashboard > Manage Jenkins > Global Tool Configuration
        
        7. Scroll down to NodeJS, then click Add NodeJS
        
        8. Set name to the version e.g. "18.0.0". This name will be used in the Jenkinsfile when building a pipeline.
                
                tools {
                    nodejs "18.0.0"
                }
                
        9. Select a version to insall, then click Save


## Restart Jenkins

Head to [localhost:8080/restart](http://localhost:8080/restart) to restart Jenkins
    

## CI/CD Pipeline

1. Create new item/job
2. Select Pipeline, then click OK
3. Scroll down to Pipeline. Use the settings below:

    Definition
      - Pipeline script from SCM
        - SCM
          - Git
          - Repository URL
            - **file:////var/jenkins_home/app/projectName**
            - **https://github.com/judigot/repository**
          - Branch Specifier (blank for 'any')
            - */main
        - Script Path
          - Jenkinsfile

# =====================================
# Laravel Commands

```
https://laracasts.com/series/laravel-from-scratch-2018/

Install dependencies (package.json)
Blank project steps:
Apply custom settings
Create migrations
Create models
Create controller (RESTful)
Setup routes

==============
PRODUCTION:
1. Cache config files
2. Store api keys, credentials, etc. in the .env file
==============

•••••••••••••••••••••••••••••••••••••••••••
Learn:
•Convert DB structure to migration
•Use query builder than eloquent:
https://fideloper.com/laravel-raw-queries

Service provider:
register() method loads first before the boot() method
When adding a service, go to app>config>services.php and input the necessary detail referencing the .env file (config files work like dbinfo.json)

•••••••••••••••••••••••••••••••••••••••••••
•Custom Settings
Add following code to AppServiceProvider.php (/app/Providers/AppServiceProvider.php)
===============================
use Illuminate\Support\Facades\Schema;
function boot()
{
    Schema::defaultStringLength(191);
}
===============================

•Commands
Start the project:
	php artisan serve

CONTROLLER COMMANDS:
*__construct is the first thing that runs in a class when called

•Create Controller/Class:
	php artisan make:controller sampleController
•Create Controller/Class with existing functions:
	php artisan make:controller SampleController -r
•Create Controller with existing functions and Model:
	php artisan make:controller SampleModelController -r -m SampleModel

MIGRATION COMMANDS:
•Define database tables from PHP classes (setup the database details in .env file first):
	php artisan migrate
•Create "migrations" table:
	php artisan migrate:install
•Rollback last migration:
	php artisan migrate:rollback
•Redefine database tables:
	php artisan migrate:fresh
•Create table:
	php artisan make:migration create_sample_table
•Update table:
	php artisan make:migration create_sample_table

MODEL COMMANDS:
•Create model:
	php artisan make:model Tablename
•Create one-to-make relationship
	php artisan make:model Order -m -f

SERVICE PROVIDER COMMANDS:
•Create provider
	php artisan make:provider SampleProvider
•Cache config files (for production)
	php artisan config:cache
•Remove cached config files
	php artisan config:clear

MIDDLEWARE COMMANDS:
•Create middleware (after creating, instantiate it in the Kernel.php, add conditions in the handle() function)
	php artisan make:middleware MiddlewareName

*2 types of middleware:
	•Global = runs on every request/page
	•Route = optional on every request/page (e.g: authentication)

AUTHENTICATION
*can be applied on the controller (constructor) or routes (web.php)
•Create login and registration system
	php artisan make:auth

LARAVEL TELESCOPE
•Require telescope
	composer require laravel/telescope --dev
•Install telescope
	php artisan telescope:install
	php artisan migrate

DEPENDENCIES
•Install dependencies
	npm install
•Compile assets (css, javascript)
	npm run dev
	npm run production
•Auto-compile assets when changed
	npm run watch

=================================================

•Routing
Router = routes>web.php
Views/Pages = (resources>views)
•Controller
•Migrations
•Models
•CSRF Protection token
•Routing Conventions
•Validation
•Service Provider (Runs on every page load)
•Authentication
•Laravel Telescope
•Events (Custom) to separate extra logic from the main purpose (CRUD)
•Notifications
•Webpack
•Collections
```

# =====================================
# Line Replacer Batch

```bat
@echo off

setlocal disableDelayedExpansion

:Variables
set InputFile=old.txt
set OutputFile=new.txt
set "_strFind=2"
set "_strInsert=replacement"

:Replace
>"%OutputFile%" (
  FOR /f "usebackq delims=" %%A IN ("%InputFile%") DO (
    IF "%%A" EQU "%_strFind%" (echo %_strInsert%) ELSE (echo %%A)
  )
)
```

# =====================================
# Linux Ubuntu Commands

## MySQL
### Execute a SQL file from URL; Import SQL file:
    curl 'https://raw.githubusercontent.com/user/repo/data.sql' | mysql -uroot -p123

### Install mysql-server

```bash
apt install -y mysql-server
```
### Start mysql
```bash
usermod -d /var/lib/mysql/ mysql && service mysql start
```

### Run mysql_secure_installation

`If there's an error running mysql_secure_installation, run the following commands in mysql to enable mysql_secure_installation:`

```bash
mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123';
FLUSH PRIVILEGES;
EXIT;
```
    
## Log In
```bash
mysql -u<user> -p<password>
mysql -uroot -p123
```

## Log Out
```bash
exit;
```

## MySQL Commands

### Show Databases
```sql
SHOW DATABASES;
```

### Show Tables
```sql
SHOW TABLES;
```

### Show Port
```sql
SHOW @@PORT;
```

### Show Database
```sql
USE `databaseName`;
```

### Show Table Information
```sql
DESCRIBE `tableName`;
```

## PostgreSQL
### Install PostgreSQL
```bash
apt install -y postgresql postgresql-contrib
```

### Start PostgreSQL
```bash
service postgresql start
```
    
### Add password
```bash
sudo passwd postgres
```
    
### Enable postgres=# Prompt:
```bash
sudo -i -u postgres
```

### Access postgres=# prompt:
```bash
psql
```

### Reset Auto-Increment ID
```bash
ALTER SEQUENCE tableName_column_id_seq RESTART WITH 1;
```

### Shorthand for enabling and accessing postgres=#:
```bash
sudo -u postgres psql
*exit
\q
```

### Log out:
```bash
\q
exit
```
    
### Create new role:

```bash
# If logged in to postgres=#
createuser --interactive
```
```bash
sudo -u postgres createuser --interactive
```
    
### List databases;
```bash
\l
```
    
### List tables:
```bash
\dt
```
    
### Delete All Tables; Delete Tables; Remove All Tables
```sql
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
```
    
### Use database:
```bash
\c database_name
```
    
### Dump database:

#### Dump Everything
```bash
pg_dump -d database_name -h localhost -p 5432 -U root > database_name.sql
```

#### Dump Schema
```bash
pg_dump --schema-only -d database_name -h localhost -p 5432 -U root > database_name_schema.sql
```

#### Dump Data
```bash
pg_dump --data-only -d database_name -h localhost -p 5432 -U root > database_name_data.sql
```

# =====================================
# Node.js & NPM Commands & Configurations

## Set Default Shell
```bash
npm config set shell "C:\\apportable\\Programming\\PortableGit\\bin\\bash.exe"
```

## Install Nest.js
```bash
git clone https://github.com/nestjs/typescript-starter.git .
pnpm install
pnpm run start
```
## Fix Initial ESLint Errors
Add this to .eslintrc.js inside **rules**
```
"prettier/prettier": [
  "error",
  {
    "endOfLine": "auto"
  }
],
```
## Project Scaffolding:

### Vite (TypeScript):

#### PNPM
```bash
pnpm create vite . --template react-ts
```

#### NPM
```bash
npm create vite@latest . -- --template react-ts
```
	
### Next.js

#### Install On Current Directory
```bash
npx create-next-app@latest . --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/*
```
	
#### Install on Current a Different Directory
```bash
npx create-next-app@latest bigbang --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/*

# What is your project named? bigbang
# Would you like to use TypeScript? Yes
# Would you like to use ESLint? Yes
# Would you like to use Tailwind CSS? Yes
# Would you like to use `src/` directory? Yes
# Would you like to use App Router? (recommended) Yes
# Would you like to customize the default import alias (@/*)? Yes
# What import alias would you like configured? @/*
```
	
#### Update Next.js Installation
```bash
npm i next@latest react@latest react-dom@latest eslint-config-next@latest
```
	
#### GetServerSideProps
- use for authentication and conditional rendering
- render data on request time
	
#### GetStaticProps:
- for SEO
- for static pages
- generates static html and json files for caching

## PurgeCSS (Remove Unused CSS)
https://www.youtube.com/watch?v=y3WQoON6Vfc

## NPM Commands
### Show Unused Packages
```bash
npx depcheck
```

### Create a package.json
#### With a wizard
```bash
npm init
```

#### Without a wizard
```bash
npm init -y
```

#### Install All Dependencies from package-lock.json:
```bash
npm ci
```

#### Install Development/Production Dependencies in package-lock.json
```bash
npm ci --only=development
npm ci --only=production
```

#### Install All Dependencies From package.json:
```bash
npm install
```

#### Install All Production ("dependencies") Dependencies From package.json Globally
```bash
npm install --only=production
```

#### Install All Development ("devDependencies") Dependencies From package.json Globally
```bash
npm install --only=development
```

#### Install Dependencies Globally
```bash
npm install -g
```
	
#### Check Package Version; Check Dependency Version
```bash
npm view <package-name> version
```

#### Delete All Dependencies:
```bash
npm uninstall *
```

## Package.json Scripts

```json
"dev": "clear && rm -r dist && webpack --mode development",
"build": "clear && rm -r dist && webpack --mode production && tsc -p .",
"watch": "clear && rm -r dist && webpack --watch --mode development"
```

## Global Dependepcies

    pnpm
    create next-app

## Big Bang Dependepcies

### Production
```bash
npm install express
npm install dotenv
npm install bcrypt
npm install sequelize

npm install typescript
npm install ts-node

npm install @types/node

npm install @types/bcrypt
npm install @types/express

npm install ejs
npm install ejs-loader
npm install mysql2

npm install bootstrap
npm install @popperjs/core
npm install jquery
npm install jquery-ui-dist

npm install bootstrap-timepicker

npm install jquery-contextmenu
npm install datatables.net-dt

npm install notifyjs
npm install flipclock
npm install @fortawesome/fontawesome-free
```

### Development
```bash
npm install -D nodemon
npm install -D webpack
npm install -D webpack-cli

npm install -D @babel/core
npm install -D babel-loader
npm install -D @babel/preset-env

npm install -D node-sass
npm install -D sass-loader
npm install -D css-loader
npm install -D style-loader

npm install -D mini-css-extract-plugin

npm install -D purgecss-webpack-plugin
npm install -D file-loader

npm install -D clean-webpack-plugin

npm install -D html-webpack-plugin
npm install -D copy-webpack-plugin

npm install -D img-loader
```
## NVM Installation

1. Download nvm-noinstall.zip from the latest version here: https://github.com/coreybutler/nvm-windows/releases
2. Extract to a folder named "nvm" in C:\judigot\Programming\Environment\nvm
3. Run "install.cmd" that's inside the extracted "nvm" folder
4. Enter "C:\judigot\Programming\Environment\nvm" as the absolute path
5. Set the "path:" inside "settings.txt" to "C:/judigot/Programming/Environment/nodejs"

# =====================================
# PHP Commands
```php
<?php
// Rename object keys; rename keys
function renameKeys($object, $newKeys)
{
    foreach ($newKeys as $key => $value) {

        // Get position of the target key
        $position = array_search($key, array_keys($object));

        // Get original value
        $positionValue = $object[$key];

        $newObject = [$value => $positionValue];

        // Remove key and its value
        unset($object[$key]);

        // Merge different parts of the array (head, renamed element, tail)
        $object = array_merge(
            array_merge(
                array_slice($object, 0, $position, true),
                $newObject
            ),
            array_slice($object, $position, count($object), true)
        );
    }

    return $object;

    /**************
     * SAMPLE USE *
     **************/
    /*
    $array = [
        "key1" => "value1",
        "key3" => "value2",
        "key4" => "value3",
    ];
    $result = renameKeys($array, [
        "key3" => "three",
    ]);
     */
}

// Get PC Serial Number (for generating license key):
$serial = shell_exec('wmic DISKDRIVE GET SerialNumber 2>&1');
echo $serial;

// Delete all files in a directory
array_map("unlink", glob(__DIR__ . "\FolderName\*"));
// Delete all files including subfolders
array_map("unlink", array_filter((array)glob(__DIR__ . "\FolderName\*")));

//  Add leading zeros:
$num = 5;
echo str_pad($num, 2, "0", STR_PAD_LEFT);

//     Validate email:
$email = "john.doe@@example.com";
if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo ("$email is a valid email address");
} else {
    echo ("$email is not a valid email address");
}

//  Get absolute project path:
$projectRoot = str_replace($_SERVER['DOCUMENT_ROOT'], "", str_replace(chr(92), "/", getcwd())) . "/";

//     Serialize database result:
md5(serialize($Result));

// Get timestamp/Current date/Get current date:
echo date("g:i:s A"); // 5:30 PM
echo date("Y-m-d H:i:s A");    // 24-hour format
echo date("Y-m-d H:i:s", time());
echo date("F j, Y");        //December 14, 2019

//   Insert MySQL date and time/get date and time/get timezone:
echo date_default_timezone_get();
echo "<br>";
echo date("Y-m-d");
echo "<br>";
echo date("G-i-s");
$time = strtoupper(date("h:i:s a"));
if ($time[0] == "0") {
    $time = substr($time, 1);
}
echo $time;

//  Get Column Names from MySQL Table:
$ColumnNames = array_keys($Result[0]);
print_r($ColumnNames);

//  Get Enum Values from MySQL Table:
$Result = $Database::Read($Connection, "SHOW COLUMNS FROM `attendees` WHERE FIELD='eventFee'");
$EventFeeFields = explode("','", preg_replace("/(enum|set)\('(.+?)'\)/", "\\2", $Result[0][array_keys($Result[0])[1]]));

//   Display Array:
echo "<pre>" . print_r($array, true) . "</pre>";
```

# =====================================
# Portable Git Bash

Portable Git Bash.bat
```bat
@echo off

start "C:\apporatable\Programming\PortableGit\git-bash.exe"
```

# =====================================
# Prisma

## Installation Steps
1. Install Packages
    ```bash
    npm init -y
    npm install typescript ts-node @types/node --save-dev
    npm install prisma --save-dev
    npm i @prisma/client
    npx tsc --init
    npx prisma init --datasource-provider mysql
    ```
2. Add a Custom Prisma Directory in package.json
    ```json
    "prisma": {
      "schema": "src/prisma/schema.prisma"
    },
    ```
3. Move the Prisma Folder to the Custom Prisma Path

4. Set the database_URL in the .Env File to Point to Your Existing Database

## Create a Prisma Schema From an Existing Database
```bash
npx prisma db pull && npx prisma generate
```

## Sync Schema to the Database (When Developing Locally)
```bash
npx prisma db push && npx prisma generate
```

## Draft Migration (Create a Migration File but Don’t Sync)

Can be edited before committing

```bash
npx prisma migrate dev --name <renamed-firstname-to-firstName> --create-only
```

## Sync Migration Files; Commit Migration Changes
```bash
npx prisma migrate dev
```

## Sync Schema to Update the Prisma Client in Node_modules

Run this everytime the schema is changed

```bash
npx prisma generate
```

# =====================================
# SEO (Search Engine Optimization)

## DNS Set Up

| Host name      | Type              | Data            | Result          |
| :------------: | :---------------: | :-------------: | :-------------: |
| @ (or empty)   | A                 | 666.666.666.666 | example.com     |
| www            | A                 | 666.666.666.666 | www.example.com |

Vercel DNS:

    76.76.21.241
## NGINX Boilerplate

```nginx
# HTTP (Port 80)
server {
    # if ($host = example.com) {
    #     return 301 https://$host$request_uri;
    # } # managed by Certbot

    listen 80;
    listen [::]:80;
    server_name example.com www.example.com localhost;
    return 301 https://$host$request_uri;
    return 404; # managed by Certbot
}

# HTTPS - SSL (Port 443)
server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;
    server_name example.com www.example.com localhost;
    
    #==========SSL CONFIGURATION==========#
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    #==========SSL CONFIGURATION==========#
    
    #==========STATIC CONTENT==========#
    # root /var/www/html;
    root /var/www/app;

    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
    #==========STATIC CONTENT==========#
    
    #==========REVERSE PROXY==========#
    location / {
        proxy_pass http://apache2;
    }
    #==========REVERSE PROXY==========#
}

#==========REVERSE PROXY==========#
upstream apache2 {
    server example.com:5000;
    # server host.docker.internal:5000;
}
#==========REVERSE PROXY==========#
```

# =====================================
# SQL

## Database Must-Haves
- Insert date and time in UTC. This means, whenever you have a user that inserts or updates a datetime value in the database, convert it to UTC and store the UTC value in the database column. Your data will be consistent. Then in the client's side, convert the UTC to the client's timezone.

## Database Schema Template

Convert this PostgreSQL schema to another database (e.g. MySQL):
- Run this template on a PostgreSQL database
- Introspect using prisma/sequelize to generate a schema file or models
- Change the database client in your .env file e.g. MySQL
- Push the generated prisma/sequelize schema to the target database

```sql
CREATE TYPE "user_types" AS ENUM ('administrator', 'standard');
CREATE TABLE "user" (
    "user_id" BIGSERIAL NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "user_type" user_types DEFAULT 'standard',
    PRIMARY KEY ("user_id")
);
CREATE TABLE "product" (
    "product_id" BIGSERIAL NOT NULL,
    "sku" VARCHAR(255) UNIQUE NOT NULL,
    "product_name" VARCHAR(255) NOT NULL,
    "cost" NUMERIC,
    "price" NUMERIC,
    PRIMARY KEY ("product_id")
);
CREATE TABLE "customer" (
    "customer_id" BIGSERIAL NOT NULL,
    "customer_name" VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY ("customer_id")
);
CREATE TABLE "order" (
    "order_id" BIGSERIAL NOT NULL,
    "customer_id" BIGINT NOT NULL,
    "order_date" TIMESTAMPTZ NOT NULL,
    PRIMARY KEY ("order_id"),
    CONSTRAINT "FK_order.customer_id" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id")
);
CREATE TABLE "order_product" (
    "id" BIGSERIAL NOT NULL,
    "order_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "FK_order_product.order_id" FOREIGN KEY ("order_id") REFERENCES "order"("order_id"),
    CONSTRAINT "FK_order_product.product_id" FOREIGN KEY ("product_id") REFERENCES "product"("product_id")
);
```

## SQL Data Types

1. **BIGSERIAL (BIGINT AUTO_INCREMENT in MySQL)**
    - **Examples**: `order_number`, `invoice_id`, `customer_id`, `ticket_id`, `reservation_id`
    - **Context**: Ideal for auto-incrementing primary keys in large tables, ensuring unique identifiers for each record.

2. **BIGINT (Same in MySQL)**
    - **Examples**: `foreign_order_id`, `foreign_product_id`, `foreign_customer_id`, `external_reference_id`, `linked_transaction_id`
    - **Context**: Suitable for referencing BIGSERIAL or BIGINT AUTO_INCREMENT primary keys from other tables, especially in large databases.

3. **UUID (Same in MySQL)**
    - **Examples**: `system_process_id`, `global_user_identifier`, `unique_payment_reference`, `distributed_transaction_id`, `cross_service_session_id`
    - **Context**: Ideal for globally unique identifiers, particularly in distributed systems or where collision avoidance is critical.

4. **VARCHAR(32) (Same in MySQL)**
    - **Examples**: `api_token`, `device_uuid`, `reference_code`, `short_url_key`, `activation_code`
    - **Context**: Used for storing fixed-size, unique strings like UUIDs, API keys, and other short identifiers.

5. **TEXT (Same in MySQL)**
    - **Examples**: `blog_post_content`, `customer_feedback`, `email_body`, `long_description`, `detailed_instructions`
    - **Context**: Ideal for fields requiring large or variable-length text data, such as descriptions, articles, or user-generated content.

6. **DECIMAL or NUMERIC (DECIMAL in MySQL)**
    - **Examples**: `product_price`, `monthly_salary`, `tax_amount`, `exchange_rate`, `mortgage_rate`
    - **Context**: Perfect for precise numerical values, especially in financial data, to avoid rounding errors and maintain accuracy.
    - **SQL**: `CREATE TABLE transactions ( amount DECIMAL(15, 2) );`

7. **FLOAT / DOUBLE (Same in MySQL)**
    - **Examples**: `gps_latitude`, `gps_longitude`, `temperature_reading`, `scientific_measurement`, `stock_price`
    - **Context**: Suitable for storing approximate floating-point numbers, with FLOAT for single precision and DOUBLE for double precision, used where exact precision is less critical.

8. **TIMESTAMP (Same in MySQL)**
    - **Examples**: `last_login_time`, `record_creation_date`, `email_sent_time`, `download_timestamp`, `subscription_start`
    - **Context**: Useful for tracking dates and times of various events or record changes, without time zone details.

9. **TIMESTAMPTZ (DATETIME in MySQL)**
    - **Examples**: `flight_departure_time`, `international_event_date`, `appointment_scheduled_at`, `global_webinar_start`, `multi_timezone_meeting`
    - **Context**: Essential for applications dealing with multiple time zones, as it includes time zone information for accuracy in scheduling and event management.

10. **BOOLEAN (TINYINT(1) in MySQL)**
    - **Examples**: `is_active_flag`, `email_verified_status`, `two_factor_authentication_enabled`, `newsletter_subscription_status`, `new_user_indicator`
    - **Context**: Commonly used in MySQL as a boolean type to represent small integers or boolean values like flags and statuses.

11. **TIMESTAMPTZ(6) (DATETIME(6) in MySQL)**
    - **Examples**: `high_precision_event_time`, `transaction_completed_at`, `system_log_timestamp`, `sensor_data_recorded_at`, `audit_trail_created_time`
    - **Context**: Ideal for storing dates and times with fractional seconds, useful in high-precision time recording applications like logging systems.

12. **ENUM (Same in MySQL)**
    - **Examples**: `order_status ('new', 'processing', 'shipped', 'delivered', 'cancelled')`, `account_type ('free', 'premium', 'enterprise', 'admin', 'guest')`, `ticket_priority ('low', 'medium', 'high', 'urgent', 'critical')`, `user_status ('active', 'inactive', 'suspended', 'deleted', 'pending')`, `product_category ('electronics', 'clothing', 'grocery', 'furniture', 'books')`
    - **Context**: Useful for fields with a limited and known set of values, ensuring data integrity and simplifying queries and analysis.

13. **JSONB (No direct equivalent in MySQL)**
    - **Examples**: `user_preferences_settings`, `e-commerce_product_attributes`, `log_event_details`, `metadata_for_assets`, `dynamic_form_responses`
    - **Context**: Chosen for its efficiency in storing and querying JSON data, particularly in applications requiring complex data structures and fast access.

14. **ARRAY (No direct equivalent in MySQL)**
    - **Examples**: `product_tags`, `contact_phone_numbers`, `email_recipients`, `survey_responses`, `skillset_keywords`
    - **Context**: Useful for storing multiple values in a single column, simplifying schema design and queries for data naturally fitting an array format, like tags or contacts.

15. **CHAR(n) (Same in MySQL)**
    - **Examples**: `country_iso_code ('US', 'CA', 'UK')`, `currency_iso_code ('USD', 'EUR', 'GBP')`, `state_abbreviation ('CA', 'TX', 'NY')`, `vehicle_license_plate`, `stock_exchange_symbol`
    - **Context**: Best suited for storing fixed-length character data, ensuring data consistency and efficiency for short, standard-format strings.

# =====================================
# Terraform

```
Tutorials:

	https://www.youtube.com/watch?v=rwel5eSm89g

	https://www.youtube.com/watch?v=iRaai1IBlB0

Terraform commands:
	Delete a specific resource:
		terraform destroy -target aws_db_instance.myDB -auto-approve

	Apply changes to state but doesn't recreate the VPC/Instance:
		terraform apply -refresh-only

	Override variables:
		terraform console -var="host_os=unix"
		
	Override variables using a variable file (for switching between development and production environment):
		terraform console -var-file="dev.tfvars"
		
	View state:
		terraform state list
		terraform state show <vpc.name>
		
	View state attribute:
		terraform state show aws_vpc.main.id
		
	View all states:
		terraform show
		
	Destroy a VPC:
		terraform destroy
		
	Destroy a VPC and yes to all:
		terraform destroy -auto-approve
		
	Apply VPC/Instance:
		terraform apply -auto-approve
		
	Replace VPC/Instance:
		terraform apply -replace="aws_instance.dev_node[0]" -auto-approve
		terraform apply -replace aws_instance.<name>
		terraform apply -replace aws_instance.<name> -auto-approve
		
	Format .tf files:
		terraform fmt

Sign in to aws:
	Create a User:
		IAM
		Create a new user
		Attach policies directly
		Check AdministratorAccess
		Create programmatic access
	Create Access Key:
		Go to the created user dashboard > Security Credentials
		Create access key
		Command Line Interface (CLI)
		Save the keys
	Enable console access:
		Go to the created user dashboard > Security Credentials
		Click Enable console access
		Enable
		Custom password
		
Docker Compose:
	volumes:
	  - ./terraform:/var/terraform
      - ~/.aws:/root/.aws
      - ~/.ssh:/root/.ssh
		
VSCode:
	Install AWS Toolkit extension
	Run: AWS: Create Credentials Profile in command palette
	Use access keys to create credential file located in (C:\Users\Jude\.aws)
	us-west-2 (Oregon)
	Install HashiCorp Terraform for syntax highlighting
	
Terraform Docker Container:
	*install AWS Toolkit extension
	terraform init
	*create VPC
	terraform plan
	terraform apply
	yes

	Run AWS: Show Resources...
	Check AWS::EC2::VPC
	Open terraform.tfstate and check if the settings match
	
Create EC2 Instance:
	Select an AMI
	Then go to EC2 Console > Images > AMIs
	Set filter to Public images
	Search for your chosen AMI
	Copy the following:
		AMI name
		Owner
```

# =====================================
# VIM

## Search file
```
/textToSearch + Enter
n or N to navigate
```

## Center cursor to screen
```
zz
```

## Scroll down (forward)
```
Ctrl + f
```

## Scroll up (backward)
```
Ctrl + b
```

## Copy selection
```
yy
```

## Copy entire line
```
yy
```

## Edit mode
```
a
```

## Save & Exit
```
ZZ
:wq!
:x
```

## Exit Without Saving
```
:q!
```

## Select All
```
ggVG
```

## Select All & Delete
```
ggVGd
```

## Delete Line Until the First Character
```
cc
```

## Delete Entire Line
```
dd
```

## Delete All 
```
dd
```

## Delete Current Word
```
dw
```

## Copy & Paste
```
yP
```

## Save Changes
```
:w
```

## Go to Start of Line
```
0
```

## Go to End of Line
```
$
```

## Go to Next Word
```
W
```

## Go to Previous Word
```
B
```

## Navigation
```
h
j
k
l
```

## Move to top of screen
```
H
```

## Move to middle of screen
```
H
```

## Move to bottom of screen
```
L
```

## Go to End of File
```
G$
```

## Append Next Line to the End of Current Line
```
J
```

## Insert a new line below the current line
```
Ctrl + ENTER
```

## Insert a new line above the current line
```
Ctrl + Shift + ENTER
```

## Select entire line
```
^vg_
```

# =====================================
# Visual Studio Code Keyboard Shortcuts

## Default

### Surround Code With
```
Ctrl =====> .
```

### Open Command Palette
```
Ctrl + Shift =====> P
```

### Search project
```
Ctrl + Shift =====> H
```

### Select all words that match your current selection
```
Ctrl + Shift + =====> L
```

### Open the directory of the currently opened file
```
Shift + Alt + =====> R
```

## Custom

### Git Status
```
Ctrl + Shift + Alt =====> ?
```

# =====================================
# Web Development

## Architecture

### Microservice Architecture
- separate backend (API) and frontent (client)
- can have many clients (web, desktop, mobile)

## Back End Tests
- Rearrange any table's column order and see of app still works

## Back End Roadmap:
- JSON schema validator (zod, ajv)
- WSL2 as linux environment. See WSL2 vs docker environment
- Single source of truth (SSOT) architecture, or single point of truth (SPOT) architecture
- Dependency injection
- Diffing algorithm: update only what's changed
- Serial processing; sequential processing
  - one process at a time to be processed
  - used when a process is dependent on another process's output (e.g. javascript's await, transactions)
- Parallel processing programming
- Bootstrapping (https://www.youtube.com/watch?v=hy0oieokjtQ)
  - runs on every request or page
  - service providers
  - register services
  - in laravel, use the boot() method
- Set up a server
  - accepts and parses json from front end
  - send json response to front end
- Load environment variables from .env file
- Create ERDs (Entity Relationship Diagram):
  - Lucidchart.com
- ORM
  - Raw query option with replacements/placeholder
  - Indexing for faster data retrieval
  - Database introspection: generate models from an existing database; convert or genereate models/migrations from existing database:
      - Sequelize-Auto
      - Prisma: npx prisma db push && npx prisma generate
  - Sync schema changes to the database; sync models/migrations settings to database structure:
      - Sequelize: Models.sequelize.sync();
      - Prisma: npx prisma db push && npx prisma generate
  - ACID, transactions, transaction rollback
  - auto increment
  - null
  - unique
  - define foreign key
  - constraints
  - migrations: stage schema changes; "database schema version control"
  - seeders
      *initial app data (app settings, admin users)
      *store app settings in the database
  - rename columns names without deleting data
  - change database structure without deleting data
- GraphQL:
  - combine different database queries (posgres & mongodb) in a single graphql query
    - https://www.youtube.com/watch?v=_trOqBZMJHQ
  - combine parent and junction table data in a single graphql query (e.g. order & order_products)
- Models
  - model must be singular, table name must be plural
  - must be connected to the database from the start
  - extends database wrapper to use CRUD functions
- Asynchronous functions
- Error handling
  - Try...throw...catch...finally block
- Connect to the database
- CRUD functions
  - prepared statements (replace ? with quoted/escaped values)
- Create a class that inherits database wrapper e.g. User class inherits CRUD methods/functions from Database class
- Routes
- REST API endpoints (GET, POST, DELETE, PUT, PATCH)
  - Handle CORS preflight requests (preflight sends OPTIONS request instead of POST)
      - switch (req.method) {
          case "POST":
            // Handle POST request
            break;
          default:
            // Handle OPTIONS (preflight) requests
            res.json({});
            break;
        }
  - Arrange API routes properly: declare dynamic routes at the top, static routes below (https://youtu.be/SccSCuHhOw0?t=1100)
  - API versioning (example.com/v1/users/posts)
  - allow only server's ip address or own domain to interact with the API. Restrict other websites, IP addresses, apps, etc.
  - use JWT (json web tokens) to protect endpoints and routes
  - return json response
  - return status (200)
- CORS
  - Allow all sites (development):
    - Access-Control-Allow-Origin "*"

  - Allow only specific sites (production):
    - Access-Control-Allow-Origin "https://www.example.com"
    
- Password hashing and checking
- Authentication
  - sessions
  - Auth0 for OAuth authentication
- Middleware
  - Global middleware: middleware to run during every HTTP request
  - Route middleware: middleware specific to certain routes e.g. Authentication middleware
  - chaining middlewares (one master middleware file and import other middlewares i.e. Laravel Kernel)
  - run code on every route visit
  - run code at the end of route visit
- Lambda functions (anonymous function)
- Closures
- Namespacing
- Caching
  - redis
  - memcached
- Decorators
- Method chaining (builder pattern)
  - must be readable and eloquent (see Laravel's Eloquent ORM)

  ```tsx
  $("example").toUpperCase().addQuotes().titleCase().fixSpelling()
  ```

- Upload large CSV file to mysql and postgres (100k rows)

## Front End Roadmap:
- Rendering:
  - Render object literal
  - Store `<option/>` value to state on change

- Reuse component logic; extract component logic into a reusable function (react custom hooks)
- Lifting up state vs redux
- React virtualized (react-virtualized): virtualized render; virtual rendering
- Optimistic updates
- Conditional rendering (avoid useEffect for checking authentication to prevent flashing the login page before the user page)
- Dynamic imports
- Inline assets load faster than downloaded ones
- Lighthouse (chrome) to optimize metrics (FCP && TTI)
- Toast messages
- Auth0 & OAuth
- Read URL slugs
- Page title controller middleware
- Debugger like laravel's dd(). var_dump() + die() combined
- Router:
  - get URL parameters (useSearchParams)
  - routes controller (react router)
  - dynamic titles
- CSRF/XSRF protection
- Render data as html to prevent running malicious scripts
- Templating
- SCSS
  - remove unused css
- Tree shaking
  - remove unused javascript
- State management
  - react useReducer
  - Redux:
    - Use cases:
      - passing value from unrelated components (another component is not a child/parent)
        
      
- AJAX:
    interceptor (request, response); see axios interceptor
- Login component (react, vue, angular)
- Lazy loading
- Load components/code on demand
- Bundling
    *code splitting

- Testing:
    - check if component renders based on prop value e.g. isLoggedIn
    - call functions inside components
    - get element's innerHTML and outerHTML
    - trigger events (click, keyboard keys)
    - access component/element attributes (id, class, data, etc.)
    - get element text content
    - access component state
    - get input element values (text, textarea, select, etc.)
    - gete form values
    - get children, sibling, grandparent count of components
    - get element type (div, span, h1, etc)
    - resolve promises
    
## Git Commit Messages (Semantic Commit Messages)

Tags: `git messages`

### Format

```
         T  Y  P  E               S  C  O P  E           S  U  B  J  E  C  T
<feat, fix, refactor, etc.>[optional scope (api, etc.)]: <description>

BODY

FOOTER
```
**! = important**

**`SCOPE` is optional**

### Examples

```
feat(api)!: send an email to the customer when a product is shipped
```

- `feat`: (new feature for the user, not a new feature for build script)
- `fix`: (bug fix for the user, not a fix to a build script)
- `docs`: (changes to the documentation)
- `style`: (formatting, missing semi colons, etc; no production code change)
- `refactor`: (refactoring production code, eg. renaming a variable)
- `test`: (adding missing tests, refactoring tests; no production code change)
- `chore`: (updating grunt tasks etc; no production code change)

## Testing
- Browser automation (google chrome recorder, selenium, puppeteer, cypress)
- Component testing
- Jest
- Mocha

## Coding Tools
- Linter
  
## Framework
- Generate controller
- Generate helper for controller
- Import helper function into the controller
- Create a "get" REST API route/endpoint using the controller
- Change CORS policy in the backend to enable requests

## Snippets
  
### Common

```
varText; stringVariable
varNumber; numberIntegerVariable
varDecimal; numberFloatVariable
varBoolean; booleanVariable
varObject; objectVariable
varEnum; objectLiteralVariable; constant; objectConstant
varArrayOfText; arrayOfStringsVariable
varArrayOfNumbers; arrayOfNumbersVariable
varArrayOfObjects; arrayOfObjectsVariable
class
function
ifStatement
ifStatements
ifElseStatement
switchCase
tryCatchFinallyBlock
forLoop; loop
whileLoop; loop
fetch
iterateArray
iterateArrayAndReturnNewArray
iterateObjects
iterateObjectProperties
compareStrings
compareNumbers
compareBooleans
compareArrays
compareObjects
log
logRed
logYellow
logGreen
logArray; logObject
logObjectProperty
combineStrings; concatenateStrings; stringCombination
stringer
stringerInterpolation; templateLiteral
debug
lambda; anonymous function; lambda expression; arrow function body
IIFE; self-invoking expression; self-calling expression; self-invoking function; self-calling function;
findObjectIndex
mutateObject
existsInArray; valueExistsInArray;
recursion
getObjectKeys
getObjectValues
appendToArray
prependToArray
removeFirstElementInArray
removeLastElementInArray
getArrayLength
getObjectLength
appendToObject
prependToObject
arrayToCSV
multilineString
builderPattern; methodChaining
import
export

TODOs:
convertStringsToArray - store every word in a string into an array; et table details using the strings from the array
convertLinesToArray - get the lines between delimiters and store in an array; check if lines contain specific keywords like UNIQUE NOT NULL
functionCall
getType
namespace
negate
ternary
isEqualTo
isGreaterThan
isLessThan
isGreaterOrEqualTo
isLessOrEqualTo
replaceString
convertToString
convertToNum
```

### Extras

#### React.js
```
boilerplate
useState
useStateExpensive; useStateLazy
```

#### TypeScript/JavaScript

```
exportDefault
alert
logToPage
logAsTable
server
functionArrow
interface
type
arrayValuesAsType
objectKeysAsType
objectKeysAsMappedType
objectValuesAsType
asyncLambda; async anonymous function; async lambda expression
asyncIIFE; self-invoking expression; self-calling expression; self-invoking function; self-calling function;
asyncFunction
asyncAwaitTryCatch
thenCatchFinally
tryCatchFinallyBlock
```

# =====================================


# API Generator

Tags: `generate rest api`, `generate restful api`, `generate api endpoints`, `generate endpoints`

```bash
#!/bin/bash

# Docker container details
CONTAINER_NAME="PostgreSQL"
DB_NAME="snippeter"
DB_USER="root"
DB_PASSWORD="123"
endpoints=()

# PostgreSQL connection URL (if you want to use URL)
DB_URL="postgresql://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME"

# Get the container ID of the running PostgreSQL container
container_id=$(docker ps -q --filter "name=${CONTAINER_NAME}")

# Check if the container is running
if [ -z "$container_id" ]; then
    if [ -z "$DB_URL" ]; then
        echo "PostgreSQL container is not running, and no URL is provided."
        exit 1
    fi
fi

# Determine whether to use URL or container-based connection
if [ -n "$container_id" ]; then
    # Using Docker container connection
    endpoints[0]=$(docker exec -i "$container_id" psql "$DB_URL" -t -c "\dt" | awk -F\| '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
else
    # Using URL connection
    endpoints[0]=$(psql "$DB_URL" -t -c "\dt" | awk -F\| '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
fi

# table_names=(${endpoints[0]})

# Convert string to array; convert space-separated strings to array; convert space separated strings to array
mapfile -t table_names <<< "${endpoints[0]}"

rm -rf src

# Base directory for API endpoints
base_dir="./src/app/api/v1"

# Create the base directory if it doesn't exist
mkdir -p "$base_dir"

# Function to create endpoint files
create_endpoint_files() {
    local endpoint=$1

    local dir_path="$base_dir/$endpoint"

    # Create directory for the endpoint
    mkdir -p "$dir_path"

    # Create files for CRUD operations
    # Route handler
    cat >"$dir_path/route.ts" <<-EOM
import { NextRequest, NextResponse } from 'next/server';

import GetHandler from './Get';
import PostHandler from './Post';
import PatchHandler from './Patch';
import PutHandler from './Put';
import DeleteHandler from './Delete';

export async function GET(req: NextRequest, res: NextResponse) {
  return GetHandler(req, res);
}
export async function POST(req: NextRequest, res: NextResponse) {
  return PostHandler(req, res);
}
export async function PATCH(req: NextRequest, res: NextResponse) {
  PatchHandler(req, res);
}
export async function PUT(req: NextRequest, res: NextResponse) {
  PutHandler(req, res);
}
export async function DELETE(req: NextRequest, res: NextResponse) {
  DeleteHandler(req, res);
}
EOM

    # Create
    cat >"$dir_path/Post.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
    const data = req.body;
    try {
        const result = await prisma.$endpoint.create({ data });
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: "Failed to create $endpoint." });
    }
}
EOM

    # Read
    cat >"$dir_path/Get.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
    try {
        const results = await prisma.$endpoint.findMany();
        res.status(200).json(results);
    } catch (error) {
        res.status(500).json({ error: "Failed to get $endpoint data." });
    }
}
EOM

    # Update
    cat >"$dir_path/Patch.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
    const { id, ...data } = req.body;
    try {
        const result = await prisma.$endpoint.update({
            where: { id },
            data
        });
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: "Failed to update $endpoint." });
    }
}
EOM

    cat >"$dir_path/Put.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
    const { id, ...data } = req.body;
    try {
        const result = await prisma.$endpoint.update({
            where: { id },
            data
        });
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: "Failed to update $endpoint." });
    }
}
EOM

    # Delete
    cat >"$dir_path/Delete.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';

export default async function handler(req: NextApiRequest, res: NextApiResponse): Promise<void> {
    const { id } = req.body;
    try {
        await prisma.$endpoint.delete({ where: { id } });
        res.status(200).json({ message: "$endpoint deleted successfully." });
    } catch (error) {
        res.status(500).json({ error: "Failed to delete $endpoint." });
    }
}
EOM
}

# Iterate over each endpoint and create necessary files
for table_name in "${table_names[@]}"; do
    create_endpoint_files "$table_name"
done

echo "API endpoint files have been generated."
```


# =====================================


# Directory Cloner

Tags: `clone directories`, `clone directory`, `copy directories`, `copy directory`

```bash
#!/bin/bash

source_folder_name="src"
ignore_directories=("node_modules" ".next") # Directories to ignore

folder_name_prefix="Copy of"

# Define the directory you want to recreate
directory_to_recreate="./$source_folder_name"

# Define the name of the script to be generated
script_name="$source_folder_name Cloner.sh"

# Check for existing copy of the directory and rename with incrementing numbers
copy_name="$folder_name_prefix $source_folder_name"
counter=1
while [ -d "$copy_name" ]; do
  let counter++
  copy_name="$folder_name_prefix $source_folder_name ($counter)"
done

# Ensure the directory exists
if [ -d "$directory_to_recreate" ]; then
  # Start writing the recreation script
  echo "#!/bin/bash" >"$script_name"
  # Echo the shebang line to ensure the script runs in bash

  # Create the top-level clone directory in the recreation script
  echo "mkdir -p \"$copy_name\"" >>"$script_name"

  # Recursively iterate over files and folders in the specified directory
  while IFS= read -r -d '' file; do
    skip=0
    for ignore_dir in "${ignore_directories[@]}"; do
      if [[ "$file" == *"$ignore_dir"* ]]; then
        skip=1
        break
      fi
    done

    if [[ $skip -eq 1 ]]; then
      continue
    fi

    # Extract the relative path from the original directory
    relative_path="${file#$directory_to_recreate/}"

    # Create the corresponding path in the cloned directory
    target_path="$copy_name/$relative_path"

    if [ -d "$file" ]; then
      # Create subdirectory command
      echo "mkdir -p \"$target_path\"" >>"$script_name"
    elif [ -f "$file" ]; then
      # Copy file with content command
      echo "cat << 'EOF' > \"$target_path\"" >>"$script_name"
      cat "$file" >>"$script_name"
      echo "" >>"$script_name" # Ensure there's a newline before EOF
      echo "EOF" >>"$script_name"
    fi
  done < <(find "$directory_to_recreate" -mindepth 1 -type d -print0 -o -type f -print0)

  # Make the recreation script executable
  chmod +x "$script_name"

  # Inform the user that the script has been generated
  echo "Directory recreation script '$script_name' has been generated."
else
  # Display an error message if the specified directory does not exist
  echo "Error: Directory '$directory_to_recreate' does not exist."
fi

sh "$script_name"
```

# =====================================


# Database Relationships: ERD Notation Examples

## 1. Mandatory One-to-Many (1:M)
- **Description**: A single entity on the "one" side is associated with multiple entities on the "many" side. This association is mandatory.
- **Notation**:
    ```
    ||-----|<  
    ```
- **Example**: Each parent has one or more children.
    ```
    (Parent) ||-----|< (Children)
    ```

## 2. Mandatory Many-to-One (M:1)
- **Description**: Multiple entities on the "many" side are associated with a single entity on the "one" side. This relationship is mandatory.
- **Notation**:
    ```
    >-----||
    ```
- **Example**: Multiple products are made by a single manufacturer.
    ```
    (Products) >-----|| (Manufacturer)
    ```

## 3. Mandatory Many-to-Many (M:N)
- **Description**: Entities on both sides can have multiple associations with entities on the other side.
- **Notation**:
    ```
    >-----|<  
    ```
- **Example**: Students can enroll in multiple courses, and each course can have multiple students.
    ```
    (Students) >-----|< (Courses)
    ```

## 4. Optional One-to-Many (1:M)
- **Description**: A single entity on the "one" side is associated with multiple entities on the "many" side, but the association is not mandatory for the "many" side.
- **Notation**:
    ```
    ||-----o|<  
    ```
- **Example**: An author may have written multiple books, but it's not mandatory for a book to have an associated author.
    ```
    (Author) ||-----o|< (Books)
    ```

## 5. Optional Many-to-One (M:1)
- **Description**: Multiple entities on the "many" side are associated with a single entity on the "one" side, but the association is not mandatory for the "many" side.
- **Notation**:
    ```
    >o-----||
    ```
- **Example**: A blog post may have multiple comments, but it's not mandatory for a comment to be associated with a blog post.
    ```
    (Comments) >o-----|| (BlogPost)
    ```

## 6. Optional Many-to-Many (M:N)
- **Description**: Entities on both sides can have multiple associations with entities on the other side, but these associations are not mandatory.
- **Notation**:
    ```
    >o-----o|<  
    ```
- **Example**: Customers can purchase multiple products, and products can be bought by multiple customers, but neither is mandatory.
    ```
    (Customers) >o-----o|< (Products)
    ```

## 7. Mandatory One-to-One (1:1)
- **Description**: Each entity on one side is associated with exactly one entity on the other side. This relationship is mandatory.
- **Notation**:
    ```
    ||-----||
    ```
- **Example**: Each user has exactly one set of user details.
    ```
    (User) ||-----|| (UserDetail)
    ```

## 8. Optional One-to-One (1:1)
- **Description**: Each entity on one side may be associated with at most one entity on the other side. This relationship is not mandatory.
- **Notation**:
    ```
    ||-----o||
    ```
- **Example**: A person may have at most one passport, but not everyone has a passport.
    ```
    (Person) ||-----o|| (Passport)
    ```

## 9. Mandatory Self-Referencing Relationship
- **Description**: An entity is associated with another entity of the same type. This relationship is mandatory.
- **Notation**:
    ```
    ||-----||
    ```
- **Example**: Every employee (except the top executive) reports to a manager, who is also an employee.
    ```
    (Employee) ||-----|| (Manager - also Employee)
    ```

# =====================================


# Programming Primitives in English

1. **Variable**
   - container
   - bin
   - box
   - spot
   - holder
   - pocket
   - storage
   - location
   - repository
   - placeholder

2. **String**
   - text
   - name
   - word
   - line
   - note
   - phrase
   - message
   - sentence
   - statement
   - expression

3. **Integer**
   - number
   - size
   - count
   - total
   - score
   - figure
   - amount
   - value
   - quantity
   - magnitude

4. **Float/Double**
   - decimal
   - bit
   - part
   - piece
   - point
   - segment
   - fraction
   - smallPart
   - decimalPoint
   - numberWithDecimals

5. **Boolean**
   - flag
   - on
   - off
   - check
   - marker
   - switch
   - toggle
   - yesNo
   - indicator
   - trueFalse

6. **Array**
   - list
   - row
   - chain
   - series
   - lineUp
   - sequence
   - grouping
   - collection
   - assemblage
   - compilation

7. **Object**
   - bundle
   - set
   - pack
   - thing
   - group
   - bunch
   - cluster
   - assembly
   - collection
   - composite

8. **Function/Method**
   - task
   - job
   - work
   - step
   - duty
   - chore
   - action
   - procedure
   - operation
   - activity

9. **Loop**
   - repeat
   - again
   - cycle
   - redo
   - goRound
   - iteration
   - recurrence
   - repetition
   - roundAbout
   - continuation

10. **IfStatement**
    - check
    - pick
    - maybe
    - choice
    - decide
    - test
    - question
    - inquiry
    - condition
    - examination

11. **Class**
    - blueprint
    - map
    - plan
    - idea
    - guide
    - pattern
    - template
    - design
    - model
    - structure

12. **Inheritance**
    - extension
    - gift
    - share
    - extra
    - addOn
    - legacy
    - passDown
    - succession
    - continuity
    - enhancement

13. **Interface**
    - agreement
    - deal
    - plan
    - rule
    - guide
    - pact
    - accord
    - contract
    - arrangement
    - understanding

14. **Exception**
    - error
    - oops
    - wrong
    - uhOh
    - glitch
    - fault
    - mistake
    - booBoo
    - oversight
    - anomaly

15. **Library/Module**
    - toolkit
    - set
    - pack
    - chest
    - tricks
    - collection
    - assortment
    - repository
    - compilation
    - resourceSet

16. **Constant**
    - constant
    - set
    - bin
    - stable
    - fixedValue
    - permanent
    - unchangeable
    - immutable
    - steady
    - established
    - invariant

17. **Enum (Enumeration)**
    - enum
    - set
    - pack
    - options
    - choiceSet
    - itemList
    - fixedList
    - valueRange
    - definedGroup
    - constantList
    - selectSet
    - namedConstants

18. **Queue**
    - queue
    - line
    - fifo
    - lineup
    - order
    - sequence
    - orderList
    - waitingLine
    - processOrder
    - serviceLine
    - firstInFirstOut

19. **Stack**
    - stack
    - pile
    - lifo
    - order
    - stackTop
    - collection
    - stackBottom
    - reverseOrder
    - layeredStructure
    - lastInFirstOut


# =====================================

# Dockerize Vite

Tags: `dockerize pnpm application`

```dockerfile
FROM node:alpine
WORKDIR /app
COPY . /app
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm run build
EXPOSE 3000
CMD node dist/index.js
```
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
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "seed" "pnpm dotenv -e .env.local -- pnpm prisma db seed" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma-push-schema" "pnpm dotenv -e .env.local -- pnpm prisma db push && pnpm prisma generate" &&
        editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma-pull-schema" "pnpm dotenv -e .env.local -- pnpm prisma db pull && pnpm prisma generate" &&

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
    complexity: ['error', 10],
    'max-depth': ['error', 4],
    'max-lines': ['error', 300],
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
DATABASE_URL="postgresql://postgres:<password>@db.<host>.supabase.co:<port>/<database>"

# Local MySQL
# DATABASE_URL="mysql://<username>:<password>@<host>:<port>/<database>"

# Local PostgreSQL
# DATABASE_URL="postgresql://<username>:<password>@<host>:<port>/<database>"

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

        # ==========CUSTOM SETTINGS========== #
        formatCode &&
        echo -e "\e[32mBig Bang was successfully scaffolded.\e[0m"
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
    complexity: ['error', 10],
    'max-depth': ['error', 4],
    'max-lines': ['error', 300],
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
# DATABASE_URL="postgresql://<username>:<password>@<host>:<port>/<database>"

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

# =====================================


# Coding Conventions & Best Practices

## Dos
- Object Parameter instead of individual arguments for readability

  Don't:
  ```typescript
  function calculateRectangleArea(length: number, width: number): number {
    return length * width;
  }
  
  // Unclear usage; values lack context and purpose
  const area = calculateRectangleArea(5, 10);
  ```
  
  Do:
  ```typescript
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
  ```js
  
  console.log("first" || "second");
  
  ```

  Execute "second" if left argument is true
  ```js
  
  console.log("first" && "second");
  
  ```
  
  Chaining: assign the first true to the variable
  ```js
  
  const x = false || false || "last condition";
  console.log(x); // Will output "last condition"
  
  ```
  
  
- Method chaining or builder pattern
  
  Class:
  ```typescript
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
  ```typescript
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
  
  ```typescript
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
<div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
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
```typescript
// customFetch.ts

type DataBody = BodyInit;

const ROOT_URL: string = 'http://localhost:3000/api/v1';

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
    let response: Response = await fetch(`${ROOT_URL}${url}`, finalOptions);
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

```typescript
// useFetchAPI.ts

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

```batch
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

```javascript
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


# File Handling Cheat Sheet

File Handling CheatSheet.ts
```typescript
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

    const { username, password } = formData;

    if (username && password) {
      console.log(JSON.stringify(formData, null, 4));
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

```batch
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
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
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

_Italic_ text.

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

| Left-Aligned | Center Aligned | Right Aligned |
| :----------- | :------------: | ------------: |
| 1            |   First Name   |     Last Name |

# =====================================

# Authentication Flow

*Tags: data flow*

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

**tokenUtils.js (Utils: Token Generation and Validation)**: Utility functions for generating and validating authentication tokens.

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

## Create An EC2 Instance Using AWS CloudShell

*Tags: create ec2 instance, create virtual machine, deploy application, create instance, create production instance*

1. Create instance

```bash
cd ~
curl -L https://raw.githubusercontent.com/judigot/references/main/AWS-Cloudshell-Bootstrap.sh | bash
cd terraform
terraform apply -auto-approve
```

Use env.development.tfvars (Uses free-tier t2.micro):

  ```bash
  terraform apply -auto-approve -var-file="env.development.tfvars"
  ```

  With database (RDS):

  ```bash
  terraform apply -auto-approve -var-file env.development.tfvars -var create_rds_instance=true
  ```

Use env.production.tfvars (Uses c5ad.large):

  ```bash
  terraform apply -auto-approve -var-file="env.production.tfvars"
  ```

  With database (RDS):

  ```bash
  terraform apply -auto-approve -var-file env.production.tfvars -var create_rds_instance=true
  ```

2. Add New SSH Keys to EC2 Instance

    *Tags: ssh to ec2 instance, add ssh to virtual machine, add ssh to aws ec2, add ssh to ec2, add access to ec2 instance, add new keys, append new ssh keys, append new keys, add ssh keys, append ssh keys, connect to ec2 instance, connect to virtual machine, access ec2 instance, add computer to ec2 instance, add machin to ec2 instance, add PC to ec2 instance*
    

    - Log in to EC2 instance using AWS CloudShell or a machine with prior access

    - On the new machine, generate a new key pair if not already done. Click [here](https://github.com/judigot/references?tab=readme-ov-file#generate-ssh-key-for-github) to generate SSH keys

    - Get the new machine's public key and append the it to `~/.ssh/authorized_keys`

      Public key should look something like `ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArJ7vI4t3yj+bgf6xvt0gCTs=`:

      Example:

        ```
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArJ7vI4t3yj+..." >> ~/.ssh/authorized_keys
        ```

    - SSH to EC2 Instance using the new machine

      ```bash
      ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@domain-name-or-ip-address # Skip prompt
      ssh -i ~/.ssh/id_rsa ubuntu@domain-name-or-ip-address
      ```

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

# PowerShell Scripting

## Generate Symlinks

*Tags: create symlinks*

```powershell
New-Item -ItemType SymbolicLink -Path "C:\User\Jude\Desktop\samplesymlink" -Target "C:\target\directory"
```

## Execute Remote Script from GitHub Using PowerShell

*Tags: execute remote github script, execute raw github script, execute github script remotely, execute github script, execute raw script, run remote script*

```bash
curl.exe -L "https://raw.githubusercontent.com/judigot/references/main/Apportable.ps1" | powershell -NoProfile -
```

## Download GitHub Repository

*Tags: download git repository using powershell, clone github repository, clone git repository, clone repository using powershell*

```powershell
$repositoryName = "inventory"
$branchName = "main"
$githubUser = "judigot"
$targetDirectory = "bigbang"
$repositoryURL = "https://github.com/$githubUser/$repositoryName"

# Ensure target directory exists
if (-not (Test-Path -Path $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory
}

# Download the ZIP file
$zipFilePath = "$targetDirectory\$repositoryName.zip"
curl.exe -L "$repositoryURL/archive/refs/heads/$branchName.zip" -o $zipFilePath

# Extract the ZIP file and remove it if extraction is successful
try {
    Expand-Archive -Force -Path $zipFilePath -DestinationPath $targetDirectory
    Remove-Item -Path $zipFilePath
} catch {
    Write-Error "Extraction failed: $_"
    exit 1
}

# Move contents of the nested directory to the target directory and clean up
$nestedDirPath = Join-Path -Path $targetDirectory -ChildPath "$repositoryName-$branchName"

if (Test-Path -Path $nestedDirPath) {
    Get-ChildItem -Path $nestedDirPath -Recurse | Move-Item -Destination $targetDirectory -Force
    Remove-Item -Path $nestedDirPath -Force -Recurse
} else {
    Write-Error "The extracted directory '$nestedDirPath' does not exist."
    exit 1
}
```

# =====================================

# Bash Scripting

## Sync Directories

*Tags: synchronize directories, synchronize directory, sync directories, sync directory, synchronize folders, sync folders, synchronize files, sync files*

```bash
#!/bin/bash

# Define the source and destination directories as variables
SOURCE_DIR="/home/ubuntu/app"      # Directory to monitor for changes
DEST_DIR="/var/www/html"           # Directory to sync changes to

# Monitor the source directory for changes and sync with the destination directory
while inotifywait -r -e modify,create,delete,move "$SOURCE_DIR"; do
    rsync -av --delete "$SOURCE_DIR/" "$DEST_DIR/"
done
```

### Run the Script

```bash
sudo chmod +x ./sync_files.sh
sudo nohup ./sync_files.sh &
tail -f nohup.out           # Check the Output: By default, nohup redirects output to nohup.out. You can view the output and logs with:
```

### Kill the Process

Command to Output the Processes the Uses the Sync Script

```bash
ps aux | grep sync_files.sh     # Verify that the script is running: You can check if the script is running by listing the background processes:
```

Output

```
root       15777  0.0  0.1  11896  5376 pts/0    S    02:06   0:00 sudo nohup ./sync_files.sh
root       15778  0.0  0.0  11896  2300 pts/1    Ss+  02:06   0:00 sudo nohup ./sync_files.sh
root       15779  0.0  0.0   7764  3328 pts/1    S    02:06   0:00 /bin/bash ./sync_files.sh
ubuntu     15810  0.0  0.0   7012  2304 pts/0    S+   02:13   0:00 grep --color=auto sync_files.sh
```

Process to Kill
```
root       15779  0.0  0.0   7764  3328 pts/1    S    02:05   0:00 /bin/bash ./sync_files.sh
```

Kill the Process

```bash
sudo kill 15779
```

## Add An Empty Commit

*Tags: allow empty commit, allow blank commit, empty commit, blank commit, no commit*

```bash
git commit --allow-empty -m "Add blank Nx project"
git push origin
git status
```

## Modify JSON Using Bash

*Tags: modify package.json, edit package.json, modify json using bash, edit json using bash*

```bash
#!/bin/bash

main() {
    declare -A propertyValues=(
        ["db:reset-with-data"]="reset with data"
        ["db:seed"]='(\\ \"\") Use single quotes to escape backlash and double quotes'
    )
    declare -A data=(
        [property]="scripts"
        [values]="propertyValues"
    )
    modifyJSON "package.json" data
    modifyJSON "public/package.json" data
}

modifyJSON() {
    local file=$1
    declare -n new_data=$2
    local property=${new_data[property]}
    declare -n values=${new_data[values]}

    new_property_json="  \"$property\": {"
    for key in "${!values[@]}"; do
        escaped_value=$(printf '%s\n' "${values[$key]}" | sed 's/\\/\\\\/g; s/"/\\"/g')
        new_property_json+="\n    \"$key\": \"$escaped_value\","
    done
    new_property_json="${new_property_json%,}\n  },"

    awk -v new_property="$new_property_json" '
    BEGIN { mode = 0 }
    /"'"$property"'": \{/ { print new_property; mode = 1; next }
    mode == 1 && /^\s*\}/ { mode = 0; next }
    mode == 1 { next }
    { print }
    ' "$file" >"${file}.tmp"

    mv "${file}.tmp" "$file"
    echo "$file updated successfully"
}

main
```

## Download GitHub Repository

*Tags: download github files using bash, download github folder, download specific repository files using bash, download specific files using bash, download git repository using bash, clone github repository, clone git repository, clone repository using bash, github folder downloader, repository folder downloader, download repository folder*

```bash
#!/bin/bash

main() {
    filesArray=(".bashrc" "templates/node.js/backend") # Usage 1
    declare -A dataArray=(
        [repository]="references"
        [user]="judigot"
        [branch]="main"
        [files]="filesArray"
        [retainFolderStructure]=true
        [createRepoFolder]=true
    )
    downloadGithubFiles dataArray
    mkdir -p src && cp -r references/templates/node.js/backend/* src
    rm -rf references
}

downloadGithubFiles() {
    # Usage
    # filesArray=(".bashrc" "src/Sample text.txt") # Usage 1
    # filesArray=(".bashrc" "src")                 # Usage 2
    # filesArray=("*")                             # Usage 3
    # declare -A dataArray=(
    #     [repository]="references"
    #     [user]="judigot"
    #     [branch]="main"
    #     [files]="filesArray"
    #     [retainFolderStructure]=true
    # )
    # downloadGithubFiles dataArray

    local -n data="$1"
    local repo=${data[repository]}
    local user=${data[user]}
    local branch=${data[branch]}
    local retainFolderStructure=${data[retainFolderStructure]}
    local createRepoFolder=${data[createRepoFolder]}
    local -n files=${data[files]}

    arrayToCSV() {
        local -n array="$1"
        local csv=""
        for item in "${array[@]}"; do
            csv+="$item,"
        done
        csv="${csv%,}" # Remove the trailing comma
        echo "$csv"
    }
    filesCSV=$(arrayToCSV files)

    IFS=',' read -r -a filesArray <<<"$filesCSV"

    urlEncode() {
        local string="$1"
        local encoded=""
        for ((i = 0; i < ${#string}; i++)); do
            local c="${string:$i:1}"
            case "$c" in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            ' ') encoded+="%20" ;;
            '"') encoded+="%22" ;;
            '#') encoded+="%23" ;;
            '&') encoded+="%26" ;;
            "'") encoded+="%27" ;;
            '(') encoded+="%28" ;;
            ')') encoded+="%29" ;;
            '+') encoded+="%2B" ;;
            ',') encoded+="%2C" ;;
            ';') encoded+="%3B" ;;
            '=') encoded+="%3D" ;;
            '@') encoded+="%40" ;;
            '[') encoded+="%5B" ;;
            ']') encoded+="%5D" ;;
            '{') encoded+="%7B" ;;
            '}') encoded+="%7D" ;;
            *) encoded+="$(printf '%%%02X' "'$c")" ;;
            esac
        done
        echo "$encoded"
    }

    download_zip() {
        curl -L "$1" -o "$2"
    }

    extract_zip() {
        if command -v unzip >/dev/null 2>&1; then
            unzip -q "$1"
        elif command -v 7z >/dev/null 2>&1; then
            7z x "$1" -aoa
        elif command -v winrar >/dev/null 2>&1; then
            winrar x "$1" >/dev/null
        elif command -v winzip >/dev/null 2>&1; then
            winzip -e "$1" >/dev/null
        else
            echo "Error: No suitable extraction tool found."
            exit 1
        fi
    }

    clean_up() {
        [ -e "$1" ] && rm -rf "$1" && echo "Deleted $1" || echo "$1 does not exist."
    }

    move_files() {
        local source=""
        local destination=""
        local extracted_folder_name="$1"

        if [ "$createRepoFolder" = true ]; then
            mkdir -p "$repo"
        fi

        if [ "${filesArray[0]}" = "*" ]; then
            if [ "$createRepoFolder" = true ]; then
                cp -r "$extracted_folder_name/"* "$repo/"
                echo -e "\e[32mCopied all files from the repository to \"$repo\"\e[0m"
            else
                cp -r "$extracted_folder_name/"* "./"
                echo -e "\e[32mCopied all files from the repository to the root folder\e[0m"
            fi
        else
            for file_path in "${filesArray[@]}"; do
                local file_name="$(basename "$file_path")"
                local extracted_file_path="$extracted_folder_name/$file_path"

                if [ -e "$extracted_file_path" ]; then
                    if [ "$retainFolderStructure" = true ]; then
                        if [ "$createRepoFolder" = true ]; then
                            mkdir -p "$repo/$(dirname "$file_path")"
                            source="$extracted_file_path"
                            destination="$repo/$file_path"
                        else
                            mkdir -p "$(dirname "$file_path")"
                            source="$extracted_file_path"
                            destination="$file_path"
                        fi
                    else
                        if [ "$createRepoFolder" = true ]; then
                            source="$extracted_file_path"
                            destination="$repo/$file_name"
                        else
                            source="$extracted_file_path"
                            destination="./$file_name"
                        fi
                    fi

                    echo -e "\e[32mCopying $source to $destination...\e[0m"
                    cp -r "$source" "$destination"
                else
                    echo "Error: The file '$file_path' does not exist in the extracted directory."
                    rm -rf "$extracted_folder_name"
                    exit 1
                fi
            done
        fi
    }

    zip="$repo.zip"
    nested="$repo-$branch"
    url="https://github.com/$user/$repo/archive/refs/heads/$branch.zip"

    download_zip "$url" "$zip"
    extract_zip "$zip"
    move_files "$nested"
    clean_up "$zip"
    clean_up "$nested"
}

main
```

## Download Specific GitHub Files

*Tags: download github files using bash, download specific repository files using bash, download specific files using bash*

```bash
downloadIndividualGithubFiles() {
    # Usage:
    # filesArray=("src/Sample File.txt", ".bashrc")
    # declare -A dataArray=(
    #     [repository]="references"
    #     [user]="judigot"
    #     [branch]="main"
    #     [files]="filesArray"
    #     [retainFolderStructure]=true
    # )
    # downloadLatestFileVersion dataArray

    local -n data="$1"
    local repo=${data[repository]}
    local user=${data[user]}
    local branch=${data[branch]}
    local retainFolderStructure=${data[retainFolderStructure]}
    local -n files=${data[files]}

    arrayToCSV() {
        local -n array="$1"
        local csv=""
        for item in "${array[@]}"; do
            csv+="$item,"
        done
        csv="${csv%,}" # Remove the trailing comma
        echo "$csv"
    }
    filesCSV=$(arrayToCSV files)

    IFS=',' read -r -a filesArray <<<"$filesCSV"

    urlEncode() {
        local string="$1"
        local encoded=""
        for ((i = 0; i < ${#string}; i++)); do
            local c="${string:$i:1}"
            case "$c" in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            ' ') encoded+="%20" ;;
            '"') encoded+="%22" ;;
            '#') encoded+="%23" ;;
            '&') encoded+="%26" ;;
            "'") encoded+="%27" ;;
            '(') encoded+="%28" ;;
            ')') encoded+="%29" ;;
            '+') encoded+="%2B" ;;
            ',') encoded+="%2C" ;;
            ';') encoded+="%3B" ;;
            '=') encoded+="%3D" ;;
            '@') encoded+="%40" ;;
            '[') encoded+="%5B" ;;
            ']') encoded+="%5D" ;;
            '{') encoded+="%7B" ;;
            '}') encoded+="%7D" ;;
            *) encoded+="$(printf '%%%02X' "'$c")" ;;
            esac
        done
        echo "$encoded"
    }

    for file in "${filesArray[@]}"; do
        local encoded_file=$(urlEncode "$file")
        local url="https://raw.githubusercontent.com/$user/$repo/$branch/$encoded_file"
        if [ "$retainFolderStructure" = true ]; then
            local output="$file"
            mkdir -p "$(dirname "$output")"
        else
            local output=$(basename "$file")
        fi
    done
}
```

## Replace File

*Tags: replace local file, update local file from github*

```bash
curl -s https://raw.githubusercontent.com/judigot/vscode/main/.bashrc -o ~/.bashrc
```

## Pause Script

*Tags: pause bash script, pause shellscript, pause shell script, stop bash script, stop shellscript, stop shell script*

```bash
read -n 1 -s -r -p "Press any key to continue..."
```

## Add New SSH Keys to EC2 Instance

*Tags: add new keys, append new ssh keys, append new keys, add ssh keys, append ssh keys*

1. Download the key pair (.pem) from the AWS EC2 Key Pairs page

   [https://console.aws.amazon.com/ec2/home#KeyPairs:](https://console.aws.amazon.com/ec2/home#KeyPairs:)

2. Save the downloaded key to `~/.ssh` on your local machine

3. Set permissions to users only

   ```bash
   chmod 400 ~/.ssh/new_key.pem
   ```

4. Generate a public key from the private key

   ```bash
   ssh-keygen -y -f ~/.ssh/new_key.pem
   ```

5. Append the generated public key to `~/.ssh/authorized_keys`

   ```
   echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys
   ```

6. SSH to EC2 Instance
   ```bash
   ssh -i ~/.ssh/new_key.pem ubuntu@domain-name-or-ip-address
   ```

## Extract HTML Attribute Using Inner Text

*Tags: extract html attribute using innerText, extract attribute using innerText*

```bash
#!/bin/bash

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

echo -e "\e[32m$hrefValue\e[0m" # Green
```

## Extract Version from GitHub Repository

*Tags: extract innerHTML, get innerHTML, extract version number from github, get version number from github, get version from github*

```bash
#!/bin/bash

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
versionNumber="${versionString:1}"
echo $versionNumber
```

## Get HTML Attribute From Text Content

```bash
#!/bin/bash

# Fetch the webpage content
htmlContent=$(curl -s https://git-scm.com/download/win)

# Define the text content you're searching for in a variable
textContent="64-bit Git for Windows Portable"

# Use grep and sed to find the href attribute of the link with the specified text content
downloadLink=$(echo "$htmlContent" | grep -oP "href=\"\K[^\"]*(?=\"[^>]*>$textContent)" | head -n 1)

# Output the download link
echo $downloadLink
```

## HTTP Request

*Tags: fetch, curl, fetch request using curl, fetch request using bash, fetch using bash, fetch using curl, curl fetch, fetch curl*

```bash
result=$(
    URL="http://localhost:5000/api/v1/helloworld"
    auth=$(printf "admin:123" | base64) # Java Spring Boot
    JWT_token="0123456789"              # JSON Web Token
    response=$(
        curl -sL -X \
            GET \
            "$URL" \
            -H "Accept: application/json, text/plain, */*" \
            -H "Content-Type: application/json" \
            -H "Authorization: Basic $auth" \
            -H "Authorization: Bearer $JWT_token" \
            -d '{"key1":"value1", "key2":"value2"}' # For POST, PATCH, and PUT requests
    )
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

*Tags: generate ssh keys for github, create ssh keys for github, generate ssh keys for aws, create ssh keys for aws, generate pem files for aws, create pem files for aws, generate pem file for aws, create pem file for aws*

GitHub SSH Keys:
```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P "" && chmod 600 ~/.ssh/id_rsa && clear && echo -e "Copy and paste the public key below to your GitHub account:\n\n\e[32m$(cat ~/.ssh/id_rsa.pub) \e[0m\n" # Green
```

AWS SSH Keys:
```bash
ssh-keygen -t rsa -b 2048 -m PEM -f ~/.ssh/aws.pem -P ""
ssh-keygen -y -f ~/.ssh/aws.pem > ~/.ssh/aws.pem.pub
```

## Test SSH Key

```bash
ssh -T git@github.com -o StrictHostKeyChecking=no # Skip answering yes
```

## Generate SSL using Certbot - HTTPS
*Tags: 443, add SSL certifiicate, add certificate, add https, setup SSL certificate, setup certificate, setup https*

```bash
apt install -y python3-certbot-nginx
certbot --nginx -d example.com -d www.example.com
certbot --nginx -d app.example.com -d www.app.example.com

# Auto-renew the SSL certificate (Certbot automatically installs a cron job for this)
certbot renew --dry-run
# *keys are located in /etc/letsencrypt
```

## Check Linux Distro and Version

```bash
cat /etc/*-release
```

## Copy Files and Directories

### Copy Files

*Tags: copy folders, copy and paste folders, copy directories, copy and paste directory, copy and paste directories*

```bash
cp src dest
```

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

*Tags: allow editing permission, allow edit permission*

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
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@domain-name-or-ip-address # Skip prompt
ssh -i ~/.ssh/id_rsa ubuntu@domain-name-or-ip-address
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

*Tags: execute remote github script, execute raw github script, execute github script remotely, execute github script, execute raw script, run remote script*

```bash
curl -L https://raw.githubusercontent.com/judigot/references/main/AWS-Cloudshell-Bootstrap.sh | bash
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

PRODUCTION_DEPENDENCIES=(
    "axios"
    "@tanstack/react-query"
    "dotenv"
    "dotenv-expand"
)

DEV_DEPENDENCIES=(
    "cross-env"
    "prettier"

    "dotenv-cli"
    "esbuild"
    "esbuild-register"
    "vite-tsconfig-paths"
    "vitest"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"
readonly PACKAGE_JSON_PATH="$PROJECT_DIRECTORY/package.json"

main() {
    echo -e "\e[32mInitializing...\e[0m"
    downloadNextJS
    createEnv
    createEnvExample
    deleteFiles "css"
    codeToBeRemoved=("import { Inter } from 'next/font/google'" "import './globals.css'" " className={inter.className}")
    removeTextContent "codeToBeRemoved[@]"
    # codeToBeRemoved=("import reactLogo from './assets/react.svg'" "import viteLogo from '/vite.svg'")
    # removeTextContent "codeToBeRemoved[@]"
    directories=("components" "helpers" "styles" "tests" "types" "utils")
    createDirectories "$PROJECT_DIRECTORY/src" "directories[@]"
    removeBoilerplate
    removeLayoutBoilerplate

    # ==========CUSTOM SETTINGS========== #
    # Strict mode
    createPrettierRc
    modifyESLintConfig
    codeToBeRemoved=(".tsx")
    removeTextContent "codeToBeRemoved[@]"
    local strictPackages=("@typescript-eslint/eslint-plugin" "@typescript-eslint/parser" "eslint-config-prettier" "eslint-plugin-jsx-a11y" "eslint-plugin-prettier" "eslint-plugin-react" "eslint-plugin-react-hooks" "eslint-plugin-react-refresh")
    append_dependencies "development" strictPackages DEV_DEPENDENCIES

    # tsconfig.node.json
    addStrictNullChecks

    # Testing
    # Jest
    local jestPackages=("jest" "@types/jest" "jest-environment-jsdom" "@testing-library/react" "@testing-library/jest-dom")
    append_dependencies "development" jestPackages DEV_DEPENDENCIES
    createJestConfig

    # Vitest
    # local vitestPackages=("vitest" "@vitejs/plugin-react" "jsdom" "@testing-library/react")
    # append_dependencies "development" "vitestPackages[@]"
    # createJestConfig

    # Prisma
    local devPrismaPackages=("prisma")
    append_dependencies "development" devPrismaPackages DEV_DEPENDENCIES
    local prodPrismaPackages=("@prisma/client")
    append_dependencies "production" prodPrismaPackages PRODUCTION_DEPENDENCIES
    prependToTextContent "$PROJECT_DIRECTORY/package.json" "\"dependencies\": {" "$(
        cat <<EOF
"prisma": {
    "seed": "node -r esbuild-register ./src/prisma/seed/seed.ts",
    "schema": "src/prisma/schema.prisma"
},
EOF
    )"

    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset-with-data" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push && pnpm dotenv -e .env.local -- pnpm run db:seed"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:seed" "pnpm dotenv -e .env.local -- pnpm prisma db seed"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:drop" "pnpm dotenv -e .env.local -- node -r esbuild-register ./src/prisma/scripts/DeleteTables.ts"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:push" "pnpm dotenv -e .env.local -- pnpm prisma db push && pnpm prisma generate"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:pull" "pnpm dotenv -e .env.local -- pnpm prisma db pull && pnpm prisma generate"

    # ==========CUSTOM SETTINGS========== #
    installAddedPackages
    formatCode

    cd "$PROJECT_DIRECTORY" && pnpm prisma init --datasource-provider postgresql
    mv "$PROJECT_DIRECTORY/prisma" "$PROJECT_DIRECTORY/src"
    echo -e "\e[32mBig Bang successfully scaffolded.\e[0m"
}

append_dependencies() {
    cd "$PROJECT_DIRECTORY" || return

    local env=$1
    local -n packages=$2
    local -n existing_packages=$3
    local install_list=""

    # Extract dependencies and devDependencies sections
    local dependencies_section
    dependencies_section=$(awk '/"dependencies": {/,/}/' "$PACKAGE_JSON_PATH")
    local devDependencies_section
    devDependencies_section=$(awk '/"devDependencies": {/,/}/' "$PACKAGE_JSON_PATH")

    for package in "${packages[@]}"; do
        # Check if the package exists in dependencies or devDependencies sections
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
            install_list+="$package "
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    if [ "$env" = "production" ]; then
        existing_packages+=($install_list)
    elif [ "$env" = "development" ]; then
        existing_packages+=($install_list)
    else
        echo -e "\e[31mInvalid environment specified. Use 'production' or 'development'.\e[0m"
        return 1
    fi
}

editJSON() {
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

prependToTextContent() {
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

createJestConfig() {
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

createVitestConfig() {
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

addStrictNullChecks() {
    cd "$PROJECT_DIRECTORY" || return

    replaceLineAfterMatch "tsconfig.json" '"compilerOptions": {' ""strictNullChecks": true,"
}

addVitestReference() {
    cd "$PROJECT_DIRECTORY" || return

    prependToPreviousLineIndex "vite.config.ts" 0 "$(
        cat <<EOF
/// <reference types="vitest" />
EOF
    )"

}

createAppTSX() {
    cd "$PROJECT_DIRECTORY/src/app" || return

    local content=""
    local fileName="App.tsx"

    content=$(
        cat <<EOF
import React from 'react';

App(): JSX.Element {
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

createPrettierRc() {
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

modifyESLintConfig() {
    # rm .eslintrc.cjs

    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".eslintrc.cjs"

    content=$(
        cat <<EOF
module.exports = {
  root: true,
  settings: {
    react: {
      version: 'detect',
    },
  },
  env: {browser: true, es2020: true},
  extends: [
    'eslint:recommended',
    'plugin:react-hooks/recommended',

    'plugin:@typescript-eslint/strict-type-checked', // Very strict!
    'plugin:@typescript-eslint/stylistic-type-checked', // Very strict!

    'plugin:react/recommended',
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
    'no-console': ['error', { allow: ['warn', 'error'] }], // Disable all console outputs except console.warn and console.error
    'arrow-body-style': ['error', 'as-needed'],
    'react/react-in-jsx-scope': 'off',
    // '@typescript-eslint/explicit-function-return-type': 'error',
    '@typescript-eslint/no-unnecessary-boolean-literal-compare': ['error'],
    '@typescript-eslint/no-unused-vars': [
      'error',
      { args: 'all', argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
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

createFile() {
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

downloadNextJS() {
    cd "$ROOT_DIRECTORY" || return

    # Check if the project already exists
    if [ -d "$PROJECT_NAME" ]; then
        rm -rf $PROJECT_NAME
    fi

    pnpm create next-app $PROJECT_NAME --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/* --turbopack

    # Check if the file was created successfully
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "\e[32mProject $PROJECT_NAME successfully scaffolded.\e[0m" # Green
    else
        echo -e "\e[31mProject $PROJECT_NAME failed to scaffold.\e[0m" # Red
    fi
}

deleteFiles() {
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

removeTextContent() {
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

removeBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="page.tsx"
    local content=""

    content=$(
        cat <<EOF
"use client";

import { useState } from "react";

function Home() {
  const [count, setCount] = useState(0);

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

export default Home;
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

removeLayoutBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="layout.tsx"
    local content=""

    content=$(
        cat <<EOF
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Create Next App',
  description: 'Generated by create next app',
};
function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
export default RootLayout;
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

createDirectories() {
    cd "$PROJECT_DIRECTORY/src" || return

    local directories=("${!2}")

    for value in "${directories[@]}"; do
        mkdir "$value"
        touch "$value/.gitkeep"

        echo -e "\e[32mFolder \e[33m$value\e[0m was successfully created.\e[0m" # Green

    done

}

installDefaultPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm install

    echo -e "\e[32mDefault packages were successfully installed.\e[0m" # Green

}

formatCode() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm prettier --write . --log-level silent

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSuccessfully formatted files.\e[0m" # Green
    else
        echo -e "\e[31mFailed to format files.\e[0m" # Red
    fi

}

removeSetting() {
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

vite.config.ts__________addBasePath() {
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

vite.config.ts__________addTestConfig() {
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
replaceLineAfterMatch() {
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

prependToPreviousLineIndex() {
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

appendToTextContentIndex() {
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

createEnv() {
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

NODE_ENV="development"

VITE_FRONTEND_URL="http://localhost:3000"
VITE_BACKEND_URL="http://localhost:5000"
VITE_API_URL="api"

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

createEnvExample() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName=".env.example"
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

NODE_ENV="development"

VITE_FRONTEND_URL="http://localhost:3000"
VITE_BACKEND_URL="http://localhost:5000"
VITE_API_URL="api"

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

installAddedPackages() {
    cd "$PROJECT_DIRECTORY" || return

    local all_dev_dependencies=()
    local all_prod_dependencies=()

    # Extract dependencies and devDependencies sections
    local dependencies_section
    dependencies_section=$(awk '/"dependencies": {/,/}/' "$PACKAGE_JSON_PATH")
    local devDependencies_section
    devDependencies_section=$(awk '/"devDependencies": {/,/}/' "$PACKAGE_JSON_PATH")

    # Check for new and existing dev dependencies
    for package in "${DEV_DEPENDENCIES[@]}"; do
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
            all_dev_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    # Check for new and existing prod dependencies
    for package in "${PRODUCTION_DEPENDENCIES[@]}"; do
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
            all_prod_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    pnpm install -D ${all_dev_dependencies[*]} &&
        pnpm install ${all_prod_dependencies[*]}
}
# ====================HELPER FUNCTIONS==================== #

main
```

# =====================================

# Big Bang Vite

Execute script remotely

```bash
curl -L "https://raw.githubusercontent.com/judigot/references/main/BigBangVite.sh" | bash
```

# =====================================

# Big Bang Spring Boot

```bash
#!/bin/bash

# Load helper functions remotely
source <(curl -fsSL "https://raw.githubusercontent.com/judigot/references/main/FileHandlingHelpers.sh")

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="bigbang"

readonly DEPENDENCIES=(
    "actuator"
    "data-jpa"
    "lombok"
    "postgresql"
    "security"
    "validation"
    "web"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"

main() {
    echo -e "\e[32mInitializing...\e[0m"

    downloadSpringBoot
    directories=("controller" "model" "repository" "service" "config")
    createDirectories "$PROJECT_DIRECTORY/src/main/java/com/example/$PROJECT_NAME" "directories[@]"
    directories=("v1")
    createDirectories "$PROJECT_DIRECTORY/src/main/java/com/example/$PROJECT_NAME/controller" "directories[@]"
    createHelloWorldController
    createCorsConfig
    editAppProperties

    echo -e "Big Bang successfully scaffolded."
}

createCorsConfig() {
    cd "$PROJECT_DIRECTORY/src/main/java/com/example/$PROJECT_NAME/config" || return
    current_dir=$(basename "$PWD")

    local htmlFileName="CorsConfig.java"
    local content=""
    content=$(
        cat <<EOF
package com.example.$PROJECT_NAME.$current_dir;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(@NonNull CorsRegistry registry) {
                registry.addMapping("/api/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "HEAD")
                        .allowedHeaders("*");
            }
        };
    }
}
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

createHelloWorldController() {
    cd "$PROJECT_DIRECTORY/src/main/java/com/example/$PROJECT_NAME/controller/v1" || return
    current_dir=$(basename "$PWD")

    local htmlFileName="HelloWorldController.java"
    local content=""
    content=$(
        cat <<EOF
package com.example.$PROJECT_NAME.controller.$current_dir;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/v1")
public class HelloWorldController {

    @Value("\${BIGBANG_MESSAGE}")
    private String BIGBANG_MESSAGE;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/helloworld")
    public Map<String, String> helloWorld() {
        Map<String, String> response = new HashMap<>();
        response.put("message", BIGBANG_MESSAGE);
        return response;
    }

    @GetMapping("/users")
    public List<Map<String, Object>> getAllUsers() {
        String sql = """
            SELECT * FROM users;
        """;
        return jdbcTemplate.queryForList(sql);
    }
}
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

editAppProperties() {
    cd "$PROJECT_DIRECTORY/src/main/resources" || return

    appendToFile "application.properties" "$(
        cat <<EOF

spring.datasource.url=jdbc:postgresql://localhost:5432/snippetboss
spring.datasource.username=root
spring.datasource.password=123
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Spring Security default user credentials
spring.security.user.name=admin
spring.security.user.password=123

# Change the default server port
server.port=5000

BIGBANG_MESSAGE=Hello, World!
EOF
    )"
}

downloadSpringBoot() {
    local dependencies=""
    dependencies=$(
        IFS=,
        echo "${DEPENDENCIES[*]}"
    )

    curl https://start.spring.io/starter.zip \
        -d type=maven-project \
        -d language=java \
        -d bootVersion=3.2.5 \
        -d baseDir=$PROJECT_NAME \
        -d groupId=com.example \
        -d artifactId=$PROJECT_NAME \
        -d name=BigBang \
        -d description="Demo project for Spring Boot Backend" \
        -d packageName=com.example.$PROJECT_NAME \
        -d packaging=jar \
        -d javaVersion=21 \
        -d dependencies="$dependencies" \
        -o $PROJECT_NAME.zip

    if command -v unzip >/dev/null 2>&1; then
        unzip "$PROJECT_NAME.zip" -d .
    elif command -v 7z >/dev/null 2>&1; then
        7z x "$PROJECT_NAME.zip" -o. -aoa
    elif command -v winrar >/dev/null 2>&1; then
        winrar x "$PROJECT_NAME.zip" .
    elif command -v winzip >/dev/null 2>&1; then
        winzip -e "$PROJECT_NAME.zip" .
    else
        echo "Error: No suitable extraction tool found (unzip, 7z, winrar, winzip)."
        exit 1
    fi

    # # Ensure extraction is complete before proceeding
    # wait

    # Delete the zip file
    rm $PROJECT_NAME.zip

    # Debug: List contents of the current directory
    echo "Contents of the current directory after extraction and deleting the zip file:"
}

appendToFile() {
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

main
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

````
Convert the text below to markdown.
Detect the programming syntax for the commands and use it in the code block.
Use @@@ instead of ``` for the code block.
Use @@@shellscript for scripting.
Use only # and ## for headings.
Don't remove lines with asterisks (*) as they are additional information.
Put everything in a single block of text for easy copying.
Don't remove any anything from the original text.
Convert some comments into headings. Use ##.
````

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

*Tags: coding rules, programming rules, programming conventions*

## Dos

- Defensive programming; Decouple your business logic from the framework to easily migrate from one framework to another
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
  function calculateRectangleArea({
    length,
    width,
  }: {
    length: number;
    width: number;
  }): number {
    return length * width;
  }

  // Clear usage; values provide context and purpose
  const area2 = calculateRectangleArea({ length: 5, width: 10 });
  ```

- Use readable boolean variables instead of vague conditions

  Before:
  ```tsx
  if (user.isActive && user.age > 18 && user.hasVerifiedEmail) {
      console.log("Success!")
  }
  ```
  After:
  ```tsx
  const isActiveUser: boolean = user.isActive;
  const isAdult: boolean = user.age > 18;
  const hasVerifiedEmail: boolean = user.hasVerifiedEmail;

  const isUserEligible: boolean = isActiveUser && isAdult && hasVerifiedEmail;

  if (isUserEligible) {
      console.log("Success!")
  }
  ```
- Self-documenting code: dot notation to reference object values
- Guard clauses, early returns, early exits
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
    calculator(initialValue)
      .add(5)
      .multiply(2)
      .subtract(10)
      .divide(5)
      .getResult()
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

[Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html)

## Center an element vertically and horizontally; center an element horizontally and vertically

*Tags: Center element vertically and horizontally; center element horizontally and vertically*

```html
<!-- WHOLE DOCUMENT CENTERED -->
<body style="display: grid; place-items: center; height: 100vh;">
  <div>Centered Element</div>
</body>

<!-- SCOPED STYLE -->
<div style="display: grid; place-items: center;">
  <div>Centered Element</div>
</div>
```

## INHERIT PARENT WIDTH; DROPDOWN POSITION

```css
.parent {
  position: relative;
}
.child {
  position: absolute;
  width: 100%;
}
```

## CENTER ELEMENT VERTICALLY

```css
/* Shorthand: top, right, bottom, left */
margin: 0% auto 0% auto;

margin-left: auto;
margin-right: auto;
```

## CENTER ELEMENT HORIZONTALLY

```css
/* Shorthand: top, right, bottom, left */
margin: auto 0% auto 0%;

margin-top: auto;
margin-bottom: auto;
```

## Center element

```css
width: 50%;
margin: auto;
```

## Toggle Switch

### CSS

```css
/*====================Toggle Switch====================*/
```

### HTML

```html
<label class="switch">
  <input type="checkbox" checked />
  <span class="slider round"></span>
</label>
```

### CSS

```css
/* Size */
.switch {
  zoom: 50%;
}
/* Transition Duration */
.slider,
.slider:before {
  transition: 0.5s;
}
/* True */
input:checked + .slider {
  background-color: green;
}
/* True Transition */
input:checked + .slider:before {
  transform: translateX(26px);
}
/* False */
.slider {
  background-color: orange;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  cursor: pointer;
  position: absolute;
}
/* Middle Switch */
.slider:before {
  content: "";
  background-color: white;
  bottom: 4px;
  left: 4px;
  height: 26px;
  width: 26px;
  position: absolute;
}
/* Container */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}
/* Middle Switch Radius */
.slider.round:before {
  border-radius: 50% !important;
}
/* Container Radius */
.slider.round {
  border-radius: 50px !important;
}
/*====================Toggle Switch====================*/
```

## NEVER USE IDs WHEN STYLING

## ":" and "::" difference

- `:` = pseudo-element (hover, active, focus)
- `::` = pseudo-selector (first-child, last-child)

## Triangle div

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Blank HTML</title>
    <style>
      .triangle {
        zoom: 20%;
        border-color: black;
        height: 0% !important;
        width: 0% !important;
        border-top: 0%;
        border-bottom: 86.6px solid;
        border-left: 50px solid transparent !important;
        border-right: 50px solid transparent !important;
      }
    </style>
  </head>
  <body>
    <div class="triangle"></div>
  </body>
</html>
```

## Center the sidebar and main content area along the vertical axis

```css
html,
body {
  height: 100%;
}
body {
  align-items: center;
}
```

## CSS grid/Display elements side by side

\*See Quickform/home layout

```css
#content {
  display: grid;

  /* First element/column is 200px, 2nd element (1fr) takes up the remaining space */
  grid-template-columns: 200px 1fr;

  /* 2 columns */
  grid-template-columns: repeat(2, 1fr);
}

#first {
  height: 100%;
  position: fixed;
}
```

## Element placement

```css
float: right;
```

## Bootstrap button

```css
.btn,
.btn:focus {
  color: #62aced;
  border: 1px solid #62aced;
  outline: none !important;
  background-color: white;
  transition: all 0.5s ease-in-out;
}
.btn:hover {
  color: white;
  background-color: #62aced;
}
.btn:active {
  box-shadow: inset 0 5px 20px -2px rgba(0, 0, 0, 0.5);
}

.green,
.green:focus {
  color: #b2ba3a;
  border-color: #b2ba3a;
}
.green:hover {
  color: white;
  background-color: #b2ba3a;
}
```

## Bootstrap modal

- Remove "fade" from `class="modal fade"` to remove default animation
- Target modal backdrop color by ".in" class
- Add title bar `<div>` under "modal-dialog" (before "modal-content") `<div>`
- Modal-dialog overrides: shadow, border-radius

```css
.modal-header {
  text-align: center;
  border-color: #dddddd;
}
.modal-content {
  border: none;
  background-color: #eeeeee;
}
.modal-footer {
  border-color: #dddddd;
}
```

## Center div/Custom modal

*Tags: center a div*

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <style>
      #modal-backdrop,
      #modal-body {
        top: 50%;
        left: 50%;
        position: fixed;
        transform: translate(-50%, -50%);
      }
      #modal-backdrop {
        height: 100%;
        width: 100%;
        background-color: rgba(0, 0, 0, 0.5);
      }
      #modal-body {
        height: 400px;
        width: 400px;
        background-color: red;
      }
    </style>
  </head>
  <body>
    <div id="modal-backdrop">
      <div id="modal-body"></div>
    </div>
  </body>
</html>
```

## Background image

```css
body {
  background-image: url("http://bit.ly/2eUrF3s");
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  background-attachment: fixed;
}
```

## Bootstrap button

```css
.btn {
  border: none;
  transition: all 0.5s;
}
```

## Set general border radius

```css
* {
  border-radius: 0 !important;
}
```

## Shadow

```css
element {
  box-shadow: 0px 0px 10px 1px #aaaaaa;
}
"box-shadow":"0px0px10px1px#AAAAAA", ;
```

## Center Fix Elements

```css
element {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

## Center Inline elements (<span>,<a>)

```css
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

export interface IFetchOptions extends RequestInit {
  timeout?: number;
  body?: DataBody;
}

export type RequestInterceptor = (
  url: string,
  options: IFetchOptions,
) => IFetchOptions;
export type ResponseInterceptor = (response: Response) => Response;

const defaultOptions: IFetchOptions = {
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
  options: IFetchOptions,
): IFetchOptions =>
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
  options: IFetchOptions = {},
): Promise<T> => {
  if (!url || typeof url !== 'string') {
    throw new Error('URL must be a valid string');
  }

  const mergedOptions: IFetchOptions = { ...defaultOptions, ...options };
  const finalOptions: IFetchOptions = applyRequestInterceptors(
    url,
    mergedOptions,
  );

  // Type guard to check if headers is Record<string, string>
  const isHeadersObject = (
    headers: HeadersInit,
  ): headers is Record<string, string> => {
    return typeof headers === 'object' && !(headers instanceof Headers);
  };

  // Ensure headers object exists
  if (!finalOptions.headers) {
    finalOptions.headers = {};
  }

  // Determine content type if body is present and Content-Type header is not set
  if (
    finalOptions.body !== undefined &&
    isHeadersObject(finalOptions.headers)
  ) {
    if (!('Content-Type' in finalOptions.headers)) {
      finalOptions.headers['Content-Type'] = determineContentType(
        finalOptions.body,
      );
    }
  }

  const controller = new AbortController();
  const id = setTimeout(() => {
    controller.abort();
  }, finalOptions.timeout ?? 5000);
  finalOptions.signal = controller.signal;

  try {
    const response: Response = await fetch(`${API_URL}${url}`, finalOptions);
    clearTimeout(id);

    if (!response.ok) {
      throw new Error(
        `There was an HTTP Error with a status code ${String(response.status)}.`,
      );
    }

    const interceptedResponse = applyResponseInterceptors(response);

    const responseData: unknown = await interceptedResponse.json();

    // Type guard to check if responseData is T
    const isT = (data: unknown): data is T => {
      // Basic runtime check for object, you might want to add more checks here based on your requirements
      return typeof data === 'object' && data !== null;
    };

    if (!isT(responseData)) {
      throw new Error('Response data is not of expected type');
    }

    return responseData;
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
    options?: IFetchOptions;
  }): Promise<T> => {
    const { url, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'GET' });
  },
  post: async <T>(params: {
    url: string;
    body: DataBody;
    options?: IFetchOptions;
  }): Promise<T> => {
    const { url, body, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'POST', body });
  },
  put: async <T>(params: {
    url: string;
    body: DataBody;
    options?: IFetchOptions;
  }): Promise<T> => {
    const { url, body, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'PUT', body });
  },
  patch: async <T>(params: {
    url: string;
    body: DataBody;
    options?: IFetchOptions;
  }): Promise<T> => {
    const { url, body, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'PATCH', body });
  },
  delete: async <T>(params: {
    url: string;
    options?: IFetchOptions;
  }): Promise<T> => {
    const { url, options } = params;
    return customFetchInternal<T>(url, { ...options, method: 'DELETE' });
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
    console.error("Error fetching user data:", error);
  }
};

// Example usage of the post method
const createData = async (userData: { name: string; email: string }) => {
  try {
    const response = await customFetch.post<{ success: boolean }>({
      url: `https://api.example.com/users`,
      body: JSON.stringify(userData),
    });
    console.log(response);
  } catch (error) {
    console.error("Error creating user:", error);
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

createData({ name: "Jane Doe", email: "jane@example.com" })
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

## Show All Running Containers

*Tags: show all active containers*

```bash
docker compose ps --services --filter "status=running"
```

## Containerization Steps

1. Build images
2. Create containers from images

## Remove & Rebuild Container and Images

```bash
docker stop nginx && docker container rm nginx && docker image rm server-nginx
docker compose up --force-recreate
```

## Delete All Unused Images

```bash
docker image prune -a
```

## Re-dockerize Application

```bash
docker stop app && docker container rm app && docker image rm custom-image-name
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Custom Container Name)

```bash
docker build -t custom-image-name .
docker container run -p 3000:3000 --restart=always --name app custom-image-name
```

## Dockerize Application from a Dockerfile (Random Container Name)

```bash
docker build -t custom-image-name .
docker run -p 3000:3000 --restart=always custom-image-name
```

## Create Container Without Starting; Create Container from an Image

```bash
docker container create --name custom-container-name custom-image-name
```

## Dockerize Application (Dockerfile)

```bash
docker build -t app .
docker run -p 3000:3000 --restart=always app
```

## Start Container

```bash
docker start <container-name>
```

## Rename Container

```bash
docker rename old new
```

## Stop Container

```bash
docker stop <container-name>
```

## Restart Container

```bash
docker restart <container-name>
```

## Update Certificates (Composer Error)

```bash
update-ca-certificates
```

## Go to Container's Terminal

```bash
docker exec -it <container_name> bash
```

## Build Docker Compose

```bash
docker compose up
docker compose build
docker compose up --force-recreate
docker compose build --no-cache
```

## Build Container

- -t to give a docker image a name
- . means the current directory; reference the current directory

```bash
docker build -t app .
docker build --no-cache -t app .
```

## Run Docker App/Container

```bash
docker run -p 3000:3000 app
```

## Download Image in Docker Hub

```bash
docker pull <username>/hello-world
```

## Run Docker Image

```bash
docker run hello-world
```

## Show All Running Containers

```bash
docker ps
```

## Show All Containers

```bash
docker ps -a
```

## Delete Docker Container; Force Delete

- add -f at the end to force delete

```bash
docker container rm container-name
```

## Show Docker Images

```bash
docker images
```

## Delete Docker Image; Force Delete

- add -f at the end to force delete

```bash
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

### Convert Div Element Into A Clickable Element

*Tags: convert element into a clickable element, clickable element, convert non-interactive elements into interactive elements*

```tsx
<div
  role="button"
  onKeyDown={() => { return; }}
  tabIndex={-1} // -1 means it cannot be tabbed
></div>
```

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
{
  data?.map(({ id, firstName }, i) => <div key={id}>{row}</div>)
}

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
const [selectedValue, setSelectedValue] = useState< (typeof animals)[keyof typeof animals] >(animals.CAT);

<select
  value={selectedValue}
  onChange={(event: React.ChangeEvent<HTMLSelectElement>) => {
    const isValueInObject = <T extends object>(
      obj: T,
      value: unknown,
    ): value is T[keyof T] => {
      return Object.values(obj).includes(value);
    };

    const selected = event.target.value;
    if (isValueInObject(CREATION_MODES, selected)) {
      setSelectedValue(selected);
    }
  }}
>
  {Object.entries(animals).map(([animalEng, animalLatin]: [string, string], i: number) => (
        <option key={animalEng} value={animalLatin} >
          {animalLatin}
        </option>
  ))}
</select>

// Raw
Object.entries(animals).forEach(
  ([animalEng, animalLatin]: [string, string], i: number) => {
    console.log({ animalEng, animalLatin });
  }
);

// Iterate a number of times
// Loop 5 times

{
  Array.from({ length: 5 }, (_, i) => (
    <div key={i}>Page {i + 1}</div>
  ))
}

// Iterate an array
{
  ['value 1', 'value 2', 'value 3'].map((value, i) => (
    <div key={i}>{value}</div>
  ))
}

// Iterate an array of object using a function
// Usage: <>{GradesItems}</>
const Items = Data.map(({ id, firstName }, i) => (
  <div key={id}>{firstName}</div>
));
```

## State Management

*Tags: global state management, global values*

### Jotai

#### Global State File

```tsx
import { atom } from "jotai";

export const dataAtom = atom<Record<string, string>[]>([{ key: "value" }]);
```

#### Usage

```tsx
import { useAtom } from "jotai";
import { dataAtom } from "@/state";

export default function App() {
  const [data, setData] = useAtom(dataAtom);
  return <>{JSON.stringify(data, null, 4)}</>;
}
```

### Zustand

#### Global State File

```tsx
import { create } from 'zustand';

interface IStore {
  count: number;
  increment: () => void;
  searchQuery: string;
  setSearchQuery: (query: string) => void;
}

export const useStore = create<IStore>()((set) => ({
  count: 1,
  increment: () => {
    set(({ count }) => ({ count: ++count }));
  },
  searchQuery: 'Initial value',
  setSearchQuery: (searchQuery) => {
    set({ searchQuery });
  },
}));
```

#### Usage

```tsx
import { useStore } from './store';

export default function App() {
  const { count, increment, searchQuery, setSearchQuery } = useStore();

  return (
    <>
      <h1>Zustand</h1>
      <h2>Example 1</h2>
      <button type="button" onMouseDown={increment}>
        Count: {count}
      </button>

      <h2>Example 2</h2>
      <input
        type="text"
        value={searchQuery}
        onChange={(e) => {
          setSearchQuery(e.target.value);
        }}
        placeholder="Enter search query"
      />
      <p>Global Search Query Value: {searchQuery}</p>
    </>
  );
}
```

## Common

### Type Guarding

*Tags: typesafe keys, type-safe keys, typesafe property keys, type-safe property keys, typesafe object keys, type-safe object keys, typesafe map keys, type-safe map keys, typesafe property names, type-safe property names, typeguards, type guards, typechecking, type checking*

```tsx
function isKeyOf<T extends object>(
  obj: T,
  key: string,
): key is Extract<keyof T, string> {
  return key in obj;
}

// Usage:
const pages = {
  login: Login,
  register: Register,
} as const;

{Object.keys(pages).map((page) => {
if (isKeyOf(pages, page)) {
  return (
    <div
      key={page}
    >
      {page.charAt(0).toUpperCase() + page.slice(1)}
    </div>
  );
}
return null;
})}
```

```tsx
interface IData {
  property1: number;
  property2: number;
}

export function isValidData(data: unknown): data is IData {
  if (
    // Check if data is not null
    data !== null &&
    // Check if data is an object
    typeof data === 'object' &&
    // Check if the required properties exist in the data object
    'property1' in data &&
    'property2' in data &&
    // Check if the properties are of the correct type
    typeof data.property1 === 'number' &&
    typeof data.property2 === 'number'
  ) {
    return true;
  }
  return false;
}
```

### Check If Property Exists

*Tags: focus on element, focus html element, focus element*

```tsx
const person = {
  name: "John",
  age: 30,
};

// Shorthand
console.log("name" in person); // true

console.log(Object.prototype.hasOwnProperty.call(person, "name")); // true
```

### Focus on HTML Element

*Tags: focus on element, focus html element, focus element*

```tsx
const element = document.querySelector(`#${id}`);
if (element instanceof HTMLElement) {
  element.focus();
}
```

### Extract Object Property Values

*Tags: extract object properties, extract object values, extract property values*

```tsx
const languages = [
  { language_name: "typescript", display_name: "TypeScript" },
  { language_name: "javascript", display_name: "JavaScript" },
  { language_name: "java", display_name: "Java" },
  { language_name: "php", display_name: "PHP" },
];

const languageNames = languages.map((language) => language.language_name);

console.log(languageNames); // Output: ["typescript", "javascript", "java", "php"]
```

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

// Override interface; reuse interface; remove interface property; omit interface property
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

// Filter first result; get first result; filter first object; get first object; find first result; find first object
const firstMales = people.find((person) => person.gender === "male");
console.log(males);
//==========FILTER OBJECTS; FILTER DATA; SEARCH OBJECTS; SEARCH DATA==========//

// Capitalize first letter of a string
const string = "hello";
const capitalizedFirstLetter = string.charAt(0).toUpperCase() + string.slice(1);
console.log(capitalizedFirstLetter);

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

// Promise.all for resolving multiple promises; multiple async calls; multiple asynchronous calls
Promise.all([promise("param1"), anotherPromise("param2")])
.then(([response1, response2]) => Promise.all([response1.json(), response2.json()]),)
.then(([result1, result2]: [unknown, unknown]) => {
  console.log(result1); // promise()
  console.log(result2); // anotherPromise()
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
const haystack: string[] = ["hay", "needle", "hay"];
if (haystack.includes("needle")) {
  console.log("Needle exists in haystack");
}

// Usage
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
// *Tags: add commas to amount, add comma to amount, add comma to numbers*
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
setInterval(() => {
}, 1000);

// Set timeout:
setTimeout(() => {
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
  c: "3", // This property will be overridden
};

const mutatedObject = {
  ...originalObject,
  c: "new value",  // Override 'c' directly
  d: "4"           // Add new property 'd'
};
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

const mutatedObject = {
  ...originalObject,
  c: {
    ...originalObject.c,
    e: "new value",  // Directly update the 'e' property within 'c'
  },
};
console.log(mutatedObject);
//==========MUTATE NESTED OBJECTS==========//


// Extract keys from an object; Extract properties from an object
const { firstName: firstName, lastName: lastName } = person;
```

## Remove Object Property

*Tags: exclude keys from an object, exclude properties from an object, filter an object, remove object key, mutate object, exclude object key, exclude object property*

```tsx
const objectVariable = {
  key1: 1,
  key2: "This will be removed",
};

// Set the property to be removed
const { key2, ...newObject } = objectVariable;

console.log(newObject); // { key1: 1 }
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

components must be functional components (class components are old)

props/proponents - data that can be used by the component (e.g. names, database values to be rendered)

Hot module replacement:
if (module.hot) {
	module.hot.accept();
}

function vs arrow functions, optional return statement

super(props) - to ensure that the React Component 's constructor() function gets called
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

```
https://raw.githubusercontent.com/judigot/references/main/FileHandlingHelpers.sh
```

# =====================================

# React Form

## Form 1

```tsx
import React, { useState, useEffect } from 'react';

/*
=====USAGE=====
<Form
  initialData={{
    tagInput: 'Tag value',
    tags: ['tag1', 'tag2'],
    textInput: 'Text value',
    textareaInput: 'Textarea value',
    selectInput: 'Option 1',
    radioInput: 'Option 1',
    checkboxoption1: true,
    checkboxoption2: false,
    checkboxoption3: false,
}}
=====USAGE=====
*/

const FORM_FIELDS = {
  TAG_INPUT: 'tagInput',
  TAGS: 'tags',
  TEXT_INPUT: 'textInput',
  TEXTAREA_INPUT: 'textareaInput',
  SELECT_INPUT: 'selectInput',
  RADIO_INPUT: 'radioInput',
  CHECKBOX_INPUT1: 'checkboxoption1',
  CHECKBOX_INPUT2: 'checkboxoption2',
  CHECKBOX_INPUT3: 'checkboxoption3',
} as const;

interface IFormInputValues {
  [FORM_FIELDS.TAG_INPUT]: string;
  [FORM_FIELDS.TAGS]: string[];
  [FORM_FIELDS.TEXT_INPUT]: string;
  [FORM_FIELDS.TEXTAREA_INPUT]: string;
  [FORM_FIELDS.SELECT_INPUT]: string;
  [FORM_FIELDS.RADIO_INPUT]: string;
  [FORM_FIELDS.CHECKBOX_INPUT1]: boolean;
  [FORM_FIELDS.CHECKBOX_INPUT2]: boolean;
  [FORM_FIELDS.CHECKBOX_INPUT3]: boolean;
}

type OmittedKeys = typeof FORM_FIELDS.TAG_INPUT; // | typeof FORM_FIELDS.TAG_INPUT | typeof FORM_FIELDS.RADIO_INPUT

type IFormDataBody = Omit<IFormInputValues, OmittedKeys>;

interface IProps {
  initialData?: IFormInputValues;
}

const defaultValues: IFormInputValues = {
  [FORM_FIELDS.TAG_INPUT]: '',
  [FORM_FIELDS.TAGS]: [],
  [FORM_FIELDS.TEXT_INPUT]: '',
  [FORM_FIELDS.TEXTAREA_INPUT]: '',
  [FORM_FIELDS.SELECT_INPUT]: '',
  [FORM_FIELDS.RADIO_INPUT]: '',
  [FORM_FIELDS.CHECKBOX_INPUT1]: false,
  [FORM_FIELDS.CHECKBOX_INPUT2]: false,
  [FORM_FIELDS.CHECKBOX_INPUT3]: false,
};

export function Form({ initialData }: IProps) {
  const selectOptions = {
    option1: 'Option 1',
    option2: 'Option 2',
    option3: 'Option 3',
  };

  const [formData, setFormData] = useState<IFormInputValues>(
    initialData ?? defaultValues,
  );

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >,
  ) => {
    const { name, value, type } = e.target;
    const checked = e.target instanceof HTMLInputElement && e.target.checked;

    setFormData((prevData) => ({
      ...prevData,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const areAllInputsFilled = Object.values(formData).every(
      (value) => value !== undefined && value !== null && value !== '',
    );

    if (areAllInputsFilled) {
      const data: IFormDataBody = formData;
      // eslint-disable-next-line no-console
      console.log(data);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <pre>{JSON.stringify(formData, null, 4)}</pre>
      <TagInput
        id="tagInput"
        required={true}
        placeholder="Add tags"
        inputValue={formData[FORM_FIELDS.TAG_INPUT]}
        addedValues={formData[FORM_FIELDS.TAGS]}
        onInputChange={handleChange}
        onAddValue={(updatedTags: string[]) => {
          setFormData((prev) => ({
            ...prev,
            [FORM_FIELDS.TAG_INPUT]: '',
            [FORM_FIELDS.TAGS]: updatedTags,
          }));
        }}
        suggestions={['Hello', 'World']}
      />

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
            <option key={key} value={option}>
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
              value={option}
              checked={formData.radioInput === option}
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
              checked={Boolean(
                formData[`checkbox${key}` as keyof IFormInputValues],
              )}
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

function TagInput({
  id,
  required,
  placeholder = 'Enter values',
  inputValue = '',
  onInputChange,
  addedValues,
  suggestions = [
    'Suggestion 1',
    'Suggestion 2',
    'Suggestion 3',
    'Suggestion 4',
  ],
  onAddValue,
}: {
  id: string;
  required: boolean;
  placeholder?: string;
  inputValue?: string;
  onInputChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  addedValues: string[];
  onAddValue: (newTags: string[]) => void;
  suggestions?: string[];
}) {
  const [filteredSuggestions, setFilteredSuggestions] = useState<string[]>([]);
  const [isFocused, setIsFocused] = useState<boolean>(false);
  const [showSuggestions, setShowSuggestions] = useState<boolean>(false); // Define the state for showing suggestions

  useEffect(() => {
    // Filter to show only unselected options
    filterAndSetSuggestions(inputValue);
    setShowSuggestions(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [inputValue, addedValues]); // Depend on tags to re-filter when they change

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && inputValue.trim()) {
      e.preventDefault();
      addValue(inputValue.trim());
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    onInputChange(e);
  };

  const addValue = (tag: string) => {
    if (!addedValues.includes(tag)) {
      const newTags = [...addedValues, tag];
      onAddValue(newTags);
    }
  };

  const removeValue = (index: number) => {
    const newTags = addedValues.filter((_, i) => i !== index);
    onAddValue(newTags);
  };

  const filterAndSetSuggestions = (input: string) => {
    if (input.length > 0) {
      const filtered = suggestions.filter(
        (suggestion) =>
          suggestion.toLowerCase().includes(input.toLowerCase()) &&
          !addedValues.includes(suggestion),
      );
      setFilteredSuggestions(filtered);
    } else {
      setFilteredSuggestions([]);
    }
  };

  const handleSuggestionClick = (suggestion: string) => {
    addValue(suggestion);
    const element = document.querySelector(`#${String(id)}`);
    if (element instanceof HTMLElement) {
      element.focus();
    }
  };

  const handleFocus = () => {
    setIsFocused(true);
    setShowSuggestions(true);
  };

  const handleBlur = () => {
    setIsFocused(false);
    setTimeout(() => {
      setShowSuggestions(false);
    }, 200); // Delay hiding to allow click event
  };

  return (
    <div
      key={id}
      className={`relative flex items-center flex-wrap gap-2 px-3 py-2 rounded-md bg-gray-700 border ${
        isFocused ? 'border-blue-500 ring-blue-500' : 'border-gray-600'
      }`}
    >
      {addedValues.map((value, index) => (
        <span
          key={`${id}-${String(index)}`}
          className="flex items-center bg-blue-700 text-white rounded-full text-sm px-2 py-1 mr-2"
        >
          {value}
          <button
            type="button"
            onClick={() => {
              removeValue(index);
            }}
            className="bg-blue-700 hover:bg-blue-500 rounded-full ml-2 inline-flex items-center justify-center w-6 h-6"
            aria-label={`Remove ${value}`}
          >
            &times;
          </button>
        </span>
      ))}

      <input
        required={addedValues.length === 0 && required}
        type="text"
        id={id}
        name={id}
        placeholder={placeholder}
        value={inputValue}
        onChange={handleChange}
        onKeyDown={handleKeyDown}
        onFocus={handleFocus}
        onBlur={handleBlur}
        className="flex-1 bg-transparent text-white outline-none min-w-[100px] basis-[100px]"
      />

      {showSuggestions && filteredSuggestions.length > 0 && (
        <ul className="absolute left-0 top-full mt-1 w-full bg-gray-600 rounded shadow-lg z-10">
          {filteredSuggestions.map((suggestion, index) => (
            <li
              key={index}
              className="p-2 cursor-pointer text-white hover:bg-gray-500 rounded-t-md first:rounded-t-md last:rounded-b-md"
              onClick={() => {
                handleSuggestionClick(suggestion);
              }}
              onKeyDown={() => {
                return;
              }}
              role="option"
              tabIndex={0} // tabIndex="0" makes the div focusable
              aria-label="Close modal" // Provides a label that describes the button's action
              aria-selected={false} // Provides a label that describes the button's action
            >
              {suggestion}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default Form;

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

  const handleChange = (e: React.FormEvent<HTMLInputElement>) => {
    const { name, value } = e.currentTarget;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const areAllInputsFilled = Object.values(formData).every(
      (value) => value !== undefined && value !== null && value !== ""
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
          onChange={handleChange}
        />

        <label>Password</label>
        <input
          required
          type="password"
          name="password"
          onChange={handleChange}
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

## Publish Repository
*Tags: publish local repository, publish existing repository*
```bash
git remote set-url origin git@github.com:judigot/<repository-name>.git
git push -u origin main
```

## Revert Version (Non-destructive)

Creates a new commit that reverts the repository to a previous state while preserving the commit history.

*Tags: revert git branch, reset git version, reset version, reset to previous version, reset repository using hash*

```bash
# git revert --no-commit j58c1688b438933ca547f77053c7fcf0e2d21492..HEAD # Revert changes from the specified commit to the latest commit without creating a commit yet.
git revert --no-commit j58c1688b438933ca547f77053c7fcf0e2d21492..HEAD # Revert changes from the specified commit to the latest commit, allowing review or adjustments.
git commit -m "Revert to previous commit without losing history"
git push origin HEAD
```

Example:

Before revert:

```bash
commit d5f8e8a (HEAD -> main) - Added feature
commit c3b4a2b - Fixed bug
commit 112405e - Initial commit
```

After revert:

```bash
commit f7b3c2d (HEAD -> main) - Reverted to commit 112405e
commit d5f8e8a - Added feature
commit c3b4a2b - Fixed bug
commit 112405e - Initial commit
```

## Reset Version (Destructive)

Deletes all changes that came after the specified commit.

*Tags: reset git version, reset version, reset to previous version, reset repository using hash*

```bash
# git reset --hard j58c1688b438933ca547f77053c7fcf0e2d21492 # Move the branch to a specific commit, losing all changes after that.
git reset j58c1688b438933ca547f77053c7fcf0e2d21492 # Move the branch to a specific commit, keeping changes made after that in the working directory.
git push origin HEAD --force
```

Example:

Before reset:

```bash
commit d5f8e8a (HEAD -> main) - Added feature
commit c3b4a2b - Fixed bug
commit 112405e - Initial commit
```

After reset:

```bash
commit 112405e (HEAD -> main) - Initial commit
```

## Hard-Reset Branch

*Tags: revert back to main hard reset remove all changes*

```bash
git checkout target-branch
git pull origin main
git reset --hard origin/main
git push origin target-branch --force
```

## Combine Branches

*Tags: absorb branch, integrate branch, merge branch, combine branch*

### Merge Method (Non-linear History)

```bash
main_branch="main"
feature_branch="feature-branch"

git checkout $main_branch && git merge $feature_branch && git push origin $main_branch
```

### Rebase Method (Simpler Linear History)

```bash
main_branch="main"
feature_branch="feature-branch"

git checkout $feature_branch && git rebase $main_branch && git checkout $main_branch && git merge $feature_branch && git push origin $main_branch
```

## Update Current Branch With Changes From Another Branch

```bash
git pull origin <base-branch>
```

## Check Git Status Before Deleting A Repository

*Tags: check git status before deleting repository, check git status before removing a repository, check git status before removing repository, check and remove*

```bash
if git status --porcelain | awk 'NF { exit 1 }'; then
    echo -e "\e[32mNo changes detected in the git repository. Proceeding to delete.\e[0m" # Green
    rm -rf $repository
    git clone $repository
else
    echo -e "\e[31mChanges detected in the git repository. Aborting deletion.\e[0m" # Red
fi
```

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

Migrate changes to another branch:
git stash -u && git checkout -b new-branch && git stash pop

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

Rename a branch, rename a branch (must be in the branch you want to rename):
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

*Tags: create a new branch with the stashed files; other tags; git stash branch; create a new branch from stash; create new branches from stash; git create branch with stashed changes; how to apply stash to a new branch; git branch from stash; git stash usage; git stash command; git stash best practices; git branch management; version control with git; git stash tutorial; git branch commands; working with git stash; git stashing changes; new branch from unsaved work; create a branch from unsaved work; create branches from unsaved work; git branch from uncommitted work; branch from unstaged changes; new branch from an unsaved work; create a branch from unsaved changes; create branches from unsaved changes; git branch from an uncommitted work; branch from an unstaged change; new branch from unsaved file; create a branch from unsaved file; create branches from unsaved files; git branch from an unstaged file; branch from an unsaved file; new branches from unsaved files; new branch from unsaved files*

    # Stash your files first using  git stash -u. This command will use the latest stash
    git stash branch new-branch-name

List all remote branches:
git branch -a

Create a new branch from an existing branch; create a new branch from an existing branch; create new branch from an existing branch, create branch:
git checkout -b new-branch parent-branch

Delete a local branch; delete local branch (checkout to another branch before deleting):
*checkout to another branch before deleting
*"Safe" delete (prevents you from deleting the branch if it has unmerged changes)
git branch -d <delete-this-branch>

Force delete a branch, even if it has unmerged changes
*Tags: delete branch, remove branch, delete git branch, remove git branch*
git branch -D <delete-this-branch>

Delete a remote branch, delete remote branch, remove remote branch, remove a remote branch:
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
  ```

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
         - \*/main
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
•Rollback every migration; reset every migration; rollback all migrations; reset all migrations; reset database; reset tables
  php artisan migrate:reset
•Define database tables from PHP classes (setup the database details in .env file first):
	php artisan migrate
•Create "migrations" table:
	php artisan migrate:install
•Rollback last migration:
	php artisan migrate:rollback
•Redefine database tables:
	php artisan migrate:fresh
•Redefine database tables with data:
	php artisan migrate:fresh --seed
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

### Show All Stored Procedures

*Tags: show stored procedures, select all stored procedures, select stored procedures*

```sql
SELECT ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
AND ROUTINE_SCHEMA = 'database_name';
```

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

*Tags: reset auto increment, reset primary key*

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

PostgreSQL
```sql
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
```

MySQL
```sql
USE $DB_NAME;

SET FOREIGN_KEY_CHECKS = 0;

SET @tables = NULL;
SELECT GROUP_CONCAT('\`', table_name, '\`') INTO @tables
FROM information_schema.tables 
WHERE table_schema = (SELECT DATABASE());

SET @tables = IFNULL(@tables, 'dummy');
SET @sql = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;
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

# Deno

## Vite

```bash
deno run -A npm:create-vite@latest bigbang --template react-swc-ts
```

## Next.js

```bash
deno run -A npm:create-next-app@latest bigbang-next --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/* --turbopack
```

## Install Packages

```bash
deno add npm:axios
deno add -D npm:@tanstack/react-router
```

# =====================================

# Node.js & NPM Commands & Configurations

## Set Default Shell

```bash
npm config set script-shell "C:/apportable/Programming/PortableGit/bin/bash.exe"
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

#### Convert NPM to PNPM

*Tags: convert npm into pnpm*

```bash
pnpm import
```

#### Install All Dependencies from pnpm-lock.json:

NPM:

*Tags: install dependencies from pnpm-lock.json, install all dependencies from package-lock.json, install dependencies from package-lock.json, install lockfile dependencies, install lock file dependencies*

NPM

```bash
npm ci
```

PNPM

```bash
pnpm install --frozen-lockfile
```

#### Install Development/Production Dependencies in pnpm-lock.json

*Tags: install development/production dependencies in package-lock.json*

NPM

```bash
npm ci --only=development
npm ci --only=production
```

PNPM

```bash
pnpm install --frozen-lockfile --only dev
pnpm install --frozen-lockfile --prod
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

## php.ini Settings

```
Uncomment:
    extension_dir = "ext"

Uncomment all extensions except these:
    ; extension=snmp
    ; extension=oci8_12c  ; Use with Oracle Database 12c Instant Client
    ; extension=oci8_19  ; Use with Oracle Database 19 Instant Client
    ; extension=pdo_firebird
    ; extension=pdo_oci
```

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
   npm install typescript esbuild esbuild-register @types/node --save-dev
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

## Google Domains Name Servers

    ns-cloud-e1.googledomains.com
    ns-cloud-e2.googledomains.com
    ns-cloud-e3.googledomains.com
    ns-cloud-e4.googledomains.com

## DNS Set Up

|  Host name   | Type |      Data       |     Result      |
| :----------: | :--: | :-------------: | :-------------: |
| @ (or empty) |  A   | 666.666.666.666 |   example.com   |
|     www      |  A   | 666.666.666.666 | www.example.com |

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

## Advanced Database Operations

*Tags: caching using postgresql, postgresql caching, postgres caching, postgresql cache, postgres cache*

- Sharding
- Stored Procedures
- Views and Materialized Views
  - View

    - A view is a virtual table that represents the result of a query.
    - Useful for simplifying complex queries, providing a level of abstraction, or ensuring security by restricting access to certain data.

  - Materialized View
    - stores the result of the query into the disk.
    - materialized views are faster as it avoids executing the underlying query each time. However, they need to be refreshed to reflect changes in the underlying tables.
    - Useful for improving performance when dealing with complex queries that are costly to execute frequently, especially when the underlying data does not change often.

- Common Table Expressions (CTEs) - used for recursive queries and to break down complicated queries into simpler parts.

  ```sql
  WITH cte AS (
      SELECT column1, column2
      FROM table_name
      WHERE condition
  )
  SELECT *
  FROM cte
  WHERE another_condition;
  ```
- Window Functions
- Indexing Strategies
  - Partial indexes
  - Expression indexes
  - Gin and GiST indexes
- JSONB Data Type
  ```sql
  SELECT order_data->>'customer' AS customer
  FROM orders
  WHERE order_data->>'status' = 'shipped';
  ```
- Foreign Data Wrappers (FDWs) - access and query data from other databases (PostgreSQL or other databases) within your PostgreSQL database
- Advanced Partitioning - splitting tables into smaller, more manageable pieces
  ```sql
  CREATE TABLE sales (
      sale_id SERIAL,
      sale_date DATE,
      amount NUMERIC
  ) PARTITION BY RANGE (sale_date);

  CREATE TABLE sales_2023 PARTITION OF sales
  FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');

  CREATE TABLE sales_2024 PARTITION OF sales
  FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
  ```
- Event Triggers - execute custom functions in response to certain events like schema changes
- Custom Types and Functions


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

## Relationship Types in Relational Databases

1. **One-to-One (1:1) Relationship**

   - Example: Each student has one unique student profile.
   - Entities: `Student`, `StudentProfile`

2. **One-to-Many (1:N) Relationship**

   - Example: Each teacher teaches multiple classes.
   - Entities: `Teacher`, `Class`

3. **Many-to-Many (M:N) Relationship**

   - Example: An order can contain multiple products, and a product can be part of multiple orders.
   - Entities: `Order`, `Product`, `OrderProduct` (junction table)

   Schema

   *take note of the composite primary key

   ```sql
    CREATE TABLE order (
        order_id SERIAL PRIMARY KEY,
        order_date DATE NOT NULL
    );
    CREATE TABLE product (
        product_id SERIAL PRIMARY KEY,
        product_name VARCHAR(100) NOT NULL,
        price DECIMAL(10, 2) NOT NULL
    );
    -- Junction/Pivot table for the many-to-many relationship
    CREATE TABLE order_product (
        order_id INT REFERENCES order(order_id) ON DELETE CASCADE,
        product_id INT REFERENCES product(product_id) ON DELETE CASCADE,
        quantity INT NOT NULL,
        PRIMARY KEY (order_id, product_id)
    );
   ```

    API Endpoint

   ```bash
    PUT /orders/{order_id}/products/{product_id}
    PUT /orders/1/products/1
    PUT /order_product?order_id=1&product_id=1
   ```

4. **Self-Referencing Relationship**

   - Example: Employees can manage other employees.
   - Entities: `Employee`

5. **Many-to-Many (M:N) Self-Referencing Relationship**

   - Example: Students can be friends with other students.
   - Entities: `Student`, `Friendship` (junction table)

6. **Optional Relationships**

   - **Zero or One (0:1) Relationship**
     - Example: A student may have zero or one locker.
     - Entities: `Student`, `Locker`
   - **Zero or Many (0:N) Relationship**
     - Example: A student may not be enrolled in any class or may be enrolled in many classes.
     - Entities: `Student`, `Class`

7. **One or Many (1:N) Relationship**

   - Example: Each department must have at least one or more employees.
   - Entities: `Department`, `Employee`

8. **Exact Cardinality Relationships**

   - Example: A project must have exactly two managers.
   - Entities: `Project`, `Manager`, `ProjectManager` (junction table)

9. **Ternary and Higher-Order Relationships**

   - Example: A project can involve multiple employees and departments.
   - Entities: `Project`, `Employee`, `Department`, `ProjectAssignment` (junction table)

10. **Generalization/Specialization (Inheritance) Relationships**

    - Example: A vehicle can be either a car or a truck, with specific attributes for each type.
    - Entities: `Vehicle`, `Car`, `Truck`

11. **Recursive Relationships**

    - Example: An employee can report to another employee within the same table.
    - Entities: `Employee`

12. **Polymorphic Relationships**

    - Example: Comments can belong to either posts or videos.
    - Entities: `Comment`, `Post`, `Video`

13. **Aggregated Relationships**

    - Example: A library contains books, where books can exist independently of the library.
    - Entities: `Library`, `Book`

14. **Composition Relationships**

    - Example: An order contains line items, where line items cannot exist without the order.
    - Entities: `Order`, `LineItem`

See:
One-to-One (1:1)
One-to-Many (1:N)
Many-to-Many (M:N)
Self-Referencing One-to-Many
Self-Referencing Many-to-Many
Polymorphic One-to-Many
Polymorphic Many-to-Many
Hierarchical Relationship (Tree Structure)
Ternary Relationships
Compound (or Multi-Level) Relationships


## PostgreSQL Indexing Best Practices

### Common Columns to Index

1. **Primary Keys:**
   - PostgreSQL automatically creates an index on primary key columns. These are essential for efficient row identification.
   ```sql
   CREATE TABLE customers (
       customer_id SERIAL PRIMARY KEY,
       name VARCHAR(100),
       email VARCHAR(100)
   );
   ```

2. **Foreign Keys:**
   - Indexing foreign key columns can speed up join operations and ensure referential integrity checks are efficient.
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       customer_id INT REFERENCES customers(customer_id),
       order_date DATE
   );

   CREATE INDEX idx_orders_customer_id ON orders(customer_id);
   ```

3. **Columns Frequently Used in WHERE Clauses:**
   - Index columns that are often used in `WHERE` conditions to filter data.
   ```sql
   CREATE INDEX idx_customers_email ON customers(email);
   ```

4. **Columns Used in JOIN Conditions:**
   - Index columns that are frequently used to join tables together.
   ```sql
   SELECT orders.order_id, customers.name
   FROM orders
   JOIN customers ON orders.customer_id = customers.customer_id;
   ```

5. **Columns Used in ORDER BY Clauses:**
   - Index columns that are often used in `ORDER BY` clauses to sort results.
   ```sql
   CREATE INDEX idx_orders_order_date ON orders(order_date);
   ```

6. **Columns Used in GROUP BY Clauses:**
   - Index columns that are frequently used in `GROUP BY` clauses for aggregation.
   ```sql
   CREATE INDEX idx_sales_region ON sales(region);
   ```

7. **High Cardinality Columns:**
   - Columns with many unique values are often good candidates for indexing because they provide high selectivity.

8. **Partial Indexes:**
   - Create partial indexes for queries that filter on specific conditions, reducing the index size and improving performance.
   ```sql
   CREATE INDEX idx_active_customers ON customers(email)
   WHERE active = true;
   ```

### Examples and Best Practices

#### Example: Primary Key and Foreign Key Indexes

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
```

#### Example: Indexing Columns in WHERE Clauses

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    hire_date DATE
);

CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_hire_date ON employees(hire_date);
```

#### Example: Indexing for JOIN and ORDER BY Clauses

```sql
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE INDEX idx_departments_name ON departments(department_name);

SELECT employees.name, departments.department_name
FROM employees
JOIN departments ON employees.department = departments.department_name
ORDER BY employees.hire_date;
```

### Best Practices for Indexing

1. **Analyze Query Patterns:**
   - Regularly analyze your query patterns and identify which columns are frequently used in `WHERE`, `JOIN`, `ORDER BY`, and `GROUP BY` clauses.

2. **Use the Right Index Type:**
   - Choose the appropriate index type based on the use case (e.g., B-tree for equality and range queries, GIN/GiST for full-text search).

3. **Avoid Over-Indexing:**
   - While indexes improve read performance, they can slow down write operations. Avoid indexing columns that are not frequently queried or those that have low selectivity.

4. **Regular Maintenance:**
   - Regularly update your index statistics with `ANALYZE` and use `VACUUM` to reclaim storage and keep indexes efficient.

5. **Monitor Performance:**
   - Use tools like `EXPLAIN` and `EXPLAIN ANALYZE` to monitor how indexes are being used and to identify potential performance improvements.

### Conclusion

By following these best practices and indexing the appropriate columns, you can significantly improve the performance of your PostgreSQL database queries. Regularly analyzing your queries and maintaining your indexes will ensure your database remains efficient and responsive.

## Searchable Table

*Tags: create searchable table, searchable database table, search table for keywords, search postgresql table for keywords, search postgres table for keywords, searchable postgresql table, searchable postgres table*


```tsx
const tableName: string = "users";
const searchableColumns: string[] = [
  "id",
  "first_name",
  "last_name",
  "email",
  "gender",
];

console.log(buildSearchVectorQuery(tableName, searchableColumns));

function buildSearchVectorQuery(
  tableName: string,
  searchableColumns: string[]
): string {
  const stemmableColumns: string[] = [
    "first_name",
    "last_name",
    "name",
    "full_name",
    "username",
    "email",
    "email_address",
    "description",
    "bio",
    "summary",
    "comment",
    "note",
    "content",
    "review",
    "title",
    "headline",
    "subject",
    "job_title",
    "position",
    "role",
    "occupation",
    "message",
    "feedback",
    "opinion",
    "thoughts",
    "discussion",
  ];

  const nonStemmableColumns: string[] = [
    "id",
    "gender",
    "user_id",
    "customer_id",
    "order_id",
    "product_code",
    "reference_number",
    "phone_number",
    "address",
    "zip_code",
    "postal_code",
    "social_security_number",
    "status",
    "category",
    "type",
    "department",
    "birthdate",
    "appointment_date",
    "created_at",
    "updated_at",
    "price",
    "quantity",
    "rating",
    "level",
    "score",
  ];

  const numberColumnNames: string[] = [
    "id",
    "user_id",
    "customer_id",
    "order_id",
    "product_code",
    "reference_number",
    "phone_number",
    "zip_code",
    "postal_code",
    "social_security_number",
    "status",
    "category",
    "type",
    "department",
    "price",
    "quantity",
    "rating",
    "level",
    "score",
  ];

  let query = `/* Drop and recreate the search_vector column, trigger, and function */
ALTER TABLE ${tableName} DROP COLUMN IF EXISTS search_vector;
ALTER TABLE ${tableName} ADD COLUMN search_vector tsvector;
    
DROP TRIGGER IF EXISTS tsvectorupdate ON ${tableName};
DROP FUNCTION IF EXISTS ${tableName}_search_trigger;
DROP INDEX IF EXISTS idx_${tableName}_search_vector;
    
CREATE OR REPLACE FUNCTION ${tableName}_search_trigger() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := `;

  let weightIndex = 0;

  for (let i = 0; i < searchableColumns.length; i++) {
    const columnName = searchableColumns[i];
    const weight = String.fromCharCode("A".charCodeAt(0) + weightIndex);

    if (stemmableColumns.includes(columnName)) {
      if (columnName === "email" || columnName === "email_address") {
        query += `
    setweight(to_tsvector('pg_catalog.english', coalesce(NEW.${columnName}, '')), '${weight}') || 
    setweight(to_tsvector('pg_catalog.english', split_part(coalesce(NEW.${columnName}, ''), '@', 1)), '${weight}')`;
      } else {
        query += `
    setweight(to_tsvector('pg_catalog.english', coalesce(NEW.${columnName}, '')), '${weight}')`;
      }
    } else if (nonStemmableColumns.includes(columnName)) {
      if (numberColumnNames.includes(columnName)) {
        query += `
    setweight(to_tsvector('simple', coalesce(NEW.${columnName}::text, '')), '${weight}')`;
      } else {
        query += `
    setweight(to_tsvector('simple', coalesce(NEW.${columnName}, '')), '${weight}')`;
      }
    }

    if (i < searchableColumns.length - 1) {
      query += " ||";
    }
    weightIndex = (weightIndex + 1) % 4; // Wrap around after 'D'
  }

  query += ";";

  query += `
  RETURN NEW;
END
$$ LANGUAGE plpgsql;
    
CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
ON ${tableName} FOR EACH ROW EXECUTE FUNCTION ${tableName}_search_trigger();
    
CREATE INDEX IF NOT EXISTS idx_${tableName}_search_vector ON ${tableName} USING gin(search_vector);
    
/* Populate the search_vector column for existing rows */
UPDATE ${tableName} SET search_vector = `;

  weightIndex = 0;

  for (let i = 0; i < searchableColumns.length; i++) {
    const columnName = searchableColumns[i];
    const weight = String.fromCharCode("A".charCodeAt(0) + weightIndex);

    if (stemmableColumns.includes(columnName)) {
      if (columnName === "email" || columnName === "email_address") {
        query += `
  setweight(to_tsvector('pg_catalog.english', coalesce(${columnName}, '')), '${weight}') || 
  setweight(to_tsvector('pg_catalog.english', split_part(coalesce(${columnName}, ''), '@', 1)), '${weight}')`;
      } else {
        query += `
  setweight(to_tsvector('pg_catalog.english', coalesce(${columnName}, '')), '${weight}')`;
      }
    } else if (nonStemmableColumns.includes(columnName)) {
      if (numberColumnNames.includes(columnName)) {
        query += `
  setweight(to_tsvector('simple', coalesce(${columnName}::text, '')), '${weight}')`;
      } else {
        query += `
  setweight(to_tsvector('simple', coalesce(${columnName}, '')), '${weight}')`;
      }
    }

    if (i < searchableColumns.length - 1) {
      query += " ||";
    }
    weightIndex = (weightIndex + 1) % 4; // Wrap around after 'D'
  }

  query += ";";

  return query;
}
```

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

Most internet traffic focuses on downloads, making it crucial to optimize read operations over write, update, and delete in CRUD applications. Prioritizing read performance enhances user experience and efficiently meets the demand for quick information access.

## Architecture

### Microservice Architecture

- separate backend (API) and frontent (client)
- can have many clients (web, desktop, mobile)

## Framework Reference

*Tags: web frameworks*

### Framework Files

### Framework Files

| File Type                   | Laravel (PHP)              | Java Spring Boot (Java)                          | Next.js (TypeScript/JavaScript) | Django (Python)    | Flask (Python)     |
| --------------------------- | -------------------------- | ------------------------------------------------ | ------------------------------- | ------------------ | ------------------ |
| Package Manager File        | ./composer.json            | ./pom.xml                                        | ./package.json                  | ./requirements.txt | ./requirements.txt |
| Environment File            | ./.env                     | ./src/main/resources/application.properties      | ./.env                          | ./.env             | ./.env             |
| Database Configuration File | .env                       | ./src/main/resources/application.properties      | ./.env                          | ./.env             | ./.env             |
| Configuration File          | ./config/app.php           | ./src/main/resources/application.yml             | ./config/default.json           | ./settings.py      | ./config.py        |
| Testing Configuration File  | ./phpunit.xml              | ./src/test/resources/application-test.properties | ./config/test.json              | ./settings_test.py | ./config_test.py   |
| Log Files                   | ./storage/logs/laravel.log | ./logs/application.log                           | ./logs/app.log                  | ./logs/django.log  | ./logs/flask.log   |


### Framework Directories
| File Type/Directory       | Laravel (PHP)                             | Java Spring Boot (Java)                | Next.js (TypeScript/JavaScript) | Django (Python) | Flask (Python)             |
| ------------------------- | ----------------------------------------- | -------------------------------------- | ------------------------------- | --------------- | -------------------------- |
| Routes File/Directory     | ./routes/web.php                          | ./src/main/java/com/example/routes     | ./app (file-based routing)      | ./urls.py       | ./routes.py                |
| Middleware File           | ./app/Http/Middleware                     | ./src/main/java/com/example/middleware | ./middleware/logger.ts          | ./middleware.py | ./middleware.py            |
| Service/Controller Files  | ./app/Http/Controllers/UserController.php | ./src/main/java/com/example/service    | ./app/api/user.ts               | ./views.py      | ./services/user_service.py |
| Views/Templates Directory | ./resources/views                         | ./src/main/resources/templates         | ./app                           | ./templates     | ./templates                |
| Static Files Directory    | ./public                                  | ./src/main/resources/static            | ./public                        | ./static        | ./static                   |
| Models                    | ./app/Models                              | ./src/main/java/com/example/models     |                                 | ./models.py     | ./models.py                |
| Services                  | ./app/Http/Controllers                    | ./src/main/java/com/example/service    | ./app/api/services              | ./services.py   | ./services/user_service.py |
| Repositories              | ./app/Repositories                        |                                        |                                 |                 |                            |
| Providers                 | ./app/Providers                           |                                        |                                 |                 |                            |
| Jobs                      | ./app/Jobs                                |                                        |                                 |                 |                            |
| Helpers                   | ./app/Helpers                             |                                        |                                 |                 |                            |
| Exceptions                | ./app/Exceptions                          |                                        |                                 |                 |                            |


### Commands

| Command                      | Laravel (PHP)                                 | Java Spring Boot (Java)          | Next.js (TypeScript/JavaScript)                  | Django (Python)                                               | Flask (Python)                     |
| ---------------------------- | --------------------------------------------- | -------------------------------- | ------------------------------------------------ | ------------------------------------------------------------- | ---------------------------------- |
| Dev Mode Command             | php artisan serve                             | mvn spring-boot:run              | pnpm dev                                         | python manage.py runserver                                    | flask run                          |
| Build Command                | php artisan config:cache                      | mvn package                      | pnpm build                                       | python manage.py collectstatic                                | flask collect                      |
| Linting Command              | php artisan lint                              | mvn checkstyle:check             | pnpm lint                                        | pylint projectName                                            | pylint projectName                 |
| Testing Command              | php artisan test                              | mvn test                         | pnpm test                                        | pytest                                                        | pytest                             |
| Start Command                | php artisan serve --env=production            | java -jar target/\*.jar          | pnpm start                                       | gunicorn projectName.wsgi:application                         | gunicorn projectName:app           |
| Install Command              | composer install                              | mvn install                      | pnpm install                                     | pip install -r requirements.txt                               | pip install -r requirements.txt    |
| Dependency Update Command    | composer update                               | mvn versions:use-latest-releases | pnpm update                                      | pip install -U -r requirements.txt                            | pip install -U -r requirements.txt |
| Framework Version Command    | php artisan --version                         | mvn --version                    | pnpm -v                                          | python -m django --version                                    | flask --version                    |
| Run Migration Command        | php artisan migrate                           | mvn flyway:migrate               | pnpm prisma migrate deploy                       | python manage.py migrate                                      | flask db upgrade                   |
| Generate Migration Command   | php artisan make:migration                    | mvn flyway:repair                | pnpm prisma migrate dev                          | python manage.py makemigrations                               | flask db migrate                   |
| Rollback Migration Command   | php artisan migrate:rollback                  | mvn flyway:undo                  | pnpm prisma migrate reset                        | python manage.py migrate <migration_name>                     | flask db downgrade                 |
| Seed Command                 | php artisan db:seed                           | mvn flyway:seed                  | pnpm prisma db seed                              | python manage.py loaddata <fixture>                           | flask db-seed                      |
| Fresh Migrate & Seed Command | php artisan migrate:fresh --seed              | mvn flyway:migrate               | pnpm prisma migrate reset && pnpm prisma db seed | python manage.py flush && python manage.py loaddata <fixture> | flask db drop && flask db-seed     |
| Drop Database Command        | php artisan db:wipe                           | mvn flyway:drop                  |                                                  | python manage.py flush                                        | flask db drop                      |
| Create Database Command      | php artisan db:create                         | mvn flyway:create                | pnpm prisma db push                              | python manage.py migrate                                      | flask db create                    |
| Dump Command                 | php artisan db:dump                           | mvn flyway:dump                  |                                                  | python manage.py dumpdata                                     | flask db dump                      |
| Restore Command              | php artisan db:restore                        | mvn flyway:restore               |                                                  | python manage.py loaddata <backup>                            | flask db restore                   |
| Create Controller Command    | php artisan make:controller ExampleController |                                  | npx create-next-app pages/api/example            | python manage.py startapp example                             |                                    |
| Create Repository Command    | php artisan make:repository ExampleRepository |                                  | npx prisma init                                  |                                                               |                                    |
| Create Service Command       | php artisan make:service ExampleService       |                                  | npx prisma init                                  |                                                               |                                    |


## Back End Tests

- Rearrange any table's column order and see of app still works

## Back End Roadmap:

*Tags: back end development, backend development, back end skills, backend skills, backend roadmap, back end roadmap*

```
Authentication
Authorization based on ownership/role
Middleware
Data validation
Data sanitization

Rate limiting in front of all API endpoints(nginx, redis or database):

    ```tsx
    const maxRequests = 20;
    const maxRequestsInterval: 10_000; // 1 minute
    ```
DTO to strip out sensitive data from the database
Encrypt or obfuscate backend endpoint from inspect element (api/v1/users)
```
- hide some fields in API responses e.g. passwords, tokens, etc.
- automating migration files creation by introspecting the existing database
- JSON schema validator (zod, ajv)
- Deduplication/deduping data
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
- SQL stored procedures
  - for querying very large data with expensive computation
- Aggregated data using SQL
- Common Table Expression, or CTE for combining queries e.g. selecting ids and insert the resulting ids into another table
- Running jobs (background process)
    # Types of Jobs in Backend Development

    ## Scheduled Jobs (Cron Jobs)
    - Tasks that run at specified times or intervals.
    - Example: Sending daily emails, cleaning up old data, generating reports.

    ## Asynchronous Jobs
    - Tasks that run in the background without blocking the main application flow.
    - Example: Processing file uploads, sending emails, performing complex computations.

    ## Batch Jobs
    - Processing large amounts of data in chunks.
    - Example: Processing logs, importing/exporting data, performing bulk updates.

    ## Event-Driven Jobs
    - Tasks triggered by specific events in the application.
    - Example: Sending a welcome email when a new user registers.

    ## Worker Jobs
    - Tasks handled by worker processes or threads, often used in microservices architecture or with a message queue system.
    - Example: Resizing images, processing payments.

    ## Maintenance Jobs
    - Tasks that ensure the health and performance of the system.
    - Example: Database backups, cache clearing, system monitoring.

    ## Data Processing Jobs
    - Transforming, aggregating, or analyzing data.
    - Example: Processing data for machine learning models, generating analytics, migrating data between systems.

    ## ETL (Extract, Transform, Load) Jobs
    - Specialized data processing jobs that extract data from one source, transform it, and load it into another system.
    - Example: Data warehousing, data integration.
- Message Queues
  - RabbitMQ
  - Apache Kafka
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

    - Access-Control-Allow-Origin "\*"

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
- Fluent interface like jQuery
- Piping functions
- Method chaining (builder pattern)
  - must be readable and eloquent (see Laravel's Eloquent ORM)

  ```tsx
  $("example").toUpperCase().addQuotes().titleCase().fixSpelling();
  ```
- Upload large CSV file to mysql and postgres (100k rows)

### Caching

Caching is a technique used to store copies of data in a temporary storage location, called a cache, so that future requests for that data can be served faster. Here are various types of caching strategies along with their pros, cons, and appropriate use cases:

#### Types of Caching

1. **Time-to-Live (TTL)**

   - **Definition:** Automatically removes stale data after a specified period.
   - **Pros:**
     - Simple to implement.
     - Automatically removes stale data.
   - **Cons:**
     - Data may become stale if the TTL is too long.
     - High churn rate if TTL is too short.
   - **When to Use:**
     - When you need a simple way to manage cache expiration and can tolerate some staleness.

2. **Manual Invalidation**

   - **Definition:** Manually invalidate the cache whenever the underlying data changes.
   - **Pros:**
     - Data consistency is maintained.
     - Cache is only cleared when necessary.
   - **Cons:**
     - Adds complexity to the application logic.
     - Risk of stale data if cache invalidation is missed.
   - **When to Use:**
     - When data changes infrequently or you have control over all data modifications.

3. **Cache-aside (Lazy Loading)**

   - **Definition:** Check the cache first, load from the database if not found, and then cache the result.
   - **Pros:**
     - Ensures fresh data is loaded into the cache as needed.
     - Reduces load on the database.
   - **Cons:**
     - Cache misses can lead to higher latency for initial requests.
   - **When to Use:**
     - When you want to load data into the cache only when it's requested and can handle occasional cache misses.

4. **Write-through Cache**

   - **Definition:** Write data to both the cache and the database simultaneously, ensuring the cache is always up-to-date.
   - **Pros:**
     - Simplifies read logic, as data is always consistent.
     - No stale data in the cache.
   - **Cons:**
     - Write operations are slower as they need to update both the cache and the database.
   - **When to Use:**
     - When data consistency is critical and you can afford slower write operations.

5. **Invalidate by Pattern**

   - **Definition:** Invalidate cache entries based on patterns when related data changes.
   - **Pros:**
     - Efficient for related data sets.
   - **Cons:**
     - Redis does not support wildcards directly, so this may require additional logic.
   - **When to Use:**
     - When you have multiple related cache keys that need to be invalidated together.

6. **Hybrid Approach**
   - **Definition:** Combine multiple strategies, such as TTL and manual invalidation, to fit specific needs.
   - **Pros:**
     - Combines the strengths of multiple strategies.
     - Provides a balance between performance and data consistency.
   - **Cons:**
     - Can be complex to implement and manage.
   - **When to Use:**
     - When you have diverse caching needs that require a combination of strategies to address effectively.

### Implementing Caching in a Backend Service with Prisma and Redis

*Tags: caching example, caching implementation, cache example, cache implementation*

## Step 1: Connect to Redis

Create a file to initialize and export your Redis client.

```tsx
// redisClient.js
import Redis from "ioredis";

const redis = new Redis();

export default redis;
```

## Step 2: Implement Caching Logic with TTL (Time-to-Live)

```tsx
// app.js
import express from "express";
import { PrismaClient } from "@prisma/client";
import redis from "./redisClient";

const app = express();
const prisma = new PrismaClient();
const ORDERS_CACHE_KEY = "orders_cache";
const CACHE_TTL = 86400; // 24 hours

app.get("/orders", async (req, res) => {
  try {
    // Try to fetch the cached data
    const cachedOrders = await redis.get(ORDERS_CACHE_KEY);
    if (cachedOrders) {
      return res.json(JSON.parse(cachedOrders));
    }

    // If no cached data is found, query the database
    const orders = await prisma.order.findMany();

    // Cache the result with a TTL
    await redis.set(ORDERS_CACHE_KEY, JSON.stringify(orders), 'EX', 86400); // Cache for 24 hours

    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
```

## Step 3: Clear Cache on Data Modification

```tsx
app.post("/orders", async (req, res) => {
  try {
    const newOrder = await prisma.order.create({ data: req.body });
    await redis.del(ORDERS_CACHE_KEY); // Invalidate cache
    res.status(201).json(newOrder);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.put("/orders/:id", async (req, res) => {
  try {
    const updatedOrder = await prisma.order.update({
      where: { id: parseInt(req.params.id) },
      data: req.body,
    });
    await redis.del(ORDERS_CACHE_KEY); // Invalidate cache
    res.json(updatedOrder);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.delete("/orders/:id", async (req, res) => {
  try {
    await prisma.order.delete({ where: { id: parseInt(req.params.id) } });
    await redis.del(ORDERS_CACHE_KEY); // Invalidate cache
    res.status(204).end();
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});
```

### Minimum Backend Setup

*Tags: api starterpack, backend starterpack*

1. **Scaffold project boilerplate**

2. **Run the SQL file** to create the database.

3. **Create an environment variable** named `BIGBANG_MESSAGE` with the value `"Hello, World!"`.

4. **Connect to a PostgreSQL database** named `bigbang` using the credentials `root:123`.

5. **Create an API endpoint** `"/api/v1/bigbang"` that returns a JSON response with the following properties:
   - `message`: **read from the environment file** the value of the environment variable `BIGBANG_MESSAGE`
   - `users`: the value from the PostgreSQL database

## Front End Roadmap:

*Tags: front end development, frontend revelopment, front end skills, frontend skills, frontend roadmap, front end roadmap*

- Feature flags
  - Environment Variables for Build-Time Flags:
  Set feature flags at build time to enable tree shaking and exclude disabled features.

  - Conditional Imports:
    Use dynamic imports to load code for features only when enabled.

  - Zustand for Runtime State Management:
    Toggle features at runtime without redeploying the application.

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
  \*code splitting

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

## Frontend Techniques

1. Debouncing
   Debouncing is a technique used to limit the number of times a function is executed. It ensures that a function is only called after a certain amount of time has passed since it was last invoked. This is particularly useful for events that can occur frequently, like keypresses, window resizing, or scrolling, to prevent unnecessary function calls and improve performance.

   **Examples:**

   - **Search Input (like Google Search Bar):** Debouncing ensures that the search function is only called once the user has stopped typing for a specified amount of time, reducing the number of API calls to fetch search suggestions. For instance, when a user types in a search input, debouncing can delay the API call until the user pauses typing for 300 milliseconds.

   **Top Plugin:**

   - **Lodash:** Lodash's `debounce` function is highly efficient and widely used for debouncing tasks.

2. Throttling
   Throttling ensures that a function is called at most once in a specified period. Unlike debouncing, throttling guarantees that the function is executed at regular intervals. This is useful for continuous events like scrolling or mouse movements to control the rate of function execution.

   **Examples:**

   - **Scroll Event (like Infinite Scrolling):** Throttling can limit the number of times a function is executed as the user scrolls, improving performance by reducing the frequency of API calls to load more content. In an infinite scrolling application, throttling can ensure that the API call to fetch more content is only made every 200 milliseconds.

   **Top Plugin:**

   - **Lodash:** Lodash's `throttle` function is a great choice for throttling tasks.

3. Skeleton Screens
   Instead of showing loading spinners, skeleton screens indicate that content is loading, providing a better user experience by giving a visual structure of the page.

   **Examples:**

   - **Placeholder Boxes:** Displaying gray boxes in place of images and text while the actual content is loading helps users understand what to expect and reduces perceived load time.
   - **Lists and Grids:** Using skeleton screens for lists and grids ensures users see a placeholder structure, improving the overall loading experience.

   **Top Plugin:**

   - **React Content Loader:** This library allows you to create customizable skeleton screens easily.

4. Client-Side Caching
   Client-side caching stores data locally to reduce the need for repeated network requests, improving load times and performance.

   **Examples:**

   - **API Responses:** Caching API responses in local storage or IndexedDB can allow for offline access and faster data retrieval on subsequent visits.
   - **User Preferences:** Storing user preferences and settings locally reduces the need to fetch them from the server every time the user interacts with the application.

   **Top Plugin:**

   - **TanStack Query (formerly React Query):** A powerful data-fetching library that simplifies fetching, caching, and synchronizing server state in React applications.
   - **SWR:** A React hook library for remote data fetching that includes built-in caching.

5. Error Handling
   Gracefully handling errors and providing meaningful messages ensures users understand what went wrong and how to proceed.

   **Examples:**

   - **Network Errors:** Displaying user-friendly error messages when a network request fails helps users understand the issue and potential steps to resolve it.
   - **Try-Catch Blocks:** Using try-catch blocks in JavaScript to handle unexpected errors and show appropriate feedback prevents the application from crashing and improves the overall user experience.

   **Top Plugin:**

   - **React Error Boundary:** Use `react-error-boundary` to handle errors gracefully in React applications.

6. Accessibility
   Ensuring your website is accessible to all users, including those with disabilities, is crucial. This involves using semantic HTML, ARIA roles, and testing with screen readers.

   **Examples:**

   - **Semantic HTML:** Using semantic HTML tags like `<header>`, `<main>`, and `<footer>` helps screen readers understand the structure of the page.
   - **ARIA Roles:** Adding ARIA roles and attributes to interactive elements ensures they are accessible to users with assistive technologies.

   **Top Plugin:**

   - **React Aria:** A library of React hooks for building accessible web applications.

7. Responsive Design
   Responsive design ensures that web applications work well on a variety of devices and screen sizes. This is achieved using CSS media queries and responsive frameworks like Bootstrap or Tailwind CSS.

   **Examples:**

   - **Adaptive Layouts:** A website layout can adjust from a multi-column layout on desktop screens to a single-column layout on mobile screens, ensuring usability across devices.
   - **Responsive Images:** Images and text can be resized or rearranged to fit different screen sizes, providing an optimal viewing experience on any device.

   **Top Plugin:**

   - **Tailwind CSS:** A highly customizable CSS framework for rapidly building responsive designs.

8. Lazy Loading
   Lazy loading defers the loading of non-critical resources until they are needed. This technique improves initial load time and reduces the amount of data transferred.

   **Examples:**

   - **Images on a Webpage:** Images can be lazy-loaded so that they are only downloaded when they come into the viewport, improving page load speed and reducing initial load time.
   - **Component Loading in Single-Page Applications:** Components can be lazy-loaded to ensure that only the necessary components are loaded initially, reducing the initial load time and improving performance.

   **Top Plugin:**

   - **React Lazy and Suspense:** Built-in React features for lazy loading components.

9. Progressive Enhancement
   Progressive enhancement focuses on providing a basic level of user experience to all browsers, then enhancing the experience for those with more advanced capabilities.

   **Examples:**

   - **Form Validation:** Initially provide basic HTML and JavaScript validation, with additional features like enhanced styling and advanced validation added for browsers that support them.
   - **Web Pages:** Design a web page to work with basic HTML and CSS, with advanced animations and interactions added for modern browsers.

10. Prefetching and Preloading
    Prefetching and preloading can be used to load resources ahead of time, improving perceived performance by reducing wait times for the user.

    **Examples:**

    - **Next Page Resources:** Prefetching the next page's resources while the user is still viewing the current page can make navigation feel faster and more seamless.
    - **Critical Resources:** Preloading critical resources like fonts or scripts ensures that they are available immediately when needed, reducing load times and improving performance.

    **Top Plugin:**

    - **React Loadable:** A higher-order component for loading components with dynamic imports.

11. Optimizing Images and Assets
    Compressing and optimizing images, and using modern formats like WebP, can significantly reduce load times. Serving static assets via a CDN can further improve performance.

    **Examples:**

    - **Image Compression:** Compressing images to reduce their file size without sacrificing quality can speed up page load times.
    - **Content Delivery Network (CDN):** Using a CDN to serve images, scripts, and stylesheets can reduce latency and improve load times by serving content from locations closer to the user.

    **Top Plugin:**

    - **vite-plugin-imagemin:** A Vite plugin to compress images during the build process.

12. Smooth Animations and Transitions
    Using CSS animations and transitions can create a smooth and engaging user experience. However, it's important to be mindful of performance impacts and avoid overuse.

    **Examples:**

    - **Modal Dialogs:** Animating the appearance of modal dialogs or dropdown menus can make the interface feel more responsive and polished.
    - **Button Hover Effects:** Using transitions for hover effects on buttons and links can provide visual feedback that enhances the user experience.

    **Top Plugin:**

    - **Framer Motion:** A powerful library for creating smooth animations and transitions in React.

13. Code Splitting
    Code splitting involves dividing code into various bundles that can be loaded on demand. This reduces the initial load time by only loading the necessary code for the current view.

    **Examples:**

    - **Route-Based Code Splitting:** In a React application, routes can be code-split so that each route only loads the necessary components when the user navigates to that route.
    - **Library Splitting:** Large libraries can be split into smaller chunks that are only loaded when needed, improving initial load performance.

    **Top Plugin:**

    - **React Loadable:** A higher-order component for loading components with dynamic imports.

14. User Feedback
    Providing instant feedback to user actions, such as button clicks or form submissions, keeps users informed about the state of their interactions and enhances the user experience.

    **Examples:**

    - **Loading Indicators:** Showing a loading spinner or progress bar during data submission gives users a visual indication that their action is being processed.
    - **Success/Error Messages:** Displaying success or error messages immediately after a form submission helps users understand the outcome of their action.

    **Top Plugin:**

    - **React Toastify:** A library for displaying notifications in React applications.

15. Data Fetching
    Efficient data fetching ensures that data is retrieved and updated in an optimized manner, enhancing the user experience by providing up-to-date information without unnecessary delays.

    **Examples:**

    - **Real-time Data Updates:** Fetching data at regular intervals or via WebSockets to keep the application data current without requiring manual refreshes.
    - **API Integration:** Efficiently integrating with APIs to fetch data only when needed and caching results to minimize repeated requests.

    **Top Plugin:**

    - **TanStack Query (formerly React Query):** A powerful data-fetching library that simplifies fetching, caching, and synchronizing server state in React applications.

## Git Commit Messages (Semantic Commit Messages)

*Tags: git messages*

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
serializeData; stringer
stringerInterpolation; templateLiteral
debug
lambda; anonymous function; lambda expression; arrow function body
IIFE; self-invoking expression; self-calling expression; self-invoking function; self-calling function
searchObjects, searchArrayOfObjects, findObject, findArrayOfObjects, findObjectInArrayOfObjects, filterObjects, filterData, searchData, findData, filterArrayOfObjects, findObjectInData, filterObjectInArray, searchObjectInArray, findDataInArray, searchObjectInData
findObjectIndex
mutateObject
mutateNestedObject
mutateArray
existsInArray; valueExistsInArray;
recursion; recursiveFunction
cloneArray; duplicateArray
cloneObject; duplicateObject
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
multilineString; heredoc
builderPattern; methodChaining
namespace
import
export

multiplePromises

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
initialData: useState & useEffect combined
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
guardClauses, errorHandling; handleErrors
earlyReturns, errorHandling; handleErrors
earlyExits, errorHandling; handleErrors
```

# =====================================

# API Generator

*Tags: generate rest api, generate restful api, generate api endpoints, generate endpoints*

```bash
#!/bin/bash

# Docker container details
CONTAINER_NAME="PostgreSQL"
DB_NAME="snippetboss"
DB_USER="root"
DB_PASSWORD="123"

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

endpoints=()
# Determine whether to use URL or container-based connection
if [ -n "$container_id" ]; then
    # Using Docker container connection
    endpoints[0]=$(docker exec -i "$container_id" psql "$DB_URL" -t -c "\dt" | awk -F\| '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
else
    # Using URL connection
    endpoints[0]=$(psql "$DB_URL" -t -c "\dt" | awk -F\| '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
fi

# Convert string to array; convert space-separated strings to array; convert space separated strings to array
mapfile -t table_names <<<"${endpoints[0]}"

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
  return PatchHandler(req, res);
}
export async function PUT(req: NextRequest, res: NextResponse) {
  return PutHandler(req, res);
}
export async function DELETE(req: NextRequest, res: NextResponse) {
  return DeleteHandler(req, res);
}
EOM

    # Create
    cat >"$dir_path/Post.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';
import DatatypeParser from '@/utils/DataTypeParser';

export default async function handler(_req: NextRequest, _res: NextResponse) {
    const data = req.body;
    try {
        const result = await prisma.$endpoint.create({ data });
        return NextResponse.json(DatatypeParser(result));
    } catch (error) {
        console.error(error);
        return NextResponse.json({
        error: error,
        });
    } finally {
        await prisma.\$disconnect();
    }
}
EOM

    # Read
    cat >"$dir_path/Get.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';
import DatatypeParser from '@/utils/DataTypeParser';

export default async function handler(_req: NextRequest, _res: NextResponse) {
    try {
        const result = await prisma.$endpoint.findMany();
        return NextResponse.json(DatatypeParser(result));
    } catch (error) {
        console.error(error);
        return NextResponse.json({
        error: error,
        });
    } finally {
        await prisma.\$disconnect();
    }
}
EOM

    # Update
    cat >"$dir_path/Patch.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';
import DatatypeParser from '@/utils/DataTypeParser';

export default async function handler(_req: NextRequest, _res: NextResponse) {
    const { id, ...data } = req.body;
    try {
        const result = await prisma.$endpoint.update({
            where: { id },
            data
        });
        return NextResponse.json(DatatypeParser(result));
    } catch (error) {
        console.error(error);
        return NextResponse.json({
        error: error,
        });
    } finally {
        await prisma.\$disconnect();
    }
}
EOM

    # Update
    cat >"$dir_path/Put.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';
import DatatypeParser from '@/utils/DataTypeParser';

export default async function handler(_req: NextRequest, _res: NextResponse) {
    const { id, ...data } = req.body;
    try {
        const result = await prisma.$endpoint.update({
            where: { id },
            data
        });
        return NextResponse.json(DatatypeParser(result));
    } catch (error) {
        console.error(error);
        return NextResponse.json({
        error: error,
        });
    } finally {
        await prisma.\$disconnect();
    }
}
EOM

    # Delete
    cat >"$dir_path/Delete.ts" <<-EOM
import { prisma } from '@/prisma/DatabaseClient';
import { NextRequest, NextResponse } from 'next/server';
import DatatypeParser from '@/utils/DataTypeParser';

export default async function handler(_req: NextRequest, _res: NextResponse) {
    const { id } = req.body;
    try {
        await prisma.$endpoint.delete({ where: { id } });
        return NextResponse.json(DatatypeParser(result));
    } catch (error) {
        console.error(error);
        return NextResponse.json({
        error: error,
        });
    } finally {
        await prisma.\$disconnect();
    }
}
EOM
}

# Iterate over each endpoint and create necessary files
for table_name in "${table_names[@]}"; do
    create_endpoint_files "$table_name"
done

echo "Next.js API endpoints have been generated."
```

# =====================================

# Directory Structure Cloner

*Tags: directory cloner, directory analyzer, clone directories, clone directory, copy directories, copy directory*

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

*Tags: dockerize static app, dockerize express app, dockerize pnpm application, dockerize node.js application, dockerize nodejs application, dockerize node application*

## Static App With Nginx Server

```dockerfile
FROM node:latest AS app
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
COPY . .
RUN pnpm build

FROM nginx:latest
COPY --from=app /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## App With Backend Server

```dockerfile
FROM node:alpine
WORKDIR /app
COPY . /app
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm build
EXPOSE 80
CMD node dist/index.js
```

# =====================================

# SQL Generator

*Tags: join builder, join generator, join query generator*

```tsx
// /* prettier-ignore */ const tableInfo = { snippet_type: [ { snippet_type_id: 1, snippet_id: 1, snippet_type_name: "global" }, { snippet_type_id: 2, snippet_id: 2, snippet_type_name: "specific" }, ], language: [ { language_id: 1, language_name: "typescript", display_name: "TypeScript" }, { language_id: 2, language_name: "java", display_name: "Java" }, ], prefix: [ { prefix_id: 1, prefix_description: "String Variable" }, { prefix_id: 2, prefix_description: "Integer Number Variable" }, { prefix_id: 3, prefix_description: "Description" }, { prefix_id: 4, prefix_description: "Description" }, { prefix_id: 5, prefix_description: "Description" }, ], prefix_name: [ { prefix_name_id: 1, prefix_id: 1, prefix_name: "varText", is_default: true, }, { prefix_name_id: 2, prefix_id: 1, prefix_name: "stringVariable", is_default: false, }, { prefix_name_id: 3, prefix_id: 2, prefix_name: "varNumber", is_default: true, }, { prefix_name_id: 4, prefix_id: 2, prefix_name: "numberIntegerVariable", is_default: false, }, { prefix_name_id: 5, prefix_id: 3, prefix_name: "varDecimal", is_default: true, }, { prefix_name_id: 6, prefix_id: 3, prefix_name: "numberFloatVariable", is_default: false, }, { prefix_name_id: 7, prefix_id: 4, prefix_name: "varBoolean", is_default: true, }, { prefix_name_id: 8, prefix_id: 4, prefix_name: "booleanVariable", is_default: false, }, { prefix_name_id: 9, prefix_id: 5, prefix_name: "varObject", is_default: true, }, { prefix_name_id: 10, prefix_id: 5, prefix_name: "objectVariable", is_default: false, }, ], snippet: [ { snippet_id: 1, snippet_type_id: 1, prefix_id: 1, snippet_content: 'const ${1:stringVariable}: string = "${2:Hello, World!}";', }, { snippet_id: 2, snippet_type_id: 1, prefix_id: 2, snippet_content: "int ${1:numberIntegerVariable} = ${2:100};", }, ], snippet_language: [ { snippet_language_id: 1, snippet_id: 1, language_id: 1 }, { snippet_language_id: 1, snippet_id: 2, language_id: 2 }, ], };
const tableInfo = {
  customer: [
    {
      customer_id: 1,
      name: "John Doe",
    },
  ],
  order: [
    {
      order_id: 1,
      customer_id: 1 /* Foreign key */,
    },
  ],
  product: [
    {
      product_id: 1,
      product_name: "Water",
    },
    {
      product_id: 2,
      product_name: "Yogurt",
    },
  ],
  order_product: [
    {
      order_product_id: 1,
      order_id: 1 /* Foreign key */,
      product_id: 1 /* Foreign key */,
    },
    {
      order_product_id: 2,
      order_id: 1 /* Foreign key */,
      product_id: 2 /* Foreign key */,
    },
  ],
};

const foreignKeys = getForeignKeys(tableInfo);
const oneToManyRelationships = getOneToManyRelationships(foreignKeys);
const joins = generateJoinQueries(tableInfo);
const joinQueries = joins.map((join) => {
  return `SELECT * FROM "${join.sourceTable}" JOIN "${join.targetTable}" ON "${join.sourceTable}".${join.foreignKey} = "${join.targetTable}".${join.foreignKey};`;
});

console.log(oneToManyRelationships);

//====================FUNCTIONS====================//

/* prettier-ignore */ function getForeignKeys( tableInfo: Record<string, { [key: string]: unknown }[]> ) { /* Step 1: Extract foreign keys */ function extractForeignKeys( tableInfo: Record<string, { [key: string]: unknown }[]> ) { const foreignKeys: { table: string; foreignKey: string; foreignTable: string; }[] = []; Object.keys(tableInfo).forEach((tableName) => { const { [tableName]: _, ...otherTables } = tableInfo; const primaryKey = Object.keys(tableInfo[tableName][0])[0]; Object.entries(otherTables).forEach( ([otherTableName, otherTableValue]) => { const otherTableColumnNames: string[] = Object.keys( otherTableValue[0] ); if (otherTableColumnNames.includes(primaryKey)) { foreignKeys.push({ table: otherTableName, foreignKey: primaryKey, foreignTable: tableName, }); } } ); }); return foreignKeys; } /* Extracted foreign keys array from tableInfo */ const extractedForeignKeys = extractForeignKeys(tableInfo); /* Step 2: Transform relations */ const groupForeignKeys = ( foreignKeys: { table: string; foreignKey: string; foreignTable: string }[] ) => { const tableNames: string[] = Array.from( new Set(foreignKeys.map((item) => item.table)) ); const transformed = tableNames.map((tableName) => { const relatedForeignKeys = foreignKeys .filter((item) => item.table === tableName) .map(({ foreignKey, foreignTable }) => ({ foreignKey, foreignTable, })); return { table: tableName, foreignKeys: relatedForeignKeys, }; }); return transformed; }; /* Transform the extracted foreign keys into the consolidated format */ return groupForeignKeys(extractedForeignKeys); }
/* prettier-ignore */ function getOneToManyRelationships( foreignKeys: { table: string; foreignKeys: { foreignKey: string; foreignTable: string }[]; }[] ) { const relationships: Record<string, unknown> = {}; foreignKeys .map(({ table, foreignKeys: foreignColumns }) => { const currentTableData = tableInfo[table as keyof typeof tableInfo]; return foreignColumns.map(({ foreignKey, foreignTable }) => { const foreignTableData = tableInfo[foreignTable as keyof typeof tableInfo][0]; const dataAndOwner = currentTableData.filter((currentTableRow) => { return ( currentTableRow[foreignKey as keyof typeof currentTableRow] === foreignTableData[foreignKey as keyof typeof foreignTableData] ); }); if (dataAndOwner.length) { relationships[foreignTable] = { ...foreignTableData, ...{ [`${table}s`]: dataAndOwner }, }; } }); }) .filter((value) => value !== undefined); return relationships; }
/* prettier-ignore */ function generateJoinQueries( tableInfo: Record<string, { [key: string]: unknown }[]> ): { sourceTable: string; targetTable: string; foreignKey: string }[] { let joins: { sourceTable: string; targetTable: string; foreignKey: string; }[] = []; const tableNames = Object.keys(tableInfo); tableNames.forEach((sourceTable) => { const sourceColumns = Object.keys(tableInfo[sourceTable][0]); sourceColumns.forEach((column) => { if (column.endsWith("_id")) { tableNames.forEach((targetTable) => { if ( targetTable !== sourceTable && tableInfo[targetTable][0].hasOwnProperty(column) ) { joins.push({ targetTable, sourceTable, foreignKey: column, }); } }); } }); }); return joins; }

//====================FUNCTIONS====================//
```

# SQL Stored Procedures

## PostgreSQL

```tsx
import { PrismaClient, Prisma } from "@prisma/client";

const prisma = new PrismaClient();

export const up = async (): Promise<void> => {
  const sql = Prisma.sql`SELECT * FROM "User";`;
  await prisma.$executeRaw`
    CREATE OR REPLACE FUNCTION get_all_users_pg()
    RETURNS TABLE(id INT, name TEXT, email TEXT) AS $$
    BEGIN
      RETURN QUERY ${sql};
    END;
    $$ LANGUAGE plpgsql;
  `;
};

export const down = async (): Promise<void> => {
  await prisma.$executeRaw`DROP FUNCTION IF EXISTS get_all_users_pg`;
};
```

## MySQL

```tsx
import { PrismaClient, Prisma } from "@prisma/client";

const prisma = new PrismaClient();

export const up = async (): Promise<void> => {
  const sql = Prisma.sql`SELECT * FROM \`User\`;`;
  await prisma.$executeRaw`
    CREATE PROCEDURE get_all_users_my()
    BEGIN
      ${sql}
    END;
  `;
};

export const down = async (): Promise<void> => {
  await prisma.$executeRaw`DROP PROCEDURE IF EXISTS get_all_users_my`;
};
```

# =====================================

# HTML Template

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sticky Navbar with Toggleable Sidebar</title>
    <style>
      /* General body styling */
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        height: 100vh;
      }

      /* Sticky navbar styling */
      .navbar {
        background-color: #333;
        color: white;
        padding: 10px 20px;
        text-align: center;
        position: sticky;
        top: 0;
        z-index: 1000;
      }

      /* Main content area with flexbox to hold sidebars and content */
      .content-area {
        display: flex;
        flex: 1;
        height: calc(100% - 40px); /* Adjust based on navbar height */
      }

      /* Sidebar styling */
      .sidebar {
        background-color: #f4f4f4;
        width: 200px;
        padding: 10px;
        overflow-y: auto;
        transition: transform 0.3s ease;
      }

      /* Left sidebar specific styling */
      .sidebar-left {
        transform: translateX(-100%);
      }

      /* Right sidebar specific styling */
      .sidebar-right {
        /* If you want borders or other styles, add them here */
      }

      /* Main content styling */
      .main-content {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
      }

      /* Toggle show class for sidebar */
      .show {
        transform: translateX(0%);
      }
    </style>
  </head>
  <body>
    <div class="navbar">
      Sticky Navbar
      <button
        onclick="toggleSidebar()"
        style="position: absolute; left: 20px; top: 10px"
      >
        Toggle Sidebar
      </button>
    </div>
    <div class="content-area">
      <div class="sidebar sidebar-left" id="leftSidebar">Left Sidebar</div>
      <div class="main-content">
        Main content goes here. Adjust the content to see how the sidebars
        behave.
      </div>
      <div class="sidebar sidebar-right">Right Sidebar</div>
    </div>

    <script>
      function toggleSidebar() {
        var sidebar = document.getElementById("leftSidebar");
        sidebar.classList.toggle("show");
      }
    </script>
  </body>
</html>
```

# MSYS2

## Initial MSYS Setup

*Tags: zsh setup, install zsh, zsh installation, download zsh*

```bash
#=====UPDATE PACKAGES=====#
pacman -Syu --noconfirm # Yes to all
#=====UPDATE PACKAGES=====#

#=====MUST-HAVE PACKAGES=====#
pacman -S --noconfirm vim
# pacman -S --noconfirm openssh # No need to install this. Just use the native Windows SSH by adding it to PATH variable
pacman -S --noconfirm zsh
#=====MUST-HAVE PACKAGES=====#

#=====ZSH CONFIGURATION=====#
# Create an empty .zshrc file
[[ -f "$HOME/.zshrc" ]] && touch .zshrc
# Install Oh My Zsh framework
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# Add zsh-autosuggestions to the list of plugins in .zshrc: vim ~/.zshrc
# It should look like this: plugins=(git zsh-autosuggestions)
# Restart terminal
#=====ZSH CONFIGURATION=====#
```

## Update Packages

```bash
pacman -Syu --noconfirm # Yes to all
# pacman -Syu
```

## Install Packages
*Tags: install pacman packages*

```bash
pacman -S --noconfirm git # Yes to all
```

# =====================================

# UUID

*Tags: uuid version 4, uuid version 5, uuid v4, uuid v5*

### V4

UUIDv4 generates a completely random and unique identifier every time.

Use cases:

- Orders Table (orders): For tracking and managing the details of customer purchases, including items, quantities, prices, and order statuses.
- Transactions Table (transactions): For recording financial transactions, such as payments, refunds, and other monetary exchanges.
- Session Identifiers Table (user_sessions): For web application session management.
- Temporary Files Table (temp_files): For managing temporary file storage.

```tsx
import { v4 as uuidv4 } from "uuid";

// Generating a random UUID v4
const randomUUID = uuidv4();
console.log("Random UUID v4:", randomUUID);
```

Generating UUIDv4 using PostgreSQL extension.

```sql
-- Create a table with a UUID v4 as the primary key
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE transactions (
    transaction_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    amount DECIMAL NOT NULL,
    description TEXT
);

-- Insert a new transaction with a random UUID v4
INSERT INTO transactions (amount, description) VALUES (99.95, 'Book purchase');
```

### V5

UUIDv5 generates consistently creates the same ID from the same inputs two inputs.

Use cases:

- User Profiles Table (user_profiles): For consistent user identification across platforms.
- API Resources Table (api_resources): For uniform referencing of API resources.
- Product Catalog Table (product_catalog): For reliable product tracking across systems.
- Configuration Items Table (config_items): For stable identifiers in system configurations.

```tsx
import { v5 as uuidv5 } from "uuid";

const NAMESPACE = "1b671a64-40d5-491e-99b0-da01ff1f3341"; // Define a fixed namespace UUID

// Generate a consistent UUID v5 based on user email and namespace
const userEmail = "user@example.com";
const userUUID = uuidv5(userEmail, NAMESPACE);
console.log("User UUID v5:", userUUID);
```

# =====================================

# Database Schema Introspection

*Tags: introspect tables, introspect schema, introspect postgresql database schema, introspect mysql database schema, introspect database schema, introspect db schema, analyze database schema, analyze db schema, analyze schema, exctract database schema information, extract db schema information*

## PostgreSQL

```sql
WITH columns_info AS ( SELECT table_schema, table_name, column_name, data_type, is_nullable, column_default, ordinal_position FROM information_schema.columns WHERE table_schema = 'public' ), foreign_keys AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema WHERE tc.constraint_type = 'FOREIGN KEY' ), primary_keys AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema WHERE tc.constraint_type = 'PRIMARY KEY' ), unique_constraints AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema WHERE tc.constraint_type = 'UNIQUE' ), check_constraints AS ( SELECT tc.table_schema, tc.table_name, cc.check_clause FROM information_schema.table_constraints AS tc JOIN information_schema.check_constraints AS cc ON tc.constraint_name = cc.constraint_name AND tc.table_schema = cc.constraint_schema WHERE tc.constraint_type = 'CHECK' ) SELECT c.table_name, json_build_object( 'columns', json_agg( CASE WHEN fk.foreign_table_name IS NOT NULL THEN json_build_object( 'column_name', c.column_name, 'data_type', c.data_type, 'is_nullable', c.is_nullable, 'column_default', c.column_default, 'primary_key', (pk.column_name IS NOT NULL), 'unique', (uc.column_name IS NOT NULL), 'check_constraints', ( SELECT json_agg(check_clause) FROM check_constraints cc WHERE cc.table_schema = c.table_schema AND cc.table_name = c.table_name ), 'foreign_key', json_build_object( 'foreign_table_name', fk.foreign_table_name, 'foreign_column_name', fk.foreign_column_name ) ) ELSE json_build_object( 'column_name', c.column_name, 'data_type', c.data_type, 'is_nullable', c.is_nullable, 'column_default', c.column_default, 'primary_key', (pk.column_name IS NOT NULL), 'unique', (uc.column_name IS NOT NULL), 'check_constraints', ( SELECT json_agg(check_clause) FROM check_constraints cc WHERE cc.table_schema = c.table_schema AND cc.table_name = c.table_name ), 'foreign_key', NULL ) END ORDER BY c.ordinal_position ) ) AS table_definition FROM columns_info c LEFT JOIN foreign_keys fk ON c.table_schema = fk.table_schema AND c.table_name = fk.table_name AND c.column_name = fk.column_name LEFT JOIN primary_keys pk ON c.table_schema = pk.table_schema AND c.table_name = pk.table_name AND c.column_name = pk.column_name LEFT JOIN unique_constraints uc ON c.table_schema = uc.table_schema AND c.table_name = uc.table_name AND c.column_name = uc.column_name GROUP BY c.table_name ORDER BY c.table_name;
```

## MySQL

```sql
SET @database_name = 'database_name'; SELECT c.table_name, JSON_OBJECT( 'columns', JSON_ARRAYAGG( JSON_OBJECT( 'column_name', c.COLUMN_NAME, 'data_type', c.DATA_TYPE, 'is_nullable', c.IS_NULLABLE, 'column_default', IFNULL(c.COLUMN_DEFAULT, NULL), 'primary_key', c.COLUMN_KEY = 'PRI', 'unique', c.COLUMN_KEY = 'UNI', 'check_constraints', JSON_ARRAY(), 'foreign_key', CASE WHEN k.REFERENCED_TABLE_NAME IS NOT NULL THEN JSON_OBJECT( 'foreign_table_name', k.REFERENCED_TABLE_NAME, 'foreign_column_name', k.REFERENCED_COLUMN_NAME ) ELSE NULL END ) ) ) AS table_definition FROM INFORMATION_SCHEMA.COLUMNS c LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k ON c.TABLE_SCHEMA = k.TABLE_SCHEMA AND c.TABLE_NAME = k.TABLE_NAME AND c.COLUMN_NAME = k.COLUMN_NAME AND k.REFERENCED_TABLE_NAME IS NOT NULL WHERE c.TABLE_SCHEMA = @database_name GROUP BY c.table_name;
```

# =====================================


# Step-by-Step Guide to Implementing Repository Pattern in Laravel

## 1. Create Models

### Customer Model: `app/Models/Customer.php`
- Define the Customer model with necessary attributes and relationships.

### Order Model: `app/Models/Order.php`
- Define the Order model with necessary attributes and relationships.

### Product Model: `app/Models/Product.php`
- Define the Product model with necessary attributes and relationships.

### OrderProduct Model: `app/Models/OrderProduct.php`
- Define the OrderProduct model for the junction table.

## 2. Create Repository Interfaces

### Customer Repository Interface: `app/Repositories/CustomerRepositoryInterface.php`
- Define an interface for the Customer repository with necessary methods.

### Order Repository Interface: `app/Repositories/OrderRepositoryInterface.php`
- Define an interface for the Order repository with necessary methods.

### Product Repository Interface: `app/Repositories/ProductRepositoryInterface.php`
- Define an interface for the Product repository with necessary methods.

## 3. Create Repository Implementations

### Customer Repository: `app/Repositories/CustomerRepository.php`
- Implement the Customer repository interface with methods to handle customer data operations.

### Order Repository: `app/Repositories/OrderRepository.php`
- Implement the Order repository interface with methods to handle order data operations.

### Product Repository: `app/Repositories/ProductRepository.php`
- Implement the Product repository interface with methods to handle product data operations.

## 4. Create Services

### Order Service: `app/Services/OrderService.php`
- Create a service that uses the repositories to handle business logic for creating orders and associating products with orders.

## 5. Create Controllers

### Order Controller: `app/Http/Controllers/OrderController.php`
- Define a controller to handle HTTP requests and use the OrderService to create orders.

## 6. Define the Routes

### Routes: `routes/web.php`
- Add routes to handle the creation of orders via a POST request to the OrderController.

## 7. Register the Repository Bindings in a Service Provider

### Service Provider: `app/Providers/AppServiceProvider.php`
- Bind the repository interfaces to their respective implementations.

## 8. Run Migrations for Customers, Orders, Products, and OrderProduct Tables

### Create Migration Files:
- Create migration files to define the schema for the `customers`, `orders`, `products`, and `order_product` tables.

### Run the Migrations:
- Run the migrations to create the tables in the database.

By following these steps, you'll set up a comprehensive implementation of the Repository Pattern for handling customer orders and product associations in a Laravel application.


# =====================================

# GitHub Rules

*Tags: main branch rules, dev branch rules, branch rules, github workflow rules*

## Ruleset Name
- **Main Branch Protection**

## Enforcement Status
- [x] **Active**  <!-- Check this box if the ruleset is currently active -->
- [ ] **Disabled**  <!-- Check this box if the ruleset is not currently active -->

## Bypass List
- (empty)

## Target Branches
### Branch Name: `main`
- **Branch Targeting Criteria:**
  - **✅ Inclusion Patterns:** 
    - `main`
  - **❌ Exclusion Patterns:** 
    - (empty)

## Rules
- [x] **Restrict Creations**  
  Only allow users with bypass permission to create matching refs.

- [x] **Restrict Updates**  
  Only allow users with bypass permission to update matching refs.

- [x] **Restrict Deletions**  
  Only allow users with bypass permissions to delete matching refs.

- [x] **Require Linear History**  
  Prevent merge commits from being pushed to matching refs.

- [x] **Require Deployments to Succeed**  
  Choose which environments must be successfully deployed to before refs can be pushed into a ref that matches this rule.
  - **Select Deployment Environments**  
    - (No deployment environments have been added)

- [x] **Require Signed Commits**  
  Commits pushed to matching refs must have verified signatures.

- [x] **Require a Pull Request Before Merging**  
  Require all commits be made to a non-target branch and submitted via a pull request before they can be merged.
  - **Required Approvals**  
    - [x] **2**  <!-- The number of approving reviews that are required before a pull request can be merged. -->
  - [x] **Dismiss Stale Pull Request Approvals When New Commits Are Pushed**  
    New, reviewable commits pushed will dismiss previous pull request review approvals.
  - [x] **Require Review from Code Owners**  
    Require an approving review in pull requests that modify files that have a designated code owner.
  - [ ] **Require Approval of the Most Recent Reviewable Push**  
    Whether the most recent reviewable push must be approved by someone other than the person who pushed it.

  - [ ] **Require Conversation Resolution Before Merging**  
    All conversations on code must be resolved before a pull request can be merged.

- [x] **Require Status Checks to Pass**  
  Choose which status checks must pass before the ref is updated. When enabled, commits must first be pushed to another ref where the checks pass.

- [x] **Require Branches to Be Up to Date Before Merging**  
  Whether pull requests targeting a matching branch must be tested with the latest code. This setting will not take effect unless at least one status check is enabled.

- [ ] **Do Not Require Status Checks on Creation**  
  Allow repositories and branches to be created if a check would otherwise prohibit it.

- [x] **Block Force Pushes**  
  Prevent users with push access from force pushing to refs.

- [x] **Require Code Scanning Results**  
  Choose which tools must provide code scanning results before the reference is updated. When configured, code scanning must be enabled and have results for both the commit and the reference being updated.
  - **Code Scanning Tools**  
    - Required tools and alert thresholds:
      - **CodeQL**

---

## Ruleset Name
- **Dev Branch Protection**

## Enforcement Status
- [x] **Active**  <!-- Check this box if the ruleset is currently active -->
- [ ] **Disabled**  <!-- Check this box if the ruleset is not currently active -->

## Bypass List
- (empty)

## Target Branches
### Branch Name: `dev`
- **Branch Targeting Criteria:**
  - **✅ Inclusion Patterns:** 
    - `dev`
  - **❌ Exclusion Patterns:** 
    - (empty)

## Rules
- [x] **Restrict Creations**  
  Only allow users with bypass permission to create matching refs.

- [x] **Restrict Updates**  
  Only allow users with bypass permission to update matching refs.

- [ ] **Restrict Deletions**  
  Allow users with appropriate permissions to delete matching refs as needed for active development.

- [x] **Require Linear History**  
  Prevent merge commits from being pushed to matching refs.

- [ ] **Require Deployments to Succeed**  
  Optional for `dev` branch to allow for quicker iterations. If critical, set deployment requirements.

- [x] **Require Signed Commits**  
  Commits pushed to matching refs must have verified signatures.

- [x] **Require a Pull Request Before Merging**  
  Require all commits be made to a non-target branch and submitted via a pull request before they can be merged.
  - **Required Approvals**  
    - [x] **1**  <!-- Require at least one approval -->
  - [x] **Dismiss Stale Pull Request Approvals When New Commits Are Pushed**  
    New, reviewable commits pushed will dismiss previous pull request review approvals.
  - [x] **Require Review from Code Owners**  
    Require an approving review in pull requests that modify files that have a designated code owner.

- [x] **Require Status Checks to Pass**  
  Choose which status checks must pass before the ref is updated. When enabled, commits must first be pushed to another ref where the checks pass.

- [ ] **Require Branches to Be Up to Date Before Merging**  
  This can be helpful but may slow down development; consider the team's workflow.

- [ ] **Do Not Require Status Checks on Creation**  
  Allow repositories and branches to be created if a check would otherwise prohibit it.

- [x] **Block Force Pushes**  
  Prevent users with push access from force pushing to refs.

- [x] **Require Code Scanning Results**  
  Choose which tools must provide code scanning results before the reference is updated. When configured, code scanning must be enabled and have results for both the commit and the reference being updated.
  - **Code Scanning Tools**  
    - Required tools and alert thresholds:
      - **CodeQL**


# =====================================

# Relationships Overview

*Tags: table relationships, entity relationships, model relationships*

- **hasOne** ↔ **belongsTo**
  - **Example**: User hasOne Profile
  - **Laravel**:
    ```php
    class User extends Model {
        public function profile() {
            return $this->hasOne(Profile::class);
        }
    }

    class Profile extends Model {
        public function user() {
            return $this->belongsTo(User::class);
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class User {
        @OneToOne(mappedBy = "user")
        private Profile profile;
    }

    @Entity
    public class Profile {
        @OneToOne
        @JoinColumn(name = "user_id")
        private User user;
    }
    ```
  - **Django**:
    ```python
    class User(models.Model):
        profile = models.OneToOneField('Profile', on_delete=models.CASCADE)

    class Profile(models.Model):
        user = models.OneToOneField(User, on_delete=models.CASCADE)
    ```
  - **Flask**:
    ```python
    class User(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        profile = db.relationship('Profile', backref='user', uselist=False)

    class Profile(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        user_id = db.Column(db.Integer, db.ForeignKey('users.id'));
    ```
  - **Sequelize**:
    ```javascript
    const User = sequelize.define('User', { /* attributes */ });
    const Profile = sequelize.define('Profile', { /* attributes */ });

    User.hasOne(Profile);
    Profile.belongsTo(User);
    ```

  - **Sample Data**:

    **users**
    | **User ID** | User Name |
    |--------------|-----------|
    | `1`          | Alice     |
    | 2            | Bob       |

    **profiles**
    | **Profile ID** | **User ID** | Bio            |
    |----------------|--------------|----------------|
    | 1              | `1`          | Developer      |
    | 2              | 2            | Designer       |

---

- **hasMany** ↔ **belongsTo**
  - **Example**: Post hasMany Comments
  - **Laravel**:
    ```php
    class Post extends Model {
        public function comments() {
            return $this->hasMany(Comment::class);
        }
    }

    class Comment extends Model {
        public function post() {
            return $this->belongsTo(Post::class);
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class Post {
        @OneToMany(mappedBy = "post")
        private List<Comment> comments;
    }

    @Entity
    public class Comment {
        @ManyToOne
        @JoinColumn(name = "post_id")
        private Post post;
    }
    ```
  - **Django**:
    ```python
    class Post(models.Model):
        comments = models.ManyToManyField('Comment', related_name='posts')

    class Comment(models.Model):
        post = models.ForeignKey(Post, on_delete=models.CASCADE)
    ```
  - **Flask**:
    ```python
    class Post(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        comments = db.relationship('Comment', backref='post', lazy=True)

    class Comment(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        post_id = db.Column(db.Integer, db.ForeignKey('posts.id'))
    ```
  - **Sequelize**:
    ```javascript
    const Post = sequelize.define('Post', { /* attributes */ });
    const Comment = sequelize.define('Comment', { /* attributes */ });

    Post.hasMany(Comment);
    Comment.belongsTo(Post);
    ```

  - **Sample Data**:

    **posts**
    | **Post ID** | Post Title        |
    |--------------|-------------------|
    | `1`          | My First Post     |
    | 2            | Another Post      |

    **comments**
    | **Comment ID** | **Post ID** | Comment Text       |
    |----------------|--------------|---------------------|
    | 1              | `1`          | Great post!         |
    | 2              | `1`          | Thanks for sharing! |
    | 3              | 2            | Nice insights!      |

---

- **hasMany** ↔ **belongsToMany**
  - **Example**: Orders and Products with Pivot Table
  - **Laravel**:
    ```php
    class Order extends Model {
        public function products() {
            return $this->belongsToMany(Product::class, 'order_items')
                        ->withPivot('quantity');
        }
    }

    class Product extends Model {
        public function orders() {
            return $this->belongsToMany(Order::class, 'order_items')
                        ->withPivot('quantity');
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class Order {
        @ManyToMany
        @JoinTable(name = "order_items",
            joinColumns = @JoinColumn(name = "order_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id"))
        private List<Product> products;
    }

    @Entity
    public class Product {
        @ManyToMany(mappedBy = "products")
        private List<Order> orders;
    }
    ```
  - **Django**:
    ```python
    class Order(models.Model):
        products = models.ManyToManyField('Product', through='OrderItem')

    class Product(models.Model):
        orders = models.ManyToManyField(Order, through='OrderItem')

    class OrderItem(models.Model):
        order = models.ForeignKey(Order, on_delete=models.CASCADE)
        product = models.ForeignKey(Product, on_delete=models.CASCADE)
        quantity = models.IntegerField()
    ```
  - **Flask**:
    ```python
    order_items = db.Table('order_items',
        db.Column('order_id', db.Integer, db.ForeignKey('orders.id')),
        db.Column('product_id', db.Integer, db.ForeignKey('products.id')),
        db.Column('quantity', db.Integer)
    )

    class Order(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        products = db.relationship('Product', secondary=order_items, backref='orders')

    class Product(db.Model):
        id = db.Column(db.Integer, primary_key=True)
    ```
  - **Sequelize**:
    ```javascript
    const Order = sequelize.define('Order', { /* attributes */ });
    const Product = sequelize.define('Product', { /* attributes */ });

    Order.belongsToMany(Product, { through: 'OrderItem', foreignKey: 'order_id' });
    Product.belongsToMany(Order, { through: 'OrderItem', foreignKey: 'product_id' });
    ```

  - **Sample Data**:

    **orders**
    | **Order ID** | Customer Name |
    |---------------|---------------|
    | 1             | Alice         |
    | 2             | Bob           |

    **products**
    | **Product ID** | Product Name    |
    |----------------|------------------|
    | 101            | Smartphone       |
    | 102            | Laptop           |
    | 103            | T-Shirt          |

    **order_items**
    | **Order ID** | **Product ID** | Quantity |
    |---------------|----------------|----------|
    | 1             | 101            | 2        |
    | 1             | 102            | 1        |
    | 2             | 103            | 4        |

---

- **hasOneThrough** ↔ **belongsTo**
  - **Example**: User hasOneThrough Address via Profile
  - **Laravel**:
    ```php
    class User extends Model {
        public function address() {
            return $this->hasOneThrough(Address::class, Profile::class);
        }
    }

    class Address extends Model {
        public function user() {
            return $this->belongsTo(User::class);
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class User {
        @OneToOne
        @JoinColumn(name = "profile_id")
        private Profile profile;

        @OneToOne(mappedBy = "user")
        private Address address;
    }

    @Entity
    public class Address {
        @OneToOne
        @JoinColumn(name = "user_id")
        private User user;
    }
    ```
  - **Django**:
    ```python
    class User(models.Model):
        profile = models.OneToOneField('Profile', on_delete=models.CASCADE)

        @property
        def address(self):
            return self.profile.address

    class Profile(models.Model):
        user = models.OneToOneField(User, on_delete=models.CASCADE)
        address = models.OneToOneField('Address', on_delete=models.CASCADE)
    ```
  - **Flask**:
    ```python
    class User(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        profile = db.relationship('Profile', backref='user', uselist=False)

    class Address(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        user_id = db.Column(db.Integer, db.ForeignKey('users.id'));
    ```

  - **Sample Data**:

    **users**
    | **User ID** | User Name |
    |--------------|-----------|
    | 1            | Alice     |
    | 2            | Bob       |

    **profiles**
    | **Profile ID** | **User ID** | Bio            |
    |----------------|--------------|----------------|
    | 1              | 1            | Developer      |
    | 2              | 2            | Designer       |

    **addresses**
    | **Address ID** | **User ID** | Address Details            |
    |----------------|--------------|-----------------------------|
    | 1              | 1            | 123 Main St, City, Country |
    | 2              | 2            | 456 Elm St, City, Country   |

---

- **hasManyThrough** ↔ **belongsToMany**
  - **Example**: User hasManyThrough Posts via Comments
  - **Laravel**:
    ```php
    class User extends Model {
        public function posts() {
            return $this->hasManyThrough(Post::class, Comment::class);
        }
    }

    class Post extends Model {
        public function users() {
            return $this->belongsToMany(User::class);
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class User {
        @OneToMany(mappedBy = "user")
        private List<Comment> comments;

        @ManyToMany(mappedBy = "users")
        private List<Post> posts;
    }

    @Entity
    public class Post {
        @ManyToMany
        @JoinTable(name = "post_user",
            joinColumns = @JoinColumn(name = "post_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id"))
        private List<User> users;
    }
    ```
  - **Django**:
    ```python
    class User(models.Model):
        comments = models.ManyToManyField('Comment', related_name='users')

        @property
        def posts(self):
            return Post.objects.filter(comments__user=self)

    class Post(models.Model):
        users = models.ManyToManyField(User, related_name='posts')
    ```
  - **Flask**:
    ```python
    post_user = db.Table('post_user',
        db.Column('post_id', db.Integer, db.ForeignKey('posts.id')),
        db.Column('user_id', db.Integer, db.ForeignKey('users.id'))
    )

    class User(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        comments = db.relationship('Comment', backref='user', lazy=True)
        posts = db.relationship('Post', secondary=post_user, backref='users');

    class Post(db.Model):
        id = db.Column(db.Integer, primary_key=True);
    ```

  - **Sample Data**:

    **users**
    | **User ID** | User Name |
    |--------------|-----------|
    | 1            | Alice     |
    | 2            | Bob       |

    **comments**
    | **Comment ID** | **User ID** | Comment Text       |
    |----------------|--------------|---------------------|
    | 1              | 1            | Great post!         |
    | 2              | 1            | Thanks for sharing! |
    | 3              | 2            | Nice insights!      |

    **posts**
    | **Post ID** | Post Title        |
    |--------------|-------------------|
    | 1            | My First Post     |
    | 2            | Another Post      |

- **Self-Referencing Relationship**
  - **Example**: Employee hasMany Subordinates and belongs to a Supervisor
  - **Laravel**:
    ```php
    class Employee extends Model {
        public function supervisor() {
            return $this->belongsTo(Employee::class, 'supervisor_id');
        }

        public function subordinates() {
            return $this->hasMany(Employee::class, 'supervisor_id');
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Entity
    public class Employee {
        @ManyToOne
        @JoinColumn(name = "supervisor_id")
        private Employee supervisor;

        @OneToMany(mappedBy = "supervisor")
        private List<Employee> subordinates;
    }
    ```
  - **Django**:
    ```python
    class Employee(models.Model):
        supervisor = models.ForeignKey('self', on_delete=models.SET_NULL, null=True, related_name='subordinates')
    ```
  - **Flask**:
    ```python
    class Employee(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        supervisor_id = db.Column(db.Integer, db.ForeignKey('employee.id'))
        supervisor = db.relationship('Employee', remote_side=[id], backref='subordinates')
    ```
  - **Sequelize**:
    ```javascript
    const Employee = sequelize.define('Employee', { /* attributes */ });

    Employee.belongsTo(Employee, { as: 'supervisor', foreignKey: 'supervisor_id' });
    Employee.hasMany(Employee, { as: 'subordinates', foreignKey: 'supervisor_id' });
    ```

  - **Sample Data**:

    **employees**
    | **Employee ID** | Employee Name | Supervisor ID |
    |-----------------|----------------|---------------|
    | 1               | Alice          | null          |
    | 2               | Bob            | 1             |
    | 3               | Carol          | 1             |

---

- **Composite Key Relationship**
  - **Example**: Order hasMany OrderItems (Composite Key: Order ID + Product ID)
  - **Laravel**:
    ```php
    class OrderItem extends Model {
        protected $primaryKey = ['order_id', 'product_id'];
        public $incrementing = false;

        public function order() {
            return $this->belongsTo(Order::class);
        }

        public function product() {
            return $this->belongsTo(Product::class);
        }
    }
    ```
  - **Java Spring Boot**:
    ```java
    @Embeddable
    public class OrderItemKey implements Serializable {
        @Column(name = "order_id")
        private Long orderId;

        @Column(name = "product_id")
        private Long productId;

        // equals() and hashCode() methods
    }

    @Entity
    public class OrderItem {
        @EmbeddedId
        private OrderItemKey id;

        @ManyToOne
        @MapsId("orderId")
        private Order order;

        @ManyToOne
        @MapsId("productId")
        private Product product;
    }
    ```
  - **Django**:
    ```python
    class OrderItem(models.Model):
        order = models.ForeignKey(Order, on_delete=models.CASCADE)
        product = models.ForeignKey(Product, on_delete=models.CASCADE)

        class Meta:
            unique_together = ['order', 'product']
    ```
  - **Flask**:
    ```python
    class OrderItem(db.Model):
        order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), primary_key=True)
        product_id = db.Column(db.Integer, db.ForeignKey('products.id'), primary_key=True)
    ```
  - **Sequelize**:
    ```javascript
    const OrderItem = sequelize.define('OrderItem', {
      order_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
      },
      product_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
      }
    });

    OrderItem.belongsTo(Order);
    OrderItem.belongsTo(Product);
    ```

  - **Sample Data**:

    **order_items**
    | **Order ID** | **Product ID** | Quantity |
    |--------------|----------------|----------|
    | 1            | 101            | 2        |
    | 1            | 102            | 1        |
    | 2            | 103            | 4        |

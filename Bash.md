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

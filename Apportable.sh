#!/bin/sh

readonly portableFolderName="apportable"
readonly rootDir="C:/$portableFolderName"

#==========PROGRAMMING==========#
environment="Programming"
readonly HOME="C:/Users/$USERNAME" # Set the custom home directory dynamically using $USER
# HOME="C:/apportable/Programming/msys64/home/$USERNAME" # Set the custom home directory dynamically using $USER
_7zip_path="$rootDir/$environment/7-Zip"

main() {
    setup_programming_environment
    install_msys2
    # install_cygwin
    create_bash_bat
    open_bash_bat
    setup_rc_files
    setup_git_config
    create_zsh_bat
    install_deno
    install_nvm
    install_php_and_composer
    # setup_php_ini
    install_unzip_zip
    install_sdkman
    install_terraform
    install_heidisql
    # install_dbeaver
    set_windows_terminal_msys2_default
    
    # setup_audio_production
}

setup_programming_environment() {
    [ -d "$rootDir/$environment" ] || mkdir -p "$rootDir/$environment"
}

install_cygwin() {
    destinationDir="$rootDir/$environment/cygwin"
    [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
    
    destinationDirWin=$(cygpath -w "$destinationDir")
    usePortableInstaller=false
    
    if command -v winget >/dev/null 2>&1; then
        if ! winget install --id Cygwin.Cygwin --location "$destinationDirWin" --silent --accept-package-agreements --accept-source-agreements 2>/dev/null; then
            echo "Winget installation failed or Cygwin not available via winget. Using portable installer..."
            usePortableInstaller=true
        fi
    else
        usePortableInstaller=true
    fi
    
    if [ "$usePortableInstaller" = "true" ]; then
        portableInstallerUrl="https://raw.githubusercontent.com/vegardit/cygwin-portable-installer/master/cygwin-portable-installer.cmd"
        installerScript="$destinationDir/cygwin-portable-installer.cmd"
        
        curl -L -o "$installerScript" "$portableInstallerUrl"
        
        if [ -f "$installerScript" ]; then
            installerScriptWin=$(cygpath -w "$installerScript")
            cmd.exe //c "cd /d \"$destinationDirWin\" && \"$installerScriptWin\""
        else
            echo "Failed to download cygwin-portable-installer."
            exit 1
        fi
    fi
    
    echo "Cygwin installation complete."
}

#=====MSYS2=====#
install_msys2() {
    msys2_url="https://github.com/msys2/msys2-installer/releases"
    h2Index=3
    page_content=$(curl -s "$msys2_url")
    h2_text=$(echo "$page_content" | awk -v indexer="$h2Index" 'BEGIN{RS="</h2>"; IGNORECASE=1} NR==indexer{gsub(/.*<h2[^>]*>/,""); print}')
    latest_release_date="$h2_text"
    latest_release_date_without_hyphens=$(echo "$latest_release_date" | tr -d '-')
    mysys2_URL="https://github.com/msys2/msys2-installer/releases/download/$latest_release_date/msys2-base-x86_64-$latest_release_date_without_hyphens.tar.xz"
    tarFile="$rootDir/$environment/msys64.tar.xz"
    curl -L -o "$tarFile" "$mysys2_URL"
    destinationDir="$rootDir/$environment/msys64_temp"

    if [ -f "$tarFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        "$_7zip_path/7z.exe" x -y "$tarFile" -o"$destinationDir"
        tarFileExtracted="$destinationDir/$(basename "$tarFile" .xz)"
        "$_7zip_path/7z.exe" x -y "$tarFileExtracted" -o"$destinationDir" -aoa
        rm -f "$tarFileExtracted"
        echo "Extraction complete."
    else
        echo "Tar file not found: $tarFile"
    fi

    extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
    mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/msys64"
    rm -rf "$destinationDir"
}
#=====MSYS2=====#
open_bash_bat() {
    BAT_PATH="$rootDir/$environment/Bash.bat"
    if [ -f "$BAT_PATH" ]; then
        BAT_PATH_WIN=$(cygpath -w "$BAT_PATH")
        cmd.exe //c start "" "$BAT_PATH_WIN"
    else
        echo "Bash.bat not found at $BAT_PATH"
        echo "Please run create_bash_bat() first"
        return 1
    fi
}
#=====OPEN BASH BAT=====#

#=====RC FILES=====#
setup_rc_files() {
    curl -sL https://raw.githubusercontent.com/judigot/references/main/PATH -o "$HOME/PATH"
    curl -sL https://raw.githubusercontent.com/judigot/references/main/.bashrc -o "$HOME/.bashrc"
    curl -sL https://raw.githubusercontent.com/judigot/references/main/.profile -o "$HOME/.profile"
    curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc"
    curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc"
}
#=====RC FILES=====#

#=====GIT CONFIG=====#
setup_git_config() {
    git config --global init.defaultBranch main
    git config --global core.autocrlf input
    git config --global core.editor "vim"
    git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
}
#=====GIT CONFIG=====#

#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#
create_bash_bat() {
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
}
#=====BATCH FILE TO EXECUTE .SH FILES USING BASH=====#

#=====BATCH FILE TO OPEN ZSH SHELL=====#
create_zsh_bat() {
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
}
#=====BATCH FILE TO OPEN ZSH SHELL=====#

#=====DENO=====#
install_deno() {
    repository="https://github.com/denoland/deno"
    HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
    versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
        $0 ~ pattern {
            match($0, />[^<]+</);
            print substr($0, RSTART + 1, RLENGTH - 2);
            exit;
        }')

    if [[ -z "$versionString" ]]; then
        echo "Failed to fetch the version string."
        exit 1
    fi

    curl -L -o "$rootDir/$environment/deno.zip" "https://github.com/denoland/deno/releases/download/$versionString/deno-x86_64-pc-windows-msvc.zip"
    zipFile="$rootDir/$environment/deno.zip"
    destinationDir="$rootDir/$environment/deno"

    if [ -f "$zipFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        "$_7zip_path/7z.exe" x -y "$zipFile" -o"$destinationDir"
        echo "Extraction complete."
    else
        echo "Zip file not found: $zipFile"
        exit 1
    fi
}
#=====DENO=====#

#=====NVM=====#
install_nvm() {
    repository="https://github.com/coreybutler/nvm-windows"
    HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
    versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
        $0 ~ pattern {
            match($0, />[^<]+</);
            print substr($0, RSTART + 1, RLENGTH - 2);
            exit;
        }')
    nvmLatestVersion="1.2.2"

    curl -L -o "$rootDir/$environment/nvm-noinstall.zip" "https://github.com/coreybutler/nvm-windows/releases/download/$nvmLatestVersion/nvm-noinstall.zip"
    zipFile="$rootDir/$environment/nvm-noinstall.zip"
    destinationDir="$rootDir/$environment/nvm"

    if [ -f "$zipFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        unzip "$zipFile" -d "$destinationDir"
        echo "Extraction complete."
    else
        echo "Zip file not found: $zipFile"
    fi

    NVM_HOME="$destinationDir"
    NVM_SYMLINK="$rootDir/$environment/nodejs"
    export NVM_HOME
    export NVM_SYMLINK
    echo "" >"$NVM_HOME/PATH.txt"
    echo "" >"$NVM_HOME/settings.txt"
    echo "PATH=$PATH" >"$NVM_HOME/PATH.txt"
    export PATH="$PATH:$NVM_HOME:$NVM_SYMLINK"

    if [ -d "/c/Program Files (x86)" ]; then
        SYS_ARCH=64
    else
        SYS_ARCH=32
    fi

    echo "root: $NVM_HOME" >"$NVM_HOME/settings.txt"
    echo "path: $NVM_SYMLINK" >>"$NVM_HOME/settings.txt"
    echo "arch: $SYS_ARCH" >>"$NVM_HOME/settings.txt"
    echo "proxy: none" >>"$NVM_HOME/settings.txt"

    nvm install lts
    nvm use lts
    npm config set script-shell "$rootDir/$environment/PortableGit/bin/bash.exe"
    npm install -g bun pnpm
    pnpm config set store-dir ~/.pnpm-store
}
#=====NVM=====#

#=====PHP=====#
install_php_and_composer() {
    versionString=$(curl -s https://www.php.net/releases/feed.php | awk -F'<php:version>|</php:version>' '/<php:version>/{print $2; exit}')

    if [[ -z "$versionString" ]]; then
        echo "Failed to fetch the version string."
        exit 1
    fi

    PHP_VERSION=$(echo "$versionString" | awk -F'.' '{print $1"."$2}')
    INSTALL_DIR_WIN="C:\\apportable\\Programming\\php"
    INSTALL_DIR="/c/apportable/Programming/php"
    SCRIPT_URL="https://php.new/install/windows/$PHP_VERSION"

    CREATE_WRAPPERS_ONLY="${CREATE_WRAPPERS_ONLY:-false}"
    
    info() {
        printf "\033[44m\033[97m INFO \033[0m %s\n" "$1"
    }
    
    if [ "$CREATE_WRAPPERS_ONLY" = "false" ]; then
        info "Downloading official PHP installer script (version $PHP_VERSION)..."
        TEMP_SCRIPT=$(mktemp).ps1
        curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT" || {
            echo "Failed to download installer script" >&2
            exit 1
        }
        
        info "Modifying installation directory to $INSTALL_DIR_WIN..."
        INSTALL_DIR_ESCAPED=$(echo "$INSTALL_DIR_WIN" | sed 's|\\|\\\\|g')
        # Replace INSTALL_DIR variable to use our portable location instead of $HOME\.config\herd-lite\bin
        sed -i "s|\\\$INSTALL_DIR = \"\\\$HOME\\\\.config\\\\herd-lite\\\\bin\"|\\\$INSTALL_DIR = \"$INSTALL_DIR_ESCAPED\"|g" "$TEMP_SCRIPT"
        
        info "Running installer via PowerShell..."
        TEMP_SCRIPT_WIN=$(cygpath -w "$TEMP_SCRIPT")
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$TEMP_SCRIPT_WIN"
        
        rm -f "$TEMP_SCRIPT"
        
        # Create php.bat wrapper for MSYS2 compatibility (installer doesn't create this)
        info "Creating php.bat wrapper for MSYS2..."
        if [ -f "$INSTALL_DIR/php.exe" ]; then
            cat > "$INSTALL_DIR/php.bat" << 'EOF'
@echo off
"%~dp0php.exe" %*
EOF
            echo "php.bat wrapper created successfully."
        fi
    fi
    
    echo "PHP installation completed at $INSTALL_DIR"
}
#=====PHP=====#

#=====PHP.INI=====#
setup_php_ini() {
    php_ini_path="$rootDir/$environment/php/php.ini"
    php_ini_development="$rootDir/$environment/php/php.ini-development"
    cp "$php_ini_development" "$php_ini_path"

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
}
#=====PHP.INI=====#

#=====UNZIP & ZIP=====#
install_unzip_zip() {
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
}
#=====UNZIP & ZIP=====#

#=====SDKMAN=====#
install_sdkman() {
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
}
#=====SDKMAN=====#

#==========TERRAFORM==========#
install_terraform() {
    repository="https://github.com/hashicorp/terraform"
    HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
    versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
        $0 ~ pattern {
            match($0, />[^<]+</);
            print substr($0, RSTART + 1, RLENGTH - 2);
            exit;
        }')
    versionNumber="${versionString:1}"
    curl -L -o "$rootDir/$environment/terraform.zip" "https://releases.hashicorp.com/terraform/$versionNumber/terraform_${versionNumber}_windows_386.zip"
    zipFile="$rootDir/$environment/terraform.zip"
    destinationDir="$rootDir/$environment/terraform"

    if [ -f "$zipFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        unzip "$zipFile" -d "$destinationDir"
        echo "Extraction complete."
    else
        echo "Zip file not found: $zipFile"
    fi
}
#==========TERRAFORM==========#

#=====DBEAVER=====#
install_dbeaver() {
    URL="https://dbeaver.io/download/"
    htmlContent=$(curl -L --silent "$URL")
    innerHTML="Windows (zip)"
    targetAttribute="href"

    hrefValue=$(echo "$htmlContent" | awk -v innerHTML="$innerHTML" -v attr="$targetAttribute" '
    BEGIN { RS="<a "; FS=">"; OFS="" }
    {
        if (index($0, innerHTML) > 0) {
            for (i = 1; i <= NF; i++) {
                attrRegex = attr "=\"[^\"]+\""
                if (match($i, attrRegex)) {
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

    curl -L -o "$rootDir/$environment/dbeaver.zip" "$dbeaver_URL"
    zipFile="$rootDir/$environment/dbeaver.zip"
    destinationDir="$rootDir/$environment/dbeaver_temp"

    if [ -f "$zipFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        unzip "$zipFile" -d "$destinationDir"
        echo "Extraction complete."
    else
        echo "Zip file not found: $zipFile"
    fi

    extractedContentFolderName=$(find "$destinationDir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
    mv "$destinationDir/$extractedContentFolderName" "$rootDir/$environment/dbeaver"
    rm -rf "$destinationDir"
}
#=====DBEAVER=====#

#=====HEIDISQL=====#
install_heidisql() {
    repository="https://github.com/HeidiSQL/HeidiSQL"
    HTMLPatternToMatch='<span class="css-truncate css-truncate-target text-bold mr-2" style="max-width: none;">'
    versionString=$(curl -s "$repository" | awk -v pattern="$HTMLPatternToMatch" '
        $0 ~ pattern {
            match($0, />[^<]+</);
            print substr($0, RSTART + 1, RLENGTH - 2);
            exit;
        }')
    heidisqlLatestVersion=$(echo "$versionString" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    JDK_URL="https://github.com/HeidiSQL/HeidiSQL/releases/download/v12.13.0.7147/HeidiSQL_12.13_64_Portable.zip"

    curl -L -o "$rootDir/$environment/heidisql.zip" $JDK_URL
    zipFile="$rootDir/$environment/heidisql.zip"
    destinationDir="$rootDir/$environment/heidisql"

    if [ -f "$zipFile" ]; then
        [ -d "$destinationDir" ] || mkdir -p "$destinationDir"
        unzip "$zipFile" -d "$destinationDir"
        echo "Extraction complete."
    else
        echo "Zip file not found: $zipFile"
    fi
}
#=====HEIDISQL=====#

#=====SET MSYS2 AS DEFAULT TERMINAL PROFILE=====#
set_windows_terminal_msys2_default() {
  set -eu

  WT_GUID='{1e38f9e3-abb4-41c5-85e7-2608453b8738}'
  WT_NAME='MSYS2'
  WT_COMMANDLINE='C:\apportable\Programming\Bash.bat'
  WT_ICON='C:\apportable\Programming\msys64\msys2.ico'

  TMP_PS="$(mktemp -t wt_msys2_default_XXXXXX.ps1)"
  trap 'rm -f "$TMP_PS"' 0 1 2 3 15

  cat > "$TMP_PS" <<'POWERSHELL'
param(
  [Parameter(Mandatory = $true)][string]$Guid,
  [Parameter(Mandatory = $true)][string]$Name,
  [Parameter(Mandatory = $true)][string]$CommandLine,
  [Parameter(Mandatory = $true)][string]$Icon
)

function Get-WtSettingsJsonPath {
  $candidates = @(
    "Microsoft.WindowsTerminal",
    "Microsoft.WindowsTerminalPreview",
    "Microsoft.WindowsTerminalCanary"
  )

  foreach ($pkgName in $candidates) {
    $pkg = Get-AppxPackage -Name $pkgName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $pkg) {
      $path = Join-Path $env:LOCALAPPDATA "Packages\$($pkg.PackageFamilyName)\LocalState\settings.json"
      if (Test-Path $path) { return $path }
    }
  }

  $unpackaged = Join-Path $env:LOCALAPPDATA "Microsoft\Windows Terminal\settings.json"
  if (Test-Path $unpackaged) { return $unpackaged }

  throw "Windows Terminal settings.json not found."
}

$settingsPath = Get-WtSettingsJsonPath
Copy-Item -Path $settingsPath -Destination "$settingsPath.bak" -Force

$settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

if ($null -eq $settings.profiles) { $settings | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{}) }
if ($null -eq $settings.profiles.list) { $settings.profiles | Add-Member -NotePropertyName list -NotePropertyValue @() }

$desired = [pscustomobject]@{
  commandline       = $CommandLine
  guid              = $Guid
  hidden            = $false
  icon              = $Icon
  name              = $Name
  startingDirectory = $null
}

$target = $settings.profiles.list | Where-Object { $_.guid -eq $Guid } | Select-Object -First 1
if ($null -eq $target) {
  $target = $settings.profiles.list | Where-Object { $_.name -eq $Name } | Select-Object -First 1
}

if ($null -eq $target) {
  $settings.profiles.list += $desired
} else {
  $target.commandline       = $desired.commandline
  $target.guid              = $desired.guid
  $target.hidden            = $desired.hidden
  $target.icon              = $desired.icon
  $target.name              = $desired.name
  $target.startingDirectory = $desired.startingDirectory
}

# Remove duplicates by name that don't match the desired GUID
$settings.profiles.list = @(
  $settings.profiles.list | Where-Object { $_.name -ne $Name -or $_.guid -eq $Guid }
)

$settings.defaultProfile = $Guid

$settings | ConvertTo-Json -Depth 80 | Set-Content -Path $settingsPath -Encoding utf8

Write-Output ("Updated: " + $settingsPath)
Write-Output ("Backup : " + $settingsPath + ".bak")
Write-Output "Restart Windows Terminal (close all Terminal windows first)."
POWERSHELL

  TMP_PS_WIN="$(cygpath -w "$TMP_PS")"

  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$TMP_PS_WIN" \
    -Guid "$WT_GUID" \
    -Name "$WT_NAME" \
    -CommandLine "$WT_COMMANDLINE" \
    -Icon "$WT_ICON"
}
#=====SET MSYS2 AS DEFAULT TERMINAL PROFILE=====#

#==========PROGRAMMING==========#

#==========AUDIO PRODUCTION==========#
setup_audio_production() {
    environment="Audio Production"
    #=====REAPER=====#
    Clone audio-production
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
    reaperExePath=$(cygpath -w "$rootDir/$environment/reaper-install.exe")
    powershell.exe -Command "Start-Process -FilePath \"$reaperExePath\""
    reaperInstallationPath="$(echo "$rootDir/$environment/REAPER"  | sed 's|/|\\\\|g')"
    echo -e "\e[32mREAPER Portable Installation Directory:\n\n$reaperInstallationPath\e[0m" # Green
    #=====REAPER=====#
}
#==========AUDIO PRODUCTION==========#

main "$@"

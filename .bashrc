#!/bin/bash

# Load aliases
#<SNIPPETS>
[[ -f "$HOME/.snippetsrc" ]] && source "$HOME/.snippetsrc"
#<SNIPPETS/>

# Configuration
PATH_REMOTE_URL="https://raw.githubusercontent.com/judigot/references/main/PATH"
PATH_LOCAL_FILE="$HOME/PATH"

# Function to update path cache asynchronously
update_path_cache() {
    {
        tmp_file="$PATH_LOCAL_FILE.tmp"
        if curl -fsSL "$PATH_REMOTE_URL" -o "$tmp_file" 2>/dev/null; then
            if [[ -s "$tmp_file" ]]; then
                mv "$tmp_file" "$PATH_LOCAL_FILE"
            else
                rm -f "$tmp_file"
            fi
        else
            rm -f "$tmp_file" 2>/dev/null
        fi
    } >/dev/null 2>&1 &
    disown
}

# Load Windows PATH entries (System and User)
load_windows_path() {
    local windows_path=""
    
    # Get Windows system PATH (Machine level)
    if command -v powershell.exe >/dev/null 2>&1; then
        local system_path=$(powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path', 'Machine')" 2>/dev/null)
        if [[ -n "$system_path" ]]; then
            windows_path="$windows_path;$system_path"
        fi
        
        # Get Windows user PATH (User level)
        local user_path=$(powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path', 'User')" 2>/dev/null)
        if [[ -n "$user_path" ]]; then
            windows_path="$windows_path;$user_path"
        fi
    fi
    
    # Convert Windows paths to MSYS2 format and add to PATH
    if [[ -n "$windows_path" ]]; then
        local msys_path=$(echo "$windows_path" | awk -F';' '{
            for (i=1; i<=NF; i++) {
                if ($i != "") {
                    gsub("\\\\", "/", $i);
                    gsub("^[Cc]:", "/c", $i);
                    gsub("^[Dd]:", "/d", $i);
                    gsub("^[Ee]:", "/e", $i);
                    gsub("^[Ff]:", "/f", $i);
                    if ($i ~ /^\/[a-z]/) {
                        printf "%s:", $i
                    }
                }
            }
        }')
        
        if [[ -n "$msys_path" ]]; then
            export PATH="$PATH:$msys_path"
        fi
    fi
}

load_windows_path

# Trigger async path update in background
update_path_cache

# Load from local PATH file
if [[ -f "$PATH_LOCAL_FILE" ]]; then
    paths=$(<"$PATH_LOCAL_FILE")
else
    paths=$(curl -fsSL "$PATH_REMOTE_URL" 2>/dev/null)
fi

# Convert Windows-style paths to Linux format
pathsLinux=$(echo "$paths" | awk -v home="$HOME" '{
    gsub("\\\\", "/");
    gsub("C:", "/c");
    gsub(/\$HOME/, home);
    printf "%s:", $0
}')

export PATH="$PATH:$pathsLinux"

# NVM and Node settings
export NVM_HOME="/c/apportable/Programming/nvm"
export NVM_SYMLINK="/c/apportable/Programming/nodejs"
export BUN_INSTALL_CACHE_DIR="$HOME/.cache/bun"

# These are only needed in Linux terminal. If you are using Windows, you can comment them out.
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SDKMAN
export SDKMAN_DIR="/c/apportable/Programming/sdkman"
[[ -s "/c/apportable/Programming/sdkman/bin/sdkman-init.sh" ]] && source "/c/apportable/Programming/sdkman/bin/sdkman-init.sh"

# Start the SSH agent and add the appropriate SSH key
if [[ "$IS_VS_CODE_FOR_WORK" == "true" ]]; then
    useworkssh
# else
    # usepersonalssh
fi

if [[ "$IS_UBUNTU" == "true" ]]; then
    alias php='/mnt/c/apportable/Programming/php/php.exe'
    alias composer='php /mnt/c/apportable/Programming/php/composer.phar'
    alias laravel='php /mnt/c/apportable/Programming/php/laravel.phar'
fi

# Auto-update terminal files (commented out for manual control)
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.bashrc -o "$HOME/.bashrc" || { echo "Failed to download .bashrc"; return 1; }
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc" || { echo "Failed to download .zshrc"; return 1; }
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc" || { echo "Failed to download .snippetsrc"; return 1; }

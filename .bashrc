#!/bin/bash

# export PATH="$PATH:/c/Users/Jude/AppData/Local/pnpm/nx:/c/Users/Jude/AppData/Roaming/Composer/vendor/bin:/c/apportable/Programming/composer:/c/apportable/Programming/php:/c/apportable/Programming/PortableGit/cmd:/c/apportable/Programming/7-Zip:/c/apportable/Programming/deno:/c/Users/Jude/AppData/Local/pnpm:/c/apportable/Programming/nvm:/c/apportable/Programming/nodejs:/c/apportable/Programming/nodejs/node_modules/npm/bin:/c/apportable/Programming/jdk/bin:/c/apportable/Programming/apache-maven/bin:/c/apportable/Programming/sqlite:/c/apportable/Programming/terraform:/c/apportable/Programming/pulumi/bin:/c/Users/Jude/AppData/Local/Programs/Microsoft VS Code/bin:/c/Program Files/Docker/Docker/resources/bin:/c/ProgramData/DockerDesktop/version-bin:"
paths=$(curl -s https://raw.githubusercontent.com/judigot/references/main/PATH)
pathsLinux=$(echo "$paths" | awk -v home="$HOME" '{
    gsub("\\\\", "/");
    gsub("C:", "/c");
    gsub(/\$HOME/, home);
    printf "%s:", $0
}')
# echo -e "$pathsLinux"
export PATH="$PATH:$pathsLinux"

export JAVA_HOME="/c/apportable/Programming/jdk"
export NVM_HOME="/c/apportable/Programming/nvm"
export NVM_SYMLINK="/c/apportable/Programming/nodejs"

# Start the SSH agent and add the default SSH key to the agent
if [[ "$IS_VS_CODE_FOR_WORK" == "true" ]]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1 && ssh-add ~/.ssh/id_rsa_work >/dev/null 2>&1
else
    eval "$(ssh-agent -s)" >/dev/null 2>&1 && ssh-add ~/.ssh/id_rsa >/dev/null 2>&1
fi

# Source ASDF if it's installed
if [ -d "$HOME/.asdf" ]; then
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"
fi

# Auto-update terminal files
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.bashrc -o "$HOME/.bashrc" || { echo "Failed to download .bashrc"; return 1; }
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc" || { echo "Failed to download .zshrc"; return 1; }
# curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc" || { echo "Failed to download .snippetsrc"; return 1; }

[[ -f "$HOME/.snippetsrc" ]] && source "$HOME/.snippetsrc"

#!/bin/bash

paths=$(curl -s https://raw.githubusercontent.com/judigot/references/main/PATH)

pathsLinux=$(echo "$paths" | awk -v home="$HOME" '{
    gsub("\\\\", "/"); 
    gsub("C:", "/c"); 
    gsub(/\$HOME/, home); 
    printf "%s:", $0
}')

export PATH=$PATH:$pathsLinux
export JAVA_HOME="/c/apportable/Programming/jdk"
export NVM_HOME="/c/apportable/Programming/nvm"
export NVM_SYMLINK="/c/apportable/Programming/nodejs"

# Auto-update terminal files
curl -sL https://raw.githubusercontent.com/judigot/references/main/.bashrc -o "$HOME/.bashrc"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc" && [[ -f "$HOME/.snippetsrc" ]] && source "$HOME/.snippetsrc"
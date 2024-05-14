#!/bin/bash

paths=$(curl -s https://raw.githubusercontent.com/judigot/references/main/PATH)

pathsLinux=$(echo "$paths" | awk -v home="$HOME" -v user="$USER" '{
    gsub("\\\\", "/"); 
    gsub("C:", "/c"); 
    gsub(/\$HOME/, home); 
    printf "%s:", $0
}')

export PATH=$PATH:$pathsLinux
export NVM_HOME="/c/apportable/Programming/nvm"
export NVM_SYMLINK="/c/apportable/Programming/nodejs"

curl -sL https://raw.githubusercontent.com/judigot/references/main/.snippetsrc -o "$HOME/.snippetsrc" && [[ -f "$HOME/.snippetsrc" ]] && source "$HOME/.snippetsrc"
curl -sL https://raw.githubusercontent.com/judigot/references/main/.zshrc -o "$HOME/.zshrc"

#!/bin/bash

#==========SSH==========#
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P "" && clear && echo -e "Copy and paste the public key below to your GitHub account:\n\n\e[32m$(cat ~/.ssh/id_rsa.pub) \e[0m\n" # Green
#==========SSH==========#

#==========TERRAFORM==========#
TERRAFORM_VERSION="1.7.5"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mkdir -p ~/bin
mv terraform ~/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    export PATH=$PATH:$HOME/bin
fi
#==========TERRAFORM==========#
#!/bin/bash

# URL of the webpage
url="https://git-scm.com/downloads"

# Class name of the element you want to extract
className="version"

# Use curl to fetch the webpage content and extract the version using awk
version=$(curl -s "$url" | awk -F'<[^>]*>' "/class=\"$className\"/{getline; gsub(/[[:space:]]/, \"\"); print }")

# Print the type of element and the extracted version
echo "Git version: $version"

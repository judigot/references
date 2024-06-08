#!/bin/bash

readonly PROJECT_NAME="bigbang"

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"

DEV_DEPENDENCIES=(
    "prettier"
)

# Function to get the latest version of an npm package
get_latest_version() {
    local package_name=$1
    local latest_version=$(npm show "$package_name" version)
    echo "$latest_version"
}

# List of packages
DEV_DEPENDENCIES=("package1" "package2" "package3")

# Loop through packages and print their latest versions
for package in "${DEV_DEPENDENCIES[@]}"; do
    latest_version=$(get_latest_version "$package")
    echo "The latest version of $package is $latest_version"
done

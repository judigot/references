#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="app"

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"
readonly PACKAGE_JSON_PATH="$PROJECT_DIRECTORY/package.json"

# Main function
main() {
    local devPackages=("tailwindcss" "nodemon")
    append_dependencies "development" devPackages

    local prodPackages=("express")
    append_dependencies "production" prodPackages
}

# Function to append a dependency to package.json without version
append_to_package_json() {
    local package_name=$1
    local type=$2

    # Read the package.json file and update dependencies or devDependencies
    if ! grep -q "\"$package_name\"" "$PACKAGE_JSON_PATH"; then
        if [ "$type" = "dependencies" ]; then
            sed -i "/\"dependencies\": {/a \ \ \ \ \"$package_name\": \"\"," "$PACKAGE_JSON_PATH"
        elif [ "$type" = "devDependencies" ]; then
            sed -i "/\"devDependencies\": {/a \ \ \ \ \"$package_name\": \"\"," "$PACKAGE_JSON_PATH"
        fi
        echo -e "\e[32mAdded $package_name to $PACKAGE_JSON_PATH\e[0m"
    else
        echo -e "\e[33m$package_name is already in $PACKAGE_JSON_PATH\e[0m"
    fi
}

# Function to append dependencies
append_dependencies() {
    local env=$1
    local -n packages=$2
    local type

    if [ "$env" = "production" ]; then
        type="dependencies"
    elif [ "$env" = "development" ]; then
        type="devDependencies"
    else
        echo -e "\e[31mInvalid environment specified. Use 'production' or 'development'.\e[0m"
        return 1
    fi

    for package in "${packages[@]}"; do
        append_to_package_json "$package" "$type"
    done
}

# Call the main function
main

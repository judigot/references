#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="app"

PRODUCTION_DEPENDENCIES=(
    "axios"
)

DEV_DEPENDENCIES=(
    "prettier"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"
readonly PACKAGE_JSON_PATH="$PROJECT_DIRECTORY/package.json"

# Main function
main() {
    local devPackages=("tailwindcss" "nodemon")
    append_dependencies "development" devPackages DEV_DEPENDENCIES

    local prodPackages=("express")
    append_dependencies "production" prodPackages PRODUCTION_DEPENDENCIES

    local moreProdPackages=("typescript")
    append_dependencies "production" moreProdPackages PRODUCTION_DEPENDENCIES

    installAddedPackages
}

# Function to append dependencies and log the install command
append_dependencies() {
    local env=$1
    local -n packages=$2
    local -n existing_packages=$3
    local install_list=""

    for package in "${packages[@]}"; do
        if ! grep -q "\"$package\"" "$PACKAGE_JSON_PATH"; then
            install_list+="$package "
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    if [ "$env" = "production" ]; then
        existing_packages+=($install_list)
    elif [ "$env" = "development" ]; then
        existing_packages+=($install_list)
    else
        echo -e "\e[31mInvalid environment specified. Use 'production' or 'development'.\e[0m"
        return 1
    fi
}

# Function to finalize the installation
installAddedPackages() {
    local all_dev_dependencies=()
    local all_prod_dependencies=()

    # Check for new and existing dev dependencies
    for package in "${DEV_DEPENDENCIES[@]}"; do
        if ! grep -q "\"$package\"" "$PACKAGE_JSON_PATH"; then
            all_dev_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    # Check for new and existing prod dependencies
    for package in "${PRODUCTION_DEPENDENCIES[@]}"; do
        if ! grep -q "\"$package\"" "$PACKAGE_JSON_PATH"; then
            all_prod_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    if [ ${#all_dev_dependencies[@]} -gt 0 ]; then
        echo "Running: pnpm install -D ${all_dev_dependencies[*]}"
        pnpm install -D ${all_dev_dependencies[*]} &
    fi
    if [ ${#all_prod_dependencies[@]} -gt 0 ]; then
        echo "Running: pnpm install ${all_prod_dependencies[*]}"
        pnpm install ${all_prod_dependencies[*]} &
    fi
    wait
}

# Call the main function
main

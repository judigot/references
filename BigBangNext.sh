#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="bigbangnext"

PRODUCTION_DEPENDENCIES=(
    "axios"
    "@tanstack/react-query"
    "dotenv"
    "dotenv-expand"
)

DEV_DEPENDENCIES=(
    "cross-env"
    "prettier"

    "dotenv-cli"
    "esbuild"
    "esbuild-register"
    "vite-tsconfig-paths"
    "vitest"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"
readonly PACKAGE_JSON_PATH="$PROJECT_DIRECTORY/package.json"

main() {
    echo -e "\e[32mInitializing...\e[0m"
    downloadNextJS
    createEnv
    createEnvExample
    deleteFiles "css"
    codeToBeRemoved=("import { Inter } from 'next/font/google'" "import './globals.css'" " className={inter.className}")
    removeTextContent "codeToBeRemoved[@]"
    # codeToBeRemoved=("import reactLogo from './assets/react.svg'" "import viteLogo from '/vite.svg'")
    # removeTextContent "codeToBeRemoved[@]"
    directories=("components" "helpers" "styles" "tests" "types" "utils")
    createDirectories "$PROJECT_DIRECTORY/src" "directories[@]"
    removeBoilerplate
    removeLayoutBoilerplate

    # ==========CUSTOM SETTINGS========== #
    # Strict mode
    createPrettierRc
    modifyESLintConfig
    codeToBeRemoved=(".tsx")
    removeTextContent "codeToBeRemoved[@]"
    local strictPackages=("@typescript-eslint/eslint-plugin" "@typescript-eslint/parser" "eslint-config-prettier" "eslint-plugin-jsx-a11y" "eslint-plugin-prettier" "eslint-plugin-react" "eslint-plugin-react-hooks" "eslint-plugin-react-refresh")
    append_dependencies "development" strictPackages DEV_DEPENDENCIES

    # tsconfig.node.json
    addStrictNullChecks

    # Testing
    # Jest
    local jestPackages=("jest" "@types/jest" "jest-environment-jsdom" "@testing-library/react" "@testing-library/jest-dom")
    append_dependencies "development" jestPackages DEV_DEPENDENCIES
    createJestConfig

    # Vitest
    # local vitestPackages=("vitest" "@vitejs/plugin-react" "jsdom" "@testing-library/react")
    # append_dependencies "development" "vitestPackages[@]"
    # createJestConfig

    # Prisma
    local devPrismaPackages=("prisma")
    append_dependencies "development" devPrismaPackages DEV_DEPENDENCIES
    local prodPrismaPackages=("@prisma/client")
    append_dependencies "production" prodPrismaPackages PRODUCTION_DEPENDENCIES
    prependToTextContent "$PROJECT_DIRECTORY/package.json" "\"dependencies\": {" "$(
        cat <<EOF
"prisma": {
    "seed": "node -r esbuild-register ./src/prisma/seed/seed.ts",
    "schema": "src/prisma/schema.prisma"
},
EOF
    )"

    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:reset-with-data" "pnpm dotenv -e .env.local -- pnpm run db:drop && pnpm dotenv -e .env.local -- pnpm run prisma:db:push && pnpm dotenv -e .env.local -- pnpm run db:seed"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:seed" "pnpm dotenv -e .env.local -- pnpm prisma db seed"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "db:drop" "pnpm dotenv -e .env.local -- node -r esbuild-register ./src/prisma/scripts/DeleteTables.ts"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:push" "pnpm dotenv -e .env.local -- pnpm prisma db push && pnpm prisma generate"
    editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "prisma:db:pull" "pnpm dotenv -e .env.local -- pnpm prisma db pull && pnpm prisma generate"

    # ==========CUSTOM SETTINGS========== #
    installAddedPackages
    formatCode

    cd "$PROJECT_DIRECTORY" && pnpm prisma init --datasource-provider postgresql
    mv "$PROJECT_DIRECTORY/prisma" "$PROJECT_DIRECTORY/src"
    echo -e "\e[32mBig Bang successfully scaffolded.\e[0m"
}

append_dependencies() {
    cd "$PROJECT_DIRECTORY" || return

    local env=$1
    local -n packages=$2
    local -n existing_packages=$3
    local install_list=""

    # Extract dependencies and devDependencies sections
    local dependencies_section
    dependencies_section=$(awk '/"dependencies": {/,/}/' "$PACKAGE_JSON_PATH")
    local devDependencies_section
    devDependencies_section=$(awk '/"devDependencies": {/,/}/' "$PACKAGE_JSON_PATH")

    for package in "${packages[@]}"; do
        # Check if the package exists in dependencies or devDependencies sections
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
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

editJSON() {
    local filename="$1"
    local action="$2" # "prepend" or "append"
    local key="$3"
    local property="$4"
    local value="$5"
    local tempFile="${filename}.tmp"

    # Use awk to process the file
    awk -v action="$action" -v key="$key" -v prop="$property" -v val="$value" '
    BEGIN { foundKey=0; propertyExists=0; }
    {
        if ($0 ~ "\"" key "\": {") {
            foundKey=1;
            print $0;
            next;
        }
        if (foundKey && $0 ~ "\"" prop "\":") {
            propertyExists=1;
        }
        if (foundKey && $0 ~ /}/) {
            if (action == "append" && !propertyExists) {
                print "    ,\"" prop "\": \"" val "\"";
            }
            foundKey=0;
            propertyExists=0;  # Reset for next key if any
        }
        if (action == "prepend" && foundKey && !propertyExists) {
            print "    \"" prop "\": \"" val "\",";
            propertyExists=1;  # Prevent further prepend
        }
        print $0;
    }' "$filename" >"$tempFile" && mv "$tempFile" "$filename"
}

prependToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local prependText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and prepend the text
        while IFS= read -r line || [[ -n $line ]]; do
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$prependText" >>"$tmpfile"
            fi
            echo "$line" >>"$tmpfile"
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text prepended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

createJestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="jest.config.ts"

    content=$(
        cat <<EOF
import type { Config } from 'jest'
import nextJest from 'next/jest.js'

const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files in your test environment
  dir: './',
})

// Add any custom config to be passed to Jest
const config: Config = {
  coverageProvider: 'v8',
  testEnvironment: 'jsdom',
  // Add more setup options before each test is run
  // setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
}

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
export default createJestConfig(config)
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

createVitestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="vitest.config.ts"

    content=$(
        cat <<EOF
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
  },
})
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

addStrictNullChecks() {
    cd "$PROJECT_DIRECTORY" || return

    replaceLineAfterMatch "tsconfig.json" '"compilerOptions": {' ""strictNullChecks": true,"
}

addVitestReference() {
    cd "$PROJECT_DIRECTORY" || return

    prependToPreviousLineIndex "vite.config.ts" 0 "$(
        cat <<EOF
/// <reference types="vitest" />
EOF
    )"

}

createAppTSX() {
    cd "$PROJECT_DIRECTORY/src/app" || return

    local content=""
    local fileName="App.tsx"

    content=$(
        cat <<EOF
import React from 'react';

App(): JSX.Element {
  const [count, setCount] = React.useState<number>(0);

  return (
    <div style={{zoom: '500%', textAlign: 'center'}}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={(): void => setCount((count: number) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

createPrettierRc() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".prettierrc"

    content=$(
        cat <<EOF
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "trailingComma": "all",
  "jsxBracketSameLine": false,
  "arrowParens": "always",
  "bracketSpacing": true
}
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

modifyESLintConfig() {
    # rm .eslintrc.cjs

    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName=".eslintrc.cjs"

    content=$(
        cat <<EOF
module.exports = {
  root: true,
  settings: {
    react: {
      version: 'detect',
    },
  },
  env: {browser: true, es2020: true},
  extends: [
    'eslint:recommended',
    'plugin:react-hooks/recommended',

    'plugin:@typescript-eslint/strict-type-checked', // Very strict!
    'plugin:@typescript-eslint/stylistic-type-checked', // Very strict!

    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    //
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: [
    'react-refresh',
    //
    'react',
    '@typescript-eslint',
    'react-hooks',
    'jsx-a11y',
    //
  ],
  //
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
  },
  //
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      {allowConstantExport: true},
    ],

    //
    'no-restricted-syntax': [
      'error',
      {
        selector: 'TSEnumDeclaration',
        message: 'Enums are not allowed. Use object literals instead.',
      },
    ],
    'no-alert': ['error'],
    'no-console': ['error', { allow: ['warn', 'error'] }], // Disable all console outputs except console.warn and console.error
    'arrow-body-style': ['error', 'as-needed'],
    'react/react-in-jsx-scope': 'off',
    // '@typescript-eslint/explicit-function-return-type': 'error',
    '@typescript-eslint/no-unnecessary-boolean-literal-compare': ['error'],
    '@typescript-eslint/no-unused-vars': [
      'error',
      { args: 'all', argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
    ],
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/strict-boolean-expressions': 'error',
    // complexity: ['error', 10],
    // 'max-depth': ['error', 4],
    // 'max-lines': ['error', 300],
    'react/jsx-props-no-spreading': 'error',
    'react/jsx-filename-extension': [1, {extensions: ['.tsx']}],
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'error',
  },
};
EOF
    )

    echo "$content" >"$fileName"
    # Check if the file was created successfully
    if [ -e "$fileName" ]; then
        echo -e "\e[32mFile ($fileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $fileName.\e[0m" # Red
    fi
}

createFile() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName="index.html"
    local content=""
    content=$(
        cat <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

downloadNextJS() {
    cd "$ROOT_DIRECTORY" || return

    # Check if the project already exists
    if [ -d "$PROJECT_NAME" ]; then
        rm -rf $PROJECT_NAME
    fi

    pnpm create next-app@latest $PROJECT_NAME --use-pnpm --ts --tailwind --eslint --app --src-dir --import-alias @/* --turbopack

    # Check if the file was created successfully
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "\e[32mProject $PROJECT_NAME successfully scaffolded.\e[0m" # Green
    else
        echo -e "\e[31mProject $PROJECT_NAME failed to scaffold.\e[0m" # Red
    fi
}

deleteFiles() {
    cd "$PROJECT_DIRECTORY/src" || return

    local fileExtension="$1"

    while IFS= read -r -d $'\0' file; do
        rm "$file"

        # Check the exit status of the 'rm' command
        if [ $? -eq 0 ]; then
            echo -e "\e[32mThe file $file was deleted successfully.\e[0m" # Green
        else
            echo -e "\e[31mFailed to delete $file.\e[0m" # Red
        fi
    done < <(find $directory -type f -name "*.$fileExtension" -print0)

}

removeTextContent() {
    cd "$PROJECT_DIRECTORY" || return

    local directory="src"
    local textToRemove=("${!1}")

    local stringToRemove=""
    # Iterate through the array elements and concatenate them
    for value in "${textToRemove[@]}"; do
        stringToRemove="$stringToRemove\|$value"
    done

    # Remove the leading space
    stringToRemove="${stringToRemove# }"

    # Define an empty array to store the filenames
    local fileArray=()

    # Use the find command to search for .tsx files in the chosen directory
    # and append each filename to the array
    while IFS= read -r -d $'\0' file; do
        fileArray+=("$file")
    done < <(find $directory -type f -name "*.tsx" -print0)

    # Print the contents of the array
    for file in "${fileArray[@]}"; do
        local replacement=""

        # Create a temporary file for editing
        local tempFile="tempfile.txt"

        # Use sed to remove the specified string from the file and save the stringToRemove in the temp file
        sed -e "s%\($stringToRemove\)%$replacement%g" "$file" >"$tempFile"
        # Replace the original file with the temp file
        mv "$tempFile" "$file"

        echo -e "\e[32mRemoved unused code from file $file.\e[0m" # Green
    done

}

removeBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="page.tsx"
    local content=""

    content=$(
        cat <<EOF
"use client";

import { useState } from "react";

function Home() {
  const [count, setCount] = useState(0);

  return (
    <div style={{zoom: '500%', textAlign: 'center'}}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={(): void => setCount((count: number) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default Home;
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/app/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/app/$fileName" ]; then
        echo -e "\e[32mBoilerplate in $fileName was successfully removed.\e[0m" # Green
    else
        echo -e "\e[31mFailed to remove boilerplate in $fileName.\e[0m" # Red
    fi
}

removeLayoutBoilerplate() {
    cd "$PROJECT_DIRECTORY" || return

    local fileName="layout.tsx"
    local content=""

    content=$(
        cat <<EOF
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Create Next App',
  description: 'Generated by create next app',
};
function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
export default RootLayout;
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/app/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/app/$fileName" ]; then
        echo -e "\e[32mBoilerplate in $fileName was successfully removed.\e[0m" # Green
    else
        echo -e "\e[31mFailed to remove boilerplate in $fileName.\e[0m" # Red
    fi
}

createDirectories() {
    cd "$PROJECT_DIRECTORY/src" || return

    local directories=("${!2}")

    for value in "${directories[@]}"; do
        mkdir "$value"
        touch "$value/.gitkeep"

        echo -e "\e[32mFolder \e[33m$value\e[0m was successfully created.\e[0m" # Green

    done

}

installDefaultPackages() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm install

    echo -e "\e[32mDefault packages were successfully installed.\e[0m" # Green

}

formatCode() {
    cd "$PROJECT_DIRECTORY" || return

    pnpm prettier --write . --log-level silent

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo -e "\e[32mSuccessfully formatted files.\e[0m" # Green
    else
        echo -e "\e[31mFailed to format files.\e[0m" # Red
    fi

}

removeSetting() {
    cd "$PROJECT_DIRECTORY" || return

    local settingID="$1"
    local file="vite.config.ts"
    local text=""

    text=$(cat $file)

    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # Find the positions of the delimiters
    local start_pos="${text%%"$startDelimiter"*}"
    local end_pos="${text##*"$endDelimiter"}"

    # Remove the text between the delimiters
    local result="${start_pos}${end_pos}"

    echo "$result" >"$PROJECT_DIRECTORY/$file"
}

vite.config.ts__________addBasePath() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="basepath"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        base: "./", // Resolve asset paths after building
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # Line number to append text (change this to the line number you want)
            local line_number=6

            # Create a temporary file
            tempFile="tempfile"

            # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            head -n "$((line_number - 1))" "$file" >"$tempFile"

            # Append the multi-line string to the temporary file
            echo -e "$textToAppend" >>"$tempFile"

            # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            tail -n "+$line_number" "$file" >>"$tempFile"

            # Replace the original file with the temporary file
            mv "$tempFile" "$file"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

vite.config.ts__________addTestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="testConfig"
    local startDelimiter="// <$settingID>"
    local endDelimiter="// </$settingID>"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter
        test: {
            globals: true,
            environment: 'jsdom',
        },
        $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            # # Line number to append text (change this to the line number you want)
            # local line_number=7

            # # Create a temporary file
            # tempFile="tempfile"

            # # Use 'head' to extract the content up to the target line and redirect it to the temporary file
            # head -n "$((line_number - 1))" "$file" >"$tempFile"

            # # Append the multi-line string to the temporary file
            # echo -e "$textToAppend" >>"$tempFile"

            # # Use 'tail' to extract the content from the target line to the end and append it to the temporary file
            # tail -n "+$line_number" "$file" >>"$tempFile"

            # # Replace the original file with the temporary file
            # mv "$tempFile" "$file"

            #=====USAGE=====#
            appendToTextContentIndex "vite.config.ts" 1 "defineConfig" "$(
                cat <<EOF
            $textToAppend
EOF
            )"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

            formatCode
        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

            formatCode
        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

# ====================HELPER FUNCTIONS==================== #
replaceLineAfterMatch() {
    #=====USAGE=====#
    # replaceLineAfterMatch "folderName/example.txt" "matchString" "newStringAfterMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceLineAfterMatch \"folderName/example.txt\" \"matchString\" \"newStringAfterMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "/$match/s/$match.*/$match$newString/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content after match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content after match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

prependToPreviousLineIndex() {
    #=====USAGE=====#
    #     prependToPreviousLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: prependToPreviousLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Insert multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print txt; print; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text inserted after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to insert multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

appendToTextContentIndex() {
    #=====USAGE=====#
    #     appendToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: appendToTextContentIndex <file> <index> <text to match> <text to append>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local appendText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to append text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$appendText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = $i txt;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

createEnv() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName=".env"
    local content=""
    content=$(
        cat <<EOF
# Environment variables declared in this file are automatically made available to Prisma.
# See the documentation for more detail: https://pris.ly/d/prisma-schema#accessing-environment-variables-from-the-schema

# Prisma supports the native connection string format for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB and CockroachDB.
# See the documentation for all the connection string options: https://pris.ly/d/connection-strings

# Supabase
# DATABASE_URL="postgresql://postgres:<password>@db.<host>.supabase.co:<port>/<database>"

# Local MySQL
DATABASE_URL="mysql://<username>:<password>@<host>:<port>/<database>"

# Local PostgreSQL
# DATABASE_URL="postgresql://root:123@localhost:5432/bigbang"

NODE_ENV="development"

VITE_FRONTEND_URL="http://localhost:3000"
VITE_BACKEND_URL="http://localhost:5000"
VITE_API_URL="api"

ACCESS_TOKEN_SECRET=
REFRESH_TOKEN_SECRET=
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

createEnvExample() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName=".env.example"
    local content=""
    content=$(
        cat <<EOF
# Environment variables declared in this file are automatically made available to Prisma.
# See the documentation for more detail: https://pris.ly/d/prisma-schema#accessing-environment-variables-from-the-schema

# Prisma supports the native connection string format for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB and CockroachDB.
# See the documentation for all the connection string options: https://pris.ly/d/connection-strings

# Supabase
# DATABASE_URL="postgresql://postgres:<password>@db.<host>.supabase.co:<port>/<database>"

# Local MySQL
DATABASE_URL="mysql://<username>:<password>@<host>:<port>/<database>"

# Local PostgreSQL
# DATABASE_URL="postgresql://root:123@localhost:5432/bigbang"

NODE_ENV="development"

VITE_FRONTEND_URL="http://localhost:3000"
VITE_BACKEND_URL="http://localhost:5000"
VITE_API_URL="api"

ACCESS_TOKEN_SECRET=
REFRESH_TOKEN_SECRET=
EOF
    )

    echo "$content" >"$htmlFileName"
    # Check if the file was created successfully
    if [ -e "$htmlFileName" ]; then
        echo -e "\e[32mFile ($htmlFileName) was successfully created.\e[0m" # Green
    else
        echo -e "\e[31mFailed to create $htmlFileName.\e[0m" # Red
    fi
}

installAddedPackages() {
    cd "$PROJECT_DIRECTORY" || return

    local all_dev_dependencies=()
    local all_prod_dependencies=()

    # Extract dependencies and devDependencies sections
    local dependencies_section
    dependencies_section=$(awk '/"dependencies": {/,/}/' "$PACKAGE_JSON_PATH")
    local devDependencies_section
    devDependencies_section=$(awk '/"devDependencies": {/,/}/' "$PACKAGE_JSON_PATH")

    # Check for new and existing dev dependencies
    for package in "${DEV_DEPENDENCIES[@]}"; do
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
            all_dev_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    # Check for new and existing prod dependencies
    for package in "${PRODUCTION_DEPENDENCIES[@]}"; do
        if ! echo "$dependencies_section" | grep -q "\"$package\"" &&
            ! echo "$devDependencies_section" | grep -q "\"$package\""; then
            all_prod_dependencies+=("$package")
        else
            echo -e "\e[33m$package is already in $PACKAGE_JSON_PATH\e[0m"
        fi
    done

    pnpm install -D ${all_dev_dependencies[*]} &&
        pnpm install ${all_prod_dependencies[*]}
}
# ====================HELPER FUNCTIONS==================== #

main

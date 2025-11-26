#!/bin/bash

# ====================PROJECT SETTINGS==================== #

readonly PROJECT_NAME="bigbangvite"

PRODUCTION_DEPENDENCIES=(
    "axios"
    "clsx"
    "@tanstack/react-query"
    "dotenv"
    "dotenv-expand"
)

DEV_DEPENDENCIES=(
    "dotenv-cli"
    "prettier"

    "vite-tsconfig-paths"
)

# ====================PROJECT SETTINGS==================== #

# Directories
readonly ROOT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_DIRECTORY="$ROOT_DIRECTORY/$PROJECT_NAME"
readonly PACKAGE_JSON_PATH="$PROJECT_DIRECTORY/package.json"

main() {    
    echo -e "\e[32mInitializing...\e[0m"
    downloadVite
    createEnvExample
    deleteFiles "css"
    codeToBeRemoved=("import './index.css'" "import './App.css'")
    removeTextContent "codeToBeRemoved[@]"
    codeToBeRemoved=("import reactLogo from './assets/react.svg'" "import viteLogo from '/vite.svg'")
    removeTextContent "codeToBeRemoved[@]"
    directories=("components" "helpers" "images" "styles" "tests" "types" "utils")
    createDirectories "$PROJECT_DIRECTORY/src" "directories[@]"
    removeBoilerplate

    # ==========CUSTOM SETTINGS========== #
    viteConfigAddBasePath true # Ensures that assets are imported after building
    viteConfigChangeDevPort true

    # Import shorthand (@)
    addImportShorthand
    viteConfigaddPathAlias true

    # Tailwind
    local tailwindPackages=("tailwindcss" "@tailwindcss/postcss" "autoprefixer" "postcss" "sass")
    append_dependencies "development" tailwindPackages DEV_DEPENDENCIES
    postCSSConfig
    tailwindConfig

    # Strict mode
    createAppTSX
    createPrettierRc
    modifyESLintConfig
    codeToBeRemoved=(".tsx")
    removeTextContent "codeToBeRemoved[@]"
    local strictPackages=("eslint-plugin-import" "eslint-import-resolver-typescript" "@eslint/compat" "globals" "@eslint/js" "@eslint/eslintrc" "@typescript-eslint/eslint-plugin" "@typescript-eslint/parser" "eslint" "eslint-config-prettier" "eslint-plugin-jsx-a11y" "eslint-plugin-prettier" "eslint-plugin-react" "eslint-plugin-react-hooks" "eslint-plugin-react-refresh" "eslint-plugin-no-type-assertion")
    append_dependencies "development" strictPackages DEV_DEPENDENCIES

    # tsconfig.node.json
    addStrictNullChecks

    # Testing
    local testPackages=("vitest" "jest" "@types/jest" "jsdom" "@testing-library/react" "@testing-library/dom" "@testing-library/jest-dom" "@types/bun")
    append_dependencies "development" testPackages DEV_DEPENDENCIES
    addVitestReference
    addVitestConfig

    # Express Server
    local serverPackages=("express" "cors")
    createAPIDirectory
    addAPIToTSConfig
    append_dependencies "production" serverPackages PRODUCTION_DEPENDENCIES
    local serverPackages=("@types/express" "@types/cors" "nodemon" "tsx")
    append_dependencies "development" serverPackages DEV_DEPENDENCIES
    viteConfigNewBuildOutput true
    addDevAndStartScripts
    editTSConfig
    createServerEntryPoint
    createComponentWithAPICall
    recreateMainForLint

    # Deno Support
    # addDenoSupport
    # ==========CUSTOM SETTINGS========== #

    installDefaultPackages &
    installAddedPackages
    formatCode
    initializeGit
    echo -e "Big Bang successfully scaffolded."
}

function addAPIToTSConfig() {
    cd "$PROJECT_DIRECTORY" || return

    echo $PROJECT_DIRECTORY

    replaceLineAfterMatch "tsconfig.app.json" '"include": ' '["src", "api"]'
}

function createAPIDirectory() {
    cd "$PROJECT_DIRECTORY" || return

    mkdir "api"

    echo -e "\e[32mFolder \e[33mapi\e[0m was successfully created.\e[0m" # Green
}

addDenoSupport() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="deno.json"

    content=$(
        cat <<EOF
{
  "compilerOptions": {
    "lib": ["deno.ns", "ESNext", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "strict": true
  },
  "imports": {
    "@/": "./src/"
  }
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

viteConfigChangeDevPort() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="devPort"
    local startDelimiter="/*<$settingID>*/"
    local endDelimiter="/*</$settingID>*/"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter server: { host: true, port: 3000, }, $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            replace "$PROJECT_DIRECTORY/$file" 'export default defineConfig({' "export default defineConfig({ $textToAppend"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

viteConfigaddPathAlias() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="alias"
    local startDelimiter="/*<$settingID>*/"
    local endDelimiter="/*</$settingID>*/"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        import path from 'node:path'; export default defineConfig({ $startDelimiter resolve: { alias: { '@': path.resolve(__dirname, './src') } }, $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            replace "$PROJECT_DIRECTORY/$file" 'export default defineConfig({' "$textToAppend"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

postCSSConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName="postcss.config.js"
    local content=""
    content=$(
        cat <<EOF
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
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

tailwindConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local htmlFileName="tailwind.config.js"
    local content=""
    content=$(
        cat <<EOF
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
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

initializeGit() {
    if command -v git >/dev/null 2>&1; then
        echo "Git is installed."

        cd "$PROJECT_DIRECTORY" || return
        git init && git add . && git commit -m "Initial commit" --quiet
    else
        echo "Git is not installed."
    fi
}

recreateMainForLint() {
    cd "$PROJECT_DIRECTORY/src" || return

    local htmlFileName="main.tsx"
    local content=""
    content=$(
        cat <<EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';

const rootElement = document.getElementById('root');

if (rootElement) {
  ReactDOM.createRoot(rootElement).render(
    <React.StrictMode>
      <App />
    </React.StrictMode>,
  );
}
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

createServerEntryPoint() {
    cd "$PROJECT_DIRECTORY/api" || return

    local htmlFileName="index.ts"
    local content=""
    content=$(
        cat <<EOF
import express, { type Request, type Response } from 'express';
import cors from 'cors';
import path from 'node:path';
import dotenv from 'dotenv';
import process from 'node:process';

dotenv.config();

const app = express();
const PORT = (process.env.PORT ?? 5000).toString();
const platform: string = process.platform;
let __dirname = path.dirname(decodeURI(new URL(import.meta.url).pathname));

if (platform === 'win32') {
  __dirname = __dirname.substring(1);
}

const publicDirectory = path.join(__dirname, 'public');

// Parse JSON from front end
app.use(express.json());

// Enable CORS and serve static files
app.use(cors());
app.use(express.static(publicDirectory));

// Define routes
app.get('/', (_req, res) => {
  const isDevelopment: boolean = String(process.env.NODE_ENV) === 'development';

  if (isDevelopment) {
    res.redirect(String(process.env.VITE_FRONTEND_URL));
    return;
  }

  res.sendFile(publicDirectory);
});

app.get('/api', (_req: Request, res: Response) => {
  res.json({ message: path.join(publicDirectory, 'index.html') });
});

// Start server
app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(\`\${platform.charAt(0).toUpperCase() + platform.slice(1)} is running on http://127.0.0.1:\${PORT}\`);
});
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

createComponentWithAPICall() {
    cd "$PROJECT_DIRECTORY/src" || return

    local htmlFileName="App.tsx"
    local content=""
    content=$(
        cat <<EOF
import React, { useEffect } from 'react';

interface IData {
  message: string;
}

function App() {
  const [data, setData] = React.useState<IData | undefined>(undefined);

  useEffect(() => {
    const backendHost = String(import.meta.env.VITE_BACKEND_HOST ?? '');
    const port = String(import.meta.env.VITE_BACKEND_PORT ?? '5000');
    const apiPath = String(import.meta.env.VITE_API_URL ?? 'api');
    const backendUrl = backendHost ? `\${backendHost}:\${port}` : '';
    const baseUrl = backendUrl ? `\${backendUrl}/\${apiPath}` : `/\${apiPath}`;

    fetch(baseUrl,
      {
        method: 'GET',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          // Authorization: 'Basic ' + btoa('admin:123'),
        },
      },
    )
      .then((res) => res.json())
      .then((data: { message: string }) => {
        setMessage(`\${data.message} - React`);
      })
      .catch(() => {
        setMessage('Backend unavailable');
      });
  }, []);

  return (
    <div style={{ zoom: '500%', textAlign: 'center' }}>
      <pre>
        <code>{JSON.stringify(data, null, 4)}</code>
      </pre>
    </div>
  );
}

export default App;
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

editTSConfig() {
    cd "$PROJECT_DIRECTORY" || return
    # replaceLineAfterMatch "./tsconfig.app.json" '"noEmit":' "false," // Commented to allow allowImportingTsExtensions: true for deno
    # replace "tsconfig.app.json" '"allowImportingTsExtensions": true,' '// "allowImportingTsExtensions": true,'

    # replaceLineAfterMatch "tsconfig.app.json" '\"compilerOptions\": {' "\\n\/\/ <server>\\n\"baseUrl\": \".\/src\", \"rootDir\": \".\/src\", \"outDir\": \".\/dist\", \"allowSyntheticDefaultImports\": true, \"esModuleInterop\": true,\\n\/\/ <server\/>"
    replaceLineAfterMatch "tsconfig.app.json" '\"compilerOptions\": {' "\\n\/\/ <server>\\n\"outDir\": \".\/dist\", \"allowSyntheticDefaultImports\": true, \"esModuleInterop\": true,\\n\/\/ <server\/>"
    # replaceLineAfterMatch "tsconfig.app.json" '\"include\": \[\"src\"\],' '\"exclude\": \[\"**\/*.tsx\"\],'
}

viteConfigNewBuildOutput() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="newBuildOutput"
    local startDelimiter="/* <$settingID> */"
    local endDelimiter="/* </$settingID> */"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter build: { outDir: 'dist/public', }, $endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            replace "$PROJECT_DIRECTORY/$file" 'export default defineConfig({' "export default defineConfig({ $textToAppend"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

addDevAndStartScripts() {
    cd "$PROJECT_DIRECTORY" || return
    replace "package.json" '"dev": "vite",' '"dev": "vite & tsc --noEmit --watch & nodemon --exec tsx api/index.ts", "test": "vitest",'
    replace "package.json" '"lint":' '"start": "node dist/index.js","lint":'
}

addImportShorthand() {
    appendToTextContent "$PROJECT_DIRECTORY/tsconfig.app.json" "\"compilerOptions\": {" "$(
        cat <<EOF
"paths": {
    "@/*": ["./src/*"]
},
EOF
    )" &&
        appendToTextContent "$PROJECT_DIRECTORY/vite.config.ts" "import react" "$(
            cat <<EOF
import tsconfigPaths from "vite-tsconfig-paths";
EOF
        )" &&
        replace "$PROJECT_DIRECTORY/vite.config.ts" "react()" "react(), tsconfigPaths()"
}

replace() {
    # Usage:
    # replace "folderName/*.txt" "matchString" "replacementString"
    # replace "folderName" "matchString" "replacementString"
    # replace "folderName/example.txt" "matchString" "replacementString"

    if [ $# -ne 3 ]; then
        echo "Usage: replace \"folderName/*.txt\" \"matchString\" \"replacementString\""
        return 1
    fi

    local path="$1"
    local match="$2"
    local replacement="$3"

    # Function to escape special characters in the replacement string for sed
    escape_sed_replacement() {
        echo "$replacement" | sed -e 's/[&/\]/\\&/g'
    }

    # Escape special characters in the replacement string
    replacement=$(escape_sed_replacement "$replacement")

    # Replace string in a file using a different delimiter
    replace_in_file() {
        local file=$1
        sed -i "s|$match|$replacement|g" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced '$match' with '$replacement' in $file.\e[0m" ||
            echo -e "\n\e[31mFailed to replace '$match' in $file.\e[0m"
    }

    # Disable glob expansion
    set -f
    # Check if the path is a directory, a single file, or a glob pattern
    if [ -d "$path" ]; then
        for file in "$path"/*; do
            [ -f "$file" ] && replace_in_file "$file"
        done
    elif [ -f "$path" ]; then
        replace_in_file "$path"
    else
        # Re-enable globbing to evaluate the pattern
        set +f
        local files=($path)
        set -f
        if [ ${#files[@]} -gt 0 ]; then
            for file in "${files[@]}"; do
                [ -f "$file" ] && replace_in_file "$file"
            done
        else
            echo -e "\n\e[31mNo files found matching the pattern: $path.\e[0m\n"
            return 1
        fi
    fi
    # Re-enable glob expansion
    set +f
}

appendToTextContent() {
    #=====USAGE=====#
    #     prependToTextContent "folder/example.txt" "textToMatch" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: appendToTextContent <file> <text to match> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local matchText="$2"
    local appendText="$3"

    if [ -e "$file" ]; then
        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and append the text
        while IFS= read -r line || [[ -n $line ]]; do
            echo "$line" >>"$tmpfile"
            if [[ "$line" == *"$matchText"* ]]; then
                echo "$appendText" >>"$tmpfile"
            fi
        done <"$file"

        # Move the temporary file to the original file
        mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text appended successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append multi-line text to file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

addStrictNullChecks() {
    cd "$PROJECT_DIRECTORY" || return

    replaceLineAfterMatch "tsconfig.node.json" '"compilerOptions": {' ""strictNullChecks": true,"
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
    cd "$PROJECT_DIRECTORY/src" || return

    local content=""
    local fileName="App.tsx"

    content=$(
        cat <<EOF
import React from 'react';

function App() {
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
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="eslint.config.js"

    # Get content from github repository
    content=$(curl -s https://raw.githubusercontent.com/judigot/references/main/templates/node.js/config/eslint.config.js)

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

downloadVite() {
    cd "$ROOT_DIRECTORY" || return

    # Check if the project already exists
    if [ -d "$PROJECT_NAME" ]; then
        rm -rf $PROJECT_NAME
    fi

    pnpm create vite $PROJECT_NAME --template react-ts

    # Check if the file was created successfully
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "\e[32mProject $PROJECT_NAME successfully scaffolded.\e[0m" # Green
    else
        echo -e "\e[31mProject $PROJECT_NAME failed to scaffold.\e[0m" # Red
    fi
}

deleteFiles() {
    cd "$PROJECT_DIRECTORY" || return

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

    local fileName="App.tsx"
    local content=""

    content=$(
        cat <<EOF
import { useState } from "react";

function App() {
  const [count, setCount] = useState(0);

  return (
    <div style={{ zoom: "500%", textAlign: "center" }}>
      <h1>Big Bang</h1>
      <div>
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
    </div>
  );
}

export default App;
EOF
    )

    echo "$content" >"$PROJECT_DIRECTORY/src/$fileName"
    # Check if the file was created successfully
    if [ -e "$PROJECT_DIRECTORY/src/$fileName" ]; then
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

    local startDelimiter="/* <$settingID> */"
    local endDelimiter="/* </$settingID> */"

    # Find the positions of the delimiters
    local start_pos="${text%%"$startDelimiter"*}"
    local end_pos="${text##*"$endDelimiter"}"

    # Remove the text between the delimiters
    local result="${start_pos}${end_pos}"

    echo "$result" >"$PROJECT_DIRECTORY/$file"
}

viteConfigAddBasePath() {
    cd "$PROJECT_DIRECTORY" || return

    local isTurnedOn="$1"

    local settingID="basepath"
    local startDelimiter="/* <$settingID> */"
    local endDelimiter="/* </$settingID> */"

    # File to edit
    local file="vite.config.ts"

    # Text to append
    local textToAppend=""
    textToAppend=$(
        cat <<EOF
        $startDelimiter base: "./", /* Resolve asset paths after building */$endDelimiter
EOF
    )

    if [ "$isTurnedOn" = true ]; then

        if grep -q "$settingID" "$file"; then
            echo -e "\e[33mThe following setting is already in $file:\n\n\t$textToAppend\e[0m" # Yellow
        else
            replace "$PROJECT_DIRECTORY/$file" 'export default defineConfig({' "export default defineConfig({ $textToAppend"

            echo -e "\e[32mAdded the following setting to $file:\n\n\t$textToAppend\e[0m"

        fi
    fi

    if [ "$isTurnedOn" = false ]; then

        if grep -q "$settingID" "$file"; then

            removeSetting $settingID

            echo -e "\e[32mSuccessfully removed the following setting from $file:\n\n\t$textToAppend\e[0m" # Green

        else
            echo -e "\e[33mThe following setting is not in $file:\n\n\t$textToAppend\e[0m"
        fi

    fi
}

addVitestConfig() {
    cd "$PROJECT_DIRECTORY" || return

    local content=""
    local fileName="vitest.config.ts"

    content=$(
        cat <<EOF
import { defineConfig } from 'vitest/config';
import { resolve } from 'node:path';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, './src'),
    },
  },
});
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

VITE_BACKEND_HOST="http://localhost"
VITE_API_URL="api"
VITE_BACKEND_PORT=5000

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

VITE_BACKEND_HOST="http://localhost"
VITE_API_URL="api"
VITE_BACKEND_PORT=5000

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
# ====================HELPER FUNCTIONS==================== #

main

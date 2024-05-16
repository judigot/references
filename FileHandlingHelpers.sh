#!/bin/bash

# accept nested directory and filename e.g. foldername/example.txt
# accept multi-line text
# use zero-based indexing for line numbers
# include expected output after running the function
# preserve line breaks
# produce errors if delimeters are not found
# include directory as first parameter

function main() {
    echo -e ""
}

function createDirectories() {
    local directory=$1
    local directories=("${!2}")

    for folderName in "${directories[@]}"; do
        mkdir "$directory/$folderName"
        touch "$directory/$folderName/.gitkeep"

        echo -e "\e[32mFolder \e[33m$folderName\e[0m was successfully created.\e[0m" # Green
    done
}

function editJSON() {
    # editJSON "$PROJECT_DIRECTORY/package.json" "prepend" "scripts" "prepended" "newPropertyValue" &&
    # editJSON "$PROJECT_DIRECTORY/package.json" "append" "scripts" "appended" "newPropertyValue"

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

function replace() {
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
    function escape_sed_replacement {
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

function replaceTextAfterMatch() {
    #=====USAGE=====#
    # replaceTextAfterMatch "folderName/example.txt" "matchString" "newStringAfterMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceTextAfterMatch \"folderName/example.txt\" \"matchString\" \"newStringAfterMatch\""
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

function replaceLineBeforeMatch() {
    #=====USAGE=====#
    # replaceLineBeforeMatch "folderName/example.txt" "matchString" "newStringBeforeMatch"

    # Check if the correct number of arguments is provided
    if [ $# -ne 3 ]; then
        echo "Usage: replaceLineBeforeMatch \"folderName/example.txt\" \"matchString\" \"newStringBeforeMatch\""
        return 1
    fi

    local file="$1"
    local match="$2"
    local newString="$3"

    # Check if the file exists
    if [ -e "$file" ]; then
        sed -i "s/^.*$match/$newString$match/" "$file" &&
            echo -e "\n\e[32mSuccessfully replaced content before match in $file.\e[0m\n" ||
            echo -e "\n\e[31mFailed to replace content before match in $file.\e[0m\n"
    else
        echo -e "\n\e[31mThe file $file does not exist.\e[0m\n"
        return 1
    fi
}

function copyPasteFileOrFolder() {
    #=====USAGE=====#
    # copyPasteFileOrFolder "example.txt" "copied.txt"
    # copyPasteFileOrFolder "folder/example.txt" "anotherFolder/copied.txt"
    # copyPasteFileOrFolder "folder" "anotherFolder"

    if [ "$#" -ne 2 ]; then
        echo -e "\e[31mUsage: copyPasteFileOrFolder <source file/folder> <destination file/folder>\e[0m" # Red
        return 1
    fi

    local source="$1"
    local destination="$2"

    if [ ! -e "$source" ]; then
        echo -e "\e[31mThe source $source does not exist.\e[0m" # Red
        return 1
    fi

    # Create the destination directory if it does not exist
    local destDir=$(dirname "$destination")
    if [ ! -d "$destDir" ]; then
        mkdir -p "$destDir"
    fi

    # Copy the file or directory to the new location
    cp -r "$source" "$destination"

    if [ $? -eq 0 ]; then
        echo -e "\e[32mCopied $source to $destination successfully.\e[0m" # Green
    else
        echo -e "\e[31mFailed to copy $source to $destination.\e[0m" # Red
        return 1
    fi
}

function getFilesByExtensionRecursive() {
    #=====USAGE=====#
    # local fileTypes=(".sh" ".txt")
    # local files="$(getFilesByExtensionRecursive "." "fileTypes[@]")"
    # echo -e "$files"

    if [ "$#" -ne 2 ]; then
        echo "Usage: getFilesByExtension <directory> <array of extensions>"
        return 1
    fi

    local directory="$1"
    local extensions=("${!2}")
    local files=()

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    for ext in "${extensions[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$(basename "$file")")
        done < <(find "$directory" -type f -name "*$ext" -print0)
    done

    printf "%s\n" "${files[@]}"
}

function getFilesByExtension() {
    #=====USAGE=====#
    # local fileTypes=(".sh" ".txt")
    # local files="$(getFilesByExtension "." "fileTypes[@]")"
    # echo -e "$files"

    if [ "$#" -ne 2 ]; then
        echo "Usage: getFilesByExtension <directory> <array of extensions>"
        return 1
    fi

    local directory="$1"
    local extensions=("${!2}")
    local files=()

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    for ext in "${extensions[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$(basename "$file")")
        done < <(find "$directory" -maxdepth 1 -type f -name "*$ext" -print0)
    done

    printf "%s\n" "${files[@]}"
}

function getFileNamesByExtensionRecursive() {
    #=====USAGE=====#
    # names="$(getFileNamesByExtensionRecursive "." "*" true)"
    # echo -e "All .txt files in current directory and subdirectories:\n${names[*]}"

    if [ "$#" -ne 3 ]; then
        echo "Usage: getFileNamesByExtensionRecursive <directory> <extension> <include extension (true/false)>"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local includeExtension="$3"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$includeExtension" = true ]; then
        find "$directory" -type f -name "*$extension" -printf "%f\n"
    else
        find "$directory" -type f -name "*$extension" -printf "%f\n" | sed 's/\.[^.]*$//'
    fi
}

function getFileNamesByExtension() {
    #=====USAGE=====#
    # names="$(getFileNamesByExtension "folder/anotherFolder" "*" true)"
    # echo "Files in the specified directory: ${names[*]}"
    # names="$(getFileNamesByExtension "folder/anotherFolder" ".txt" false)"
    # echo "TXT files in the specified directory: ${names[*]}"

    if [ "$#" -ne 3 ]; then
        echo "Usage: getFileNamesByExtension <directory> <extension> <include extension (true/false)>"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local includeExtension="$3"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$extension" = "*" ]; then
        if [ "$includeExtension" = true ]; then
            find "$directory" -maxdepth 1 -type f -printf "%f\n"
        else
            find "$directory" -maxdepth 1 -type f -printf "%f\n" | sed 's/\.[^.]*$//'
        fi
    else
        if [ "$includeExtension" = true ]; then
            find "$directory" -maxdepth 1 -type f -name "*$extension" -printf "%f\n"
        else
            find "$directory" -maxdepth 1 -type f -name "*$extension" -printf "%f\n" | sed 's/\.[^.]*$//'
        fi
    fi
}

function getFileCountByExtensionRecursive() {
    #=====USAGE=====#
    # count=$(getFileCountByExtensionRecursive "folder/anotherFolder" ".txt")

    if [ "$#" -ne 2 ]; then
        echo "0"
        return 1
    fi

    local directory="$1"
    local extension="$2"

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    # Use find to count files with the specified extension recursively
    local count=$(find "$directory" -type f -name "*$extension" | wc -l)

    echo $count
}

function getFileCountByExtension() {
    #=====USAGE=====#
    # count=$(getFileCountByExtension "folder/anotherFolder" "*")
    # count=$(getFileCountByExtension "folder/anotherFolder" ".txt")

    if [ "$#" -ne 2 ]; then
        echo "0"
        return 1
    fi

    local directory="$1"
    local extension="$2"
    local count=0

    # Check if the specified directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory $directory does not exist."
        return 1
    fi

    if [ "$extension" = "*" ]; then
        count=$(find "$directory" -maxdepth 1 -type f | wc -l)
    else
        count=$(find "$directory" -maxdepth 1 -type f -name "*$extension" | wc -l)
    fi

    echo $count
}

function getContentsBetweenDelimeters() {
    #=====USAGE=====#
    # local content="$(getContentsBetweenDelimeters "example.txt" "<startDelimiter>" "<endDelimiter/>")"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: getContentsBetweenDelimeters <file> <start delimiter> <end delimiter>\e[0m\n" >&2
        return 1
    fi

    local file="$1"
    local startDelimiter="$2"
    local endDelimiter="$3"

    if [ ! -e "$file" ]; then
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" >&2
        return 1
    fi

    # Check if the delimiters exist in the file
    if ! grep -q "$startDelimiter" "$file"; then
        echo -e "\n\e[31mStart delimiter '$startDelimiter' not found in file.\e[0m\n" >&2
        return 1
    fi

    if ! grep -q "$endDelimiter" "$file"; then
        echo -e "\n\e[31mEnd delimiter '$endDelimiter' not found in file.\e[0m\n" >&2
        return 1
    fi

    # Extract and print the contents between the delimiters
    awk -v startDelim="$startDelimiter" -v endDelim="$endDelimiter" \
        'BEGIN {capture=0} 
          ~ startDelim {capture=1; next} 
          ~ endDelim {capture=0} 
         capture && !( ~ endDelim) {print}' "$file"
}

function replaceTextBetweenDelimiters() {
    #=====USAGE=====#
    # replaceTextBetweenDelimiters "folder/example.txt" "<startDelimiter>" "<endDelimiter/>" "$(
    #     cat <<EOF
    # Replacement 1
    # Replacement 2
    # EOF
    # )"

    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: replaceTextBetweenDelimiters <file> <start delimiter> <end delimiter> <replacement text>\e[0m\n"
        return 1
    fi

    local file="$1"
    local startDelimiter="$2"
    local endDelimiter="$3"
    local replacementText="$4"

    if [ ! -e "$file" ]; then
        echo -e "\n\e[31mFile does not exist.\e[0m\n"
        return 1
    fi

    # Check if the delimiters exist in the file
    if ! grep -qF "$startDelimiter" "$file"; then
        echo -e "\n\e[31mStart delimiter not found in file.\e[0m\n"
        return 1
    fi

    if ! grep -qF "$endDelimiter" "$file"; then
        echo -e "\n\e[31mEnd delimiter not found in file.\e[0m\n"
        return 1
    fi

    awk -v s="$startDelimiter" -v e="$endDelimiter" -v r="$replacementText" '
{
    if ($0 ~ s) {
        print;
        print r;
        skip = 1;
    } else if ($0 ~ e) {
        skip = 0;
    }

    if (!skip || $0 ~ e) print;
}' "$file" >temp && mv temp "$file" && echo -e "\n\e[32mText replaced successfully.\e[0m\n" || echo -e "\n\e[31mFailed to replace text.\e[0m\n"
}

function replaceTextBetweenLines() {
    #=====USAGE=====#
    # replaceTextBetweenLines "folder/example.txt" 2 3 "$(
    #         cat <<EOF
    # Replacement 1
    # Replacement 2
    # EOF
    #     )"

    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: replaceTextBetweenLines <file> <start line index> <end line index> <'multi-line replacement text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local startIndex="$2"
    local endIndex="$3"
    local replacementText="$4"

    if [ -e "$file" ]; then
        # Convert from zero-based to one-based indexing
        let "startIndex++"
        let "endIndex++"

        # Create a temporary file for the modified content
        tmpfile=$(mktemp)

        # Process the file and replace the text
        awk -v start="$startIndex" -v end="$endIndex" -v replace="$replacementText" 'NR==start, NR==end { if(NR==start) print replace; next } 1' "$file" >"$tmpfile" && mv "$tmpfile" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText replaced successfully between lines $((startIndex - 1)) and $((endIndex - 1)).\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to replace text in the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function removeLines() {
    #=====USAGE=====#
    # removeLines "example.txt" 1
    # removeLines "example.txt" 1 2

    if [ "$#" -lt 2 ]; then
        echo -e "\n\e[31mUsage: removeLines <file> <start index> [end index]\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local startIndex="$2"
    local endIndex=${3:-$startIndex}

    # Adjusting for zero-based indexing
    let "startIndex++"
    let "endIndex++"

    if [ -e "$file" ]; then
        # Use sed to remove lines from startIndex to endIndex
        sed -i "${startIndex},${endIndex}d" "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mLines removed successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to remove lines from the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToFile() {
    #=====USAGE=====#
    #     prependToFile "folder/example.txt" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 2 ]; then
        echo -e "\n\e[31mUsage: prependToFile <file> <'text to prepend'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local prependText="$2"

    if [ -e "$file" ]; then
        # Read the file content
        local content=$(cat "$file")

        # Prepend the text to the content
        echo -n "$prependText$content" >"$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText prepended successfully to the beginning of the file.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend text to the beginning of the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToFile() {
    #=====USAGE=====#
    #     appendToFile "folder/example.txt" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    if [ "$#" -ne 2 ]; then
        echo -e "\n\e[31mUsage: appendToFile <file> <'text to append'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local appendText="$2"

    if [ -e "$file" ]; then
        # Read the file content
        local content=$(cat "$file")

        # Append the text to the content
        echo -n "$content$appendText" >"$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText appended successfully to the end of the file.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append text to the end of the file.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToPreviousLineIndex() {
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

function appendToNextLineIndex() {
    #=====USAGE=====#
    #     appendToNextLineIndex "example.txt" 4 "$(
    #         cat <<EOF
    # Line 4
    # EOF
    #     )"

    if [ "$#" -ne 3 ]; then
        echo -e "\n\e[31mUsage: appendToNextLineIndex <file> <index> <'multi-line text'>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local insertText="$3"

    if [ -e "$file" ]; then
        # Append multi-line text after the line with the specified index
        awk -v idx="$index" -v txt="$insertText" 'NR==idx+1{print; print txt; next}1' "$file" >tmpfile && mv tmpfile "$file"

        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mMulti-line text appended after line number $index.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to append multi-line text after line number $index.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function prependToTextContentIndex() {
    #=====USAGE=====#
    #     prependToTextContentIndex "folder/example.txt" 0 "text" "$(
    #         cat <<EOF
    # Multi-line
    # text
    # EOF
    #     )"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 4 ]; then
        echo -e "\n\e[31mUsage: prependToTextContentIndex <file> <index> <text to match> <text to prepend>\e[0m\n" # Red
        return 1
    fi

    local file="$1"
    local index="$2"
    local matchText="$3"
    local prependText="$4"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Use awk to prepend text to the nth occurrence of the match
        awk -v idx="$index" -v txt="$prependText" -v pattern="$matchText" '
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ pattern) {
                    count++;
                    if (count == idx + 1) {
                        $i = txt $i;
                        break;
                    }
                }
            }
        }
        {print}' "$file" >tmpfile && mv tmpfile "$file"

        # Check if the awk operation was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mText prepended successfully to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to prepend text to the $((index + 1))th occurrence of '$matchText'.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function appendToTextContentIndex() {
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

function prependToTextContent() {
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

function appendToTextContent() {
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

function getFileContents() {
    #=====USAGE=====#
    # fileContents=$(getFileContents "folderName/example.txt")

    # Check if an argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: getFileContents \"folderName/example.txt\""
        return 1
    fi

    local file="$1"

    # Check if the file exists
    if [ -e "$file" ]; then
        # Read and print the contents of the file
        cat "$file"

        # Check if the file reading was successful
        if [ $? -eq 0 ]; then
            echo -e "\n\e[32mFile contents read successfully.\e[0m\n" # Green
        else
            echo -e "\n\e[31mFailed to read file contents.\e[0m\n" # Red
            return 1
        fi
    else
        echo -e "\n\e[31mFile $file does not exist.\e[0m\n" # Red
        return 1
    fi
}

function createFolders() {
    #=====USAGE=====#
    # createFolders "parentFolder/childFolder"

    # Check if an argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: createFolders \"parentFolder/childFolder\""
        return 1
    fi

    # Extract the folder path from the argument
    local folderPath="$1"

    # Create the folders
    mkdir -p "$folderPath"

    # Check if the folders were created successfully
    if [ $? -eq 0 ]; then
        echo -e "\n\e[32mFolders created successfully: $folderPath\e[0m\n" # Green
    else
        echo -e "\n\e[31mFailed to create folders: $folderPath\e[0m\n" # Red
        return 1
    fi
}

function createFile() {
    #=====USAGE=====#
    # createFile "nonexistentFolder/example.txt" "$(
    #         cat <<EOF
    # Multiline
    # text
    # EOF
    #     )"

    # Check if both file and content arguments are provided
    if [ $# -lt 2 ]; then
        echo "Usage: createFile \"nonexistentFolder/example.txt\" \"\$(
            cat <<EOF
Multiline
text
EOF
        )\""
        return 1
    fi

    local file="$1"
    local content="$2"

    # Extract the directory path from the file
    dir=$(dirname "$file")

    # Create the directory if it doesn't exist
    mkdir -p "$dir"

    # Create the file with the specified content
    echo "$content" >"$file"

    # Check if the file was created successfully
    if [ -e "$file" ]; then
        echo -e "\n\e[32mFile $file was successfully created.\e[0m\n" # Green
    else
        echo -e "\n\e[31mFailed to create $file.\e[0m\n" # Red
    fi
}

main
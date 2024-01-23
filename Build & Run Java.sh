#!/bin/bash

# Build java files; run java files;
# find . -name "*.java" -print0 | xargs -0 javac && find . -name "*.class" -exec sh -c 'classname=$(echo "{}" | sed "s|^\./||" | sed "s|\.class$||" | tr "/" "."); if javap -cp . -public "$classname" | grep -q "public static void main(java.lang.String\[])"; then java -cp . "$classname"; exit 0; fi' \;

# Find all Java files and store them in an array
echo "Finding Java files..."
if ! mapfile -t java_files < <(find . -name "*.java"); then
    echo "Failed to find Java files."
    exit 1
fi

# Check if any Java files were found
if [ ${#java_files[@]} -eq 0 ]; then
    echo "No Java files found."
    exit 1
fi

# Compile all Java files
echo "Compiling Java files..."
if ! javac "${java_files[@]}"; then
    echo "Compilation failed."
    exit 1
fi

echo "Compilation successful."

# Assuming your main class is Main and it's not in a package
echo "Running Main class..."
java Main

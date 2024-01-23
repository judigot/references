import fs from "fs";
import path from "path";

// Read file contents
const fileContents = fs.readFileSync(path.resolve(__dirname, `package.json`));

// Create a file; create file; Write a file; Write file
let fileName: string = "filename.txt";
fs.writeFile(fileName, fileContents, (error) => {
  if (error) return console.log(error);
});

// Check if a directory exists
const folderName = "foldername2";
if (fs.existsSync(folderName)) {
  console.log("The path exists.");
} else {
  // Create a folder in the current directory; create folder; create a directory
  fs.mkdir(folderName, (error) => {
    if (error) return console.log(error);
  });
}

// Delete a folder recursively; delete a directory recursively
fs.rmSync("filename.json", { recursive: true, force: true });

// Copy file
const fileClone = "filename.json";
fs.copyFile("package.json", fileClone, (error) => {
  if (error) return console.log(error);
});

// Check if file exists; Check if a file exists
if (fs.existsSync("filename.txt")) {
  console.log("The file exists.");

  // Delete file; delete a file
  fs.rm("filename.json", (error) => {
    if (error) console.log(error);
  });
}

// Filter certain types
const jsonFiles: string[] = [];

// Loop all files in current directory; Get all files in current directory; Get all files in a directory
fs.readdirSync(path.resolve(__dirname, ``)).map((fileName) => {
  //==========FILTER FILE TYPES==========//
  let targetFileType = "json";

  // Extract filename
  const fileNameWithoutExtension = fileName.substring(
    0,
    fileName.length - targetFileType.length - 1
  );

  // Get file extension; extract file extension
  const fileExtension = fileName.split(".").pop();

  if (fileExtension!.includes(targetFileType)) {
    jsonFiles.push(fileName);
  }
  //==========FILTER FILE TYPES==========//
     javascriptFiles.push(`${file}`);
});
console.log(jsonFiles);

exists "file name or folder name"

Create:
createFile "example.txt" "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog."
createFolder "folderName"
getFileContents "directory or file name"

// Should append or prepend to multiple lines e.b. if there are multiple "src: {", then append or prepend to all "src: {" 
appendToTextContent "example.txt" "text to append" "text to match"
prependToTextContent "example.txt" "text to prepend" "text to match"

// Only append or prepend to the nth match e.g. if there are multiple "src: {", only append or prepend to the 2nd "src: {"

// This should append to the first text that matches "fox":
appendToTextContentIndex "example.txt" 0 "src: {"

// This should prepend to the second text that matches "fox":
prependToTextContentIndex "example.txt" 2 "src: {"

appendToNextLine "example.txt" 5 "text to append"
prependToPreviousLine "example.txt" 2 "text to append"

appendToFile "example.txt" "this text should append to the last character of the last line of file"
prependToFile "example.txt" "this text should prepend to the first character of the first line"

appendToLine "example.txt" 5 "this text should append to the last character of the 5th line"
prependToLine "example.txt" 5 "this text should prepend to the last character of the 5th line"

appendToNextLine "example.txt" 5 "this should be appended to the next line"
prependToNextLine "example.txt" 2 "this should be prepended to the previous line"

// The end parameter should be optional
removeLines(start, end?) "example.txt" 2 3

replaceTextBetweenLines(start, end) "example.txt" 2 3
replaceText "example.txt" 2 3
replaceTextUsingDelimeters "example.txt" 2 3
getContentsByDelimeter "example.txt" "<start>" "</end>"
            
// This should return an array with the file names and their contents
getFileInfo("directoryName")

getFileNames("directoryName")

getFilesByExtension(["html", "js"])

copyPasteFileOrFolder()
replaceLineAfterMatch() // for changing variable values e.g. .env values
replaceLineBeforeMatch() // for changing variable values e.g. .env values
replace
duplicateFileOrFolder()
moveFileOrFolder(source, destination)

// Returns the text content between lines. 1 is the starting line, 2 is the end line. The end parameter should be optional
getLineContents 1, 2

// Returns the starting and endline line of a multi-line text
getLineRangeByTextContent "example.txt" "text content"

Read:

Update:

Delete:

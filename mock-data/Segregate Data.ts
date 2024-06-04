import * as fs from "node:fs";
import * as path from "node:path";

const INPUT_FILE = "./users.ts";
const OUTPUT_DIR = "./users";
const CHUNK_SIZE = 5000;

interface Data {
  id: number;
  first_name: string;
  last_name: string;
  email: string | null;
  gender: string | null;
}

// Ensure the output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR);
}

const main = async () => {
  try {
    // Read the entire content of the input file
    const fileContent = fs.readFileSync(INPUT_FILE, "utf8");

    // Extract the JSON array from the file content
    const jsonArray = JSON.parse(fileContent.replace(/\/\* prettier-ignore \*\/export const users = \[/, '[').replace(/];$/, ']'));

    // Segregate the JSON array into chunks of CHUNK_SIZE
    for (let i = 0; i < jsonArray.length; i += CHUNK_SIZE) {
        const chunk = jsonArray.slice(i, i + CHUNK_SIZE);
        const start = i + 1;
        const end = i + chunk.length;
        const fileName = `Users (${start} - ${end}).ts`;
        const filePath = path.join(OUTPUT_DIR, fileName);
        const fileData = `/* prettier-ignore */ export const users_${start}_to_${end} = [${chunk.map(data => JSON.stringify(data)).join(',\n')}];`;
        fs.writeFileSync(filePath, fileData, "utf8");
    }

    // Create the index file to export all chunks
    const indexFilePath = path.join(OUTPUT_DIR, "index.ts");
    const imports = [];
    const exports = [];

    for (let i = 0; i < jsonArray.length; i += CHUNK_SIZE) {
      const start = i + 1;
      const end = i + CHUNK_SIZE > jsonArray.length ? jsonArray.length : i + CHUNK_SIZE;
      const variableName = `users_${start}_to_${end}`;
      const fileName = `Users (${start} - ${end})`;
      imports.push(`import { ${variableName} } from './${fileName}';`);
      exports.push(`...${variableName}`);
    }

    const indexFileContent = `${imports.join('\n')}\n\nexport const users = [\n${exports.join(',\n')}\n];`;

    fs.writeFileSync(indexFilePath, indexFileContent, "utf8");

    console.log(`Segregated data has been written to ${OUTPUT_DIR} and index file created.`);
  } catch (error) {
    console.error("Error processing files:", error);
  }
};

main();

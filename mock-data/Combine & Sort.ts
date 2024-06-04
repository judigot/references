import * as fs from "node:fs";
import * as path from "node:path";

const INPUT_DIR = "./data";
const OUTPUT_FILE = "./users.ts";

interface Data {
  id: number;
  first_name: string;
  last_name: string;
  email: string | null;
  gender: string | null;
}

const main = async () => {
  try {
    const files = fs.readdirSync(INPUT_DIR);
    const combinedData: Data[] = [];

    let currentId = 1;
    for (const file of files) {
      if (file.endsWith(".json")) {
        const filePath = path.join(INPUT_DIR, file);
        const fileData: Data[] = JSON.parse(fs.readFileSync(filePath, "utf8"));
        
        const slicedData = fileData.slice(100);
        for (const entry of slicedData) {
          combinedData.push({ ...entry, id: currentId });
          currentId++;
        }
      }
    }

    const jsonlData = combinedData.map(data => JSON.stringify(data)).join(',\n');
    const outputData = `/* prettier-ignore */ export const users = [${jsonlData}];`;

    fs.writeFileSync(OUTPUT_FILE, outputData, "utf8");
    console.log(`Combined data has been written to ${OUTPUT_FILE}`);
  } catch (error) {
    console.error("Error processing files:", error);
  }
};

main();
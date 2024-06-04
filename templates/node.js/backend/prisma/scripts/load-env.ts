import { existsSync } from 'fs';
import { resolve, basename } from 'path';
import { config } from 'dotenv';

const envLocalPath = '.env.local';
const envPath = '.env';

const envFile = existsSync(envLocalPath) ? envLocalPath : envPath;
config({ path: resolve(process.cwd(), envFile) });

// eslint-disable-next-line no-console
console.log(`Loaded ${basename(envFile)}\n`);

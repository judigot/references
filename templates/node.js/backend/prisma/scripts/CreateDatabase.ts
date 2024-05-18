import { Prisma, PrismaClient } from '@prisma/client';
import { readFileSync } from 'fs';
import { join } from 'path';

const getSchemaSQL = (): string => {
  const schemaPath = join(__dirname, '../database/schema.sql');
  return readFileSync(schemaPath, 'utf8');
};

const prisma = new PrismaClient();

export async function CreateDatabase() {
  const sql = /*sql*/ `${getSchemaSQL()}`;

  // Split the SQL on semicolons and filter out empty statements
  const statements = sql
    .split(';')
    .map((s) => s.trim())
    .filter((s) => s.length > 0);

  try {
    for (const statement of statements) {
      await prisma.$executeRaw`${Prisma.sql([statement])}`;
    }
    // eslint-disable-next-line no-console
    console.log('Successfully created tables.');
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

export default async function main(): Promise<void> {
  if (require.main === module) {
    await CreateDatabase();
  }
}

void main();

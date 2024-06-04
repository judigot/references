import './load-env';
import { Prisma, PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function DeleteTables() {
  const sql = /*sql*/ `
    DROP SCHEMA public CASCADE;
    CREATE SCHEMA public;
  `;

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
    console.log('Successfully deleted tables.');
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

export default async function main(): Promise<void> {
  if (require.main === module) {
    await DeleteTables();
  }
}

void main();

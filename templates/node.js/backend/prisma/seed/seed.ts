import '../scripts/load-env.ts';

import { PrismaClient, Prisma } from '@prisma/client';

import { users } from './mock-data/users';

type ModelNames = Prisma.ModelName;

const prisma = new PrismaClient();

const tableInfo: Record<
  ModelNames,
  Record<string, null | number | string | boolean>[]
> = {
  user: [
    {
      id: 1,
      username: "johndoe",
      email: "johndoe@example.com",
      password_hash:
        "$2b$12$eJp4Z7Z8q7FJ6a5X5Zb8R.1Zbv8dD6aF7j5jO6f5aD7Zb6jP5R3d2",
      first_name: "John",
      last_name: "Doe",
      created_at: "2024-05-18T12:34:56Z",
      updated_at: "2024-05-18T12:34:56Z",
      deleted_at: null,
    },
  ],
};

function createInsertSQL(
  tableName: string,
  data: Record<string, unknown>[],
): string {
  if (data.length === 0) return '';

  const columns = Object.keys(data[0])
    .map((column) => `"${column}"`)
    .join(', ');

  const values = data
    .map(
      (row) =>
        `(${Object.values(row)
          .map((value) =>
            value === null
              ? 'NULL'
              : typeof value === 'string'
              ? `'${value.replace(/'/g, "''")}'`
              : value,
          )
          .join(', ')})`,
    )
    .join(',\n');

  return `INSERT INTO "${tableName}" (${columns}) VALUES ${values} ON CONFLICT DO NOTHING;`;
}

export async function Seed() {
  try {
    for (const [tableName, rows] of Object.entries(tableInfo)) {
      const sql = createInsertSQL(tableName, rows);
      if (sql) {
        await prisma.$executeRawUnsafe(sql);
        await prisma.$executeRawUnsafe(
          `ALTER SEQUENCE ${tableName}_${
            Object.keys(rows[0])[0]
          }_seq RESTART WITH ${rows.length + 1};`
        );
      }
    }
    // eslint-disable-next-line no-console
    console.log("Successfully seeded data.");
  } catch (error) {
    console.error("Error:", error);
  } finally {
    await prisma.$disconnect();
  }
}

export default async function main(): Promise<void> {
  if (require.main === module) {
    await Seed();
  }
}

void main();

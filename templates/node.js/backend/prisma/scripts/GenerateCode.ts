import { Prisma, PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface ForeignKey {
  foreign_table_name: string;
  foreign_column_name: string;
}

interface ColumnDefinition {
  column_name: string;
  data_type: string;
  is_nullable: string;
  column_default: string | null;
  primary_key: boolean;
  unique: boolean;
  check_constraints: string[];
  foreign_key?: ForeignKey;
}

interface TableDefinition {
  table_name: string;
  table_definition: {
    columns: ColumnDefinition[];
  };
}

async function getTableDefinitions(): Promise<TableDefinition[]> {
  const sql = Prisma.sql`
    WITH columns_info AS ( SELECT table_schema, table_name, column_name, data_type, is_nullable, column_default, ordinal_position FROM information_schema.columns WHERE table_schema = 'public' ), foreign_keys AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema WHERE tc.constraint_type = 'FOREIGN KEY' ), primary_keys AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema WHERE tc.constraint_type = 'PRIMARY KEY' ), unique_constraints AS ( SELECT tc.table_schema, tc.table_name, kcu.column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema WHERE tc.constraint_type = 'UNIQUE' ), check_constraints AS ( SELECT tc.table_schema, tc.table_name, cc.check_clause FROM information_schema.table_constraints AS tc JOIN information_schema.check_constraints AS cc ON tc.constraint_name = cc.constraint_name AND tc.table_schema = cc.constraint_schema WHERE tc.constraint_type = 'CHECK' ) SELECT c.table_name, json_build_object( 'columns', json_agg( CASE WHEN fk.foreign_table_name IS NOT NULL THEN json_build_object( 'column_name', c.column_name, 'data_type', c.data_type, 'is_nullable', c.is_nullable, 'column_default', c.column_default, 'primary_key', (pk.column_name IS NOT NULL), 'unique', (uc.column_name IS NOT NULL), 'check_constraints', ( SELECT json_agg(check_clause) FROM check_constraints cc WHERE cc.table_schema = c.table_schema AND cc.table_name = c.table_name ), 'foreign_key', json_build_object( 'foreign_table_name', fk.foreign_table_name, 'foreign_column_name', fk.foreign_column_name ) ) ELSE json_build_object( 'column_name', c.column_name, 'data_type', c.data_type, 'is_nullable', c.is_nullable, 'column_default', c.column_default, 'primary_key', (pk.column_name IS NOT NULL), 'unique', (uc.column_name IS NOT NULL), 'check_constraints', ( SELECT json_agg(check_clause) FROM check_constraints cc WHERE cc.table_schema = c.table_schema AND cc.table_name = c.table_name ), 'foreign_key', NULL ) END ORDER BY c.ordinal_position ) ) AS table_definition FROM columns_info c LEFT JOIN foreign_keys fk ON c.table_schema = fk.table_schema AND c.table_name = fk.table_name AND c.column_name = fk.column_name LEFT JOIN primary_keys pk ON c.table_schema = pk.table_schema AND c.table_name = pk.table_name AND c.column_name = pk.column_name LEFT JOIN unique_constraints uc ON c.table_schema = uc.table_schema AND c.table_name = uc.table_name AND c.column_name = uc.column_name GROUP BY c.table_name ORDER BY c.table_name;
  `;

  return await prisma.$queryRaw<TableDefinition[]>(sql);
}

function pgToTsType(pgType: string): string {
  switch (pgType) {
    case 'integer':
      return 'number';
    case 'text':
      return 'string';
    case 'boolean':
      return 'boolean';
    // Add more type mappings as needed
    default:
      return 'unknown';
  }
}

function generateTypeScriptInterfaces(definitions: TableDefinition[]): string {
  let interfaces = '';

  definitions.forEach(({ table_name, table_definition }) => {
    interfaces += `interface ${table_name.charAt(0).toUpperCase() + table_name.slice(1)} {\n`;
    table_definition.columns.forEach((column) => {
      interfaces += `  ${column.column_name}: ${pgToTsType(column.data_type)}${column.is_nullable === 'YES' ? ' | null' : ''};\n`;
      if (column.foreign_key) {
        interfaces += `  // Foreign key to ${column.foreign_key.foreign_table_name}.${column.foreign_key.foreign_column_name}\n`;
      }
    });
    interfaces += '}\n\n';
  });

  return interfaces;
}

export async function GenerateTypescriptInterfaces(): Promise<void> {
  try {
    const tableDefinitions = await getTableDefinitions();
    const interfaces = generateTypeScriptInterfaces(tableDefinitions);
    // eslint-disable-next-line no-console
    console.log(interfaces);
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

export default async function main(): Promise<void> {
  if (require.main === module) {
    await GenerateTypescriptInterfaces();
  }
}

void main();

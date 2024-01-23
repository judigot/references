Commands:
  npm init -y
  npm install typescript ts-node @types/node --save-dev
  npm install prisma --save-dev
  npm i @prisma/client
  npx tsc --init
  npx prisma init --datasource-provider mysql

  *Add a custom prisma directory in package.json:
      "prisma": {
        "schema": "src/prisma/schema.prisma"
      },
  *Move the prisma folder to the custom prisma path

  *Set the DATABASE_URL in the .env file to point to your existing database.

  *Create a prisma schema from an existing database:
      npx prisma db pull && npx prisma generate

Sync schema to the database (when developing locally):
      npx prisma db push && npx prisma generate

Draft migration (create a migration file but don't sync):
    *Can be edited before committing

      npx prisma migrate dev --name <renamed-firstname-to-firstName> --create-only

Sync migration files; commit migration changes:
      npx prisma migrate dev

Sync schema to update the Prisma Client in node_modules:
    *Run this everytime the schema is changed
      npx prisma generate
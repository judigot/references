import './load-env';
import { DeleteTables } from './DeleteTables';
import { CreateDatabase } from './CreateDatabase';
import { Seed } from '../seed/seed';

void (async () => {
  try {
    await DeleteTables();
    await CreateDatabase();
    await Seed();
  } catch (error) {
    console.error(
      'An error occurred during the database setup process:',
      error,
    );
  }
})();

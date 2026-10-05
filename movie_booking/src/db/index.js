import pool from '../common/config/db.js';
import { drizzle } from 'drizzle-orm/node-postgres';

const db = drizzle({client: pool});

export default db;
import { Pool } from 'pg';

// Create pool
const pool = new Pool({
    host: 'postgres',   // Container host name
    port: 5432,
    user: 'admin',
    password: 'passu123',
    database: 'nba_db',
    max: 5              // Max amount of connections
});

export default pool;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    gender TEXT
);
-- CREATE TABLE users (
--     id BIGSERIAL PRIMARY KEY,
--     username VARCHAR(32) NOT NULL UNIQUE,
--     email VARCHAR(32) NOT NULL UNIQUE,
--     password_hash TEXT NOT NULL,
--     first_name VARCHAR(50),
--     last_name VARCHAR(50),
--     created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
--     deleted_at TIMESTAMPTZ DEFAULT NULL
-- );
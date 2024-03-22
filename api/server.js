const express = require('express');
const { Pool } = require('pg');
require('dotenv').config({
    path: './.env',
});
const app = express();
app.use(express.json());

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    user: 'openTheBoxUser',
    password: 'openTheBoxPassword',
    database: 'openTheBox'
});

app.post('/users', async (req, res) => {
    const { name, password } = req.body;
    try {
        const result = await pool.query('INSERT INTO users (name, password) VALUES ($1, $2) RETURNING *', [name, password]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/gifts', async (req, res) => {
    const { name, description, text, image, video, music } = req.body;
    try {
        const result = await pool.query('INSERT INTO gift (name, description, text, image, video, music) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *', [name, description, text, image, video, music]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(process.env.PORT, () => {
    console.log('Server is running on port ', process.env.PORT);
});
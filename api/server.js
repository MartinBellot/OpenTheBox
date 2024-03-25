const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcrypt');
const saltRounds = 10;

require('dotenv').config({
    path: './.env',
});
const app = express();
app.use(cors());
app.use(express.json());

const multer = require('multer');

const upload = multer({ storage: multer.memoryStorage() })

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    user: 'openTheBoxUser',
    password: 'openTheBoxPassword',
    database: 'openTheBox'
});

app.post('/users', async (req, res) => {
    const { name, password } = req.body;
    console.log('do call api');
    try {
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        const result = await pool.query('INSERT INTO users (name, password) VALUES ($1, $2) RETURNING *', [name, hashedPassword]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/gifts', async (req, res) => {
    const { name, description, text, image, video, music, gift_from, gift_to } = req.body;
    try {
        const result = await pool.query('INSERT INTO gift (name, description, text, image, video, music, gift_from, gift_to) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *', [name, description, text, image, video, music, gift_from, gift_to]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/signin', async (req, res) => {
    const { name, password } = req.body;
    try {
        const result = await pool.query('SELECT * FROM users WHERE name = $1', [name]);
        if (result.rows.length > 0) {
            const user = result.rows[0];
            const passwordMatch = await bcrypt.compare(password, user.password);
            if (passwordMatch) {
                res.json(user);
            } else {
                res.status(401).json({ error: 'Invalid password' });
            }
        } else {
            res.status(401).json({ error: 'Invalid username or password' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/users/:userId/friends', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await pool.query(`
            SELECT USERS.id, USERS.name 
            FROM friends 
            INNER JOIN USERS ON friends.id_friend = USERS.id 
            WHERE friends.id_user = $1
        `, [userId]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/users/:userId/add/friends', async (req, res) => {
    const { userId } = req.params;
    const { friendId } = req.body;
    try {
        const result = await pool.query('INSERT INTO friends (id_user, id_friend) VALUES ($1, $2) RETURNING *', [userId, friendId]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/users/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await pool.query('SELECT name FROM users WHERE id = $1', [userId]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

const fs = require('fs');
const path = require('path');

app.post('/upload', upload.single('file'), (req, res) => {
    try {
        console.log("try to upload file...");
        if (!req.file) {
            console.log("No file attached");
            return res.status(400).json({ message: "No file attached" });
        }

        // req.file is the `file` file
        // req.file.buffer is a Buffer of the entire file
        const file = req.file.buffer; // This is your file as binary data
        console.log('got file: ', file);

        // Define the path where the file should be saved
        const savePath = path.join(__dirname, 'upload', req.file.originalname);

        // Write the file
        fs.writeFile(savePath, file, (err) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: "Error saving file" });
            }

            return res.status(201).json({ message: "File uploaded successfully" });
        });
    } catch (error) {
        console.error(error);
    }
});

app.get('/download/:filename', (req, res) => {
    // Extract the filename from the request parameters
    const { filename } = req.params;

    // Define the path of the file to be downloaded
    const filePath = path.join(__dirname, 'upload', filename);

    // Send the file for download
    res.download(filePath, (err) => {
        if (err) {
            console.error(err);
            res.status(500).json({ message: "Error downloading file" });
        }
    });
});

app.get('/users/name/:userName', async (req, res) => {
    const { userName } = req.params;
    try {
        const result = await pool.query('SELECT id FROM users WHERE name = $1', [userName]);
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/users/:userId/suggestions', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await pool.query(`
            SELECT id, name 
            FROM USERS 
            WHERE id NOT IN (
                SELECT id_friend 
                FROM friends 
                WHERE id_user = $1
            ) AND id != $1
        `, [userId]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(process.env.PORT, () => {
    console.log('Server is running on port ', process.env.PORT);
});
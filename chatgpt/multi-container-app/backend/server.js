require("dotenv").config();

const express = require("express");
const cors = require("cors");

const { Client } = require("pg");

const app = express();

app.use(cors());

const client = new Client({

    host: process.env.POSTGRES_HOST,

    user: process.env.POSTGRES_USER,

    password: process.env.POSTGRES_PASSWORD,

    database: process.env.POSTGRES_DB,

    port: process.env.POSTGRES_PORT

});

client.connect()
    .then(() => {

        console.log("Connected to PostgreSQL");

    })
    .catch((err) => {

        console.error("Database connection error", err);

    });

app.get("/", async (req, res) => {

    const result =
        await client.query("SELECT NOW()");

    res.json({

        message: "🚀 Backend connected to PostgreSQL",

        time: result.rows[0]

    });

});

app.listen(3000, () => {

    console.log("Backend running on port 3000");

});

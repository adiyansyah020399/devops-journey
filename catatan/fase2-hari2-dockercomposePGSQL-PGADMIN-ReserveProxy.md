# Docker Compose PostgreSQL, pgAdmin & Reverse Proxy

> Catatan belajar Docker Compose lanjutan.
> Fokus memahami PostgreSQL container, environment variables, pgAdmin, reverse proxy nginx, dan architecture multi-container production style.

---

# Tujuan Lab

Membangun stack multi-container yang terdiri dari:

```text
Frontend (Nginx)
Backend API (Node.js)
PostgreSQL
pgAdmin
Reverse Proxy
```

Semua service berjalan menggunakan:

```text
Docker Compose
```

---

# Architecture Final

```text
Browser
   |
   v
Nginx Reverse Proxy
   ├── Frontend
   └── Backend API
            |
            v
       PostgreSQL
            |
            v
         pgAdmin
```

---

# Konsep Yang Dipelajari

# 1. PostgreSQL Container

Database berjalan sebagai container terpisah.

---

# 2. pgAdmin

GUI PostgreSQL berbasis browser.

Digunakan untuk:
- melihat database
- menjalankan query SQL
- monitoring database

---

# 3. Environment Variables

Digunakan untuk:
- menyimpan password
- menyimpan konfigurasi
- memisahkan secret dari source code

---

# 4. Reverse Proxy

Nginx menjadi gerbang utama aplikasi.

Frontend dan backend berjalan dalam:
- satu domain
- satu port

---

# Struktur Project

```text
multi-container-app/
├── docker-compose.yml
├── .env
├── .gitignore
├── nginx.conf
├── frontend/
│   └── index.html
└── backend/
    ├── Dockerfile
    ├── package.json
    ├── package-lock.json
    └── server.js
```

---

# Membuat PostgreSQL Service

# Install PostgreSQL Package

Masuk backend:

```bash
cd backend
```

Install PostgreSQL dependency:

```bash
npm install pg
```

---

# Penjelasan pg

`pg` adalah PostgreSQL client untuk Node.js.

Digunakan untuk:
- connect database
- menjalankan query SQL

---

# Membuat .env

Kembali root project:

```bash
cd ..
```

Create file:

```bash
nano .env
```

Isi:

```env
POSTGRES_USER=devops
POSTGRES_PASSWORD=devops123
POSTGRES_DB=devopsdb
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
```

---

# Kenapa Menggunakan .env?

Karena:
- password tidak hardcoded
- lebih aman
- best practice DevOps
- mudah ganti environment

---

# Update .gitignore

Edit:

```bash
nano .gitignore
```

Tambahkan:

```gitignore
.env
```

---

# Kenapa .env Tidak Dipush?

Karena biasanya berisi:
- password
- API key
- secret

---

# Install dotenv

Masuk backend:

```bash
cd backend
```

Install package:

```bash
npm install dotenv
```

---

# Update server.js

Edit:

```bash
nano server.js
```

Isi:

```javascript
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
```

---

# Penjelasan server.js

# process.env

Membaca variable dari `.env`.

---

# Client()

Digunakan untuk connect PostgreSQL.

---

# SELECT NOW()

Mengambil waktu dari database PostgreSQL.

---

# Membuat docker-compose.yml

Edit:

```bash
nano docker-compose.yml
```

Isi:

```yaml
services:

  postgres:
    image: postgres:15

    container_name: postgres-db

    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}

    ports:
      - "5432:5432"

    volumes:
      - postgres-data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4

    container_name: pgadmin

    environment:
      PGADMIN_DEFAULT_EMAIL: admin@devops.com
      PGADMIN_DEFAULT_PASSWORD: admin123

    ports:
      - "5050:80"

    depends_on:
      - postgres

  backend:
    build: ./backend

    container_name: backend-api

    env_file:
      - .env

    ports:
      - "3000:3000"

    depends_on:
      - postgres

  frontend:
    image: nginx

    container_name: frontend-nginx

    ports:
      - "8080:80"

    volumes:
      - ./frontend:/usr/share/nginx/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf

volumes:
  postgres-data:
```

---

# Penjelasan Compose

# postgres

Container database PostgreSQL.

---

# pgadmin

GUI database PostgreSQL.

---

# env_file

Backend membaca variable dari `.env`.

---

# volumes

```yaml
postgres-data
```

Digunakan untuk:
- persistent database storage
- data tidak hilang

---

# depends_on

Menjalankan dependency service terlebih dahulu.

---

# Membuat nginx.conf

Create file:

```bash
nano nginx.conf
```

Isi:

```nginx
server {

    listen 80;

    location / {

        root /usr/share/nginx/html;

        index index.html;

    }

    location /api/ {

        proxy_pass http://backend:3000/;

    }

}
```

---

# Penjelasan Reverse Proxy

# location /

Menampilkan frontend website.

---

# location /api/

Meneruskan request ke backend container.

---

# proxy_pass

Menghubungkan nginx ke backend service.

---

# Update Frontend index.html

Edit:

```bash
nano frontend/index.html
```

Ganti:

```javascript
fetch("http://localhost:3000")
```

Menjadi:

```javascript
fetch("/api/")
```

---

# Kenapa Menggunakan /api/?

Karena backend sekarang diakses melalui:
- nginx reverse proxy
- bukan langsung port backend

---

# Build & Run Compose

```bash
sudo docker compose up -d --build
```

---

# Check Running Container

```bash
sudo docker ps
```

Harus muncul:

```text
postgres-db
backend-api
frontend-nginx
pgadmin
```

---

# Check Backend Logs

```bash
sudo docker compose logs backend
```

Expected:

```text
Connected to PostgreSQL
```

---

# Test Backend API

```bash
curl localhost:3000
```

Expected:

```json
{
  "message":"🚀 Backend connected to PostgreSQL"
}
```

---

# Test Frontend

Buka:

```text
http://localhost:8080
```

Klik tombol:

```text
Get Backend Message
```

Frontend akan mendapatkan response dari backend API melalui reverse proxy nginx.

---

# Access pgAdmin

Buka:

```text
http://localhost:5050
```

Login:

## Email

```text
admin@devops.com
```

## Password

```text
admin123
```

---

# Register PostgreSQL di pgAdmin

# General Tab

## Name

```text
DevOps PostgreSQL
```

---

# Connection Tab

## Host

```text
postgres
```

---

## Username

```text
devops
```

---

## Password

```text
devops123
```

---

# Test SQL Query

Masuk Query Tool:

```sql
SELECT NOW();
```

---

# Problem Yang Ditemui

# PostgreSQL ECONNREFUSED

Error:

```text
ECONNREFUSED postgres:5432
```

Penyebab:
- PostgreSQL belum fully ready
- backend connect terlalu cepat

---

# Solusi

Restart backend:

```bash
sudo docker compose restart backend
```

---

# Problem Reverse Proxy 404

Error terjadi karena:

```javascript
fetch("/api")
```

Tidak cocok dengan:

```nginx
location /api/
```

---

# Solusi

Gunakan:

```javascript
fetch("/api/")
```

---

# Skill Yang Dipelajari

Yang dipahami:
- PostgreSQL container
- pgAdmin
- environment variables
- dotenv
- reverse proxy nginx
- Docker networking
- backend database integration
- persistent database volume
- API routing
- internal service communication

Skill DevOps yang mulai terbentuk:
- production-style architecture
- backend infrastructure
- service orchestration
- configuration management
- container networking
- reverse proxy management

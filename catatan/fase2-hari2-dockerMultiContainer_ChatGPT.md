# Docker Compose Multi Container App

> Catatan belajar multi-container application menggunakan Docker Compose.
> Fokus memahami komunikasi antar container, backend API container, frontend container, networking Docker Compose, dan CORS.

---

# Apa Itu Multi Container Application?

Aplikasi modern biasanya tidak berjalan dalam satu container saja.

Contoh architecture production:

```text
Frontend
Backend API
Database
Redis
Nginx
```

Setiap service berjalan di container terpisah.

---

# Kenapa Multi Container Penting?

Keuntungan:
- service terisolasi
- mudah scaling
- mudah maintenance
- deployment lebih fleksibel
- lebih mendekati architecture production

---

# Konsep Yang Dipelajari

# 1. Frontend Container

Digunakan untuk:
- menampilkan UI
- website static
- client application

Pada lab ini menggunakan:

```text
Nginx
```

---

# 2. Backend Container

Digunakan untuk:
- API
- business logic
- processing data

Pada lab ini menggunakan:

```text
Node.js + Express
```

---

# 3. Docker Compose Networking

Docker Compose otomatis membuat internal network.

Container dapat saling komunikasi menggunakan:

```text
service name
```

Bukan:
- localhost
- IP manual

---

# Architecture Lab

```text
Browser
   |
   v
Frontend (Nginx)
   |
   v
Backend API (Node.js)
```

---

# Struktur Project

```text
multi-container-app/
├── docker-compose.yml
├── frontend/
│   └── index.html
└── backend/
    ├── Dockerfile
    ├── package.json
    ├── package-lock.json
    └── server.js
```

---

# Membuat Project Folder

```bash
mkdir ~/multi-container-app

cd ~/multi-container-app
```

---

# Membuat Folder Frontend & Backend

```bash
mkdir frontend backend
```

---

# Backend Service

# Masuk ke Folder Backend

```bash
cd backend
```

---

# Membuat package.json

```bash
nano package.json
```

Isi:

```json
{
  "name": "backend-api",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.18.2"
  }
}
```

---

# Penjelasan Dependency

# express

Framework backend Node.js untuk membuat API.

---

# cors

Middleware untuk mengizinkan request dari origin berbeda.

Digunakan karena:
- frontend berjalan di port berbeda
- browser memblok cross-origin request

---

# Install Dependency

```bash
npm install
```

Akan membuat:

```text
package-lock.json
```

---

# Membuat server.js

```bash
nano server.js
```

Isi:

```javascript
const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());

app.get("/", (req, res) => {

    res.json({
        message: "🚀 Hello from backend container"
    });

});

app.listen(3000, () => {

    console.log("Backend running on port 3000");

});
```

---

# Penjelasan server.js

# app.use(cors())

Mengizinkan request dari frontend berbeda origin.

---

# app.get("/")

Endpoint API root.

---

# res.json()

Mengirim response JSON.

---

# app.listen(3000)

Backend berjalan di port 3000.

---

# Membuat Dockerfile Backend

```bash
nano Dockerfile
```

Isi:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

---

# Penjelasan Dockerfile

# FROM node:18-alpine

Menggunakan Node.js image ringan berbasis Alpine Linux.

---

# WORKDIR /app

Set working directory container.

---

# COPY package.json .

Copy package.json ke container.

---

# RUN npm install

Install dependency backend.

---

# COPY . .

Copy semua source code backend.

---

# EXPOSE 3000

Memberitahu container menggunakan port 3000.

---

# CMD

Command pertama saat container berjalan.

```dockerfile
CMD ["node", "server.js"]
```

---

# Frontend Service

# Masuk ke Folder Frontend

```bash
cd ../frontend
```

---

# Membuat index.html

```bash
nano index.html
```

Isi:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Multi Container App</title>
</head>
<body>

    <h1>🚀 Multi Container App</h1>

    <button onclick="loadMessage()">
        Get Backend Message
    </button>

    <p id="result"></p>

    <script>

        async function loadMessage() {

            const response =
                await fetch("http://localhost:3000");

            const data = await response.json();

            document.getElementById("result")
                .innerText = data.message;
        }

    </script>

</body>
</html>
```

---

# Penjelasan Frontend

Frontend:
- memanggil backend API
- menampilkan response backend

Menggunakan:

```javascript
fetch("http://localhost:3000")
```

Untuk request ke backend container.

---

# Membuat docker-compose.yml

Kembali ke root project:

```bash
cd ..
```

---

Create compose file:

```bash
nano docker-compose.yml
```

Isi:

```yaml
services:

  backend:
    build: ./backend

    container_name: backend-api

    ports:
      - "3000:3000"

  frontend:
    image: nginx

    container_name: frontend-nginx

    ports:
      - "8080:80"

    volumes:
      - ./frontend:/usr/share/nginx/html
```

---

# Penjelasan docker-compose.yml

# backend

Service backend API.

---

# build: ./backend

Build image dari Dockerfile backend.

---

# frontend

Service nginx frontend.

---

# volumes

Bind mount folder frontend ke nginx container.

---

# Menjalankan Multi Container App

# Build & Run Compose

```bash
sudo docker compose up -d --build
```

Penjelasan:
- build backend image
- create container
- run container

---

# Check Running Container

```bash
sudo docker ps
```

Harus muncul:

```text
backend-api
frontend-nginx
```

---

# Test Backend API

```bash
curl localhost:3000
```

Expected output:

```json
{
  "message":"🚀 Hello from backend container"
}
```

---

# Test Frontend

Buka browser:

```text
http://localhost:8080
```

Klik tombol:

```text
Get Backend Message
```

Frontend akan menampilkan message dari backend API.

---

# Problem Yang Ditemui

# CORS Error

Error terjadi karena:

```text
frontend -> localhost:8080
backend  -> localhost:3000
```

Browser menganggap:
- origin berbeda
- port berbeda

Dan memblok request.

---

# Solusi CORS

Install package:

```bash
npm install cors
```

Tambahkan:

```javascript
const cors = require("cors");

app.use(cors());
```

---

# Rebuild Backend Image

Karena source backend berubah:

```bash
sudo docker compose up -d --build
```

---

# Docker Compose Commands

# Run Compose

```bash
sudo docker compose up -d
```

---

# Rebuild Compose

```bash
sudo docker compose up -d --build
```

---

# Check Container

```bash
sudo docker ps
```

---

# Check Compose Service

```bash
sudo docker compose ps
```

---

# Check Logs

```bash
sudo docker compose logs
```

---

# Stop Compose

```bash
sudo docker compose down
```

---

# Skill Yang Dipelajari

Yang dipahami:
- multi-container architecture
- frontend container
- backend container
- Docker Compose networking
- backend API
- Node.js containerization
- Express API
- CORS
- compose build workflow

Skill DevOps yang mulai terbentuk:
- microservice basic
- service communication
- container orchestration
- backend deployment workflow
- real application environment

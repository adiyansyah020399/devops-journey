# Catatan Belajar — Fase 2 Hari 3
**Fase 2: Git, Scripting & Cloud | Docker Compose Multi-Service**

---

## 1. Konsep Multi-Service Architecture

Aplikasi production selalu terdiri dari beberapa service:

```
Browser → Frontend (Nginx) → Backend (Python/Node) → Database (MySQL)
```

Tanpa Docker Compose — ribet:
```bash
docker run -d nginx ...
docker run -d python ...
docker run -d mysql ...
```

Dengan Docker Compose — simpel:
```bash
docker compose up -d
```

---

## 2. Struktur Project Multi-Service

```
docker-multiservice/
├── docker-compose.yml    ← konfigurasi semua service
├── html/
│   └── index.html        ← halaman frontend
└── api/
    └── app.py            ← backend Python API
```

---

## 3. docker-compose.yml Multi-Service

```yaml
services:

  # Service 1 - Web Frontend
  web:
    image: nginx:alpine
    container_name: frontend
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - api

  # Service 2 - Backend API
  api:
    image: python:3.11-alpine
    container_name: backend
    ports:
      - "5000:5000"
    volumes:
      - ./api:/app
    working_dir: /app
    command: python app.py
    depends_on:
      - db

  # Service 3 - Database
  db:
    image: mysql:8.0
    container_name: database
    environment:
      MYSQL_ROOT_PASSWORD: devops123
      MYSQL_DATABASE: devopsdb
      MYSQL_USER: devops
      MYSQL_PASSWORD: devops123
    volumes:
      - db_data:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  db_data:    # named volume untuk persistent data
```

---

## 4. Konsep Baru di docker-compose.yml

### depends_on
```yaml
depends_on:
  - api
```
Menentukan urutan service dinyalakan. `web` baru start setelah `api` ready.

### environment
```yaml
environment:
  MYSQL_ROOT_PASSWORD: devops123
  MYSQL_DATABASE: devopsdb
```
Variabel environment — dipakai untuk konfigurasi seperti password dan nama database.

### Named Volume vs Bind Mount
```yaml
# Bind Mount — folder lokal ke container
volumes:
  - ./html:/usr/share/nginx/html

# Named Volume — dikelola Docker, untuk data persistent
volumes:
  - db_data:/var/lib/mysql
```

Named volume tidak hilang saat `docker compose down` — data database tetap ada!

### working_dir & command
```yaml
working_dir: /app
command: python app.py
```
Tentukan folder kerja dan perintah yang dijalankan saat container start.

---

## 5. Service Discovery

Docker Compose otomatis membuat **network** untuk semua service.
Antar service bisa berkomunikasi menggunakan **nama service** sebagai hostname:

```python
# Di dalam container backend, konek ke database:
conn = mysql.connector.connect(
    host="db",      # nama service di docker-compose.yml!
    user="devops",
    password="devops123",
    database="devopsdb"
)
```

Tidak perlu tahu IP address — Docker yang handle routing!

---

## 6. Python API yang Konek ke MySQL

```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import mysql.connector

def get_skills():
    try:
        conn = mysql.connector.connect(
            host="db",           # nama service MySQL
            user="devops",
            password="devops123",
            database="devopsdb"
        )
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM skills")
        skills = cursor.fetchall()
        conn.close()
        return skills
    except Exception as e:
        return {"error": str(e)}

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()

        if self.path == '/skills':
            data = get_skills()
        else:
            data = {
                "status": "ok",
                "service": "DevOps API",
                "endpoints": ["/skills"]
            }

        self.wfile.write(json.dumps(data).encode())

    def log_message(self, format, *args):
        pass

print("API Server running on port 5000")
HTTPServer(('0.0.0.0', 5000), Handler).serve_forever()
```

---

## 7. Perintah Docker Compose

```bash
# Jalankan semua service di background
sudo docker compose up -d

# Lihat status service
sudo docker compose ps

# Lihat log semua service
sudo docker compose logs

# Lihat log service tertentu
sudo docker compose logs api
sudo docker compose logs db

# Restart service tertentu
sudo docker compose restart api

# Stop semua service (container dihapus, volume tetap ada)
sudo docker compose down

# Stop + hapus volume (DATA HILANG!)
sudo docker compose down -v

# Build ulang image
sudo docker compose build

# Pull image terbaru
sudo docker compose pull
```

---

## 8. Perintah MySQL di dalam Container

```bash
# Masuk ke MySQL
sudo docker exec -it database mysql -u devops -pdevops123 devopsdb

# Di dalam MySQL:
SHOW TABLES;
SHOW DATABASES;
DESCRIBE nama_tabel;

# Buat tabel
CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100),
    level VARCHAR(50),
    kategori VARCHAR(50)
);

# Insert data
INSERT INTO skills (nama, level, kategori) VALUES
('Linux', 'Intermediate', 'OS'),
('Docker', 'Beginner', 'Container');

# Query data
SELECT * FROM skills;
SELECT * FROM skills WHERE level = 'Intermediate';

# Keluar
EXIT;
```

---

## 9. Install Package di Container yang Berjalan

```bash
# Install python package di container backend
sudo docker exec -it backend pip install mysql-connector-python

# Catatan: cara yang lebih baik adalah tambahkan di Dockerfile
# supaya otomatis terinstall saat build image
```

---

## 10. Arsitektur yang Dibangun

```
Request dari Browser
        ↓
   Nginx (port 8080)
   /var/www/html/index.html
        ↓
   Python API (port 5000)
   GET /skills
        ↓
   MySQL (port 3306)
   SELECT * FROM skills
        ↓
   JSON Response ke Browser
```

---

## 11. Test Endpoint API

```bash
# Test root endpoint
curl localhost:5000
# Response: {"status":"ok","service":"DevOps API","endpoints":["/skills"]}

# Test skills endpoint
curl localhost:5000/skills
# Response: [{"id":1,"nama":"Linux",...}, ...]

# Test frontend
curl localhost:8080
```

---

## 12. Error Umum

```
Port already allocated
→ Port sudah dipakai container lain
→ Fix: sudo docker ps, lalu stop container lama

Container keeps restarting
→ Ada error di script/app
→ Fix: sudo docker compose logs nama-service

Permission denied docker socket
→ User tidak ada di group docker
→ Fix: sudo usermod -aG docker $USER, lalu newgrp docker

Cannot connect to database
→ Database belum ready saat backend start
→ Fix: tambahkan depends_on atau retry logic di kode
```

---

## Milestone Hari Ini ✅

- Docker Compose multi-service (3 container sekaligus)
- Service discovery antar container
- Named volume untuk persistent database
- depends_on untuk urutan startup
- Environment variables untuk konfigurasi
- Python API konek ke MySQL database
- Full stack app: Nginx + Python + MySQL
- REST API endpoint `/skills` return JSON dari database

---

## Progress Fase 2

```
Minggu 1 ✅ → Git & GitHub
Minggu 2 ✅ → Docker Dasar, Volume, Compose
Minggu 3 ✅ → Docker Compose Multi-Service
Minggu 4 ⬅️ → CI/CD dengan GitHub Actions
```

---

*Selanjutnya: CI/CD dengan GitHub Actions — otomasi build & deploy otomatis setiap push ke GitHub!*

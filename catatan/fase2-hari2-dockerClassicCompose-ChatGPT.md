# Docker Compose Basic

> Catatan belajar Docker Compose dari nol.
> Fokus memahami automation container, docker-compose.yml, service management, bind mount, dan workflow development menggunakan Docker Compose.

---

# Apa Itu Docker Compose?

Docker Compose adalah tool untuk menjalankan multiple container menggunakan satu file konfigurasi.

Semua konfigurasi disimpan di:

```text
docker-compose.yml
```

Dengan Docker Compose:
- container lebih mudah dikelola
- tidak perlu menjalankan banyak command docker run
- environment aplikasi bisa dibuat otomatis

---

# Kenapa Docker Compose Penting?

Dalam aplikasi nyata biasanya terdapat banyak service:

```text
Frontend
Backend API
Database
Redis
Nginx
```

Tanpa Docker Compose:

```bash
docker run ...
docker run ...
docker run ...
docker run ...
```

Sulit dikelola.

Dengan Docker Compose cukup:

```bash
docker compose up
```

Semua container langsung berjalan otomatis.

---

# Konsep Dasar Docker Compose

# 1. Service

Service adalah definisi container.

Contoh:

```yaml
services:

  web:
    image: nginx
```

`web` adalah nama service.

---

# 2. Image

Menentukan image yang digunakan.

```yaml
image: nginx
```

---

# 3. Container Name

Memberi nama container.

```yaml
container_name: compose-nginx
```

---

# 4. Port Mapping

Menghubungkan port host ke container.

```yaml
ports:
  - "8085:80"
```

Artinya:

```text
localhost:8085 -> container:80
```

---

# 5. Volume / Bind Mount

Menghubungkan file/folder local ke container.

```yaml
volumes:
  - ./index.html:/usr/share/nginx/html/index.html
```

---

# Struktur Project

```text
docker-compose-lab/
├── docker-compose.yml
├── index.html
├── about.html
└── style.css
```

---

# Membuat Project Folder

```bash
mkdir ~/docker-compose-lab
cd ~/docker-compose-lab
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
    <title>DevOps Compose Lab</title>

    <link rel="stylesheet" href="style.css">
</head>
<body>

    <h1>🚀 Docker Compose Challenge</h1>

    <p>
        Belajar Docker Compose bersama Adi
    </p>

    <a href="about.html">
        About Me
    </a>

</body>
</html>
```

---

# Membuat about.html

```bash
nano about.html
```

Isi:

```html
<!DOCTYPE html>
<html>
<head>
    <title>About Me</title>

    <link rel="stylesheet" href="style.css">
</head>
<body>

    <h1>👨‍💻 About Me</h1>

    <p>
        Nama saya Muhamad Adiyansyah
    </p>

    <p>
        Sedang belajar menjadi DevOps Engineer 🚀
    </p>

    <a href="index.html">
        Back To Home
    </a>

</body>
</html>
```

---

# Membuat style.css

```bash
nano style.css
```

Isi:

```css
body {
    background: #0d1117;
    color: #58a6ff;
    font-family: monospace;
    text-align: center;
    padding-top: 80px;
}

h1 {
    font-size: 40px;
}

p {
    color: #c9d1d9;
    font-size: 18px;
}

a {
    color: #58a6ff;
    text-decoration: none;
    border: 1px solid #58a6ff;
    padding: 10px 20px;
    border-radius: 5px;
}

a:hover {
    background: #58a6ff;
    color: black;
}
```

---

# Membuat docker-compose.yml

```bash
nano docker-compose.yml
```

Isi:

```yaml
services:

  web:
    image: nginx

    container_name: devops-compose-lab

    ports:
      - "9090:80"

    volumes:
      - ./:/usr/share/nginx/html
```

---

# Penjelasan docker-compose.yml

# services

Tempat mendefinisikan container/service.

---

# web

Nama service.

Bisa bebas:
- web
- backend
- mysql
- redis

---

# image

Image yang digunakan container.

```yaml
image: nginx
```

---

# container_name

Nama container Docker.

```yaml
container_name: devops-compose-lab
```

---

# ports

Port mapping.

```yaml
ports:
  - "9090:80"
```

Artinya:

```text
localhost:9090 -> container:80
```

---

# volumes

Bind mount folder project ke nginx container.

```yaml
volumes:
  - ./:/usr/share/nginx/html
```

Artinya:
- semua file project local otomatis terbaca container

Termasuk:
- html
- css
- javascript
- image

---

# Menjalankan Docker Compose

## Run Compose

```bash
sudo docker compose up -d
```

Penjelasan:
- `up`
  → menjalankan service

- `-d`
  → mode background

Docker Compose akan:
- membaca docker-compose.yml
- pull image
- membuat container
- menjalankan container

Secara otomatis.

---

# Check Running Container

```bash
sudo docker ps
```

Pastikan status:

```text
Up
```

---

# Check Compose Service

```bash
sudo docker compose ps
```

---

# Test Website

## Browser

Buka:

```text
http://localhost:9090
```

---

## Curl

```bash
curl localhost:9090
```

---

# Realtime Update

Karena menggunakan bind mount:

```yaml
volumes:
  - ./:/usr/share/nginx/html
```

Maka perubahan file local langsung muncul di container.

Tanpa:
- rebuild image
- restart container

---

# Test Realtime Update

Edit:

```bash
nano style.css
```

Ubah misalnya:

```css
background: black;
```

Refresh browser.

Perubahan langsung muncul.

---

# Check Compose Logs

```bash
sudo docker compose logs
```

Digunakan untuk:
- debugging
- melihat log service

---

# Restart Compose

```bash
sudo docker compose restart
```

---

# Stop Compose

```bash
sudo docker compose down
```

Penjelasan:
- stop semua service
- remove container compose

---

# Perbedaan Docker Run vs Docker Compose

# Docker Run

Semua command manual.

```bash
docker run ...
docker run ...
docker run ...
```

Kurang efisien untuk banyak container.

---

# Docker Compose

Semua konfigurasi tersimpan di:

```text
docker-compose.yml
```

Menjalankan semua service cukup:

```bash
docker compose up
```

Lebih automation dan mudah dikelola.

---

# Challenge yang Dikerjakan

# Challenge 1

Membuat:
- index.html
- about.html
- style.css

---

# Challenge 2

Menggunakan custom port:

```text
9090
```

---

# Challenge 3

Menggunakan custom container name:

```text
devops-compose-lab
```

---

# Challenge 4

Menggunakan bind mount seluruh project folder.

---

# Challenge 5

Melakukan realtime update tanpa rebuild image.

---

# Error yang Ditemui

# Port Already Allocated

Error:

```bash
Bind for 0.0.0.0 failed: port is already allocated
```

Penyebab:
- port sudah digunakan container lain

Check:

```bash
sudo docker ps
```

Gunakan port lain atau stop container lama.

---

# Permission Denied Docker Socket

Error:

```bash
permission denied while trying to connect to the docker API socket
```

Fix:

```bash
sudo usermod -aG docker devops
```

Lalu logout/login ulang terminal.

---

# Skill Yang Dipelajari

Yang dipahami:
- Docker Compose
- Service
- Compose workflow
- Bind mount
- Automation container
- Port mapping
- Compose logs
- Compose restart
- Compose down

Skill DevOps yang mulai terbentuk:
- infrastructure as code
- container orchestration basic
- automation workflow
- development environment management

# Docker Volume & Bind Mount

> Catatan belajar Docker Volume dan Bind Mount.
> Fokus memahami persistent storage, sharing data antara host dan container, serta realtime development workflow.

---

# Apa Itu Docker Volume?

Secara default container Docker bersifat sementara (ephemeral).

Artinya:
- ketika container dihapus
- data di dalam container ikut hilang

Contoh:
- database MySQL di dalam container
- container dihapus
- semua data hilang

Untuk mengatasi itu Docker menyediakan:
- Volume
- Bind Mount

Agar data tetap tersimpan walaupun container dihapus.

---

# Kenapa Docker Volume Penting?

Dalam dunia production:
- aplikasi membutuhkan data persistent
- data tidak boleh hilang saat container restart/remove

Contoh penggunaan:
- database
- upload file
- nginx log
- redis data
- application storage

---

# Jenis Storage Docker

# 1. Anonymous Volume

Docker otomatis membuat volume tanpa nama.

Jarang digunakan manual.

---

# 2. Named Volume

Volume memiliki nama.

Contoh:

```bash
docker volume create mysql-data
```

Keuntungan:
- mudah dikelola
- reusable
- cocok production

---

# 3. Bind Mount

Mapping folder local host ke container.

Contoh:

```bash
-v ~/project:/app
```

Artinya:

```text
Folder local:
~/project

di-mapping ke:
 /app
```

Sangat sering digunakan saat development.

---

# Perbedaan Volume vs Bind Mount

| Feature | Volume | Bind Mount |
|---|---|---|
| Disimpan Docker | ✅ | ❌ |
| Path ditentukan manual | ❌ | ✅ |
| Cocok production | ✅ | ⚠️ |
| Cocok development | ⚠️ | ✅ |
| Realtime update file | ⚠️ | ✅ |

---

# Check Docker Volume

## Melihat Semua Volume

```bash
sudo docker volume ls
```

---

# Create Docker Volume

## Membuat Volume Baru

```bash
sudo docker volume create nginx-data
```

---

# Check Volume

```bash
sudo docker volume ls
```

Output:

```text
nginx-data
```

---

# Inspect Volume

## Melihat Detail Volume

```bash
sudo docker volume inspect nginx-data
```

Tujuan:
- melihat lokasi penyimpanan volume
- melihat metadata volume

Biasanya data disimpan di:

```text
/var/lib/docker/volumes/
```

---

# Praktik Bind Mount

# Tujuan Praktik

Membuat:
- website sederhana
- menggunakan nginx
- file berasal dari local machine
- perubahan realtime tanpa rebuild image

---

# Create Project Folder

```bash
mkdir ~/docker-volume-lab
cd ~/docker-volume-lab
```

---

# Create HTML File

```bash
nano index.html
```

Isi:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Volume Lab</title>
</head>
<body>

    <h1>🔥 Docker Volume Practice</h1>

    <p>
        Belajar Docker Volume bersama Adi
    </p>

</body>
</html>
```

Save:
- CTRL + O
- ENTER
- CTRL + X

---

# Run Nginx dengan Bind Mount

```bash
sudo docker run -d \
--name nginx-volume-lab \
-p 8090:80 \
-v ~/docker-volume-lab:/usr/share/nginx/html \
nginx
```

---

# Penjelasan Command

## -d

Menjalankan container di background.

---

## --name nginx-volume-lab

Memberi nama container.

---

## -p 8090:80

Port mapping.

Artinya:

```text
localhost:8090 -> container:80
```

---

## -v

Volume / bind mount.

---

## ~/docker-volume-lab

Folder local host.

---

## /usr/share/nginx/html

Folder website nginx di dalam container.

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

# Test Website

## Menggunakan Curl

```bash
curl localhost:8090
```

---

## Menggunakan Browser

Buka:

```text
http://localhost:8090
```

Jika berhasil:
- website custom tampil

---

# Realtime File Update

Salah satu kelebihan bind mount:
- perubahan file local langsung muncul di container

Tanpa:
- rebuild image
- restart container

---

# Test Realtime Update

Edit file:

```bash
nano index.html
```

Ubah isi HTML.

Lalu refresh browser.

Perubahan langsung muncul.

---

# Masuk ke Dalam Container

```bash
sudo docker exec -it nginx-volume-lab bash
```

---

# Check File dari Dalam Container

```bash
cat /usr/share/nginx/html/index.html
```

Isi file akan sama dengan file local.

Karena:
- folder local sedang di-mount ke container

---

# Keluar dari Container

```bash
exit
```

---

# Stop Container

```bash
sudo docker stop nginx-volume-lab
```

---

# Start Container Lagi

```bash
sudo docker start nginx-volume-lab
```

---

# Test Setelah Restart

```bash
curl localhost:8090
```

Website tetap ada karena:
- file berasal dari local host
- bukan disimpan di container internal

---

# Konsep Penting yang Dipelajari

# 1. Persistent Storage

Data tetap ada walaupun container restart/remove.

---

# 2. Bind Mount

Folder local bisa digunakan langsung oleh container.

---

# 3. Realtime Development Workflow

Developer dapat edit file local tanpa rebuild image.

---

# 4. Container Lifecycle

Memahami:
- run
- stop
- start
- remove

---

# Error yang Ditemui

# Port Already Allocated

Error:

```bash
Bind for 0.0.0.0:8090 failed: port is already allocated
```

Penyebab:
- port sudah digunakan container lain

Check:

```bash
sudo docker ps
```

Stop container lama atau gunakan port lain.

Contoh:

```bash
sudo docker run -d -p 9000:80 nginx
```

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

Lalu logout/login terminal.

---

# Kesimpulan Belajar

Yang dipelajari:
- Docker Volume
- Bind Mount
- Persistent Storage
- Nginx Container
- Port Mapping
- Realtime Update File
- Sharing Data Host ke Container

Skill yang mulai dipahami:
- basic storage Docker
- container data management
- development workflow menggunakan Docker
- dasar infrastructure container

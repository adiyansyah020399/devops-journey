# Docker Journey — Basic Docker Learning

> Catatan belajar Docker dari nol.
> Fokus memahami konsep dasar Docker, container, image, port mapping, custom image, dan push image ke Docker Hub.

---

# Apa Itu Docker?

Docker adalah platform untuk menjalankan aplikasi menggunakan container.

Container memungkinkan aplikasi berjalan dengan environment yang konsisten tanpa perlu install dependency manual di setiap server.

Dengan Docker:
- aplikasi lebih mudah dipindahkan
- deployment lebih cepat
- environment development dan production bisa sama
- isolasi aplikasi lebih baik

---

# Konsep Dasar Docker

## Docker Image

Image adalah blueprint/template untuk membuat container.

Contoh:
- ubuntu
- nginx
- mysql

Image bersifat read-only.

---

## Docker Container

Container adalah instance yang berjalan dari sebuah image.

Ibarat:
- image = cetakan
- container = hasil cetakan yang sedang berjalan

---

## Docker Hub

Docker Hub adalah registry/public repository untuk menyimpan image Docker.

Mirip seperti:
- GitHub → menyimpan source code
- Docker Hub → menyimpan docker image

---

# Install Docker di Ubuntu

## 1. Update Package Ubuntu

```bash
sudo apt update
```

Tujuan:
- memperbarui daftar package Ubuntu
- memastikan package terbaru bisa diinstall

---

## 2. Install Dependency

```bash
sudo apt install -y ca-certificates curl gnupg
```

Keterangan:
- `ca-certificates`
  → validasi SSL certificate

- `curl`
  → download file dari internet

- `gnupg`
  → verifikasi key repository Docker

---

## 3. Tambahkan Docker GPG Key

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Membuat folder penyimpanan key Docker.

---

Download Docker GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Tujuan:
- memastikan package Docker valid dan aman

---

Set permission:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Agar system dapat membaca key tersebut.

---

## 4. Tambahkan Docker Repository

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Tujuan:
- menambahkan repository resmi Docker ke Ubuntu

---

## 5. Update Repository

```bash
sudo apt update
```

Agar Ubuntu membaca repository Docker yang baru ditambahkan.

---

## 6. Install Docker

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Package:
- `docker-ce`
  → Docker Engine

- `docker-ce-cli`
  → command docker

- `containerd.io`
  → runtime container

---

## 7. Tambahkan User ke Docker Group

```bash
sudo usermod -aG docker devops
```

Tujuan:
- supaya tidak perlu menggunakan `sudo` setiap menjalankan docker

Catatan:
- perlu logout/login terminal setelah menjalankan command ini

---

# Verifikasi Docker

## Test Docker

```bash
sudo docker run hello-world
```

Jika berhasil muncul:
- Docker berhasil install
- Docker daemon berjalan normal
- Docker bisa pull image dari Docker Hub

---

# Basic Docker Command

## Check Docker Image

```bash
sudo docker images
```

Menampilkan image yang ada di local.

---

## Check Container Running

```bash
sudo docker ps
```

Menampilkan container yang sedang berjalan.

---

## Check All Container

```bash
sudo docker ps -a
```

Menampilkan semua container termasuk yang sudah stop.

---

# Menjalankan Ubuntu Container

## Run Ubuntu Container

```bash
sudo docker run -it ubuntu bash
```

Penjelasan:
- `run`
  → menjalankan container

- `-it`
  → interactive terminal

- `ubuntu`
  → image yang digunakan

- `bash`
  → command pertama saat container berjalan

---

## Check Current User

```bash
whoami
```

Output:
```bash
root
```

Artinya:
- kita sedang berada di dalam container sebagai root user

---

## Check Hostname

```bash
hostname
```

Hostname container biasanya berupa ID container.

---

## Check OS Version

```bash
cat /etc/os-release
```

Menampilkan informasi OS di dalam container.

---

# Menjalankan Nginx Container

## Run Nginx

```bash
sudo docker run -d --name webserver nginx
```

Penjelasan:
- `-d`
  → menjalankan container di background

- `--name webserver`
  → memberi nama container

- `nginx`
  → image yang digunakan

---

## Check Running Container

```bash
sudo docker ps
```

Jika STATUS = Up
→ berarti container berjalan normal.

---

## Check Logs

```bash
sudo docker logs webserver
```

Digunakan untuk:
- melihat log aplikasi
- debugging error

---

## Masuk ke Dalam Container

```bash
sudo docker exec -it webserver bash
```

Penjelasan:
- `exec`
  → menjalankan command di container yang sedang berjalan

- `-it`
  → interactive shell

---

## Check File HTML Nginx

```bash
ls /usr/share/nginx/html/
```

Lokasi default file website nginx.

---

## Check Isi index.html

```bash
cat /usr/share/nginx/html/index.html
```

Menampilkan isi halaman default nginx.

---

# Stop dan Remove Container

## Stop Container

```bash
sudo docker stop webserver
```

Menghentikan container.

---

## Start Container

```bash
sudo docker start webserver
```

Menjalankan container yang sudah stop.

---

## Remove Container

```bash
sudo docker rm webserver
```

Menghapus container.

Catatan:
- container harus dalam keadaan stop sebelum dihapus

---

## Remove Image

```bash
sudo docker rmi nginx
```

Menghapus image nginx dari local.

---

# Docker Port Mapping

Secara default container tidak bisa diakses dari luar.

Perlu port mapping.

---

## Run Nginx dengan Port Mapping

```bash
sudo docker run -d --name webserver -p 8080:80 nginx
```

Penjelasan:
- `8080`
  → port host/local machine

- `80`
  → port di dalam container

Artinya:
```text
localhost:8080 -> container:80
```

---

## Test Access

```bash
curl localhost:8080
```

Jika berhasil:
- nginx berhasil diakses dari host

---

# Membuat Custom Docker Image

Tujuan:
- membuat image sendiri
- custom aplikasi/web

---

# Membuat Project

## Create Folder

```bash
mkdir ~/docker-project
cd ~/docker-project
```

---

# Membuat index.html

```bash
cat > index.html << "EOF"
<!DOCTYPE html>
<html>
<head>
    <title>Docker by Adi</title>
</head>
<body>
    <h1>🐳 Hello from Docker!</h1>
</body>
</html>
EOF
```

File ini akan menjadi halaman website custom.

---

# Membuat Dockerfile

## Create Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
EOF
```

---

# Penjelasan Dockerfile

## FROM nginx:alpine

Menggunakan base image nginx versi alpine.

Alpine:
- lebih ringan
- ukuran image kecil

---

## COPY

```dockerfile
COPY index.html /usr/share/nginx/html/index.html
```

Mengcopy file dari local ke dalam image.

---

## EXPOSE 80

Memberi tahu bahwa container menggunakan port 80.

---

# Build Docker Image

## Build Image

```bash
sudo docker build -t devops-web:v1 .
```

Penjelasan:
- `build`
  → membuat image

- `-t`
  → memberi tag/nama image

- `devops-web:v1`
  → nama image dan version

- `.`
  → current directory build context

---

## Check Image

```bash
sudo docker images
```

Melihat image hasil build.

---

# Run Custom Image

## Stop Old Container

```bash
sudo docker stop webserver
```

---

## Remove Old Container

```bash
sudo docker rm webserver
```

---

## Run Custom Image

```bash
sudo docker run -d --name webserver -p 8080:80 devops-web:v1
```

---

## Test Result

```bash
curl localhost:8080
```

Jika berhasil:
- halaman custom HTML tampil

---

# Docker Hub

Docker Hub digunakan untuk:
- menyimpan image online
- sharing image
- deployment image ke server lain

---

# Push Image ke Docker Hub

## Login Docker Hub

```bash
sudo docker login
```

---

## Tag Image

```bash
sudo docker tag devops-web:v1 xowhacks/devops-web:v1
```

Format:
```text
username/nama-image:version
```

---

## Push Image

```bash
sudo docker push xowhacks/devops-web:v1
```

Upload image ke Docker Hub.

---

# Pull Image dari Docker Hub

Image yang sudah dipush bisa dijalankan di device/server lain.

```bash
sudo docker run -d -p 8080:80 xowhacks/devops-web:v1
```

---

# Error yang Ditemui

# 1. docker build requires 1 argument

Error:

```bash
docker buildx build requires 1 argument
```

Penyebab:
- lupa menambahkan `.`

Salah:

```bash
sudo docker build -t devops-web:v1
```

Benar:

```bash
sudo docker build -t devops-web:v1 .
```

---

# 2. permission denied docker.sock

Error:

```bash
permission denied while trying to connect to the docker API socket
```

Penyebab:
- user belum masuk group docker

Fix:

```bash
sudo usermod -aG docker devops
```

Lalu:
- logout/login terminal

---

# 3. port already allocated

Error:

```bash
Bind for 0.0.0.0:8080 failed: port is already allocated
```

Penyebab:
- port sudah dipakai container lain

Check:

```bash
sudo docker ps
```

Stop container lama atau gunakan port lain.

Contoh:

```bash
sudo docker run -d -p 8081:80 xowhacks/devops-web:v1
```

---

# Kesimpulan Belajar

Yang dipelajari:
- install Docker
- image
- container
- nginx container
- port mapping
- docker exec
- docker logs
- Dockerfile
- build image
- push image Docker Hub

Skill yang mulai dipahami:
- basic containerization
- membuat custom image
- menjalankan aplikasi dengan Docker
- upload image ke registry online

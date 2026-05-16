# Catatan Belajar Linux — Hari 3
**Fase 1: Linux & Jaringan Dasar | Minggu 3**

---

## 1. Package Manager (apt)

```bash
# Update & Upgrade
sudo apt update              # update daftar package yang tersedia
sudo apt upgrade -y          # upgrade semua package
sudo apt list --upgradable   # lihat package yang bisa diupgrade

# Install & Hapus
sudo apt install -y nama     # install package
sudo apt install -y pkg1 pkg2 pkg3  # install beberapa sekaligus
sudo apt remove nama         # hapus package (konfigurasi masih ada)
sudo apt purge nama          # hapus package beserta konfigurasinya
sudo apt autoremove -y       # hapus package yang tidak diperlukan

# Informasi
apt search nama              # cari package
apt show nama                # detail informasi package
apt list --installed         # lihat semua package terinstall
apt list --installed | wc -l # hitung jumlah package terinstall
```

Perbedaan remove vs purge:
```
apt remove → hapus package, file konfigurasi MASIH ADA
apt purge  → hapus package + file konfigurasi, bersih total
```

Tools penting yang wajib terinstall:
```bash
sudo apt install -y curl wget git tree htop
```

| Tool | Fungsi |
|------|--------|
| `curl` | Transfer data dari/ke URL, testing API |
| `wget` | Download file dari internet |
| `git` | Version control |
| `tree` | Tampilkan struktur folder |
| `htop` | Monitor process realtime (lebih bagus dari top) |

---

## 2. Cron — Penjadwalan Otomatis

```bash
crontab -l    # lihat semua cron job aktif
crontab -e    # edit cron job (pilih nano saat pertama kali)
crontab -r    # hapus semua cron job (hati-hati!)
```

Format cron:
```
*    *    *    *    *    perintah
│    │    │    │    │
│    │    │    │    └── hari dalam seminggu (0-7, 0&7=Minggu)
│    │    │    └─────── bulan (1-12)
│    │    └──────────── tanggal (1-31)
│    └───────────────── jam (0-23)
└────────────────────── menit (0-59)

* = setiap
*/5 = setiap 5
```

Contoh jadwal:
```
* * * * *       → setiap menit
*/5 * * * *     → setiap 5 menit
0 * * * *       → setiap jam (menit ke-0)
0 9 * * *       → setiap hari jam 09:00
0 9 * * 1       → setiap Senin jam 09:00
0 0 1 * *       → setiap tanggal 1 tiap bulan jam 00:00
0 0 * * *       → setiap hari tengah malam
```

Contoh cron job monitoring disk:
```bash
# Buat script
cat > ~/belajar-devops/cek-disk.sh << 'EOF'
#!/bin/bash
echo "=== Cek Disk $(date) ===" >> ~/belajar-devops/disk.log
df -h >> ~/belajar-devops/disk.log
echo "" >> ~/belajar-devops/disk.log
EOF

chmod +x ~/belajar-devops/cek-disk.sh

# Jadwalkan setiap jam
# Tambahkan di crontab -e:
0 * * * * ~/belajar-devops/cek-disk.sh
```

---

## 3. SSH — Secure Shell

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "komentar"

# Hasil:
# ~/.ssh/id_rsa      → private key (JANGAN dibagikan!)
# ~/.ssh/id_rsa.pub  → public key (boleh dibagikan)
# ~/.ssh/known_hosts → daftar server yang pernah dikoneksi
```

Analogi kunci dan gembok:
```
id_rsa.pub = GEMBOK → pasang di server tujuan
id_rsa     = KUNCI  → hanya kamu yang pegang

Cara kerja:
1. Pasang public key di server
2. Saat konek, server verifikasi private key kamu
3. Kalau cocok → masuk tanpa password!
```

Perintah SSH:
```bash
# Konek ke server
ssh username@ip_server

# Konek ke port tertentu (default 22)
ssh -p 2222 username@ip_server

# Konek pakai private key tertentu
ssh -i ~/.ssh/id_rsa username@ip_server

# Copy public key ke server
ssh-copy-id username@ip_server

# Copy file ke server (upload)
scp file.txt username@ip_server:/home/username/

# Copy file dari server (download)
scp username@ip_server:/home/username/file.txt .

# Copy folder ke server
scp -r folder/ username@ip_server:/home/username/
```

Setup SSH ke localhost:
```bash
sudo apt install -y openssh-server
sudo service ssh start
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh devops@localhost
```

---

## 4. Nginx — Web Server

```bash
# Install
sudo apt install -y nginx

# Manajemen service
sudo service nginx start    # jalankan
sudo service nginx stop     # hentikan
sudo service nginx restart  # restart
sudo service nginx status   # cek status

# Test web server
curl localhost
curl localhost:8080
```

File penting Nginx:
```
/var/www/html/          → folder file website
/etc/nginx/             → folder konfigurasi
/etc/nginx/sites-available/default  → konfigurasi site default
```

Konfigurasi port (ubah ke 8080 untuk Cloud Shell):
```bash
sudo tee /etc/nginx/sites-available/default << 'EOF'
server {
    listen 8080;
    root /var/www/html;
    index index.html;
}
EOF

sudo service nginx restart
```

Membuat halaman web custom:
```bash
sudo tee /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Journey</title>
</head>
<body>
    <h1>Halo! Ini server pertama saya!</h1>
    <p>Nama: Adi Yansyah</p>
    <p>Belajar: DevOps Engineering</p>
</body>
</html>
EOF
```

---

## 5. Google Cloud Shell

- Akses: **shell.cloud.google.com**
- Gratis, tidak perlu kartu kredit
- 5GB storage permanen
- Linux Ubuntu dengan tools lengkap
- Web Preview untuk akses via browser (port 8080)
# Catatan Belajar Linux — Hari 3
**Fase 1: Linux & Jaringan Dasar | Minggu 3**
 
---
 
## 1. Package Manager (apt)
 
```bash
# Update & Upgrade
sudo apt update              # update daftar package yang tersedia
sudo apt upgrade -y          # upgrade semua package
sudo apt list --upgradable   # lihat package yang bisa diupgrade
 
# Install & Hapus
sudo apt install -y nama     # install package
sudo apt install -y pkg1 pkg2 pkg3  # install beberapa sekaligus
sudo apt remove nama         # hapus package (konfigurasi masih ada)
sudo apt purge nama          # hapus package beserta konfigurasinya
sudo apt autoremove -y       # hapus package yang tidak diperlukan
 
# Informasi
apt search nama              # cari package
apt show nama                # detail informasi package
apt list --installed         # lihat semua package terinstall
apt list --installed | wc -l # hitung jumlah package terinstall
```
 
Perbedaan remove vs purge:
```
apt remove → hapus package, file konfigurasi MASIH ADA
apt purge  → hapus package + file konfigurasi, bersih total
```
 
Tools penting yang wajib terinstall:
```bash
sudo apt install -y curl wget git tree htop
```
 
| Tool | Fungsi |
|------|--------|
| `curl` | Transfer data dari/ke URL, testing API |
| `wget` | Download file dari internet |
| `git` | Version control |
| `tree` | Tampilkan struktur folder |
| `htop` | Monitor process realtime (lebih bagus dari top) |
 
---
 
## 2. Cron — Penjadwalan Otomatis
 
```bash
crontab -l    # lihat semua cron job aktif
crontab -e    # edit cron job (pilih nano saat pertama kali)
crontab -r    # hapus semua cron job (hati-hati!)
```
 
Format cron:
```
*    *    *    *    *    perintah
│    │    │    │    │
│    │    │    │    └── hari dalam seminggu (0-7, 0&7=Minggu)
│    │    │    └─────── bulan (1-12)
│    │    └──────────── tanggal (1-31)
│    └───────────────── jam (0-23)
└────────────────────── menit (0-59)
 
* = setiap
*/5 = setiap 5
```
 
Contoh jadwal:
```
* * * * *       → setiap menit
*/5 * * * *     → setiap 5 menit
0 * * * *       → setiap jam (menit ke-0)
0 9 * * *       → setiap hari jam 09:00
0 9 * * 1       → setiap Senin jam 09:00
0 0 1 * *       → setiap tanggal 1 tiap bulan jam 00:00
0 0 * * *       → setiap hari tengah malam
```
 
Contoh cron job monitoring disk:
```bash
# Buat script
cat > ~/belajar-devops/cek-disk.sh << 'EOF'
#!/bin/bash
echo "=== Cek Disk $(date) ===" >> ~/belajar-devops/disk.log
df -h >> ~/belajar-devops/disk.log
echo "" >> ~/belajar-devops/disk.log
EOF
 
chmod +x ~/belajar-devops/cek-disk.sh
 
# Jadwalkan setiap jam
# Tambahkan di crontab -e:
0 * * * * ~/belajar-devops/cek-disk.sh
```
 
---
 
## 3. SSH — Secure Shell
 
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "komentar"
 
# Hasil:
# ~/.ssh/id_rsa      → private key (JANGAN dibagikan!)
# ~/.ssh/id_rsa.pub  → public key (boleh dibagikan)
# ~/.ssh/known_hosts → daftar server yang pernah dikoneksi
```
 
Analogi kunci dan gembok:
```
id_rsa.pub = GEMBOK → pasang di server tujuan
id_rsa     = KUNCI  → hanya kamu yang pegang
 
Cara kerja:
1. Pasang public key di server
2. Saat konek, server verifikasi private key kamu
3. Kalau cocok → masuk tanpa password!
```
 
Perintah SSH:
```bash
# Konek ke server
ssh username@ip_server
 
# Konek ke port tertentu (default 22)
ssh -p 2222 username@ip_server
 
# Konek pakai private key tertentu
ssh -i ~/.ssh/id_rsa username@ip_server
 
# Copy public key ke server
ssh-copy-id username@ip_server
 
# Copy file ke server (upload)
scp file.txt username@ip_server:/home/username/
 
# Copy file dari server (download)
scp username@ip_server:/home/username/file.txt .
 
# Copy folder ke server
scp -r folder/ username@ip_server:/home/username/
```
 
Setup SSH ke localhost:
```bash
sudo apt install -y openssh-server
sudo service ssh start
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh devops@localhost
```
 
---
 
## 4. Nginx — Web Server
 
```bash
# Install
sudo apt install -y nginx
 
# Manajemen service
sudo service nginx start    # jalankan
sudo service nginx stop     # hentikan
sudo service nginx restart  # restart
sudo service nginx status   # cek status
 
# Test web server
curl localhost
curl localhost:8080
```
 
File penting Nginx:
```
/var/www/html/          → folder file website
/etc/nginx/             → folder konfigurasi
/etc/nginx/sites-available/default  → konfigurasi site default
```
 
Konfigurasi port (ubah ke 8080 untuk Cloud Shell):
```bash
sudo tee /etc/nginx/sites-available/default << 'EOF'
server {
    listen 8080;
    root /var/www/html;
    index index.html;
}
EOF
 
sudo service nginx restart
```
 
Membuat halaman web custom:
```bash
sudo tee /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Journey</title>
</head>
<body>
    <h1>Halo! Ini server pertama saya!</h1>
    <p>Nama: Adi Yansyah</p>
    <p>Belajar: DevOps Engineering</p>
</body>
</html>
EOF
```
 
---
 
## 5. Google Cloud Shell
 
- Akses: **shell.cloud.google.com**
- Gratis, tidak perlu kartu kredit
- 5GB storage permanen
- Linux Ubuntu dengan tools lengkap
- Web Preview untuk akses via browser (port 8080)
---
 
## Milestone Hari Ini ✅
 
- Install dan konfigurasi Nginx web server
- Custom halaman HTML
- Deploy ke Google Cloud Shell
- Akses web dari browser via internet
- Setup SSH key pair
- Koneksi SSH ke localhost
- Penjadwalan cron job otomatis
---
 
*Selanjutnya: Jaringan Dasar (TCP/IP, DNS, HTTP, curl, ping, netstat)*

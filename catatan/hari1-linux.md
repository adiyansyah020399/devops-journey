# Catatan Belajar Linux — Hari 1
**Fase 1: Linux & Jaringan Dasar | Minggu 1**

---

## 1. Orientasi Terminal

```bash
whoami        # tampilkan user yang sedang aktif
hostname      # tampilkan nama komputer
pwd           # tampilkan lokasi direktori saat ini (Print Working Directory)
```

---

## 2. Navigasi Direktori

```bash
cd /          # pindah ke root
cd ~          # pindah ke home directory
cd ..         # naik satu level
cd ../..      # naik dua level sekaligus
cd /etc       # pindah pakai absolute path (selalu mulai dari /)
cd catatan    # pindah pakai relative path (relatif dari posisi sekarang)
```

---

## 3. Melihat Isi Direktori

```bash
ls            # tampilkan isi direktori
ls -l         # tampilkan detail (permission, ukuran, tanggal)
ls -la        # tampilkan semua termasuk file tersembunyi (diawali titik)
```

> File tersembunyi di Linux diawali titik (`.bashrc`, `.profile`, dll)

---

## 4. Struktur Direktori Linux yang Wajib Diingat

| Direktori | Fungsi |
|-----------|--------|
| `/etc` | File konfigurasi sistem |
| `/var/log` | Log-log sistem |
| `/home` | Folder tiap user |
| `/tmp` | File sementara, terhapus saat restart |
| `/usr` | Program dan tools yang terinstall |
| `/opt` | Software tambahan pihak ketiga |

---

## 5. Manajemen File & Folder

```bash
mkdir nama-folder           # buat folder
mkdir -p folder/subfolder   # buat folder beserta subfolder sekaligus

cp file.txt backup.txt      # copy file
cp file.txt folder/         # copy file ke dalam folder

mv file.txt folder/         # pindah file ke folder
mv file.txt nama-baru.txt   # rename file

rm file.txt                 # hapus file
rm -r folder/               # hapus folder beserta isinya
rm -ri folder/              # hapus folder dengan konfirmasi satu per satu
```

> ⚠️ **PERINGATAN:** `rm` tidak ada tempat sampah. File yang terhapus tidak bisa dikembalikan!

---

## 6. Menulis ke File (Redirect)

```bash
echo "teks" > file.txt    # tulis ke file — MENIMPA isi lama
echo "teks" >> file.txt   # tulis ke file — MENAMBAHKAN di bawah
```

---

## 7. Membaca Isi File

```bash
cat file.txt          # tampilkan semua isi file sekaligus
less file.txt         # tampilkan per halaman (spasi = lanjut, q = keluar)
head file.txt         # tampilkan 10 baris pertama
head -n 5 file.txt    # tampilkan 5 baris pertama
tail file.txt         # tampilkan 10 baris terakhir
tail -n 5 file.txt    # tampilkan 5 baris terakhir
tail -f /var/log/syslog  # pantau log secara REALTIME (Ctrl+C untuk keluar)
```

---

## 8. Log Penting di /var/log

| File | Isi |
|------|-----|
| `auth.log` | Log login dan autentikasi |
| `syslog` | Log umum sistem |
| `dpkg.log` | Log instalasi package |
| `kern.log` | Log kernel |

---


## 9. Permission (chmod)
 
r=4, w=2, x=1
 
```bash
chmod 644 file    # rw-r--r-- (owner:rw, group:r, other:r)
chmod 755 file    # rwxr-xr-x (owner:rwx, group:rx, other:rx)
chmod 700 file    # rwx------ (hanya owner punya akses penuh)
chmod 400 file    # r-------- (hanya owner bisa baca)
chmod +x file     # tambah execute permission untuk semua
chmod -w file     # hapus write permission
chmod g+w file    # tambah write permission untuk group
chmod o-r file    # hapus read permission untuk other
```
 
Cara membaca permission:
```
-  rw-  r--  r--
│   │    │    └── other
│   │    └─────── group
│   └──────────── owner
└─────────────── tipe: d=direktori, -=file
```
 
---
 
## 10. User Management
 
```bash
# Melihat informasi user
whoami                   # tampilkan user aktif
id                       # detail uid, gid, groups
id nama                  # detail user lain
cat /etc/passwd          # semua user di sistem
cat /etc/group           # semua group di sistem
 
# Format /etc/passwd:
# username:x:uid:gid:info:home:shell
 
# Manajemen user
sudo adduser nama              # buat user baru (interaktif)
su - nama                      # pindah ke user lain
sudo usermod -aG sudo nama     # tambah user ke group sudo
sudo userdel -r nama           # hapus user beserta home directorynya
 
# Catatan:
# UID 0        = root
# UID 1-999    = system user
# UID 1000+    = user manusia
```
 
---
 
## 11. Process Management
 
```bash
# Melihat process
ps                  # process milik user aktif
ps aux              # semua process di sistem
ps aux --forest     # semua process dalam bentuk tree
top                 # monitor process realtime (q untuk keluar)
 
# Navigasi di top:
# M = urutkan berdasarkan memory
# P = urutkan berdasarkan CPU
# k = kill process
# q = keluar
 
# Menjalankan process di background
perintah &          # jalankan di background, terminal tetap bisa dipakai
 
# Menghentikan process
kill PID            # hentikan process dengan sopan (SIGTERM)
kill -15 PID        # sama dengan kill biasa (SIGTERM)
kill -9 PID         # paksa hentikan, tidak bisa diabaikan (SIGKILL)
kill -1 PID         # restart process (SIGHUP)
 
# Kapan pakai kill -15 vs kill -9:
# kill -15 → gunakan duluan, beri kesempatan process menutup diri dengan bersih
# kill -9  → gunakan kalau kill -15 tidak mempan, process tidak mau berhenti
```
 
---
 
*Selanjutnya: Text Processing & Shell Power (grep, sed, awk, pipe)*


## Perintah Cepat Hari Ini

```bash
sudo apt update      # update daftar package
sudo apt upgrade -y  # upgrade semua package
```

---



*Selanjutnya: Process Management (ps, top, kill, systemctl)*

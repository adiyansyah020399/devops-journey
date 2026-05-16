
# Catatan Belajar Linux — Hari 4
**Fase 1: Linux & Jaringan Dasar | Minggu 4**

---

## 1. ping — Test Koneksi

```bash
ping google.com           # ping terus menerus (Ctrl+C untuk stop)
ping -c 4 google.com      # ping 4 kali saja
ping -c 4 8.8.8.8         # ping ke IP address Google DNS
```

Cara membaca output:
```
64 bytes from 8.8.8.8: icmp_seq=1 ttl=246 time=19.5 ms
                                              └── waktu bolak-balik (makin kecil makin bagus)

0% packet loss = koneksi bagus
100% packet loss = tidak ada koneksi
```

Kalau ping gagal:
- Tidak ada koneksi internet
- Server tujuan mati
- Firewall memblokir ICMP

---

## 2. ip — Informasi Jaringan

```bash
ip addr show      # lihat semua interface dan IP address
ip a              # singkatan dari ip addr show
ip route show     # lihat routing table
ip route          # singkatan
```

Istilah penting:
```
eth0        = nama interface jaringan utama
inet        = IP address versi 4 (IPv4)
inet6       = IP address versi 6 (IPv6)
gateway     = pintu keluar ke internet
default     = jalur default untuk semua traffic
```

---

## 3. DNS — Domain Name System

DNS menerjemahkan nama domain → IP address.
Tanpa DNS, kamu harus hafal IP semua website!

```bash
nslookup google.com     # cek IP dari domain
dig google.com          # informasi DNS lebih detail
dig google.com +short   # tampilkan IP saja

# Install jika belum ada
sudo apt install -y bind9-dnsutils
```

File konfigurasi DNS:
```bash
cat /etc/resolv.conf    # DNS server yang dipakai
cat /etc/hosts          # DNS lokal (override DNS)
```

Format /etc/hosts:
```
127.0.0.1    localhost
192.168.1.10 server-dev.local
```
Bisa dipakai untuk override — paksa domain tertentu ke IP tertentu.

---

## 4. curl — HTTP Request & Testing API

```bash
# Request dasar
curl google.com                    # GET request, tampilkan body
curl -I google.com                 # tampilkan header saja
curl -v google.com                 # verbose, tampilkan semua detail

# Download file
curl -O https://url.com/file.txt   # download dengan nama asli
curl -o namafile.txt https://url   # download dengan nama custom

# Testing API
curl -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}'

# Lihat status code saja
curl -s -o /dev/null -w "%{http_code}" google.com
```

HTTP Status Code yang wajib dihapal:
```
2xx = Sukses
  200 = OK
  201 = Created

3xx = Redirect
  301 = Moved Permanently (pindah permanen)
  302 = Found (pindah sementara)

4xx = Error Client
  400 = Bad Request
  401 = Unauthorized (perlu login)
  403 = Forbidden (tidak punya akses)
  404 = Not Found

5xx = Error Server
  500 = Internal Server Error
  502 = Bad Gateway
  503 = Service Unavailable
```

---

## 5. ss & netstat — Lihat Port Aktif

```bash
ss -tulnp          # lihat semua port yang aktif
netstat -tulnp     # cara lama, sama fungsinya

# Filter port tertentu
ss -tulnp | grep :80
ss -tulnp | grep :22
ss -tulnp | grep :443

# Install netstat jika belum ada
sudo apt install -y net-tools
```

Flag penjelasan:
```
-t = TCP
-u = UDP
-l = listening (menunggu koneksi)
-n = tampilkan angka bukan nama
-p = tampilkan process yang menggunakan port
```

Port penting yang wajib dihapal:
```
22    → SSH
80    → HTTP
443   → HTTPS
3306  → MySQL
5432  → PostgreSQL
6379  → Redis
8080  → HTTP alternatif
27017 → MongoDB
```

---

## 6. traceroute — Jalur Paket ke Server

```bash
traceroute google.com

# Install jika belum ada
sudo apt install -y traceroute
```

Cara membaca output:
```
Hop 1  → gateway lokal (router kamu)
Hop 2  → router ISP
Hop 3+ → jaringan ISP
Hop N  → server tujuan

* * * = router tidak merespon (normal, diblokir firewall)
```

---

## 7. Workflow Troubleshooting Jaringan

Urutan standar saat ada masalah koneksi:

```bash
# Step 1 - Cek internet
ping -c 3 8.8.8.8

# Step 2 - Cek DNS
nslookup google.com

# Step 3 - Cek port service aktif
ss -tulnp | grep :80

# Step 4 - Cek service merespon
curl -I localhost

# Step 5 - Cek log error
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/syslog
```

Logika troubleshooting:
```
Internet OK? → DNS OK? → Port terbuka? → Service merespon? → Cek log!
```

---

## 8. Nginx di WSL

```bash
# Install
sudo apt install -y nginx

# Manajemen
sudo service nginx start
sudo service nginx stop
sudo service nginx restart
sudo service nginx status

# Verifikasi berjalan
ss -tulnp | grep :80
curl -I localhost

# Log nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# File website
ls /var/www/html/
```

---

## Milestone Hari Ini ✅

- Test koneksi dengan ping
- Lihat IP address dan routing table
- DNS lookup dengan nslookup dan dig
- HTTP request dengan curl
- Testing API dengan curl POST
- Monitoring port dengan ss
- Traceroute untuk melihat jalur paket
- Troubleshooting workflow lengkap
- Nginx berjalan di WSL

---

*Selanjutnya: Bash Scripting (variabel, kondisi, loop, fungsi)*

# Catatan Belajar Linux — Hari 6
**Fase 1: Linux & Jaringan Dasar | Minggu 6 — Mini Project**

---

## Overview Project

Deploy web server di Google Cloud Shell dengan halaman profil DevOps,
dilengkapi script monitoring otomatis dan auto-backup.

```
devops-project/
├── scripts/
│   ├── monitoring.sh  ← auto monitoring disk, memory, service
│   └── backup.sh      ← auto backup website
├── backup/
│   └── website_backup_YYYYMMDD_HHMMSS.tar.gz
└── monitoring.log     ← log history monitoring
```

---

## 1. Setup Nginx di Google Cloud Shell

```bash
# Install nginx
sudo apt update
sudo apt install -y nginx

# Konfigurasi port 8080 (wajib di Cloud Shell)
sudo tee /etc/nginx/sites-available/default << 'EOF'
server {
    listen 8080;
    root /var/www/html;
    index index.html;
}
EOF

# Start nginx
sudo service nginx start
sudo service nginx status

# Test
curl localhost:8080
```

Akses dari browser:
- Klik tombol **Web Preview** di pojok kanan atas Cloud Shell
- Pilih **Preview on port 8080**

File website disimpan di:
```
/var/www/html/index.html
```

---

## 2. Deploy Halaman Web

```bash
# Buat/update halaman web
sudo tee /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
...isi HTML...
</html>
EOF

# Verifikasi
curl localhost:8080 | head -5
```

---

## 3. Script Auto-Backup

```bash
cat > ~/devops-project/scripts/backup.sh << 'EOF'
#!/bin/bash

TANGGAL=$(date '+%Y%m%d_%H%M%S')
BACKUP_DIR=~/devops-project/backup
SOURCE=/var/www/html
BACKUP_FILE="website_backup_$TANGGAL.tar.gz"

mkdir -p $BACKUP_DIR

# Buat backup dalam format tar.gz
tar -czf $BACKUP_DIR/$BACKUP_FILE $SOURCE 2>/dev/null

# Verifikasi backup berhasil
if [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    SIZE=$(du -sh $BACKUP_DIR/$BACKUP_FILE | cut -f1)
    echo "✅ Backup berhasil: $BACKUP_FILE ($SIZE)"
else
    echo "❌ Backup gagal!"
fi

# Hapus backup lebih dari 7 hari (hemat storage)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
echo "🧹 Backup lama sudah dibersihkan"

# Tampilkan semua backup
echo ""
echo "📦 Daftar backup:"
ls -lh $BACKUP_DIR/
EOF

chmod +x ~/devops-project/scripts/backup.sh
```

Perintah tar yang dipakai:
```bash
tar -czf file.tar.gz folder/   # compress (buat backup)
tar -xzf file.tar.gz           # extract (restore backup)
tar -tzf file.tar.gz           # lihat isi tanpa extract

# Flag:
# -c = create (buat)
# -x = extract (ekstrak)
# -z = gunzip (kompres/dekompres)
# -f = file (nama file)
# -t = list (tampilkan isi)
```

---

## 4. Script Auto-Monitoring

```bash
cat > ~/devops-project/scripts/monitoring.sh << 'EOF'
#!/bin/bash

TANGGAL=$(date '+%Y-%m-%d %H:%M:%S')
LOG=~/devops-project/monitoring.log

echo "===============================" | tee -a $LOG
echo "  MONITORING REPORT"            | tee -a $LOG
echo "  $TANGGAL"                     | tee -a $LOG
echo "===============================" | tee -a $LOG

# Cek disk
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
echo "📦 DISK: $DISK%" | tee -a $LOG
if [ $DISK -gt 90 ]; then
    echo "   ⚠️  CRITICAL!" | tee -a $LOG
elif [ $DISK -gt 70 ]; then
    echo "   ⚡ WARNING!" | tee -a $LOG
else
    echo "   ✅ Aman" | tee -a $LOG
fi

# Cek memory
TOTAL=$(free -m | grep Mem | awk '{print $2}')
USED=$(free -m | grep Mem | awk '{print $3}')
PERSEN=$((USED * 100 / TOTAL))
echo "🧠 MEMORY: $USED MB / $TOTAL MB ($PERSEN%)" | tee -a $LOG
if [ $PERSEN -gt 90 ]; then
    echo "   ⚠️  CRITICAL!" | tee -a $LOG
elif [ $PERSEN -gt 70 ]; then
    echo "   ⚡ WARNING!" | tee -a $LOG
else
    echo "   ✅ Aman" | tee -a $LOG
fi

# Cek & auto-restart nginx kalau mati
if sudo service nginx status > /dev/null 2>&1; then
    echo "   ✅ nginx berjalan" | tee -a $LOG
else
    echo "   ❌ nginx MATI!" | tee -a $LOG
    sudo service nginx start
    echo "   🔄 nginx direstart otomatis" | tee -a $LOG
fi
EOF

chmod +x ~/devops-project/scripts/monitoring.sh
```

Catatan `tee -a`:
```bash
echo "teks" | tee -a file.log
# Tampilkan di terminal DAN simpan ke file sekaligus
# -a = append (tambahkan, tidak menimpa)
```

---

## 5. Jadwalkan dengan Cron

```bash
crontab -e
```

Tambahkan:
```
# Monitoring setiap jam
0 * * * * ~/devops-project/scripts/monitoring.sh

# Backup setiap hari jam 02:00 pagi
0 2 * * * ~/devops-project/scripts/backup.sh
```

Verifikasi:
```bash
crontab -l
```

---

## 6. Troubleshooting Nginx

```bash
# Cek status
sudo service nginx status

# Cek port aktif
ss -tulnp | grep :8080

# Cek log error
sudo tail -f /var/log/nginx/error.log

# Cek log access
sudo tail -f /var/log/nginx/access.log

# Test konfigurasi nginx
sudo nginx -t

# Restart nginx
sudo service nginx restart
```

Error umum:
```
403 Forbidden  → file index.html tidak ada di /var/www/html/
404 Not Found  → URL yang diminta tidak ada
502 Bad Gateway → aplikasi backend tidak berjalan
```

---

## 7. Perintah Berguna Lainnya

```bash
# Lihat ukuran folder
du -sh ~/devops-project/

# Lihat penggunaan disk
df -h

# Lihat penggunaan memory
free -m
free -h

# Lihat semua proses
ps aux

# Cek koneksi aktif
ss -tulnp
```

---

## Milestone Mini Project ✅

- ✅ Deploy Nginx web server di Google Cloud Shell
- ✅ Halaman profil HTML live di internet
- ✅ Script auto-backup dengan timestamp otomatis
- ✅ Script auto-monitoring disk, memory, service
- ✅ Auto-restart nginx kalau mati
- ✅ Cron job terjadwal (monitoring + backup)
- ✅ Log monitoring tersimpan otomatis

---

## FASE 1 SELESAI! 🎓

```
Minggu 1 ✅ → Linux Dasar
Minggu 2 ✅ → Text Processing
Minggu 3 ✅ → SSH, Package, Cron, Nginx
Minggu 4 ✅ → Jaringan Dasar
Minggu 5 ✅ → Bash Scripting
Minggu 6 ✅ → Mini Project Deploy
```

---

*Selanjutnya: FASE 2 — Git, Scripting & Cloud Dasar*
*( Git/GitHub, Bash scripting lanjut, Python dasar, AWS/GCP free tier )*

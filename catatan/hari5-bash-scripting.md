# Catatan Belajar Linux — Hari 5
**Fase 1: Linux & Jaringan Dasar | Minggu 5**

---

## 1. Struktur Dasar Script Bash

```bash
#!/bin/bash
# Baris pertama wajib ada — menunjukkan interpreter yang dipakai

# Komentar menggunakan tanda #
echo "Hello DevOps!"
```

Menjalankan script:
```bash
chmod +x script.sh    # beri execute permission
./script.sh           # jalankan
bash script.sh        # jalankan tanpa execute permission
```

---

## 2. Variabel

```bash
# Definisi variabel (tanpa spasi di sekitar =)
NAMA="Muhamad Adiyansyah"
ROLE="DevOps Engineer"
TAHUN=2026

# Memanggil variabel (pakai $)
echo "Nama: $NAMA"
echo "Role: $ROLE"

# PENTING: bash case sensitive!
# $NAMA, $nama, $Nama = tiga variabel berbeda!
```

Command substitution — simpan output perintah ke variabel:
```bash
HOSTNAME=$(hostname)
TANGGAL=$(date)
IP=$(ip a | grep 'inet ' | grep eth0 | awk '{print $2}')
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

echo "Hostname : $HOSTNAME"
echo "Tanggal  : $TANGGAL"
```

Format tanggal custom:
```bash
TANGGAL=$(date '+%Y-%m-%d %H:%M:%S')
# Output: 2026-05-16 15:00:00

TANGGAL_FILE=$(date '+%Y%m%d')
# Output: 20260516 (cocok untuk nama file)
```

Contoh penggunaan nyata:
```bash
BACKUP_FILE="backup-$(date +%Y%m%d).tar.gz"
# Output: backup-20260516.tar.gz
```

---

## 3. Kondisi (if-elif-else)

```bash
if [ kondisi ]; then
    # jalankan kalau kondisi benar
elif [ kondisi2 ]; then
    # jalankan kalau kondisi2 benar
else
    # jalankan kalau semua kondisi salah
fi
```

Operator perbandingan angka:
```
-gt  = greater than (lebih besar dari)      >
-lt  = less than (lebih kecil dari)         <
-ge  = greater than or equal (≥)
-le  = less than or equal (≤)
-eq  = equal (sama dengan)                  ==
-ne  = not equal (tidak sama dengan)        !=
```

Operator perbandingan string:
```
=    = sama dengan
!=   = tidak sama dengan
-z   = string kosong
-n   = string tidak kosong
```

Contoh:
```bash
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ $DISK -gt 90 ]; then
    echo "⚠️  CRITICAL: Disk hampir penuh!"
elif [ $DISK -gt 70 ]; then
    echo "⚡ WARNING: Disk mulai penuh"
else
    echo "✅ OK: Disk masih aman"
fi
```

---

## 4. Loop

### For Loop
```bash
# Loop sederhana
for i in 1 2 3 4 5; do
    echo "Iterasi ke-$i"
done

# Loop dengan range
for i in {1..10}; do
    echo "Nomor: $i"
done

# Loop file
for file in /path/to/*.md; do
    echo "File: $(basename $file)"
done

# Loop dengan increment custom (setiap 2)
for i in {0..10..2}; do
    echo $i
done
```

### While Loop
```bash
COUNTER=1
while [ $COUNTER -le 5 ]; do
    echo "Iterasi ke-$COUNTER"
    COUNTER=$((COUNTER + 1))
done
```

### Aritmatika di Bash
```bash
HASIL=$((10 + 5))    # penjumlahan = 15
HASIL=$((10 - 5))    # pengurangan = 5
HASIL=$((10 * 5))    # perkalian  = 50
HASIL=$((10 / 5))    # pembagian  = 2
PERSEN=$((USED * 100 / TOTAL))  # persentase
```

---

## 5. Fungsi

```bash
# Definisi fungsi
nama_fungsi() {
    # isi fungsi
    echo "Halo dari fungsi!"
}

# Fungsi dengan argumen
sapa() {
    NAMA=$1      # argumen pertama
    ROLE=$2      # argumen kedua
    echo "Halo $NAMA, role kamu: $ROLE"
}

# Memanggil fungsi
nama_fungsi
sapa "Adi" "DevOps"
```

Variabel argumen:
```
$1, $2, $3  = argumen ke-1, 2, 3
$@          = semua argumen
$#          = jumlah argumen
$0          = nama script
```

---

## 6. Redirect Output di Script

```bash
LOG_FILE=~/app.log

# Tulis ke log
echo "Server started" >> $LOG_FILE

# Buang output (tidak tampil di terminal)
perintah > /dev/null 2>&1

# Cek service tanpa output
if sudo service nginx status > /dev/null 2>&1; then
    echo "nginx berjalan"
fi
```

---

## 7. Script Monitoring Server Lengkap

```bash
#!/bin/bash

TANGGAL=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE=~/belajar-devops/monitoring.log

tampil_header() {
    echo "==============================="
    echo "  SERVER MONITORING REPORT"
    echo "  $TANGGAL"
    echo "==============================="
}

cek_disk() {
    DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    echo ""
    echo "📦 DISK USAGE: $DISK%"
    if [ $DISK -gt 90 ]; then
        echo "   ⚠️  CRITICAL!"
    elif [ $DISK -gt 70 ]; then
        echo "   ⚡ WARNING!"
    else
        echo "   ✅ Aman"
    fi
}

cek_memory() {
    TOTAL=$(free -m | grep Mem | awk '{print $2}')
    USED=$(free -m | grep Mem | awk '{print $3}')
    PERSEN=$((USED * 100 / TOTAL))
    echo ""
    echo "🧠 MEMORY USAGE: $USED MB / $TOTAL MB ($PERSEN%)"
    if [ $PERSEN -gt 90 ]; then
        echo "   ⚠️  CRITICAL!"
    elif [ $PERSEN -gt 70 ]; then
        echo "   ⚡ WARNING!"
    else
        echo "   ✅ Aman"
    fi
}

cek_service() {
    echo ""
    echo "⚙️  SERVICE STATUS:"
    for SERVICE in nginx ssh cron; do
        if sudo service $SERVICE status > /dev/null 2>&1; then
            echo "   ✅ $SERVICE"
        else
            echo "   ❌ $SERVICE"
        fi
    done
}

tampil_header
cek_disk
cek_memory
cek_service
```

Jadwalkan dengan cron setiap jam:
```bash
# crontab -e
0 * * * * ~/belajar-devops/scripts/monitoring.sh
```

---

## 8. Tips Bash Scripting

```bash
# Selalu mulai dengan #!/bin/bash
# Gunakan HURUF_BESAR untuk variabel global
# Gunakan huruf_kecil untuk variabel lokal di fungsi
# Selalu test script sebelum dijadwalkan di cron
# Gunakan echo untuk debug
# Simpan output penting ke log file
```

---

## Milestone Hari Ini ✅

- Variabel dan command substitution
- Kondisi if-elif-else
- Operator perbandingan angka dan string
- For loop dan while loop
- Aritmatika bash
- Fungsi dengan argumen
- Script monitoring server lengkap
- Menjadwalkan script dengan cron

---

*Selanjutnya: Minggu 6 — Mini Project: Setup VPS + Deploy Nginx + Auto Monitoring*

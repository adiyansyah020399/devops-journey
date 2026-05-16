#!/bin/bash

# Variable
NAMA="Muhamad Adiyansyah"
ROLE="DevOps Engineer"
TAHUN=2026
 
# Tampilkan Variable
echo "Nama  : $NAMA"
echo "Role  : $ROLE"
echo "Tahun : $TAHUN"

# Variable dari output perintah
HOSTNAME=$(hostname)
TANGGAL=$(date)
IP=$(ip a | grep 'inet ' | grep eth0 | awk '{print $2}')

echo ""
echo "Hostname : $HOSTNAME"
echo "Tanggal  : $TANGGAL"
echo "IP       : $IP"

# ================================
# KONDISI IF-ELSE
# ================================

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

echo ""
echo "=== Cek Disk Usage ==="
echo "Penggunaan disk: $DISK_USAGE%"

if [ $DISK_USAGE -gt 90 ]; then
    echo "⚠️  CRITICAL: Disk hampir penuh!"
elif [ $DISK_USAGE -gt 70 ]; then
    echo "⚡ WARNING: Disk mulai penuh"
else
    echo "✅ OK: Disk masih aman"
fi

# ================================
# LOOP
# ================================

echo ""
echo "=== For Loop ==="
for i in 1 2 3 4 5; do
    echo "Iterasi ke-$i"
done

echo ""
echo "=== Loop dengan Range ==="
for i in {1..5}; do
    echo "Nomor: $i"
done

echo ""
echo "=== Loop file di folder ==="
echo "File di ~/belajar-devops/catatan:"
for file in ~/belajar-devops/catatan/*.md; do
    echo "  - $(basename $file)"
done

echo ""
echo "=== While Loop ==="
COUNTER=1
while [ $COUNTER -le 3 ]; do
    echo "While iterasi ke-$COUNTER"
    COUNTER=$((COUNTER + 1))
done

# ================================
# FUNGSI
# ================================

# Definisi fungsi
cek_service() {
    SERVICE=$1
    if sudo service $SERVICE status > /dev/null 2>&1; then
        echo "✅ $SERVICE sedang berjalan"
    else
        echo "❌ $SERVICE tidak berjalan"
    fi
}

tampil_info_disk() {
    echo ""
    echo "=== Info Disk ==="
    df -h | grep -E "^/dev|^Filesystem"
}

# Panggil fungsi
echo ""
echo "=== Cek Status Service ==="
cek_service nginx
cek_service ssh
cek_service cron

tampil_info_disk



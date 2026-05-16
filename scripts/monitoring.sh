#!/bin/bash

# ================================
# SCRIPT MONITORING SERVER
# ================================

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

# Jalankan semua fungsi
tampil_header
cek_disk
cek_memory
cek_service

echo ""
echo "==============================="
echo "Report disimpan ke: $LOG_FILE"

# Simpan ke log
tampil_header >> $LOG_FILE
cek_disk >> $LOG_FILE
cek_memory >> $LOG_FILE
echo "" >> $LOG_FILE


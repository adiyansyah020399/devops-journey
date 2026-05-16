# Catatan Belajar Linux — Hari 2
**Text Processing & Shell Power**

## 1. grep — Mencari Teks

grep "kata" file.txt          # cari kata di file
grep -i "kata" file.txt       # case insensitive
grep -n "kata" file.txt       # tampilkan nomor baris
grep -v "kata" file.txt       # tampilkan yang TIDAK mengandung kata
grep -E "ERROR|WARNING" file  # cari ERROR atau WARNING (regex)

Regex dasar:
^ = awal baris
$ = akhir baris
| = atau (OR)

## 2. Pipe |

perintah1 | perintah2   # output p1 jadi input p2

Contoh:
grep "ERROR" server.log | wc -l
ls /etc | wc -l
ps aux | grep bash

## 3. cut — Ambil Kolom Tertentu

cut -d',' -f1 file.txt      # kolom 1, delimiter koma
cut -d',' -f1,3 file.txt    # kolom 1 dan 3

## 4. sort — Mengurutkan

sort file.txt               # urutkan alfabetis
sort -r file.txt            # urutkan terbalik
sort -n file.txt            # urutkan sebagai angka
sort -t',' -k4 -n file.txt  # urutkan berdasar kolom 4

## 5. uniq — Hapus Duplikat

sort file.txt | uniq        # harus sort dulu!
sort file.txt | uniq | wc -l

## 6. wc — Menghitung

wc -l file.txt    # hitung baris
wc -w file.txt    # hitung kata

## 7. sed — Mengganti Teks

sed 's/lama/baru/' file.txt   # ganti teks

## 8. Pipeline Lengkap — Contoh Nyata

# Analisis log
grep "ERROR" server.log | wc -l
grep "ERROR" server.log | cut -d' ' -f2
grep -E "ERROR|WARNING" server.log | wc -l

# Analisis data
sort -t',' -k4 -n -r karyawan.txt | head -n 3
grep "DevOps" karyawan.txt | cut -d',' -f1,3 | sort | sed 's/,/ - /'

*Selanjutnya: SSH, Package Manager & Cron*

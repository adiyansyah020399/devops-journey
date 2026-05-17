# Catatan Belajar — Fase 2 Hari 1
**Fase 2: Git, Scripting & Cloud | Minggu 1 — Git & GitHub**

---

## 1. Konsep Dasar Git

Git adalah sistem version control — mencatat setiap perubahan file secara permanen.

```
Working Directory → Staging Area → Local Repository → Remote (GitHub)
      │                  │                │                    │
   edit file          git add          git commit           git push
```

Analogi:
```
Working Dir = barang yang mau dikirim
Staging     = memasukkan ke dalam kardus
Commit      = kardus disegel dengan label
Push        = kirim ke gudang pusat (GitHub)
```

---

## 2. Setup Git

```bash
# Cek versi
git --version

# Setup identitas (wajib sebelum commit pertama)
git config --global user.name "Nama Kamu"
git config --global user.email "email@gmail.com"
git config --global init.defaultBranch main

# Simpan kredensial (tidak perlu input token berulang)
git config --global credential.helper store

# Verifikasi semua config
git config --list
```

---

## 3. Membuat Repository

```bash
# Buat repository baru di folder yang sudah ada
cd ~/folder-project
git init

# Cek status
git status
```

Output `git status`:
```
Untracked files   → file belum ditrack Git
Changes to be committed → sudah di staging, siap commit
Changes not staged      → ada perubahan tapi belum di-staging
```

---

## 4. Workflow Harian Git

```bash
# 1. Cek perubahan
git status

# 2. Lihat detail perubahan
git diff                    # perubahan belum di-staging
git diff --staged           # perubahan sudah di-staging

# 3. Staging
git add nama-file.txt       # staging satu file
git add .                   # staging semua perubahan

# 4. Unstaging (kalau salah add)
git restore --staged file.txt

# 5. Commit
git commit -m "pesan commit yang jelas"

# 6. Push ke GitHub
git push
git push -u origin main     # pertama kali push branch baru
```

---

## 5. Melihat History

```bash
git log                     # history lengkap
git log --oneline           # history singkat satu baris
git log --oneline --graph   # history dengan visualisasi branch
git log -5                  # 5 commit terakhir
git show HASH               # detail satu commit
```

---

## 6. .gitignore — File yang Tidak Perlu Ditrack

```bash
# Buat file .gitignore
nano .gitignore
```

Contoh isi `.gitignore`:
```
*.log           # semua file .log
*.tmp           # semua file .tmp
node_modules/   # folder node_modules
.env            # file environment (berisi password!)
__pycache__/    # cache Python
```

Keluarkan file yang sudah terlanjur di-staging:
```bash
git rm --cached nama-file.log
```

---

## 7. Branching

```bash
# Lihat semua branch
git branch

# Buat branch baru
git checkout -b nama-branch
git branch nama-branch      # buat tanpa pindah

# Pindah branch
git checkout nama-branch
git switch nama-branch      # cara baru

# Hapus branch
git branch -d nama-branch   # hapus branch yang sudah di-merge
git branch -D nama-branch   # paksa hapus
```

Naming convention branch:
```
feature/nama-fitur    → fitur baru
fix/nama-bug          → perbaikan bug
hotfix/nama-issue     → perbaikan darurat di production
docs/nama-dokumen     → update dokumentasi
```

---

## 8. Merging

```bash
# Pastikan di branch tujuan (biasanya main)
git checkout main

# Merge branch lain ke main
git merge nama-branch

# Tipe merge:
# Fast-forward  → tidak ada konflik, langsung maju
# Merge commit  → ada percabangan, dibuat commit baru
```

Kalau ada konflik:
```bash
# Cek file yang konflik
git status

# Edit file yang konflik, cari tanda:
# <<<<<<< HEAD
# kode dari main
# =======
# kode dari branch
# >>>>>>> nama-branch

# Setelah selesai edit, staging dan commit
git add .
git commit -m "resolve merge conflict"
```

---

## 9. Remote Repository (GitHub)

```bash
# Tambah remote
git remote add origin https://github.com/username/repo.git

# Cek remote
git remote -v

# Ganti URL remote (kalau salah)
git remote set-url origin https://username:TOKEN@github.com/username/repo.git

# Push pertama kali
git push -u origin main

# Push selanjutnya
git push

# Pull perubahan dari GitHub
git pull

# Clone repository dari GitHub
git clone https://github.com/username/repo.git
```

---

## 10. Personal Access Token (GitHub)

GitHub tidak support password biasa untuk push. Harus pakai token:

1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token (classic)
4. Centang scope: **repo** (semua sub-item)
5. Generate & copy tokennya
6. Pakai token sebagai password saat push

Simpan token di URL supaya tidak perlu input terus:
```bash
git remote set-url origin https://USERNAME:TOKEN@github.com/USERNAME/REPO.git
```

---

## 11. Perintah Git Lainnya

```bash
# Batalkan perubahan di working directory
git restore nama-file.txt

# Kembali ke commit tertentu (hati-hati!)
git checkout HASH

# Buat tag untuk versi
git tag v1.0.0
git push origin v1.0.0

# Stash — simpan perubahan sementara
git stash          # simpan
git stash pop      # ambil kembali
```

---

## 12. Workflow Git Standar DevOps

```bash
# Mulai fitur baru
git checkout -b feature/nama-fitur

# Kerja, edit, tambah file...

# Commit progress
git add .
git commit -m "feat: tambah fitur X"

# Push branch ke GitHub
git push -u origin feature/nama-fitur

# Setelah selesai, merge ke main
git checkout main
git merge feature/nama-fitur
git push

# Hapus branch
git branch -d feature/nama-fitur
```

---

## Repository

```
GitHub: https://github.com/adiyansyah020399/devops-journey
```

---

## Milestone Hari Ini ✅

- Setup Git config (nama, email, default branch)
- Buat repository lokal dengan git init
- Git add, commit, log
- Branching dan merging
- Push ke GitHub
- Personal Access Token setup
- Repository live di GitHub

---

*Selanjutnya: Fase 2 Minggu 2 — Docker Dasar*

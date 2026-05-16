#!/bin/bash
echo "=== Cek Disk $(date) ===" >> ~/belajar-devops/disk.log
df -h >> ~/belajar-devops/disk.log
echo "" >> ~/belajar-devops/disk.log

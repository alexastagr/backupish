#!/bin/bash


DB_LIST="databases.txt"  
BACKUP_DIR="/path/to/local/backup"
DATE=$(date +"%Y-%m-%d")

# Your FTP Credentials
FTP_ENABLE=true
FTP_HOST="ftp.example.com"
FTP_USER="ftp_username"
FTP_PASS="ftp_password"
FTP_DIR="/remote/backup/path"

# create DIR if not exist
mkdir -p "$BACKUP_DIR/$DATE"

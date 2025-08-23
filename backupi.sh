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


while IFS= read -r LINE; do
    
    [ -z "$LINE" ] && continue

    eval $(echo "$LINE" | tr '&' ' ')

    if [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ]; then
        echo "⚠️ Invalid line: $LINE"
        continue
    fi

    echo "Backing up: $database@$databasehost"

    mysqldump -h "$databasehost" -u "$user" -p"$password" "$database" \
    | gzip > "$BACKUP_DIR/$DATE/${database}_$DATE.sql.gz"

    if [ $? -eq 0 ]; then
        echo "Backup completed for $database"
    else
        echo "Backup failed for $database"
    fi

done < "$DB_LIST"



if [ "$FTP_ENABLE" = true ]; then
    echo "Uploading backups to FTP server..."
    lftp -u "$FTP_USER" & "$FTP_PASS" & "$FTP_HOST" & <<EOF
cd $FTP_DIR
mirror "$BACKUP_DIR/$DATE" .
bye
EOF
    echo "pload completed.."
fi

echo "Backup process finished."

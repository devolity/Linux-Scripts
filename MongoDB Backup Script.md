
Creating a bash script to back up a MongoDB database involves using `mongodump` to create a dump of your database. Here's a script that automates the backup process and allows for storing backups with a timestamp in the filename.
### Step-by-Step Guide:

1. **Create the Backup Directory:**
   Make sure you have a directory to store your backups. For example, `/path/to/backup/directory`.

2. **Write the Backup Script:**

   Create a new bash script file, for example `mongodb_backup.sh`, and add the following content:

   ```bash
   #!/bin/bash

   # MongoDB connection details
   MONGO_HOST="localhost"
   MONGO_PORT="27017"
   MONGO_USER="your_mongodb_user"  # If authentication is enabled
   MONGO_PASS="your_mongodb_password"  # If authentication is enabled
   MONGO_DB="your_database_name"

   # Backup storage directory
   BACKUP_DIR="/path/to/backup/directory"

   # Date format for backup file names
   DATE_FORMAT=$(date +'%Y-%m-%d_%H-%M-%S')

   # Create backup file name
   BACKUP_NAME="${MONGO_DB}_backup_${DATE_FORMAT}.gz"

   # Full path to the backup file
   BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

   # Perform the backup using mongodump
   mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS --db $MONGO_DB --archive=$BACKUP_PATH --gzip

   # Check if the backup was successful
   if [ $? -eq 0 ]; then
       echo "Backup successful: ${BACKUP_PATH}"
   else
       echo "Backup failed"
       exit 1
   fi

   # Optional: Remove old backups (older than 7 days)
   find $BACKUP_DIR -name "${MONGO_DB}_backup_*.gz" -mtime +7 -exec rm {} \;

   # Optional: Print list of current backups
   echo "Current backups:"
   ls -lh $BACKUP_DIR
   ```

3. **Make the Script Executable:**

   ```bash
   chmod +x mongodb_backup.sh
   ```

4. **Run the Script:**

   Execute the script to perform a backup:

   ```bash
   ./mongodb_backup.sh
   ```

5. **Automate the Backup Process:**

   To schedule regular backups, use `cron`. Edit the crontab for the current user:

   ```bash
   crontab -e
   ```

   Add a line to run the script at your desired interval. For example, to run the backup script every day at 2 AM:

   ```bash
   0 2 * * * /path/to/mongodb_backup.sh
   ```

### Explanation of the Script:

- **MongoDB Connection Details**: Replace `your_mongodb_user`, `your_mongodb_password`, and `your_database_name` with your actual MongoDB username, password, and database name. If your MongoDB does not require authentication, you can remove the `--username` and `--password` options.

- **Backup Directory**: Replace `/path/to/backup/directory` with the path to the directory where you want to store your backups.

- **Date Format**: The `DATE_FORMAT` variable creates a timestamp to uniquely name each backup file.

- **mongodump Command**: This command creates a compressed (`--gzip`) archive (`--archive`) of the specified MongoDB database. The backup file is named according to the `BACKUP_NAME` variable and stored in the `BACKUP_DIR`.

- **Error Checking**: The script checks if the `mongodump` command was successful and prints a message accordingly.

- **Remove Old Backups**: The `find` command deletes backup files older than 7 days. Adjust the `-mtime +7` value to keep backups for a different number of days.

- **List Current Backups**: The script lists the current backups in the backup directory for verification purposes.

This script and setup should provide a robust solution for automating MongoDB backups on your server.
rsync -a --delete /home/joos/ /tmp/backup

if [ "$?" -eq 0 ]; then
        logger "Backup successfully"
else    logger "Backup failed"
fi
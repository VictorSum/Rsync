#!/bin/bash
srv_user=joos
srv_ip=10.103.7.20
rsync -avz --progress --delete $srv_user@$srv_ip:/home/joos/ /tmp/current/ --backup --backup-dir=/tmp/increment/`date +%Y-%m-%d-%H-%M`/

cd /tmp/increment/
ls -t | tail -n +6 | xargs rm -rf --
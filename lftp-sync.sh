#!/bin/bash

login=$1
host=$2
remote_dir=$3
local_dir=$4

base_name="$(basename "$0")"
lock_file="/tmp/$base_name.lock"
trap "rm -f $lock_file; exit 0" SIGINT SIGTERM

if [[ -e "$lock_file" ]]
then
    echo "$base_name is running already."
    exit
else
    touch "$lock_file"
    lftp -u "$login", sftp://"$host" << EOF
    set sftp:auto-confirm yes
    set xfer:use-temp-file yes
    set xfer:temp-file-name *.lftp
    set mirror:use-pget-n 30
    set mirror:parallel-transfer-count 5
    set mirror:parallel-directories yes
    mirror -c --log="/var/log/sync/$base_name.log" --exclude .sync/ --Move --scan-all-first "$remote_dir" "$local_dir"
    quit
EOF
    rm -f "$lock_file"
    trap - SIGINT SIGTERM
    exit
fi
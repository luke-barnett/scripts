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
    set mirror:use-pget-n 10
    mirror -c -P5 --log="/var/log/sync/$base_name.log" "$remote_dir" "$local_dir"
    quit
EOF
    rm -f "$lock_file"
    trap - SIGINT SIGTERM
    exit
fi
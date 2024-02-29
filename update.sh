#!/bin/sh

# RELEASED UNDER GNU GENERAL PUBLIC LICENSE Version v2
# Script by leproide - https://github.com/Leproide

path="/var/www/html/changeme"

# URL dello script PowerShell
ScriptURL='https://massgrave.dev/get.ps1'

# Scarica lo script PowerShell e cerca la variabile $DownloadURL
DownloadURL=$(curl -s "$ScriptURL" | grep -oP '\$DownloadURL = \x27\K[^\x27]+')

# Controlla se l'estrazione è riuscita
if [ -n "$DownloadURL" ]; then
    wget_result="$(wget -NS "$DownloadURL" -P "$path" -O MAS_AIO.cmd_update 2>&1 | grep "HTTP/" | awk '{print $2}')"

    if [ $wget_result = 200 ]; then
        if cmp -s "$path/MAS_AIO.cmd" "$path/MAS_AIO.cmd_update"; then
            echo "Files are the same"
            rm "$path/MAS_AIO.cmd_update"
            echo "No update available $(date)" >> "$path/update.log"
            exit 1
        else
            echo "Files are different"
            rm "$path/MAS_AIO.cmd.bak"
            mv "$path/MAS_AIO.cmd" "$path/MAS_AIO.cmd.bak"
            mv "$path/MAS_AIO.cmd_update" "$path/MAS_AIO.cmd"
            echo "Updated $(date)" >> "$path/update.log"
            exit 1
        fi
    else
        echo "Something went wrong"
        echo "DOWNLOAD ERROR - $wget_result - $(date)" >> "$path/update.log"
        exit 1
    fi
else
    echo "Impossibile recuperare URL download" >> "$path/update.log"
    exit 1
fi

#!/bin/sh

# RELEASED UNDER GNU GENERAL PUBLIC LICENSE Version v2
# Script by leproide - https://github.com/Leproide

path="/var/www/html/changeme"

wget_result="$(wget -NS https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd -P "$path" -O MAS_AIO.cmd_update 2>&1 | grep "HTTP/" | awk '{print $2}')"

if [ $wget_result = 200 ]; then
if cmp -s $path/MAS_AIO.cmd $path/MAS_AIO.cmd_update
then echo "Files are the same"
rm $path/MAS_AIO.cmd_update
echo No update available $(date) >> $path/update.log
exit 0
else echo "Files are different"
rm $path/MAS_AIO.cmd.bak
mv $path/MAS_AIO.cmd $path/MAS_AIO.cmd.bak
mv $path/MAS_AIO.cmd_update $path/MAS_AIO.cmd
echo Updated $(date) >> $path/update.log
exit 0
fi
else
    echo "Something went wrong"
        echo DOWNLOAD ERROR - $wget_result - $(date) >> $path/update.log
        exit 1
fi

#!/bin/sh

# RELEASED UNDER GNU GENERAL PUBLIC LICENSE Version v2
# Script by leproide - https://github.com/Leproide

path="/var/www/html/changeme"

# MASSGRAVE GET SCRIPT URL
ScriptURL='https://get.activated.win'

# CHECK IF SCRIPT URL IS ACCESSIBLE
if curl --output /dev/null --silent --head --fail "$ScriptURL"; then
    # Fetching download URLs from the new script
    DownloadURLs=$(curl -s "$ScriptURL" | grep -oP '(?<=\$DownloadURL[1-3] = \')[^\']+')

    # Check if we successfully fetched the URLs
    if [ -n "$DownloadURLs" ]; then
        # Update each URL into an array
        IFS=$'\n' read -r -d '' -a urls <<< "$DownloadURLs"

        for url in "${urls[@]}"; do
            # Attempting to download the script
            wget_result="$(wget -NS "$url" -P "$path" -O MAS_AIO.cmd_update 2>&1 | grep "HTTP/" | awk '{print $2}')"

            if [ $wget_result = 200 ]; then
                if cmp -s "$path/MAS_AIO.cmd" "$path/MAS_AIO.cmd_update"; then
                    echo "Files are the same"
                    rm "$path/MAS_AIO.cmd_update"
                    echo "No update available $(date)" >> "$path/update.log"
                    exit 1
                else
                    echo "Files are different"
                    rm "$path/MAS_AIO.cmd.bak" 2>/dev/null
                    mv "$path/MAS_AIO.cmd" "$path/MAS_AIO.cmd.bak"
                    mv "$path/MAS_AIO.cmd_update" "$path/MAS_AIO.cmd"
                    echo "Updated $(date)" >> "$path/update.log"
                    exit 1
                fi
            else
                echo "Failed to download from $url, HTTP status: $wget_result"
            fi
        done
        echo "All URLs have been tried, no successful download."
        exit 1
    else
        echo "Cant fetch download url from remote script" >> "$path/update.log"
        exit 1
    fi
else
    echo "Error: Unable to reach $ScriptURL" >> "$path/update.log"
    exit 1
fi

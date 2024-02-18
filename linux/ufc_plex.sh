#!/bin/bash

# Log file path
log_file="/var/log/ufc_script.log"

# Function to log messages
log() {
    local log_timestamp
    log_timestamp=$(date +"%Y-%m-%d %T")
    echo "[$log_timestamp] $*" >> "$log_file"
}

while getopts "p:m:" flag; do
    case "${flag}" in
        p) ppvnumber=${OPTARG};;
        m) mainevent=${OPTARG};;
    esac
done

# Log script start
log "----------START----------"
log "Script started with PPV number $ppvnumber and main event $mainevent"

# UFC folder paths vars, Season Format naming standard var. 
localfolder="data/usenet/tv"
destinationshare="/mnt/shared/Videos/Plex_TV_Shows/Ultimate Fighting Championship/Season 1/"
seasonfmt="S01E$ppvnumber"

# UFC Downloaded File Check
ufcfolder=$(ls "/$localfolder" | grep "$ppvnumber")
if [[ -z "$ufcfolder" ]]; then
    log "No UFC PPV $ppvnumber folder found in $localfolder. Exiting script."
    exit 1
fi

# File ID Collection
originalufcfile=$(ls "/$localfolder/$ufcfolder"/*"$ppvnumber"*)

# File conversions by type
if [[ $originalufcfile =~ ".mkv" ]]; then
    newufcfile=$(echo "${originalufcfile//*.mkv/"UFC.$ppvnumber.$mainevent.$seasonfmt.mkv"}")
elif [[ $originalufcfile =~ ".mp4" ]]; then
    newufcfile=$(echo "${originalufcfile//*.mp4/"UFC.$ppvnumber.$mainevent.$seasonfmt.mp4"}")
fi

renameufcfile="/$localfolder/$ufcfolder/$newufcfile"

# Check if the file already exists in the destination
if [[ -e "$destinationshare/$newufcfile" ]]; then
    log "File $newufcfile already exists in the destination. Skipping..."
else
    # Rename Downloaded Original File to Naming Standard
    mv "$originalufcfile" "$renameufcfile" >> "$log_file" 2>&1
    # Log file renaming 
    log " $originalufcfile renamed to $renameufcfile"
    
    # Move the Renamed file to the destination
    mv "$renameufcfile" "$destinationshare" >> "$log_file" 2>&1
    # Log file movement
    log "Moved file $renameufcfile to $destinationshare"

    # Local Cleanup and last 10 fights retained
    rm "/$localfolder/$ufcfolder" -rf >> "$log_file" 2>&1
    log "Removed local folder /$localfolder/$ufcfolder"
    
    cd "$destinationshare" 
    # Check if there are files to be removed in the destination
    files_to_remove=$(ls -1tr "$destinationshare" | head -n -10)
    if [[ -n "$files_to_remove" ]]; then
        # Remove old files in the destination and log the action
        echo "$files_to_remove" | xargs -I{} echo "Removing file {}" >> "$log_file"
        echo "$files_to_remove" | xargs -I{} rm -f {} >> "$log_file" 2>&1
        log "Removed old files in $destinationshare"
    else
        log "No files to remove in $destinationshare"
    fi
fi

# Log script end
log "Script completed."

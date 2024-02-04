#/bin/bash

while getopts "p:m:" flag
do
    case "${flag}" in
        p) ppvnumber=${OPTARG};;
        m) mainevent=${OPTARG};;
    esac
done
#UFC folder paths vars
localfolder="data/usenet/tv"
$destinationshare="/mnt/shared/Videos/Plex_TV_Shows/Ultimate\ Fighting\ Championship/Season\ 1/"
#ufc file find and rename vars
ufcfolder=$(ls /$localfolder |grep $ppvnumber)
originalufcfile=$(ls /$localfolder/$ufcfolder/*$ppvnumber* )
seasonfmt="S01E"
seasonfmt+="$ppvnumber"

#file conversions by type
if [[ $originalufcfile =~ ".mkv" ]]; then
newufcfile=$(echo "${originalufcfile//*.mkv/"UFC.$ppvnumber.$mainevent.$seasonfmt.mkv"}")
renameufcfile=$(echo /$localfolder/$ufcfolder/$newufcfile)
mv $originalufcfile $renameufcfile
mv $renameufcfile $destinationshare
fi
if [[ $originalufcfile =~ ".mp4" ]]; then
newufcfile=$(echo "${originalufcfile//*.mp4/"UFC.$ppvnumber.$mainevent.$seasonfmt.mp4"}")
renameufcfile=$(echo /$localfolder/$ufcfolder/$newufcfile)
mv $originalufcfile $renameufcfile
mv $renameufcfile $destinationshare
fi
#Local Cleanup and last 10 fights retained
rm /$localfolder/$ufcfolder -rf
cd  $destinationshare 
ls -1tr $destinationshare | head -n -10 |xargs -n 1 rm

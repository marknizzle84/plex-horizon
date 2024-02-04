#/bin/bash

while getopts "q:" flag
do
    case "${flag}" in
        q) query=${OPTARG};;
    esac
done

baseurl="http://192.168.1.61:32400"
token='whUWzw2_CHyxJkMx76Mj'

curl -L -X GET "$baseurl/$query" \
-H 'Accept: application/json' \
-H "X-Plex-Token: $token"

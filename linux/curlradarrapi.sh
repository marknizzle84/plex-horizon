#/bin/bash
# API Reference: https://radarr.video/docs/api/#
# Get Movies - ./curlradarrapi.sh -q /api/v3/movie |jq .[].title


while getopts "q:" flag
do
    case "${flag}" in
        q) query=${OPTARG};;
    esac
done

baseurl="http://192.168.1.62:7878"
token=$(cat radarrtoken.pem)
#echo "$baseurl/$query?apikey=$token"

curl -X GET "$baseurl$query?apikey=$token" \
  -H 'accept: application/json' \
  -H "X-Api-Key: $token"

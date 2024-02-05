#/bin/bash
# API Reference: https://radarr.video/docs/api/#
# Get Movies - ./curlradarrapi.sh -q /api/v3/movie |jq .[].title
# Get Unmonitored Movies  ./curlradarrapi.sh -q /api/v3/movie |jq -r '.[] |select(.monitored == false)|.title'


while getopts "q:t:" flag
do
    case "${flag}" in
        q) query=${OPTARG};;
        t) type=${OPTARG};;
    esac
done

baseurl="http://192.168.1.62:7878"
token=$(cat radarrtoken.pem)
#echo "$baseurl/$query?apikey=$token"

curl -X $type "$baseurl$query?apikey=$token" \
  -H 'accept: application/json' \
  -H "X-Api-Key: $token"

#/bin/bash
#titles of unwatched movies query with jq - "./curlplexapi.sh -q library/sections/1/unwatched |jq -r '.[].Metadata[].title' "
#titles of unwatched tvshow query with jq - "./curlplexapi.sh -q library/sections/2/unwatched |jq -r '.[].Metadata[].title' "
# select item 3 in array with jq - " ./curlplexapi.sh -q library/sections/1/unwatched |jq -r '.[].Metadata[2]' "
# give details of all movies between years - "./curlplexapi.sh -q library/sections/1/unwatched |jq -r '.[].Metadata[]| select(.year >= 1935 and .year <= 1969)' "
# give just titles of all movies between years - "./curlplexapi.sh -q library/sections/1/unwatched |jq -r '.[].Metadata[]| select(.year >= 1935 and .year <= 1969)| .title' "
# query for video codecs not h264 and return results " ./curlplexapi.sh -q library/sections/1/unwatched | jq -r '.[].Metadata[] | select(.Media[].videoCodec != "h264") | .title,.Media[].videoCodec' "
while getopts "q:" flag
do
    case "${flag}" in
        q) query=${OPTARG};;
    esac
done

baseurl="http://192.168.1.61:32400"
token=$(cat plextoken.pem)

curl -L -X GET "$baseurl/$query" \
-H 'Accept: application/json' \
-H "X-Plex-Token: $token"

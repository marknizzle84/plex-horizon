#/bin/bash
# API Reference: https://radarr.video/docs/api/#
# Get Movies - ./curlradarrapi.sh -q /api/v3/movie |jq .[].title
# Get Unmonitored Movies  ./curlradarrapi.sh -q /api/v3/movie |jq -r '.[] |select(.monitored == false)|.title.id'


baseurl="http://192.168.1.62:7878"
token=$(cat radarrtoken.pem)
API_ENDPOINT="/api/v3/movie"

# Function to fetch and print the list of movie IDs
fetch_movie_ids() {
curl -X GET "$baseurl$API_ENDPOINT?apikey=$token" \
  -H 'accept: application/json' \
  -H "X-Api-Key: $token" \
| jq -r '.[] | select(.monitored == false)|.id'
}

# Function to delete a movie by ID
delete_movie() {
    local id="$1"
    echo "Deleting movie with ID: $id"
    curl -X DELETE "$baseurl$API_ENDPOINT/$id?apikey=$token"
}

# Check command-line argument
if [ "$1" == "delete-unmonitored" ]; then
    # Delete movies
    ids=$(fetch_movie_ids)
    for id in $ids; do
        delete_movie "$id"
    done
else
    # Default: Fetch and print movie IDs
    fetch_movie_ids
fi

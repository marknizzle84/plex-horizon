import requests

url = "http://192.168.1.61:32400/butler"
with open('plextoken.pem', 'r') as file:
    token = file.read()

payload={}
headers = {
  'Accept': 'application/json',
  'X-Plex-Token': token
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)

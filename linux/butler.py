import requests

url = "http://192.168.1.61:32400/butler"

payload={}
headers = {
  'Accept': 'application/json',
  'X-Plex-Token': 'whUWzw2_CHyxJkMx76Mj'
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)
import requests
import urllib.parse
import sys

# Check if the correct number of arguments is passed
if len(sys.argv) != 3:
    print("Usage: python getsongbpm.py 'Artist Name' 'Song Title'")
    sys.exit(1)

# Replace YOUR_API_KEY_HERE with your actual getsongbpm.com API key
API_KEY = "4a45338f3b72c92981ea4c26c94ebf61"
BASE_URL = "https://api.getsongbpm.com"

def search_song(artist, title):
    """
    Search for a song by artist and title, returning the first matching song's ID.
    """
    # URL encode the artist and title
    encoded_artist = urllib.parse.quote(artist)
    encoded_title = urllib.parse.quote(title)
    search_url = f"{BASE_URL}/search/?api_key={API_KEY}&type=both&lookup=song:{encoded_title}%20artist:{encoded_artist}"
    
    response = requests.get(search_url)
    if response.status_code != 200:
        print(f"Error fetching search results: {response.status_code}")
        sys.exit(1)
    
    results = response.json().get('search')
    if not results:
        print("No results found.")
        sys.exit(1)
    
    # Assuming the first result is the desired one
    return results[0]['id']

def get_song_bpm(song_id):
    """
    Fetch the BPM of a song using its ID.
    """
    song_url = f"{BASE_URL}/song/?api_key={API_KEY}&id={song_id}"
    response = requests.get(song_url)
    if response.status_code != 200:
        print(f"Error fetching song details: {response.status_code}")
        sys.exit(1)
    
    song_details = response.json().get('song')
    if not song_details:
        print("Song details not found.")
        sys.exit(1)
    
    return song_details.get('tempo')

def main():
    artist = sys.argv[1]
    title = sys.argv[2]
    
    print(f"Searching for '{title}' by '{artist}'...")
    song_id = search_song(artist, title)
    bpm = get_song_bpm(song_id)
    
    if bpm:
        print(f"The BPM of '{title}' by '{artist}' is: {bpm}")
    else:
        print("BPM not found.")

if __name__ == "__main__":
    main()

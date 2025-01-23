import requests
import os
import time
import json
from pathlib import Path

def get_all_cards():
    """Fetch all cards from the API"""
    url = "https://db.ygoprodeck.com/api/v7/cardinfo.php"
    try:
        print("Fetching card list...")
        response = requests.get(url)
        if response.status_code == 200:
            return response.json().get('data', [])
        return []
    except Exception as e:
        print(f"Error fetching cards: {e}")
        return []

def download_image(url, filepath):
    """Download image from URL"""
    try:
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            return True
        return False
    except Exception as e:
        print(f"Error downloading {url}: {e}")
        return False

def setup_directories():
    """Create necessary directories if they don't exist"""
    # Create main pics directory
    Path("pics").mkdir(exist_ok=True)
    # Create field directory for field spells
    Path("pics/field").mkdir(exist_ok=True)
    # Create thumbnail directory
    Path("pics/thumbnail").mkdir(exist_ok=True)

def download_card_images():
    """Download all card images"""
    setup_directories()
    
    # Get all cards
    cards = get_all_cards()
    if not cards:
        print("No cards found!")
        return

    total_cards = len(cards)
    print(f"Found {total_cards} cards")

    # Track progress
    successful = 0
    failed = []
    
    # Create a log file for failed downloads
    with open('failed_downloads.txt', 'w') as log:
        # Process each card
        for i, card in enumerate(cards, 1):
            card_id = str(card.get('id'))
            name = card.get('name', 'Unknown')
            
            print(f"Processing {i}/{total_cards}: {name} ({card_id})")
            
            # Get image URLs
            images = card.get('card_images', [])
            if not images:
                failed.append(f"{card_id} - {name} - No images found")
                continue

            # Get first image (usually the main one)
            image = images[0]
            
            # Download main image
            main_url = image.get('image_url')
            main_path = f"pics/{card_id}.jpg"
            
            # Download small image
            small_url = image.get('image_url_small')
            small_path = f"pics/thumbnail/{card_id}.jpg"
            
            # Respect API rate limit (20 requests per second)
            time.sleep(0.05)
            
            # Download both images
            main_success = download_image(main_url, main_path)
            small_success = download_image(small_url, small_path)
            
            if main_success and small_success:
                successful += 1
            else:
                failed.append(f"{card_id} - {name}")
                log.write(f"{card_id} - {name} - Main: {main_success}, Small: {small_success}\n")
            
            # Progress update
            if i % 100 == 0:
                print(f"Progress: {i}/{total_cards} ({(i/total_cards)*100:.1f}%)")
                print(f"Successful: {successful}, Failed: {len(failed)}")

    # Final report
    print("\nDownload Complete!")
    print(f"Total cards processed: {total_cards}")
    print(f"Successfully downloaded: {successful}")
    print(f"Failed downloads: {len(failed)}")
    print("See failed_downloads.txt for details on failed downloads")

    # Save failed downloads to JSON for reference
    with open('failed_downloads.json', 'w') as f:
        json.dump(failed, f, indent=2)

if __name__ == "__main__":
    download_card_images()

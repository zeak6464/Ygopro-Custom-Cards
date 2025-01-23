import requests
import os
import re
from bs4 import BeautifulSoup
import time
import sqlite3

def sanitize_filename(filename):
    """Remove invalid characters from filename"""
    return re.sub(r'[<>:"/\\|?*]', '', filename)

def create_database_structure(cursor):
    """Create the database tables with the correct structure"""
    # Create texts table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS texts (
            id INTEGER PRIMARY KEY,
            name TEXT,
            desc TEXT
        )
    ''')
    
    # Create datas table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS datas (
            id INTEGER PRIMARY KEY,
            ot INTEGER,
            alias INTEGER,
            setcode INTEGER,
            type INTEGER,
            atk INTEGER,
            def INTEGER,
            level INTEGER,
            race INTEGER,
            attribute INTEGER,
            category INTEGER
        )
    ''')

def download_pack_image(pack_name, pack_num, output_dir):
    """Download pack image from Yu-Gi-Oh! Wikia"""
    
    # Check if image already exists
    filename = f"{pack_num}.jpg"
    filepath = os.path.join(output_dir, filename)
    if os.path.exists(filepath):
        print(f"Skipping {filename} - already exists")
        return True
    
    # Create URL-friendly pack name
    search_name = pack_name.replace(' ', '_')
    
    # Try different URL patterns
    urls = [
        f"https://yugioh.fandom.com/wiki/{search_name}",
        f"https://yugioh.fandom.com/wiki/{search_name}_Booster_Pack"
    ]
    
    for url in urls:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                soup = BeautifulSoup(response.text, 'html.parser')
                
                # Look for the pack image
                image = soup.find('img', {'class': 'pi-image-thumbnail'})
                if image and image.get('src'):
                    image_url = image['src']
                    
                    # Download the image
                    img_response = requests.get(image_url)
                    if img_response.status_code == 200:
                        # Save image
                        with open(filepath, 'wb') as f:
                            f.write(img_response.content)
                        print(f"Downloaded {filename} - {pack_name}")
                        return True
                        
        except Exception as e:
            print(f"Error downloading pack #{pack_num} ({pack_name}): {e}")
            continue
            
    print(f"Could not find image for pack #{pack_num} ({pack_name})")
    return False

def extract_pack_info(lua_file):
    """Extract pack names from the Lua script"""
    packs = []
    
    with open(lua_file, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Find the highest pack number in the script
    pack_num_pattern = r'pack\[(\d+)\]'
    pack_numbers = re.findall(pack_num_pattern, content)
    max_pack_id = max(int(num) for num in pack_numbers) if pack_numbers else 0
        
    # Find pack definitions using regex
    pattern = r'--([^\n]+)\s*--Released:'
    matches = re.finditer(pattern, content)
    
    for match in matches:
        pack_name = match.group(1).strip()
        # Remove pack code from name if present
        pack_name = re.sub(r'\([^)]*\)', '', pack_name).strip()
        current_pack = len(packs) + 1
        packs.append((current_pack, pack_name))
            
    return packs, max_pack_id

def update_database(packs, max_pack_id):
    """Update the database with pack IDs and names"""
    
    # Connect to database
    conn = sqlite3.connect('Test.db')
    cursor = conn.cursor()
    
    # Create database structure if it doesn't exist
    create_database_structure(cursor)
    
    # Get current maximum ID in texts table
    cursor.execute("SELECT MAX(id) FROM texts WHERE id <= ?", (max_pack_id,))
    current_max = cursor.fetchone()[0] or 0
    
    print(f"Current maximum pack ID in database: {current_max}")
    print(f"Maximum pack ID in script: {max_pack_id}")
    
    # Delete only entries that are pack IDs from both tables
    cursor.execute("DELETE FROM texts WHERE id BETWEEN 1 AND ?", (max_pack_id,))
    cursor.execute("DELETE FROM datas WHERE id BETWEEN 1 AND ?", (max_pack_id,))
    
    # Insert pack information
    for pack_id, pack_name in packs:
        # Insert into texts table
        cursor.execute(
            "INSERT INTO texts (id, name, desc) VALUES (?, ?, ?)",
            (pack_id, pack_name, '')  # Include pack name, empty desc
        )
        
        # Insert into datas table with default values
        cursor.execute(
            "INSERT INTO datas (id, ot, alias, setcode, type, atk, def, level, race, attribute, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (pack_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)  # category 1 for packs
        )
    
    # Fill remaining IDs if needed
    last_pack = len(packs)
    if last_pack < max_pack_id:
        for pack_id in range(last_pack + 1, max_pack_id + 1):
            # Insert into texts table
            cursor.execute(
                "INSERT INTO texts (id, name, desc) VALUES (?, ?, ?)",
                (pack_id, '', '')
            )
            
            # Insert into datas table
            cursor.execute(
                "INSERT INTO datas (id, ot, alias, setcode, type, atk, def, level, race, attribute, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                (pack_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)
            )
    
    # Commit changes and close connection
    conn.commit()
    conn.close()
    print(f"Updated database with {max_pack_id} pack entries")

def main():
    try:
        # Get pack information from Lua script
        packs, max_pack_id = extract_pack_info("script/c6465.lua")
        print(f"Found {len(packs)} packs in Lua script")
        
        # Create output directory for images
        output_dir = "pack_images"
        os.makedirs(output_dir, exist_ok=True)
        
        # Download pack images first
        print("\nDownloading pack images...")
        for pack_id, pack_name in packs:
            print(f"\nProcessing pack #{pack_id}: {pack_name}")
            download_pack_image(pack_name, pack_id, output_dir)
            time.sleep(1)  # Delay to avoid overwhelming the server
            
        # Then update the database
        print("\nUpdating database...")
        update_database(packs, max_pack_id)
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()

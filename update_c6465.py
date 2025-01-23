import requests
import json
import time

def get_all_sets():
    """Fetch all card sets from the API"""
    url = "https://db.ygoprodeck.com/api/v7/cardsets.php"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        return []
    except Exception as e:
        print(f"Error fetching sets: {e}")
        return []

def get_cards_from_set(set_name):
    """Fetch all cards from a specific set"""
    url = f"https://db.ygoprodeck.com/api/v7/cardinfo.php?cardset={set_name}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.json().get('data', [])
        return []
    except Exception as e:
        print(f"Error fetching {set_name}: {e}")
        return []

def generate_pack_lua(pack_num, set_info, cards):
    """Generate Lua code for a pack"""
    # Create the header comment and pack initialization
    lua_code = (
        f"\n        --{set_info['set_name']} ({set_info['set_code']})\n"
        f"        --Released: {set_info['tcg_date']}\n"
        f"        pack[{pack_num}]={{}}\n"
        f"        pack[{pack_num}][1]={{\n"
    )
    
    # Add card IDs with comments for names
    for card in cards:
        lua_code += f"            {card['id']}, --{card['name']}\n"
    
    # Add the closing brackets and pack setup
    lua_code += (
        "        }\n"
        f"        pack[{pack_num}][2]={{}}\n"
        f"        pack[{pack_num}][3]={{}}\n"
        f"        for _,v in ipairs(pack[{pack_num}][1]) do table.insert(pack[{pack_num}][3],v) end\n"
    )
    
    return lua_code

def update_c6465():
    # Get all sets
    print("Fetching all card sets...")
    sets = get_all_sets()
    if not sets:
        print("Failed to fetch card sets")
        return
    
    # Sort sets by release date
    sets.sort(key=lambda x: x.get('tcg_date', '9999-99-99'))
    
    all_packs = "\n        --Pack definitions generated from YGOPRODeck API\n"
    
    # Read existing file
    try:
        with open('c6465.lua', 'r', encoding='utf-8') as file:
            content = file.read()
    except Exception as e:
        print(f"Error reading c6465.lua: {e}")
        return

    # Process each set
    for i, set_info in enumerate(sets, 1):
        set_name = set_info['set_name']
        print(f"Processing {i}/{len(sets)}: {set_name}")
        
        # Respect API rate limit (20 requests per second)
        time.sleep(0.05)
        
        cards = get_cards_from_set(set_name)
        if cards:
            pack_code = generate_pack_lua(i, set_info, cards)
            all_packs += pack_code
            print(f"Added {len(cards)} cards from {set_name}")
        else:
            print(f"No cards found for {set_name}")

    # Find where to insert the new packs
    pack_start = content.find("pack={}")
    if pack_start != -1:
        # Create updated content
        new_content = (
            content[:pack_start + 7] + 
            all_packs +
            content[pack_start + 7:]
        )
        
        # Write to new file
        try:
            with open('c6465.lua', 'w', encoding='utf-8') as file:
                file.write(new_content)
            print("\nSuccessfully created c6465_updated.lua")
            
            # Write sets info to JSON for reference
            with open('card_sets_info.json', 'w') as f:
                json.dump(sets, f, indent=2)
            print("Created card_sets_info.json with set information")
            
        except Exception as e:
            print(f"Error writing updated file: {e}")
    else:
        print("Could not find pack={} in the original file")

if __name__ == "__main__":
    update_c6465()

Yu-Gi-Oh! Pack Opening Duel Scripts (c6465)
==================================

This folder contains scripts for managing the Pack Opening Duel system.

Files:
------
1. update_c6465.py
   - Updates the c6465.lua script with current card sets from YGOPRODeck API
   - Generates pack definitions for all available card sets
   - Creates card_sets_info.json with set information

2. update_packs.py
   - Downloads pack images from Yu-Gi-Oh! Wikia
   - Creates/updates zeak6464-unofficial.cdb with pack information
   - Images are saved as numbered files (1.jpg to #.jpg) in pack_images folder
   - Skips downloading if image already exists

3. update_pics.py
   - Updates card images for the game
   - Downloads missing card pictures

4. script/c6465.lua
   - Main script for Pack Opening Duel
   - Contains all pack definitions and game logic
   - Used by EDOPro for the Pack Opening Duel mode

Usage:
------
1. Update card sets:
   python update_c6465.py

2. Download pack images and update database:
   python update_packs.py

3. Update card images:
   python update_pics.py

Requirements:
------------
- Python 3.6 or higher
- Required Python packages:
  - requests
  - beautifulsoup4
  - sqlite3 (usually included with Python)

Folder Structure:
----------------
- pack_images/                    : Contains pack artwork (1.jpg to #.jpg)
- script/                         : Contains Lua scripts
- zeak6464-unofficial.cdb         : SQLite database for pack information

Notes:
------
- Run scripts in order: update_c6465.py -> update_packs.py -> update_pics.py
- Make sure you have a stable internet connection
- Some pack images might not be available on Yu-Gi-Oh! Wikia
- The database is automatically created/updated when running update_packs.py 
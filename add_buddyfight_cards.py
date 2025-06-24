import sqlite3
import os
import re

# BuddyFight Card Database
BUDDYFIGHT_CARDS = [
    # System/Utility Cards
    {
        'id': 202500000,
        'name': 'BuddyFight Duel System',
        'desc': 'Core system script for BuddyFight duels. Manages gauge, size system, buddy calls, and all game mechanics.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x1000,  # BuddyFight system
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500001,
        'name': 'BuddyFight Field Generator',
        'desc': 'Activates BuddyFight rules and restrictions. Required to start a BuddyFight duel.',
        'type': 0x80002,  # Field Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x1000,  # BuddyFight system
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Buddy Monsters
    {
        'id': 202500002,
        'name': 'Drum Bunker Dragon "2018"',
        'desc': 'A Size 2 Buddy Monster from Future Card BuddyFight. Has Soulguard and can be Buddy Called for 2 gauge. When in center, opponent cannot attack directly.',
        'type': 0x21,  # Effect Monster
        'atk': 5000, 'def': 3000, 'level': 6,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x1000,  # Buddy Monster
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Dragon World Monsters
    {
        'id': 202500010,
        'name': 'Gigant Sword Dragon',
        'desc': 'A Size 2 Dragon World monster. When summoned, you can destroy 1 opponent monster. Requires 2 gauge to call.',
        'type': 0x21,  # Effect Monster
        'atk': 6000, 'def': 2000, 'level': 6,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500011,
        'name': 'Extreme Sword Dragon',
        'desc': 'A Size 2 Dragon World monster with Double Attack. Can attack twice per turn. Requires 2 gauge to call.',
        'type': 0x21,  # Effect Monster
        'atk': 5000, 'def': 3000, 'level': 6,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500012,
        'name': 'Steel Gauntlet Dragon',
        'desc': 'A Size 1 Dragon World monster with defensive abilities. When destroyed, can search for another Dragon World monster.',
        'type': 0x21,  # Effect Monster
        'atk': 3000, 'def': 4000, 'level': 4,
        'race': 0x4,  # Dragon
        'attribute': 0x10,  # Earth
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500013,
        'name': 'Thousand Rapier Dragon',
        'desc': 'A Size 1 Dragon World monster. When it destroys an opponent monster, inflict 1 damage to opponent.',
        'type': 0x21,  # Effect Monster
        'atk': 4000, 'def': 2000, 'level': 4,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500014,
        'name': 'Bear-Trap Fang Dragon',
        'desc': 'A Size 1 Dragon World monster. When opponent attacks, can change attack target to this card.',
        'type': 0x21,  # Effect Monster
        'atk': 3000, 'def': 3000, 'level': 4,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500015,
        'name': 'Systemic Dagger Dragon',
        'desc': 'A Size 1 Dragon World monster with Move and Quick Attack. Can change battle position and attack the turn it is summoned.',
        'type': 0x21,  # Effect Monster
        'atk': 3000, 'def': 2000, 'level': 4,
        'race': 0x4,  # Dragon
        'attribute': 0x8,  # Fire
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500016,
        'name': 'Latale Shield Dragon',
        'desc': 'A Size 1 Dragon World monster with defensive abilities. Reduces battle damage to 0 once per turn. When destroyed, can summon another Dragon World monster.',
        'type': 0x21,  # Effect Monster
        'atk': 2000, 'def': 4000, 'level': 4,
        'race': 0x4,  # Dragon
        'attribute': 0x10,  # Earth
        'setcode': 0x5000,  # Dragon World
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Spells
    {
        'id': 202500017,
        'name': 'Dragon Heal',
        'desc': 'Gain 2 Life (2000 LP). A basic healing spell for Dragon World decks.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x2000,  # BuddyFight Spell
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500018,
        'name': 'Dragon Force',
        'desc': 'All Dragon World monsters gain +1000 ATK until end of turn. Pay 1 gauge to cast.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x2000,  # BuddyFight Spell
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500019,
        'name': 'Dragon Sanctuary',
        'desc': 'Reduce all battle damage to Dragon World monsters to 0 this turn. Pay 2 gauge to cast.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x2000,  # BuddyFight Spell
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500020,
        'name': 'Emergency Shield',
        'desc': 'Can only be cast when opponent attacks and you have no monsters in center. Negate the attack.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x2000,  # BuddyFight Spell
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Items
    {
        'id': 202500021,
        'name': 'Dragonblade, Dragobrave',
        'desc': 'A legendary Dragon World item. Grants +5000 ATK and counterattack abilities. Pay 3 gauge to equip.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x6000,  # BuddyFight Item
        'ot': 4, 'alias': 0, 'category': 0
    },
    {
        'id': 202500022,
        'name': 'Dragonblade, Dragofearless',
        'desc': 'A basic Dragon World item. Grants +3000 ATK. No equip cost - can be equipped for free.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x6000,  # BuddyFight Item
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Impact
    {
        'id': 202500023,
        'name': 'Reckless Angerrrr!!',
        'desc': 'Can only be cast during Final Phase. Destroy all monsters on the field, then deal 1 Life damage for each destroyed monster. Pay 3 gauge to cast.',
        'type': 0x2,  # Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x3000,  # Impact
        'ot': 4, 'alias': 0, 'category': 0
    },
    
    # Flags
    {
        'id': 202500024,
        'name': 'Dragon World',
        'desc': 'The Dragon World flag. Dragon World monsters gain +500 ATK/DEF. Can attack directly if opponent has no Size 2+ monsters. When a Dragon World monster destroys an opponent monster, draw 1 card. Pay 1 gauge to search for a Dragon World monster.',
        'type': 0x80002,  # Field Spell
        'atk': 0, 'def': 0, 'level': 0,
        'race': 0, 'attribute': 0,
        'setcode': 0x1001,  # Flag
        'ot': 4, 'alias': 0, 'category': 0
    }
]

def create_database_structure(cursor):
    """Create the database tables with the correct structure"""
    # Create texts table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS texts (
            id INTEGER PRIMARY KEY,
            name TEXT,
            desc TEXT,
            str1 TEXT,
            str2 TEXT,
            str3 TEXT,
            str4 TEXT,
            str5 TEXT,
            str6 TEXT,
            str7 TEXT,
            str8 TEXT,
            str9 TEXT,
            str10 TEXT,
            str11 TEXT,
            str12 TEXT,
            str13 TEXT,
            str14 TEXT,
            str15 TEXT,
            str16 TEXT
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

def add_buddyfight_cards_to_database(db_file='zeak6464-unofficial.cdb'):
    """Add all BuddyFight cards to the database"""
    
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    
    # Create database structure if it doesn't exist
    create_database_structure(cursor)
    
    # Remove existing BuddyFight cards (ID range 202500000-202500099)
    cursor.execute("DELETE FROM texts WHERE id BETWEEN 202500000 AND 202500099")
    cursor.execute("DELETE FROM datas WHERE id BETWEEN 202500000 AND 202500099")
    
    print(f"Adding {len(BUDDYFIGHT_CARDS)} BuddyFight cards to database...")
    
    # Add each BuddyFight card
    for card in BUDDYFIGHT_CARDS:
        # Insert into texts table
        cursor.execute('''
            INSERT INTO texts (id, name, desc) VALUES (?, ?, ?)
        ''', (card['id'], card['name'], card['desc']))
        
        # Insert into datas table
        cursor.execute('''
            INSERT INTO datas (id, ot, alias, setcode, type, atk, def, level, race, attribute, category) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            card['id'],
            card['ot'],
            card['alias'],
            card['setcode'],
            card['type'],
            card['atk'],
            card['def'],
            card['level'],
            card['race'],
            card['attribute'],
            card['category']
        ))
        
        print(f"Added: {card['name']} (ID: {card['id']})")
    
    # Commit changes and close connection
    conn.commit()
    conn.close()
    
    print(f"\nSuccessfully added {len(BUDDYFIGHT_CARDS)} BuddyFight cards to {db_file}")
    print("\nCard Summary:")
    print("- 2 System cards (Field Generator, Core System)")
    print("- 1 Buddy Monster (Drum Bunker Dragon)")
    print("- 7 Dragon World Monsters (Size 1 and Size 2)")
    print("- 4 Spells (Heals, Buffs, Protection)")
    print("- 2 Items (Dragonblades)")
    print("- 1 Impact (Board wipe)")
    print("- 1 Flag (Dragon World)")

def main():
    try:
        # Check if database file exists
        db_file = 'zeak6464-unofficial.cdb'
        if not os.path.exists(db_file):
            print(f"Database file {db_file} not found. Creating new database...")
        
        # Add BuddyFight cards to database
        add_buddyfight_cards_to_database(db_file)
        
        print("\nDatabase update complete!")
        print("You can now use these BuddyFight cards in EDOPro/YGOPro.")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main() 
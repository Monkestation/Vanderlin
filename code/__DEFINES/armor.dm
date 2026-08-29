// bonus used for depth layering for armor
#define LAYERED_ARMOR_STACK_BONUS 1.5

#define ARMOR_BLOCK "block"
#define ARMOR_BLUNT_DMG "blunt_dmg"
#define ARMOR_TYPE_DMG "typed_dmg"

#define DAMAGE_TYPED "typed"
#define DAMAGE_BLUNT "blunt"


// Modifiers for a material.
/*-------------------------\
| MATERIAL MODIFIER DEFINES |
\-------------------------*/

/// A bonus applied to certain antag/special equipment, only in cases where it is necessary for the equipment to be particularly resilient comparative to material.
#define INTEGRITY_SPECIAL_BONUS 1.2
/// A malus applied to certain antag/special equipment, only in cases where it is necessary for the equipment to be weaker comparative to the material.
#define INTEGRITY_SPECIAL_MALUS 0.8

#define INTEGRITY_MOD_BLACKSTEEL 1.3
#define INTEGRITY_MOD_DARKSTEEL 1.4
#define INTEGRITY_MOD_BLOODSTEEL 1.3
#define INTEGRITY_MOD_KETRYL 1.5
#define INTEGRITY_MOD_STEEL 1
#define INTEGRITY_MOD_SILVER 0.8
#define INTEGRITY_MOD_IRON 0.75
#define INTEGRITY_MOD_LEATHER 0.6
#define INTEGRITY_MOD_GOLD 0.6
#define INTEGRITY_MOD_BRONZE 0.5
#define INTEGRITY_MOD_COPPER 0.3
#define INTEGRITY_MOD_IMPROV 0.15


/*-------------------------\
| WEAPON INTEGRITY DEFINES |
\-------------------------*/

#define INTEGRITY_GOD_WEAPON 1750

#define INTEGRITY_SLEDGEHAMMER 900
#define INTEGRITY_BARMACE 900
#define INTEGRITY_WARHAMMER 850
#define INTEGRITY_MACE 750
#define INTEGRITY_FLAIL 700
#define INTEGRITY_HAMMER 700

#define INTEGRITY_GREATSWORD 800
#define INTEGRITY_LONGSWORD 750
#define INTEGRITY_SWORD 650
#define INTEGRITY_RAPIER 600

#define INTEGRITY_URUMI 600
#define INTEGRITY_WHIP 500

#define INTEGRITY_GREATAXE 800
#define INTEGRITY_DBL_BATTLEAXE INTEGRITY_BATTLEAXE + 50
#define INTEGRITY_BATTLEAXE 700
#define INTEGRITY_AXE 650

#define INTEGRITY_HALBERD 700
#define INTEGRITY_SPEAR 600
#define INTEGRITY_QUARTERSTAFF 550
#define INTEGRITY_JAVELIN 450

#define INTEGRITY_HANDCLAW 350

#define INTEGRITY_DAGGER 350
#define INTEGRITY_KNIFE 325
#define INTEGRITY_TOSSBLADE 175

#define INTEGRITY_SHIELD 600

/*-------------------------\
| STATIC INTEGRITY DEFINES |
\-------------------------*/

#define INTEGRITY_STATIC_200 200
#define INTEGRITY_STATIC_300 300
#define INTEGRITY_STATIC_400 400

#define INTEGRITY_UNBREAKABLE 10000000

/*----------------------\
| OLD INTEGRITY DEFINES |
\----------------------*/

#define INTEGRITY_OLD_BLACKSTEEL	650		// BLACKSTEEL
#define INTEGRITY_OLD_STRONGEST		500		// STEEL
#define INTEGRITY_OLD_STRONG		300		// IRON
#define INTEGRITY_OLD_STANDARD		200		// LEATHER
#define INTEGRITY_OLD_POOR			150		// GAMBESON, COPPER
#define INTEGRITY_OLD_WORST			100

/*------------------------\
| ARMOR INTEGRITY DEFINES | // Use these when possible on armor to keep value consistent.
\------------------------*/
// Side = Non-chest armor integrity
// For now. Steel vs Iron will be a difference of 75% integrity without rating differences.
// So Iron will actually be pretty decent and there shouldn't be a compulsive need to upgrade.

// Helmet
#define ARMOR_INT_HELMET_ANTAG 600
#define ARMOR_INT_HELMET_BLACKSTEEL 500
#define ARMOR_INT_HELMET_HEAVY_STEEL 400
#define ARMOR_INT_HELMET_HEAVY_IRON 300
#define ARMOR_INT_HELMET_HEAVY_DECREPIT 200
#define ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY 50 // Integrity reduction, if a helmet is adjustable
#define ARMOR_INT_HELMET_STEEL 300
#define ARMOR_INT_HELMET_IRON 225
#define ARMOR_INT_HELMET_HARDLEATHER 250
#define ARMOR_INT_HELMET_LEATHER 200
#define ARMOR_INT_HELMET_CLOTH 100

// Chest / Armor Pieces

// HEAVY
#define ARMOR_INT_CHEST_PLATE_ANTAG 700
#define ARMOR_INT_CHEST_PLATE_BLACKSTEEL 600
#define ARMOR_INT_CHEST_PLATE_STEEL 500
#define ARMOR_INT_CHEST_PLATE_BRIGANDINE 350
#define ARMOR_INT_CHEST_PLATE_PSYDON 400 // You get free training, less int
#define ARMOR_INT_CHEST_PLATE_IRON 375
#define ARMOR_INT_CHEST_PLATE_DECREPIT 250

// MEDIUM
#define ARMOR_INT_CHEST_MEDIUM_STEEL 300
#define ARMOR_INT_CHEST_MEDIUM_IRON 225
#define ARMOR_INT_CHEST_MEDIUM_SCALE 200 // More coverage, less integrity
#define ARMOR_INT_CHEST_MEDIUM_DECREPIT 150

// LIGHT
#define ARMOR_INT_CHEST_LIGHT_MASTER 300 // High tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_MEDIUM 250 // Medium tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_BASE 200
#define ARMOR_INT_CHEST_LIGHT_STEEL 180
#define ARMOR_INT_CHEST_CIVILIAN 100

// LEG PIECES - Leg Armor
#define ARMOR_INT_LEG_ANTAG 600
#define ARMOR_INT_LEG_BLACKSTEEL 500
#define ARMOR_INT_LEG_STEEL_PLATE 400
#define ARMOR_INT_LEG_IRON_PLATE 300
#define ARMOR_INT_LEG_DECREPIT_PLATE 200
#define ARMOR_INT_LEG_STEEL_CHAIN 300
#define ARMOR_INT_LEG_BRIGANDINE 250 // Iron grade but whatever.
#define ARMOR_INT_LEG_IRON_CHAIN 225
#define ARMOR_INT_LEG_DECREPIT_CHAIN 150
#define ARMOR_INT_LEG_HARDLEATHER 250
#define ARMOR_INT_LEG_LEATHER 200
#define ARMOR_INT_LEG_CLOTH 10

// SIDE PIECES - Non-Chest armor
#define ARMOR_INT_SIDE_ANTAG 500 // Integrity for antag pieces
#define ARMOR_INT_SIDE_BLACKSTEEL 400 // Integrity for blacksteel pieces
#define ARMOR_INT_SIDE_STEEL 300 // Integrity for steel pieces
#define ARMOR_INT_SIDE_IRON 225 // Integrity for iron pieces
#define ARMOR_INT_SIDE_HARDLEATHER 250 // Integrity for hardened leather pieces
#define ARMOR_INT_SIDE_LEATHER 200 // Integrity for leather / copper pieces
#define ARMOR_INT_SIDE_DECREPIT 150 // Integrity for decrepit pieces
#define ARMOR_INT_SIDE_CLOTH 100 // Integrity for cloth / aesthetic oriented pieces

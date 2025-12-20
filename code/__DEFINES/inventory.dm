/*ALL DEFINES RELATED TO INVENTORY OBJECTS, MANAGEMENT, ETC, GO HERE*/

//ITEM INVENTORY WEIGHT, FOR w_class
#define WEIGHT_CLASS_TINY     1 //Usually items smaller then a human hand, (e.g. playing cards, lighter, scalpel, coins/holochips)
#define WEIGHT_CLASS_SMALL    2 //Pockets can hold small and tiny items, (e.g. flashlight, multitool, grenades, GPS device)
#define WEIGHT_CLASS_NORMAL   3 //Standard backpacks can carry tiny, small & normal items, (e.g. fire extinguisher, stun baton, gas mask, metal sheets)
#define WEIGHT_CLASS_BULKY    4 //Items that can be weilded or equipped but not stored in an inventory, (e.g. defibrillator, backpack, space suits)
#define WEIGHT_CLASS_HUGE     5 //Usually represents objects that require two hands to operate, (e.g. shotgun, two-handed melee weapons)
#define WEIGHT_CLASS_GIGANTIC 6 //Essentially means it cannot be picked up or placed in an inventory, (e.g. mech parts, safe)

//Inventory depth: limits how many nested storage items you can access directly.
//1: stuff in mob, 2: stuff in backpack, 3: stuff in box in backpack, etc
#define INVENTORY_DEPTH		2
#define STORAGE_VIEW_DEPTH	2

//ITEM INVENTORY SLOT BITMASKS

#define ITEM_SLOT_PANTS			(1<<0)
#define ITEM_SLOT_SHIRT			(1<<1)
#define ITEM_SLOT_ARMOR			(1<<2)
#define ITEM_SLOT_SHOES			(1<<3)
#define ITEM_SLOT_GLOVES		(1<<4)
#define ITEM_SLOT_RING			(1<<5)
#define ITEM_SLOT_MASK			(1<<6)
#define ITEM_SLOT_MOUTH			(1<<7)
#define ITEM_SLOT_HEAD			(1<<8)
#define ITEM_SLOT_CLOAK			(1<<9)
#define ITEM_SLOT_NECK			(1<<10)
#define ITEM_SLOT_HANDS			(1<<11)
#define ITEM_SLOT_BELT			(1<<12)
#define ITEM_SLOT_BACK_R		(1<<13)
#define ITEM_SLOT_BACK_L		(1<<14)
#define ITEM_SLOT_WRISTS		(1<<15)
#define ITEM_SLOT_HANDCUFFED 	(1<<16)
#define ITEM_SLOT_LEGCUFFED 	(1<<17)
#define ITEM_SLOT_BELT_L		(1<<18)
#define ITEM_SLOT_BELT_R		(1<<19)
/// Inside of a character's backpack
#define ITEM_SLOT_BACKPACK 		(1<<20)

#define SLOTS_AMT			21 // Keep this up to date!

#define ITEM_SLOT_BACK			(ITEM_SLOT_BACK_L | ITEM_SLOT_BACK_R)
#define ITEM_SLOT_HIP			(ITEM_SLOT_BELT_L | ITEM_SLOT_BELT_R)

#define DEFAULT_SLOT_PRIORITY list(\
	ITEM_SLOT_HEAD,\
	ITEM_SLOT_SHIRT,\
	ITEM_SLOT_PANTS,\
	ITEM_SLOT_GLOVES,\
	ITEM_SLOT_SHOES,\
	ITEM_SLOT_MASK,\
	ITEM_SLOT_WRISTS,\
	ITEM_SLOT_CLOAK,\
	ITEM_SLOT_ARMOR,\
	ITEM_SLOT_BACK_L,\
	ITEM_SLOT_BACK_R,\
	ITEM_SLOT_BELT,\
	ITEM_SLOT_BELT_L,\
	ITEM_SLOT_BELT_R,\
	ITEM_SLOT_MOUTH,\
	ITEM_SLOT_NECK,\
	ITEM_SLOT_RING,\
	ITEM_SLOT_HANDS,\
)

//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
//Make sure to update check_obscured_slots() if you add more.
#define HIDEGLOVES (1<<0)
#define HIDESUITSTORAGE (1<<1)
#define HIDEJUMPSUIT (1<<2)	//these first four are only used in exterior suits
#define HIDESHOES (1<<3)
#define HIDEMASK (1<<4)
#define HIDEEARS (1<<5)	// (ears means headsets and such)
#define HIDEEYES (1<<6)	// Whether eyes and glasses are hidden
#define HIDEFACE (1<<7)	// Whether we appear as unknown.
#define HIDEHAIR (1<<8)
#define HIDEFACIALHAIR (1<<9)
#define HIDENECK (1<<10)
#define HIDEBOOB (1<<11)
#define HIDEBELT (1<<12)
#define HIDETAIL (1<<13)
// Some clothing have bras, etc of their own and look wrong overlayed over the default underwear
// Such as the amazonian chainkini
// Younglings will always override this don't worry
/// Don't show default underwear bras when wearing this (Female only)
#define HIDEUNDIESTOP (1<<14)
/// Don't show default underwear bottoms when wearing this
#define HIDEUNDIESBOT (1<<15)
/// Don't show either
#define HIDEUNDIES (HIDEUNDIESTOP | HIDEUNDIESBOT)

//blocking_behavior var on clothing items
#define BLOCKBOOTS		(1<<0)
#define BLOCKGLOVES		(1<<1)
#define BLOCKWRISTS		(1<<2)
#define BLOCKARMOR		(1<<3)
#define BLOCKSHIRT		(1<<4)
#define BLOCKPANTS		(1<<5)
#define BLOCKCLOAK		(1<<6)
#define BULKYBLOCKS		(1<<7)

//bitflags for clothing coverage - also used for limbs
#define HEAD		(1<<0)
#define CHEST		(1<<1)
#define GROIN		(1<<2)
#define LEG_LEFT	(1<<3)
#define LEG_RIGHT	(1<<4)
#define LEGS		(LEG_LEFT | LEG_RIGHT)
#define FOOT_LEFT	(1<<5)
#define FOOT_RIGHT	(1<<6)
#define FEET		(FOOT_LEFT | FOOT_RIGHT)
#define ARM_LEFT	(1<<7)
#define ARM_RIGHT	(1<<8)
#define ARMS		(ARM_LEFT | ARM_RIGHT)
#define HAND_LEFT	(1<<9)
#define HAND_RIGHT	(1<<10)
#define HANDS		(HAND_LEFT | HAND_RIGHT)
#define NECK		(1<<11)
#define VITALS		(1<<13)
#define MOUTH		(1<<14)
#define EARS		(1<<15)
#define NOSE		(1<<16)
#define RIGHT_EYE	(1<<17)
#define LEFT_EYE	(1<<18)
#define HAIR		(1<<19)
#define EYES		(LEFT_EYE | RIGHT_EYE)
#define FACE		(MOUTH | NOSE | EYES)
#define FULL_HEAD	(HEAD | MOUTH | NOSE | EYES | EARS | HAIR)
#define HEAD_EXCEPT_MOUTH	(HEAD | NOSE | EYES | EARS | HAIR)
#define HEAD_NECK	(HEAD | MOUTH | NOSE | EYES | EARS | HAIR | NECK)
#define BELOW_HEAD	(CHEST | GROIN | VITALS | ARMS | HANDS | LEGS | FEET)
#define BELOW_CHEST	(GROIN | LEGS | FEET) //for water
#define FULL_BODY	(FULL_HEAD | NECK | BELOW_HEAD)

//defines for the index of hands
#define LEFT_HANDS 1
#define RIGHT_HANDS 2

/// sleeve flags
#define SLEEVE_NORMAL 0
#define SLEEVE_TORN 1
#define SLEEVE_ROLLED 2
#define SLEEVE_NOMOD 3

//flags for female outfits: How much the game can safely "take off" the uniform without it looking weird
#define NO_FEMALE_UNIFORM			0
#define FEMALE_UNIFORM_FULL			1
#define FEMALE_UNIFORM_TOP			2

//flags for alternate styles: These are hard sprited so don't set this if you didn't put the effort in
#define NORMAL_STYLE		0
#define ALT_STYLE			1

//flags for outfits that have mutantrace variants (try not to use this): Currently only needed if you're trying to add tight fitting bootyshorts
#define NO_MUTANTRACE_VARIATION		0
#define MUTANTRACE_VARIATION		1

//flags for covering body parts
#define GLASSESCOVERSEYES	(1<<0)
#define MASKCOVERSEYES		(1<<1)		// get rid of some of the other stupidity in these flags
#define HEADCOVERSEYES		(1<<2)		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		(1<<3)		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		(1<<4)
#define PEPPERPROOF			(1<<5)	//protects against pepperspray

#define TINT_DARKENED 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully

#define CANT_CADJUST 0
#define CAN_CADJUST 1
#define CADJUSTED 2

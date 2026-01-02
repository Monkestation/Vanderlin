// PRICESHEET: (this prices are based on aprox 2X before tax of prices of the player market at 01/01/26 )
// Leather = 20 per
// Iron = 60 per - Based off a smith charge of 30 per ingot
// Steel = 80 per - Based off a smith charge of 40 per ingot
// Gold = 100 per = Based off a smith charge of 50 per ingot
// Wood = 10 mammonons per small log
// essential items can be discounted because nobody even makes those anyways.
// any item can be little more or less , the merchant is not a replacement for a local smith.

/datum/supply_pack/armor
	group = "Armor"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

// IRON GEAR

/datum/supply_pack/armor/light
	group = "Armor(Light)"

// HELMETS

/datum/supply_pack/armor/light/skullcap
	name = "Skullcap Helmet"
	cost = 30 ///Two made per one bar
	contains = /obj/item/clothing/head/helmet/skullcap

/datum/supply_pack/armor/light/poth
	name = "Pot Helmet"
	cost = 60
	contains = /obj/item/clothing/head/helmet/ironpot

/datum/supply_pack/armor/light/lakkariancap
	name = "Lakkarian Cap"
	cost = 160 ///One iron, one gold
	contains = /obj/item/clothing/head/helmet/ironpot/lakkariancap

// MASK COIF NECK

/datum/supply_pack/armor/light/imask
	name = "Iron Facemask"
	cost = 30
	contains = /obj/item/clothing/face/facemask

/datum/supply_pack/armor/light/chaincoif_iron
	name = "Iron Chain Coif"
	cost = 60
	contains = /obj/item/clothing/neck/chaincoif/iron

// ARMOR

/datum/supply_pack/armor/light/lightleather_armor
	name = "Leather Armor"
	cost = 15
	contains = /obj/item/clothing/armor/leather

/datum/supply_pack/armor/light/splint
	name = "Splint Armor"
	cost = 45
	contains = /obj/item/clothing/armor/leather/splint

/datum/supply_pack/armor/light/studleather
	name = "Hardened Leather Armor"
	cost = 50
	contains = /obj/item/clothing/armor/leather/advanced

/datum/supply_pack/armor/light/icuirass
	name = "Iron Cuirass"
	cost = 60
	contains = /obj/item/clothing/armor/cuirass/iron

/datum/supply_pack/armor/light/ihalf_plate
	name = "Iron Half-plate"
	cost = 180 ///three iron bars
	contains = /obj/item/clothing/armor/plate/iron

/datum/supply_pack/armor/light/ifull_plate
	name = "Iron Plate Armor"
	cost = 240 ///4 iron bars
	contains = /obj/item/clothing/armor/plate/full/iron

/datum/supply_pack/armor/light/lakkarianarmor
	name = "Lakkarian Armor"
	cost = 180 //Kinda guessing on this one based on it being heavy armor
	contains = /obj/item/clothing/armor/gambeson/heavy/lakkarijupon

/datum/supply_pack/armor/light/stepperobes
	name = "Steppe Robes"
	cost = 60
	contains = /obj/item/clothing/armor/gambeson/light/steppe

/datum/supply_pack/armor/light/steppehidearmor
	name = "Steppe Hide Armor"
	cost = 28
	contains = /obj/item/clothing/armor/leather/hide/steppe

/datum/supply_pack/armor/light/shamaniccoat
	name = "Shamanic Coat"
	cost = 30
	contains = /obj/item/clothing/armor/leather/heavy/atgervi

// SHIRT ARMOR

/datum/supply_pack/armor/light/chainmail_iron
	name = "Iron Chainmail"
	cost = 39
	contains = /obj/item/clothing/armor/chainmail/iron

/datum/supply_pack/armor/light/haukberk
	name = "Iron hauberk"
	cost = 120
	contains = /obj/item/clothing/armor/chainmail/hauberk/iron

// ARMS

/datum/supply_pack/armor/light/leather_bracers
	name = "Leather Bracers"
	cost = 15
	contains = /obj/item/clothing/wrists/bracers/leather

/datum/supply_pack/armor/light/bracers
	name = "Iron Vambraces"
	cost = 60
	contains = /obj/item/clothing/wrists/bracers/iron

/datum/supply_pack/armor/light/heavy_gloves
	name = "Heavy Leather Gloves"
	cost = 20
	contains = /obj/item/clothing/gloves/angle

/datum/supply_pack/armor/light/chain_gloves_iron
	name = "Iron Chain Gloves"
	cost = 30
	contains = /obj/item/clothing/gloves/chain/iron

// PANTS

/datum/supply_pack/armor/light/chainlegs_iron
	name = "Iron Chain Chausses"
	cost = 60
	contains = /obj/item/clothing/pants/chainlegs/iron

/datum/supply_pack/armor/light/chainkilt_iron
	name = "Iron Chain Kilt"
	cost = 60
	contains = /obj/item/clothing/pants/chainlegs/kilt/iron

// BOOTS

/datum/supply_pack/armor/light/light_armor_boots
	name = "Iron Boots"
	cost = 60
	contains = /obj/item/clothing/shoes/boots/armor/light

// STEEL GEAR

/datum/supply_pack/armor/steel
	group = "Armor(Steel)"

// HELMETS
/datum/supply_pack/armor/steel/hounskull
	name = "Hounskull Helmet"
	cost = 240 /// Three steel bars
	contains = /obj/item/clothing/head/helmet/visored/hounskull

/datum/supply_pack/armor/steel/zplatehelm
	name = "Zalad Plate Helm"
	cost = 160
	contains = /obj/item/clothing/head/rare/zaladplate

/datum/supply_pack/armor/steel/zsallet
	name = "Zalad Sallet"
	cost = 80
	contains = /obj/item/clothing/head/helmet/sallet/zalad

/datum/supply_pack/armor/steel/nasalh
	name = "Nasal Helmet"
	cost = 40 ///Two made per bar
	contains = /obj/item/clothing/head/helmet/nasal

/datum/supply_pack/armor/steel/sallet
	name = "Sallet Helmet"
	cost = 80
	contains = /obj/item/clothing/head/helmet/sallet

/datum/supply_pack/armor/steel/visorsallet
	name = "Visored Sallet"
	cost = 160
	contains = /obj/item/clothing/head/helmet/visored/sallet

/datum/supply_pack/armor/steel/buckethelm
	name = "Great Helm"
	cost = 80
	contains = /obj/item/clothing/head/helmet/heavy/bucket

/datum/supply_pack/armor/steel/pegasushelm
	name = "Pegasus Knight Helm"
	cost = 80
	contains = /obj/item/clothing/head/helmet/pegasusknight

/datum/supply_pack/armor/steel/elvenhelm
	name = "Elf Sallet"
	cost = 180 ///One gold one steel
	contains = /obj/item/clothing/head/helmet/sallet/elven

/datum/supply_pack/armor/steel/atgervihelm
	name = "Atgervi Helm"
	cost = 80
	contains = /obj/item/clothing/head/helmet/bascinet/atgervi

/datum/supply_pack/armor/steel/steppehelm
	name = "Steppe Bascinet"
	cost = 80
	contains = /obj/item/clothing/head/helmet/bascinet/steppe

// MASK COIF NECK

/datum/supply_pack/armor/steel/smask
	name = "Steel Facemask"
	cost = 80
	contains = /obj/item/clothing/face/facemask/steel

/datum/supply_pack/armor/steel/steppemask
	name = "Steppe Mask"
	cost = 80
	contains = /obj/item/clothing/face/facemask/steel/steppe

/datum/supply_pack/armor/steel/beastmask
	name = "Steppe Beast Mask"
	cost = 80
	contains = /obj/item/clothing/face/facemask/steel/steppebeast

/datum/supply_pack/armor/steel/chaincoif_steel
	name = "Steel Chain Coif"
	cost = 80
	contains = /obj/item/clothing/neck/chaincoif

// ARMOR

/datum/supply_pack/armor/steel/slamellar
	name = "Steel Lamellar"
	cost = 170 ///two steel, one hide
	contains = /obj/item/clothing/armor/medium/scale/steppe

/datum/supply_pack/armor/steel/zplatearmor
	name = "Zalad Plate"
	cost = 320 ///Four steel bars
	contains = /obj/item/clothing/armor/rare/zaladplate

/datum/supply_pack/armor/steel/cuirass
	name = "Steel Cuirass"
	cost = 80
	contains = /obj/item/clothing/armor/cuirass

/datum/supply_pack/armor/steel/brigandine
	name = "Brigandine"
	cost = 240 ///Three steel bars
	contains = /obj/item/clothing/armor/brigandine

/datum/supply_pack/armor/steel/coatofplates
	name = "Coat Of Plates"
	cost = 240
	contains = /obj/item/clothing/armor/brigandine/coatplates

/datum/supply_pack/armor/steel/half_plate // so heavy users have something to buy
	name = "Steel Half-plate"
	cost = 240
	contains = /obj/item/clothing/armor/plate

/datum/supply_pack/armor/steel/elvenplate
	name = "Elven Cuirass"
	cost = 180
	contains = /obj/item/clothing/armor/cuirass/rare/elven

// SHIRT ARMOR

/datum/supply_pack/armor/steel/atgervichest
	name = "Atgervi Hauberk"
	cost = 160
	contains = /obj/item/clothing/armor/chainmail/hauberk/atgervi

/datum/supply_pack/armor/steel/chainmail
	name = "Steel Chainmail"
	cost = 80
	contains = /obj/item/clothing/armor/chainmail

/datum/supply_pack/armor/steel/chainmail_hauberk
	name = "Hauberk"
	cost = 160
	contains = /obj/item/clothing/armor/chainmail/hauberk

// ARMS

/datum/supply_pack/armor/steel/bracers
	name = "Steel Bracers"
	cost = 80
	contains = /obj/item/clothing/wrists/bracers

/*/datum/supply_pack/armor/steel/zplategloves
	name = "Zalad Plate Gloves"
	cost = 55
	contains = /obj/item/clothing/armor/rare/zaladplate
*/// This isnt gloves, this is the zalad plate chest piece.

/datum/supply_pack/armor/steel/plate_gloves
	name = "Heavy Plate Gloves"
	cost = 80
	contains = /obj/item/clothing/gloves/plate

/datum/supply_pack/armor/steel/atgervigloves
	name = "Atgervi Gloves"
	cost = 80
	contains = /obj/item/clothing/gloves/plate/atgervi

// PANTS

/datum/supply_pack/armor/steel/chainlegs_steel
	name = "Steel Chain Chausses"
	cost = 80
	contains = /obj/item/clothing/pants/chainlegs

/datum/supply_pack/armor/steel/chainkilt_steel
	name = "Steel Chain Kilt"
	cost = 80
	contains = /obj/item/clothing/pants/chainlegs/kilt

// BOOTS

/datum/supply_pack/armor/steel/steel_boots
	name = "Plate Boots"
	cost = 80
	contains = /obj/item/clothing/shoes/boots/armor

/datum/supply_pack/armor/steel/zplateboots
	name = "Zalad Plate Boots"
	cost = 80
	contains = /obj/item/clothing/shoes/boots/rare/zaladplate

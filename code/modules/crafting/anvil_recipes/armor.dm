/datum/anvil_recipe/armor
	appro_skill = /datum/attribute/skill/craft/armorsmithing
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor
	category = "Armor"

//For the sake of keeping the code modular with the introduction of new metals, each recipe has had it's main resource added to it's datum
//This way, we can avoid having to name things in strange ways and can simply have iron/cuirass, stee/cuirass, blacksteel/cuirass->
//-> and not messy names like ibreastplate and hplate

// when you add a new armor make sure to clasify it.
// if you cant find it on this list . create a new one and put it down below.
/*
/datum/anvil_recipe/armor/*material*/helmet--> head slot
/datum/anvil_recipe/armor/*material*/neck --> neck slot
/datum/anvil_recipe/armor/*material*/chest--> chest , cloak and armor slots
/datum/anvil_recipe/armor/*material*/gloves--> hands slot
/datum/anvil_recipe/armor/*material*/boots--> feet slot
/datum/anvil_recipe/armor/*material*/face--> face slot
/datum/anvil_recipe/armor/*material*/wrists--> wrist slot
/datum/anvil_recipe/armor/*material*/misc--> stuff that you cant wear like horse barding
*/

// --------- COPPER -----------

/datum/anvil_recipe/armor/copper
	abstract_type = /datum/anvil_recipe/armor/copper
	craftdiff = 0 // for starters
	required_material = /obj/item/ingot/copper
///////////////////////////////////////////////

// COPPER ARMOR
/datum/anvil_recipe/armor/copper/chest/cuirass
	name = "Copper heart protector"
	created_item = /obj/item/clothing/armor/cuirass/copperchest

/datum/anvil_recipe/armor/copper/wrists/bracers
	name = "Copper bracers"
	created_item = /obj/item/clothing/wrists/bracers/copper

/datum/anvil_recipe/armor/copper/face/mask
	name = "Copper mask"
	created_item = /obj/item/clothing/face/facemask/copper
	output_amount = 2

// NECK ARMOR
/datum/anvil_recipe/armor/copper/neck/gorget
	name = "Copper neck protector"
	created_item = /obj/item/clothing/neck/gorget/copper

// HELMETS
/datum/anvil_recipe/armor/copper/helmet/cap
	name = "Lamellar cap"
	created_item = /obj/item/clothing/head/helmet/coppercap

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- BRONZE -----------
/datum/anvil_recipe/armor/bronze
	required_material = /obj/item/ingot/bronze
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/bronze
///////////////////////////////////////////////

/datum/anvil_recipe/armor/bronze/helmet/barbute
	name = "Barbute, Bronze (+1 Bronze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/helmet/heavy/bronze

/datum/anvil_recipe/armor/bronze/helmet/murmillo
	name = "Murmillo-Style Helmet, Bronze (+1 Bronze, +1 Fur)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/fur)
	created_item = /obj/item/clothing/head/helmet/bronzegladiator
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/helmet/illyria
	name = "Bascinet, Bronze (+1 Cured Leather)"
	additional_items = list( /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/helmet/bronze

/datum/anvil_recipe/armor/bronze/chest/protector
	name = "Heart Protector, Bronze (+1 Cured Leather)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/bronze/light

/datum/anvil_recipe/armor/bronze/chest/cuirass
	name = "Cuirass, Bronze (+1 Bronze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/bronze

/datum/anvil_recipe/armor/bronze/chest/halfplate
	name = "Panoply Assembly, Halved, Bronze (+2 Bronze, +1 Cured Leather, +1 Fur)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/armor/plate/full/bronze/alt
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/chest/fullplate
	name = "Panoply Assembly, Full, Bronze (+3 Bronze, +1 Cured Leather, +1 Fur)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	created_item = /obj/item/clothing/armor/plate/full/bronze
	craftdiff = 3

/datum/anvil_recipe/armor/bronze/neck/bevor
	name = "Bevor, Bronze (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/neck/bevor/bronze
	craftdiff = 2

/datum/anvil_recipe/armor/bronze/boots/greaves
	name = "Greaves, Bronze (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/bronze


/datum/anvil_recipe/armor/bronze/face/mask
	name = "Mask, Bronze (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/face/facemask/bronze

/datum/anvil_recipe/armor/bronze/face/maskclassic
	name = "Mask, Ornate, Bronze (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/face/facemask/bronze/classic

// BRONZE ARMOR

/datum/anvil_recipe/armor/bronze/chest/brigandine
	name = "Abyssal Robe (+Bronze +Cloth)"
	required_material = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine/abyssor
	craftdiff = 3

// BRONZE NECK ARMOR

/datum/anvil_recipe/armor/bronze/gorget
	name = "Bronze Gorget"
	required_material = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/gorget/hoplite
	craftdiff = 0

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- IRON -----------
/datum/anvil_recipe/armor/iron
	required_material = /obj/item/ingot/iron
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/iron
///////////////////////////////////////////////

// IRON ARMOR
/datum/anvil_recipe/armor/iron/chest/splint
	name = "Two splint Armors (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/under/splintpants
	name = "two splint trousers  (+3 cured leather)" //two items per bar since is mostly leather + iron bits, ideal for cheaper armors
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/pants/trou/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/boots/mailleboots
	name = "two chainmail boots (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/ironmaille
	output_amount = 2

/datum/anvil_recipe/armor/iron/chest/cuirass
	name = "Iron Cuirass"
	created_item = /obj/item/clothing/armor/cuirass/iron

/datum/anvil_recipe/armor/iron/under/chausses
	name = "Iron Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs/iron

/datum/anvil_recipe/armor/iron/face/platemask
	name = "Iron Face Masks"
	created_item = /obj/item/clothing/face/facemask
	output_amount = 2

// IRON CHAIN ARMOR
/datum/anvil_recipe/armor/iron/chest/chainmail
	name = "Iron Maille"
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/chest/chainkini
	name = "Iron Chainkini (+fur)"
	additional_items = list(/obj/item/natural/fur)
	created_item = /obj/item/clothing/armor/amazon_chainkini

/datum/anvil_recipe/armor/iron/chest/hauberk
	name = "Iron Hauberk (+Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/under/chainleg
	name = "Iron Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs/iron

/datum/anvil_recipe/armor/iron/under/chainkilt
	name = "Iron Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt/iron

/datum/anvil_recipe/armor/iron/gloves/chainglove
	name = "Iron Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron
	output_amount = 2

/datum/anvil_recipe/armor/iron/chest/chest/scaledcloak
	name = "Scaled Cloak (+Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/cloak/scaledcloak
	output_amount = 2

// IRON NECK ARMOR
/datum/anvil_recipe/armor/iron/neck/gorget
	name = "Iron Gorget"
	created_item = /obj/item/clothing/neck/gorget

/datum/anvil_recipe/armor/iron/neck/chaincoif
	name = "Iron Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif/iron

/datum/anvil_recipe/armor/iron/neck/highcollier
	name = "Iron High Collier"
	created_item = /obj/item/clothing/neck/highcollier/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/neck/highcollier_renegade
	name = "Iron Renegade Collar (+Hide)"
	additional_items = list(/obj/item/natural/hide)
	created_item = /obj/item/clothing/neck/highcollier/iron/renegadecollar
	craftdiff = 1

/datum/anvil_recipe/armor/iron/gloves/chainglove
	name = "Iron Chain Gauntlets"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/gloves/chain/iron
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/armor/iron/gloves/igauntlets
	name = "Iron Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/iron

/datum/anvil_recipe/armor/iron/wrists/ijackchain
	name = "Iron Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/ironjackchain
	output_amount = 2

/datum/anvil_recipe/armor/iron/wrists/ibracers
	name = "Iron Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers/iron

/datum/anvil_recipe/armor/iron/chest/chainmail
	name = "Iron Haubergeon"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/chest/hauberk
	name = "Hauberk (+Iron)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/chest/cuirass
	name = "Iron Cuirass"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/cuirass/iron
	craftdiff = 0

/datum/anvil_recipe/armor/iron/chest/platefull
	name = "Iron Plate Armor (+Iron x3)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/chest/platefull_shadow
	name = "Iron Plate Shadow Armor (+iron x3)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/cuirass/iron/shadowplate
	craftdiff = 2

/datum/anvil_recipe/armor/iron/chest/halfplate
	name = "Iron Half-plate (+2 Iron)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/platehelmet
	name = "Iron Plate Helmet (+Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/barred_helmet
	name = "Barred Helmet (+Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/townwatch/gatemaster
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/winged_helmet
	name = "Winged Helmet"
	created_item = /obj/item/clothing/head/helmet/winged
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/horned_helmet
	name = "Horned Helmet"
	created_item = /obj/item/clothing/head/helmet/horned
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmet/bastion_helm
	name = "Bastion helm (+2 Iron)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/necked
	craftdiff = 2

/datum/anvil_recipe/armor/steel/helmet/pegasusknighthelm
	name = "Coifed Helmet (+Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/pegasusknight
	craftdiff = 2

/datum/anvil_recipe/armor/steel/helmet/crusader_helm
	name = "Crusader helm (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader
	craftdiff = 2

/datum/anvil_recipe/armor/steel/helmet/totod_crusader_helm
	name = "Totod Crusader helm (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader/t
	craftdiff = 2

/datum/anvil_recipe/armor/steel/helmet/skullmet_helm
	name = "Skullmet helm (+2 Bones)"
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/rousskull_helm

	name = "Rous Skull helm (+2 Bones)"
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/rousskullmet
	craftdiff = 3

/datum/anvil_recipe/armor/iron/helmet/cage_helmet
	name = "feldsher's cage"
	created_item = /obj/item/clothing/head/helmet/feld
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/pothelmet
	name = "Pot Helmet"
	created_item = /obj/item/clothing/head/helmet/ironpot

/datum/anvil_recipe/armor/iron/helmet/lakkariancap
	name = "Crowned Cap (+1 Gold)"
	created_item = /obj/item/clothing/head/helmet/ironpot/lakkariancap
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/iron/helmet/nasal_helmet
	name = "Nasal helmet"
	created_item = /obj/item/clothing/head/helmet/nasal

/datum/anvil_recipe/armor/iron/helmet/skullcap
	name = "x2 Skullcap"
	created_item = /obj/item/clothing/head/helmet/skullcap
	output_amount = 2

/datum/anvil_recipe/armor/iron/helmet/helmetkettle
	name = "Iron Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/iron
	output_amount = 2

/datum/anvil_recipe/armor/iron/helmet/helmetslitkettle
	name = "Slitted Iron Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/slit/iron

/datum/anvil_recipe/armor/iron/helmet/helmetsall
	name = "Iron Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet/iron

/datum/anvil_recipe/armor/iron/helmet/helmetsallv
	name = "Visored Iron Sallet (+1 Iron)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/sallet/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmet/eoran_sallet
	name = "Eoran Sallet (+1 Iron)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/sallet/eoran
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmet/helmetknight
	name = "Iron Knight's helmet (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = (/obj/item/clothing/head/helmet/visored/knight/iron)
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmet/owlhelmet
	name = "strigidae armet (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/knight/owl
	craftdiff = 2

// IRON PLATE ARMOR
/datum/anvil_recipe/armor/iron/chest/halfplate
	name = "Iron Half-plate (+2 Iron)"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron

/datum/anvil_recipe/armor/iron/chest/platefull
	name = "Iron Plate Armor (+2 Iron)"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmet/platehelmet
	name = "Iron Plate Helmet (+2 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 2
/datum/anvil_recipe/armor/iron/neck/bevor
	name = "Iron Bevor"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/bevor/iron

/datum/anvil_recipe/armor/iron/boots/platebootlight
	name = "Light Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/light

/datum/anvil_recipe/armor/iron/helmet/town_watch_helmet
	name = "Town Watch helmet"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/town_watch_helmet_alt
	name = "Town Watch helmet (alt)"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch/alt
	craftdiff = 1

/datum/anvil_recipe/armor/iron/helmet/skullcap
	name = "Skullcap"
	created_item = /obj/item/clothing/head/helmet/skullcap

/datum/anvil_recipe/armor/iron/helmet/grenzelhoft_skullcap
	name = "Grenzelhoft Plume helmet"
	additional_items = list(/obj/item/natural/feather)
	created_item = /obj/item/clothing/head/helmet/skullcap/grenzelhoft

/datum/anvil_recipe/armor/iron/chest/splint
	name = "Two splint Armors (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/chest/light_brigandine
	name = "Lightweight Brigandine (+cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine/light

///////////////////////////////////////////////
// --------- STEEL -----------
/datum/anvil_recipe/armor/steel
	required_material = /obj/item/ingot/steel
	abstract_type = /datum/anvil_recipe/armor/steel
	craftdiff = 2

///////////////////////////////////////////////

// STEEL ARMOR
/datum/anvil_recipe/armor/steel/wrists/jackchain
	name = "Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/jackchain
	output_amount = 2

/datum/anvil_recipe/armor/steel/chest/flutedhauberk
	name = "fluted hauberk (+1 Hauberk + 1 Steel)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/clothing/armor/chainmail/hauberk, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/fluted
	craftdiff = 3

/datum/anvil_recipe/armor/steel/face/platemask
	name = "Steel Mask"
	created_item = /obj/item/clothing/face/facemask/steel
	output_amount = 2

/datum/anvil_recipe/armor/steel/face/steppemask
	name = "Steppe War Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppe
	output_amount = 2

/datum/anvil_recipe/armor/steel/face/maskbeast
	name = "Steppe Beast Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppebeast
	output_amount = 2

/datum/anvil_recipe/armor/steel/helmet/cuirass
	name = "Steel Cuirass"
	created_item = /obj/item/clothing/armor/cuirass

/datum/anvil_recipe/armor/steel/helmet/brigadine
	name = "Brigandine (+Bar x2, +Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/helmetbuc
	name = "Great Helm"
	required_material = /obj/item/ingot/steel
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)

/datum/anvil_recipe/armor/steel/helmet/keeperbucket
	name = "Keeper's Helm"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/natural/cloth)
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket/keeper)

/datum/anvil_recipe/armor/iron/gloves/shadow_plate_gauntlets
	name = "Shadow Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
	craftdiff = 3

/datum/anvil_recipe/armor/steel/under/chainleg
	name = "Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs

/datum/anvil_recipe/armor/steel/under/chainkilt_steel
	name = "Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt

/datum/anvil_recipe/armor/steel/chest/haubergeon
	name = "Haubergeon"
	created_item = /obj/item/clothing/armor/chainmail

/datum/anvil_recipe/armor/steel/gloves/chainglove
	name = "Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain
	output_amount = 2

/datum/anvil_recipe/armor/steel/chest/hauberk
	name = "Hauberk (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk
	craftdiff = 3

/datum/anvil_recipe/armor/steel/chest/scalemail
	name = "Scalemail (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/scale
	craftdiff = 3

/datum/anvil_recipe/armor/steel/chest/scalemail/steppe
	name = "Lamellar Armor (+Bar, +cured hide)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/medium/scale/steppe
	craftdiff = 3

/datum/anvil_recipe/armor/steel/chest/surcoat
	name = "Armored Surcoat (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat
	craftdiff = 3

/datum/anvil_recipe/armor/steel/chest/surcoat/heartfelt
	name = "Armored Heartfelt Surcoat (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat/heartfelt
	craftdiff = 4

// STEEL NECK ARMOR
/datum/anvil_recipe/armor/steel/neck/bevor
	name = "Bevor"
	created_item = /obj/item/clothing/neck/bevor

/datum/anvil_recipe/armor/steel/neck/chaincoif
	name = "Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif

/datum/anvil_recipe/armor/steel/neck/highcolleir
	name = "High Collier"
	created_item = /obj/item/clothing/neck/highcollier
	craftdiff = 3

// STEEL HELMETS

/datum/anvil_recipe/armor/steel/helmet/nasal_helmet
	name = "Nasal helmet"
	created_item = /obj/item/clothing/head/helmet/nasal
	craftdiff = 1
	output_amount = 2

/datum/anvil_recipe/armor/steel/helmet/gallowglass
	name = "Gallowglass Helmet"
	created_item = /obj/item/clothing/head/helmet/gallowglass
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmet/coppergate
	name = "Coppergate helmet"
	created_item = /obj/item/clothing/head/helmet/coppergate
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmet/helmetbuc
	name = "Great Helm"
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)

/datum/anvil_recipe/armor/steel/helmet/helmetkettle
	name = "Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle
	output_amount = 2

/datum/anvil_recipe/armor/steel/helmet/helmetslitkettle
	name = "Slitted Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/slit

/datum/anvil_recipe/armor/steel/helmet/froghelmet
	name = "Frog Helmet"
	created_item = (/obj/item/clothing/head/helmet/heavy/frog)

/datum/anvil_recipe/armor/steel/helmet/helmetsall
	name = "Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet

/datum/anvil_recipe/armor/steel/helmet/elven_sallet
	name = "Elven Guardian Sallet (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/sallet/elven

/datum/anvil_recipe/armor/steel/chest/elven_cuirass
	name = "Elven Guardian Cuirass (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/armor/cuirass/rare/elven

/datum/anvil_recipe/armor/steel/helmet/helmetsall_zalad
	name = "Kulah Khud"
	created_item = /obj/item/clothing/head/helmet/sallet/zalad

/datum/anvil_recipe/armor/steel/helmet/bascinet
	name = "Bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet

/datum/anvil_recipe/armor/steel/helmet/bascinet/steppe
	name = "Steppe Bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet/steppe

/datum/anvil_recipe/armor/steel/helmet/spangenhelm
	name = "Spangenhelm"
	created_item = /obj/item/clothing/head/helmet/heavy/viking
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/xylixhelm
	name = "xylixian helmet (+1 Coin)"
	additional_items = list(/obj/item/coin)
	created_item = /obj/item/clothing/head/helmet/heavy/xylixhelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/astratahelm
	name = "astrata helmet (+1 Gold)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/heavy/astratahelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/nochelm
	name = "noc helmet (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/head/helmet/heavy/nochelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/necrahelm
	name = "necra helmet (+1 Tallow)"
	additional_items = list(/obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/head/helmet/heavy/necrahelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/dendorhelm
	name = "dendor helmet (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/clothing/head/helmet/heavy/dendorhelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/abyssorgreathelm
	name = "abyssorite helmet (+1 Bronze)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/abyssorgreathelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/ravoxhelm
	name = "justice eagle (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/ravoxhelm
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/helmetknight
	name = "Knight's helmet (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/knight)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/helmetsallv
	name = "Visored sallet (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/sallet)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmet/bellow
	name = "Bellow Sallet (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/bellow)
	craftdiff = 4

/datum/anvil_recipe/armor/steel/helmet/hounskull
	name = "Hounskull Helmet (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/hounskull)
	craftdiff = 4

/datum/anvil_recipe/armor/steel/helmet/volfplate
	name = "volf-face helm(+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate

/datum/anvil_recipe/armor/steel/misc/barding
	name = "Saiga Barding, Chainmail (+1 Steel)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/chain

/datum/anvil_recipe/armor/steel/misc/barding/honse
	name = "Honse Barding, Chainmail (+1 Steel)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/honse/chain

/datum/anvil_recipe/armor/steel/helmet/royal_knight_helm
	name = "Royal Knight Helmet (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/royalknight)
	craftdiff = 6

// STEEL DECORATED HELMS
/datum/anvil_recipe/armor/steel/helmet/decoratedbascinet
	name = "Decorated Bascinet (+Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/bascinet

/datum/anvil_recipe/armor/steel/helmet/decorativecoppergate
	name = "Decorated Coppergate helmet (+Gold)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/decorativecoppergate
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmet/decoratedhelmetbucgold
	name = "Decorated Gold-trimmed Great Helm (+Gold Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/gold,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/golden

/datum/anvil_recipe/armor/steel/helmet/decoratedhelmetknight
	name = "Decorated Knight's Helmet (+Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/knight
	craftdiff = 4

/datum/anvil_recipe/armor/steel/helmet/buckethelm
	name = "Decorated Great Helm (+Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/bucket
	craftdiff = 4

/datum/anvil_recipe/armor/steel/helmet/decoratedhelmetpig
	name = "Decorated Hounskull Helmet (+Bar x2, +Cloth)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/hounskull
	craftdiff = 4

/datum/anvil_recipe/armor/steel/chest/halfplate_decrorated
	name = "Decorated Half-plate (+Steel Bar x2, + Gold Bar)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold)
	created_item = /obj/item/clothing/armor/plate/decorated
	craftdiff = 4

/datum/anvil_recipe/armor/steel/chest/halfplate_decrorated_corset
	name = "Decorated Half-plate With Corset (+Steel Bar x2, + Gold Bar, + Silk x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/armor/plate/decorated/corset
	craftdiff = 4

// STEEL PLATE ARMOR
/datum/anvil_recipe/armor/steel/chest/halfplate
	name = "Steel Half-plate (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate
	craftdiff = 3

/datum/anvil_recipe/armor/steel/chest/platefull
	name = "Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full
	craftdiff = 4

/datum/anvil_recipe/armor/steel/wrists/platebracer
	name = "Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers
	craftdiff = 4

/datum/anvil_recipe/armor/steel/under/plateleg
	name = "Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs
	craftdiff = 4

/datum/anvil_recipe/armor/steel/gloves/plateglove
	name = "Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate
	craftdiff = 4

/datum/anvil_recipe/armor/steel/boots/plateboot
	name = "Plated boots"
	created_item = /obj/item/clothing/shoes/boots/armor
	craftdiff = 4

////---------RARE STEEL-------------///
/datum/anvil_recipe/armor/steel/rare
	craftdiff = 6
	abstract_type = /datum/anvil_recipe/armor/steel/rare
	required_material = /obj/item/ingot/steel

/// DWARVEN SET//
/datum/anvil_recipe/armor/steel/rare/helmet/dwarf_plate_helm
	name = "Dwarven Plate Helm (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/dwarven

/datum/anvil_recipe/armor/steel/rare/chest/dwarf_plate_torso
	name = "Dwarven Plate (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/dwarven

/datum/anvil_recipe/armor/steel/rare/boots/dwarf_plate_boots
	name = "Dwarven Plate Boots (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/shoes/boots/armor/dwarven

/datum/anvil_recipe/armor/steel/rare/gloves/dwarf_plate_gauntlets
	name = "Dwarven Plate Gauntlets (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/gloves/plate/dwarven

/// GRENZEL SET///
/datum/anvil_recipe/armor/steel/rare/gloves/grenzel_plate_gauntlets
	name = "Grenzel Plate Gauntlets (+1 Steel)"
	created_item = /obj/item/clothing/gloves/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/chest/grenzel_plate
	name = "Grenzel Plate (+3 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/boots/grenzel_plate_boots
	name = "Grenzel Plate Boots (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/shoes/boots/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/helmet/grenzel_plate_helm
	name = "Grenzel Chicklet Plate Helm (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/grenzelplate

/// ZALADIN SET ///
/datum/anvil_recipe/armor/steel/rare/helmet/zaladin_plate_helm
	name = "Zaladin Bastion Plate Helm (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/gloves/zaladin_plate_gauntlets
	name = "Zaladin Claw Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/boots/zaladin_plate_boots
	name = "Zaladin Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/chest/zaladin_plate
	name = "Zaladin Kataphractoe Scaleskin (+Bar X3)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/rare/zaladplate

/// HOPLITE ///
/datum/anvil_recipe/armor/steel/rare/chest/hoplite_plate
	name = "Hoplite Plate (+2 Steel +2 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/armor/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/helmet/hoplite_plate_helm
	name = "Hoplite Plate Helm (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/wrists/hoplite_plate_bracers
	name = "Hoplite Bracers (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/wrists/bracers/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/boots/hoplite_plate_boots
	name = "Hoplite Sandals (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/shoes/rare/hoplite

/// BLADESINGER ///
/datum/anvil_recipe/armor/steel/rare/boots/elven_plate_boots
	name = "Elven Plate Boots (+1 Black Steel)"
	created_item = /obj/item/clothing/shoes/boots/rare/elfplate

/datum/anvil_recipe/armor/steel/rare/helmet/elven_helm
	name = "Elven Plate Helmet (+1 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/rare/elfplate

/datum/anvil_recipe/armor/steel/rare/gloves/elven_plate_gloves
	name = "Elven Plate Gauntlets (+1 Black Steel)"
	created_item = /obj/item/clothing/gloves/rare/elfplate

/datum/anvil_recipe/armor/steel/rare/chest/elven_plate_chest
	name = "Elven Plate Armor (+3 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/rare/elfplate

/// DROW PLATE ///
/datum/anvil_recipe/armor/steel/rare/boots/dark_elven_plate_boots
	name = "Dark Elven Plate Boots (+1 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/shoes/boots/rare/elfplate/welfplate

/datum/anvil_recipe/armor/steel/rare/helmet/dark_elven_helm
	name = "Dark Elven Plate Helmet (+1 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/rare/elfplate/welfplate

/datum/anvil_recipe/armor/steel/rare/gloves/dark_elven_plate_gloves
	name = "Dark Elven Plate Gauntlets (+1 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/gloves/rare/elfplate/welfplate

/datum/anvil_recipe/armor/steel/rare/chest/dark_elven_plate_chest
	name = "Dark Elven Plate Armor (+3 Black Steel)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/rare/elfplate/welfplate

/// ATERGVI PLATE ///

/datum/anvil_recipe/armor/steel/rare/chest/atgervi_hauberk
	name = "vagarian hauberk(+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/atgervi

/datum/anvil_recipe/armor/steel/rare/gloves/atgervi_claws
	name = "beast claws(+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/gloves/plate/atgervi

/datum/anvil_recipe/armor/steel/rare/helmet/atgervi_helmet
	name = "owl helmet(+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/bascinet/atgervi


//////////////////////////////////////////////////////////////////////////////////////////////
// --------- SILVER -----------
/datum/anvil_recipe/armor/silver
	required_material = /obj/item/ingot/silver
	craftdiff = 3 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/silver
///////////////////////////////////////////////

// --------- SILVER -----------
/datum/anvil_recipe/armor/silver/helmet/bascinet
	name = "Silver Bascinet (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/silver

/datum/anvil_recipe/armor/silver/helmet/armet
	name = "Silver Armet (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/silver/armet

/datum/anvil_recipe/armor/silver/under/plateleg
	name = "Silver Plate Chausses (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/silver

/datum/anvil_recipe/armor/silver/chest/platefull
	name = "Silver Plate Armor (+Silver Bar, +Steel Bar x3)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/silver
	craftdiff = 4

/datum/anvil_recipe/armor/silver/chest/halfplate
	name = "Silver Half Plate Armor (+Silver Bar, +Steel Bar)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/silver
	craftdiff = 4

/datum/anvil_recipe/armor/silver/gloves/gauntlets
	name = "Silver Gauntlets"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/gloves/plate/silver
	craftdiff = 4

/datum/anvil_recipe/armor/silver/boots/silver_boots
	name = "Silver Boots"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/shoes/boots/armor/silver
	craftdiff = 4

// --------- BLACKSTEEL -----------
/datum/anvil_recipe/armor/blacksteel
	required_material = /obj/item/ingot/blacksteel
	craftdiff = 4 // this is the good stuff
	abstract_type = /datum/anvil_recipe/armor/blacksteel
///////////////////////////////////////////////

// BLACKSTEEL ARMOR //

/datum/anvil_recipe/armor/blacksteel/helmet/volfplate_beast
	name = "volfskulle bascinet(+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate/beast

/datum/anvil_recipe/armor/blacksteel/chest/grenzel_cuirass
	name = "Grenzelhoft Cuirass (+Steel Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/cuirass/grenzelhoft

/datum/anvil_recipe/armor/blacksteel/chest/platechest
	name = "Blacksteel Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/plate/blkknight
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/under/platelegs
	name = "Blacksteel Plate Chausses (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/pants/platelegs/blk
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "Blacksteel Great Helm (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/blacksteel/bucket
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/gloves/plategloves
	name = "Blacksteel Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/blk
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/boots/plateboots
	name = "Blacksteel Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/blkknight
	craftdiff = 5

// --------- DARKSTEEL -----------
/datum/anvil_recipe/armor/darksteel
	required_material = /obj/item/ingot/darksteel
	craftdiff = 5 // the unholy stuff
	abstract_type = /datum/anvil_recipe/armor/darksteel
///////////////////////////////////////////////

///--------ZIZO-----------///
/datum/anvil_recipe/armor/darksteel/under/zizo_plate_pants
	name = "Darksteel Plate Chausses (+1 Darksteel)"
	additional_items = list(/obj/item/ingot/darksteel)
	created_item = /obj/item/clothing/pants/platelegs/zizo

/datum/anvil_recipe/armor/darksteel/gloves/zizo_plate_gloves
	name = "Darksteel Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/zizo

/datum/anvil_recipe/armor/darksteel/boots/zizo_plate_boots
	name = "Darksteel Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/zizo

/datum/anvil_recipe/armor/darksteel/helmet/zizo_helm_visor
	name = "Darksteel Barbute (+1 Darksteel)"
	additional_items = list(/obj/item/ingot/darksteel)
	created_item = /obj/item/clothing/head/helmet/visored/zizo

/datum/anvil_recipe/armor/darksteel/helmet/zizo_helm
	name = "Darksteel Frog Helm (+1 Darksteel)"
	additional_items = list(/obj/item/ingot/darksteel)
	created_item = /obj/item/clothing/head/helmet/heavy/zizo

/datum/anvil_recipe/armor/darksteel/chest/zizo_plate
	name = "Darksteel Plate Armor (+3 Darksteel)"
	additional_items = list(/obj/item/ingot/darksteel, /obj/item/ingot/darksteel, /obj/item/ingot/darksteel)
	created_item = /obj/item/clothing/armor/plate/full/zizo

//-------MATTHIOS---------------///
/datum/anvil_recipe/armor/darksteel/helmet/matthios_helm
	name = "Gilded Visage (+1 gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/heavy/matthios

/datum/anvil_recipe/armor/steel/boots/matthios_plate_boots
	name = "Matthiosan Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/matthios

/datum/anvil_recipe/armor/steel/under/matthios_plate_pants
	name = "Matthiosan Plate Chausses (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/matthios

/datum/anvil_recipe/armor/steel/chest/matthios_plate
	name = "Matthiosan Plate Armor (+3 Steel)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/matthios

/datum/anvil_recipe/armor/steel/gloves/matthios_plate_gauntlets
	name = "Matthiosan Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/matthios

//--------GRAGGAR---------------///
/datum/anvil_recipe/armor/blacksteel/helmet/graggar_helm
	name = "Vicious Helmet (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/graggar

/datum/anvil_recipe/armor/darksteel/helmet/sinistar
	name = "Sinistar Helmet (+1 Steel)"
	created_item = /obj/item/clothing/head/helmet/heavy/sinistar
	additional_items = list(/obj/item/ingot/steel)

/datum/anvil_recipe/armor/steel/chest/graggar_plate
	name = "Graggarite Plate Armor (+3 Steel)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/graggar

/datum/anvil_recipe/armor/steel/boots/graggar_plate_boots
	name = "Graggarite Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/graggar

/datum/anvil_recipe/armor/steel/gloves/graggar_plate_gauntlets
	name = "Graggarite Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/graggar

/datum/anvil_recipe/armor/steel/under/graggarite_plate_pants
	name = "Graggarite Plate Chausses (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/graggar

///---------BLESSED SILVER---------------///
/datum/anvil_recipe/armor/blessedsilver
	required_material = /obj/item/ingot/silverblessed
	abstract_type = /datum/anvil_recipe/armor/blessedsilver
	craftdiff = 4

///////////////////////////////////////

/datum/anvil_recipe/armor/blessedsilver/helmet/psythorns
	name = "crown of psydonian thorns(+1 Blacksteel)"
	additional_items = list(/datum/anvil_recipe/armor/blacksteel)
	created_item = /obj/item/clothing/head/helmet/blacksteel/psythorns

/datum/anvil_recipe/armor/blessedsilver/chest/psychestplate
	name = "Psydonic Chestplate (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/psydon

/datum/anvil_recipe/armor/blessedsilver/chest/psycuirass
	name = "Psydonic Cuirass (+2 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/ornate

/datum/anvil_recipe/armor/blessedsilver/helmet/armetpsy
	name = "Psydonic Armet"
	created_item = /obj/item/clothing/head/helmet/heavy/psydonhelm

/datum/anvil_recipe/armor/blessedsilver/helmet/helmsallpsy
	name = "Psydonic Sallet (+1 Blessed Silver)"
	created_item = /obj/item/clothing/head/helmet/heavy/psysallet

/datum/anvil_recipe/armor/blessedsilver/helmet/helmbucketpsy
	name = "Psydonic Bucket Helm (+1 Blessed Silver)"
	created_item = /obj/item/clothing/head/helmet/heavy/psybucket

/datum/anvil_recipe/armor/blessedsilver/helmet/helmetabso
	name = "Psydonian Conical Helm (+2 Blessed Silver)"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/helmet/heavy/absolver

/datum/anvil_recipe/armor/blessedsilver/chest/psyhalfplate
	name = "Psydonic Half-Plate (+Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	additional_items = list(/obj/item/clothing/armor/cuirass/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/chest/psyfullplate
	name = "Psydonic Full-Plate (+Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	additional_items = list(/obj/item/clothing/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/chest/psyfullplatealt
	name = "Psydonic Full-Plate, Hauberked (+Psydonic Hauberk, +2 Blessed Silver, +2 Cured Leather)"
	additional_items = list(/obj/item/clothing/armor/chainmail/hauberk/fluted, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/gloves/psydonmask
	name = "Psydonic Mask"
	created_item = /obj/item/clothing/face/facemask/psydonmask

/datum/anvil_recipe/armor/blessedsilver/gloves/psydonic_gloves
	name = "Psydonic Chain Gloves"
	created_item = /obj/item/clothing/gloves/chain/psydon

///----------GOLD-------------///
/datum/anvil_recipe/armor/gold
	required_material = /obj/item/ingot/gold
	craftdiff = 5 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/gold

///////////////////////////////

/datum/anvil_recipe/armor/gold/face/mask
	name = "Gold Mask"
	created_item = /obj/item/clothing/face/facemask/goldmask

/datum/anvil_recipe/armor/gold/boots/anklets
	name = "golden anklets"
	created_item = /obj/item/clothing/shoes/anklets

/datum/anvil_recipe/armor/gold/helmet/buckethelm
	name = "Gold Helmet (+1 Bucket helm)"
	additional_items = list(/obj/item/clothing/head/helmet/heavy/bucket)
	created_item = /obj/item/clothing/head/helmet/heavy/bucket/gold

/datum/anvil_recipe/armor/gold/helmet/armet
	name = "Golden Knight's Armet (1+ knight helmet, +1 Gold, +2 Silk)"
	additional_items = list(/obj/item/clothing/head/helmet/visored/knight, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/head/helmet/visored/gold

/datum/anvil_recipe/armor/gold/helmet/armetcrown
	name = "Golden Royal Armet (1+ Steel knight helmet, +1 Gold, +2 Silk, +1 Dorpel)"
	additional_items = list(/obj/item/clothing/head/helmet/visored/knight, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/gem/diamond)
	created_item = /obj/item/clothing/head/helmet/visored/gold/king

/datum/anvil_recipe/armor/gold/neck/gorget
	name = "Golden Gorget (+1 Gorget, +2 Silk)"
	additional_items = list(/obj/item/clothing/neck/gorget, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/neck/gorget/gold

/datum/anvil_recipe/armor/gold/chest/cuirass
	name = "Golden Cuirass (+1 Steel Cuirass, +1 Gold , +2 Silk)"
	additional_items = list(/obj/item/clothing/armor/cuirass, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/armor/cuirass/fluted/gold

/datum/anvil_recipe/armor/gold/chest/cuirasshero
	name = "Golden Heroic Cuirass (+1 Steel Cuirass, +2 Gold, +2 Silk, +1 Tallow)"
	additional_items = list(/obj/item/clothing/armor/cuirass, /obj/item/ingot/gold, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/armor/cuirass/fluted/gold/heroic

/datum/anvil_recipe/armor/gold/under/greaves
	name = "Golden Greaves (+1 Steel plated boots +1 Gold, +2 Silk)"
	additional_items = list(/obj/item/clothing/shoes/boots/armor, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/shoes/boots/armor/gold

/datum/anvil_recipe/armor/gold/face/naledi_mask
	name = "war scholar's mask"
	created_item = /obj/item/clothing/face/lordmask/naledi

/datum/anvil_recipe/armor/gold/face/sojourner_mask
	name = "sojourner's mask(+1 Gold)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/face/lordmask/naledi/sojourner

///-----------HOLY STEEL---------------///
/datum/anvil_recipe/armor/holysteel
	required_material = /obj/item/ingot/steelholy
	craftdiff = 4
	abstract_type = /datum/anvil_recipe/armor/holysteel

/////////////////////////////////

/datum/anvil_recipe/armor/holysteel/helmet/undividedtemplar_sallet
	name = "Undivided Templar's Sallet (+1 Holy Steel, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/helmet/heavy/undivided

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_noc
	name = "Noc Helmet (+1 Silver)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/noc
	additional_items = list(/obj/item/ingot/silver)

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_astrata
	name = "Astratan Helmet (+1 Gold)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/astrata
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_necra
	name = "Necran Helmet (+1 Tallow)"
	additional_items = list(/obj/item/reagent_containers/food/snacks/tallow)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/necra

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_dendor
	name = "Dendor Helmet (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_pestra
	name = "Pestran Helmet (+1 needle)"
	additional_items = list(/obj/item/needle)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_malum
	name = "Malum Helmet (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/malumhelm

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_ravox
	name = "Ravox Helmet (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/ravox

/datum/anvil_recipe/armor/holyssteel/templar/helmet/helmet_xylix
	name = "Xylix Helmet (+1 Coin)"
	additional_items = list(/obj/item/coin)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/xylix

/datum/anvil_recipe/armor/holysteel/templar/helmet/helmet_abyssor
	name = "Abyssor Helmet (+1 Bronze)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/abyssor

/datum/anvil_recipe/armor/bronze/helmet/abyssor_deep
	name = "Deep Abyssor Helmet (+2 Bronze)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/deepabyssor

/datum/anvil_recipe/armor/holysteel/chest/holysee_plate
	name = "holy silver plate(+3 Silver)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver)
	created_item = /obj/item/clothing/armor/plate/full/holysee
	craftdiff = 4

/datum/anvil_recipe/armor/holysteel/under/holysee_chausses
	name = "holy silver chausses(+1 Silver)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/pants/platelegs/holysee
	craftdiff = 3

/datum/anvil_recipe/armor/holysteel/helmet/holysee_bascinet
	name = "holy silver bascinet(+1 Silver)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/head/helmet/heavy/holysee
	craftdiff = 3

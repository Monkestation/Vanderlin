/datum/anvil_recipe/armor
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor
	category = "Armor"

//For the sake of keeping the code modular with the introduction of new metals, each recipe has had it's main resource added to it's datum
//This way, we can avoid having to name things in strange ways and can simply have iron/cuirass, stee/cuirass, blacksteel/cuirass->
//-> and not messy names like ibreastplate and hplate

// --------- COPPER -----------

/datum/anvil_recipe/armor/copper
	abstract_type = /datum/anvil_recipe/armor/copper
	craftdiff = 0 // for starters
	req_bar = /obj/item/ingot/copper
///////////////////////////////////////////////

// COPPER ARMOR
/datum/anvil_recipe/armor/copper/cuirass
	name = "Copper heart protector"
	recipe_name = "a simple armor piece for the chest"
	created_item = /obj/item/clothing/armor/cuirass/copperchest

/datum/anvil_recipe/armor/copper/bracers
	name = "Copper bracers"
	recipe_name = "a pair of Copper bracers"
	created_item = /obj/item/clothing/wrists/bracers/copper

/datum/anvil_recipe/armor/copper/mask
	name = "Copper mask"
	recipe_name = "a mask of copper"
	created_item = /obj/item/clothing/face/facemask/copper

// NECK ARMOR
/datum/anvil_recipe/armor/copper/gorget
	name = "Copper neck protector"
	recipe_name = "a neck protector"
	created_item = /obj/item/clothing/neck/gorget/copper

// HELMETS
/datum/anvil_recipe/armor/copper/cap
	name = "Lamellar cap"
	recipe_name = "a copper cap"
	created_item = /obj/item/clothing/head/helmet/coppercap

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- BRONZE -----------
/datum/anvil_recipe/armor/bronze
	req_bar = /obj/item/ingot/bronze
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/bronze
///////////////////////////////////////////////

// BRONZE ARMOR

/datum/anvil_recipe/armor/bronze/brigandine
	name = "Abyssal Robe (+Bronze Bar, +Cloth)"
	recipe_name = "an abyssal robe"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine/abyssor
	craftdiff = 3

// BRONZE NECK ARMOR

/datum/anvil_recipe/armor/bronze/gorget
	name = "Bronze Gorget"
	recipe_name = "a bronze gorget"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/gorget/hoplite
	craftdiff = 0


// BRONZE HELMET

/datum/anvil_recipe/armor/bronze/helmet
	name = "Abyssor Helmet (+Bronze Bar)"
	recipe_name = "an abyssor helmet"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/abyssor
	craftdiff = 3

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- IRON -----------
/datum/anvil_recipe/armor/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/iron
///////////////////////////////////////////////

// IRON ARMOR
/datum/anvil_recipe/armor/iron/splint
	name = "Two splint Armors (+2 cured leather)"
	recipe_name = "durable light armor"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	createditem_extra = 1

/datum/anvil_recipe/armor/iron/splintpants
	name = "two splint trousers  (+3 cured leather)" //two items per bar since is mostly leather + iron bits, ideal for cheaper armors
	recipe_name = "durable light armor"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/pants/trou/leather/splint
	createditem_extra = 1

/datum/anvil_recipe/armor/iron/mailleboots
	name = "two chainmail boots (+2 cured leather)"
	recipe_name = "durable light armor"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/ironmaille
	createditem_extra = 1


/datum/anvil_recipe/armor/iron/cuirass
	name = "Iron Cuirass"
	recipe_name = "an iron cuirass"
	created_item = /obj/item/clothing/armor/cuirass/iron

/datum/anvil_recipe/armor/iron/chausses
	name = "Iron Plate Chausses"
	recipe_name = "a pair of iron Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs/iron

/datum/anvil_recipe/armor/iron/platemask
	name = "2x Iron Face Masks"
	recipe_name = "a Face Mask"
	created_item = /obj/item/clothing/face/facemask
	createditem_extra = 1
	craftdiff = 0

// IRON CHAIN ARMOR
/datum/anvil_recipe/armor/iron/chainmail
	name = "Iron Maille"
	recipe_name = "an iron maille shirt"
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/chainkini
	name = "Iron Chainkini (+fur)"
	recipe_name = "Fur skirt and maille chest holder"
	additional_items = list(/obj/item/natural/fur)
	created_item = /obj/item/clothing/armor/amazon_chainkini

/datum/anvil_recipe/armor/iron/hauberk
	name = "Iron Hauberk (+Bar)"
	recipe_name = "a Hauberk"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/chainleg
	name = "Iron Chain Chausses"
	recipe_name = "a pair of Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs/iron

/datum/anvil_recipe/armor/iron/chainkilt
	name = "Iron Chain Kilt"
	recipe_name = "a short Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt/iron

/datum/anvil_recipe/armor/iron/chainglove
	name = "2x Iron Chain Gauntlets"
	recipe_name = "two pairs of Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron
	createditem_extra = 1

// IRON NECK ARMOR
/datum/anvil_recipe/armor/iron/gorget
	name = "Iron Gorget"
	recipe_name = "a gorget"
	created_item = /obj/item/clothing/neck/gorget

/datum/anvil_recipe/armor/iron/chaincoif
	name = "Iron Chain Coif"
	recipe_name = "a Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif/iron

/datum/anvil_recipe/armor/iron/highcollier
	name = "Iron High Collier"
	recipe_name = "a High Collier"
	created_item = /obj/item/clothing/neck/highcollier/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/highcollier_renegade
	name = "Iron Renegade Collar (+Hide)"
	recipe_name = "a renegade collar"
	additional_items = list(/obj/item/natural/hide)
	created_item = /obj/item/clothing/neck/highcollier/iron/renegadecollar
	craftdiff = 1

/datum/anvil_recipe/armor/iron/chainglove
	name = "2x Iron Chain Gauntlets"
	recipe_name = "two pairs of Chain Gauntlets"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/gloves/chain/iron
	createditem_extra = 1
	craftdiff = 0

/datum/anvil_recipe/armor/iron/igauntlets
	name = "Iron Plate Gauntlets"
	recipe_name = "a pair of Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/iron

/datum/anvil_recipe/armor/iron/ijackchain
	name = "2x Iron Jack Chains"
	recipe_name = "two pairs of Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/ironjackchain
	createditem_extra = 1

/datum/anvil_recipe/armor/iron/ibracers
	name = "Iron Plate Vambraces"
	recipe_name = "a pair of Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers/iron

/datum/anvil_recipe/armor/iron/chainmail
	name = "Iron Haubergeon"
	recipe_name = "a Haubergeon"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/hauberk
	name = "Hauberk (+Bar)"
	recipe_name = "a Hauberk"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/cuirass
	name = "Iron Cuirass"
	recipe_name = "a cuirass"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/cuirass/iron
	craftdiff = 0

/datum/anvil_recipe/armor/iron/platefull
	name = "Iron Plate Armor (+Bar x3)"
	recipe_name = "a full set of Full-Plate Armor"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/platefull_shadow
	name = "Iron Plate Shadow Armor (+Bar x3)"
	recipe_name = "a full set of Full-Plate Shadow Armor"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/cuirass/iron/shadowplate
	craftdiff = 2

/datum/anvil_recipe/armor/iron/halfplate
	name = "Iron Half-plate (+Bar x2)"
	recipe_name = "a Half-Plate Armor"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/platehelmet
	name = "Iron Plate Helmet (+Bar)"
	recipe_name = "a heavy iron helmet"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 1

/datum/anvil_recipe/armor/iron/barred_helmet
	name = "Barred Helmet (+Bar)"
	recipe_name = "a heavy iron helmet"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/townwatch/gatemaster
	craftdiff = 1

/datum/anvil_recipe/armor/iron/winged_helmet
	name = "Winged Helmet"
	recipe_name = "an iron helmet"
	created_item = /obj/item/clothing/head/helmet/winged
	craftdiff = 1

/datum/anvil_recipe/armor/iron/horned_helmet
	name = "Horned Helmet"
	recipe_name = "an iron helmet"
	created_item = /obj/item/clothing/head/helmet/horned
	craftdiff = 1

/datum/anvil_recipe/armor/steel/bastion_helm
	name = "Bastion helm (+Bar X2)"
	recipe_name = "a heavy steel bastion helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/necked
	craftdiff = 2

/datum/anvil_recipe/armor/steel/pegasusknighthelm
	name = "Coifed Helmet (+Cloth)"
	recipe_name = "a pegasus knight's helmet"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/pegasusknight
	craftdiff = 2

/datum/anvil_recipe/armor/steel/crusader_helm
	name = "Crusader helm (+Bar X2)"
	recipe_name = "a heavy steel crusader helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader
	craftdiff = 2

/datum/anvil_recipe/armor/steel/totod_crusader_helm
	name = "Totod Crusader helm (+Bar X2)"
	recipe_name = "a heavy steel totod crusader helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader/t
	craftdiff = 2

/datum/anvil_recipe/armor/steel/skullmet_helm
	name = "Skullmet helm (+Bone X2)"
	recipe_name = "A creacher skull covering a steel helmet."
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	craftdiff = 3

/datum/anvil_recipe/armor/steel/rousskull_helm

	name = "Rous Skull helm (+Bone X2)"
	recipe_name = "A rous skull covering a steel helmet."
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/rousskullmet
	craftdiff = 3

/datum/anvil_recipe/armor/iron/cage_helmet
	name = "feldsher's cage"
	recipe_name = "a cage helmet"
	created_item = /obj/item/clothing/head/helmet/feld
	craftdiff = 1

/datum/anvil_recipe/armor/iron/pothelmet
	name = "Pot Helmet"
	recipe_name = "a sturdy iron helmet"
	created_item = /obj/item/clothing/head/helmet/ironpot

/datum/anvil_recipe/armor/iron/lakkariancap
	name = "Crowned Cap (+ Gold Bar)"
	recipe_name = "a sturdy lakkarian cap"
	created_item = /obj/item/clothing/head/helmet/ironpot/lakkariancap
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/iron/nasal_helmet
	name = "Nasal helmet"
	recipe_name = "a Nasal helmet"
	created_item = /obj/item/clothing/head/helmet/nasal

/datum/anvil_recipe/armor/iron/skullcap
	name = "x2 Skullcap"
	recipe_name = "Two skullcaps"
	created_item = /obj/item/clothing/head/helmet/skullcap
	createditem_extra = 1

/datum/anvil_recipe/armor/iron/helmetkettle
	name = "Iron Kettle Helmet"
	recipe_name = "a Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/iron

/datum/anvil_recipe/armor/iron/helmetslitkettle
	name = "Slitted Iron Kettle Helmet"
	recipe_name = "a slitted kettle helmets"
	created_item = /obj/item/clothing/head/helmet/kettle/slit/iron

/datum/anvil_recipe/armor/iron/helmetsall
	name = "Iron Sallet"
	recipe_name = "a Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet/iron

/datum/anvil_recipe/armor/iron/helmetsallv
	name = "Visored Iron Sallet (+Bar)"
	recipe_name = "a Visored Sallet"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/sallet/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/eoran_sallet
	name = "Eoran Sallet (+Bar)"
	recipe_name = "an Eoran Sallet"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/sallet/eoran
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmetknight
	name = "Iron Knight's helmet (+Bar)"
	recipe_name = "a Knight's Helmet"
	additional_items = list(/obj/item/ingot/iron)
	created_item = (/obj/item/clothing/head/helmet/visored/knight/iron)
	craftdiff = 2

// IRON PLATE ARMOR
/datum/anvil_recipe/armor/iron/halfplate
	name = "Iron Half-plate (+Bar x2)"
	recipe_name = "a Half-Plate Armor"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron

/datum/anvil_recipe/armor/iron/platefull
	name = "Iron Plate Armor (+Bar x3)"
	recipe_name = "a full set of Full-Plate Armor"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/platehelmet
	name = "Iron Plate Helmet (+Bar)"
	recipe_name = "a heavy iron helmet"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 2
/datum/anvil_recipe/armor/iron/bevor
	name = "Iron Bevor"
	recipe_name = "a Bevor"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/bevor/iron

/datum/anvil_recipe/armor/iron/platebootlight
	name = "Light Plate Boots"
	recipe_name = "a pair of Light Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/light

/datum/anvil_recipe/armor/iron/town_watch_helmet
	name = "Town Watch helmet"
	recipe_name = "a Town Watch helmet"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch
	craftdiff = 1

/datum/anvil_recipe/armor/iron/town_watch_helmet_alt
	name = "Town Watch helmet (alt)"
	recipe_name = "a Town Watch helmet"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch/alt
	craftdiff = 1

/datum/anvil_recipe/armor/iron/skullcap
	name = "Skullcap"
	recipe_name = "a skullcap"
	created_item = /obj/item/clothing/head/helmet/skullcap

/datum/anvil_recipe/armor/iron/grenzelhoft_skullcap
	name = "Grenzelhoft Plume helmet"
	additional_items = list(/obj/item/natural/feather)
	recipe_name = "a grenzelhoft plume helmet"
	created_item = /obj/item/clothing/head/helmet/skullcap/grenzelhoft

/datum/anvil_recipe/armor/iron/splint
	name = "Two splint Armors (+2 cured leather)"
	recipe_name = "durable light armor"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	createditem_extra = 1

///////////////////////////////////////////////
// --------- STEEL -----------
/datum/anvil_recipe/armor/steel
	req_bar = /obj/item/ingot/steel
	abstract_type = /datum/anvil_recipe/armor/steel
	craftdiff = 2
///////////////////////////////////////////////

// STEEL ARMOR
/datum/anvil_recipe/armor/steel/jackchain
	name = "2x Jack Chains"
	recipe_name = "two pairs of Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/jackchain
	createditem_extra = 1

/datum/anvil_recipe/armor/steel/platemask
	name = "Steel Mask"
	recipe_name = "a Face Mask"
	created_item = /obj/item/clothing/face/facemask/steel

/datum/anvil_recipe/armor/steel/steppemask
	name = "Steppe War Mask"
	recipe_name = "a Face Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppe

/datum/anvil_recipe/armor/steel/maskbeast
	name = "Steppe Beast Mask"
	recipe_name = "a Face Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppebeast

/datum/anvil_recipe/armor/steel/cuirass
	name = "Steel Cuirass"
	recipe_name = "a Cuirass"
	created_item = /obj/item/clothing/armor/cuirass

/datum/anvil_recipe/armor/steel/brigadine
	name = "Brigandine (+Bar x2, +Cloth)"
	recipe_name = "a Brigandine"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine
	craftdiff = 3
/*
/datum/anvil_recipe/armor/steel/brigadine
	name = "Captain's brigandine (+Bar x2, +Cloth)"
	recipe_name = "a premium Brigandine"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine/captain
	craftdiff = 6
*/

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Great Helm"
	recipe_name = "a Bucket Helmet"
	req_bar = /obj/item/ingot/steel
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)
/*
/datum/anvil_recipe/armor/steel/sinistar
	name = "Sinistar Helmet (+Steel Bar)"
	recipe_name = "a graggarite helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/sinistar
	additional_items = list(/obj/item/ingot/steel)
*/

/datum/anvil_recipe/armor/iron/shadow_plate_gauntlets
	name = "Shadow Plate Gauntlets"
	recipe_name = "a pair of Shadow Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
	craftdiff = 3

/datum/anvil_recipe/armor/steel/templar
	craftdiff = 3
	abstract_type = /datum/anvil_recipe/armor/steel/templar

/datum/anvil_recipe/armor/steel/templar/helmet_noc
	name = "Noc Helmet (+Silver Bar)"
	recipe_name = "a noc helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/noc
	additional_items = list(/obj/item/ingot/silver)

/datum/anvil_recipe/armor/steel/templar/gold_helmet
	name = "Gold Helmet (+Gold Bar)"
	recipe_name = "a golden helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/bucket/gold
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/steel/templar/helmet_astrata
	name = "Astratan Helmet (+Gold Bar)"
	recipe_name = "an astratan helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/astrata
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/steel/templar/helmet_necra
	name = "Necran Helmet (+Iron Bar)"
	recipe_name = "a necran helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/necra
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_dendor
	name = "Dendor Helmet (+Small Log)"
	recipe_name = "a dendorian helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
	additional_items = list(/obj/item/grown/log/tree/small)

/datum/anvil_recipe/armor/steel/templar/helmet_pestra
	name = "Pestran Helmet (+Iron Bar)"
	recipe_name = "a pestran helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_malum
	name = "Malum Helmet (+Iron Bar)"
	recipe_name = "a malumite helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_ravox
	name = "Ravox Helmet (+Iron Bar)"
	recipe_name = "a ravoxian helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/ravox
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_xylix
	name = "Xylix Helmet (+Iron Bar)"
	recipe_name = "a xylixian helmet"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/xylix
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/chainleg
	name = "Chain Chausses"
	recipe_name = "a pair of Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs

/datum/anvil_recipe/armor/steel/chainkilt_steel
	name = "Chain Kilt"
	recipe_name = "a long Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt

/datum/anvil_recipe/armor/steel/haubergeon
	name = "Haubergeon"
	recipe_name = "a Haubergeon"
	created_item = /obj/item/clothing/armor/chainmail

/datum/anvil_recipe/armor/steel/chainglove
	name = "2x Chain Gauntlets"
	recipe_name = "two pairs of Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain
	createditem_extra = 1

/datum/anvil_recipe/armor/steel/hauberk
	name = "Hauberk (+Bar)"
	recipe_name = "a Hauberk"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk
	craftdiff = 3

/datum/anvil_recipe/armor/steel/scalemail
	name = "Scalemail (+Bar)"
	recipe_name = "a Scalemail"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/scale
	craftdiff = 3

/datum/anvil_recipe/armor/steel/scalemail/steppe
	name = "Lamellar (+Bar, +cured hide)"
	recipe_name = "Steel Lamellar"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/medium/scale/steppe
	craftdiff = 3

/datum/anvil_recipe/armor/steel/surcoat
	name = "Armored Surcoat (+Bar)"
	recipe_name = "an Armored Surcoat"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat
	craftdiff = 3

/datum/anvil_recipe/armor/steel/surcoat/heartfelt
	name = "Armored Heartfelt Surcoat (+Bar)"
	recipe_name = "an Armored Heartfeltian Surcoat"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat/heartfelt
	craftdiff = 4

// STEEL NECK ARMOR
/datum/anvil_recipe/armor/steel/bevor
	name = "Bevor"
	recipe_name = "a Bevor"
	created_item = /obj/item/clothing/neck/bevor

/datum/anvil_recipe/armor/steel/chaincoif
	name = "Chain Coif"
	recipe_name = "a Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif

/datum/anvil_recipe/armor/steel/highcolleir
	name = "High Collier"
	recipe_name = "a High Collier"
	created_item = /obj/item/clothing/neck/highcollier
	craftdiff = 3

// STEEL HELMETS
/datum/anvil_recipe/armor/steel/nasal_helmet
	name = "x2 Nasal helmet"
	recipe_name = "Two nasal helmets"
	created_item = /obj/item/clothing/head/helmet/nasal
	craftdiff = 1
	createditem_extra = 1


/datum/anvil_recipe/armor/steel/gallowglass
	name = "Gallowglass Helmet"
	recipe_name = "Gallowglass Helm"
	created_item = /obj/item/clothing/head/helmet/gallowglass
	craftdiff = 1

/datum/anvil_recipe/armor/steel/coppergate
	name = "Coppergate helmet"
	recipe_name = "coppergate helmet"
	created_item = /obj/item/clothing/head/helmet/coppergate
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Great Helm"
	recipe_name = "a Bucket Helmet"
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "x2 Kettle Helmet"
	recipe_name = "Two kettle helmets"
	created_item = /obj/item/clothing/head/helmet/kettle
	createditem_extra = 1

/datum/anvil_recipe/armor/steel/helmetslitkettle
	name = "Slitted Kettle Helmet"
	recipe_name = "a slitted kettle helmets"
	created_item = /obj/item/clothing/head/helmet/kettle/slit

/datum/anvil_recipe/armor/steel/froghelmet
	name = "Frog Helmet"
	recipe_name = "a frog helmet"
	created_item = (/obj/item/clothing/head/helmet/heavy/frog)

/datum/anvil_recipe/armor/steel/helmetsall
	name = "Sallet"
	recipe_name = "a Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet

/datum/anvil_recipe/armor/steel/elven_sallet
	name = "Elven Guardian Sallet (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	recipe_name = "a Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet/elven

/datum/anvil_recipe/armor/steel/elven_cuirass
	name = "Elven Guardian Cuirass (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	recipe_name = "a cuirass"
	created_item = /obj/item/clothing/armor/cuirass/rare/elven

/datum/anvil_recipe/armor/steel/helmetsall_zalad
	name = "Kulah Khud"
	recipe_name = "a Zalad Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet/zalad

/datum/anvil_recipe/armor/steel/bascinet
	name = "Bascinet"
	recipe_name = "a bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet

/datum/anvil_recipe/armor/steel/bascinet/steppe
	name = "Steppe Bascinet"
	recipe_name = "a bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet/steppe

/datum/anvil_recipe/armor/steel/spangenhelm
	name = "Spangenhelm"
	recipe_name = "a nasal helm with built in eye protection"
	created_item = /obj/item/clothing/head/helmet/heavy/viking
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmetknight
	name = "Knight's helmet (+Bar)"
	recipe_name = "a Knight's Helmet"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/knight)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "Visored sallet (+Bar)"
	recipe_name = "a Visored Sallet"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/sallet)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/hounskull
	name = "Hounskull Helmet (+Bar x2)"
	recipe_name = "a Hounskull Helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/hounskull)
	craftdiff = 4

/*
/datum/anvil_recipe/armor/steel/warden_helm
	name = "Warden Helmet (+Bar)"
	recipe_name = "a Warden's Helmet"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/warden)
	craftdiff = 6

/datum/anvil_recipe/armor/steel/royal_knight_helm
	name = "Royal Knight Helmet (+Bar x2)"
	recipe_name = "a royal knight's Helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/royalknight)
	craftdiff = 6

/datum/anvil_recipe/armor/steel/captain_helm
	name = "Captain's Helmet (+Bar x2)"
	recipe_name = "a captain's Helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/captain)
	craftdiff = 6
*/

// STEEL DECORATED HELMS
/datum/anvil_recipe/armor/steel/decoratedbascinet
	name = "Decorated Bascinet (+Cloth)"
	recipe_name = "a decorated bascinet"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/bascinet

/datum/anvil_recipe/armor/steel/decorativecoppergate
	name = "Decorated Coppergate helmet (+Gold)"
	recipe_name = "decorative coppergate helmet"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/decorativecoppergate
	craftdiff = 1

/datum/anvil_recipe/armor/steel/decoratedhelmetbucgold
	name = "Decorated Gold-trimmed Great Helm (+Gold Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/gold,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/golden

/datum/anvil_recipe/armor/steel/decoratedhelmetknight
	name = "Decorated Knight's Helmet (+Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/knight
	craftdiff = 4

/datum/anvil_recipe/armor/steel/buckethelm
	name = "Decorated Great Helm (+Bar, +Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/bucket
	craftdiff = 4

/datum/anvil_recipe/armor/steel/decoratedhelmetpig
	name = "Decorated Hounskull Helmet (+Bar x2, +Cloth)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/hounskull
	craftdiff = 4

/datum/anvil_recipe/armor/steel/halfplate_decrorated
	name = "Decorated Half-plate (+Steel Bar x2, + Gold Bar)"
	recipe_name = "a decorated Half-Plate Armor"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold)
	created_item = /obj/item/clothing/armor/plate/decorated
	craftdiff = 4

/datum/anvil_recipe/armor/steel/halfplate_decrorated_corset
	name = "Decorated Half-plate With Corset (+Steel Bar x2, + Gold Bar, + Silk x3)"
	recipe_name = "a decorated Half-Plate Armor with Corset"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/armor/plate/decorated/corset
	craftdiff = 4

// STEEL PLATE ARMOR
/datum/anvil_recipe/armor/steel/halfplate
	name = "Steel Half-plate (+Bar x2)"
	recipe_name = "a Half-Plate Armor"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate
	craftdiff = 3

/datum/anvil_recipe/armor/steel/platefull
	name = "Plate Armor (+Bar x3)"
	recipe_name = "a Full-Plate Armor"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full
	craftdiff = 4

/datum/anvil_recipe/armor/steel/platebracer
	name = "Plate Vambraces"
	recipe_name = "Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateleg
	name = "Plate Chausses"
	recipe_name = "a pair of Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateglove
	name = "Plate Gauntlets"
	recipe_name = "a pair of Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateboot
	name = "Plated boots"
	recipe_name = "some Plated Boots"
	created_item = /obj/item/clothing/shoes/boots/armor
	craftdiff = 4

/*
/datum/anvil_recipe/armor/steel/steam
	craftdiff = 5
	abstract_type = /datum/anvil_recipe/armor/steel/steam

/datum/anvil_recipe/armor/steel/steam/helm
	name = "Steamknight helm (+Bar, +Bronze cog)"
	recipe_name = "a steam powered helmet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/steam

/datum/anvil_recipe/armor/steel/steam/gauntlets
	name = "Steamknight gauntlets (+Bronze cog)"
	recipe_name = "a pair of steam powered gauntlets"
	additional_items = list(/obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/gloves/plate/steam

/datum/anvil_recipe/armor/steel/steam/body
	name = "Steamknight plate (+Bar x2, +Bronze cog x3)"
	recipe_name = "a pair of steam powered gauntlets"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/gear/metal/bronze, /obj/item/gear/metal/bronze, /obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/armor/steam

/datum/anvil_recipe/armor/steel/steam/boots
	name = "Steamknight plate boots (+Bronze cog)"
	recipe_name = "a pair of steam powered gauntlets"
	additional_items = list(/obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/shoes/boots/armor/steam
*/

/*
/datum/anvil_recipe/armor/steel/rare
	craftdiff = 5
	abstract_type = /datum/anvil_recipe/armor/steel/rare

/datum/anvil_recipe/armor/steel/rare/dwarf_plate_helm
	name = "Dwarven Plate Helm (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/dwarfplate

/datum/anvil_recipe/armor/steel/rare/dwarf_plate_torso
	name = "Dwarven Plate (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/rare/dwarfplate

/datum/anvil_recipe/armor/steel/rare/dwarf_plate_boots
	name = "Dwarven Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/dwarfplate

/datum/anvil_recipe/armor/steel/rare/dwarf_plate_gauntlets
	name = "Dwarven Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/dwarfplate

/datum/anvil_recipe/armor/steel/rare/grenzel_plate_gauntlets
	name = "Grenzel Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/grenzel_plate
	name = "Grenzel Plate (+Bar x3)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/grenzel_plate_boots
	name = "Grenzel Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/grenzel_plate_helm
	name = "Grenzel Chicklet Plate Helm (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/grenzelplate

/datum/anvil_recipe/armor/steel/rare/zaladin_plate_helm
	name = "Zaladin Bastion Plate Helm (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/hoplite_plate_helm
	name = "Hoplite Plate Helm (+Bronze Bar, +Steel Bar)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/zaladin_plate_gauntlets
	name = "Zaladin Claw Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/zaladin_plate
	name = "Zaladin Kataphractoe Scaleskin (+Bar X3)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/hoplite_plate
	name = "Hoplite Plate (+Bar x2 +Bronze Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/armor/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/zaladin_plate_boots
	name = "Zaladin Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/zaladplate

/datum/anvil_recipe/armor/steel/rare/hoplite_plate_bracers
	name = "Hoplite Bracers (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/wrists/bracers/rare/hoplite

/datum/anvil_recipe/armor/steel/rare/hoplite_plate_boots
	name = "Hoplite Sandals (+Bronze Bar)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/shoes/rare/hoplite

/datum/anvil_recipe/armor/steel/captain_plate_pants
	name = "Captain Plate Chausses (+Bar)"
	recipe_name = "a pair of Premium Plate Chausses"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/captain
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_pants
	name = "Matthiosan Plate Chausses (+Bar)"
	recipe_name = "a pair of Matthiosan Plate Chausses"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggarite_plate_pants
	name = "Graggarite Plate Chausses (+Bar)"
	recipe_name = "a pair of Graggarite Plate Chausses"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate
	name = "Matthiosan Plate Armor (+Bar x3)"
	recipe_name = "a Full-Plate matthiosan Armor"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate
	name = "Graggarite Plate Armor (+Bar x3)"
	recipe_name = "a Full-Plate Graggarite Armor"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_gauntlets
	name = "Matthiosan Plate Gauntlets"
	recipe_name = "a pair of matthiosan Plate gauntlets"
	created_item = /obj/item/clothing/gloves/plate/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate_gauntlets
	name = "Graggarite Plate Gauntlets"
	recipe_name = "a pair of graggarite Plate gauntlets"
	created_item = /obj/item/clothing/gloves/plate/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_boots
	name = "Matthiosan Plate Boots"
	recipe_name = "a pair of matthios Plate gauntlets"
	created_item = /obj/item/clothing/shoes/boots/armor/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate_boots
	name = "Graggarite Plate Boots"
	recipe_name = "a pair of graggar Plate boots"
	created_item = /obj/item/clothing/shoes/boots/armor/graggar
	craftdiff = 6

*/

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- SILVER -----------
/datum/anvil_recipe/armor/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = 3 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/silver
///////////////////////////////////////////////

// --------- SILVER -----------
/datum/anvil_recipe/armor/silver/bascinet
	name = "Silver Bascinet (+Steel Bar x2)"
	recipe_name = "a silver bascinet"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/silver

/datum/anvil_recipe/armor/silver/plateleg
	name = "Silver Plate Chausses (+Steel Bar x2)"
	recipe_name = "a pair of Silver Plate Chausses"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/silver

/datum/anvil_recipe/armor/silver/platefull
	name = "Silver Plate Armor (+Silver Bar, +Steel Bar x3)"
	recipe_name = "a Full-Plate Silver Armor"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/silver
	craftdiff = 4

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- GOLD -----------
/datum/anvil_recipe/armor/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = 3 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/gold
///////////////////////////////////////////////

/datum/anvil_recipe/armor/gold/mask
	name = "Gold Mask"
	created_item = /obj/item/clothing/face/facemask/goldmask

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- BLACKSTEEL -----------
/datum/anvil_recipe/armor/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = 4 // this is the good stuff
	abstract_type = /datum/anvil_recipe/armor/blacksteel
///////////////////////////////////////////////

// --------- BLACKSTEEL -----------
/datum/anvil_recipe/armor/blacksteel/grenzel_cuirass
	name = "Grenzelhoft Cuirass (+Steel Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/cuirass/grenzelhoft

/datum/anvil_recipe/armor/blacksteel/platechest
	name = "Blacksteel Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/plate/blkknight
	craftdiff = 5

/*
/datum/anvil_recipe/armor/blacksteel/zizo_plate_chest
	name = "Darksteel Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/plate/full/zizo
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/elven_plate_chest
	name = "Elven Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/rare/elfplate
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/dark_elven_plate_chest
	name = "Dark Elven Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/armor/rare/elfplate/welfplate
	craftdiff = 5
*/

/datum/anvil_recipe/armor/blacksteel/platelegs
	name = "Blacksteel Plate Chausses (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/pants/platelegs/blk
	craftdiff = 5

/*
/datum/anvil_recipe/armor/blacksteel/zizo_plate_pants
	name = "Darksteel Plate Chausses (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/pants/platelegs/zizo
	craftdiff = 5
*/

/datum/anvil_recipe/armor/blacksteel/bucket
	name = "Blacksteel Great Helm (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/blacksteel/bucket
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/plategloves
	name = "Blacksteel Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/blk
	craftdiff = 5

/*
/datum/anvil_recipe/armor/blacksteel/zizo_plate_gloves
	name = "Darksteel Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/zizo
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/elven_plate_gloves
	name = "Elven Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/elfplate
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/dark_elven_plate_gloves
	name = "Dark Elven Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/rare/elfplate/welfplate
	craftdiff = 5
*/

/datum/anvil_recipe/armor/blacksteel/plateboots
	name = "Blacksteel Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/blkknight
	craftdiff = 5

/*
/datum/anvil_recipe/armor/blacksteel/elven_plate_boots
	name = "Elven Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/elfplate
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/dark_elven_plate_boots
	name = "Dark Elven Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/zizo_plate_boots
	name = "Darksteel Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/zizo
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/zizo_helm_visor
	name = "Darksteel Barbute (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/visored/zizo
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/zizo_helm
	name = "Darksteel Frog Helm (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/heavy/zizo
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/matthios_helm
	name = "Gilded Visage (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/heavy/matthios
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/graggar_helm
	name = "Vicious Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/helmet/heavy/graggar
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/elven_helm
	name = "Elven Plate Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/rare/elfplate
	craftdiff = 5

/datum/anvil_recipe/armor/blacksteel/dark_elven_helm
	name = "Dark Elven Plate Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/blacksteel)
	created_item = /obj/item/clothing/head/rare/elfplate/welfplate
	craftdiff = 5
*/

/datum/anvil_recipe/armor/anklets
	name = "golden anklets"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/shoes/anklets
	craftdiff = 2


/datum/anvil_recipe/armor/holysee_plate
	name = "holy silver plate"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/armor/plate/full/holysee
	craftdiff = 4

/datum/anvil_recipe/armor/holysee_chausses
	name = "holy silver chausses"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/pants/platelegs/holysee
	craftdiff = 3

/datum/anvil_recipe/armor/holysee_bascinet
	name = "holy silver bascinet"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/head/helmet/heavy/holysee
	craftdiff = 3

/datum/anvil_recipe/armor/naledi_mask
	name = "war scholar's mask"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask/naledi
	craftdiff = 3

/datum/anvil_recipe/armor/sojourner_mask
	name = "sojourner's mask"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/face/lordmask/naledi/sojourner
	craftdiff = 4


/datum/anvil_recipe/armor/xylixhelm
	name = "xylixian helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/xylixhelm
	craftdiff = 3

/datum/anvil_recipe/armor/astratahelm
	name = "astrata helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/astratahelm
	craftdiff = 3

/datum/anvil_recipe/armor/nochelm
	name = "noc helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/nochelm
	craftdiff = 3

/datum/anvil_recipe/armor/necrahelm
	name = "necra helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/necrahelm
	craftdiff = 3

/datum/anvil_recipe/armor/dendorhelm
	name = "dendor helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/dendorhelm
	craftdiff = 3

/datum/anvil_recipe/armor/abyssorgreathelm
	name = "abyssorite helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/abyssorgreathelm
	craftdiff = 3

/datum/anvil_recipe/armor/ravoxhelm
	name = "justice eagle"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/ravoxhelm
	craftdiff = 3

/datum/anvil_recipe/armor/volfplate
	name = "volf-face helm"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate
	craftdiff = 3

/datum/anvil_recipe/armor/volfplate_puritan
	name = "volfskulle bascinet"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate/puritan
	craftdiff = 4

/datum/anvil_recipe/armor/atgervi_hauberk
	name = "vagarian hauberk"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/atgervi_claws
	name = "beast claws"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/plate/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/atgervi_helmet
	name = "owl helmet"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/bascinet/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/psydonboots
	name = "crown of psydonian thorns"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/head/helmet/blacksteel/psythorns
	craftdiff = 3

/datum/anvil_recipe/armor/hauberk
	name = "fluted hauberk"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/armor/chainmail/hauberk/fluted
	craftdiff = 3

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "Psydonic Chestplate (+1 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/psydon

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "Psydonic Cuirass (+2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/ornate

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "Psydonic Armet"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psydonhelm

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "Psydonic Sallet (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psysallet

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "Psydonic Bucket Helm (+1 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psybucket

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "Psydonian Conical Helm (+2 Blessed Silver)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/helmet/heavy/absolver

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "Psydonic Half-Plate (+Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/cuirass/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "Psydonic Full-Plate (+Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "Psydonic Full-Plate, Hauberked (+Psydonic Hauberk, +2 Blessed Silver, +2 Cured Leather)"
	req_bar = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/chainmail/hauberk/fluted, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psydonmask
	name = "Psydonic Mask"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/face/facemask/psydonmask

/datum/anvil_recipe/armor/blessedsilver/psydonic_gloves
	name = "Psydonic Chain Gloves"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/gloves/chain/psydon

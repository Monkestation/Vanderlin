/datum/anvil_recipe/armor
	appro_skill = /datum/attribute/skill/craft/armorsmithing
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
	required_material = /obj/item/ingot/copper
///////////////////////////////////////////////

// COPPER ARMOR
/datum/anvil_recipe/armor/copper/cuirass
	name = "Copper heart protector"
	created_item = /obj/item/clothing/armor/cuirass/copperchest

/datum/anvil_recipe/armor/copper/bracers
	name = "Copper bracers"
	created_item = /obj/item/clothing/wrists/bracers/copper

/datum/anvil_recipe/armor/copper/mask
	name = "Copper mask"
	created_item = /obj/item/clothing/face/facemask/copper
	output_amount = 2

// NECK ARMOR
/datum/anvil_recipe/armor/copper/gorget
	name = "Copper neck protector"
	created_item = /obj/item/clothing/neck/gorget/copper

// HELMETS
/datum/anvil_recipe/armor/copper/cap
	name = "Lamellar cap"
	created_item = /obj/item/clothing/head/helmet/coppercap

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- BRONZE -----------
/datum/anvil_recipe/armor/bronze
	required_material = /obj/item/ingot/bronze
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/bronze
///////////////////////////////////////////////

// BRONZE ARMOR

/datum/anvil_recipe/armor/bronze/brigandine
	name = "Abyssal Robe (+Bronze Bar, +Cloth)"
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


// BRONZE HELMET

/datum/anvil_recipe/armor/bronze/helmet
	name = "Deep Abyssor Helmet (+Bronze Bar)"
	required_material = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/necked/deepabyssor
	craftdiff = 3

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- IRON -----------
/datum/anvil_recipe/armor/iron
	required_material = /obj/item/ingot/iron
	craftdiff = 1
	abstract_type = /datum/anvil_recipe/armor/iron
///////////////////////////////////////////////

// IRON ARMOR
/datum/anvil_recipe/armor/iron/splint
	name = "Two splint Armors (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/splintpants
	name = "two splint trousers  (+3 cured leather)" //two items per bar since is mostly leather + iron bits, ideal for cheaper armors
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/pants/trou/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/mailleboots
	name = "two chainmail boots (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/boots/armor/ironmaille
	output_amount = 2

/datum/anvil_recipe/armor/iron/cuirass
	name = "Iron Cuirass"
	created_item = /obj/item/clothing/armor/cuirass/iron

/datum/anvil_recipe/armor/iron/chausses
	name = "Iron Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs/iron

/datum/anvil_recipe/armor/iron/platemask
	name = "Iron Face Masks"
	created_item = /obj/item/clothing/face/facemask
	output_amount = 2

// IRON CHAIN ARMOR
/datum/anvil_recipe/armor/iron/chainmail
	name = "Iron Maille"
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/chainkini
	name = "Iron Chainkini (+fur)"
	additional_items = list(/obj/item/natural/fur)
	created_item = /obj/item/clothing/armor/amazon_chainkini

/datum/anvil_recipe/armor/iron/hauberk
	name = "Iron Hauberk (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/chainleg
	name = "Iron Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs/iron

/datum/anvil_recipe/armor/iron/chainkilt
	name = "Iron Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt/iron

/datum/anvil_recipe/armor/iron/chainglove
	name = "Iron Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron
	output_amount = 2

// IRON NECK ARMOR
/datum/anvil_recipe/armor/iron/gorget
	name = "Iron Gorget"
	created_item = /obj/item/clothing/neck/gorget

/datum/anvil_recipe/armor/iron/chaincoif
	name = "Iron Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif/iron

/datum/anvil_recipe/armor/iron/highcollier
	name = "Iron High Collier"
	created_item = /obj/item/clothing/neck/highcollier/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/highcollier_renegade
	name = "Iron Renegade Collar (+Hide)"
	additional_items = list(/obj/item/natural/hide)
	created_item = /obj/item/clothing/neck/highcollier/iron/renegadecollar
	craftdiff = 1

/datum/anvil_recipe/armor/iron/chainglove
	name = "Iron Chain Gauntlets"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/gloves/chain/iron
	output_amount = 2
	craftdiff = 0

/datum/anvil_recipe/armor/iron/igauntlets
	name = "Iron Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/iron

/datum/anvil_recipe/armor/iron/ijackchain
	name = "Iron Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/ironjackchain
	output_amount = 2

/datum/anvil_recipe/armor/iron/ibracers
	name = "Iron Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers/iron

/datum/anvil_recipe/armor/iron/chainmail
	name = "Iron Haubergeon"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/chainmail/iron

/datum/anvil_recipe/armor/iron/hauberk
	name = "Hauberk (+Bar)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/iron

/datum/anvil_recipe/armor/iron/cuirass
	name = "Iron Cuirass"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/armor/cuirass/iron
	craftdiff = 0

/datum/anvil_recipe/armor/iron/platefull
	name = "Iron Plate Armor (+Bar x3)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/platefull_shadow
	name = "Iron Plate Shadow Armor (+Bar x3)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/cuirass/iron/shadowplate
	craftdiff = 2

/datum/anvil_recipe/armor/iron/halfplate
	name = "Iron Half-plate (+Bar x2)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron
	craftdiff = 1

/datum/anvil_recipe/armor/iron/platehelmet
	name = "Iron Plate Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 1

/datum/anvil_recipe/armor/iron/barred_helmet
	name = "Barred Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/townwatch/gatemaster
	craftdiff = 1

/datum/anvil_recipe/armor/iron/winged_helmet
	name = "Winged Helmet"
	created_item = /obj/item/clothing/head/helmet/winged
	craftdiff = 1

/datum/anvil_recipe/armor/iron/horned_helmet
	name = "Horned Helmet"
	created_item = /obj/item/clothing/head/helmet/horned
	craftdiff = 1

/datum/anvil_recipe/armor/steel/bastion_helm
	name = "Bastion helm (+Bar X2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/necked
	craftdiff = 2

/datum/anvil_recipe/armor/steel/pegasusknighthelm
	name = "Coifed Helmet (+Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/pegasusknight
	craftdiff = 2

/datum/anvil_recipe/armor/steel/crusader_helm
	name = "Crusader helm (+Bar X2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader
	craftdiff = 2

/datum/anvil_recipe/armor/steel/totod_crusader_helm
	name = "Totod Crusader helm (+Bar X2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/crusader/t
	craftdiff = 2

/datum/anvil_recipe/armor/steel/skullmet_helm
	name = "Skullmet helm (+Bone X2)"
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	craftdiff = 3

/datum/anvil_recipe/armor/steel/rousskull_helm

	name = "Rous Skull helm (+Bone X2)"
	additional_items = list(/obj/item/alch/bone, /obj/item/alch/bone)
	created_item = /obj/item/clothing/head/helmet/medium/decorated/rousskullmet
	craftdiff = 3

/datum/anvil_recipe/armor/iron/cage_helmet
	name = "feldsher's cage"
	created_item = /obj/item/clothing/head/helmet/feld
	craftdiff = 1

/datum/anvil_recipe/armor/iron/pothelmet
	name = "Pot Helmet"
	created_item = /obj/item/clothing/head/helmet/ironpot

/datum/anvil_recipe/armor/iron/lakkariancap
	name = "Crowned Cap (+ Gold Bar)"
	created_item = /obj/item/clothing/head/helmet/ironpot/lakkariancap
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/iron/nasal_helmet
	name = "Nasal helmet"
	created_item = /obj/item/clothing/head/helmet/nasal

/datum/anvil_recipe/armor/iron/skullcap
	name = "x2 Skullcap"
	created_item = /obj/item/clothing/head/helmet/skullcap
	output_amount = 2

/datum/anvil_recipe/armor/iron/helmetkettle
	name = "Iron Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/iron

/datum/anvil_recipe/armor/iron/helmetslitkettle
	name = "Slitted Iron Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/slit/iron

/datum/anvil_recipe/armor/iron/helmetsall
	name = "Iron Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet/iron

/datum/anvil_recipe/armor/iron/helmetsallv
	name = "Visored Iron Sallet (+Bar)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/sallet/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/eoran_sallet
	name = "Eoran Sallet (+Bar)"
	required_material = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/sallet/eoran
	craftdiff = 2

/datum/anvil_recipe/armor/iron/helmetknight
	name = "Iron Knight's helmet (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = (/obj/item/clothing/head/helmet/visored/knight/iron)
	craftdiff = 2

// IRON PLATE ARMOR
/datum/anvil_recipe/armor/iron/halfplate
	name = "Iron Half-plate (+Bar x2)"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/iron

/datum/anvil_recipe/armor/iron/platefull
	name = "Iron Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/iron,/obj/item/ingot/iron,/obj/item/ingot/iron)
	created_item = /obj/item/clothing/armor/plate/full/iron
	craftdiff = 2

/datum/anvil_recipe/armor/iron/platehelmet
	name = "Iron Plate Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/heavy/ironplate
	craftdiff = 2
/datum/anvil_recipe/armor/iron/bevor
	name = "Iron Bevor"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/bevor/iron

/datum/anvil_recipe/armor/iron/platebootlight
	name = "Light Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/light

/datum/anvil_recipe/armor/iron/town_watch_helmet
	name = "Town Watch helmet"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch
	craftdiff = 1

/datum/anvil_recipe/armor/iron/town_watch_helmet_alt
	name = "Town Watch helmet (alt)"
	required_material = /obj/item/ingot/iron
	created_item = /obj/item/clothing/head/helmet/townwatch/alt
	craftdiff = 1

/datum/anvil_recipe/armor/iron/skullcap
	name = "Skullcap"
	created_item = /obj/item/clothing/head/helmet/skullcap

/datum/anvil_recipe/armor/iron/grenzelhoft_skullcap
	name = "Grenzelhoft Plume helmet"
	additional_items = list(/obj/item/natural/feather)
	created_item = /obj/item/clothing/head/helmet/skullcap/grenzelhoft

/datum/anvil_recipe/armor/iron/splint
	name = "Two splint Armors (+2 cured leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/leather/splint
	output_amount = 2

/datum/anvil_recipe/armor/iron/brigandine/light
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
/datum/anvil_recipe/armor/steel/jackchain
	name = "Jack Chains"
	created_item = /obj/item/clothing/wrists/bracers/jackchain
	output_amount = 2

/datum/anvil_recipe/armor/steel/platemask
	name = "Steel Mask"
	created_item = /obj/item/clothing/face/facemask/steel
	output_amount = 2

/datum/anvil_recipe/armor/steel/steppemask
	name = "Steppe War Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppe
	output_amount = 2

/datum/anvil_recipe/armor/steel/maskbeast
	name = "Steppe Beast Mask"
	created_item = /obj/item/clothing/face/facemask/steel/steppebeast
	output_amount = 2

/datum/anvil_recipe/armor/steel/cuirass
	name = "Steel Cuirass"
	created_item = /obj/item/clothing/armor/cuirass

/datum/anvil_recipe/armor/steel/brigadine
	name = "Brigandine (+Bar x2, +Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine
	craftdiff = 3
/*
/datum/anvil_recipe/armor/steel/brigadine
	name = "Captain's brigandine (+Bar x2, +Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/armor/brigandine/captain
	craftdiff = 6
*/

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Great Helm"
	required_material = /obj/item/ingot/steel
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)
/*
/datum/anvil_recipe/armor/steel/sinistar
	name = "Sinistar Helmet (+Steel Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/sinistar
	additional_items = list(/obj/item/ingot/steel)
*/

/datum/anvil_recipe/armor/iron/shadow_plate_gauntlets
	name = "Shadow Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
	craftdiff = 3

/datum/anvil_recipe/armor/steel/templar
	craftdiff = 3
	abstract_type = /datum/anvil_recipe/armor/steel/templar

/datum/anvil_recipe/armor/steel/templar/helmet_noc
	name = "Noc Helmet (+Silver Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/noc
	additional_items = list(/obj/item/ingot/silver)

/datum/anvil_recipe/armor/steel/templar/gold_helmet
	name = "Gold Helmet (+Gold Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/bucket/gold
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/steel/templar/helmet_astrata
	name = "Astratan Helmet (+Gold Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/astrata
	additional_items = list(/obj/item/ingot/gold)

/datum/anvil_recipe/armor/steel/templar/helmet_necra
	name = "Necran Helmet (+Iron Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/necra
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_dendor
	name = "Dendor Helmet (+Small Log)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
	additional_items = list(/obj/item/grown/log/tree/small)

/datum/anvil_recipe/armor/steel/templar/helmet_pestra
	name = "Pestran Helmet (+Iron Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_malum
	name = "Malum Helmet (+Iron Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_ravox
	name = "Ravox Helmet (+Iron Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/ravox
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_xylix
	name = "Xylix Helmet (+Iron Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/xylix
	additional_items = list(/obj/item/ingot/iron)

/datum/anvil_recipe/armor/steel/templar/helmet_abyssor
	name = "Abyssor Helmet (+Bronze Bar)"
	created_item = /obj/item/clothing/head/helmet/heavy/necked/abyssor
	additional_items = list(/obj/item/ingot/bronze)

/datum/anvil_recipe/armor/steel/chainleg
	name = "Chain Chausses"
	created_item = /obj/item/clothing/pants/chainlegs

/datum/anvil_recipe/armor/steel/chainkilt_steel
	name = "Chain Kilt"
	created_item = /obj/item/clothing/pants/chainlegs/kilt

/datum/anvil_recipe/armor/steel/haubergeon
	name = "Haubergeon"
	created_item = /obj/item/clothing/armor/chainmail

/datum/anvil_recipe/armor/steel/chainglove
	name = "Chain Gauntlets"
	created_item = /obj/item/clothing/gloves/chain
	output_amount = 2

/datum/anvil_recipe/armor/steel/hauberk
	name = "Hauberk (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk
	craftdiff = 3

/datum/anvil_recipe/armor/steel/scalemail
	name = "Scalemail (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/scale
	craftdiff = 3

/datum/anvil_recipe/armor/steel/scalemail/steppe
	name = "Lamellar (+Bar, +cured hide)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/medium/scale/steppe
	craftdiff = 3

/datum/anvil_recipe/armor/steel/surcoat
	name = "Armored Surcoat (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat
	craftdiff = 3

/datum/anvil_recipe/armor/steel/surcoat/heartfelt
	name = "Armored Heartfelt Surcoat (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/medium/surcoat/heartfelt
	craftdiff = 4

// STEEL NECK ARMOR
/datum/anvil_recipe/armor/steel/bevor
	name = "Bevor"
	created_item = /obj/item/clothing/neck/bevor

/datum/anvil_recipe/armor/steel/chaincoif
	name = "Chain Coif"
	created_item = /obj/item/clothing/neck/chaincoif

/datum/anvil_recipe/armor/steel/highcolleir
	name = "High Collier"
	created_item = /obj/item/clothing/neck/highcollier
	craftdiff = 3

// STEEL HELMETS
/datum/anvil_recipe/armor/steel/nasal_helmet
	name = "x2 Nasal helmet"
	created_item = /obj/item/clothing/head/helmet/nasal
	craftdiff = 1
	output_amount = 2

/datum/anvil_recipe/armor/steel/gallowglass
	name = "Gallowglass Helmet"
	created_item = /obj/item/clothing/head/helmet/gallowglass
	craftdiff = 1

/datum/anvil_recipe/armor/steel/coppergate
	name = "Coppergate helmet"
	created_item = /obj/item/clothing/head/helmet/coppergate
	craftdiff = 1

/datum/anvil_recipe/armor/steel/helmetbuc
	name = "Great Helm"
	created_item = (/obj/item/clothing/head/helmet/heavy/bucket)

/datum/anvil_recipe/armor/steel/helmetkettle
	name = "x2 Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle
	output_amount = 2

/datum/anvil_recipe/armor/steel/helmetslitkettle
	name = "Slitted Kettle Helmet"
	created_item = /obj/item/clothing/head/helmet/kettle/slit

/datum/anvil_recipe/armor/steel/froghelmet
	name = "Frog Helmet"
	created_item = (/obj/item/clothing/head/helmet/heavy/frog)

/datum/anvil_recipe/armor/steel/helmetsall
	name = "Sallet"
	created_item = /obj/item/clothing/head/helmet/sallet

/datum/anvil_recipe/armor/steel/elven_sallet
	name = "Elven Guardian Sallet (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/head/helmet/sallet/elven

/datum/anvil_recipe/armor/steel/elven_cuirass
	name = "Elven Guardian Cuirass (+Gold bar)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/armor/cuirass/rare/elven

/datum/anvil_recipe/armor/steel/helmetsall_zalad
	name = "Kulah Khud"
	created_item = /obj/item/clothing/head/helmet/sallet/zalad

/datum/anvil_recipe/armor/steel/bascinet
	name = "Bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet

/datum/anvil_recipe/armor/steel/bascinet/steppe
	name = "Steppe Bascinet"
	created_item = /obj/item/clothing/head/helmet/bascinet/steppe

/datum/anvil_recipe/armor/steel/spangenhelm
	name = "Spangenhelm"
	created_item = /obj/item/clothing/head/helmet/heavy/viking
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmetknight
	name = "Knight's helmet (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/knight)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/helmetsallv
	name = "Visored sallet (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/sallet)
	craftdiff = 3

/datum/anvil_recipe/armor/steel/hounskull
	name = "Hounskull Helmet (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/hounskull)
	craftdiff = 4

/datum/anvil_recipe/armor/steel/barding
	name = "Saiga Barding, Chainmail (+1 Steel)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/chain

/datum/anvil_recipe/armor/steel/barding/honse
	name = "Honse Barding, Chainmail (+1 Steel)"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/barding/honse/chain

/*
/datum/anvil_recipe/armor/steel/warden_helm
	name = "Warden Helmet (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/warden)
	craftdiff = 6

/datum/anvil_recipe/armor/steel/royal_knight_helm
	name = "Royal Knight Helmet (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/royalknight)
	craftdiff = 6

/datum/anvil_recipe/armor/steel/captain_helm
	name = "Captain's Helmet (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = (/obj/item/clothing/head/helmet/visored/captain)
	craftdiff = 6
*/

// STEEL DECORATED HELMS
/datum/anvil_recipe/armor/steel/decoratedbascinet
	name = "Decorated Bascinet (+Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/helmet/heavy/decorated/bascinet

/datum/anvil_recipe/armor/steel/decorativecoppergate
	name = "Decorated Coppergate helmet (+Gold)"
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
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold)
	created_item = /obj/item/clothing/armor/plate/decorated
	craftdiff = 4

/datum/anvil_recipe/armor/steel/halfplate_decrorated_corset
	name = "Decorated Half-plate With Corset (+Steel Bar x2, + Gold Bar, + Silk x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel, /obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/natural/silk, /obj/item/natural/silk)
	created_item = /obj/item/clothing/armor/plate/decorated/corset
	craftdiff = 4

// STEEL PLATE ARMOR
/datum/anvil_recipe/armor/steel/halfplate
	name = "Steel Half-plate (+Bar x2)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate
	craftdiff = 3

/datum/anvil_recipe/armor/steel/platefull
	name = "Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full
	craftdiff = 4

/datum/anvil_recipe/armor/steel/platebracer
	name = "Plate Vambraces"
	created_item = /obj/item/clothing/wrists/bracers
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateleg
	name = "Plate Chausses"
	created_item = /obj/item/clothing/pants/platelegs
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateglove
	name = "Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate
	craftdiff = 4

/datum/anvil_recipe/armor/steel/plateboot
	name = "Plated boots"
	created_item = /obj/item/clothing/shoes/boots/armor
	craftdiff = 4

/*
/datum/anvil_recipe/armor/steel/steam
	craftdiff = 5
	abstract_type = /datum/anvil_recipe/armor/steel/steam

/datum/anvil_recipe/armor/steel/steam/helm
	name = "Steamknight helm (+Bar, +Bronze cog)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/head/helmet/heavy/steam

/datum/anvil_recipe/armor/steel/steam/gauntlets
	name = "Steamknight gauntlets (+Bronze cog)"
	additional_items = list(/obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/gloves/plate/steam

/datum/anvil_recipe/armor/steel/steam/body
	name = "Steamknight plate (+Bar x2, +Bronze cog x3)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/gear/metal/bronze, /obj/item/gear/metal/bronze, /obj/item/gear/metal/bronze)
	created_item = /obj/item/clothing/armor/steam

/datum/anvil_recipe/armor/steel/steam/boots
	name = "Steamknight plate boots (+Bronze cog)"
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
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/captain
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_pants
	name = "Matthiosan Plate Chausses (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggarite_plate_pants
	name = "Graggarite Plate Chausses (+Bar)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate
	name = "Matthiosan Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate
	name = "Graggarite Plate Armor (+Bar x3)"
	additional_items = list(/obj/item/ingot/steel,/obj/item/ingot/steel,/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_gauntlets
	name = "Matthiosan Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate_gauntlets
	name = "Graggarite Plate Gauntlets"
	created_item = /obj/item/clothing/gloves/plate/graggar
	craftdiff = 6

/datum/anvil_recipe/armor/steel/matthios_plate_boots
	name = "Matthiosan Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/matthios
	craftdiff = 6

/datum/anvil_recipe/armor/steel/graggar_plate_boots
	name = "Graggarite Plate Boots"
	created_item = /obj/item/clothing/shoes/boots/armor/graggar
	craftdiff = 6

*/

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- SILVER -----------
/datum/anvil_recipe/armor/silver
	required_material = /obj/item/ingot/silver
	craftdiff = 3 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/silver
///////////////////////////////////////////////

// --------- SILVER -----------
/datum/anvil_recipe/armor/silver/bascinet
	name = "Silver Bascinet (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/silver

/datum/anvil_recipe/armor/silver/armet
	name = "Silver Armet (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/silver/armet

/datum/anvil_recipe/armor/silver/plateleg
	name = "Silver Plate Chausses (+Steel Bar x2)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/pants/platelegs/silver

/datum/anvil_recipe/armor/silver/platefull
	name = "Silver Plate Armor (+Silver Bar, +Steel Bar x3)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/plate/full/silver
	craftdiff = 4

/datum/anvil_recipe/armor/silver/gauntlet
	name = "Silver Gauntlets"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/gloves/plate/silver
	craftdiff = 4

/datum/anvil_recipe/armor/silver/boots
	name = "Silver Boots"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/shoes/boots/armor/silver
	craftdiff = 4

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- GOLD -----------
/datum/anvil_recipe/armor/gold
	required_material = /obj/item/ingot/gold
	craftdiff = 3 // harder to work with. mostly jewelry
	abstract_type = /datum/anvil_recipe/armor/gold
///////////////////////////////////////////////

/datum/anvil_recipe/armor/gold/mask
	name = "Gold Mask"
	created_item = /obj/item/clothing/face/facemask/goldmask

//////////////////////////////////////////////////////////////////////////////////////////////
// --------- BLACKSTEEL -----------
/datum/anvil_recipe/armor/blacksteel
	required_material = /obj/item/ingot/blacksteel
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
	required_material = /obj/item/ingot/gold
	created_item = /obj/item/clothing/shoes/anklets
	craftdiff = 2


/datum/anvil_recipe/armor/holysee_plate
	name = "holy silver plate"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/armor/plate/full/holysee
	craftdiff = 4

/datum/anvil_recipe/armor/holysee_chausses
	name = "holy silver chausses"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/pants/platelegs/holysee
	craftdiff = 3

/datum/anvil_recipe/armor/holysee_bascinet
	name = "holy silver bascinet"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/clothing/head/helmet/heavy/holysee
	craftdiff = 3

/datum/anvil_recipe/armor/naledi_mask
	name = "war scholar's mask"
	required_material = /obj/item/ingot/gold
	created_item = /obj/item/clothing/face/lordmask/naledi
	craftdiff = 3

/datum/anvil_recipe/armor/sojourner_mask
	name = "sojourner's mask"
	required_material = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/clothing/face/lordmask/naledi/sojourner
	craftdiff = 4


/datum/anvil_recipe/armor/xylixhelm
	name = "xylixian helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/xylixhelm
	craftdiff = 3

/datum/anvil_recipe/armor/astratahelm
	name = "astrata helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/astratahelm
	craftdiff = 3

/datum/anvil_recipe/armor/nochelm
	name = "noc helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/nochelm
	craftdiff = 3

/datum/anvil_recipe/armor/necrahelm
	name = "necra helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/necrahelm
	craftdiff = 3

/datum/anvil_recipe/armor/dendorhelm
	name = "dendor helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/dendorhelm
	craftdiff = 3

/datum/anvil_recipe/armor/abyssorgreathelm
	name = "abyssorite helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/abyssorgreathelm
	craftdiff = 3

/datum/anvil_recipe/armor/ravoxhelm
	name = "justice eagle"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/ravoxhelm
	craftdiff = 3

/datum/anvil_recipe/armor/volfplate
	name = "volf-face helm"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate
	craftdiff = 3

/datum/anvil_recipe/armor/volfplate_puritan
	name = "volfskulle bascinet"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate/puritan
	craftdiff = 4

/datum/anvil_recipe/armor/atgervi_hauberk
	name = "vagarian hauberk"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/armor/chainmail/hauberk/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/atgervi_claws
	name = "beast claws"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/plate/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/atgervi_helmet
	name = "owl helmet"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/helmet/bascinet/atgervi
	craftdiff = 3

/datum/anvil_recipe/armor/psydonboots
	name = "crown of psydonian thorns"
	required_material = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/head/helmet/blacksteel/psythorns
	craftdiff = 3

/datum/anvil_recipe/armor/hauberk
	name = "fluted hauberk"
	required_material = /obj/item/ingot/steel
	created_item = /obj/item/clothing/armor/chainmail/hauberk/fluted
	craftdiff = 3

/datum/anvil_recipe/armor/blessedsilver/psychestplate
	name = "Psydonic Chestplate (+1 Cured Leather)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/psydon

/datum/anvil_recipe/armor/blessedsilver/psycuirass
	name = "Psydonic Cuirass (+2 Cured Leather)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/cuirass/ornate

/datum/anvil_recipe/armor/blessedsilver/armetpsy
	name = "Psydonic Armet"
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psydonhelm

/datum/anvil_recipe/armor/blessedsilver/helmsallpsy
	name = "Psydonic Sallet (+1 Blessed Silver)"
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psysallet

/datum/anvil_recipe/armor/blessedsilver/helmbucketpsy
	name = "Psydonic Bucket Helm (+1 Blessed Silver)"
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/head/helmet/heavy/psybucket

/datum/anvil_recipe/armor/blessedsilver/helmetabso
	name = "Psydonian Conical Helm (+2 Blessed Silver)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	created_item = /obj/item/clothing/head/helmet/heavy/absolver

/datum/anvil_recipe/armor/blessedsilver/psyhalfplate
	name = "Psydonic Half-Plate (+Psydonic Cuirass, +1 Blessed Silver, +2 Cured Leather)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/cuirass/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplate
	name = "Psydonic Full-Plate (+Psydonic Half-Plate, +1 Blessed Silver, +2 Cured Leather)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/plate/fluted/ornate, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psyfullplatealt
	name = "Psydonic Full-Plate, Hauberked (+Psydonic Hauberk, +2 Blessed Silver, +2 Cured Leather)"
	required_material = /obj/item/ingot/silverblessed
	additional_items = list(/obj/item/clothing/armor/chainmail/hauberk/fluted, /obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/armor/plate/fluted/ornate

/datum/anvil_recipe/armor/blessedsilver/psydonmask
	name = "Psydonic Mask"
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/face/facemask/psydonmask

/datum/anvil_recipe/armor/blessedsilver/psydonic_gloves
	name = "Psydonic Chain Gloves"
	required_material = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/gloves/chain/psydon

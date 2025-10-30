/datum/inqports/reliquary/
	category = 1 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/supplies/
	category = 2  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/articles/
	category = 3  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/equipment/
	category = 4 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/wardrobe/
	category = 5 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".


/obj/structure/closet/crate/chest/inqcrate/supplies/
	name = "inquisitorial supply crate"

/obj/structure/closet/crate/chest/inqcrate/articles/
	name = "inquisitorial article crate"

/obj/structure/closet/crate/chest/inqreliquary/relic/

/obj/structure/closet/crate/chest/inqcrate/equipment/
	name = "inquisitorial equipment crate"

/obj/structure/closet/crate/chest/inqcrate/wardrobe/
	name = "grenzelhoft's finest wardrobe crate"

/// ✤ SUPPLIES ✤ START HERE! WOW!

/datum/inqports/supplies/extrafunding
	name = "(80 Silvers) Extra Funding"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding
	marquescost = 16
	maximum = 1

/obj/item/coin/silver/inqpile/Initialize()
	. = ..()
	set_quantity(20)

/obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding/Initialize()
	. = ..()
	new /obj/item/coin/silver/inqpile(src)
	new /obj/item/coin/silver/inqpile(src)
	new /obj/item/coin/silver/inqpile(src)
	new /obj/item/coin/silver/inqpile(src)

/datum/inqports/supplies/stampstuff
	name = "1 Lump of Redtallow"
	item_type = /obj/item/reagent_containers/food/snacks/tallow/red
	marquescost = 2

/datum/inqports/supplies/medical
	name = "5 Rolls of Cloth and Needles"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/medical
	marquescost = 8

/obj/item/natural/bundle/cloth/roll/Initialize()
	. = ..()
	icon_state = "clothroll2"
	amount = 10

/obj/structure/closet/crate/chest/inqcrate/supplies/medical/Initialize()
	. = ..()
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/natural/bundle/cloth/roll(src)
	new /obj/item/natural/bundle/cloth/roll(src)
	new /obj/item/natural/bundle/cloth/roll(src)
	new /obj/item/natural/bundle/cloth/roll(src)
	new /obj/item/natural/bundle/cloth/roll(src)

/datum/inqports/supplies/chains
	name = "2 Lengths of Chain"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/chains
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/supplies/chains/Initialize()
	. = ..()
	new /obj/item/rope/chain(src)
	new /obj/item/rope/chain(src)

/datum/inqports/supplies/redpotions
	name = "3 Bottles of Red"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/redpots
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/supplies/redpots/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/healthpot(src)

/datum/inqports/supplies/lifebloodvials
	name = "3 Vials of Strong Red"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/sredvials
	maximum = 4
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/supplies/sredvials/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)

/datum/inqports/supplies/bluepotions
	name = "3 Bottles of Blue"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/bluepots
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/bluepots/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/manapot(src)

/datum/inqports/supplies/strongbluevials
	name = "3 Vials of Strong Blue"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/sbluevials
	maximum = 4
	marquescost = 16

/obj/structure/closet/crate/chest/inqcrate/supplies/sbluevials/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/strongmanapot(src)
	new /obj/item/reagent_containers/glass/bottle/strongmanapot(src)
	new /obj/item/reagent_containers/glass/bottle/strongmanapot(src)

/datum/inqports/supplies/smokes
	name = "4 Smokebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/smokes
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/smokes/Initialize()
	. = ..()
	new /obj/item/smokebomb(src)
	new /obj/item/smokebomb(src)
	new /obj/item/smokebomb(src)
	new /obj/item/smokebomb(src)

/obj/item/reagent_containers/glass/bottle/alchemical/blessedwater
	list_reagents = list(/datum/reagent/water/blessed = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew
	list_reagents = list(/datum/reagent/medicine/stronghealth = 30)

/datum/inqports/supplies/psybuns
	name = "The Grenzelhoftian Bakery Special"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/psybuns
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/supplies/psybuns/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/bun(src)
	new /obj/item/reagent_containers/food/snacks/bun(src)
	new /obj/item/reagent_containers/food/snacks/bun(src)
	new /obj/item/reagent_containers/food/snacks/bun(src)
	new /obj/item/reagent_containers/food/snacks/bun(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)

/datum/inqports/supplies/bottlebombs
	name = "3 Bottlebombs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs/Initialize()
	. = ..()
	new /obj/item/explosive(src)
	new /obj/item/explosive(src)
	new /obj/item/explosive(src)

/datum/inqports/supplies/bullion
	name = "6 Blessed Silver Bullion"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/bullion/
	marquescost = 16

/obj/structure/closet/crate/chest/inqreliquary/relic/bullion/Initialize()
	. = ..()
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)


// ✤ ARTICLES ✤ RIGHT HERE! THAT'S RIGHT!

/datum/inqports/articles/psycrosssilver
	name = "1 Silver Psycross"
	item_type = /obj/item/clothing/neck/psycross/silver
	marquescost = 14

/datum/inqports/articles/psycross
	name = "1 Psycross"
	item_type = /obj/item/clothing/neck/psycross
	marquescost = 2

/datum/inqports/articles/indexaccused
	name = "3 INDEXERs, 3 Accusations"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexaccused
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/articles/indexaccused/Initialize()
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)

/*
/datum/inqports/articles/indexers
	name = "3 INDEXERs"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexers
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/articles/indexers/Initialize()
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
*/
/*
/datum/inqports/articles/accusations
	name = "3 Accusations"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/accusations
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/articles/accusations/Initialize()
	. = ..()
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
*/

/datum/inqports/articles/confessions
	name = "3 Confessions"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/confessions
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/articles/confessions/Initialize()
	. = ..()
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)

/datum/inqports/articles/bmirror
	name = "1 Black Mirror"
	item_type = /obj/item/inqarticles/bmirror
	marquescost = 8

/datum/inqports/articles/listener
	name = "1 Attentive Ear"
	item_type = /obj/item/listeningdevice
	marquescost = 4

/datum/inqports/articles/whisperer
	name = "1 Secret Whisperer"
	item_type = /obj/item/speakerinq
	marquescost = 8


// ✤ EQUIPMENT ✤ BELONGS HERE! JUST BELOW!

/datum/inqports/equipment/psydonthorns
	name = "1 Psydonian Thorns"
	item_type = /obj/item/clothing/wrists/bracers/psythorns
	marquescost = 16

/datum/inqports/equipment/garrote
	name = "1 Seizing Garrote"
	item_type = /obj/item/inqarticles/garrote
	marquescost = 4

/datum/inqports/equipment/strangemask
	name = "1 Confessional Mask"
	item_type = /obj/item/clothing/face/facemask/steel/confessor
	marquescost = 10

/datum/inqports/equipment/otavansatchel
	name = "1 Grenzelhoftian Leather Satchel"
	item_type = /obj/item/storage/backpack/satchel/otavan
	marquescost = 8

/datum/inqports/equipment/psysack
	name = "1 Identity Concealer"
	item_type = /obj/item/clothing/face/sack/psy
	marquescost = 6

/datum/inqports/equipment/inqcordage
	name = "2 Spools of Inquiry Cordage"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage/Initialize()
	. = ..()
	new /obj/item/rope/inqarticles/inquirycord(src)
	new /obj/item/rope/inqarticles/inquirycord(src)

/datum/inqports/equipment/blackbags
	name = "3 Black Bags"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/blackbags
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/equipment/blackbags/Initialize()
	. = ..()
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)


/datum/inqports/equipment/psydonhelms
	name = "Helms of Psydon"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms
	marquescost = 12
	maximum = 1

/obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms/Initialize()
	. = ..()
	new /obj/item/clothing/head/helmet/heavy/psydonbarbute(src)
	new /obj/item/clothing/head/helmet/heavy/psysallet(src)
	new /obj/item/clothing/head/helmet/heavy/psybucket(src)
	new /obj/item/clothing/head/helmet/heavy/psydonhelm(src)

/datum/inqports/equipment/crankbox
	name = "The Crankbox"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/
	marquescost = 16
	maximum = 1

/obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/Initialize()
	. = ..()
	new /obj/item/psydonmusicbox(src)

/datum/inqports/equipment/nocshades
	name = "1 Nocshade Lens-Pair"
	item_type = /obj/item/clothing/face/spectacles/inq
	marquescost = 16

// ✤ WARDROBE ✤ STARTS HERE! YEP!

/obj/item/clothing/neck/fencerguard/inq
	icon_state = "fencercollar"
	color = "#8b1414"
	detail_color = "#99b2b1"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_SIDE_STEEL
	body_parts_covered = NECK
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	detail_tag = "_detail"
	color = "#5058c1"

/obj/item/clothing/armor/gambeson/heavy/otavan/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/datum/inqports/wardrobe/fencerset
	name = "The Grenzelhoftian Fencer's Finest Set Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset
	marquescost = 14

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset/Initialize()
	. = ..()
	new /obj/item/clothing/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/neck/fencerguard/inq(src)
	new /obj/item/clothing/gloves/leather/otavan(src)
	new /obj/item/clothing/pants/tights/colored/black(src)
	new /obj/item/clothing/shoes/otavan(src)

/datum/inqports/wardrobe/confessionalcombo
	name = "The Confessional Combination"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo
	marquescost = 14

/obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguehood/psydon/confessor(src)
	new /obj/item/clothing/armor/leather/jacket/leathercoat/confessor(src)

/datum/inqports/wardrobe/inspectorcoat
	name = "The Inquisition's Finest Coats and Hats"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats
	marquescost = 18

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats/Initialize()
	. = ..()
	new /obj/item/clothing/head/leather/inqhat(src)
	new /obj/item/clothing/armor/medium/scale/inqcoat/armored(src)
	new /obj/item/clothing/head/leather/inqhat(src)
	new /obj/item/clothing/armor/medium/scale/inqcoat/armored(src)
	new /obj/item/clothing/head/leather/inqhat(src)
	new /obj/item/clothing/armor/medium/scale/inqcoat/armored(src)

/datum/inqports/wardrobe/inspector
	name = "The Inquisitorial Inspector's Best Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector
	marquescost = 18

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector/Initialize()
	. = ..()
	new /obj/item/clothing/head/leather/inqhat(src)
	new /obj/item/clothing/armor/medium/scale/inqcoat/armored(src)
	new /obj/item/clothing/gloves/leather/otavan/inqgloves(src)
	new /obj/item/clothing/shoes/otavan/inqboots(src)

/datum/inqports/wardrobe/fencersthree
	name = "The Fencer's Gambeson Three-Pack"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree
	marquescost = 16

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree/Initialize()
	. = ..()
	new /obj/item/clothing/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/armor/gambeson/heavy/otavan/inq(src)

/datum/inqports/wardrobe/psydonianstandard
	name = "The Inquisitorial Standard"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian/Initialize()
	. = ..()
	new /obj/item/clothing/pants/tights/colored/black(src)
	new /obj/item/clothing/armor/gambeson/heavy/inq(src)
	new /obj/item/clothing/gloves/leather/otavan(src)
	new /obj/item/clothing/shoes/psydonboots(src)

/datum/inqports/wardrobe/nobledressup
	name = "The Cost of Nobility Crate"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup
	marquescost = 24

/obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup/Initialize()
	. = ..()
	new /obj/item/clothing/cloak/lordcloak/ladycloak(src)
	new /obj/item/clothing/cloak/lordcloak(src)
	new /obj/item/clothing/shirt/tunic/noblecoat(src)
	new /obj/item/clothing/shirt/dress/royal(src)
	new /obj/item/clothing/wrists/royalsleeves(src)
	new /obj/item/clothing/shirt/dress/royal/prince(src)

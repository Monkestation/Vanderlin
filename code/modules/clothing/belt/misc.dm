/obj/item/storage/belt/leather
	name = "belt"
	desc = "A leather belt."
	icon_state = "leather"
	item_state = "leather"
	equip_sound = 'sound/blank.ogg'
	var/empty_when_dropped = TRUE

/obj/item/storage/belt/leather/dropped(mob/user, silent)
	. = ..()
	if(QDELETED(src))
		return

	if(!empty_when_dropped)
		return

	atom_storage?.remove_all(get_turf(src))

/obj/item/storage/belt/leather/assassin // Assassin's super edgy and cool belt can carry normal items (for poison vial, lockpick).
	empty_when_dropped = FALSE
	storage_type = /datum/storage/belt/assassin

/obj/item/storage/belt/leather/assassin/populate_contents()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/poison(src)
	new /obj/item/weapon/knife/dagger/steel/profane(src)
	new /obj/item/lockpick(src)

//Bandit's belt starts with a simple needle and a key to their hideout.

/obj/item/storage/belt/leather/bandit/populate_contents()
	new /obj/item/needle/thorn(src)
	new /obj/item/key/bandit(src)

//Adventurer's belt start with a needle, cloth and just that, good luck buddy

/obj/item/storage/belt/leather/adventurer/populate_contents()
	new /obj/item/needle/thorn(src)
	new /obj/item/natural/cloth(src)

//Garrison's belt starts with a simple needle, and a key to their hideout.

/obj/item/storage/belt/leather/fgarrison/populate_contents()
	new /obj/item/needle/thorn(src)
	new /obj/item/key/forrestgarrison(src)

//they get their keys + dagger there
/obj/item/storage/belt/leather/townguard/populate_contents()
	new /obj/item/weapon/knife/dagger/steel/special(src)
	new /obj/item/storage/keyring/guard(src)

// Bandit's belt starts with a bandage and a key to their guildhall.
/obj/item/storage/belt/leather/mercenary/populate_contents()
	new /obj/item/natural/cloth(src)
	new /obj/item/key/mercenary(src)

/obj/item/storage/belt/leather/mercenary/shalal
	name = "shalal belt"
	icon_state = "shalal"

/obj/item/storage/belt/leather/mercenary/black
	name = "black belt"
	icon_state = "blackbelt"

/obj/item/storage/belt/leather/plaquegold
	name = "plaque belt"
	desc = "A belt with a golden plaque on its front."
	icon_state = "goldplaque"
	sellprice = 50

/obj/item/storage/belt/leather/shalal
	name = "shalal belt"
	icon_state = "shalal"
	sellprice = 5

/obj/item/storage/belt/leather/black
	name = "black belt"
	icon_state = "blackbelt"
	sellprice = 10

/obj/item/storage/belt/leather/plaquesilver
	name = "plaque belt"
	desc = "A belt with a silver plaque on its front."
	icon_state = "silverplaque"
	sellprice = 30

/obj/item/storage/belt/leather/plaquesilver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/storage/belt/leather/steel
	name = "steel belt"
	desc = "A belt with a steel plate on its front."
	icon_state = "steelplaque"
	sellprice = 30

/obj/item/storage/belt/leather/rope
	name = "rope belt"
	desc = "A simple belt made of rope."
	icon_state = "rope"
	item_state = "rope"
	color = "#b9a286"
	salvage_result = /obj/item/rope
	storage_type = /datum/storage/belt/cloth

/obj/item/storage/belt/leather/rope/attack_self(mob/user, params)
	. = ..()
	to_chat(user, span_notice("You begin untying [src]."))
	if(do_after(user, 1.5 SECONDS, src))
		qdel(src)
		user.put_in_active_hand(new salvage_result(get_turf(user)))

/obj/item/storage/belt/leather/rope/dark
	color = "#505050"

/obj/item/storage/belt/leather/suspenders
	name = "suspenders"
	desc = "A pair of suspenders which go over the shoulders. Used for keeping one's pants in place in an admittably fashionable style."
	icon_state = "suspenders"
	alternate_worn_layer = ARMOR_LAYER

/obj/item/storage/belt/leather/cloth_belt
	name = "cloth belt"
	desc = "This belt has been sewn out of cloth, as opposed to tied. Which makes it superior. Obviously."
	icon_state = "clothsash"
	salvage_result = /obj/item/natural/cloth

/obj/item/storage/belt/leather/cloth
	name = "cloth sash"
	desc = "A simple cloth sash."
	icon_state = "cloth"
	salvage_result = /obj/item/natural/cloth
	storage_type = /datum/storage/belt/cloth

/obj/item/storage/belt/leather/cloth/attack_self(mob/user, params)
	. = ..()
	to_chat(user, span_notice("You begin untying [src]."))
	if(do_after(user, 1.5 SECONDS, src))
		qdel(src)
		user.put_in_active_hand(new salvage_result(get_turf(user)))

/obj/item/storage/belt/leather/cloth/lady
	color = "#575160"

/obj/item/storage/belt/leather/cloth/bandit
	color = "#ff0000"

/obj/item/storage/belt/pouch
	name = "pouch"
	desc = "Usually used for holding coins."
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "pouch"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	fiber_salvage = FALSE
	storage_type = /datum/storage/coin_pouch
	grid_height = 64
	grid_width = 32

/obj/item/storage/belt/pouch/coins/mid/populate_contents()
	. = ..()
	new /obj/item/coin/copper/pile(src)
	new /obj/item/coin/silver/pile(src)

/obj/item/storage/belt/pouch/coins/poor/populate_contents()
	new /obj/item/coin/copper/pile(src)
	new /obj/item/coin/copper/pile(src)
	if(prob(50))
		new /obj/item/coin/copper/pile(src)

/obj/item/storage/belt/pouch/coins/rich/populate_contents()
	new /obj/item/coin/silver/pile(src)
	new /obj/item/coin/silver/pile(src)
	if(prob(50))
		new /obj/item/coin/silver/pile(src)

/obj/item/storage/belt/pouch/coins/veryrich/populate_contents()
	new /obj/item/coin/gold/pile(src)
	new /obj/item/coin/gold/pile(src)
	if(prob(50))
		new /obj/item/coin/gold/pile(src)

/obj/item/storage/belt/pouch/bullets/populate_contents()
	for(var/i in 1 to 4)
		new /obj/item/ammo_casing/caseless/bullet(src)

/obj/item/storage/belt/pouch/cloth
	name = "cloth pouch"
	desc = "Usually used for holding small amount of coins."
	icon_state = "clothpouch"
	salvage_result = /obj/item/natural/cloth
	storage_type = /datum/storage/coin_pouch/cloth

//Poison darts pouch
/obj/item/storage/belt/pouch/pdarts/populate_contents()
	for(var/i in 1 to 4)
		new /obj/item/ammo_casing/caseless/dart/poison(src)

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A bulky bag worn over the shoulder which can be used to hold many things."
	icon_state = "satchel"
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	storage_type = /datum/storage/satchel

/obj/item/storage/backpack/satchel/cloth
	name = "cloth knapsack"
	desc = "A rudimentary cloth sack strapped to the back for storing small amounts of items."
	icon_state = "clothbackpack"
	item_state = "clothbackpack"
	salvage_result = /obj/item/natural/cloth
	storage_type = /datum/storage/satchel/cloth

/obj/item/storage/backpack/satchel/heartfelt/populate_contents()
	new /obj/item/natural/feather(src)
	new /obj/item/paper/heartfelt(src)

/obj/item/storage/backpack/satchel/otavan
	name = "grenzelhoftian leather satchel"
	desc = "A made to last leather bag from the Psydonian heart of Grenzelhoft. It's Grenzelhoft's finest."
	icon_state = "osatchel"
	item_state = "osatchel"

/obj/item/storage/backpack/satchel/mule/populate_contents()
	for(var/i in 1 to 3)
		switch(rand(1,4))
			if(1)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(2)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(3)
				new /obj/item/reagent_containers/powder/ozium(src)
			if(4)
				new /obj/item/reagent_containers/powder/spice(src)

/obj/item/storage/backpack/satchel/black
	color = CLOTHING_SOOT_BLACK

/obj/item/storage/backpack/backpack
	name = "backpack"
	desc = "A bulky backpack worn on the back which can store many items."
	icon_state = "backpack"
	item_state = "backpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = NONE
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	storage_type = /datum/storage/backpack

/obj/item/storage/backpack/backpack/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/storage/backpack/backpack/artibackpack
	name = "cooling backpack"
	desc = "A leather backpack with complex bronze pipework coursing through it. It hums and vibrates constantly."
	icon_state = "artibackpack"
	item_state = "artibackpack"
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	//for those curious, yes the artibackpack preserves organs and food. Check _organ.dm and snacks.dm

/obj/item/storage/backpack/backpack/artibackpack/porter
	name = "humdrum"
	desc = "A absurdly oversized backpack with complex bronze pipework coursing through it. It hums and vibrates constantly."
	sewrepair = TRUE //Kobold thing, trust.
	storage_type = /datum/storage/porter

/obj/item/storage/backpack/satchel/surgbag
	name = "surgery bag"
	desc = "Contains all the phreakish devices one needs to cut a person up."
	item_state = "doctorbag"
	icon_state = "doctorbag"
	attack_verb = list("beats", "bludgeons")
	storage_type = /datum/storage/surgery_bag

/obj/item/storage/backpack/satchel/surgbag/populate_contents()
	new /obj/item/needle/blessed(src)
	new /obj/item/weapon/surgery/scalpel(src)
	new /obj/item/weapon/surgery/saw(src)
	new /obj/item/weapon/surgery/hemostat(src)
	new /obj/item/weapon/surgery/hemostat(src)
	new /obj/item/weapon/surgery/retractor(src)
	new /obj/item/weapon/surgery/bonesetter(src)
	new /obj/item/weapon/surgery/cautery(src)
	new /obj/item/natural/worms/leech/parasite(src)
	new /obj/item/weapon/surgery/hammer(src)

/obj/item/surgeontoolspawner
	name = "set of surgery tools"

/obj/item/surgeontoolspawner/OnCrafted(dirin, mob/user)
	. = ..()
	new /obj/item/weapon/surgery/scalpel(loc)
	new /obj/item/weapon/surgery/saw(loc)
	//two hemostats because one is needed to clamp bleeders, the other is needed to actually remove stuff with it
	new /obj/item/weapon/surgery/hemostat(loc)
	new /obj/item/weapon/surgery/hemostat(loc)
	new /obj/item/weapon/surgery/retractor(loc)
	new /obj/item/weapon/surgery/bonesetter(loc)
	new /obj/item/weapon/surgery/cautery(loc)
	new /obj/item/weapon/surgery/hammer(loc)
	qdel(src)

/obj/item/storage/backpack/satchel/surgbag/shit/populate_contents()
	new /obj/item/weapon/surgery/scalpel(src)
	new /obj/item/weapon/surgery/saw(src)
	new /obj/item/weapon/surgery/hemostat(src)
	new /obj/item/weapon/surgery/hemostat(src)
	new /obj/item/weapon/surgery/retractor(src)
	new /obj/item/weapon/surgery/bonesetter(src)
	new /obj/item/weapon/surgery/cautery(src)
	new /obj/item/weapon/surgery/hammer(src)
	new /obj/item/natural/worms/leech(src)
	new /obj/item/natural/worms/leech(src)
	new /obj/item/natural/bundle/fibers/half(src)

/obj/item/storage/backpack/satchel/musketeer/populate_contents()
	new /obj/item/weapon/knife/dagger/bayonet(src)
	new /obj/item/reagent_containers/glass/bottle/aflask(src)
	new /obj/item/storage/belt/pouch/coins/poor(src)

/obj/item/storage/belt/leather/knifebelt
	name = "tossblade belt"
	desc = "A many-slotted belt meant for tossblades. Little room left over."
	icon_state = "knife"
	item_state = "knife"
	strip_delay = 20
	var/max_storage = 8
	sewrepair = TRUE
	storage_type = /datum/storage/belt/knife_belt
	empty_when_dropped = FALSE

/obj/item/storage/belt/leather/knifebelt/attackby(obj/A, mob/living/user, params)
	if(istype(A, /obj/item/weapon/knife/throwingknife))
		if(atom_storage.attempt_insert(A, user))
			to_chat(user, span_notice("I discreetly slip [A] into [src]."))
		return TRUE
	. = ..()

/obj/item/storage/belt/leather/knifebelt/attack_hand_secondary(mob/user, params)
	. = ..()
	if(length(contents))
		return
	var/list/knives = list()
	atom_storage.remove_type(/obj/item/weapon/knife/throwingknife, get_turf(user), 1, TRUE, user, knives)
	for(var/knife in knives)
		if(!user.put_in_active_hand(knife))
			break
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/belt/leather/knifebelt/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] inside.")

/obj/item/storage/belt/leather/knifebelt/iron/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife(src)

/obj/item/storage/belt/leather/knifebelt/steel/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife/steel(src)

/obj/item/storage/belt/leather/knifebelt/psydon/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife/psydon(src)

/obj/item/storage/belt/leather/knifebelt/black
	icon_state = "blackknife"
	item_state = "blackknife"

/obj/item/storage/belt/leather/knifebelt/black/iron/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife(src)

/obj/item/storage/belt/leather/knifebelt/black/steel/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife/steel(src)

/obj/item/storage/belt/leather/knifebelt/black/psydon/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife/psydon(src)

/obj/item/storage/belt/leather/knifebelt/black/rous/populate_contents()
	for(var/i in 1 to max_storage)
		new /obj/item/weapon/knife/throwingknife/rous(src)

///////////////////////////////////////////////

/obj/item/storage/hip/headhook
	name = "head hook"
	desc = "an iron hook for storing 6 heads"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi' //N/A uncomment when a mob_overlay icon is made and added
	icon_state = "ironheadhook"
	item_state = "ironheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/iron
	storage_type = /datum/storage/headhook

/obj/item/storage/hip/headhook/bronze
	name = "bronze head hook"
	desc = "a bronze hook for storing 12 heads"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi' // TODO
	icon_state = "bronzeheadhook"
	item_state = "bronzeheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/bronze
	storage_type = /datum/storage/headhook/bronze

/obj/item/storage/hip/headhook/attackby(obj/item/H, mob/user, params)
	. = ..()
	user.visible_message("[user] tries to put [H] into [src].", "You try to put [H] into [src].")

/obj/item/storage/hip/headhook/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] thing[length(contents) > 1 ? "s" : ""] in [src].")

/obj/item/storage/hip/headhook/royal
	name = "royal head hook"
	desc = "a golden hook for storing 16 heads, befitting of any king's hunt"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi' // TODO
	icon_state = "goldheadhook" // coder sprite  , if you can improve it would be nice
	item_state = "goldheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	sellprice = 160
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/gold
	storage_type = /datum/storage/headhook/bronze

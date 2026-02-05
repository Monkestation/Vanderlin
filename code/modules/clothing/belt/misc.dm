/obj/item/storage/belt/leather
	name = "belt"
	desc = "A leather belt."
	icon_state = "leather"
	item_state = "leather"
	equip_sound = 'sound/blank.ogg'
	var/empty_when_dropped = TRUE

/obj/item/storage/belt/leather/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	if(!empty_when_dropped)
		return
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/storage/belt/leather/assassin // Assassin's super edgy and cool belt can carry normal items (for poison vial, lockpick).
	empty_when_dropped = FALSE
	component_type = /datum/component/storage/concrete/grid/belt/assassin

	populate_contents = list(
		/obj/item/reagent_containers/glass/bottle/poison,
		/obj/item/weapon/knife/dagger/steel/profane,
		/obj/item/lockpick,
	)

//Bandit's belt starts with a simple needle and a key to their hideout.

/obj/item/storage/belt/leather/bandit
	populate_contents = list(
		/obj/item/needle/thorn,
		/obj/item/key/bandit,
	)


//Adventurer's belt start with a needle, cloth and just that, good luck buddy

/obj/item/storage/belt/leather/adventurer
	populate_contents = list(
		/obj/item/needle/thorn,
		/obj/item/natural/cloth,
	)


//Garrison's belt starts with a simple needle, and a key to their hideout.

/obj/item/storage/belt/leather/fgarrison
	populate_contents = list(
		/obj/item/needle/thorn,
		/obj/item/key/forrestgarrison,
	)

/obj/item/storage/belt/leather/townguard //they get their keys + dagger there
	populate_contents = list(
		/obj/item/weapon/knife/dagger/steel/special,
		/obj/item/storage/keyring/guard,
	)

// Bandit's belt starts with a bandage and a key to their guildhall.
/obj/item/storage/belt/leather/mercenary
	populate_contents = list(
		/obj/item/natural/cloth,
		/obj/item/key/mercenary,
	)

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
	component_type = /datum/component/storage/concrete/grid/belt/cloth

/obj/item/storage/belt/leather/rope/attack_self(mob/user, list/modifiers)
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
	component_type = /datum/component/storage/concrete/grid/belt/cloth

/obj/item/storage/belt/leather/cloth/attack_self(mob/user, list/modifiers)
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
	component_type = /datum/component/storage/concrete/grid/coin_pouch
	grid_height = 64
	grid_width = 32

/obj/item/storage/belt/pouch/coins/mid/Initialize()
	. = ..()
	var/obj/item/coin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/coin/copper/pile/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/pouch/coins/poor/Initialize()
	. = ..()
	var/obj/item/coin/copper/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/pouch/coins/rich/Initialize()
	. = ..()
	var/obj/item/coin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/pouch/coins/veryrich/Initialize()
	. = ..()
	var/obj/item/coin/gold/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/pouch/bullets
	populate_contents = list(
		/obj/item/ammo_casing/caseless/bullet,
		/obj/item/ammo_casing/caseless/bullet,
		/obj/item/ammo_casing/caseless/bullet,
		/obj/item/ammo_casing/caseless/bullet,
	)

/obj/item/storage/belt/pouch/cloth
	name = "cloth pouch"
	desc = "Usually used for holding small amount of coins."
	icon_state = "clothpouch"
	salvage_result = /obj/item/natural/cloth
	component_type = /datum/component/storage/concrete/grid/coin_pouch/cloth

//Poison darts pouch
/obj/item/storage/belt/pouch/pdarts
	populate_contents = list(
		/obj/item/ammo_casing/caseless/dart/poison,
		/obj/item/ammo_casing/caseless/dart/poison,
		/obj/item/ammo_casing/caseless/dart/poison,
		/obj/item/ammo_casing/caseless/dart/poison,
	)

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
	component_type = /datum/component/storage/concrete/grid/satchel

/obj/item/storage/backpack/satchel/cloth
	name = "cloth knapsack"
	desc = "A rudimentary cloth sack strapped to the back for storing small amounts of items."
	icon_state = "clothbackpack"
	item_state = "clothbackpack"
	salvage_result = /obj/item/natural/cloth
	component_type = /datum/component/storage/concrete/grid/satchel/cloth

/obj/item/storage/backpack/satchel/heartfelt
	populate_contents = list(
		/obj/item/natural/feather,
		/obj/item/paper/heartfelt,
	)

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
	component_type = /datum/component/storage/concrete/grid/backpack

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
	component_type = /datum/component/storage/concrete/grid/porter

/obj/item/storage/backpack/satchel/surgbag
	name = "surgery bag"
	desc = "Contains all the phreakish devices one needs to cut a person up."
	item_state = "doctorbag"
	icon_state = "doctorbag"
	attack_verb = list("beats", "bludgeons")
	populate_contents = list(
		/obj/item/needle/blessed,
		/obj/item/weapon/surgery/scalpel,
		/obj/item/weapon/surgery/saw,
		/obj/item/weapon/surgery/hemostat,
		/obj/item/weapon/surgery/hemostat,
		/obj/item/weapon/surgery/retractor,
		/obj/item/weapon/surgery/bonesetter,
		/obj/item/weapon/surgery/cautery,
		/obj/item/natural/worms/leech/parasite,
		/obj/item/weapon/surgery/hammer,
	)
	component_type = /datum/component/storage/concrete/grid/surgery_bag

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

/obj/item/storage/backpack/satchel/surgbag/shit
	populate_contents = list(
		/obj/item/needle,
		/obj/item/weapon/surgery/scalpel,
		/obj/item/weapon/surgery/saw,
		/obj/item/weapon/surgery/hemostat,
		/obj/item/weapon/surgery/hemostat,
		/obj/item/weapon/surgery/retractor,
		/obj/item/weapon/surgery/bonesetter,
		/obj/item/weapon/surgery/cautery,
		/obj/item/natural/worms/leech,
		/obj/item/natural/worms/leech,
		/obj/item/weapon/surgery/hammer,
		/obj/item/natural/bundle/fibers/full,
	)

/obj/item/storage/backpack/satchel/musketeer
	populate_contents = list(
		/obj/item/weapon/knife/dagger/bayonet,
		/obj/item/storage/belt/pouch/coins/poor,
		/obj/item/reagent_containers/glass/bottle/aflask
	)

/obj/item/storage/belt/leather/knifebelt
	name = "tossblade belt"
	desc = "A many-slotted belt meant for tossblades. Little room left over."
	icon_state = "knife"
	item_state = "knife"
	strip_delay = 20
	var/max_storage = 8
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/grid/belt/knife_belt
	empty_when_dropped = FALSE

/obj/item/storage/belt/leather/knifebelt/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isturf(attacked_atom))
		return ..()

	. = TRUE
	if(length(contents) >= max_storage)
		to_chat(user, span_warning("Your [src.name] is full!"))
		return
	var/turf/T = attacked_atom
	to_chat(user, span_notice("You begin to gather the ammunition..."))
	for(var/obj/item/weapon/knife/throwingknife/knife in T.contents)
		if(do_after(user, 5 DECISECONDS))
			if(!eat_knife(knife))
				break

/obj/item/storage/belt/leather/knifebelt/proc/eat_knife(obj/A)
	if(A.type in typesof(/obj/item/weapon/knife/throwingknife))
		if(length(contents) < max_storage)
			return SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, FALSE)

/obj/item/storage/belt/leather/knifebelt/attackby(obj/A, mob/living/user, list/modifiers)
	if(A.type in typesof(/obj/item/weapon/knife/throwingknife))
		if(SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, user, TRUE))
			to_chat(usr, span_notice("I discreetly slip [A] into [src]."))
		else
			to_chat(loc, span_warning("Full!"))
		return TRUE
	. = ..()

/obj/item/storage/belt/leather/knifebelt/attack_hand_secondary(mob/user, list/modifiers)
	if(length(contents))
		var/list/knives = list()
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE_TYPE, /obj/item/weapon/knife/throwingknife, drop_location(), amount = 1, check_adjacent = TRUE, user = user, inserted = knives)
		for(var/knife in knives)
			if(!user.put_in_active_hand(knife))
				break
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	. = ..()

/obj/item/storage/belt/leather/knifebelt/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] inside.")

/obj/item/storage/belt/leather/knifebelt/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/steel/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/steel/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/psydon/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/psydon/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/black
	icon_state = "blackknife"
	item_state = "blackknife"

/obj/item/storage/belt/leather/knifebelt/black/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/black/steel/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/steel/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/black/psydon/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/psydon/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

/obj/item/storage/belt/leather/knifebelt/black/rous/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/weapon/knife/throwingknife/rous/A = new(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			qdel(A)

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
	component_type = /datum/component/storage/concrete/grid/headhook

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
	component_type = /datum/component/storage/concrete/grid/headhook/bronze


/obj/item/storage/hip/headhook/attackby(obj/item/H, mob/user, list/modifiers)
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
	component_type = /datum/component/storage/concrete/grid/headhook/bronze

/obj/item/orphan_toy
	icon = 'icons/obj/orphanage.dmi'
	desc = "A robust carved wooden toy."
	force = 0
	w_class = WEIGHT_CLASS_TINY
	smeltresult = /obj/item/fertilizer/ash
	sellprice = 0
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	resistance_flags = FLAMMABLE
	abstract_type = /obj/item/orphan_toy
	item_weight = 100 GRAMS

/obj/item/orphan_toy/knight
	name = "toy knight"
	icon_state = "toy_knight"

/obj/item/orphan_toy/wizard
	name = "toy wizard"
	icon_state = "toy_wizard"

/obj/item/orphan_toy/bard
	name = "toy bard"
	icon_state = "toy_bard"

/obj/item/orphan_toy/wolf
	name = "toy volf"
	icon_state = "toy_wolf"

/obj/item/orphan_toy/saiga
	name = "toy saiga"
	icon_state = "toy_saiga"

/obj/item/orphan_toy/goblin
	name = "toy goblin"
	icon_state = "toy_goblin"

/obj/item/orphan_toy/dragon
	name = "toy dragon"
	icon_state = "toy_dragon"

/obj/item/orphan_toy/skeleton
	name = "toy skeleton"
	icon_state = "toy_skeleton"

/obj/item/clothing/head/crown/wooden
	name = "wooden crown"
	desc = "Truly you are the master of all."
	icon = 'icons/obj/orphanage.dmi'
	icon_state = "wooden_crown"
	sellprice = 0

/obj/item/child_toy
	icon = 'icons/obj/toy.dmi'
	force = 0
	w_class = WEIGHT_CLASS_TINY
	smeltresult = /obj/item/fertilizer/ash
	sellprice = 0
	resistance_flags = FLAMMABLE
	abstract_type = /obj/item/child_toy
	item_weight = 100 GRAMS
	dyeable = TRUE
	var/hugable = FALSE
	var/named = FALSE
	var/has_storage = FALSE
	var/storage_component_path = /datum/component/storage/concrete/grid/coin_pouch/cloth

/obj/item/child_toy/attack_self(mob/living/user)
		if(!hugable)
				return

		user.add_stress(/datum/stress_event/hug)
		playsound(user, pick('sound/vo/hug.ogg'), 100, FALSE, -1)
		visible_message(span_emote("[user] hugs [src.name]."), span_emote("I hug [src.name]."))

/obj/item/child_toy/stick_doll
	name = "stick doll"
	desc = "It can be either beloved toy of a child or tool of malicious ritual."
	icon_state = "stickd"

/obj/item/child_toy/ball
	name = "leather ball"
	desc = "It is said that kicking a ball is the favourite game of the Orcish clans... especially the brawl after it."
	icon_state = "ball"
	drop_sound = 'sound/items/basketball_bounce.ogg'
	mob_throw_hit_sound = 'sound/items/basketball_bounce.ogg'

/obj/item/child_toy/soft_toy
	abstract_type = /obj/item/child_toy/soft_toy
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	item_weight = 100 GRAMS
	hugable = TRUE

/obj/item/child_toy/soft_toy/attackby(obj/item/W, mob/user, list/modifiers)
	if(!user.is_literate())
		to_chat(user, span_warning("I don't know how to read or write."))
		return
	if(istype(W, /obj/item/needle))
		if(named)
			to_chat(user, span_warning("It is already named."))
		else
			var/n_name = browser_input_text(usr, "what would you like to name your toy?", "Toy Naming", null, MAX_NAME_LEN)
			if(n_name && !named)
				named = n_name
				name = "[(n_name ? "[n_name]" : null)]"
		return
	..()
	update_appearance(UPDATE_NAME)

/obj/item/child_toy/soft_toy/bear
	name = "bear doll"
	desc = "Dangerous only to nitemares."
	icon_state = "bear"

/obj/item/child_toy/soft_toy/doll
	name = "doll"
	desc = "She can be anything."
	icon_state = "doll"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_BLUE

/obj/item/child_toy/soft_toy/kobold
	desc = "It has a opening so you can keep all your treasures in his tummy."
	has_storage = TRUE
	storage_component_path = /datum/component/storage/concrete/grid/coin_pouch/cloth
	abstract_type = /obj/item/child_toy/soft_toy/kobold

/obj/item/child_toy/soft_toy/kobold/Initialize(mapload, ...)
	. = ..()
	if(has_storage && storage_component_path)
		AddComponent(storage_component_path)

/obj/item/child_toy/soft_toy/kobold/amber
	name = "amberhide kobold doll"
	icon_state = "amberhide"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/soft_toy/kobold/moon
	name = "moonshade kobold doll"
	icon_state = "moonshade"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/soft_toy/kobold/stone
	name = "stonepaw kobold doll"
	icon_state = "stonepaw"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/soft_toy/kobold/sun
	name = "sunstreak kobold doll"
	icon_state = "sunstreak"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/soft_toy/kobold/sand
	name = "sandswept kobold doll"
	icon_state = "sandswept"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/soft_toy/kobold/ice
	name = "icepack kobold doll"
	icon_state = "icepack"
	detail_tag = "_detail"
	detail_color = COLOR_ASSEMBLY_GREEN

/obj/item/child_toy/toy_soldier
	melting_material = /datum/material/tin
	melt_amount = 20
	resistance_flags = FIRE_PROOF
	abstract_type = /obj/item/child_toy/toy_soldier
	item_weight = 5 GRAMS
	var/open = FALSE

/obj/item/child_toy/toy_soldier/attackby(obj/item/G, mob/user, list/modifiers)
	if(!user.is_literate())
		to_chat(user, span_warning("I don't know how to read or write."))
		return
	if(istype(G, /obj/item/weapon/chisel))
		if(named)
			to_chat(user, span_warning("It is already named."))
		else
			var/n_name = browser_input_text(usr, "what would you like to name your toy?", "Toy Naming", null, MAX_NAME_LEN)
			if(n_name && !named)
				named = n_name
				name = "[(n_name ? "[n_name]" : null)]"
				update_appearance(UPDATE_NAME)
		return
	..()

/obj/item/child_toy/toy_soldier/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][open ? "-alt" : ""]"

/obj/item/child_toy/toy_soldier/attack_self(mob/user, list/modifiers)
	open = !open
	update_appearance(UPDATE_ICON)

/obj/item/child_toy/toy_soldier/soldier
	name = "tin toy soldier"
	desc = "The infantry, the backbone of every army, make sure they are well supplied."
	icon_state = "tsoldier"

/obj/item/child_toy/toy_soldier/rider
	name = "tin toy rider"
	desc = "No force is ready for suprises, meneuver warfare does wonders with good flank."
	icon_state = "trider"

/obj/item/child_toy/toy_soldier/canon
	name = "tin canon"
	desc = "Castles were formidable in the past, however those daes are long gone."
	icon_state = "tcan"

/obj/item/child_toy/toy_soldier/archer
	name = "tin toy archer"
	desc = "Even from afar the enemy is not safe, degrade their forces before they have chance to strike."
	icon_state = "tarcher"

/obj/item/child_toy/toy_soldier/magos
	name = "tin toy magos"
	desc = "Some might consider the use of magick undignified, however this is no longer the age of chivalry."
	icon_state = "tmagos"


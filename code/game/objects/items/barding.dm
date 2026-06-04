/obj/item/clothing/barding
	name = "padded barding"
	desc = "A set of padded body armor for a Saiga, designed to protect your mount's vital organs."
	slot_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "sewingkit"
	var/barding_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	var/barding_state = "barding"
	var/female_barding_state = "barding-f"
	gender = NEUTER
	var/list/valid_animal_types = list(
		/mob/living/simple_animal/hostile/retaliate/saiga
	)
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = /datum/attribute/skill/misc/sewing/mending
	dyeable = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	fiber_salvage = TRUE
	integrity_failure = 0.1
	item_weight = 3 KILOGRAMS

/obj/item/clothing/barding/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /mob/living/simple_animal))
		return NONE

	if(!is_type_in_list(interacting_with, valid_animal_types))
		to_chat(user, span_warning("\The [src] cannot be used on [interacting_with]! It is only meant for specific animals."))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/simple_animal/animal = interacting_with
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal] is a juvenile and cannot wear a bard!"))
		return ITEM_INTERACT_BLOCKING

	if(animal.bbarding)
		to_chat(user, span_warning("[animal] is already wearing a bard!"))
		return ITEM_INTERACT_BLOCKING

	if(!animal.ssaddle)
		to_chat(user, span_warning("[animal] needs to be saddled before you can fit a bard onto it!"))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] is fitting a bard onto [animal]..."), span_notice("I start fitting a bard onto [animal]..."))
	if(!do_after(user, 5 SECONDS, animal))
		return ITEM_INTERACT_BLOCKING

	animal.bbarding = src
	forceMove(animal)
	animal.update_appearance(UPDATE_ICON)
	user.visible_message(span_notice("[user] fits a bard onto [animal]."), span_notice("I fit a bard onto [animal]."))

	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/barding/atom_break(damage_flag)
	. = ..()
	if(istype(loc, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = loc
		if(A.bbarding == src)
			A.bbarding = null
	. = ..()

/obj/item/clothing/barding/chain
	name = "chainmail barding"
	desc = "A set of chainmail body armor for a Saiga, designed to protect your mount's vital organs."
	icon_state = "armorkit"
	barding_state = "barding_chain"
	female_barding_state = "barding_chain-f"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	smeltresult = /obj/item/ingot/steel_slag
	sewrepair = null
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	item_weight = 8 KILOGRAMS

/obj/item/clothing/barding/honse
	name = "padded barding"
	desc = "A set of padded body armor for a Honse, designed to protect your mount's vital organs."
	icon_state = "sewingkit"
	barding_icon = 'icons/mob/monster/fogbeast.dmi'
	barding_state = "barding"
	female_barding_state = "barding"
	valid_animal_types = list(
		/mob/living/simple_animal/hostile/retaliate/honse
	)
	item_weight = 4 KILOGRAMS

/obj/item/clothing/barding/honse/chain
	name = "chainmail barding"
	desc = "A set of chainmail body armor for a Honse, designed to protect your mount's vital organs."
	icon_state = "armorkit"
	barding_state = "barding_chain"
	female_barding_state = "barding_chain"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	melting_material = /datum/material/steel
	melt_amount = 80
	sewrepair = null
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	item_weight = 10 KILOGRAMS

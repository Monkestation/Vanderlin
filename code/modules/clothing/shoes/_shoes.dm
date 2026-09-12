/obj/item/clothing/shoes
	name = "shoes"
	desc = "Typical shoes worn by almost anyone."
	gender = PLURAL //Carn: for grammarically correct text-parsing

	icon = 'icons/roguetown/clothing/feet.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/feet.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/feet.dmi'
	sleevetype = "leg"
	bloody_icon_state = "shoeblood"

	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	body_parts_covered = FEET
	slot_flags = ITEM_SLOT_SHOES
	prevent_crits = list(BCLASS_LASHING, BCLASS_TWIST)
	resistance_flags = FLAMMABLE

	permeability_coefficient = 0.5
	slowdown = 0
	strip_delay = 1 SECONDS
	equip_delay_self = 3 SECONDS

	grid_width = 64
	grid_height = 32

	smeltresult = /obj/item/fertilizer/ash
	sellprice = 5
	item_weight = 0.9 KILOGRAMS

	var/blood_state = BLOOD_STATE_NOT_BLOODY
	var/list/bloody_shoes = list(BLOOD_STATE_MUD = 0, BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	var/offset = 0
	var/equipped_before_drop = FALSE
	var/can_be_bloody = TRUE
	var/is_barefoot = FALSE
	var/chained = 0
	abstract_type = /obj/item/clothing/shoes
	var/polished = 0

/obj/item/clothing/shoes/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_blood))

/obj/item/clothing/shoes/suicide_act(mob/living/carbon/user)
	if(rand(2)>1)
		user.visible_message("<span class='suicide'>[user] begins tying \the [src] up waaay too tightly! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		var/obj/item/bodypart/l_leg = user.get_bodypart(BODY_ZONE_L_LEG)
		var/obj/item/bodypart/r_leg = user.get_bodypart(BODY_ZONE_R_LEG)
		if(l_leg)
			l_leg.dismember()
		if(r_leg)
			r_leg.dismember()
		return BRUTELOSS
	else//didnt realize this suicide act existed (was in miscellaneous.dm) and didnt want to remove it, so made it a 50/50 chance. Why not!
		user.visible_message("<span class='suicide'>[user] is bashing [user.p_their()] own head in with [src]! Ain't that a kick in the head?</span>")
		for(var/i = 0, i < 3, i++)
			sleep(3)
			playsound(user, 'sound/blank.ogg', 50, TRUE)
		return(BRUTELOSS)

/obj/item/clothing/shoes/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(offset && (slot_flags & slot))
		user.pixel_y += offset
		worn_y_dimension -= (offset * 2)
		user.update_inv_shoes()
		equipped_before_drop = TRUE
	if(slot_flags & slot)
		if(!user.has_stress_type(/datum/stress_event/shiny_shoes) && !user.has_stress_type(/datum/stress_event/extra_shiny_shoes))
			if(polished == 1)
				user.add_stress(/datum/stress_event/shiny_shoes)
			else if(polished == 2)
				user.add_stress(/datum/stress_event/extra_shiny_shoes)

/obj/item/clothing/shoes/proc/restore_offsets(mob/user)
	equipped_before_drop = FALSE
	user.pixel_y -= offset
	worn_y_dimension = world.icon_size

/obj/item/clothing/shoes/dropped(mob/user)
	if(offset && equipped_before_drop)
		restore_offsets(user)
	. = ..()

/obj/item/clothing/shoes/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/proc/clean_blood(datum/source, strength)
	if(strength < CLEAN_TYPE_BLOOD)
		return
	bloody_shoes = list(BLOOD_STATE_MUD = 0,BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	blood_state = BLOOD_STATE_NOT_BLOODY
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/proc/negates_gravity()
	return FALSE

/obj/item/clothing/shoes/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(item_flags & IN_INVENTORY)
		return NONE

	if(user.cmode)
		return NONE

	if(istype(tool, /obj/item/natural/cloth))
		if(polished)
			to_chat(user, span_notice("\The [name] are already polished."))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/natural/cloth/rag = tool
		if(rag.reagents.total_volume < 0.1)
			to_chat(user, span_warning("[rag] is too dry to polish with!"))
			return ITEM_INTERACT_BLOCKING

		var/dirty_water = rag.reagents?.get_reagent_amount(/datum/reagent/water/gross)
		if(dirty_water)
			to_chat(user, span_warning("[rag] is too dirty to polish anything with it!"))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, ("I start polishing \the [name] with \the [rag.name]"))

		if(do_after(user, 2 SECONDS, src))
			rag.reagents.remove_all(1)
			polished = 1
			AddComponent(/datum/component/particle_spewer/sparkle, shine_more = TRUE)
			if(HAS_TRAIT(user, TRAIT_NOBLE_BLOOD))
				user.add_stress(/datum/stress_event/noble_polishing_shoe)
			addtimer(CALLBACK(src, PROC_REF(lose_shine)), 5 MINUTES)
			to_chat(user, span_notice("I polish \the [name]."))

		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/reagent_containers/food/snacks/fat))
		if(!polished)
			to_chat(user, span_notice("\the [name] needs to be cleaned with cloth before it can be shined."))
			return ITEM_INTERACT_BLOCKING
		else if(polished == 2) // we love magic numbers
			to_chat(user, span_notice("You can't possibily make \the [name] shine more."))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice("You start shining \the [name] with \the [tool.name]."))

		if(do_after(user, 2 SECONDS, src))
			polished = 2
			if(HAS_TRAIT(user, TRAIT_NOBLE_BLOOD))
				user.add_stress(/datum/stress_event/noble_polishing_shoe)
			var/datum/component/particle_spewer = GetComponent(/datum/component/particle_spewer/sparkle)
			if(particle_spewer)
				qdel(particle_spewer)
			AddComponent(/datum/component/particle_spewer/sparkle)
			addtimer(CALLBACK(src, PROC_REF(lose_shine)), 10 MINUTES)
			to_chat(user, span_notice("You shined \the [name]."))

		return ITEM_INTERACT_SUCCESS

/obj/item/clothing/shoes/examine(mob/user)
	. = ..()
	if(polished == 1)
		. += ("\nThis shoe was polished, it looks quite nice.")
	if(polished == 2)
		. += span_notice("\nThis shoe was polished to a shine, it looks immaculate!")

/obj/item/clothing/shoes/proc/lose_shine()
	if(polished == 1 || polished == 2)
		qdel(GetComponent(/datum/component/particle_spewer/sparkle))
		polished = 0

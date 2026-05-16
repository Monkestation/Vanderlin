
/obj/item/bodypart/onbite(mob/living/user)
	. = ..()
	if(!.)
		return
	if(status != BODYPART_ORGANIC)
		return TRUE
	if((user.mind && user.mind.has_antag_datum(/datum/antagonist/zombie)) || is_species(/datum/species/werewolf))
		if(user.has_status_effect(/datum/status_effect/debuff/silver_bane))
			to_chat(user, span_notice("My power is weakened, I cannot heal!"))
			return TRUE
		if(!do_after(user, 5 SECONDS, src))
			return TRUE
		user.visible_message(span_warning("[user] consumes [src]!"),\
						span_notice("I consume [src]!"))
		playsound(user, pick(dismemsound), 100, FALSE, -1)
		new /obj/effect/gibspawner/generic(get_turf(src), user)
		user.reagents.add_reagent(/datum/reagent/medicine/healthpot, 30)
		qdel(src)

/obj/item/bodypart/MiddleClick(mob/living/user, list/modifiers)
	if(status != BODYPART_ORGANIC)
		return ..()
	if(skeletonized || !length(food_type))
		to_chat(user, span_warning("[src] has no meat to eat."))
		return
	var/bloodcolor = COLOR_BLOOD
	if(owner)
		bloodcolor = owner.get_blood_type().color
	else if(original_owner)
		bloodcolor = original_owner.get_blood_type().color
	var/obj/item/held_item = user.get_active_held_item()
	if(isanimal(user))
		visible_message("[user] begins to eat \the [src].")
		playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
		if(!do_after(user, 5 SECONDS, src))
			return
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src), bloodcolor)
		qdel(src)
		return
	else if(held_item?.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
		var/used_time = 21 SECONDS
		used_time -= (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/labor/butchering) * 3 SECONDS)
		visible_message("[user] begins to butcher \the [src].")
		playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
		if(!do_after(user, used_time, src))
			return
		var/drops = 1 + round(lerp(0, 3, GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/labor/butchering) / SKILL_RANK_LEGENDARY))
		var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)/3
		for(var/i in 1 to drops)
			var/choose_type = pickweight(food_type)
			var/obj/item/reagent_containers/food/snacks/food = new choose_type(get_turf(src))
			if(HAS_TRAIT(src, TRAIT_ROTTEN))
				food.become_rotten()
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src), bloodcolor)
		user.adjust_experience(/datum/attribute/skill/labor/butchering, amt2raise, FALSE)
		qdel(src)
		return
	..()

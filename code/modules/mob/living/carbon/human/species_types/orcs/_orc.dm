/datum/attribute_holder/sheet/job/orc
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_INTELLIGENCE = -9,
	)

/datum/species/orc
	name = "orc"
	id = SPEC_ID_ORC
	species_traits = list(NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RADIMMUNE,TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE, TRAIT_INHUMENCAMP)
	nojumpsuit = 1
	sexes = 1
	damage_overlay_type = ""
	changesource_flags = WABBAJACK
	statsheet_male = /datum/attribute_holder/sheet/job/orc
	var/raceicon = "orc"
	exotic_bloodtype = /datum/blood_type/human/corrupted/orc
	meat = list(/obj/item/reagent_containers/food/snacks/meat/strange/inhumen = 1)

/datum/species/orc/update_damage_overlays(mob/living/carbon/human/H)
	return

/datum/species/orc/regenerate_icons(mob/living/carbon/human/H)
	H.icon_state = ""
	if(HAS_TRAIT(H, TRAIT_NO_TRANSFORM))
		return 1
	H.update_inv_hands()
	H.update_inv_handcuffed()
	H.update_inv_legcuffed()
	H.update_fire()
	H.update_body()
	H.update_transform()
	return TRUE

/datum/component/rot/corpse/orc/process()
	var/amt2add = 10
	var/time_elapsed = last_process ? (world.time - last_process)/10 : 1
	if(last_process)
		amt2add = ((world.time - last_process)/10) * amt2add
	last_process = world.time
	amount += amt2add
	if(has_world_trait(/datum/world_trait/pestra_mercy))
		amount -= (is_ascendant(PESTRA) ? 2.5 : 5) * time_elapsed

	var/mob/living/carbon/C = parent
	if(!C)
		qdel(src)
		return
	if(C.stat != DEAD)
		qdel(src)
		return
	var/should_update = FALSE
	if(amount > 20 MINUTES)
		for(var/obj/item/bodypart/B in C.bodyparts)
			if(!B.skeletonized)
				B.skeletonized = TRUE
				should_update = TRUE
	else if(amount > 12 MINUTES)
		for(var/obj/item/bodypart/B in C.bodyparts)
			if(!HAS_TRAIT(B, TRAIT_ROTTEN))
				B.kill_limb()
				should_update = TRUE
			if(HAS_TRAIT(B, TRAIT_ROTTEN) && amount < 16 MINUTES && !C.has_faction(FACTION_MATTHIOS))
				var/turf/open/T = C.loc
				if(istype(T))
					T.pollute_turf(/datum/pollutant/rot, 4)
	if(should_update)
		if(amount > 20 MINUTES)
			C.update_body()
			qdel(src)
			return
		else if(amount > 12 MINUTES)
			C.update_body()



//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_CHEST		0.15
#define THERMAL_PROTECTION_GROIN		0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025

/mob/living/carbon/human
	var/allmig_reward = 0

/mob/living/carbon/human/Life()
//	set invisibility = 0
	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	. = ..()

	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE)

	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		adjust_bloodpool(3)

	if (QDELETED(src))
		return 0

	if(advsetup)
		Stun(50)

	if(mind)
		mind.sleep_adv.add_stress_cycle(get_stress_amount())
		for(var/datum/antagonist/A in mind.antag_datums)
			A.on_life(src)

	handle_vamp_dreams()
	if(IsSleeping())
		if(health > 0)
			remove_status_effect(/datum/status_effect/debuff/trainsleep)
			remove_status_effect(/datum/status_effect/debuff/sleepytime)
			if(has_status_effect(/datum/status_effect/debuff/dreamytime))
				remove_status_effect(/datum/status_effect/debuff/dreamytime)
				if(mind)
					mind.sleep_adv.advance_cycle()
					if(!mind.antag_datums || !mind.antag_datums.len)
						allmig_reward++
						var/static/list/towner_jobs
						towner_jobs = GLOB.serf_positions | GLOB.peasant_positions | GLOB.apprentices_positions | GLOB.youngfolk_positions | GLOB.company_positions
						if(mind.assigned_role.title in towner_jobs) //If you play a towner-related role, you get triumphs.
							adjust_triumphs(1)
						to_chat(src, span_danger("Nights Survived: \Roman[allmig_reward]"))
						if(allmig_reward > 0 && allmig_reward % 2 == 0)
							adjust_triumphs(1)
	if(!HAS_TRAIT(src, TRAIT_STASIS))
		if(HAS_TRAIT(src, TRAIT_LEPROSY))
			if(MOBTIMER_FINISHED(src, MT_LEPERBLEED, 12 MINUTES))
				if(prob(5))
					to_chat(src, span_warning("My skin opens up and bleeds..."))
					MOBTIMER_SET(src, MT_LEPERBLEED)
					var/obj/item/bodypart/part = pick(bodyparts)
					if(part)
						part.add_wound(/datum/wound/slash/small)
					adjustToxLoss(10)
		handle_heart()
		handle_liver()
		update_stamina()
		update_energy()
		handle_environment()
		handle_hygiene()
		if(health <= 0)
			apply_damage(1, OXY)
		if(dna?.species)
			dna.species.spec_life(src) // for mutantraces

	//heart attack stuff
	handle_curses()
	if(charflaw && !charflaw.ephemeral)
		charflaw.flaw_on_life(src)
	if(!client && !HAS_TRAIT(src, TRAIT_NOSLEEP) && !ai_controller)
		if(MOBTIMER_EXISTS(src, MT_SLO))
			if(MOBTIMER_FINISHED(src, MT_SLO, 90 SECONDS)) //?????
				Sleeping(100)
		else
			MOBTIMER_SET(src, MT_SLO)
	else
		MOBTIMER_UNSET(src, MT_SLO)

	if(!typing)
		set_typing_indicator(FALSE)
	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()
	handle_gas_mask_sound()

	if(stat != DEAD)
		return 1

/mob/living/carbon/human/proc/handle_gas_mask_sound()
	if(!istype(wear_mask, /obj/item/clothing/face/facemask/steel/confessor))
		if(breathe_tick)
			breathe_tick = 0
		return
	if(stat == DEAD)
		return
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return
	breathe_tick++
	var/mask_sound
	if(istype(wear_mask, /obj/item/clothing/face/facemask/steel/confessor))
		if(breathe_tick>=rand(3,5))
			breathe_tick = 0
			mask_sound = pick('sound/items/confessormask1.ogg', 'sound/items/confessormask2.ogg', 'sound/items/confessormask3.ogg',
							'sound/items/confessormask4.ogg', 'sound/items/confessormask5.ogg', 'sound/items/confessormask6.ogg',
							'sound/items/confessormask7.ogg', 'sound/items/confessormask8.ogg', 'sound/items/confessormask9.ogg',
					 		'sound/items/confessormask10.ogg')
			playsound(src, mask_sound, 90, FALSE, 4, 0)
			return

/mob/living/carbon/human/DeadLife()
	set invisibility = 0

	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(mind)
		for(var/datum/antagonist/A in mind.antag_datums)
			A.on_life(src)

	. = ..()
	name = get_visible_name()

/mob/living/carbon/human/proc/on_daypass()
	if(stat < 3) //not dead
		if(dna?.species)
			if(STUBBLE in dna.species.species_traits)
				if(gender == MALE)
					if(prob(50))
						has_stubble = TRUE
						update_body()


/mob/living/carbon/human/handle_traits()
	if (getOrganLoss(ORGAN_SLOT_BRAIN) >= 60)
		add_stress(/datum/stress_event/brain_damage)
	else
		remove_stress(/datum/stress_event/brain_damage)
	return ..()

/mob/living/proc/handle_environment()
	return

/mob/living/carbon/human/handle_environment()
	dna?.species.handle_environment(src)

/mob/living/carbon/human/proc/handle_hygiene()
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_NOHYGIENE))
		return
	if(HAS_TRAIT(src, TRAIT_ALWAYS_CLEAN))
		set_hygiene(HYGIENE_LEVEL_CLEAN)

	else
		var/hygiene_adjustment = 0

		//Are our clothes dirty?
		var/obj/item/head = get_item_by_slot(ITEM_SLOT_HEAD)
		if(head && HAS_BLOOD_DNA(head))
			hygiene_adjustment -= 1 * HYGIENE_FACTOR

		var/obj/item/neck = get_item_by_slot(ITEM_SLOT_NECK)
		if(neck && HAS_BLOOD_DNA(neck))
			hygiene_adjustment -= 1 * HYGIENE_FACTOR

		var/obj/item/mask = get_item_by_slot(ITEM_SLOT_MASK)
		if(mask && HAS_BLOOD_DNA(mask))
			hygiene_adjustment -= 1 * HYGIENE_FACTOR

		var/obj/item/shirt = get_item_by_slot(ITEM_SLOT_SHIRT)
		if(shirt && HAS_BLOOD_DNA(shirt))
			hygiene_adjustment -= 2 * HYGIENE_FACTOR

		var/obj/item/cloak = get_item_by_slot(ITEM_SLOT_CLOAK)
		if(cloak && HAS_BLOOD_DNA(cloak))
			hygiene_adjustment -= 2 * HYGIENE_FACTOR

		var/obj/item/pants = get_item_by_slot(ITEM_SLOT_PANTS)
		if(pants && HAS_BLOOD_DNA(pants))
			hygiene_adjustment -= 3 * HYGIENE_FACTOR

		var/obj/item/armor = get_item_by_slot(ITEM_SLOT_ARMOR)
		if(armor && HAS_BLOOD_DNA(armor))
			hygiene_adjustment -= 3 * HYGIENE_FACTOR

		var/obj/item/shoes = get_item_by_slot(ITEM_SLOT_SHOES)
		if(shoes && HAS_BLOOD_DNA(shoes))
			hygiene_adjustment -= 0.5 * HYGIENE_FACTOR

		//Are we bathing?
		var/current_turf = get_turf(src)
		if(istype(current_turf, /turf/open/water))
			var/turf/open/water/bathing_liquid = current_turf
			hygiene_adjustment += bathing_liquid.cleanliness_factor


		adjust_hygiene(hygiene_adjustment)
	dna?.species.handle_hygiene(src)

///FIRE CODE
/mob/living/carbon/human/handle_fire()
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return

	if(dna)
		. = dna.species.handle_fire(src) //do special handling based on the mob's species. TRUE = they are immune to the effects of the fire.

	if(!last_fire_update)
		last_fire_update = fire_stacks + divine_fire_stacks
	if((fire_stacks + divine_fire_stacks > 10 && last_fire_update <= 10) || (fire_stacks + divine_fire_stacks <= 10 && last_fire_update > 10))
		last_fire_update = fire_stacks + divine_fire_stacks
		update_fire()


/mob/living/carbon/human/proc/get_thermal_protection()
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_armor)
		if(wear_armor.max_heat_protection_temperature >= 30000)
			thermal_protection += (wear_armor.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= 30000)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	return thermal_protection

/mob/living/carbon/human/IgniteMob()
	//If have no DNA or can be Ignited, call parent handling to light user
	//If firestacks are high enough
	if(!dna || dna.species.CanIgniteMob(src))
		if(!on_fire)
			if(fire_stacks + divine_fire_stacks > 10)
				Immobilize(30)
				emote("firescream", TRUE)
			else
				emote("pain", TRUE)
		return ..()
	. = FALSE //No ignition

/mob/living/carbon/human/ExtinguishMob()
	if(!dna || !dna.species.ExtinguishMob(src))
		last_fire_update = null
		..()

/mob/living/carbon/human/SoakMob(locations, dirty_water = FALSE, rain = FALSE)
	var/coverhead
	//add belt slots to this for rusting
	var/list/body_parts = list(head, wear_mask, wear_wrists, wear_shirt, wear_neck, cloak, wear_armor, wear_pants, backr, backl, gloves, shoes, belt, wear_ring)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(zone2covered(BODY_ZONE_HEAD, C.body_parts_covered))
				coverhead = TRUE
	if(locations & HEAD)
		if(!coverhead)
			add_stress(/datum/stress_event/coldhead)

	if(locations & CHEST)
		if(!rain)
			ExtinguishMob()
		for(var/obj/item/clothing/C in get_equipped_items())
			if(C.wetable)
				C.wet.add_water(20, dirty_water)
		if(locations & HEAD)
			adjust_fire_stacks(-2)
		else
			adjust_fire_stacks(-1)
	else
		if(locations == FEET)
			var/obj/item/clothing/C = shoes
			if(C && C.wetable)
				C.wet.add_water(20, dirty_water)
		else
			var/list/below_chest = list(wear_pants, shoes)
			for(var/obj/item/clothing/C in below_chest)
				if(C.wetable)
					C.wet.add_water(20, dirty_water)

//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.body_parts_covered
	if(wear_armor)
		if(wear_armor.max_heat_protection_temperature && wear_armor.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_armor.body_parts_covered
	if(wear_pants)
		if(wear_pants.max_heat_protection_temperature && wear_pants.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_pants.body_parts_covered
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.body_parts_covered
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.body_parts_covered
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.body_parts_covered

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.body_parts_covered
	if(wear_armor)
		if(wear_armor.min_cold_protection_temperature && wear_armor.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_armor.body_parts_covered
	if(wear_pants)
		if(wear_pants.min_cold_protection_temperature && wear_pants.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_pants.body_parts_covered
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.body_parts_covered
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.body_parts_covered
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.body_parts_covered

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)
	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)

/mob/living/carbon/human/handle_random_events()
	..()
	//Puke if toxloss is too high
	if(!stat)
		if(prob(33) && getToxLoss() >= 75)
			MOBTIMER_SET(src, MT_PUKE)
			vomit(1, blood = TRUE)

/mob/living/carbon/human/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(head && istype(head, /obj/item/clothing))
		var/obj/item/clothing/CH = head
		if(CH.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	return ..()

/mob/living/carbon/human/proc/handle_heart()
	var/we_breath = !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT)

	if(!undergoing_cardiac_arrest())
		return

	if(we_breath)
		adjustOxyLoss(8)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(2)

/mob/living/carbon/human/proc/handle_vamp_dreams()
	if(!HAS_TRAIT(src, TRAIT_VAMP_DREAMS))
		return
	if(!mind)
		return
	if(!has_status_effect(/datum/status_effect/debuff/vamp_dreams))
		return
	if(!eyesclosed)
		return
	if(body_position != LYING_DOWN)
		return
	if(!istype(loc, /obj/structure/closet/crate/coffin))
		return
	var/obj/structure/closet/crate/coffin/coffin = loc
	if(coffin.opened)
		return
	remove_status_effect(/datum/status_effect/debuff/vamp_dreams)
	mind.sleep_adv.advance_cycle()

#undef THERMAL_PROTECTION_HEAD
#undef THERMAL_PROTECTION_CHEST
#undef THERMAL_PROTECTION_GROIN
#undef THERMAL_PROTECTION_LEG_LEFT
#undef THERMAL_PROTECTION_LEG_RIGHT
#undef THERMAL_PROTECTION_FOOT_LEFT
#undef THERMAL_PROTECTION_FOOT_RIGHT
#undef THERMAL_PROTECTION_ARM_LEFT
#undef THERMAL_PROTECTION_ARM_RIGHT
#undef THERMAL_PROTECTION_HAND_LEFT
#undef THERMAL_PROTECTION_HAND_RIGHT

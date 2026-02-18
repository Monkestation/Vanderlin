/datum/coven/quietus
	name = "Quietus"
	desc = "Live in the shadows striking only when needed."
	icon_state = "daimonion"
	power_type = /datum/coven_power/quietus

/datum/coven_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

//SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	name = "Silence of Death"
	desc = "Create an area of pure silence around you, confusing those within it, sound can still escape the zone."
	level = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	toggled = TRUE
	vitae_cost = 15
	duration_length = 5 SECONDS
	cooldown_length = 15 SECONDS
	var/datum/proximity_monitor/advanced/silence_field/proximity_field
	var/silence_range = 7
	var/validation_timer

/datum/coven_power/quietus/silence_of_death/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!proximity_field)
		proximity_field = new /datum/proximity_monitor/advanced/silence_field(owner, silence_range, FALSE, src)
		// Apply silence to all mobs currently in range
		apply_initial_silence()
		// Start validation timer to check positions periodically - this is really redundant but its useful incases of forceMove
		validation_timer = addtimer(CALLBACK(src, PROC_REF(validate_silence_field)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/coven_power/quietus/silence_of_death/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(proximity_field)
		QDEL_NULL(proximity_field)
	if(validation_timer)
		deltimer(validation_timer)
		validation_timer = null

/datum/coven_power/quietus/silence_of_death/proc/apply_initial_silence()
	if(!owner || !proximity_field)
		return

	// Find all mobs within range and apply silence
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/validate_silence_field()
	if(!owner || !proximity_field)
		return

	var/list/current_affected = proximity_field.affected_mobs.Copy()

	// Check each affected mob to see if they're still in range
	for(var/mob/living/carbon/human/target in current_affected)
		if(!target || target.z != owner.z || get_dist(owner, target) > silence_range)
			proximity_field.remove_affected_mob(target)

	// Check for new mobs that entered range
	for(var/mob/living/carbon/human/target in range(silence_range, owner))
		if(should_affect_target(target) && !(target in proximity_field.affected_mobs))
			proximity_field.add_affected_mob(target)

/datum/coven_power/quietus/silence_of_death/proc/should_affect_target(mob/living/carbon/human/target)
	if(target == owner)
		return FALSE
	if(target.clan_position?.is_subordinate_to(owner.clan_position))
		return FALSE
	if(target.clan_position?.is_superior_to(owner.clan_position))
		return FALSE
	return TRUE

/datum/coven_power/quietus/silence_of_death/proc/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILENT_FOOTSTEPS))
		ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!HAS_TRAIT(target, TRAIT_DEAF))
		ADD_TRAIT(target, TRAIT_DEAF, "quietus")
		target.adjust_confusion_up_to(2.5 SECONDS, 5 SECONDS)

/datum/coven_power/quietus/silence_of_death/proc/remove_silence(mob/living/carbon/human/target)
	if(HAS_TRAIT_FROM(target, TRAIT_DEAF, "quietus"))
		REMOVE_TRAIT(target, TRAIT_DEAF, "quietus")
	if(HAS_TRAIT_FROM(target, TRAIT_SILENT_FOOTSTEPS, "quietus"))
		REMOVE_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")

// Proximity monitor for the silence field
/datum/proximity_monitor/advanced/silence_field
	var/datum/coven_power/quietus/silence_of_death/parent_power
	var/list/affected_mobs = list()

/datum/proximity_monitor/advanced/silence_field/New(atom/center, range, ignore_if_not_on_turf, datum/coven_power/quietus/silence_of_death/power)
	parent_power = power
	. = ..()

/datum/proximity_monitor/advanced/silence_field/setup_field_turf(turf/target)
	. = ..()
	// Check for any mobs already on this turf
	for(var/mob/living/carbon/human/H in target)
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_crossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		if(parent_power.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_uncrossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		remove_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/proc/add_affected_mob(mob/living/carbon/human/target)
	if(target in affected_mobs)
		return
	affected_mobs |= target
	parent_power.apply_silence(target)

/datum/proximity_monitor/advanced/silence_field/proc/remove_affected_mob(mob/living/carbon/human/target)
	if(!(target in affected_mobs))
		return
	affected_mobs -= target
	parent_power.remove_silence(target)

/datum/proximity_monitor/advanced/silence_field/Destroy()
	// Clean up all affected mobs when the field is destroyed
	for(var/mob/living/carbon/human/H in affected_mobs)
		parent_power.remove_silence(H)
	affected_mobs.Cut()
	parent_power = null
	return ..()

/datum/coven_power/quietus/scorpions_touch
	name = "Scorpion's Touch"
	desc = "Create a powerful venom to apply to your enemies."

	level = 2
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING | COVEN_CHECK_FREE_HAND
	violates_masquerade = TRUE
	cooldown_length = 5 SECONDS

/datum/coven_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/melee/touch_attack/quietus(owner))

//SCORPION'S TOUCH
/obj/item/melee/touch_attack/quietus
	name = "\improper poison touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = COLOR_RED_LIGHT

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity, list/modifiers)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.adjustFireLoss(10)
		L.AdjustKnockdown(3 SECONDS)
		L.adjust_stamina(-50)
	return ..()

//BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	name = "Baal's Caress"
	desc = "Transmute your vitae into a toxin that destroys all flesh it touches."

	level = 3
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	vitae_cost = 3
	target_type = TARGET_OBJ
	range = 15
	violates_masquerade = TRUE
	cooldown_length = 30 SECONDS

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()
	var/obj/item/weapon/target_weapon = target
	if(!istype(target_weapon))
		if(alert)
			to_chat(owner, span_warning("[src] can only be used on weapons!"))
		return FALSE

	if(!target_weapon.sharpness)
		if(alert)
			to_chat(owner, span_warning("[src] can only be used on bladed weapons!"))
		return FALSE

	return .

/datum/coven_power/quietus/baals_caress/activate(obj/item/weapon/target)
	. = ..()
	target.AddElement(/datum/element/one_time_poison, list(/datum/reagent/strongpoison = 2))

/datum/coven_power/quietus/taste_of_death
	name = "Taste of Death"
	desc = "Spit a glob of caustic blood at your enemies."

	level = 4
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	violates_masquerade = TRUE

/datum/coven_power/quietus/taste_of_death/post_gain()
	. = ..()
	owner.add_spell(/datum/action/cooldown/spell/projectile/acid_splash/quietus, TRUE)

//DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	name = "Dagon's Call"
	desc = "Curse the last person you attacked to drown in their own blood."

	level = 5
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	cooldown_length = 30 SECONDS

/datum/coven_power/quietus/dagons_call/activate()
	. = ..()
	var/mob/living/lastattacker = owner.lastattacker_weakref?.resolve()
	if(isliving(lastattacker))
		lastattacker.adjust_stamina(-80)
		lastattacker.adjust_fire_stacks(6)
		lastattacker.adjustFireLoss(10)
		to_chat(owner, "You send your curse on [lastattacker], the last creature you attacked.")
	else
		to_chat(owner, "You don't seem to have last attacked soul earlier...")
		return

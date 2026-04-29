/proc/CheckZoneCoven(mob/target)
	var/area/area = get_area(target)
	return area.coven_protected

/mob/living
	var/cached_island_id = null
	var/last_island_check = 0

	var/mob/living/walk_to_target
	var/walk_to_duration = 0
	var/walk_to_steps_taken = 0

	var/celerity_visual = FALSE

	var/turf/walk_to_last_pos
	var/list/walk_to_cached_path
	var/list/frenzy_cached_path = null
	var/turf/frenzy_last_pos = null

	var/list/taboos

	var/enhanced_strip = FALSE
	var/datum/clan/clan
	var/bloodpool = 1500
	var/maxbloodpool = 3000

	var/extra_mob_weight = 0

	COOLDOWN_DECLARE(detection_cooldown)
	var/detections = 0

	var/coven_time_plus = 0

	var/last_rage_hit = 0
	var/frenzy_hardness = 1
	var/last_frenzy_check = 0
	var/atom/frenzy_target = null

	COOLDOWN_DECLARE(drinkblood_use)
	var/last_bloodpower_click = 0
	var/last_drinkblood_click = 0

	var/list/drunked_of = list()

	var/frenzy_chance_boost = 10
	var/humanity = 7

	var/potence_weapon_buff = 0
	var/last_telepathy_use = 0

	/// List of covens this mob possesses
	var/list/datum/coven/covens
	var/datum/clan_menu_interface/clan_menu_interface
	var/datum/clan_hierarchy_node/clan_position

	var/list/stored_enchantments


/mob/living/proc/has_bloodpool_cost(cost)
	if(cost > bloodpool)
		return FALSE
	return TRUE

/datum/clan/proc/grant_hierarchy_actions(mob/living/carbon/human/H)
	if(!H.clan_position)
		return

	for(var/datum/action/clan_hierarchy/action in H.actions)
		action.Remove(H)

	if(length(H.clan_position.subordinates))
		var/datum/action/clan_hierarchy/command_subordinate/command_action = new()
		command_action.Grant(H)

		var/datum/action/clan_hierarchy/locate_subordinate/locate_action = new()
		locate_action.Grant(H)

	if(H.clan_position.can_assign_positions)
		var/datum/action/clan_hierarchy/summon_subordinate/summon_action = new()
		summon_action.Grant(H)

		var/datum/action/clan_hierarchy/mass_command/mass_action = new()
		mass_action.Grant(H)

/mob/living/proc/set_bloodpool(newblood)
	bloodpool = CLAMP(newblood, 0, maxbloodpool)
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		hud_used?.bloodpool?.name = "Psydon's Grace: [bloodpool]"
		hud_used?.bloodpool?.desc = "Psydon's Grace: [bloodpool]/[maxbloodpool]"
	else
		hud_used?.bloodpool?.name = "Bloodpool: [bloodpool]"
		hud_used?.bloodpool?.desc = "Bloodpool: [bloodpool]/[maxbloodpool]"
	hud_used?.bloodpool?.set_value((100 / (maxbloodpool / bloodpool)) / 100, 1 SECONDS)

/mob/living/proc/adjust_bloodpool(adjust)
	bloodpool = CLAMP(bloodpool + adjust, 0, maxbloodpool)
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		hud_used?.bloodpool?.name = "Psydon's Grace: [bloodpool]"
		hud_used?.bloodpool?.desc = "Psydon's Grace: [bloodpool]/[maxbloodpool]"
	else
		hud_used?.bloodpool?.name = "Bloodpool: [bloodpool]"
		hud_used?.bloodpool?.desc = "Bloodpool: [bloodpool]/[maxbloodpool]"
	if(bloodpool <= 0)
		hud_used?.bloodpool?.set_value(0, 1 SECONDS)
	else
		hud_used?.bloodpool?.set_value((100 / (maxbloodpool / bloodpool)) / 100, 1 SECONDS)

/mob/proc/affects_masquerade()
	return FALSE

/mob/living/carbon/affects_masquerade(town_only=TRUE)
	. = FALSE
	if(!mind)
		return
	if(CheckZoneCoven(src))
		return
	if(town_only && !is_town_level(z))
		return
	if(is_blind())
		return
	if(stat >= UNCONSCIOUS)
		return
	if(clan)
		return
	if(mind.has_antag_datum(/datum/antagonist/vampire) || mind.has_antag_datum(/datum/antagonist/zombie) || mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if((FACTION_UNDEAD in faction) || (MOB_UNDEAD in mob_biotypes))
		return
	return TRUE


/// Check Eye witnesses to vampire stuff in an area.
/// Called by the perpetrator
/// atom/source = The atom/location of the thing of interest - what people are looking at
/mob/living/proc/CheckEyewitness(atom/source, range = DEFAULT_MESSAGE_RANGE, affects_source = FALSE)
	var/actual_range = max(1, round(range*(source.alpha/255)))
	var/list/seenby = list()
	var/turf/T = get_turf(src)
	//anyone right next to us counts counts
	for(var/mob/living/carbon/human/H in oviewers(1, src))
		if(!H.affects_masquerade())
			continue
		//assuming they're not looking directly away
		if(T != get_step(H, turn(H.dir, 180)))
			seenby |= H

	for(var/mob/living/carbon/human/H in viewers(actual_range, source))
		if(H == src)
			continue
		if(affects_source && H == source)
			seenby |= H
			continue
		if(!H.affects_masquerade())
			continue
		if(!(source.has_light_nearby() || H.has_nightvision() || get_dist(H, source) <= 1))
			continue
		if(!H.can_see_cone(src))
			continue
		seenby |= H
	return seenby

/// Increases a vampire's detection value by a number of points.
/// Usually I based the value off of the the number of eyewitnesses.
/// If the vampire was the source of the eyewitness I decreased it by 1
/mob/living/proc/vampire_detected(value, forced = FALSE)
	if(value <= 0)
		return
	if(!clan || istype(clan, /datum/clan/daewalker))
		return
	if(CheckZoneCoven(src))
		return
	if(!COOLDOWN_FINISHED(src, detection_cooldown) && !forced)
		return
	COOLDOWN_START(src, detection_cooldown, 20 SECONDS)
	detections += value
	GLOB.vamp_detection += value
	to_chat(src, "<h2>[span_boldannounce("DETECTED x[value]!")]</h2>")


/**
 * Creates an action button and applies post_gain effects of the given Coven.
 * Now properly stores the coven on the mob.
 *
 * Arguments:
 * * coven - Coven datum/path that is being given to this mob.
 */
/mob/living/carbon/human/proc/give_coven(datum/coven/coven)
	if(ispath(coven))
		var/datum/coven/new_coven = new coven(1)
		coven = new_coven

	// Store the coven on the mob
	if(!length(covens))
		covens = list()

	// Assign the mob as owner
	coven.assign(src)

	// Store by name for easy access
	covens[coven.name] = coven

	if(coven.level > 0)
		var/datum/action/coven/action = new(src, coven)
		action.Grant(src)

/**
 * Removes a coven from the mob, cleaning up all associated data and effects.
 * Handles action removal, power cleanup, and proper memory management.
 *
 * Arguments:
 * * coven - Either a coven datum instance, coven type path, or coven name string
 * * silent - If TRUE, suppresses removal messages to the player
 * * keep_experience - If TRUE, preserves XP for potential future restoration
 *
 * Returns:
 * * TRUE if coven was successfully removed
 * * FALSE if coven was not found or removal failed
 */
/mob/living/carbon/human/proc/remove_coven(coven, silent = FALSE)
	if(!length(covens))
		return FALSE

	var/datum/coven/target_coven
	var/coven_name

	// Handle different input types
	if(istype(coven, /datum/coven))
		// Direct coven datum
		target_coven = coven
		coven_name = target_coven.name
	else if(ispath(coven))
		// Coven type path - find by type
		for(var/name in covens)
			var/datum/coven/stored_coven = covens[name]
			if(stored_coven.type == coven)
				target_coven = stored_coven
				coven_name = name
				break
	else if(istext(coven))
		// Coven name string
		coven_name = coven
		target_coven = covens[coven_name]
	else
		return FALSE

	// Verify we found a valid coven
	if(!target_coven || !coven_name)
		return FALSE

	if(target_coven.coven_action)
		target_coven.coven_action.Remove(src)
		QDEL_NULL(target_coven.coven_action)

	if(target_coven.research_interface)
		QDEL_NULL(target_coven.research_interface)

	pre_coven_removal(target_coven)

	for(var/datum/coven_power/power in target_coven.known_powers)
		power.deactivate()
		if(power.discipline.coven_action)
			power.discipline.coven_action.Remove(src)

	target_coven.owner = null
	target_coven.current_power = null

	covens -= coven_name

	if(!silent)
		to_chat(src, "<span class='boldwarning'>You have lost your knowledge of [target_coven.name].</span>")

	QDEL_NULL(target_coven)
	return TRUE

/**
 * Pre-removal hook for covens. Override this in specific coven types
 * to handle coven-specific cleanup before removal.
 *
 * Arguments:
 * * coven - The coven being removed
 */
/mob/living/carbon/human/proc/pre_coven_removal(datum/coven/coven)
	return

/mob/living/carbon/human/proc/get_coven(datum/coven/coven_type)
	if(!length(covens))
		return null
	for(var/datum/coven/coven as anything in covens)
		if(coven.type != coven_type)
			continue
		return coven
	return null

/**
 * Opens the unified clan menu showing all covens and research trees
 */
/mob/living/carbon/human/proc/open_clan_menu()
	if(!clan)
		to_chat(src, "<span class='warning'>You have no clan!</span>")
		return
	if(!covens || !length(covens))
		to_chat(src, "<span class='warning'>You have no covens to manage!</span>")
		return

	// Clean up existing interface
	if(clan_menu_interface)
		qdel(clan_menu_interface)

	// Create new interface and store it
	clan_menu_interface = new /datum/clan_menu_interface(src)
	clan_menu_interface.generate_interface()


/mob/living/carbon/human/proc/process_vampire_life()
	if(!clan)
		return

	// Handle low bloodpool effects
	handle_bloodpool_effects()

	// Coffin regeneration
	var/obj/structure/closet/crate/coffin/coffin = loc
	if(istype(coffin) && (src in coffin.contents))
		if(InCritical() && !HAS_TRAIT(src, TRAIT_DEATHCOMA))
			to_chat(src, span_notice("You enter the horrible slumber of deathless Torpor. You will heal until you are renewed."))
			ADD_TRAIT(src, TRAIT_DEATHCOMA, VAMPIRE_TRAIT)
		heal_overall_damage(5, 5)
		adjustToxLoss(-5)
		heal_wounds(25)
		for(var/obj/item/organ/artery/artery in getorganslotlist(ORGAN_SLOT_ARTERY))
			artery.applyOrganDamage(-5)
		if(prob(3))
			regenerate_limb(silent=FALSE)
		if(blood_volume <= BLOOD_VOLUME_NORMAL)
			if(blood_volume < BLOOD_VOLUME_SAFE)
				blood_volume = BLOOD_VOLUME_SAFE
			adjust_bloodvolume(10)
		set_bloodpool(max(bloodpool, min(maxbloodpool * 0.25, bloodpool + 5)))
	else if(HAS_TRAIT(src, TRAIT_DEATHCOMA) && (!InCritical() || (!istype(coffin) || !(src in coffin.contents))))
		REMOVE_TRAIT(src, TRAIT_DEATHCOMA, VAMPIRE_TRAIT)
		to_chat(src, span_warning("You have recovered from Torpor."))

/mob/living/carbon/human/proc/handle_bloodpool_effects()
	// Apply thirst effects based on bloodpool levels
	switch(bloodpool)
		if(VITAE_LEVEL_HUNGRY to VITAE_LEVEL_FED)
			apply_status_effect(/datum/status_effect/debuff/thirstyt1)
			remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			remove_status_effect(/datum/status_effect/debuff/thirstyt3)
		if(VITAE_LEVEL_STARVING to VITAE_LEVEL_HUNGRY)
			apply_status_effect(/datum/status_effect/debuff/thirstyt2)
			remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			remove_status_effect(/datum/status_effect/debuff/thirstyt3)
		if(-INFINITY to VITAE_LEVEL_STARVING)
			apply_status_effect(/datum/status_effect/debuff/thirstyt3)
			remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			if(prob(3))
				playsound(src, pick('sound/vo/hungry1.ogg','sound/vo/hungry2.ogg','sound/vo/hungry3.ogg'), 100, TRUE, -1)

	if(bloodpool < 100 && prob(9))
		if(last_frenzy_check + 5 MINUTES < world.time)
			rollfrenzy()

/mob/living/proc/get_clan_hierarchy_examine(mob/living/examiner)
	if(!clan || !clan_position || !examiner.clan)
		return ""

	if(examiner.clan != clan)
		return ""

	var/examine_text = ""

	examine_text += "<span class='info'><b>Clan Position:</b> [clan_position.name]</span>\n"

	if(clan_position.superior && clan_position.superior.assigned_member)
		var/mob/living/carbon/human/superior = clan_position.superior.assigned_member
		examine_text += "<span class='info'><b>Reports to:</b> [superior.real_name] ([clan_position.superior.name])</span>\n"

	if(examiner.clan_position && (examiner.clan_position.can_assign_positions || examiner.clan_position.is_superior_to(clan_position)))
		if(length(clan_position.subordinates))
			examine_text += "<span class='info'><b>Subordinates:</b> "
			var/list/sub_names = list()
			for(var/datum/clan_hierarchy_node/sub in clan_position.subordinates)
				if(sub.assigned_member)
					sub_names += "[sub.assigned_member.real_name] ([sub.name])"
			examine_text += english_list(sub_names)
			examine_text += "</span>\n"

	return examine_text

/mob/living/carbon/human/proc/make_vampire_slave(mob/living/carbon/human/master)
	if(!master.clan)
		return
	master.clan.add_non_vampire_member(src)
	add_bodypart_feature(new /datum/bodypart_feature/vamprire_seal)

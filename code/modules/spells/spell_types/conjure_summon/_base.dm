
/datum/action/cooldown/spell/conjure_summon
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	sound = 'sound/magic/magnet.ogg'

	click_to_activate = TRUE
	cast_range = 2

	spell_cost = 40

	required_technique = TECHNIQUE_SUMMONING

	invocation_type = INVOCATION_SHOUT
	invocation = "FIX ME!"

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_summons = 1
	var/summons_per_cast = 1
	var/list/conjured_mobs = list()
	var/current_mode = 1
	var/list/modes = list()
	var/summon_noun = "servant"
	var/recoil_energy_floor = 200
	var/recoil_severity = CONJURE_RECOIL_LIGHT
	var/recoil_stamina_only = TRUE
	var/static/list/command_word_types = list(
		/datum/action/cooldown/spell/command_word/fray,
		/datum/action/cooldown/spell/command_word/harry,
		/datum/action/cooldown/spell/command_word/quicken,
		/datum/action/cooldown/spell/command_word/beckon,
	)

/datum/action/cooldown/spell/conjure_summon/Remove(mob/remove_from)
	check_remove_command_words(remove_from)
	return ..()

/datum/action/cooldown/spell/conjure_summon/Grant(mob/grant_to)
	. = ..()
	apply_mode()
	grant_command_words(grant_to)

/datum/action/cooldown/spell/conjure_summon/proc/grant_command_words(mob/living/user)
	if(!istype(user))
		return
	for(var/path in command_word_types)
		if(has_command_word(user, path))
			continue
		var/datum/action/cooldown/spell/command_word/new_word = new path()
		new_word.Grant(user)

/datum/action/cooldown/spell/conjure_summon/proc/has_command_word(mob/living/user, path)
	for(var/datum/action/cooldown/spell/command_word/existing in user.actions)
		if(existing.type == path)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/conjure_summon/proc/check_remove_command_words(mob/living/user)
	if(!istype(user))
		return
	// bail if another conjure_summon spell is still granted
	for(var/datum/action/cooldown/spell/conjure_summon/other in user.actions)
		if(other == src)
			continue
		return
	// none left - strip the command words too
	for(var/datum/action/cooldown/spell/command_word/cw in user.actions)
		if(!(cw.type in command_word_types))
			continue
		cw.Remove(user)

/datum/action/cooldown/spell/conjure_summon/Destroy()
	for(var/mob/living/M as anything in conjured_mobs)
		if(!QDELETED(M))
			qdel(M)
	conjured_mobs.Cut()
	return ..()

/datum/action/cooldown/spell/conjure_summon/toggle_alt_mode(mob/user)
	if(length(modes) < 2)
		return
	var/next = current_mode
	for(var/i in 1 to length(modes))
		next = (next % length(modes)) + 1
		if(mode_available(next, user))
			break
	current_mode = next
	apply_mode()
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]]."))
	return TRUE

/datum/action/cooldown/spell/conjure_summon/proc/mode_available(index, mob/user)
	var/req = modes[index]["tier_req"]
	if(!req)
		return TRUE
	return get_summon_tier(user) >= req

/datum/action/cooldown/spell/conjure_summon/proc/apply_mode()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	if(mode["invocation"])
		invocation = mode["invocation"]
	update_mode_maptext()

/datum/action/cooldown/spell/conjure_summon/proc/update_mode_maptext()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(mode["tag"])
		holder.maptext_x = 5
		holder.color = mode["color"]

/datum/action/cooldown/spell/conjure_summon/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(owner, TRAIT_CONJURE_BACKLASH))
		if(feedback)
			owner.balloon_alert(owner, "the backlash still grips me!")
		return FALSE

/datum/action/cooldown/spell/conjure_summon/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(!validate_cast_location(cast_on, user))
		return FALSE

	var/at_capacity = (length(conjured_mobs) >= max_summons)
	if(at_capacity)
		dismiss_summons(conjured_mobs.Copy())
	var/to_spawn = at_capacity ? summons_per_cast : min(summons_per_cast, max_summons - length(conjured_mobs))
	if(to_spawn < 1)
		to_spawn = 1

	var/list/all_summoned = list()
	for(var/i in 1 to to_spawn)
		var/turf/spawn_turf = get_summon_turf(user, cast_on, i)
		var/mob/living/summoned = spawn_summon(spawn_turf, user)
		if(summoned)
			all_summoned += summoned
	if(!length(all_summoned))
		return FALSE
	for(var/mob/living/summoned in all_summoned)
		conjured_mobs += summoned
		RegisterSignal(summoned, COMSIG_QDELETING, PROC_REF(remove_conjure))
		summoned.AddComponent(/datum/component/conjured_minion, user, recoil_energy_floor, recoil_severity, recoil_stamina_only)
		var/turf/landing = get_turf(summoned)
		landing?.zFall(summoned)
	on_summon_complete(user, cast_on, all_summoned)
	return TRUE

/// Checked before spawning starts. Override to skip/replace the default "cast_on must be open" check.
/datum/action/cooldown/spell/conjure_summon/proc/validate_cast_location(atom/cast_on, mob/living/user)
	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T) || T.is_blocked_turf())
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/conjure_summon/proc/spawn_summon(turf/T, mob/living/user)
	return TRUE

/// Where the Nth summon of this cast lands. Default: everyone piles on cast_on's turf.
/datum/action/cooldown/spell/conjure_summon/proc/get_summon_turf(mob/living/user, atom/cast_on, index)
	return get_turf(cast_on)

/// Fires once, after all mobs for this cast have been created and registered. Good spot for AI targeting etc.
/datum/action/cooldown/spell/conjure_summon/proc/on_summon_complete(mob/living/user, atom/cast_on, list/summoned_mobs)
	return

/datum/action/cooldown/spell/conjure_summon/proc/get_summon_tier(mob/living/user)
	var/lvl = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane)
	if(lvl >= SKILL_LEVEL_MASTER)
		return 3
	if(lvl >= SKILL_LEVEL_EXPERT)
		return 2
	return 1

/datum/action/cooldown/spell/conjure_summon/proc/dismiss_summons(list/mobs)
	for(var/mob/living/M in mobs)
		dismiss_conjured_minion(M)

/datum/action/cooldown/spell/conjure_summon/proc/remove_conjure(mob/living/summoned)
	SIGNAL_HANDLER
	conjured_mobs -= summoned

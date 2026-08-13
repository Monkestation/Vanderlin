#define CONJURE_UNTETHER_ID "conjure_untether"
#define CONJURE_DISMISS_FADE_TIME (4 SECONDS)
#define CONJURE_RECOIL_SLOW "conjure_recoil_slow"

/datum/component/conjured_minion
	var/datum/weakref/summoner_ref
	var/recoil_energy_floor = 200
	var/recoil_severity = CONJURE_RECOIL_FULL
	var/recoil_stamina_only = FALSE
	var/dismissing = FALSE
	var/leash_range = 12
	COOLDOWN_DECLARE(next_leash_message)
	var/base_alpha = 255
	var/untether_strain = 0
	var/untether_max = 10
	var/tether_timer

/datum/component/conjured_minion/Initialize(mob/living/summoner, energy_floor = 200, severity = CONJURE_RECOIL_FULL, stamina_only = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	summoner_ref = WEAKREF(summoner)
	recoil_energy_floor = energy_floor
	recoil_severity = severity
	recoil_stamina_only = stamina_only
	if(isliving(summoner))
		summoner.add_summoned_minion(parent)
	ADD_TRAIT(parent, TRAIT_CONJURED_SUMMON, REF(src))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_summon_death))
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_leash))
	if(ishuman(parent))
		apply_phantasmal()
		RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	var/mob/living/M = parent
	base_alpha = M.alpha
	make_docile()
	addtimer(CALLBACK(src, PROC_REF(make_docile)), 1.5 SECONDS)
	tether_timer = addtimer(CALLBACK(src, PROC_REF(check_tether)), 4 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/component/conjured_minion/proc/make_docile()
	var/mob/living/M = parent
	if(QDELETED(M) || !M.ai_controller)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner)
		return
	M.ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, summoner)
	M.ai_controller.set_blackboard_key(BB_TARGETTING_DATUM, GLOB.conjured_targetting)
	M.pet_passive = TRUE

/datum/component/conjured_minion/Destroy(force, silent)
	if(tether_timer)
		deltimer(tether_timer)
		tether_timer = null
	var/mob/living/summoner = summoner_ref?.resolve()
	if(isliving(summoner))
		summoner.remove_summoned_minion(parent)
	if(!QDELETED(parent))
		REMOVE_TRAIT(parent, TRAIT_CONJURED_SUMMON, REF(src))
		var/mob/living/M = parent
		M.remove_movespeed_modifier(CONJURE_UNTETHER_ID)
	return ..()

/datum/component/conjured_minion/proc/on_summon_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(dismissing)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner || summoner.stat == DEAD)
		return
	if(untether_strain > 0 || summoner.z != source.z || get_dist(source, summoner) > leash_range)
		to_chat(summoner, span_warning("A dull ache echoes down the leyline - [source] has perished beyond the tether's reach."))
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(apply_conjure_recoil), summoner, recoil_energy_floor, recoil_severity, 1, TRUE, recoil_stamina_only)

/datum/component/conjured_minion/proc/check_leash(atom/movable/source, atom/newloc)
	SIGNAL_HANDLER
	var/mob/living/M = source
	var/mob/living/summoner = summoner_ref?.resolve()
	if(!summoner || summoner.z != source.z)
		return
	var/datum/ai_controller/AC = M.ai_controller
	if(AC?.blackboard[BB_TRAVEL_DESTINATION])
		return
	var/newdist = get_dist(newloc, summoner)
	if(newdist <= leash_range)
		return
	if(newdist < get_dist(source, summoner))
		return
	if(M.client && COOLDOWN_FINISHED(src, next_leash_message))
		COOLDOWN_START(src, next_leash_message, 3 SECONDS)
		to_chat(M, span_warning("The tether binding you to your body stops you from moving further.."))
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/component/conjured_minion/proc/check_tether()
	var/mob/living/M = parent
	if(QDELETED(M) || dismissing)
		return
	var/mob/living/summoner = summoner_ref?.resolve()
	validate_combat_target(M, summoner)
	if(summoner && !QDELETED(summoner) && summoner.z == M.z && get_dist(M, summoner) <= leash_range)
		if(untether_strain > 0)
			relax_tether(M)
		return
	strain_tether(M)

/datum/component/conjured_minion/proc/validate_combat_target(mob/living/M, mob/living/summoner)
	var/datum/ai_controller/AC = M.ai_controller
	if(!AC)
		return
	var/mob/living/current = AC.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isnull(current))
		return
	if(!QDELETED(current) && !current.stat)
		if(!summoner || QDELETED(summoner) || summoner.z != M.z)
			return
		if(get_dist(current, summoner) <= leash_range + 1)
			return
	AC.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	if(AC.blackboard[BB_HIGHEST_THREAT_MOB] == current)
		AC.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	var/list/table = AC.blackboard[BB_MOB_AGGRO_TABLE]
	if(islist(table))
		table -= current

/datum/component/conjured_minion/proc/strain_tether(mob/living/M)
	untether_strain++
	var/mob/living/summoner = summoner_ref?.resolve()
	if(untether_strain == 1)
		M.visible_message(span_warning("[M] flickers, its form straining against the distant leyline."))
		if(summoner)
			to_chat(summoner, span_warning("I feel the tether to [M] strain - my servant is beyond my reach."))
	M.alpha = max(50, M.alpha - 12)
	M.add_movespeed_modifier(CONJURE_UNTETHER_ID, update = TRUE, override = TRUE, multiplicative_slowdown = min(untether_strain, 2) * 0.6)
	if(untether_strain == untether_max - 2 && summoner)
		to_chat(summoner, span_userdanger("The tether to [M] is fraying - it will unravel unless I close the distance!"))
	if(untether_strain < untether_max)
		return
	if(M.ckey)
		untether_strain = untether_max
		return
	M.visible_message(span_warning("[M] loses all cohesion, unraveling as the leyline tether snaps."))
	dismiss_conjured_minion(M)

/datum/component/conjured_minion/proc/relax_tether(mob/living/M)
	untether_strain = 0
	M.remove_movespeed_modifier(CONJURE_UNTETHER_ID)
	M.alpha = base_alpha
	M.visible_message(span_notice("[M] steadies as its master's presence returns."))

/datum/component/conjured_minion/proc/apply_phantasmal()
	var/mob/living/M = parent
	M.alpha = 170
	var/col = get_phantom_color()
	M.add_atom_colour(soften_color(col, 0.55), FIXED_COLOUR_PRIORITY)
	M.filters += filter(type = "drop_shadow", x = 0, y = 0, size = 2, offset = 0, color = col)

/datum/component/conjured_minion/proc/soften_color(col, blend = 0.55)
	var/list/parts = ReadRGB(col)
	if(length(parts) < 3)
		return col
	return rgb(parts[1] + (255 - parts[1]) * blend, parts[2] + (255 - parts[2]) * blend, parts[3] + (255 - parts[3]) * blend)

/datum/component/conjured_minion/proc/get_phantom_color()
	var/mob/living/summoner = summoner_ref?.resolve()
	var/key = summoner ? "[summoner.real_name]" : "arcyne"
	var/hash = 0
	for(var/i in 1 to length(key))
		hash += text2ascii(key, i)
	var/list/palette = list("#d13b2e", "#e0a020")
	return palette[(hash % length(palette)) + 1]

/datum/component/conjured_minion/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/summoner = summoner_ref?.resolve()
	examine_list += span_notice("A phantasmal servant, bound to the will of [summoner ? summoner.real_name : "an unknown magus"].")

#undef CONJURE_UNTETHER_ID

/mob/living/carbon/human/proc/release_conjured_gear()
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		if(HAS_TRAIT(gear, TRAIT_NODROP))
			qdel(gear)
		else
			dropItemToGround(gear, force = TRUE)

/mob/living/proc/add_summoned_minion(mob/living/summon)
	if(QDELETED(summon))
		return
	if(!summoned_minions)
		summoned_minions = list()
	if(summon in summoned_minions)
		return
	if(!length(summoned_minions))
		request_attack_relay()
		RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(relay_attack_to_summons), override = TRUE)
		RegisterSignal(src, COMSIG_MOB_ITEM_ATTACK, PROC_REF(relay_weapon_attack_to_summons), override = TRUE)
		RegisterSignal(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(relay_unarmed_attack_to_summons), override = TRUE)
	summoned_minions += summon

/mob/living/proc/remove_summoned_minion(mob/living/summon)
	if(!summoned_minions || !(summon in summoned_minions))
		return
	summoned_minions -= summon
	if(length(summoned_minions))
		return
	summoned_minions = null
	UnregisterSignal(src, list(COMSIG_ATOM_WAS_ATTACKED, COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	release_attack_relay()

/mob/living/proc/request_attack_relay()
	attack_relay_refs++
	if(attack_relay_refs > 1)
		return
	if(!HAS_TRAIT(src, TRAIT_RELAYING_ATTACKER))
		AddElement(/datum/element/relay_attackers)
		attack_relay_self_added = TRUE

/mob/living/proc/release_attack_relay()
	if(attack_relay_refs <= 0)
		return
	attack_relay_refs--
	if(attack_relay_refs > 0)
		return
	if(attack_relay_self_added)
		RemoveElement(/datum/element/relay_attackers)
		attack_relay_self_added = FALSE

/mob/living/proc/relay_attack_to_summons(mob/living/source, atom/attacker, damage)
	SIGNAL_HANDLER
	if(!isliving(attacker) || !length(summoned_minions))
		return
	for(var/mob/living/summon in summoned_minions)
		if(QDELETED(summon) || summon.stat == DEAD || summon == attacker)
			continue
		if(summon.faction_check_atom(attacker))
			continue
		var/datum/component/ai_aggro_system/aggro = summon.GetComponent(/datum/component/ai_aggro_system)
		if(!aggro)
			continue
		aggro.add_threat_to_mob_capped(attacker, 24, 24)

/mob/living/proc/relay_weapon_attack_to_summons(datum/source, mob/target, mob/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(weapon && !weapon.force)
		return
	propagate_focus_aggro(target)

/mob/living/proc/relay_unarmed_attack_to_summons(datum/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!cmode)
		return
	propagate_focus_aggro(target)

/mob/living/proc/propagate_focus_aggro(atom/target)
	if(!isliving(target) || target == src || !length(summoned_minions))
		return
	for(var/mob/living/summon in summoned_minions)
		if(QDELETED(summon) || summon.stat == DEAD || summon == target)
			continue
		if(summon.faction_check_atom(target))
			continue
		var/datum/component/ai_aggro_system/aggro = summon.GetComponent(/datum/component/ai_aggro_system)
		if(!aggro)
			continue
		aggro.add_threat_to_mob_capped(target, 18, 18)


/proc/dismiss_conjured_minion(mob/living/M)
	if(QDELETED(M))
		return
	var/datum/component/conjured_minion/minion = M.GetComponent(/datum/component/conjured_minion)
	if(minion)
		minion.dismissing = TRUE
	M.ai_controller?.set_ai_status(AI_STATUS_OFF)
	M.visible_message(span_notice("[M] unravels, dissolving back into the leyline."))
	animate(M, alpha = 0, time = 4 SECONDS)
	QDEL_IN(M, 4 SECONDS)


/mob/living/proc/conjure_damage_fraction()
	if(maxHealth <= 0)
		return 0
	var/total = getBruteLoss() + getFireLoss() + getToxLoss() + getOxyLoss()
	return clamp(total / maxHealth, 0, 1)

/proc/apply_conjure_recoil(mob/living/summoner, energy_floor = 200, severity = CONJURE_RECOIL_FULL, scale = 1, block = TRUE, stamina_only = FALSE)
	if(!istype(summoner))
		return
	scale = clamp(scale, 0, 1)
	if(scale <= 0)
		return
	if(stamina_only)
		summoner.adjust_stamina(-round(summoner.maximum_stamina * 0.5 * scale))
		to_chat(summoner, span_warning("The leyline snaps taut and tears the wind from me as my primordial unravels."))
		scale *= 0.5
		block = FALSE
	if(severity == CONJURE_RECOIL_LIGHT)
		to_chat(summoner, span_warning("A jolt of pain stings me as my conjured servant falls."))
		return

	if(summoner.energy > energy_floor)
		summoner.energy = max(energy_floor, summoner.energy - (summoner.energy - energy_floor) * scale)

	var/list/base_stats
	var/base_duration
	if(severity == CONJURE_RECOIL_FULL)
		base_stats = list(STAT_STRENGTH = -4, STAT_SPEED = -4, STAT_CONSTITUTION = -4, STAT_ENDURANCE = -4, STATKEY_PER = -3, STAT_INTELLIGENCE = -3)
		base_duration = 3 MINUTES
	else
		base_stats = list(STAT_STRENGTH = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2)
		base_duration = 45 SECONDS

	if(block)
		var/slow_time = round(30 * scale)
		if(slow_time > 0)
			summoner.add_movespeed_modifier(CONJURE_RECOIL_SLOW, update = TRUE, override = TRUE, multiplicative_slowdown = 2 * scale)
			addtimer(CALLBACK(summoner, TYPE_PROC_REF(/mob, remove_movespeed_modifier), CONJURE_RECOIL_SLOW), slow_time)
		summoner.emote("painscream")
		to_chat(summoner, span_userdanger("Agony tears through me as my conjured servant is struck down!"))
	else if(!stamina_only)
		to_chat(summoner, span_warning("A cold recoil ripples through me as I unbind my servant."))

	summoner.apply_status_effect(/datum/status_effect/debuff/conjure_backlash, scale, base_stats, base_duration, block)
	summoner.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)

/datum/status_effect/debuff/conjure_backlash
	id = "conjure_backlash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	status_type = STATUS_EFFECT_REPLACE
	duration = 3 MINUTES
	var/blocks_resummon = FALSE

/datum/status_effect/debuff/conjure_backlash/on_creation(mob/living/new_owner, scale = 1, list/base_stats, base_duration = 45 SECONDS, block = FALSE)
	scale = clamp(scale, 0, 1)
	blocks_resummon = block
	var/list/scaled = list()
	if(islist(base_stats))
		for(var/statkey in base_stats)
			var/mag = round(abs(base_stats[statkey]) * scale)
			if(mag)
				scaled[statkey] = -mag
	effectedstats = scaled
	duration = max(1 SECONDS, round(base_duration * scale))
	return ..(new_owner)

/datum/status_effect/debuff/conjure_backlash/on_apply()
	. = ..()
	if(!.)
		return
	if(blocks_resummon)
		ADD_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")

/datum/status_effect/debuff/conjure_backlash/on_remove()
	if(blocks_resummon)
		REMOVE_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")
	return ..()

/datum/status_effect/debuff/conjure_backlash/be_replaced()
	if(blocks_resummon)
		REMOVE_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")
	return ..()

/atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	name = "Conjurer's Backlash"
	desc = "The unbinding of my conjured servant recoils upon me - the more grievously it was hurt, the deeper the toll. My body and focus are sapped until it passes."
	icon_state = "debuff"

#undef CONJURE_DISMISS_FADE_TIME
#undef CONJURE_RECOIL_SLOW

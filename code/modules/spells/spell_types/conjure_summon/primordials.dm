/datum/action/cooldown/spell/conjure_summon/primordial
	name = "Conjure Flame Primordial"
	desc = "Conjure a Primordial to fight at your side. Toggle its element with Shift+G while the spell is selected: Flame, Water, or Air. \
	It grows mightier with your skill at Arcyne Armament - upgrading at Expert, and further at Master.\
	An elemental of moderate health and damage, able to breath out fire in a cone in front of them."
	button_icon_state = "primetriangle"
	invocation = "Exsurge, ignis!"
	summon_noun = "primordial"
	recoil_energy_floor = 150
	required_form = FORM_FIRE
	var/mob_path = /mob/living/simple_animal/hostile/retaliate/primordial/fire

/datum/action/cooldown/spell/conjure_summon/primordial/air
	name = "Conjure Air Primordial"
	desc = "Conjure a Primordial to fight at your side. Toggle its element with Shift+G while the spell is selected: Flame, Water, or Air. \
	It grows mightier with your skill at Arcyne Armament - upgrading at Expert, and further at Master.\
	A fast elemental with the highest melee damage, lowest health able to throw targets back"
	required_form = FORM_AIR
	mob_path = /mob/living/simple_animal/hostile/retaliate/primordial/air

/datum/action/cooldown/spell/conjure_summon/primordial/water
	name = "Conjure Water Primordial"
	desc = "Conjure a Primordial to fight at your side. Toggle its element with Shift+G while the spell is selected: Flame, Water, or Air. \
	It grows mightier with your skill at Arcyne Armament - upgrading at Expert, and further at Master.\
	A slow elemental with high health able to create a whirlpool around themselves"
	required_form = FORM_WATER
	mob_path = /mob/living/simple_animal/hostile/retaliate/primordial/water

/datum/action/cooldown/spell/conjure_summon/primordial/spawn_summon(turf/T, mob/living/user)
	var/mob/living/simple_animal/hostile/retaliate/primordial/conjured = new mob_path(T, user)
	scale_primordial(conjured, user)
	return conjured

/datum/action/cooldown/spell/conjure_summon/primordial/proc/scale_primordial(mob/living/simple_animal/hostile/retaliate/primordial/P, mob/living/user)
	var/tier = get_summon_tier(user)
	var/mult = 1 + (tier - 1) * 0.2
	P.maxHealth = round(P.maxHealth * mult)
	P.health = P.maxHealth
	P.melee_damage_lower = round(P.melee_damage_lower * mult)
	P.melee_damage_upper = round(P.melee_damage_upper * mult)

#define CONJURE_TAUNT_TELEGRAPH (1.5 SECONDS)
#define CONJURE_OVERLOAD_WINDUP (3.5 SECONDS)

/obj/effect/temp_visual/conjure_taunt
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	duration = CONJURE_TAUNT_TELEGRAPH

/datum/action/cooldown/spell/command_word
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	sound = null

	click_to_activate = TRUE
	cast_range = 12
	self_cast_possible = TRUE

	spell_cost = 0

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/current_mode = 1
	var/list/modes = list()
	var/command_range = 12
	var/focusing = FALSE

/datum/action/cooldown/spell/command_word/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/command_word/proc/apply_mode(index)
	if(!length(modes))
		return
	current_mode = index
	var/list/mode = modes[index]
	invocation = mode["invocation"]
	cooldown_time = mode["cooldown"]
	build_all_button_icons()
	update_mode_maptext()

/datum/action/cooldown/spell/command_word/toggle_alt_mode(mob/user)
	if(length(modes) < 2)
		return FALSE
	apply_mode((current_mode % length(modes)) + 1)
	if(user)
		user.balloon_alert(user, modes[current_mode]["name"])
	return TRUE

/datum/action/cooldown/spell/command_word/proc/update_mode_maptext()
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

/datum/action/cooldown/spell/command_word/cast(atom/cast_on)
	. = ..()
	return fire_command(cast_on)

/datum/action/cooldown/spell/command_word/proc/get_summons_in_range()
	var/mob/living/user = owner
	var/list/found = list()
	if(!istype(user))
		return found
	for(var/mob/living/M in user.summoned_minions)
		if(QDELETED(M) || M.stat == DEAD || M == user)
			continue
		if(get_dist(user, M) > command_range)
			continue
		found += M
	return found

/datum/action/cooldown/spell/command_word/proc/find_nearest_enemy(mob/living/summon)
	var/mob/living/nearest
	var/nearest_dist = INFINITY
	for(var/mob/living/L in oview(9, summon))
		if(QDELETED(L) || L.stat == DEAD || L == summon)
			continue
		if(summon.faction_check_atom(L))
			continue
		var/d = get_dist(summon, L)
		if(d < nearest_dist)
			nearest_dist = d
			nearest = L
	return nearest

/datum/action/cooldown/spell/command_word/proc/fire_command(atom/cast_on)
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/list/summons = get_summons_in_range()
	if(!length(summons))
		to_chat(user, span_warning("I have no conjured servants at hand to command."))
		return FALSE

	var/atom/aim
	if(isliving(cast_on) && !(cast_on in summons) && cast_on != user)
		aim = cast_on
	else if(isturf(cast_on))
		aim = cast_on

	var/key = modes[current_mode]["key"]
	if(key == "focus")
		return do_focus(summons)
	if(key == "taunt")
		return do_taunt(summons, get_turf(cast_on))
	if(key == "overload")
		var/mob/living/bomb = pick_overload_summon(summons, cast_on)
		if(!bomb)
			return FALSE
		to_chat(user, span_userdanger("[bomb] surges with unstable arcyne power - it will overload!"))
		return summon_overload(bomb)

	var/count = 0
	var/balloon = "<font color='[modes[current_mode]["color"]]'>[LOWER_TEXT(modes[current_mode]["name"])]!</font>"
	for(var/mob/living/summon in summons)
		if(command_summon(summon, key, aim))
			summon.balloon_alert_to_viewers(balloon)
			count++

	if(!count)
		to_chat(user, span_warning("None of my servants can answer that command right now."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/command_word/proc/command_summon(mob/living/summon, key, atom/aim)
	switch(key)
		if("special")
			return summon_special(summon, aim)
		if("feint")
			return summon_feint(summon, aim)
		if("kick")
			return summon_kick(summon, aim)
		if("surge", "bloodrush", "empower")
			return empower_summon(summon, key, aim)
		if("target")
			return summon_target(summon, aim)
	return FALSE

/datum/action/cooldown/spell/command_word/proc/is_primordial(mob/living/summon)
	return istype(summon, /mob/living/simple_animal/hostile/retaliate/primordial)

/datum/action/cooldown/spell/command_word/proc/primordial_ward(mob/living/simple_animal/hostile/retaliate/primordial/P)
	P.defprob = min(initial(P.defprob) + 40, 95)
	addtimer(CALLBACK(src, PROC_REF(end_primordial_ward), P), 5 SECONDS)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/end_primordial_ward(mob/living/simple_animal/hostile/retaliate/primordial/P)
	if(QDELETED(P))
		return
	P.defprob = initial(P.defprob)

/datum/action/cooldown/spell/command_word/proc/primordial_heal(mob/living/simple_animal/hostile/retaliate/primordial/P)
	if(!COOLDOWN_FINISHED(P, next_heal_time))
		return FALSE
	COOLDOWN_START(P, next_heal_time, 15 SECONDS)
	P.adjustHealth(-round(P.maxHealth * 0.25))
	return TRUE

/datum/action/cooldown/spell/command_word/proc/primordial_overcharge(mob/living/simple_animal/hostile/retaliate/primordial/P)
	P.next_ability_use = 0
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_target(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target)
		summon.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		summon.balloon_alert_to_viewers("cleared target")
		summon.pet_passive = TRUE
		return TRUE
	if(target == summon.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		summon.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		summon.balloon_alert_to_viewers("cleared target")
		summon.pet_passive = TRUE
		return TRUE
	summon.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	summon.balloon_alert_to_viewers("target set")
	summon.pet_passive = FALSE
	return TRUE


/datum/action/cooldown/spell/command_word/proc/summon_special(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target)
		target = summon.ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!target)
		return FALSE

	if(!summon.ai_controller)
		return fire_special_direct(summon, target)

	summon.ai_controller.set_blackboard_key(BB_COMMANDED_TARGET, target)
	summon.ai_controller.set_blackboard_key(BB_COMMANDED_ACTION, "special")
	return TRUE

/datum/action/cooldown/spell/command_word/proc/fire_special_direct(mob/living/summon, atom/target)
	summon.face_atom(target)

	if(istype(summon, /mob/living/simple_animal/hostile/retaliate/primordial))
		var/mob/living/simple_animal/hostile/retaliate/primordial/P = summon
		if(!COOLDOWN_FINISHED(P, next_ability_use))
			return FALSE
		P.ability(get_turf(target), P)
		COOLDOWN_START(P, next_ability_use, P.ability_cooldown)
		return TRUE

	if(summon.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE
	var/obj/item/weapon/W = summon.get_active_held_item()
	if(!istype(W) || !W.weapon_special)
		return FALSE
	if(!W.weapon_special.apply_cost(summon))
		return FALSE
	W.weapon_special.deploy(summon, W, target)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_feint(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target)
		target = summon.ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!isliving(target))
		return FALSE

	if(!summon.ai_controller)
		return fire_feint_direct(summon, target)

	summon.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	summon.ai_controller.set_blackboard_key(BB_COMMANDED_TARGET, target)
	summon.ai_controller.set_blackboard_key(BB_COMMANDED_ACTION, "feint")
	return TRUE

/datum/action/cooldown/spell/command_word/proc/fire_feint_direct(mob/living/summon, mob/living/target)
	summon.face_atom(target)
	var/was_passive = FALSE
	if(isanimal(summon))
		var/mob/living/simple_animal/SA = summon
		was_passive = SA.pet_passive
		SA.pet_passive = FALSE
	var/datum/rmb_intent/feint/F = new()
	F.special_attack(summon, target)
	if(was_passive)
		addtimer(CALLBACK(src, PROC_REF(restore_pet_passive), summon), 3 SECONDS)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/summon_kick(mob/living/summon, atom/aim)
	var/atom/target = aim
	if(!target)
		target = summon.ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		target = find_nearest_enemy(summon)
	if(!isliving(target))
		return FALSE

	if(!summon.ai_controller)
		if(!summon.Adjacent(target))
			return FALSE //no controller to path with, fall back to old adjacent-only behavior
		summon.face_atom(target)
		if(is_primordial(summon))
			return primordial_shove(summon, target)
		INVOKE_ASYNC(src, PROC_REF(do_kick), summon, target)
		return TRUE

	summon.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	summon.ai_controller.set_blackboard_key(BB_COMMANDED_TARGET, target)
	summon.ai_controller.set_blackboard_key(BB_COMMANDED_ACTION, "kick")
	return TRUE

/datum/action/cooldown/spell/command_word/proc/primordial_shove(mob/living/simple_animal/hostile/retaliate/primordial/P, mob/living/target)
	var/shove_dir = get_dir(P, target)
	var/turf/dest = get_ranged_target_turf(target, shove_dir, 2)
	if(dest)
		target.throw_at(dest, 2, 1, P)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_kick(mob/living/summon, mob/living/target)
	if(QDELETED(summon) || QDELETED(target))
		return
	var/old_mmb = summon.mmb_intent
	summon.mmb_intent = new INTENT_KICK(summon)
	target.onkick(summon)
	QDEL_NULL(summon.mmb_intent)
	summon.mmb_intent = old_mmb

/datum/action/cooldown/spell/command_word/proc/restore_pet_passive(mob/living/summon)
	if(QDELETED(summon) || !isanimal(summon))
		return
	var/mob/living/simple_animal/SA = summon
	SA.pet_passive = TRUE

/datum/action/cooldown/spell/command_word/proc/do_focus(list/summons)
	focusing = !focusing
	var/mob/living/user = owner
	var/zone = user.zone_selected
	var/count = 0
	for(var/mob/living/summon in summons)
		if(!summon.ai_controller)
			continue //player-piloted summons have no blackboard targeting for Focus to act on
		if(focusing)
			summon.ai_controller.set_blackboard_key(BB_FORCED_ATTACK_ZONE, zone)
			summon.balloon_alert_to_viewers("<font color='[modes[current_mode]["color"]]'>focus!</font>")
		else
			summon.ai_controller.clear_blackboard_key(BB_FORCED_ATTACK_ZONE)
		count++
	if(!count)
		return TRUE
	if(focusing)
		to_chat(user, span_notice("My servants lock onto where I aim - the [parse_zone(zone)]."))
	else
		to_chat(user, span_notice("My servants return to striking where they see fit."))
	return TRUE

/datum/action/cooldown/spell/command_word/proc/overload_scale(mob/living/summon)
	if(istype(summon, /mob/living/simple_animal/hostile/retaliate/primordial))
		return 0.5
	return 1

/datum/action/cooldown/spell/command_word/proc/pick_overload_summon(list/summons, atom/cast_on)
	if(isliving(cast_on) && (cast_on in summons))
		return cast_on
	var/turf/ref = get_turf(cast_on)
	if(!ref)
		ref = get_turf(owner)
	var/mob/living/best
	var/best_dist = INFINITY
	for(var/mob/living/S in summons)
		var/d = get_dist(S, ref)
		if(d < best_dist)
			best_dist = d
			best = S
	return best

/datum/action/cooldown/spell/command_word/proc/summon_overload(mob/living/summon)
	summon.do_jitter_animation(1000)
	summon.Slowdown(3)
	summon.balloon_alert_to_viewers("<font color='[GLOB.form_colors[FORM_FIRE]]'>detonating! (-4 spd)</font>")
	addtimer(CALLBACK(src, PROC_REF(do_overload), summon, overload_scale(summon)), CONJURE_OVERLOAD_WINDUP)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_overload(mob/living/summon, scale)
	if(QDELETED(summon) || summon.stat == DEAD)
		return
	var/turf/epicenter = get_turf(summon)
	if(!epicenter)
		return
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		caster = null
	var/zone = summon.zone_selected || BODY_ZONE_CHEST
	var/damage = round(120 * scale)
	var/curtain_life = (scale >= 1) ? 8 SECONDS : 3 SECONDS
	new /obj/effect/temp_visual/explosion(epicenter)
	new /obj/effect/temp_visual/fire_pillar(epicenter)
	playsound(epicenter, pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 100, TRUE)
	for(var/turf/T in range(1, epicenter))
		new /obj/effect/temp_visual/dragonfire(T)
		new /obj/effect/curtain_fire(T, curtain_life, caster)
		for(var/mob/living/victim in T)
			if(victim == summon || victim == caster || victim.stat == DEAD)
				continue
			if(summon.faction_check_atom(victim))
				continue
			if(caster && !QDELETED(caster))
				arcyne_strike(caster, victim, null, damage, zone, BCLASS_BURN, spell_name = "Overloaded", damage_type = BURN, skip_animation = TRUE)
			else
				victim.adjustFireLoss(damage)
			apply_scorch_stack(victim, 2, zone)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)
	summon.death()

/datum/action/cooldown/spell/command_word/proc/empower_summon(mob/living/summon, key, atom/aim)
	if(is_primordial(summon))
		switch(key)
			if("surge", "bloodrush")
				return primordial_heal(summon)
			if("empower")
				return primordial_overcharge(summon)
		return FALSE
	switch(key)
		if("surge")
			return do_surge(summon)
		if("bloodrush")
			summon.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
			return TRUE
		if("empower")
			if(summon.has_status_effect(/datum/status_effect/buff/empowered_strike))
				return FALSE
			summon.apply_status_effect(/datum/status_effect/buff/empowered_strike, 10 SECONDS)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/command_word/proc/do_surge(mob/living/summon)
	summon.SetUnconscious(0)
	summon.SetSleeping(0)
	summon.SetParalyzed(0)
	summon.SetImmobilized(0)
	summon.SetStun(0)
	summon.SetKnockdown(0)
	if(summon.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		summon.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	summon.set_resting(FALSE)
	summon.adjust_stamina(10)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/do_taunt(list/summons, turf/dest)
	if(!isturf(dest) || !length(summons))
		return FALSE
	new /obj/effect/temp_visual/conjure_taunt(dest)
	for(var/mob/living/summon in summons)
		if(QDELETED(summon) || summon.stat == DEAD)
			continue
		summon.Beam(dest, "purple_lightning", time = CONJURE_TAUNT_TELEGRAPH)
	playsound(dest, 'sound/magic/charging.ogg', 60, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_taunt), summons.Copy(), dest), CONJURE_TAUNT_TELEGRAPH)
	return TRUE

/datum/action/cooldown/spell/command_word/proc/finish_taunt(list/summons, turf/dest)
	if(!isturf(dest))
		return
	new /obj/effect/temp_visual/blink(dest)
	playsound(dest, 'sound/magic/blink.ogg', 60, TRUE)
	for(var/mob/living/summon in summons)
		if(QDELETED(summon) || summon.stat == DEAD)
			continue
		if(!do_teleport(summon, dest, precision = 2, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
			var/turf/landing = get_teleport_turf(dest, 2)
			if(landing)
				summon.forceMove(landing)
		summon.balloon_alert_to_viewers("<font color='#e0a020'>taunt!</font>")
		summon.emote("warcry")
		if(summon.ai_controller)
			var/mob/living/foe = find_nearest_enemy(summon)
			if(foe)
				summon.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, foe)
				summon.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, foe)
		if(isanimal(summon))
			var/mob/living/simple_animal/SA = summon
			SA.pet_passive = FALSE
		for(var/mob/living/enemy in oview(5, summon))
			if(QDELETED(enemy) || enemy.stat == DEAD || enemy == summon)
				continue
			if(summon.faction_check_atom(enemy))
				continue
			var/datum/component/ai_aggro_system/A = enemy.GetComponent(/datum/component/ai_aggro_system)
			if(A)
				A.add_threat_to_mob(summon, 100)

/datum/action/cooldown/spell/command_word/fray
	name = "Fray"
	desc = "Battle order. Order your summon to unleash a Special, or set a target. Toggle with Shift+G"
	button_icon_state = "order_servants"
	invocation_type = INVOCATION_SHOUT
	invocation = "Impetum!"
	cooldown_time = 1 SECONDS
	modes = list(
		list("name" = "Target", "tag" = "TGT", "key" = "target", "color" = "#e0a020", "invocation" = "Calcitra!", "cooldown" = 6 SECONDS, "desc" = ""),
		list("name" = "Special", "tag" = "SPC", "key" = "special", "color" = LIGHT_COLOR_FIRE, "invocation" = "Impetum!", "cooldown" = 1 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/harry
	name = "Harry"
	desc = "Order your summons to Feint or Kick your enemies. Toggle with Shift+G."
	button_icon_state = "aetherknife"
	invocation_type = INVOCATION_SHOUT
	invocation = "Fallere!"
	cooldown_time = 6 SECONDS
	modes = list(
		list("name" = "Feint", "tag" = "FNT", "key" = "feint", "color" = "#c9a0ff", "invocation" = "Fallere!", "cooldown" = 6 SECONDS, "desc" = ""),
		list("name" = "Kick", "tag" = "KCK", "key" = "kick", "color" = "#e0a020", "invocation" = "Calcitra!", "cooldown" = 6 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/quicken
	name = "Quicken"
	desc = "Powerful abilities to quicken your summons. Empower let their next strike bypass Guard, and reset a Primordial's ability cooldown. Surge removes stun and Blood Rush floods it with vigor and blood. Toggle with Shift+G."
	button_icon_state = "conjure_aegis"
	invocation_type = INVOCATION_SHOUT
	invocation = "Vera Manus!"
	cooldown_time = 25 SECONDS
	spell_cost = 10
	modes = list(
		list("name" = "Empower", "tag" = "EMP", "key" = "empower", "color" = "#d13b2e", "invocation" = "Vera Manus!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Surge", "tag" = "SRG", "key" = "surge", "color" = "#d13b2e", "invocation" = "Resurge!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Blood Rush", "tag" = "RSH", "key" = "bloodrush", "color" = "#d13b2e", "invocation" = "Concita!", "cooldown" = 30 SECONDS, "desc" = ""),
	)

/datum/action/cooldown/spell/command_word/beckon
	name = "Beckon"
	desc = "Taunt teleport your servants to a marked spot and attract their aggression they will attack anything that gets close, Overload makes one explode with arcyne energy, Focus sets them to strike the zone you are aiming at, it does not guarantee they'll hit. Toggle with Shift+G"
	button_icon_state = "primetriangle"
	invocation_type = INVOCATION_SHOUT
	invocation = "Provoco!"
	cooldown_time = 30 SECONDS
	modes = list(
		list("name" = "Taunt", "tag" = "TNT", "key" = "taunt", "color" = "#e0a020", "invocation" = "Provoco!", "cooldown" = 30 SECONDS, "desc" = ""),
		list("name" = "Overloaded", "tag" = "OVL", "key" = "overload", "color" = LIGHT_COLOR_FIRE, "invocation" = "Displode!", "cooldown" = 0, "desc" = ""),
		list("name" = "Focus", "tag" = "FCS", "key" = "focus", "color" = "#66ff66", "invocation" = "Coniunge!", "cooldown" = 0, "desc" = ""),
	)

#undef CONJURE_TAUNT_TELEGRAPH
#undef CONJURE_OVERLOAD_WINDUP

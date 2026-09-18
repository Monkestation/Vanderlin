#define SCORCH_ADAPTATION_DURATION (3 SECONDS)
#define SCORCH_ADAPTATION_KEY "scorch_adaptation"
#define SCORCH_OVERLAY_COLOR rgb(255, 138, 61)
#define SCORCH_BURN_DAMAGE 60

/obj/effect/temp_visual/scorch_flash
	icon = 'icons/mob/OnFire.dmi'
	icon_state = "Generic_mob_burning"
	layer = ABOVE_MOB_LAYER
	duration = 8

/proc/apply_scorch_stack(mob/living/target, stacks = 1, zone_override = null)
	if(!isliving(target))
		return
	new /obj/effect/temp_visual/scorch_flash(get_turf(target))
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
			apply_scorch_burn(target, zone_override)
			final_tier = 4
			break
		if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
			target.remove_status_effect(/datum/status_effect/debuff/scorched3)
			target.apply_status_effect(/datum/status_effect/debuff/scorched4)
			apply_scorch_burn(target, zone_override)
			final_tier = 4
			break
		if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
			target.remove_status_effect(/datum/status_effect/debuff/scorched2)
			target.apply_status_effect(/datum/status_effect/debuff/scorched3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
			target.remove_status_effect(/datum/status_effect/debuff/scorched1)
			target.apply_status_effect(/datum/status_effect/debuff/scorched2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/scorched1)
		final_tier = max(final_tier, 1)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>scorched I</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>scorched II (-1 con)</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>scorched III (-2 con)</font>")

/proc/apply_scorch_burn(mob/living/target, zone_override = null)
	if(!isliving(target))
		return FALSE
	if(target.mob_timers[SCORCH_ADAPTATION_KEY] && world.time < target.mob_timers[SCORCH_ADAPTATION_KEY])
		var/remaining = round((target.mob_timers[SCORCH_ADAPTATION_KEY] - world.time) / 10)
		target.balloon_alert_to_viewers("<font color='#ff8a3d'>fire adapted ([remaining]s)</font>")
		return FALSE
	var/target_zone = BODY_ZONE_CHEST
	var/mob/living/carbon/carbon_target
	if(iscarbon(target))
		carbon_target = target
		var/aimed_zone = zone_override ? check_zone(zone_override) : null
		if(aimed_zone && carbon_target.get_bodypart(aimed_zone))
			target_zone = aimed_zone
		else
			var/obj/item/bodypart/most_wounded
			for(var/obj/item/bodypart/BP as anything in carbon_target.bodyparts)
				if(QDELETED(BP))
					continue
				if(!most_wounded || (BP.brute_dam + BP.burn_dam) > (most_wounded.brute_dam + most_wounded.burn_dam))
					most_wounded = BP
			if(most_wounded && (most_wounded.brute_dam + most_wounded.burn_dam) > 0)
				target_zone = most_wounded.body_zone
	target.apply_damage(SCORCH_BURN_DAMAGE, BURN, target_zone, 0)
	target.mob_timers[SCORCH_ADAPTATION_KEY] = world.time + SCORCH_ADAPTATION_DURATION
	var/hit_zone_name = parse_zone(target_zone)
	target.balloon_alert_to_viewers("<font color='#ff4a2a'>CHARRED!</font>")
	target.visible_message(
		span_boldwarning("Flames burn straight through [target]'s armor, searing a wound deep into the [hit_zone_name]!"),
		span_userdanger("Flames burn straight through my armor, searing a wound deep into my [hit_zone_name]!"))
	playsound(get_turf(target), pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 100, TRUE)
	new /obj/effect/temp_visual/fire(get_turf(target))
	new /obj/effect/temp_visual/explosion(get_turf(target))
	return TRUE

/proc/remove_scorch_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
		target.remove_status_effect(/datum/status_effect/debuff/scorched4)
		target.apply_status_effect(/datum/status_effect/debuff/scorched3)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
		target.remove_status_effect(/datum/status_effect/debuff/scorched3)
		target.apply_status_effect(/datum/status_effect/debuff/scorched2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
		target.remove_status_effect(/datum/status_effect/debuff/scorched2)
		target.apply_status_effect(/datum/status_effect/debuff/scorched1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
		target.remove_status_effect(/datum/status_effect/debuff/scorched1)
		return TRUE
	return FALSE

/proc/has_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return get_scorch_stacks(target) > 0

/proc/get_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
		return 4
	if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
		return 1
	return 0

/proc/remove_all_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/scorched4)
	target.remove_status_effect(/datum/status_effect/debuff/scorched3)
	target.remove_status_effect(/datum/status_effect/debuff/scorched2)
	target.remove_status_effect(/datum/status_effect/debuff/scorched1)

/datum/status_effect/debuff/scorched1
	id = "scorched1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched1
	duration = 25 SECONDS

/atom/movable/screen/alert/status_effect/debuff/scorched1
	name = "Scorched"
	desc = "Flames lick at me, but I can shake this off."
	icon_state = "debuff"

/datum/status_effect/debuff/scorched1/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched1/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched2
	id = "scorched2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched2
	duration = 25 SECONDS
	effectedstats = list(STAT_CONSTITUTION = -1)

/atom/movable/screen/alert/status_effect/debuff/scorched2
	name = "Scorched II"
	desc = "The heat saps the vigor from my flesh."
	icon_state = "debuff"

/datum/status_effect/debuff/scorched2/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched2/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched3
	id = "scorched3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched3
	duration = 25 SECONDS
	effectedstats = list(STAT_CONSTITUTION = -2)

/atom/movable/screen/alert/status_effect/debuff/scorched3
	name = "Scorched III"
	desc = "The searing burns wrack my body, leaving it frail."
	icon_state = "debuff"

/datum/status_effect/debuff/scorched3/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched3/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched4
	id = "scorched4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched4
	duration = 25 SECONDS
	effectedstats = list(STAT_CONSTITUTION = -2)

/atom/movable/screen/alert/status_effect/debuff/scorched4
	name = "Scorched IV"
	desc = "I am utterly consumed by flame - my flesh is searing apart."
	icon_state = "debuff"

/datum/status_effect/debuff/scorched4/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched4/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

#undef SCORCH_ADAPTATION_DURATION
#undef SCORCH_ADAPTATION_KEY
#undef SCORCH_OVERLAY_COLOR
#undef SCORCH_BURN_DAMAGE

#define CURTAIN_TICK_DAMAGE 30
#define CURTAIN_BURN_KEY "curtain_burn"

/datum/action/cooldown/spell/fire_curtain
	button_icon = 'icons/mob/actions/spells/mage_pyromancy.dmi'
	name = "Fire Curtain"
	desc = "Conjure a 5x2 curtain of flame at a target location, perpendicular to your facing. \
	After a 2-second telegraph, the fire erupts. Burning for 10 seconds. \
	The fire does not block movement but will burn anything that passes through or stands in it. \
	You are not immune to your own curtain."
	button_icon_state = "fire_curtain"
	sound = 'sound/magic/fireball.ogg'

	required_technique = TECHNIQUE_CREATION
	required_form = FORM_FIRE

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	spell_cost = 50

	invocation = "Velum Ignis!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 25 SECONDS

	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/curtain_width = 5
	var/curtain_depth = 2
	var/curtain_life = 10 SECONDS
	var/telegraph_time = 3 SECONDS

/datum/action/cooldown/spell/fire_curtain/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/list/affected_turfs = get_curtain_turfs(center, H.dir)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/trap_wall/fire(T)

	H.visible_message(span_danger("[H] conjures a wall of flame!"))
	playsound(get_turf(H), 'sound/magic/charging_fire.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(spawn_curtain), affected_turfs, H, H.zone_selected), telegraph_time)
	return TRUE

/datum/action/cooldown/spell/fire_curtain/proc/get_curtain_turfs(turf/center, facing)
	var/list/row_turfs = list(center)
	var/spread_dir1
	var/spread_dir2
	if(facing == NORTH || facing == SOUTH)
		spread_dir1 = WEST
		spread_dir2 = EAST
	else
		spread_dir1 = NORTH
		spread_dir2 = SOUTH

	var/half = (curtain_width - 1) / 2
	var/turf/current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir1)
		if(current)
			row_turfs += current
	current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir2)
		if(current)
			row_turfs += current

	// Extend depth along the facing direction
	var/list/all_turfs = row_turfs.Copy()
	for(var/d in 1 to curtain_depth - 1)
		var/list/next_row = list()
		for(var/turf/T in row_turfs)
			var/turf/deep = get_step(T, facing)
			if(deep)
				all_turfs |= deep
				next_row += deep
		row_turfs = next_row
	return all_turfs

/datum/action/cooldown/spell/fire_curtain/proc/spawn_curtain(list/turfs, mob/living/caster, aim_zone)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in turfs)
		new /obj/effect/curtain_fire(T, curtain_life, caster, aim_zone)
	playsound(turfs[1], pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 120, TRUE, 6)

/obj/effect/temp_visual/trap_wall/fire
	color = LIGHT_COLOR_FIRE
	light_color = LIGHT_COLOR_FIRE
	duration = 3 SECONDS

/obj/effect/curtain_fire
	name = "wall of flame"
	desc = "A searing curtain of conjured fire."
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	object_slowdown = 15
	var/lifetime = 10 SECONDS
	var/tick_damage = CURTAIN_TICK_DAMAGE
	var/burn_cooldown = 1 SECONDS
	var/datum/weakref/caster_ref
	var/aim_zone

/obj/effect/curtain_fire/Initialize(mapload, life, mob/living/new_caster, aimed_zone)
	. = ..()
	if(life)
		lifetime = life
	if(new_caster)
		caster_ref = WEAKREF(new_caster)
	aim_zone = aimed_zone
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/curtain_fire/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/curtain_fire/Crossed(atom/movable/AM, oldLoc)
	. = ..()
	if(isliving(AM))
		burn_occupant(AM)

/obj/effect/curtain_fire/process(seconds_per_tick)
	var/turf/T = get_turf(src)
	if(!isturf(T))
		return
	for(var/mob/living/L in T)
		burn_occupant(L)

/obj/effect/curtain_fire/proc/burn_occupant(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_NOFIRE))
		return
	if(L.mob_timers[CURTAIN_BURN_KEY] && world.time < L.mob_timers[CURTAIN_BURN_KEY])
		return
	L.mob_timers[CURTAIN_BURN_KEY] = world.time + burn_cooldown
	var/hit_zone = aim_zone || BODY_ZONE_CHEST
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(istype(caster) && !QDELETED(caster))
		arcyne_strike(caster, L, null, tick_damage, hit_zone, BCLASS_BURN, spell_name = "Fire Curtain", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE)
	else
		var/fallback_zone = check_zone(hit_zone)
		var/armor_block = L.run_armor_check(fallback_zone, "fire", blade_dulling = BCLASS_BURN, damage = tick_damage)
		L.apply_damage(tick_damage, BURN, fallback_zone, armor_block)
	apply_scorch_stack(L, 1, hit_zone)
	L.emote("pain", forced = TRUE)

#undef CURTAIN_TICK_DAMAGE
#undef CURTAIN_BURN_KEY

#define BATTLE_WARD_RUNE_DURATION (1 MINUTES)
#define BATTLE_WARD_TELEGRAPH_TIME (3 SECONDS)

/datum/action/cooldown/spell/battle_ward
	button_icon = 'icons/mob/actions/spells/mage_battlewardry.dmi'
	name = "Battle Ward"
	desc = "Channel arcyne energy to inscribe a pattern of five rune wards in an X formation on a targeted area. The runes are fragile and last for one minute before fading. In addition, Battle Wards are indiscriminate unlike permanent Rune Wards, and will hit the caster and their allies. They can be circumvented by jumping or flying over them, or destroyed with a few solid hits. The type of rune placed depends on your current ward mode.\n\
	Use the Alt Mode keybind to cycle between Stun, Fire, Chill, and Damage."
	button_icon_state = "battle_ward"
	sound = 'sound/magic/charging.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	spell_cost = 40
	required_form = FORM_WATER
	required_technique = TECHNIQUE_CREATION

	invocation = "Bellitutela Inscriptum!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/ward_mode = "stun"
	var/list/ward_modes = list(
		"stun" = /obj/structure/rune_ward/stun,
		"fire" = /obj/structure/rune_ward/fire,
		"chill" = /obj/structure/rune_ward/chill,
		"damage" = /obj/structure/rune_ward/damage
	)
	var/static/list/ward_mode_labels = list("stun" = "STUN", "fire" = "FIRE", "chill" = "CHILL", "damage" = "DMG")

/datum/action/cooldown/spell/battle_ward/Grant(mob/grant_to)
	. = ..()
	update_ward_maptext()

/datum/action/cooldown/spell/battle_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/rune_path = ward_modes[ward_mode]
	if(!rune_path)
		return FALSE

	// X pattern: center + 4 corners
	var/list/target_turfs = list()
	target_turfs += center
	target_turfs += get_step(center, NORTHWEST)
	target_turfs += get_step(center, NORTHEAST)
	target_turfs += get_step(center, SOUTHWEST)
	target_turfs += get_step(center, SOUTHEAST)

	// Show telegraph visuals before runes appear
	for(var/turf/T in target_turfs)
		new /obj/effect/temp_visual/trap_wall/battle_ward(T)

	playsound(center, 'sound/magic/whiteflame.ogg', 60, TRUE)
	H.visible_message(span_warning("[H] completes a complex inscription - runes begin to materialize!"), span_notice("I finish inscribing the [ward_mode] ward pattern."))

	addtimer(CALLBACK(src, PROC_REF(spawn_runes), target_turfs, rune_path, H.real_name, H.ckey || "no ckey"), BATTLE_WARD_TELEGRAPH_TIME)
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/spawn_runes(list/turfs, rune_path, caster_name, caster_ckey)
	for(var/turf/T in turfs)
		var/obj/structure/rune_ward/rune = new rune_path(T)
		rune.owner_name = caster_name
		rune.owner_ckey = caster_ckey
		rune.modify_max_integrity(50)
		QDEL_IN(rune, BATTLE_WARD_RUNE_DURATION)


/datum/action/cooldown/spell/battle_ward/toggle_alt_mode(mob/user)
	var/current_index = ward_modes.Find(ward_mode)
	current_index = (current_index % length(ward_modes)) + 1
	ward_mode = ward_modes[current_index]
	var/label = ward_mode_labels[ward_mode] || uppertext(ward_mode)
	to_chat(user, span_notice("Ward mode set to: [label]."))
	update_ward_maptext()
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/update_ward_maptext()
	var/label = ward_mode_labels[ward_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 5

/obj/effect/temp_visual/trap_wall/battle_ward
	duration = BATTLE_WARD_TELEGRAPH_TIME

#undef BATTLE_WARD_RUNE_DURATION
#undef BATTLE_WARD_TELEGRAPH_TIME

#define RUNE_WARD_IMMUNITY_DURATION (3 SECONDS)
#define RUNE_WARD_IMMUNITY_KEY "rune_ward_immunity"

/obj/structure/rune_ward
	name = "arcyne rune"
	desc = "A faintly glowing symbol etched into the ground."
	icon = 'icons/misc/rune_wards.dmi'
	icon_state = "rune"
	attacked_sound = 'sound/magic/magic_nulled.ogg'
	density = FALSE
	anchored = TRUE
	alpha = 180
	layer = TURF_LAYER + 0.1
	max_integrity = 300

	var/datum/weakref/owner_ref
	var/datum/weakref/spell_ref
	var/owner_name = "unknown"
	var/owner_ckey = "unknown"
	var/checks_antimagic = TRUE

/obj/structure/rune_ward/Crossed(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		var/mob/owner = owner_ref?.resolve()
		if(M == owner)
			return
		if(checks_antimagic && M.can_block_magic())
			trigger_visual()
			qdel(src)
			return
		if(AM.throwing)
			return
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.movement_type & (FLYING|FLOATING))
				return
			if(L.pulledby)
				return
			if(L.mob_timers[RUNE_WARD_IMMUNITY_KEY] && world.time < L.mob_timers[RUNE_WARD_IMMUNITY_KEY])
				return
	else
		return
	var/mob/living/L = AM
	if(!isliving(L))
		return
	L.mob_timers[RUNE_WARD_IMMUNITY_KEY] = world.time + RUNE_WARD_IMMUNITY_DURATION
	log_combat(AM, src, "triggered [name] placed by [owner_name] ([owner_ckey]) at [AREACOORD(src)]")
	rune_effect(L)
	trigger_visual()
	qdel(src)

/obj/structure/rune_ward/proc/trigger_visual()
	alpha = 255
	flick(icon_state, src)

/obj/structure/rune_ward/proc/rune_effect(mob/living/L)
	return

/obj/structure/rune_ward/Destroy()
	owner_ref = null
	spell_ref = null
	return ..()

/obj/structure/rune_ward/examine(mob/user)
	. = ..()
	if(max_integrity <= 50)
		. += span_info("This rune looks very fragile - a few solid hits would destroy it.")
	else
		. += span_info("A skilled mage can scrub this effortlessly. Otherwise, it must be destroyed by force.")
	. += span_info("Flying, jumping, or being thrown over the rune will not trigger it.")

/obj/structure/rune_ward/stun
	name = "shock rune"
	icon_state = "rune_stun"

/obj/structure/rune_ward/stun/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune erupts with arcyne lightning!</B>"))
	playsound(src, 'sound/magic/lightning.ogg', 80, TRUE)
	L.lightning_shock(src)

/obj/structure/rune_ward/fire
	name = "flame rune"
	icon_state = "rune_fire"

/obj/structure/rune_ward/fire/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune erupts in flames!</B>"))
	playsound(src, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 80, TRUE)
	new /obj/effect/hotspot(get_turf(src))
	L.Slowdown(4)
	L.adjust_fire_stacks(6)

/obj/structure/rune_ward/chill
	name = "frost rune"
	icon_state = "rune_chill"

/obj/structure/rune_ward/chill/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>Frost erupts from the rune and seizes your limbs!</B>"))
	playsound(src, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	new /obj/effect/temp_visual/trapice(get_turf(src))
	L.Slowdown(4)
	L.adjustFireLoss(10)
	apply_frost_stack(L, 4)

/obj/structure/rune_ward/damage
	name = "force rune"
	icon_state = "rune_damage"
	var/rune_damage = 80

/obj/structure/rune_ward/damage/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>Arcyne blades erupt from the rune!</B>"))
	playsound(src, 'sound/magic/blade_burst.ogg', 80, TRUE)
	playsound(src, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 80, TRUE)
	new /obj/effect/temp_visual/blade_burst(get_turf(src))
	L.Slowdown(4)
	var/mob/living/carbon/human/owner = owner_ref?.resolve()
	if(ishuman(owner) && ishuman(L))
		arcyne_strike(owner, L, null, rune_damage, BODY_ZONE_CHEST, \
			BCLASS_STAB, armor_penetration = 25, spell_name = "Force Rune", \
			damage_type = BRUTE, skip_animation = TRUE)
	else
		L.adjustBruteLoss(rune_damage)

/obj/structure/rune_ward/alarm
	name = "alarm rune"
	icon_state = "rune_alarm"
	alpha = 40

/obj/structure/rune_ward/alarm/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune chimes loudly!</B>"))
	playsound(src, 'sound/magic/charging.ogg', 80, TRUE)
	var/mob/owner = owner_ref?.resolve()
	if(owner)
		var/area/A = get_area(src)
		var/area_name = A ? A.name : "an unknown location"
		to_chat(owner, span_warning("One of my alarm runes has been triggered at [area_name]!"))
		if(owner.client)
			SEND_SOUND(owner, sound('sound/magic/charging.ogg', volume = 40))

#undef RUNE_WARD_IMMUNITY_DURATION
#undef RUNE_WARD_IMMUNITY_KEY

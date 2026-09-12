/datum/action/cooldown/spell/projectile/blade_storm
	name = "Blade Storm"
	desc = "Hurls forth a shadow of yourself. On impact, teleport onto the target \
		and unleash a storm of slashes on them and around yourself.\
		Requires 7 Momentum: 3 strikes at 30 damage each. \
		Overcharged at 10 Momentum: 5 strikes at 30 damage each. \
		If reflected onto yourself, the arcyne energy tears into your own chest. \
		The blade has no eyes - it does not distinguish friend from foe. Let not your foe deflect it into your ally."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "blade_storm"
	sound = 'sound/magic/blink.ogg'

	projectile_type = /obj/projectile/magic/blade_storm
	cast_range = 7

	required_form = FORM_AIR
	required_technique = TECHNIQUE_IMBUE
	spell_cost = 90

	invocation = "Procella Gladiorum!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/aoe_damage = 30
	var/aoe_base_cuts = 3
	var/aoe_bonus_cuts = 2
	var/personal_damage = 30
	var/personal_base_cuts = 3
	var/personal_bonus_cuts = 2
	var/min_momentum = 7
	var/empowered_momentum = 10
	var/cut_delay = 2
	var/telegraph_delay = 8
	var/storm_deflected = FALSE

	var/cached_aoe_cuts = 3
	var/cached_p_cuts = 3
	var/cached_locked_zone = BODY_ZONE_CHEST

/datum/action/cooldown/spell/projectile/blade_storm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/projectile/blade_storm/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = H.arcyne_get_weapon()
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		return FALSE

	var/stacks = M.stacks
	cached_aoe_cuts = aoe_base_cuts
	cached_p_cuts = personal_base_cuts
	if(stacks >= empowered_momentum)
		cached_aoe_cuts += aoe_bonus_cuts
		cached_p_cuts += personal_bonus_cuts
	M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released into shadow!"))

	cached_locked_zone = H.zone_selected || BODY_ZONE_CHEST

	H.visible_message(span_boldwarning("[H] hurls a shadow of [H.p_them()]self forward!"))
	log_combat(H, cast_on, "used Blade Storm on")

	. = ..()

/datum/action/cooldown/spell/projectile/blade_storm/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	..()
	var/obj/projectile/magic/blade_storm/P = to_fire
	if(istype(P))
		P.aoe_cuts = cached_aoe_cuts
		P.aoe_dmg = aoe_damage
		P.p_cuts = cached_p_cuts
		P.p_dmg = personal_damage
		P.def_zone = cached_locked_zone
		P.parent_spell = src

/datum/action/cooldown/spell/projectile/blade_storm/proc/execute_storm(mob/living/carbon/human/user, mob/living/victim, aoe_cuts, aoe_dmg, p_cuts, p_dmg, def_zone)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/obj/item/held_weapon = user.arcyne_get_weapon()
	if(!held_weapon)
		return

	var/turf/landing = get_turf(victim)

	// Afterimage at departure
	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)
	do_teleport(user, landing, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(landing, 'sound/magic/blink.ogg', 40, TRUE)

	user.visible_message(
		span_warning("[user] materializes from the shadow onto [victim]!"),
		span_notice("I emerge from the shadow!"))

	var/turf/center = get_turf(victim)
	var/list/ring_turfs = get_hollow_ring(center)

	for(var/turf/T in ring_turfs)
		new /obj/effect/temp_visual/blade_storm_telegraph(T)
	playsound(center, 'sound/magic/blade_burst.ogg', 80, TRUE)

	user.visible_message(span_warning("[user] raises [held_weapon.name] - arcyne energy surges toward the [span_warning(parse_zone(def_zone))]!"))

	storm_deflected = FALSE
	for(var/cut_num in 1 to aoe_cuts)
		var/delay = telegraph_delay + (cut_num - 1) * cut_delay
		addtimer(CALLBACK(src, PROC_REF(do_storm_cut), user, held_weapon, center, ring_turfs, cut_num, def_zone, aoe_dmg), delay)

	for(var/strike_num in 1 to p_cuts)
		var/delay = telegraph_delay + (strike_num - 1) * cut_delay
		addtimer(CALLBACK(src, PROC_REF(do_personal_strike), user, held_weapon, victim, strike_num, def_zone, p_dmg), delay)

/datum/action/cooldown/spell/projectile/blade_storm/proc/do_storm_cut(mob/living/carbon/human/user, obj/item/weapon, turf/center, list/ring_turfs, cut_num, def_zone, aoe_dmg)
	if(QDELETED(user) || user.stat == DEAD)
		return

	for(var/swing_dir in list(NORTH, SOUTH, EAST, WEST))
		var/obj/effect/melee_swing/S = new(center)
		S.dir = swing_dir
		flick(pick("left_swing", "right_swing"), S)
		QDEL_IN(S, 1 SECONDS)

	playsound(center, pick("genslash"), 80, TRUE)

	for(var/turf/T in ring_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim.stat == DEAD)
				continue
			arcyne_strike(user, victim, weapon, aoe_dmg, def_zone, BCLASS_CUT, spell_name = "Blade Storm (Cut [cut_num])", skip_animation = TRUE, skip_message = TRUE)

/datum/action/cooldown/spell/projectile/blade_storm/proc/do_personal_strike(mob/living/carbon/human/user, obj/item/weapon, mob/living/victim, strike_num, def_zone, p_dmg)
	if(QDELETED(user) || user.stat == DEAD || QDELETED(victim) || victim.stat == DEAD)
		return

	arcyne_strike(user, victim, weapon, p_dmg, def_zone, spell_name = "Blade Storm (Strike [strike_num])", skip_animation = TRUE)

	var/turf/victim_turf = get_turf(victim)
	if(victim_turf)
		var/obj/effect/temp_visual/blade_cut/V = new(victim_turf)
		V.dir = get_dir(user, victim)

/datum/action/cooldown/spell/projectile/blade_storm/proc/get_hollow_ring(turf/center)
	var/list/ring = list()
	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			var/turf/T = locate(center.x + dx, center.y + dy, center.z)
			if(T)
				ring += T
	return ring

/datum/action/cooldown/spell/projectile/blade_storm/proc/handle_self_hit(mob/living/carbon/human/caster, p_cuts, p_dmg)
	to_chat(caster, span_userdanger("My own shadow crashes back into me!"))
	caster.visible_message(span_warning("[caster]'s shadow rebounds violently!"))
	var/backlash = p_dmg * p_cuts * 0.5
	caster.apply_damage(backlash, BRUTE, BODY_ZONE_CHEST)
	playsound(get_turf(caster), 'sound/combat/hits/bladed/genstab (1).ogg', 80, TRUE)

/obj/projectile/magic/blade_storm
	name = "shadow afterimage"
	icon_state = "cursehand0"
	damage = 0
	nodamage = TRUE
	speed = 1.5
	hitsound = 'sound/magic/blink.ogg'
	var/aoe_cuts = 3
	var/aoe_dmg = 30
	var/p_cuts = 3
	var/p_dmg = 30
	var/datum/action/cooldown/spell/projectile/blade_storm/parent_spell

/obj/projectile/magic/blade_storm/on_hit(atom/target)
	if(!isliving(target) || !firer || !ishuman(firer))
		return ..()
	var/mob/living/victim = target
	var/mob/living/carbon/human/caster = firer

	if(!parent_spell && caster.mind)
		parent_spell = locate(/datum/action/cooldown/spell/projectile/blade_storm) in caster.actions
	if(!parent_spell)
		return ..()

	if(victim == caster)
		parent_spell.handle_self_hit(caster, p_cuts, p_dmg)
		return BULLET_ACT_BLOCK

	if(victim.can_block_magic())
		visible_message(span_warning("[victim] shatters the shadow!"))
		playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	if(out_of_effective_range())
		return

	INVOKE_ASYNC(parent_spell, TYPE_PROC_REF(/datum/action/cooldown/spell/projectile/blade_storm, execute_storm), caster, victim, aoe_cuts, aoe_dmg, p_cuts, p_dmg, def_zone)
	return BULLET_ACT_BLOCK

/obj/effect/temp_visual/blade_storm_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 1
	duration = 8

/obj/effect/melee_swing
	name = "arcyne slash"
	icon = 'icons/effects/effects.dmi'
	icon_state = "strike"
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

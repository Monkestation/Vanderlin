#define BOULDER_MODE_HEAVE "heave"
#define BOULDER_MODE_DROP "drop"

/obj/effect/temp_visual/falling_boulder
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "rock"
	name = "falling boulder"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 9
	pixel_z = 270
	var/datum/callback/on_impact

/obj/effect/temp_visual/falling_boulder/Initialize(mapload, datum/callback/impact_cb)
	. = ..()
	on_impact = impact_cb
	animate(src, pixel_z = 0, time = duration)
	addtimer(CALLBACK(src, PROC_REF(do_impact)), duration)

/obj/effect/temp_visual/falling_boulder/proc/do_impact()
	on_impact?.Invoke()

/obj/effect/temp_visual/trap/meteor
	color = "#8B4513"
	light_color = "#8B4513"
	duration = 3 SECONDS

/datum/action/cooldown/spell/menhir
	button_icon = 'icons/mob/actions/spells/mage_geomancy.dmi'
	name = "Menhir"
	desc = "Hurl a massive boulder that shatters into stone fragments.\n\
	HEAVE flings it in a flat line at a target - immediate, but stopped by walls and cover.\n\
	DROP calls it down from directly above you.\n\
	A piece of boulder will remain where it lands - you can roll through it with Ramstam to burst it.\n\
	Use Shift-G to switch."
	button_icon_state = "boulder_strike"
	sound = 'sound/combat/hits/onstone/stonedeath.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_PROJECTILE

	required_form = FORM_EARTH
	required_technique = TECHNIQUE_DESTRUCTION

	spell_cost = 40

	invocation = "Saxum Ruinae!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 15 SECONDS

	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/boulder_mode = BOULDER_MODE_HEAVE
	var/heave_damage = 90
	var/drop_damage = 90
	var/drop_splash = 35
	var/drop_telegraph_time = 3
	var/frag_count = 8
	var/frag_damage = 15
	var/pillar_lifetime = 15 SECONDS
	var/static/list/mode_labels = list(BOULDER_MODE_HEAVE = "HEAVE", BOULDER_MODE_DROP = "DROP")

/datum/action/cooldown/spell/menhir/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/menhir/toggle_alt_mode(mob/user)
	boulder_mode = (boulder_mode == BOULDER_MODE_HEAVE) ? BOULDER_MODE_DROP : BOULDER_MODE_HEAVE
	to_chat(user, span_notice("Menhir set to: [mode_labels[boulder_mode]]."))
	update_mode_maptext()
	return TRUE

/datum/action/cooldown/spell/menhir/proc/update_mode_maptext()
	var/label = mode_labels[boulder_mode]
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
		holder.color = GLOB.form_colors[FORM_EARTH]

/datum/action/cooldown/spell/menhir/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(boulder_mode == BOULDER_MODE_DROP)
		var/turf/target = get_turf(cast_on)
		if(!target)
			return FALSE
		do_drop(H, target)
	else
		do_heave(H, cast_on)
	return TRUE

/datum/action/cooldown/spell/menhir/proc/do_heave(mob/living/carbon/human/H, atom/aim)
	var/turf/origin = get_turf(H)
	if(!origin || !aim)
		return
	playsound(origin, 'sound/combat/hits/onstone/stonedeath.ogg', 80, TRUE)
	var/obj/projectile/magic/boulder/B = new(origin)
	B.damage = heave_damage
	B.frag_count = frag_count
	B.frag_damage = frag_damage
	B.pillar_lifetime = pillar_lifetime
	B.firer = H
	B.preparePixelProjectile(aim, H)
	B.fire()

/datum/action/cooldown/spell/menhir/proc/do_drop(mob/living/carbon/human/H, turf/target)
	new /obj/effect/temp_visual/trap/geomancy(target)
	target.visible_message(span_boldwarning("A shadow spreads over [target] - a boulder plummets from the sky!"))
	playsound(target, 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 60, TRUE)
	addtimer(CALLBACK(src, PROC_REF(drop_fall), target, H), drop_telegraph_time)

/datum/action/cooldown/spell/menhir/proc/drop_fall(turf/target, mob/living/carbon/human/H)
	if(QDELETED(target))
		return
	new /obj/effect/temp_visual/falling_boulder(target, CALLBACK(src, PROC_REF(do_drop_hit), target, H))

/datum/action/cooldown/spell/menhir/proc/do_drop_hit(turf/target, mob/living/carbon/human/H)
	if(QDELETED(target))
		return
	playsound(target, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 5)
	new /obj/effect/temp_visual/spell_impact(target, spell_color, SPELL_IMPACT_HIGH)
	for(var/obj/structure/S in target)
		S.take_damage(drop_damage, BRUTE, "blunt")
	for(var/mob/living/L in target)
		strike_mob(H, L, drop_damage)
	for(var/turf/T in range(1, target))
		if(T == target)
			continue
		for(var/mob/living/L in T)
			strike_mob(H, L, drop_splash)
	fragment_burst(target, H)
	leave_pillar(target, H)

/datum/action/cooldown/spell/menhir/proc/leave_pillar(turf/T, mob/living/carbon/human/H)
	if(!T || T.density)
		return
	if(locate(/obj/structure/earthen_pillar) in T)
		return
	for(var/obj/structure/S in T)
		if(S.density)
			return
	var/obj/structure/earthen_pillar/pillar = new(T)
	pillar.caster_ref = WEAKREF(H)
	QDEL_IN(pillar, pillar_lifetime)

/datum/action/cooldown/spell/menhir/proc/strike_mob(mob/living/carbon/human/H, mob/living/L, dmg)
	if(L == H || QDELETED(L))
		return
	if(L.can_block_magic())
		return
	if(ishuman(L))
		arcyne_strike(H, L, null, dmg, H.zone_selected || BODY_ZONE_CHEST, BCLASS_BLUNT, \
			spell_name = name, damage_type = BRUTE, npc_simple_damage_mult = 2, skip_animation = TRUE)
	else
		L.adjustBruteLoss(dmg * (L.mind ? 1 : 2))
	new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

/datum/action/cooldown/spell/menhir/proc/fragment_burst(turf/T, mob/living/carbon/human/H)
	if(!T)
		return
	var/static/list/burst_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to frag_count)
		var/fdir = pick(burst_dirs)
		var/turf/ftarget = get_ranged_target_turf(T, fdir, 3)
		var/obj/projectile/magic/gravel_blast/frag = new(T)
		frag.damage = frag_damage
		frag.range = 3
		frag.ricochets_max = 0
		frag.firer = H
		frag.preparePixelProjectile(ftarget, T)
		frag.fire()

/obj/projectile/magic/boulder
	name = "boulder"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "boulder"
	damage = 100
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = 3.5
	accuracy = 30
	hitsound = 'sound/combat/hits/onstone/stonedeath.ogg'
	var/frag_count = 8
	var/frag_damage = 15
	var/pillar_lifetime = 0

/obj/projectile/magic/boulder/on_hit(target)
	. = ..()
	if(out_of_effective_range())
		return
	var/turf/impact = get_turf(src)
	if(!impact)
		return
	for(var/i in 1 to frag_count)
		var/obj/projectile/magic/gravel_blast/frag = new(impact)
		frag.damage = frag_damage
		frag.range = 3
		frag.ricochets_max = 0
		frag.ricochet_chance = 0
		frag.firer = firer
		frag.name = "gravel fragment"
		var/angle = rand(0, 359)
		frag.fire(angle)
	playsound(impact, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 5)
	if(pillar_lifetime > 0 && !impact.density && !(locate(/obj/structure/earthen_pillar) in impact))
		var/blocked = FALSE
		for(var/obj/structure/S in impact)
			if(S.density)
				blocked = TRUE
				break
		if(!blocked)
			var/obj/structure/earthen_pillar/pillar = new(impact)
			pillar.caster_ref = WEAKREF(firer)
			QDEL_IN(pillar, pillar_lifetime)

/obj/projectile/magic/boulder/Bump(atom/A)
	if(ismob(A))
		var/mob/living/M = A
		if(M.can_block_magic())
			visible_message(span_warning("[src] shatters harmlessly against [M]!"))
			playsound(get_turf(M), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return
		if(M == firer)
			damage = round(damage / 2)
	return ..()

#undef BOULDER_MODE_HEAVE
#undef BOULDER_MODE_DROP

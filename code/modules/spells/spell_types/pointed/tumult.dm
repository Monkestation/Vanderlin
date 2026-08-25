#define TUMULT_MODE_ERUPT "erupt"
#define TUMULT_MODE_CHARGE "charge"

#define MT_ROCKSHOT "rockshot"
#define ROCKSHOT_DR_DURATION 1 SECONDS

/obj/projectile/magic/gravel_blast
	name = "gravel shot"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "stone"
	damage = 26
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = 4
	accuracy = 50
	hitsound = 'sound/combat/hits/onstone/wallhit.ogg'
	ricochets_max = 2
	ricochet_chance = 80
	var/reduced_damage = 11

/obj/projectile/magic/gravel_blast/arc
	name = "arced gravel shot"
	damage = 20
	arcshot = TRUE

/obj/projectile/magic/gravel_blast/process_hit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M == firer)
			damage = round(damage / 2)
		else if(M.mob_timers[MT_ROCKSHOT] && world.time < M.mob_timers[MT_ROCKSHOT] + ROCKSHOT_DR_DURATION)
			damage = reduced_damage
		else
			M.mob_timers[MT_ROCKSHOT] = world.time
	return ..()

/obj/projectile/magic/gravel_blast/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.can_block_magic())
			visible_message(span_warning("[src] shatters harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

/obj/structure/earthen_wall
	name = "earthen wall"
	desc = "A wall of conjured stone. It will crumble in time."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 300
	var/timeleft = 10 SECONDS

/obj/structure/earthen_wall/Initialize()
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/structure/earthen_pillar
	name = "stone pillar"
	desc = "A pillar of conjured stone. Sturdy, but not indestructible. Shatters into gravel when destroyed."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 150
	anchored = TRUE
	var/datum/weakref/caster_ref
	var/fragment_count = 3
	var/fragment_damage = 15

/obj/structure/earthen_pillar/Destroy()
	caster_ref = null
	return ..()

/obj/structure/earthen_pillar/atom_break(damage_flag, silent)
	shatter_fragments()
	return ..()

/obj/structure/earthen_pillar/proc/shatter_fragments()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/mob/caster = caster_ref?.resolve()
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to fragment_count)
		var/dir = pick_n_take(dirs)
		var/turf/target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gravel_blast/frag = new(T)
		frag.damage = fragment_damage
		frag.ricochets_max = 0
		if(caster)
			frag.firer = caster
		frag.preparePixelProjectile(target, T)
		frag.fire()

/datum/action/cooldown/spell/tumult
	button_icon = 'icons/mob/actions/spells/mage_geomancy.dmi'
	name = "Tumult"
	desc = "Erupts stone from the ground, or become one yourself and bowls through your foes! switch mode with Shift-G.\n\
	CAIRN erupts a cairn from a spot you choose, hitting those caught and leaving them Vulnerable, with more damage in the center. You are unharmed by the spell.\n\
	RAMSTAM turns you into a rolling boulders that hurtle to a marked destination, restricted to the cardinal and diagonal direction. You batter asides anyone in the way for a small amount of damage. If you hit a wall, you will burst out gravel around you, deals damage to it, and ricochet to the spot you came from. If you are riposted, it will halt and exposes you. If you rolls through a stone pillar, you will shatter it for gravel bursts that you are immune to. You cannot steer once begun."
	button_icon_state = "cairn"
	sound = 'sound/combat/hits/onstone/stonedeath.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	spell_cost = 40

	required_form = FORM_EARTH
	required_technique = TECHNIQUE_CREATION

	invocation = "Surge, Terra!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 10 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/geo_mode = TUMULT_MODE_ERUPT
	var/static/list/mode_labels = list(TUMULT_MODE_ERUPT = "CAIRN", TUMULT_MODE_CHARGE = "RAMSTAM")
	var/erupt_cooldown = 10 SECONDS
	var/charge_cooldown = 12 SECONDS

	var/telegraph_delay = 4
	var/erupt_direct = 40
	var/erupt_aoe = 20
	var/erupt_npc_mult = 2
	var/erupt_push = 1
	var/pillar_integrity = 150
	var/vuln_duration = 5 SECONDS

	var/max_tiles = 7
	var/telegraph_time = 3
	var/roll_speed = 1
	var/barrel_damage = 15
	var/knock_dist = 1
	var/charge_frag_count = 8
	var/charge_frag_damage = 12
	var/crash_structure_damage = 100
	var/rolling = FALSE

/datum/action/cooldown/spell/tumult/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/tumult/toggle_alt_mode(mob/user)
	if(rolling)
		return FALSE
	geo_mode = (geo_mode == TUMULT_MODE_ERUPT) ? TUMULT_MODE_CHARGE : TUMULT_MODE_ERUPT
	cooldown_time = (geo_mode == TUMULT_MODE_CHARGE) ? charge_cooldown : erupt_cooldown
	invocation = geo_mode == TUMULT_MODE_ERUPT ? "Surge, Terra!" : "Volve!"
	to_chat(user, span_notice("Tumult set to: [mode_labels[geo_mode]]."))
	update_mode_maptext()
	build_all_button_icons()
	return TRUE

/datum/action/cooldown/spell/tumult/proc/update_mode_maptext()
	var/label = mode_labels[geo_mode]
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

/datum/action/cooldown/spell/tumult/cast(atom/cast_on)
	cooldown_time = (geo_mode == TUMULT_MODE_CHARGE) ? charge_cooldown : erupt_cooldown
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(geo_mode == TUMULT_MODE_CHARGE)
		return cast_charge(H, cast_on)
	return cast_erupt(H, cast_on)

/datum/action/cooldown/spell/tumult/proc/cast_erupt(mob/living/carbon/human/H, atom/cast_on)
	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE
	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE
	if(T.density)
		to_chat(H, span_warning("There's no room to raise stone there!"))
		return FALSE
	for(var/obj/structure/S in T.contents)
		if(S.density)
			to_chat(H, span_warning("Something is already there!"))
			return FALSE
	new /obj/effect/temp_visual/trap/geomancy(T)
	playsound(T, 'sound/combat/hits/onstone/wallhit.ogg', 60, TRUE)
	addtimer(CALLBACK(src, PROC_REF(erupt_strike), T, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/tumult/proc/erupt_strike(turf/T, mob/living/carbon/human/caster)
	if(QDELETED(caster) || caster.stat == DEAD)
		return
	playsound(T, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 4)
	var/target_zone = caster.zone_selected || BODY_ZONE_CHEST

	for(var/mob/living/victim in T.contents)
		if(victim == caster || victim.stat == DEAD)
			continue
		if(victim.can_block_magic())
			victim.visible_message(span_warning("The erupting stone crumbles around [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		arcyne_strike(caster, victim, null, erupt_direct, target_zone, BCLASS_BLUNT, \
			spell_name = "Cairn", damage_type = BRUTE, npc_simple_damage_mult = erupt_npc_mult, skip_animation = TRUE)
		victim.apply_status_effect(/datum/status_effect/debuff/vulnerable, vuln_duration)
		to_chat(victim, span_userdanger("Stone erupts beneath me!"))
		new /obj/effect/temp_visual/spell_impact(get_turf(victim), spell_color, spell_impact_intensity)
		var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, erupt_push), erupt_push, 1, caster, force = MOVE_FORCE_STRONG)

	for(var/turf/affected in get_hear(1, T))
		if(affected == T)
			continue
		new /obj/effect/temp_visual/kinetic_blast(affected)
		for(var/mob/living/victim in affected)
			if(victim == caster || victim.stat == DEAD)
				continue
			if(victim.can_block_magic())
				continue
			arcyne_strike(caster, victim, null, erupt_aoe, target_zone, BCLASS_BLUNT, \
				spell_name = "Cairn", damage_type = BRUTE, npc_simple_damage_mult = erupt_npc_mult, skip_animation = TRUE)
			victim.apply_status_effect(/datum/status_effect/debuff/vulnerable, vuln_duration)
			var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, erupt_push), erupt_push, 1, caster, force = MOVE_FORCE_STRONG)

	for(var/turf/struct_turf in get_hear(1, T))
		for(var/obj/structure/S in struct_turf)
			S.take_damage(erupt_direct, BRUTE, "blunt")

	new /obj/effect/temp_visual/kinetic_blast(T)
	var/obj/structure/earthen_pillar/pillar = new(T)
	pillar.max_integrity = pillar_integrity
	pillar.update_integrity(pillar_integrity)
	pillar.caster_ref = WEAKREF(caster)
	QDEL_IN(pillar, erupt_cooldown)

/datum/action/cooldown/spell/tumult/proc/cast_charge(mob/living/carbon/human/H, atom/cast_on)
	if(rolling)
		return FALSE
	var/turf/target = get_turf(cast_on)
	if(!target)
		return FALSE
	var/dir = get_dir(H, target)
	if(!dir)
		return FALSE
	var/dist = min(get_dist(get_turf(H), target), max_tiles)
	if(dist < 1)
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(do_ramstam), H, dir, dist)
	return TRUE

/datum/action/cooldown/spell/tumult/proc/do_ramstam(mob/living/carbon/human/H, dir, dist)
	rolling = TRUE
	H.setDir(dir)
	var/commit_time = telegraph_time + dist * roll_speed * 2 + 4
	H.changeNext_move(commit_time)
	H.apply_status_effect(/datum/status_effect/swingdelay/penalty/committed, commit_time, TRUE)
	H.tempfixeye = TRUE

	var/list/indicators = list()
	var/turf/cur = get_turf(H)
	for(var/i in 1 to dist)
		cur = get_step(cur, dir)
		if(!cur || cur.density)
			break
		indicators += new /obj/effect/temp_visual/trap/geomancy(cur)
	playsound(H, 'sound/foley/stone_scrape.ogg', 60, TRUE)
	sleep(telegraph_time)
	for(var/obj/effect/E in indicators)
		qdel(E)

	if(QDELETED(H) || H.stat != CONSCIOUS)
		end_ramstam(H, null, initial(H.alpha))
		return

	var/saved_alpha = H.alpha
	H.alpha = 0
	var/obj/effect/ramstam_boulder/B = new(get_turf(H))
	B.setDir(dir)

	var/list/struck = list()
	var/tiles_rolled = 0
	var/hit_wall = FALSE
	var/stopped = FALSE
	for(var/i in 1 to dist)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			break
		var/turf/next = get_step(H, dir)
		if(!next || next.density)
			roll_crash(H, next)
			hit_wall = TRUE
			break
		var/obj/structure/earthen_pillar/pillar = (locate(/obj/structure/earthen_pillar) in next)
		if(pillar)
			pillar.caster_ref = WEAKREF(H)
			pillar.shatter_fragments()
			qdel(pillar)
		else
			var/blocked = FALSE
			for(var/obj/structure/S in next)
				if(S.density && !S.climbable)
					blocked = TRUE
					break
			if(blocked)
				roll_crash(H, next)
				hit_wall = TRUE
				break
		var/countered = FALSE
		for(var/mob/living/L in next)
			if(L == H)
				continue
		if(countered)
			stopped = TRUE
			break
		H.forceMove(next)
		H.setDir(dir)
		B.forceMove(next)
		tiles_rolled++
		playsound(next, 'sound/foley/stone_scrape.ogg', 45, TRUE)
		new /obj/effect/temp_visual/kinetic_blast(next)
		for(var/mob/living/L in next)
			if(L == H || (L in struck))
				continue
			struck += L
			roll_hit(H, L, dir)
		sleep(roll_speed)

	if(hit_wall && !stopped)
		roll_return(H, B, turn(dir, 180), tiles_rolled)

	end_ramstam(H, B, saved_alpha)

/datum/action/cooldown/spell/tumult/proc/roll_return(mob/living/carbon/human/H, obj/effect/ramstam_boulder/B, return_dir, tiles)
	for(var/i in 1 to tiles)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			return
		var/turf/next = get_step(H, return_dir)
		if(!next || next.density)
			return
		var/blocked = FALSE
		for(var/obj/structure/S in next)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			return
		H.forceMove(next)
		H.setDir(return_dir)
		if(!QDELETED(B))
			B.setDir(return_dir)
			B.forceMove(next)
		playsound(next, 'sound/foley/stone_scrape.ogg', 40, TRUE)
		sleep(roll_speed)

/datum/action/cooldown/spell/tumult/proc/end_ramstam(mob/living/carbon/human/H, obj/effect/ramstam_boulder/B, restore_alpha)
	if(!QDELETED(B))
		qdel(B)
	if(!QDELETED(H))
		H.alpha = restore_alpha
		H.tempfixeye = FALSE
	rolling = FALSE

/datum/action/cooldown/spell/tumult/proc/roll_hit(mob/living/carbon/human/H, mob/living/L, dir)
	if(L.can_block_magic())
		return
	if(ishuman(L))
		arcyne_strike(H, L, null, barrel_damage, H.zone_selected || BODY_ZONE_CHEST, BCLASS_BLUNT, \
			spell_name = "Ramstam", damage_type = BRUTE, npc_simple_damage_mult = 1.5, skip_animation = TRUE)
	else
		L.adjustBruteLoss(barrel_damage * (L.mind ? 1 : 1.5))
	new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
	var/knockdir = pick(turn(dir, 90), turn(dir, -90))
	L.safe_throw_at(get_ranged_target_turf(L, knockdir, knock_dist), knock_dist, 1, H, force = MOVE_FORCE_STRONG)

/datum/action/cooldown/spell/tumult/proc/roll_crash(mob/living/carbon/human/H, turf/obstacle)
	var/turf/from = get_turf(H)
	playsound(from, 'sound/combat/hits/onstone/stonedeath.ogg', 80, TRUE)
	if(obstacle)
		new /obj/effect/temp_visual/kinetic_blast(obstacle)
		if(obstacle.density)
			obstacle.take_damage(crash_structure_damage, BRUTE, "blunt")
		for(var/obj/structure/S in obstacle)
			if(S.density)
				S.take_damage(crash_structure_damage, BRUTE, "blunt")
	if(!from)
		return
	new /obj/effect/temp_visual/spell_impact(from, spell_color, SPELL_IMPACT_MEDIUM)
	var/static/list/burst_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to charge_frag_count)
		var/fdir = pick(burst_dirs)
		var/turf/ftarget = get_ranged_target_turf(from, fdir, 4)
		var/obj/projectile/magic/gravel_blast/frag = new(from)
		frag.damage = charge_frag_damage
		frag.range = 4
		frag.ricochets_max = 0
		frag.firer = H
		frag.preparePixelProjectile(ftarget, from)
		frag.fire()

/datum/action/cooldown/spell/tumult/proc/riposte_counter(mob/living/carbon/human/H, mob/living/L)
	H.visible_message(span_warning("[L] braces and turns [H]'s charge aside - [H] sprawls, exposed!"), span_userdanger("[L] catches my charge - I am thrown off and left exposed!"))

/obj/effect/ramstam_boulder
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "boulder"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = MOB_LAYER

/obj/effect/ramstam_boulder/Initialize(mapload)
	. = ..()
	SpinAnimation(15, -1)

#undef TUMULT_MODE_ERUPT
#undef TUMULT_MODE_CHARGE

#undef MT_ROCKSHOT
#undef ROCKSHOT_DR_DURATION

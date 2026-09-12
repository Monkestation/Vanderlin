/datum/action/cooldown/spell/forcewall
	name = "Forcewall"
	desc = "Conjure a wall of arcyne force, preventing anyone and anything other than you from moving through it."
	button_icon_state = "forcewall"

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_ILLUSION

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 35 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	var/telegraph_type = /obj/effect/temp_visual/trap_wall

/datum/action/cooldown/spell/forcewall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/front = get_turf(cast_on)
	if(!front)
		return FALSE

	var/list/affected_turfs = list()
	affected_turfs += front

	if(H.dir == SOUTH || H.dir == NORTH)
		affected_turfs += get_step(front, WEST)
		affected_turfs += get_step(get_step(front, WEST), WEST)
		affected_turfs += get_step(front, EAST)
		affected_turfs += get_step(get_step(front, EAST), EAST)
	else
		affected_turfs += get_step(front, NORTH)
		affected_turfs += get_step(get_step(front, NORTH), NORTH)
		affected_turfs += get_step(front, SOUTH)
		affected_turfs += get_step(get_step(front, SOUTH), SOUTH)

	for(var/turf/affected_turf in affected_turfs)
		new telegraph_type(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_wall), affected_turf, H), 1 SECONDS)

	H.visible_message("[H] mutters an incantation and a wall of arcyne force manifests out of thin air!")
	return TRUE

/datum/action/cooldown/spell/forcewall/proc/spawn_wall(turf/target, mob/caster)
	new /obj/structure/forcefield_weak(target, caster)


/obj/structure/forcefield_weak
	desc = "A wall of pure arcyne force."
	name = "Arcyne Wall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "arcynewall"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	opacity = 0
	density = TRUE
	max_integrity = 150
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = 20 SECONDS
	var/mob/caster

/obj/structure/forcefield_weak/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/structure/forcefield_weak/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(ismob(mover))
		var/mob/M = mover
		if(M.can_block_magic(charge_cost = 0))
			return TRUE
	return FALSE

/obj/effect/temp_visual/trap_wall
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 1 SECONDS

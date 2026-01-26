// These do not all confirm to spell standards but if someone wants to go through all 60 odd of these and add proper
// Valid target / Can cast then be my guest
/datum/action/cooldown/spell/essence
	name = "Utility Spell"
	desc = "A minor utility spell."
	school = "utility"
	spell_cost = 5
	charge_drain = 0
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	point_cost = 2
	spell_type = SPELL_ESSENCE
	experience_modifier = 0
	associated_skill = /datum/skill/craft/alchemy

/datum/action/cooldown/spell/essence/get_adjusted_charge_time()
	return charge_time

/datum/action/cooldown/spell/essence/get_adjusted_cost(cost_override)
	if(cost_override)
		return cost_override
	return spell_cost

/obj/effect/temp_visual/snake
	icon = 'icons/effects/effects.dmi'
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 1.5 SECONDS
	var/datum/weakref/mob

/obj/effect/temp_visual/snake/Initialize(mapload, mob/living/target_mob)
	. = ..()
	if(!target_mob || !istype(target_mob))
		return INITIALIZE_HINT_QDEL
	mob = WEAKREF(target_mob)
	overlays += emissive_appearance(icon, icon_state, alpha = src.alpha)
	if(target_mob)
		target_mob.vis_contents += src

/obj/effect/temp_visual/snake/twin_up
	icon_state = "twinsnake"

/obj/effect/temp_visual/snake/swarm
	icon_state = "snakeswarm"

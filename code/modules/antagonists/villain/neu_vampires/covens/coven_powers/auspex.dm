/datum/coven/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/coven_power/auspex
	max_level = 2

/datum/coven_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

//HEIGHTENED SENSES
/datum/coven_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 10
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/heightened_senses/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, VAMPIRE_TRAIT)

	owner.update_sight()

/datum/coven_power/auspex/heightened_senses/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, VAMPIRE_TRAIT)

	owner.update_sight()


//PSYCHIC PROJECTION
/datum/coven_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 2
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 250

/datum/coven_power/auspex/psychic_projection/activate()
	. = ..()
	var/obj/effect/blood_rune/rune = write_full_rune(get_turf(owner), /datum/rune_spell/astraljourney)
	rune.trigger(owner)

/mob
	var/obj/effect/blood_rune/ajourn

////////////////////////////////////////////////////////////////////////////////////////
GLOBAL_LIST_INIT(astral_projections, list())

/datum/action/cooldown/spell/undirected/astral_return
	name = "Re-enter Body"
	desc = "End your astral projection and re-awaken inside your body. If used while tangible you might spook on-lookers, so be mindful."
	button_icon_state = "astral_return"
	button_icon = 'icons/mob/actions/spells/vampire.dmi'
	spell_requirements = NONE
	charge_required = FALSE

/datum/action/cooldown/spell/undirected/astral_return/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return istype(owner, /mob/living/simple_animal/hostile/retaliate/astral_projection)

/datum/action/cooldown/spell/undirected/astral_return/cast(mob/living/simple_animal/hostile/retaliate/astral_projection/astral)
	. = ..()
	astral.death()//pretty straightforward isn't it?

/datum/action/cooldown/spell/undirected/astral_toggle
	name = "Toggle Tangibility"
	desc = "Turn into a visible copy of your body, able to speak and bump into doors. But note that the slightest source of damage will dispel your astral projection altogether."
	button_icon_state = "astral_toggle"
	button_icon = 'icons/mob/actions/spells/vampire.dmi'
	spell_requirements = NONE
	charge_required = FALSE

/datum/action/cooldown/spell/undirected/astral_toggle/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return istype(owner, /mob/living/simple_animal/hostile/retaliate/astral_projection)

/datum/action/cooldown/spell/undirected/astral_toggle/cast(mob/living/simple_animal/hostile/retaliate/astral_projection/astral)
	. = ..()
	astral.toggle_tangibility()
	if (astral.tangibility)
		desc = "Turn back into an invisible projection of your soul."
	else
		desc = "Turn into a visible copy of your body, able to speak and bump into doors. But note that the slightest source of damage will dispel your astral projection altogether."

/mob/living/simple_animal/hostile/retaliate/astral_projection
	name = "astral projection"
	real_name = "astral projection"
	desc = "A fragment of a cultist's soul, freed from the laws of physics."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	movement_type = FLYING
	maxHealth = 1
	health = 1
	melee_damage_lower = 0
	melee_damage_upper = 0
	move_to_delay = 3
	density = 0
	plane = GHOST_PLANE
	invisibility = INVISIBILITY_GHOST
	see_invisible = INVISIBILITY_GHOST
	incorporeal_move = INCORPOREAL_MOVE_BASIC
	alpha = 127
	now_pushing = 1 //prevents pushing atoms

	//keeps track of whether we're in "ghost" form or "slightly less ghost" form
	var/tangibility = FALSE

	//the cultist's original body
	var/mob/living/anchor

	var/image/incorporeal_appearance
	var/image/tangible_appearance

	var/time_last_speech = 0//speech bubble cooldown

	//sechud stuff
	var/cardjob = "hudunknown"

	var/projection_destroyed = FALSE
	var/direct_delete = FALSE

	var/last_devotion_gain = 0
	var/devotion_gain_delay = 60 SECONDS

	var/datum/action/cooldown/spell/undirected/astral_return/astral_return
	var/datum/action/cooldown/spell/undirected/astral_toggle/astral_toggle

/mob/living/simple_animal/hostile/retaliate/astral_projection/New()
	..()
	GLOB.astral_projections += src
	last_devotion_gain = world.time
	incorporeal_appearance = image('icons/mob/mob.dmi', "blank")
	tangible_appearance = image('icons/mob/mob.dmi', "blank")
	see_in_dark = 100

	astral_return = new
	astral_toggle = new

	astral_return.Grant(src)
	astral_toggle.Grant(src)

/mob/living/simple_animal/hostile/retaliate/astral_projection/Login()
	..()

	if (!tangibility)
		overlay_fullscreen("astralborder", /atom/movable/screen/fullscreen/astral_border)
		update_fullscreen_alpha("astralborder", 255, 5)

/mob/living/simple_animal/hostile/retaliate/astral_projection/proc/destroy_projection()
	if (projection_destroyed)
		return
	incorporeal_appearance = null
	tangible_appearance = null
	astral_return.Remove(src)
	astral_toggle.Remove(src)
	projection_destroyed = TRUE
	GLOB.astral_projections -= src
	//the projection has ended, let's return to our body
	if (anchor && client)
		if (key)
			if (tangibility)
				var/obj/effect/afterimage/A = new (loc, anchor, 10)
				A.dir = dir
				for(var/mob/M in dview(world.view, loc, INVISIBILITY_MAXIMUM))
					if (M.client)
						M.playsound_local(loc, get_sfx("disappear_sound"), 75, 0, -2)
			anchor.key = key
			to_chat(anchor, span_notice("You reconnect with your body.") )
			anchor.ajourn = null
	invisibility = 101
	density = FALSE
	sleep(20)
	anchor = null
	if (!direct_delete)
		qdel(src)

/mob/living/simple_animal/hostile/retaliate/astral_projection/Destroy()
	if (!projection_destroyed)
		incorporeal_appearance = null
		tangible_appearance = null
		astral_return.Remove(src)
		astral_toggle.Remove(src)
		projection_destroyed = TRUE
		GLOB.astral_projections -= src
		//the projection has ended, let's return to our body
		if (anchor && client)
			if (key)
				if (tangibility)
					var/obj/effect/afterimage/A = new (loc, anchor, 10)
					A.dir = dir
					for(var/mob/M in dview(world.view, loc, INVISIBILITY_MAXIMUM))
						if (M.client)
							M.playsound_local(loc, get_sfx("disappear_sound"), 75, 0, -2)
				anchor.key = key
				to_chat(anchor, span_notice("You reconnect with your body.") )
				anchor.ajourn = null
		invisibility = 101
		density = FALSE
		anchor = null
	. = ..()

/mob/living/simple_animal/hostile/retaliate/astral_projection/Life()
	. = ..()

	if (anchor)
		var/turf/T = get_turf(anchor)
		var/turf/U = get_turf(src)
		if (T.z != U.z)
			to_chat(src, span_warning("You cannot sustain the astral projection at such a distance.") )
			death()
			return
	else
		death()
		return

/mob/living/simple_animal/hostile/retaliate/astral_projection/death(gibbed = FALSE)
	INVOKE_ASYNC(src, PROC_REF(destroy_projection))

/mob/living/simple_animal/hostile/retaliate/astral_projection/examine(mob/living/user)
	. = ..()
	if(isliving(user))
		if (!tangibility)
			if ((user == src) && anchor)
				. += span_notice("You check yourself to see how others would see you were you tangible:")
				anchor.examine(user)
			else if (user?.clan)
				. += span_notice("It's an astral projection.")
			else
				. += span_cult("Wait something's not right here.")
		else if (anchor)
			. += anchor.examine(user)//examining the astral projection alone won't be enough to see through it, although the user might want to make sure they cannot be identified first.
	else
		. +=  span_cult("Wait something's not right here.")

//no pulling stuff around
/mob/living/simple_animal/hostile/retaliate/astral_projection/start_pulling(atom/movable/AM, state, force = pull_force, suppress_message = FALSE, obj/item/item_override, accurate = FALSE)
	return

//this should prevent most other edge cases
/mob/living/simple_animal/hostile/retaliate/astral_projection/incapacitated(ignore_restraints = FALSE, ignore_grab = TRUE, ignore_stasis = TRUE)
	return TRUE

//bullets instantly end us
/mob/living/simple_animal/hostile/retaliate/astral_projection/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	. = ..()
	if (tangibility)
		death()

/mob/living/simple_animal/hostile/retaliate/astral_projection/ex_act(severity)
	if(tangibility)
		death()

//called once when we are created, shapes our appearance in the image of our anchor
/mob/living/simple_animal/hostile/retaliate/astral_projection/proc/ascend(mob/living/body)
	if (!body)
		return
	anchor = body
	//memorizing our anchor's appearance so we can toggle to it
	tangible_appearance = body.appearance

	//getting our ghostly looks
	overlays.len = 0
	if (ishuman(body))
		var/mob/living/carbon/human/H = body
		//instead of just adding an overlay of the body's uniform and suit, we'll first process them a bit so the leg part is mostly erased, for a ghostly look.
		//overlays += crop_human_suit_and_uniform(body)
		overlays += H.overlays_standing[GLASSES_LAYER]
		overlays += H.overlays_standing[BELT_LAYER]
		overlays += H.overlays_standing[BACK_LAYER]
		overlays += H.overlays_standing[HEAD_LAYER]
		overlays += H.overlays_standing[HANDCUFF_LAYER]

	//giving control to the player
	key = body.key

	//name  & examine stuff
	desc = body.desc
	gender = body.gender
	if(body.mind && body.mind.name)
		name = body.mind.name
	else
		if(body.real_name)
			name = body.real_name
		else
			if(gender == MALE)
				name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
			else
				name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	real_name = name

	//memorizing our current appearance so we can toggle back to it later. Has to be done AFTER setting our new name.
	incorporeal_appearance = appearance

	//we don't transfer the mind but we keep a reference to it.
	mind = body.mind

/mob/living/simple_animal/hostile/retaliate/astral_projection/proc/toggle_tangibility()
	if (tangibility)
		density = FALSE
		appearance = incorporeal_appearance
		movement_type = FLYING
		incorporeal_move = 1
		speed = 0.5
		overlay_fullscreen("astralborder", /atom/movable/screen/fullscreen/astral_border)
		update_fullscreen_alpha("astralborder", 255, 5)
		var/obj/effect/afterimage/A = new (loc, anchor, 10)
		A.dir = dir
	else
		density = TRUE
		appearance = tangible_appearance
		incorporeal_move = 0
		movement_type = GROUND
		see_invisible = SEE_INVISIBLE_OBSERVER
		speed = 1
		clear_fullscreen("astralborder", animated = 5)
		alpha = 0
		animate(src, alpha = 255, time = 10)

	tangibility = !tangibility

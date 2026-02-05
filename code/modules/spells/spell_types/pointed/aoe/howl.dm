#define TRAIT_RECENTLY_STAGGERED "recently_staggered"

/datum/action/cooldown/spell/aoe/repulse/howl
	name = "Terrifying Howl"
	desc = "Let loose a howl of dread, repelling those nearby while immobilizing them."
	button_icon_state = "howl"

	spell_type = SPELL_RAGE
	associated_skill = null

	invocation_type = INVOCATION_NONE
	aoe_radius = 5

	has_visual_effects = FALSE
	click_to_activate = FALSE
	cooldown_time = 50 SECONDS
	spell_cost = 45
	charge_required = FALSE
	sound = 'sound/vo/mobs/wwolf/roar.ogg'
	sparkle_path = null
	var/obj/effect/abstract/particle_holder/howl_effect
	min_throw = 1
	max_throw = 1
	/// The maximum immobilize for adjacent targets, falls off based on aoe_radius
	var/maximum_immobilize = 1.5 SECONDS

/datum/action/cooldown/spell/aoe/repulse/howl/Destroy()
	if(howl_effect)
		QDEL_NULL(howl_effect)
	. = ..()

/datum/action/cooldown/spell/aoe/repulse/howl/is_valid_target(atom/cast_on)
	if(HAS_TRAIT(cast_on, TRAIT_RECENTLY_STAGGERED))
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/aoe/repulse/howl/cast(atom/cast_on)
	. = ..()
	if(ismovableatom(cast_on))
		howl_effect = new(cast_on, /particles/particle_song, PARTICLE_ATTACH_MOB, 3.5 SECONDS)

/datum/action/cooldown/spell/aoe/repulse/howl/cast_on_thing_in_aoe(atom/movable/victim, atom/caster)
	if(isliving(victim))
		var/mob/living/victim_mob = victim
		if(prob(victim_mob.get_shield_block_chance()))
			return

	var/dist_from_caster = get_dist(victim, caster)

	if(sparkle_path)
		// Created sparkles will disappear on their own
		new sparkle_path(get_turf(victim), get_dir(caster, victim))

	if(isliving(victim))
		var/mob/living/victim_living = victim
		if(dist_from_caster <= 1)
			victim_living.Immobilize(maximum_immobilize)
			victim_living.adjust_eye_blur(maximum_immobilize / 2 SECONDS)
			to_chat(victim, span_userdanger("You're disoriented by [caster]'s roar!"))
			if(dist_from_caster != 0) //we can't throw someone on the same turf as us
				throw_victim(victim, caster)
		else
			victim_living.Immobilize(clamp(maximum_immobilize - maximum_immobilize * (dist_from_caster / aoe_radius), 0.1 SECONDS, maximum_immobilize))
			to_chat(victim, span_danger("You're shaken by [caster]'s roar!"))

	ADD_TRAIT(victim, TRAIT_RECENTLY_STAGGERED, "howl")
	addtimer(TRAIT_CALLBACK_REMOVE(victim, TRAIT_RECENTLY_STAGGERED, "howl"), 60 SECONDS)

#undef TRAIT_RECENTLY_STAGGERED

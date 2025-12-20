/datum/action/cooldown/spell/aoe/repulse/howl
	name = "Terrifying Howl"
	desc = "Let loose a howl of dread, repelling anyone around you."
	button_icon_state = "howl"

	spell_type = SPELL_RAGE

	invocation_type = INVOCATION_NONE
	aoe_radius = 2

	has_visual_effects = FALSE
	click_to_activate = FALSE
	cooldown_time = 50 SECONDS
	spell_flags = SPELL_RITUOS
	spell_cost = 50
	charge_required = FALSE
	sound = 'sound/vo/mobs/wwolf/roar.ogg'

/datum/action/cooldown/spell/aoe/repulse/howl/is_valid_target(atom/cast_on)
	if(HAS_TRAIT(cast_on, TRAIT_RECENTLY_STAGGERED))
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/aoe/repulse/howl/cast_on_thing_in_aoe(atom/movable/victim, atom/caster)
	if(isliving(victim))
		var/mob/living/victim_mob = victim
		if(prob(victim_mob.get_shield_block_chance()))
			return

	var/turf/throwtarget = get_edge_target_turf(caster, get_dir(caster, get_step_away(victim, caster)))
	var/dist_from_caster = get_dist(victim, caster)

	if(sparkle_path)
		// Created sparkles will disappear on their own
		new sparkle_path(get_turf(victim), get_dir(caster, victim))

	if(dist_from_caster == 0)
		if(isliving(victim))
			var/mob/living/victim_living = victim
			victim_living.Paralyze(2.5 SECONDS)
			victim_living.adjustBruteLoss(5)
			to_chat(victim, span_userdanger("You're slammed into the floor by [caster]!"))
		return

	if(isliving(victim))
		var/mob/living/victim_living = victim
		victim_living.Paralyze(1.5 SECONDS)
		to_chat(victim, span_userdanger("You're thrown back by [caster]!"))

	// So stuff gets tossed around at the same time.
	victim.safe_throw_at(
		throwtarget,
		((clamp((max_throw - (clamp(dist_from_caster - 2, 0, dist_from_caster))), 3, max_throw))),
		1,
		caster,
		force = repulse_force
	)

	ADD_TRAIT(victim, TRAIT_RECENTLY_STAGGERED, "howl")
	addtimer(TRAIT_CALLBACK_REMOVE(victim, TRAIT_RECENTLY_STAGGERED, "howl"), 20 SECONDS)

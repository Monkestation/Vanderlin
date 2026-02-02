/datum/reagent/eldritch
	name = "Eldritch Essence"
	description = "A strange liquid that defies the laws of physics. \
		It re-energizes and heals those who can see beyond this fragile reality, \
		but is incredibly harmful to the closed-minded. It metabolizes very quickly."
	taste_description = "Ag'hsj'saje'sh"
	color = "#1f8016"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second

/datum/reagent/eldritch/on_mob_life(mob/living/carbon/drinker)
	drinker.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM, 150)
	drinker.adjustToxLoss(2 * REM, FALSE)
	drinker.adjustFireLoss(2 * REM, FALSE)
	drinker.adjustOxyLoss(2 * REM, FALSE)
	drinker.adjustBruteLoss(2 * REM, FALSE)
	..()
	return TRUE

/datum/status_effect/amok
	id = "amok"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	duration = 10 SECONDS
	tick_interval = 1 SECONDS

/datum/status_effect/amok/on_apply(mob/living/afflicted)
	. = ..()
	to_chat(owner, span_boldwarning("You feel filled with a rage that is not your own!"))
	return TRUE

/datum/status_effect/amok/tick()
	var/prev_combat_mode = owner.cmode
	owner.cmode = TRUE

	var/search_radius = 1

	var/list/mob/living/targets = list()
	for(var/mob/living/potential_target in oview(owner, search_radius))
		targets += potential_target

	if(LAZYLEN(targets))
		owner.log_message(" attacked someone due to the amok debuff.", LOG_ATTACK) //the following attack will log itself
		owner.ClickOn(pick(targets))

	owner.cmode = prev_combat_mode

/datum/status_effect/cloudstruck
	id = "cloudstruck"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	duration = 3 SECONDS
	on_remove_on_mob_delete = TRUE
	///This overlay is applied to the owner for the duration of the effect.
	var/static/mutable_appearance/mob_overlay

/datum/status_effect/cloudstruck/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	if(!mob_overlay)
		mob_overlay = mutable_appearance('icons/effects/eldritch.dmi', "cloud_swirl", ABOVE_MOB_LAYER)
	return ..()

/datum/status_effect/cloudstruck/on_apply()
	. = ..()
	owner.add_overlay(mob_overlay)
	owner.become_blind(id)
	return TRUE

/datum/status_effect/cloudstruck/on_remove()
	. = ..()
	owner.cure_blind(id)
	owner.cut_overlay(mob_overlay)

/datum/action/cooldown/spell/cone/staggered/eldritch_blast
	name = "Eldritch Blast"
	desc = "A plume of crackling energy streaks toward a target, causing moderate damage."
	button_icon_state = "eldritch_blast"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1
	attunements = list(
		/datum/attunement/dark = 0.3,
	)

	invocation = "Eldritch blast!"
	invocation_type = INVOCATION_SHOUT

	cone_levels = 5
	respect_density = TRUE

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 30 SECONDS
	spell_cost = 25
	spell_flags = SPELL_RITUOS

/datum/action/cooldown/spell/cone/staggered/eldritch_blast/cast(atom/cast_on)
	. = ..()
	new /obj/effect/temp_visual/dir_setting/entropic(get_step(cast_on, cast_on.dir), cast_on.dir)


/datum/action/cooldown/spell/cone/staggered/eldritch_blast/do_mob_cone_effect(mob/living/victim, atom/caster, level)
	if(victim.can_block_magic(antimagic_flags) || victim == caster)
		return
	victim.apply_status_effect(/datum/status_effect/amok)
	victim.apply_status_effect(/datum/status_effect/cloudstruck, level * 1 SECONDS)
	victim.reagents?.add_reagent(/datum/reagent/eldritch, max(1, 6 - level))


/obj/effect/temp_visual/dir_setting/entropic
	icon = 'icons/effects/160x160.dmi'
	icon_state = "entropic_plume"
	duration = 3 SECONDS

/obj/effect/temp_visual/dir_setting/entropic/setDir(dir)
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_x = -64
		if(SOUTH)
			pixel_x = -64
			pixel_y = -128
		if(EAST)
			pixel_y = -64
		if(WEST)
			pixel_y = -64
			pixel_x = -128

/datum/action/cooldown/spell/aoe/blood_harvest
	name = "Blood Harvest"
	desc = "Ravage all those around you and claim their blood."
	button_icon_state = "vicissitude"
	sound = 'sound/magic/invoke_general.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	learnable = FALSE
	spell_type = SPELL_BLOOD
	antimagic_flags = MAGIC_RESISTANCE_BLOOD
	associated_skill = /datum/attribute/skill/magic/blood

	invocation = "Your blood shall serve me!!"
	invocation_type = INVOCATION_SHOUT

	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 45 SECONDS
	spell_cost = 300

	aoe_radius = 7

	var/effect_range = 10
	var/can_heal_damage = FALSE
	var/heal_damage_amount = 0.5

/datum/action/cooldown/spell/aoe/blood_harvest/feedback(had_targets)
	if(!had_targets)
		to_chat(owner, span_warning("There are no valid targets to reave."))
		return
	owner.visible_message(
		SPAN_GOD_ARCHDEVILS("A crimson glow suddenly erupts in [owner]'s eyes as dark powers take hold!"),
		SPAN_GOD_ARCHDEVILS("I unleash the power of The Forgotten Ones, draining the very lifeforce of those around me."),
	)

/datum/action/cooldown/spell/aoe/blood_harvest/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/aoe/blood_harvest/cast_on_thing_in_aoe(mob/living/victim, atom/caster)
	if(HAS_ANY_OF_TRAITS(target, list(TRAIT_NOBLOOD, TRAIT_DEVILS_REJECTION)))
		return
	if(victim.stat == DEAD)
		return
	if(victim.has_status_effect(/datum/status_effect/buff/blood_mark/befriend))
		return
	if(victim.has_faction(FACTION_BLOOD_MAGIC))
		return
	victim.apply_status_effect(/datum/status_effect/debuff/blood_harvest, null, owner, clamp(round(GET_MOB_SKILL_VALUE_OLD(owner, associated_skill)), 1 , 3), effect_range, can_heal_damage, heal_damage_amount)

/datum/action/cooldown/spell/aoe/blood_harvest/invocation(mob/living/invoker)
	//lists can be sent by reference, a string would be sent by value
	var/list/invocation_list = list(invocation, invocation_type)
	SEND_SIGNAL(invoker, COMSIG_MOB_PRE_INVOCATION, src, invocation_list)
	var/used_invocation_message = invocation_list[INVOCATION_MESSAGE]
	var/used_invocation_type = invocation_list[INVOCATION_TYPE]

	switch(used_invocation_type)
		if(INVOCATION_SHOUT)
			invoker.say(used_invocation_message, spans = list("god_archdevil"), forced = "spell ([src])")

		if(INVOCATION_WHISPER)
			invoker.whisper(used_invocation_message, spans = list("god_archdevil"), forced = "spell ([src])")

		if(INVOCATION_EMOTE)
			invoker.visible_message(
				capitalize(replace_pronouns(replacetext(used_invocation_message, "%CASTER", invoker.name), invoker)),
				capitalize(replace_pronouns(replacetext(invocation_self_message, "%CASTER", invoker.name), invoker)),
			)

/atom/movable/screen/alert/status_effect/debuff/blood_harvest
	name = "Blood Harvest"
	desc = "Wounds are opening upon my flesh and my blood is being ripped out of me!"
	icon_state = "bloodcurse"

// This should be stacking
/datum/status_effect/debuff/blood_harvest
	id = "blood_harvest"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_harvest
	duration = 10 SECONDS
	examine_text = "<b>SUBJECTPRONOUN writhes as their blood seeks freedom!</b>"
	effectedstats = list(STAT_CONSTITUTION = -2)
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 2 DECISECONDS
	var/datum/weakref/debuffer
	var/outline_colour = COLOR_BLOOD_MAGIC
	var/base_tick = 0.5
	var/intensity = 1
	var/range = 10
	var/can_heal_damage = FALSE
	var/heal_damage_amount = 0.5
	var/datum/beam/transfer_beam

/datum/status_effect/debuff/blood_harvest/on_creation(mob/living/new_owner, duration_override, mob/living/caster, potency, effect_range, if_heal_damage, heal_damage_amt)
	intensity = potency
	range = effect_range
	can_heal_damage = if_heal_damage
	heal_damage_amount = heal_damage_amt
	if(caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/debuff/blood_harvest/on_apply()
	. = ..()
	to_chat(owner, span_bloody("My blood is being pulled from my body, I must flee!"))
	owner.add_filter("filter_blood_harvest", 2, outline_filter(1, outline_colour))

/datum/status_effect/debuff/blood_harvest/on_remove()
	. = ..()
	to_chat(owner, span_notice("I've escaped the blood harvest!"))
	owner.remove_filter("filter_blood_harvest")
	qdel(transfer_beam)

/datum/status_effect/debuff/blood_harvest/refresh(mob/living/new_owner, duration_override, ...)
	. = ..()
	intensity += 1
	to_chat(owner, span_boldwarning("The pull on my blood intensifies, ripping it from my flesh!"))

/datum/status_effect/debuff/blood_harvest/tick()
	if(!owner)
		return
	var/mob/living/carbon/human/status_victim = owner

	var/damage_amount = base_tick * intensity

	if(prob(66))
		to_chat(status_victim, span_bloody("Bloody mist tears from my flesh!"))
		status_victim.adjustFireLoss(damage_amount / 2)
		status_victim.adjustBruteLoss(damage_amount / 2)

	if(prob(5))
		status_victim.playsound_local(status_victim, 'sound/heart/fastbeat.ogg', 50)

	if(prob(1))
		status_victim.emote("scream")

	if(!debuffer)
		return
	var/mob/living/our_debuffer = debuffer.resolve()

	var/floored_damage = floor(damage_amount)
	var/vitae_amount = floored_damage * 2

	if(status_victim.bloodpool)
		status_victim.adjust_bloodpool(-vitae_amount)
	our_debuffer.adjust_bloodpool(vitae_amount)

	status_victim.adjust_blood_volume(-floored_damage)
	our_debuffer.adjust_stamina(-floored_damage)
	our_debuffer.adjust_energy(floored_damage)
	our_debuffer.heal_overall_damage(heal_damage_amount, heal_damage_amount)
	status_victim.adjust_blood_volume(floored_damage, maximum = BLOOD_VOLUME_SAFE_MAXIMUM)

	if(!transfer_beam)
		transfer_beam = our_debuffer.Beam(status_victim, icon_state = "drain_life", time = INFINITY)

	if(get_dist(our_debuffer, status_victim) > range)
		qdel(src)

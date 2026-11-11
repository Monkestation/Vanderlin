/datum/action/cooldown/spell/blood_transfusion
	name = "Blood Transfusion"
	desc = "Launch a bolt of your own blood to pass it to another."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation = "P'SS LF'E!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 125
	spell_flags = SPELL_UNETCHABLE

/datum/action/cooldown/spell/blood_transfusion/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on) || !ishuman(owner))
		return
	var/mob/living/carbon/human/target = cast_on
	var/mob/living/carbon/human/human_owner = owner

	var/blood_adjustment = human_owner.default_blood_volume / 10
	if(human_owner.blood_volume < (blood_adjustment + BLOOD_VOLUME_SURVIVE))
		to_chat(human_owner, span_bloody("I do not have enough blood for a transfusion."))
		return
	if(target.blood_volume >= BLOOD_VOLUME_SAFE_MAXIMUM)
		to_chat(human_owner, span_bloody("[target] does not require a blood transfusion."))
		return

	target.Beam(human_owner, icon_state = "drain_life", time = 3 SECONDS)
	human_owner.adjust_blood_volume(-blood_adjustment)
	target.adjust_blood_volume(blood_adjustment)
	target.adjust_jitter(4 SECONDS)
	to_chat(human_owner, span_bloody("You pass your own blood to [target]."))

	target.visible_message(
			span_danger("[target] shudders as blood pours into their veins!"),
			span_userdanger("Blood forces itself into my body!"),
			span_hear("I hear a fluid spill..."),
		)
	new /obj/effect/decal/cleanable/blood/puddle(get_turf(human_owner), human_owner.get_blood_type().color)

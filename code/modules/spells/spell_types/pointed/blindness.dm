/datum/action/cooldown/spell/blindness
	name = "Blindness"
	desc = "Point at a target to blind them for few seconds."
	button_icon_state = "blindness"
	sound = 'sound/magic/churn.ogg'

	attunements = list(
		/datum/attunement/arcyne = 0.1
	)

	invocation = "darkness envelop them."
	invocation_type = INVOCATION_WHISPER

	spell_flags = SPELL_RITUOS
	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 30

/datum/action/cooldown/spell/blindness/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/blindness/cast(mob/living/cast_on)
	. = ..()
	cast_on.adjust_temp_blindness(6 SECONDS)
	cast_on.visible_message(span_warning("[owner] points at [cast_on]'s eyes!"), span_warning("My eyes are covered in darkness!"))

/datum/action/cooldown/spell/blindness/miracle
	name = "Noc's Blindness"
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/noc)

	invocation = "Noc blinds thee of thy sins!"
	invocation_type = INVOCATION_SHOUT


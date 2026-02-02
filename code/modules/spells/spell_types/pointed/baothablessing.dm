/datum/action/cooldown/spell/baothablessings
	name = "Baotha's Blessings"
	desc = "Reverses overdose effect on a target and soothe their mood.."
	button_icon_state = "lesserheal"
	sound = 'sound/magic/heal.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "Receive Boatha's Gift."
	invocation_type = INVOCATION_WHISPER

	cast_range = 4
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 10

/datum/action/cooldown/spell/baothablessings/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/baothablessings/cast(mob/living/cast_on)
	. = ..()
	if(istype(cast_on.patron, /datum/patron/psydon))
		cast_on.visible_message(span_info("[cast_on] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(cast_on, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return
	if(cast_on.has_status_effect(/datum/status_effect/buff/druqks/baotha))
		to_chat(owner, span_warning("They're already blessed by these effects!"))
		return
	cast_on.apply_status_effect(/datum/status_effect/buff/druqks/baotha) //Gets the trait temorarily, basically will just stop any active/upcoming ODs.
	cast_on.visible_message("<span class='info'>[cast_on]'s eyes appear to gloss over!</span>", "<span class='notice'>I feel.. at ease.</span>")

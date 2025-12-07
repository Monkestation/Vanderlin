/datum/action/cooldown/spell/painkiller
	name = "Numbing Pleasure"
	button_icon_state = "astrata"
	sound = 'sound/magic/timestop.ogg'


	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "May you find bliss through your pain."
	invocation_type = INVOCATION_WHISPER

	attunements = list(
		/datum/attunement/electric = 0.3,
		/datum/attunement/aeromancy = 0.3,
	)

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 75

/datum/action/cooldown/spell/painkiller/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/painkiller/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/datum/physiology/phy = cast_on.physiology
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		return	//No, you don't get to feel good. You're an undead mob. Feel bad.
	cast_on.visible_message(span_info("[cast_on] begins to twitch as warmth radiates from them!"), span_notice("The pain from my wounds fade, every new one being a mere pleasant warmth!"))
	phy.pain_mod *= 0.5	//Literally halves your pain modifier.
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 0.5), 1 MINUTES)	//Adds back the 0.5 of pain, basically setting it back to 1.
	cast_on.apply_status_effect(/datum/status_effect/buff/lux_drank/baothavitae)					//Basically lowers fortune by 2 but +3 speed, it's powerful. Drugs cus Baotha.

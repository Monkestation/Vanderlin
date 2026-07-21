/datum/action/cooldown/spell/undirected/joy
	name = "Joy"
	desc = "Oh, boy! Here I go killing again!"
	button_icon_state = "joy"
	sound = 'sound/magic/sunshineday.ogg'

	antimagic_flags = NONE

	associated_stat = STAT_CONSTITUTION

	charge_required = FALSE
	has_visual_effects = FALSE
	cooldown_time = 4 MINUTES
	spell_type = SPELL_STAMINA

/datum/action/cooldown/spell/undirected/joy/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(owner)

/datum/action/cooldown/spell/undirected/joy/cast(mob/living/cast_on)
	. = ..()
	cast_on.emote("smile", forced = TRUE)
	cast_on.apply_status_effect(/datum/status_effect/buff/pyrojoy) // To mitigate the amount of stress you'll get. It's a LOT.
	cast_on.reagents?.add_reagent(/datum/reagent/medicine/healthpot, 7) // Slight mitigation due to the amount of wounds you receive.
	cast_on.reagents?.add_reagent(/datum/reagent/medicine/endorphin, 5) // To mitigate the immediate pain.

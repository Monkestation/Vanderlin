/datum/action/cooldown/spell/gem_detect
	name = "Ore Sight"
	desc = "Reveals the location of precious stones and crystals nearby."
	button_icon_state = "aros"
	button_icon = 'icons/roguetown/items/gems.dmi'
	spell_cost = 30
	required_form = FORM_EARTH

/datum/action/cooldown/spell/gem_detect/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/gem_detect/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human = cast_on
	human.set_oresight(TRUE)

	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob/living, set_oresight), FALSE), 5 MINUTES)

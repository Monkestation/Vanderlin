/datum/action/cooldown/spell/essence/gem_detect
	name = "Gem Detect"
	desc = "Reveals the location of precious stones and crystals nearby."
	button_icon_state = "aros"
	button_icon = 'icons/roguetown/items/gems.dmi'
	cast_range = 3
	point_cost = 4
	attunements = list(/datum/attunement/earth)
	essences = list(/datum/thaumaturgical_essence/crystal)

/datum/action/cooldown/spell/essence/gem_detect/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human = owner
	human.set_oresight(TRUE)

	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob/living, set_oresight), FALSE), 10 SECONDS)

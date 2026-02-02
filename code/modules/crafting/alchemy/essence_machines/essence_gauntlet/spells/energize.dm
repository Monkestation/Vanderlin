/datum/action/cooldown/spell/essence/energize
	name = "Energize"
	desc = "Restores energy to magical devices or provides a burst of vitality."
	button_icon_state = "energize"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/light)

/datum/action/cooldown/spell/essence/energize/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	owner.visible_message(span_notice("[owner] channels energy into [target]."))

	if(istype(target, /mob/living))
		var/mob/living/L = target
		L.adjust_stamina(30)
		L.adjust_energy(30)

	if(istype(target, /obj/structure/mana_pylon))
		var/obj/structure/mana_pylon/pylon = target
		pylon.mana_pool.adjust_mana(30)

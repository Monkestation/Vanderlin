/datum/action/cooldown/spell/essence/refresh
	name = "Refresh"
	desc = "Removes minor fatigue and restores a small amount of stamina."
	button_icon_state = "refresh"
	//sound = 'sound/magic/staff_healing.ogg'
	cast_range = 1
	point_cost = 3
	attunements = list(/datum/attunement/life)

/datum/action/cooldown/spell/essence/refresh/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] appears refreshed."))
	//playsound(owner, 'sound/magic/staff_healing.ogg', 50, TRUE)

	target.adjust_stamina(20)
	target.adjust_energy(20)

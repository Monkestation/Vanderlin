/datum/action/cooldown/spell/essence/mend
	name = "Minor Mend"
	desc = "Repairs minor damage to simple objects."
	button_icon_state = "mend"
	//sound = 'sound/magic/staff_healing.ogg'
	cast_range = 1
	attunements = list(/datum/attunement/earth)
	point_cost = 3

/datum/action/cooldown/spell/essence/mend/cast(atom/cast_on)
	. = ..()
	var/obj/item/target = cast_on
	if(!isobj(target))
		return FALSE

	owner.visible_message(span_notice("[owner] gestures, mending minor damage to [target]."))
	//playsound(get_turf(target), 'sound/magic/staff_healing.ogg', 50, TRUE)

	// Restore some durability or repair minor damage
	if(target.get_integrity() < target.max_integrity)
		target.repair_damage(10)

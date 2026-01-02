/datum/action/cooldown/spell/essence/stabilize
	name = "Stabilize"
	desc = "Prevents objects from moving or falling for a short time."
	button_icon_state = "stabilize"
	cast_range = 2
	point_cost = 4
	attunements = list(/datum/attunement/earth)

/datum/action/cooldown/spell/essence/stabilize/cast(atom/cast_on)
	. = ..()
	var/obj/target = cast_on
	if(!target)
		return FALSE
	if(!istype(target))
		return FALSE
	if(target.anchored)
		return

	owner.visible_message(span_notice("[owner] stabilizes [target] with magical force."))
	new /obj/effect/temp_visual/solosnake(get_turf(target))
	target.anchored = TRUE
	addtimer(VARSET_CALLBACK(target, anchored, FALSE), 30 SECONDS)

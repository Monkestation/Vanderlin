
/datum/antagonist/skeleton
	name = "Skeleton"
	roundend_category = "Lich"
	antagpanel_category = "Necromancy"
	antag_hud_type = ANTAG_HUD_NECROMANCY
	antag_hud_name = "skeleton"
	increase_votepwr = FALSE

/datum/antagonist/skeleton/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		var/datum/antagonist/vampire/V = examined_datum
		if(!V.disguised)
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite. My ally.")

/datum/antagonist/skeleton/greet()
	owner.announce_objectives()
	..()

/datum/antagonist/skeleton/roundend_report()
	return

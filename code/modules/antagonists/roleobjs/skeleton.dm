
/datum/antagonist/skeleton
	name = "Skeleton"
	roundend_category = ROLE_LICH
	job_rank = ROLE_NECRO_SKELETON
	antagpanel_category = "Necromancy"
	antag_hud_type = ANTAG_HUD_NECROMANCY
	antag_hud_name = "skeleton"
	increase_votepwr = FALSE

/datum/antagonist/skeleton/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
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

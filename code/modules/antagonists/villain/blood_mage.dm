/datum/antagonist/blood_mage
	name = "Blood Mage"
	antagpanel_category = "Blood Mages"
	roundend_category = "Blood Mages"
	show_name_in_check_antagonists = TRUE
	antag_hud_type = ANTAG_HUD_BLOOD_MAGE

/datum/antagonist/blood_mage/mage
	antag_hud_name = "bloodmage"
	confess_lines = list(
		"BLOOD IS POWER!",
		"YOUR VITAE IS MINE!",
		"LIFE AND DEATH IS IN MY HANDS!",
	)

/datum/antagonist/blood_mage/mage/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/blood_mage/occult))
		return
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A formidable Blood Sorcerer, they could teach me much.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/mage))
		return span_boldnotice("A fellow Blood Mage.")

/datum/antagonist/blood_mage/sorcerer
	name = "Blood Sorcerer"
	antag_hud_name = "bloodsorc"
	confess_lines = list(
		"THE POWER OF THE ANCIENTS!",
		"NO GOD CAN CLAIM MY POWER!",
		"BLOOD IS MY LEGACY!",
	)

/datum/antagonist/blood_mage/sorcerer/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord/daewalker))
		return span_boldnotice("The immortal servant of the Sun Queen.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord/nitewalker))
		return span_boldnotice("The immortal servant of the Moon Prince.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Firstborn lord of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/lords_spawn))
		return span_boldnotice("The spawn of the firstborn.")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/outcast))
		return span_boldnotice("An outcast child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A fellow Blood Sorcerer.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/mage))
		return span_boldnotice("An established Blood Mage.")

/datum/antagonist/blood_mage/student
	name = "Blood Magic Apprentice"
	antag_hud_name = "bloodapp"
	increase_votepwr = FALSE

/datum/antagonist/blood_mage/student/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A Scion of Blood Magic... the things I could learn...")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A fellow student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/mage))
		return span_boldnotice("An established Blood Mage, they could teach me much.")

/datum/antagonist/blood_mage/occult
	name = "Occult Librarian"
	antag_hud_name = null
	antag_hud_type = null
	increase_votepwr = FALSE

/datum/antagonist/blood_mage/occult/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	return

/datum/antagonist/blood_mage/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
			to_chat(world, "[the_name] was a [name].")
	return

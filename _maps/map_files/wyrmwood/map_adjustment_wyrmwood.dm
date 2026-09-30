/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/wyrmwood
	map_file_name = "wyrmwood.dmm"
	blacklist = list(
		/datum/job/tomb_warden,
		/datum/job/matron,
		/datum/job/grabber,
		/datum/job/courtphys,
		/datum/job/hand,
		/datum/job/forestwarden,
		/datum/job/forestguard,
		/datum/job/forestenforcer,
		/datum/job/forestpreacher,
		/datum/job/forestsupport,
		/datum/job/gatemaster,
		/datum/job/town_elder,
		/datum/job/bandit,
		/datum/job/gmtemplar,
		/datum/job/minor_noble,
		/datum/job/courtagent,
		/datum/job/templar,
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/adept,
		/datum/job/orthodoxist,
		/datum/job/mercenary,
		/datum/job/tapster,
		/datum/job/prisoner,
	)

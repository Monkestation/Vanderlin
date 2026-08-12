/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/valdero
	map_file_name = "valdero.dmm"
	blacklist = list(
		/datum/job/tomb_warden,
		/datum/job/matron,
		/datum/job/courtphys,
		/datum/job/forestwarden,
		/datum/job/forestguard,
		/datum/job/forestenforcer,
		/datum/job/forestpreacher,
		/datum/job/forestsupport,
		/datum/job/town_elder,
		/datum/job/lieutenant,
		/datum/job/bandit,
		/datum/job/courtagent,
		/datum/job/archivist,
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/adept,
		/datum/job/orthodoxist,
	)
	slot_adjust = list(
		/datum/job/royalknight = 1
		/datum/job/squire = 1
	)

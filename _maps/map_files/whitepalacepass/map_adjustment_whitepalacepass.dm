/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/whitepalacepass
	map_file_name = "WhitePalacePass.dmm"
	blacklist = list(
		/datum/job/shophand, //Unneeded honestly.
		/datum/job/forestguard,
		/datum/job/forestwarden,
		/datum/job/dungeoneer,
		/datum/job/prisoner,
		/datum/job/jailor,
		/datum/job/gaffer_assistant //Never filled, prefer to just ditch it.
	)
	// Limited positions to ensure core roles are filled.
	slot_adjust = list(
		/datum/job/feldsher = 2,
		/datum/job/tapster = 2,
		/datum/job/cook = 2,
		/datum/job/servant = 3,
		/datum/job/carpenter = 2,
		/datum/job/hunter = 2,
		/datum/job/bard = 3,
		/datum/job/bapprentice = 3,
		/datum/job/miner = 4,
		/datum/job/fisher = 2,
		/datum/job/farmer = 3,
		/datum/job/orphan = 6,
		/datum/job/men_at_arms = 4,
		/datum/job/guardsman = 6,
		/datum/job/mercenary = 3,
		/datum/job/artificer = 2,
		/datum/job/adept = 4
	)
	ages_adjust = list(
		/datum/job/forestguard = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	)

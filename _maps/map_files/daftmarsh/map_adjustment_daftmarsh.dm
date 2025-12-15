/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/daftmarsh
	map_file_name = "daftmarsh.dmm"
	// Disabled for Daftmarsh.
	blacklist = list(
		/datum/job/courtphys, //Against design idea.
		/datum/job/tapster, //Unneeded.
		/datum/job/shophand, //Unneeded honestly.
		/datum/job/gaffer_assistant, //Never filled, prefer to just ditch it.
		/datum/job/minor_noble, //Minor nobles will have to approach via pilgrim waves and be guests that way.
		/datum/job/absolver,
	)
	// Limited positions to ensure core roles are filled.
	slot_adjust = list(
		/datum/job/feldsher = 1,
		/datum/job/cook = 1,
		/datum/job/servant = 2,
		/datum/job/carpenter = 2, //Towner roles don't need nearly as many, here.
		/datum/job/hunter = 2,
		/datum/job/bard = 3,
		/datum/job/miner = 4,
		/datum/job/fisher = 4, //Thematically fitting for them to be more common than most.
		/datum/job/farmer = 4, //Not like this would ever be filled ANYWAYS.
		/datum/job/vagrant = 6, //Beggars and orphans don't need to be nearly so populated.
		/datum/job/orphan = 6,
		/datum/job/men_at_arms = 3, //Combat roles overall tuned town a bit.
		/datum/job/guardsman = 6,
		/datum/job/adventurer = 8, //Not sure on this one but I generally want to cut down on the non-town roles.
		/datum/job/pilgrim = 15,
		/datum/job/adept = 1,
		/datum/job/clinicapprentice = 2,
	)

	ages_adjust = list(
		/datum/job/forestguard = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	)

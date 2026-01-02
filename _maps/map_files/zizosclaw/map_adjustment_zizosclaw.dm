/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

#define DARK_ELF list(\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW\
)

#define ZIZO_DEVOTEE list(
	/datum/patron/inhumen/zizo
)

/datum/map_adjustment/zizosclaw
	map_file_name = "zizosclaw.dmm"
	species_adjust = list(
		/datum/job/lord = DARK_ELF,
		/datum/job/consort = DARK_ELF,
		/datum/job/prince = DARK_ELF,
		/datum/job/hand = DARK_ELF,
		/datum/job/captain = DARK_ELF,
		/datum/job/steward = DARK_ELF,
		/datum/job/courtphys = DARK_ELF,
	)
	patron_adjust = list(
		/datum/job/lord = ZIZO_DEVOTEE,
	)


#undef DARK_ELF
#undef ZIZO_DEVOTEE

	ages_adjust = list(
		/datum/job/forestguard = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	)

	blacklist = list(
		// Inquisition
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/adept,
		/datum/job/orthodoxist,
		// RACES_PLAYER_GRENZ
		/datum/job/advclass/combat/swordmaster,
		/datum/job/advclass/mercenary/grenzelhoft,
		/datum/job/advclass/pilgrim/rare/grenzelhoft,
		/datum/job/advclass/pilgrim/rare/preacher,
		/datum/job/advclass/veteran/merc,
		// Church
		/datum/job/priest
		/datum/job/monk
		/datum/job/templar
		/datum/job/churchling

	)

	migrant_blacklist = list(
		/datum/migrant_wave/crusade,
		/datum/migrant_wave/grenzelhoft_visit,
	)

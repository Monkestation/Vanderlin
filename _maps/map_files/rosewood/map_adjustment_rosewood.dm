/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

#define POINTY_EARS list(\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF\
)

/datum/map_adjustment/rosewood
	map_file_name = "rosewood.dmm"
	species_adjust = list(
		/datum/job/lord = POINTY_EARS,
		/datum/job/prince = POINTY_EARS,
		/datum/job/hand = POINTY_EARS,
		/datum/job/captain = POINTY_EARS
	)

#undef POINTY_EARS

	ages_adjust = list(
		/datum/job/forestguard = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	)

	slot_adjust = list(
		/datum/job/bard = 2,
		/datum/job/monk = 7,
		/datum/job/templar = 1,
		/datum/job/churchling = 5,
		/datum/job/farmer = 4
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
		//event
		/datum/job/lord,
		/datum/job/consort,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/captain,
		/datum/job/steward,
		/datum/job/courtphys,
		/datum/job/archivist,
		/datum/job/magician,
		/datum/job/minor_noble,
		/datum/job/adventurer/courtagent,
		/datum/job/priest,
		/datum/job/servant,
		/datum/job/mageapprentice,
		/datum/job/merchant,
		/datum/job/wretch,
		/datum/job/bandit,
		/datum/job/royalknight,
		/datum/job/dungeoneer,
		/datum/job/men_at_arms,
		/datum/job/gatemaster,
		/datum/job/forestwarden,
		/datum/job/forestguard,
		/datum/job/jester,
		/datum/job/artificer,
		/datum/job/butler,
		/datum/job/fisher,
		/datum/job/grabber,
		/datum/job/shophand,
	)

	migrant_blacklist = list(
		/datum/migrant_wave/crusade,
		/datum/migrant_wave/grenzelhoft_visit,
	)

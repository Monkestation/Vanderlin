/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

#define DARK_ELF list(\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW\
)

#define SERVANTRY list(\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW\
)

// Those raised to Zizonian worship, or converted/brainwashed to an extent to be trusted as leadership.
#define ZIZO_DEVOTEE list(\
	/datum/patron/inhumen/zizo\
)

// All dark elves in leadership must be younger, as the old ones may still remember their Ravoxian culture. ~400 years max.
#define AGE_POST_CONQUEST list(\
	AGE_ADULT\
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
		/datum/job/royalknight = DARK_ELF,
		// Hollowkin servantry:
		/datum/job/servant = SERVANTRY,
		/datum/job/butler = SERVANTRY,
	)
	patron_adjust = list(
		/datum/job/lord = ZIZO_DEVOTEE,
		/datum/job/hand = ZIZO_DEVOTEE,
		/datum/job/captain = ZIZO_DEVOTEE,
		/datum/job/royalknight = ZIZO_DEVOTEE,
	)

	sexes_adjust = list(
		/datum/job/lord = list(FEMALE),
		/datum/job/hand = list(FEMALE),
		/datum/job/captain = list(FEMALE),
	)

	ages_adjust = list(
		/datum/job/lord = AGE_POST_CONQUEST,
		/datum/job/hand = AGE_POST_CONQUEST,
		/datum/job/captain = AGE_POST_CONQUEST,
	)

	jobname_adjust = list(
		/datum/job/farmer = list(
			"title" = "Celson",
			"title_fem" = "Celbride",
			),
		/datum/job/soilchild = list(
			"title" = "Sporeling",
			"title_fem" = "Sporeling",
		),
		/datum/job/carpenter = list(
			"title" = "Capcarver"
		),
		/datum/job/forestwarden = list(
			"title" = "Gloomwarden"
		),
	)

#undef DARK_ELF
#undef SERVANTRY
#undef ZIZO_DEVOTEE
#undef AGE_POST_CONQUEST

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
		// Church - Moved to keep, Zizonian.
		/datum/job/priest,
		/datum/job/monk,
		/datum/job/templar,
		/datum/job/churchling,
		/datum/job/undertaker,
		// Unwanted roles
		/datum/job/minor_noble,
		/datum/job/mercenary,
		/datum/job/gaffer,
		/datum/job/gaffer_assistant,
		/datum/job/mageapprentice,
		/datum/job/clinicapprentice,
		/datum/job/lieutenant,
		/datum/job/tapster,
		/datum/job/jester, // Zizo says no fun allowed! Xylixians sob.
		// Old party
		/datum/job/matron,
		/datum/job/town_elder,
		/datum/job/veteran,
		/datum/job/magician,
		/datum/job/gatemaster,
		// Roles overridden by variant:
		/datum/job/apothecary, // Apoth + feldsher = Mycologist.
		/datum/job/feldsher,
		/datum/job/archivist, // Court Mage + archivist = Sanguine Scholar
		/datum/job/guardsman, // Redcap
		/datum/job/men_at_arms,
		/datum/job/merchant, // Marchand-mercier.
		/datum/job/shophand,
		/datum/job/grabber,
		/datum/job/artificer, // Tinkerer.
		/datum/job/mason, // Mason + Miner = Stoneson/Stonebride.
		/datum/job/miner,
		/datum/job/hunter, // Fisher + Hunter = Orion
		/datum/job/fisher,
		/datum/job/armorsmith, // Armorsmith + Weaponsmith = Blacksmith
		/datum/job/weaponsmith,
		/datum/job/forestguard, // Gloomwarden
		/datum/job/forestwarden,

	)

	migrant_blacklist = list(
		/datum/migrant_wave/crusade,
		/datum/migrant_wave/grenzelhoft_visit,
	)

	//whitelist = list ()

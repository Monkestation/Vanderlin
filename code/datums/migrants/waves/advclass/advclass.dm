/datum/migrant_role/advclass/pilgrim
	name = JOB_PILGRIM
	migrant_job = /datum/job/pilgrim
	advclass_cat_rolls = list(CTAG_PILGRIM = 10)

/datum/migrant_wave/pilgrim
	name = "Pilgrimage"
	roles = list(
		/datum/migrant_role/advclass/pilgrim = 4,
	)
	weight = 20
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Vanderlin, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_role/advclass/adventurer
	name = JOB_ADVENTURER
	migrant_job = /datum/job/adventurer
	advclass_cat_rolls = list(CTAG_ADVENTURER = 5)

/datum/migrant_wave/adventurer
	name = "Adventure Party"
	weight = 20
	roles = list(
		/datum/migrant_role/advclass/adventurer = 4,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Vanderlin, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_role/advclass/bandit
	name = ROLE_BANDIT
	migrant_job = /datum/job/bandit
	advclass_cat_rolls = list(CTAG_BANDIT = 20)

/datum/migrant_wave/bandit
	name = "Bandit Raid"
	spawn_landmark = ROLE_BANDIT
	weight = 8
	roles = list(
		/datum/migrant_role/advclass/bandit = 4,
	)
	can_roll = FALSE

/datum/migrant_role/advclass/mercenary
	name = JOB_MERCENARY
	migrant_job = /datum/job/mercenary
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)

/datum/migrant_wave/merc
	name = "Band of Mercenaries"
	weight = 8
	roles = list(
		/datum/migrant_role/advclass/mercenary = 4,
	)

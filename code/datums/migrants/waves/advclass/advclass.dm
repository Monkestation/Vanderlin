/datum/migrant_role/advclass/pilgrim
	name = "Pilgrim"
	migrant_job = /datum/job/pilgrim
	advclass_cat_rolls = list(CTAG_PILGRIM = 10)

/datum/migrant_wave/pilgrim
	name = "Pilgrimage"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_one
	roles = list(
		/datum/migrant_role/advclass/pilgrim = 4,
	)
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Vanderlin, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_wave/pilgrim_down_one
	name = "Pilgrimage"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/pilgrim = 3,
	)
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Vanderlin, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_wave/pilgrim_down_two
	name = "Pilgrimage"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/pilgrim = 2,
	)
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Vanderlin, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_wave/pilgrim_down_three
	name = "Pilgrimage"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/pilgrim = 1,
	)
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Vanderlin, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_role/advclass/adventurer
	name = "Adventurer"
	migrant_job = /datum/job/adventurer
	advclass_cat_rolls = list(CTAG_ADVENTURER = 5)

/datum/migrant_wave/adventurer
	name = "Adventure Party"
	downgrade_wave = /datum/migrant_wave/adventurer_down_one
	roles = list(
		/datum/migrant_role/advclass/adventurer = 4,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Vanderlin, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_wave/adventurer_down_one
	name = "Adventure Party"
	downgrade_wave = /datum/migrant_wave/adventurer_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/adventurer = 3,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Vanderlin, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_wave/adventurer_down_two
	name = "Adventure Party"
	downgrade_wave = /datum/migrant_wave/adventurer_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/adventurer = 2,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Vanderlin, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_wave/adventurer_down_three
	name = "Adventure Party"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/adventurer = 1,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Vanderlin, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_role/advclass/bandit
	name = "Bandit"
	migrant_job = /datum/job/bandit
	advclass_cat_rolls = list(CTAG_BANDIT = 20)

/datum/migrant_wave/bandit
	name = "Bandit Raid"
	spawn_landmark = "Bandit"
	downgrade_wave = /datum/migrant_wave/bandit_down_one
	weight = 8
	roles = list(
		/datum/migrant_role/advclass/bandit = 4,
	)
	can_roll = FALSE

/datum/migrant_wave/bandit_down_one
	name = "Bandit Raid"
	spawn_landmark = "Bandit"
	downgrade_wave = /datum/migrant_wave/bandit_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/bandit = 3,
	)

/datum/migrant_wave/bandit_down_two
	name = "Bandit Raid"
	spawn_landmark = "Bandit"
	downgrade_wave = /datum/migrant_wave/bandit_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/bandit = 2,
	)

/datum/migrant_wave/bandit_down_three
	name = "Bandit Raid"
	spawn_landmark = "Bandit"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/bandit = 1,
	)

/datum/migrant_role/advclass/mercenary
	name = "Mercenary"
	migrant_job = /datum/job/mercenary
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)

/datum/migrant_wave/merc
	name = "Band of Mercenaries"
	downgrade_wave = /datum/migrant_wave/merc_down_one
	weight = 8
	roles = list(
		/datum/migrant_role/advclass/mercenary = 4,
	)

/datum/migrant_wave/merc_down_one
	name = "Band of Mercenaries"
	downgrade_wave = /datum/migrant_wave/merc_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/mercenary = 3,
	)

/datum/migrant_wave/merc_down_two
	name = "Band of Mercenaries"
	downgrade_wave = /datum/migrant_wave/merc_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/mercenary = 2,
	)

/datum/migrant_wave/merc_down_three
	name = "Band of Mercenaries"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/mercenary = 1,
	)

/datum/migrant_role/advclass/folkhero
	name = "Folkhero"
	migrant_job = /datum/job/folkhero
	advclass_cat_rolls = list(CTAG_FOLKHEROES = 20)

/datum/migrant_wave/folkheroes
	name = "Folkheroes"
	max_spawns = 1
	downgrade_wave = /datum/migrant_wave/folkheroes_down_one
	weight = 4
	roles = list(
		/datum/migrant_role/advclass/folkhero = 3,
	)

/datum/migrant_wave/folkheroes_down_one
	name = "Folkheroes"
	downgrade_wave = /datum/migrant_wave/folkheroes_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/folkhero = 2,
	)

/datum/migrant_wave/folkheroes_down_two
	name = "Folkheroes"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/advclass/folkhero = 1,
	)

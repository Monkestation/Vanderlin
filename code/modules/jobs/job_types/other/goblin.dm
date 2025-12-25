/datum/job/goblin
	title = "Goblin"
	job_flags = JOB_EQUIP_RANK
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	allowed_races = RACES_PLAYER_ALL
	spawn_type = /mob/living/carbon/human/species/goblin/cave
	outfit = /datum/outfit/npc/goblin
	give_bank_account = FALSE

	traits = list(
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_CRITICAL_WEAKNESS
	)

/datum/job/goblin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.mind)
		spawned.mind.special_role = "goblin"
		spawned.mind.current.job = null

	spawned.faction = list(FACTION_ORCS)
	spawned.name = "goblin"
	spawned.real_name = "goblin"

	if(spawned.charflaw)
		QDEL_NULL(spawned.charflaw)

	spawned.remove_all_languages()
	spawned.grant_language(/datum/language/hellspeak)

/datum/antagonist/vampire/lords_spawn
	name = "Vampire Spawn"
	antag_hud_name = "vampspawn"
	confess_lines = list(
		"THE CRIMSON MASTER CALLS!",
		"MY MASTER COMMANDS!",
		"THE SUN IS THE ANATHEMA OF OUR MASTER!",
	)

/datum/antagonist/vampire/lords_spawn/on_gain()
	var/mob/living/carbon/human/vampire = owner.current
	remove_job()
	vampire.delete_equipment()
	vampire.reset_and_reroll_stats()
	vampire.purge_combat_knowledge()
	vampire.remove_all_traits()
	. = ..()
	vampire.grant_undead_eyes()
	ADD_TRAIT(vampire, TRAIT_FOREIGNER, JOB_TRAIT)
	SSrole_class_handler.setup_class_handler(vampire, list(CTAG_ADVENTURER = 5, CTAG_PILGRIM=2))

/datum/antagonist/vampire/lords_spawn/equip()
	. = ..()
	owner.forget_and_be_forgotten()
	for(var/datum/mind/found_mind in get_minds("Vampire Spawn"))
		owner.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Death Knight"))
		owner.share_identities(found_mind)

	owner.current.adjust_skillrank(/datum/skill/magic/blood, 2, TRUE)

/datum/antagonist/vampire/lords_spawn/greet()
	to_chat(owner.current, span_userdanger("We are awakened from our slumber, Spawn of the feared Vampire Lord."))
	. = ..()

/datum/antagonist/vampire/lords_spawn/move_to_spawnpoint()
	if(SSmapping.config.map_name != "Voyage")
		owner.current.forceMove(pick(GLOB.vspawn_starts))

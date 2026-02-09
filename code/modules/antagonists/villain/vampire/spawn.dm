/datum/antagonist/vampire/lords_spawn
	name = "Vampire Spawn"
	antag_hud_name = "vampspawn"
	confess_lines = list(
		"THE CRIMSON MASTER CALLS!",
		"MY MASTER COMMANDS!",
		"THE SUN IS THE ANATHEMA OF OUR MASTER!",
	)

/datum/antagonist/vampire/lords_spawn/on_gain()
	. = ..()

	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, spawn_pick_class), "[type]"), 5 SECONDS)

/mob/living/carbon/human/proc/spawn_pick_class()
	//! TODO: This should just be an advclass spawn
	var/list/classoptions = list("Bard", "Fisher", "Hunter", "Miner", "Peasant", "Carpenter", "Cheesemaker", "Blacksmith", "Carpenter", "Thief", "Treasure Hunter", "Mage")
	var/list/visoptions = list()

	for(var/T in 1 to 5)
		var/picked = pick_n_take(classoptions)
		visoptions |= picked

	var/selected = input(src, "Which class was I?", "VAMPIRE SPAWN") as anything in visoptions

	for(var/datum/job/advclass/A in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		if(A.title == selected)
			equipOutfit(A.outfit)
			break

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
	owner.current.forceMove(pick(GLOB.vspawn_starts))

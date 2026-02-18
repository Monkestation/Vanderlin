/datum/antagonist/vampire/lord
	name = "Vampire Lord"
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "vamplord"
	confess_lines = list(
		"I AM ANCIENT!",
		"I AM THE LAND!",
		"FIRSTBORNE CHILD OF KAIN!",
	)

	var/ascended = FALSE

/datum/antagonist/vampire/lord/on_gain()
	var/mob/living/carbon/human/vampire = owner?.current
	if(SSmapping.config.map_name != "Voyage")
		remove_job()
		vampire.delete_equipment()
		vampire.reset_and_reroll_stats()
		vampire.purge_combat_knowledge()
		vampire.remove_all_traits()
	. = ..()
	if(SSmapping.config.map_name != "Voyage")
		addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "[name]"), 5 SECONDS)
	vampire.grant_undead_eyes()

/datum/antagonist/vampire/proc/get_thralls()
	if(!clan_selected)
		addtimer(CALLBACK(src, PROC_REF(get_thralls)), 2 SECONDS)
		return

	var/list/restricted_roles = typecacheof(list(
		/datum/job/lord,
		/datum/job/consort,
		/datum/job/priest,
		/datum/job/hand,
		/datum/job/captain,
		/datum/job/prince,
		/datum/job/inquisitor,
		/datum/job/absolver,
		/datum/job/orthodoxist,
		/datum/job/adept,
		/datum/job/forestwarden,
		/datum/job/royalknight,
		/datum/job/templar,
		/datum/job/monk,
		/datum/job/churchling,
	))

	var/list/candidates = SSgamemode.get_candidates(ROLE_NBEAST, ROLE_NBEAST, living_players = TRUE, no_antags = TRUE, restricted_roles = restricted_roles)
	var/thralls = rand(2, 3)

	candidates -= owner.current

	if(!length(candidates))
		return

	for(var/i = 1 to thralls)
		var/mob/living/carbon/human/human = pick_n_take(candidates)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(owner.current.clan, TRUE)
		human?.mind.add_antag_datum(new_antag)
		human.adjust_bloodpool(500)

/datum/antagonist/vampire/lord/greet()
	to_chat(owner.current, span_userdanger("I am ancient. I am the Land. And I am now awoken to trespassers upon my domain."))
	. = ..()

/datum/antagonist/vampire/lord/equip()
	. = ..()

	owner.forget_and_be_forgotten()
	for(var/datum/mind/found_mind in get_minds("Vampire Spawn"))
		owner.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Death Knight"))
		owner.share_identities(found_mind)

	var/mob/living/carbon/human/source_mob = owner.current
	source_mob.equipOutfit(/datum/outfit/vamplord)
	source_mob.set_patron(/datum/patron/godless/autotheist)

	return TRUE

/datum/antagonist/vampire/lord/move_to_spawnpoint()
	if(SSmapping.config.map_name != "Voyage")
		owner.current.forceMove(pick(GLOB.vlord_starts))

/datum/outfit/vamplord/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/magic/blood, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 4, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	pants = /obj/item/clothing/pants/tights/colored/black
	shirt = /obj/item/clothing/shirt/vampire
	belt = /obj/item/storage/belt/leather/plaquegold
	head  = /obj/item/clothing/head/vampire
	beltl = /obj/item/key/vampire
	beltr = /obj/item/storage/belt/pouch/coins/veryrich
	cloak = /obj/item/clothing/cloak/cape/puritan
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel/black
	if(!(HAS_TRAIT(H, TRAIT_FOREIGNER)))
		ADD_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
/*------VERBS-----*/

// NEW VERBS
/mob/living/carbon/human/proc/demand_submission()
	set name = "Demand Submission"
	set category = "RoleUnique.Vampire"
	if(SSmapping.retainer.king_submitted)
		to_chat(src, span_warning("I am already the Master of [SSmapping.config.map_name]."))
		return

	var/mob/living/carbon/ruler = SSticker.rulermob

	if(!ruler || (get_dist(src, ruler) > 1))
		to_chat(src, span_warning("The Master of [SSmapping.config.map_name] is not beside me."))
		return

	if(ruler.stat <= CONSCIOUS)
		to_chat(src, span_warning("[ruler] is still conscious."))
		return

	switch(alert(ruler, "Submit and Pledge Allegiance to [name]?", "SUBMISSION", "Yes", "No"))
		if("Yes")
			SSmapping.retainer.king_submitted = TRUE
		if("No")
			to_chat(ruler, span_boldnotice("I refuse!"))
			to_chat(src, span_boldnotice("[p_they(TRUE)] refuse[ruler.p_s()]!"))

/mob/living/carbon/human/proc/punish_spawn()
	set name = "Punish Minion"
	set category = "RoleUnique.Vampire"

	var/list/possible = list()
	for(var/mob/living/carbon/human/member in clan?.clan_members)
		if(member.stat != DEAD && member != src)
			var/datum/mind/V = member.mind
			possible[V.current.real_name] = V.current
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		possible[D.current.real_name] = D.current
	var/name_choice = browser_input_list(src, "Who to punish?", "PUNISHMENT", possible)
	if(!name_choice)
		return
	var/mob/living/carbon/human/choice = possible[name_choice]
	if(!choice || QDELETED(choice))
		return
	var/punishmentlevels = list("Pause", "Pain", "DESTROY")
	var/punishment = browser_input_list(src, "Select punishment severity.", "PUNISHMENT", punishmentlevels)
	if(!punishment)
		return
	switch(punishment)
		if("Pain")
			to_chat(choice, span_boldnotice("You are wracked with pain as your master punishes you!"))
			choice.apply_damage(30, BRUTE)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("Pause")
			to_chat(choice, span_boldnotice("Your body is frozen in place as your master punishes you!"))
			choice.Paralyze(300)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("DESTROY")
			to_chat(choice, span_boldnotice("You feel only darkness. Your master no longer has use of you."))
			addtimer(CALLBACK(choice, TYPE_PROC_REF(/mob/living, dust)), 10 SECONDS)
	visible_message(span_danger("[src] reaches out, gripping [choice]'s soul, inflicting punishment!"), ignored_mobs = list(choice))

/mob/proc/death_knight_spawn()
	SEND_SOUND(src, sound('sound/misc/notice (2).ogg'))
	if(alert(src, "A Vampire Lord is summoning you from the Underworld.", "Be Risen?", "Yes", "No") == "Yes")
		if(!has_world_trait(/datum/world_trait/death_knight))
			to_chat(src, span_warning("Another soul was chosen."))
		returntolobby()

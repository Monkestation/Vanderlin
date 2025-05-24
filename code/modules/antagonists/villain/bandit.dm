
/datum/antagonist/bandit
	name = "Bandit"
	roundend_category = "bandits"
	antagpanel_category = "Bandit"
	job_rank = ROLE_BANDIT
	antag_hud_type = ANTAG_HUD_BANDIT
	antag_hud_name = "bandit"
	var/tri_amt
	var/contrib
	confess_lines = list("FREEDOM!!!", "I WILL NOT LIVE IN YOUR WALLS!", "I WILL NOT FOLLOW YOUR RULES!")

	innate_traits = list(
		TRAIT_BANDITCAMP,
		TRAIT_SEEPRICES,
		TRAIT_STEELHEARTED,
		TRAIT_VILLAIN,
	)

/datum/antagonist/bandit/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/bandit))
		return "<span class='boldnotice'>Another free man. My ally.</span>"

/datum/antagonist/bandit/on_gain()
	owner.special_role = "Bandit"
	owner.purge_combat_knowledge()
	move_to_spawnpoint()
	owner.current.roll_mob_stats()
	forge_objectives()
	. = ..()
	finalize_bandit()
	equip_bandit()

/datum/antagonist/bandit/proc/finalize_bandit()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/traitor.ogg', 80, FALSE, pressure_affected = FALSE)
	var/mob/living/carbon/human/H = owner.current
	H.set_patron(/datum/patron/inhumen/matthios)

/datum/antagonist/bandit/greet()
	to_chat(owner.current, "<span class='alertsyndie'>I am a BANDIT!</span>")
	to_chat(owner.current, "<span class='info'>Long ago I did a crime worthy of my bounty being hung on the wall outside of the local inn.</span>")
	owner.announce_objectives()
	..()

/datum/antagonist/bandit/proc/forge_objectives()
	return

/proc/isbandit(mob/living/M)
	return istype(M) && M.mind && M.mind.has_antag_datum(/datum/antagonist/bandit)

/datum/antagonist/bandit/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.bandit_starts))

/datum/antagonist/bandit/proc/equip_bandit()

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Bandit"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	return TRUE

/datum/antagonist/bandit/roundend_report()
	if(owner?.current)
		var/amt = tri_amt
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
		if(!amt)
			to_chat(world, "[the_name] was a bandit.")
		else
			to_chat(world, "[the_name] was a bandit. He stole [amt] triumphs worth of loot.")
	return

/*	.................   Unique Bandit recipes   ................... */
/datum/crafting_recipe/bandit_volfhelm
	name = "(Bandit) Volfhelm"
	time = 4 SECONDS
	reqs = list(/obj/item/natural/fur/volf = 2)
	result = /obj/item/clothing/head/helmet/leather/volfhelm
	category = CAT_NONE
	always_availible = FALSE

/datum/crafting_recipe/cult_hood
	name = "(Cult) Ominous Hood"
	time = 4 SECONDS
	reqs = list(/obj/item/natural/hide = 1)
	result = /obj/item/clothing/head/helmet/leather/hood_ominous
	category = CAT_NONE
	always_availible = FALSE


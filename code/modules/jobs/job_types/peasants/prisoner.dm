/datum/job/prisoner
	title = "Prisoner"
	tutorial = "For a crime, or false allegation; as a hostage against another, \
	or held for ransom: your fate until this day has been ill-starred save its first. \
	You are of noble birth. Perhaps your story, which none but you recall, \
	will move some pity from callous hearts or promises of riches parole your release. \
	Maybe your old associates conspire now to release you in a daring rescue. \
	Yet it is far surer that your tears will rust this cursed mask \
	than the sun shine upon your face a freed soul once more." // changed to reduce dictation of character. Nikov.
	department_flag = PEASANTS
	display_order = JDO_PRISONER
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 2
	can_random = FALSE
	banned_leprosy = FALSE
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_FOREIGNNOBLE

	outfit = /datum/outfit/prisoner
	give_bank_account = 173

	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'
	can_have_apprentices = FALSE

/datum/outfit/prisoner/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	mask = /obj/item/clothing/face/facemask/prisoner
	if(H.wear_mask)
		var/obj/I = H.wear_mask
		H.dropItemToGround(H.wear_mask, TRUE)
		qdel(I)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE) // given Noble trait. N.
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE) // given Noble trait. N.
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE) // per suggestion. N.
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE) // given Noble trait it makes no sense they were illiterate. N.
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE) // per suggestion. N.
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_STR, -1) // Malnutrition. N.
	H.change_stat(STATKEY_PER, 2) // Few distractions, idle mind, focused senses. N.
	H.change_stat(STATKEY_INT, 2) // Given Noble trait it makes no sense they are idiots. N.
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_END, -1)
	var/datum/antagonist/new_antag = new /datum/antagonist/prisoner()
	H.mind?.add_antag_datum(new_antag)
	ADD_TRAIT(H, TRAIT_BANDITCAMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

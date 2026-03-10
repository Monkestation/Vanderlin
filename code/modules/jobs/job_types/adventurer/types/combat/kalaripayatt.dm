/datum/job/advclass/combat/kalaripayatt
	title = "Kalaripayatt"
	allowed_races = list(
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_ELF,\
		SPEC_ID_DWARF,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_HOLLOWKIN,\
		SPEC_ID_HALFLING,\
		SPEC_ID_TIEFLING,\
	)
	allowed_patrons = ALL_TEMPLE_PATRONS // I dont think the inhumen pantheon would appreciate the nuance of dance.
	tutorial = "Hailing from one of many Faience's classical dance companies in the Southeast; Kalaripayatt's are skilled dancers trained in martial arts, dedicated to celebrating the natural wonders of the vigorous body. Fighting with a grace unseen in many other combatants." //shout out to hembrent for helping me write this!
	total_positions = 4
	outfit = /datum/outfit/adventurer/kalaripayatt
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT,)
	allowed_patrons = ALL_TEMPLE_PATRONS  // randomize patron if not in ten

	skills = list(
		/datum/skill/misc/reading = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/craft/sewing = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/music = 2, // they wont spawn with instruments though.
	)

	jobstats = list(
		STATKEY_CON = -2, //they arent meant to get hit.
		STATKEY_END = 2,
		STATKEY_SPD = 1,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
	)

/datum/job/advclass/combat/kalaripayatt/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectable = list(
		"Kukri (Knife)" = /obj/item/weapon/knife/hunting/kukri/iron,
		"Whip (Urumi)" = /obj/item/weapon/whip/urumi/iron,
		"Sword (Wo Dao)" = /obj/item/weapon/sword/scimitar/wodao/iron,
		"Mace (Shishpar)" = /obj/item/weapon/mace/shishpar
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "What do you dance with?")
	if(!choice)
		return

	switch(choice)
		if("Mace (Shishpar)")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		if("Sword (Wo Dao)")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		if("Kukri (Knife)")
			spawned.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		if("Whip (Urumi)")
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)

/datum/outfit/adventurer/kalaripayatt
	name = "Kalaripayatt (Adventurer)"
	ring = /obj/item/clothing/ring/shell
	wrists = /obj/item/clothing/wrists/gem/shellbracelet
	mask = /obj/item/clothing/face/facemask/goldnosechain
	neck = /obj/item/clothing/neck/psycross/pearl
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor,
	)
/datum/outfit/adventurer/kalaripayatt/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(equipped_human.gender == FEMALE) //female dancers typically wear more jewelery compared to men in indian classical dance.
		head = /obj/item/clothing/head/crown/circlet/dancer
		shirt = /obj/item/clothing/shirt/dress/gown/saree/colored/dancer
		pants = /obj/item/clothing/pants/tights/colored/white

	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/dhoti/colored/dancer
		shirt = /obj/item/clothing/shirt/undershirt/sash/colored/green

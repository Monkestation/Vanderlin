/datum/migrant_role/dark_itinerant_knight
	name = "Drow Knight"
	greet_text = "You are an evil itinerant Knight, you have embarked alongside your squire on a voyage to engulf chaos within these lands."
	migrant_job = /datum/job/migrant/dark_itinerant_knight

/datum/job/migrant/dark_itinerant_knight
	title = "Zizo Knight"
	tutorial = "You are the last holdout of the Dark Lady's name in Wintermare. The others have perished. Is it cowardice that has saved your company, or wits?\
	\n\
	It hardly matters anymore. The <span class='briar'>briars</span> bind you here like the other filth. Her voice has grown silent. It is up to you to survive."
	outfit = /datum/outfit/dark_itinerant_knight
	antag_role = /datum/antagonist/zizocultist/leader
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW)
	job_flags = (JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS)
	selection_color = JCOLOR_NOBLE
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	faction = list(FACTION_UNDEAD, FACTION_CABAL)
	department_flag = UNDEAD
	spawn_positions = 1
	total_positions = 0
	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/labor/mathematics = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/swimming = 3,
	)

	traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_BREADY)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

/datum/outfit/dark_itinerant_knight
	name = "Zizo Knight"
	head = /obj/item/clothing/head/helmet/heavy/zizo
	mask = /obj/item/clothing/face/shepherd/shadowmask
	gloves = /obj/item/clothing/gloves/plate/zizo
	pants = /obj/item/clothing/pants/platelegs/zizo
	shirt = /obj/item/clothing/shirt/shadowshirt
	cloak = /obj/item/clothing/cloak/half/shadowcloak/cult
	armor = /obj/item/clothing/armor/plate/full/zizo
	shoes = /obj/item/clothing/shoes/boots/armor/zizo
	neck = /obj/item/clothing/neck/chaincoif
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/whip/spiderwhip
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/weapon/sword/long/greatsword/zizo
	wrists = /obj/item/clothing/neck/psycross/zizo
	ring = /obj/item/clothing/ring/collar_detonator
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/dirk = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1)

/datum/outfit/dark_itinerant_knight/equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	H.underwear = "Femleotard"
	H.underwear_color = COLOR_SILVER

/datum/migrant_role/dark_itinerant_squire
	name = "Underling Squire"
	greet_text = "You are the squire of an evil knight, they have taken you under their custody as you were the only one who didn't object to their dubious ethics."
	migrant_job = /datum/job/migrant/dark_itinerant_squire

/datum/job/migrant/dark_itinerant_squire
	title = "Zizo Remnant"
	tutorial = "The Remnants of Zizo's military force. You fled due to your injuries in the battle, only to return to ash and despair, but not only of the enemies.\
	\nAll you served beside are now gone or worse and all you served against share a similar fate. The Tundra is silent with nothing but an eerie wind, will you fall silent next, or will you survive among the ashes?"
	outfit = /datum/outfit/zizo_remnant
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_DROW, SPEC_ID_HALF_DROW)
	allowed_ages = list(AGE_ADULT)
	department_flag = UNDEAD
	selection_color = JCOLOR_NOBLE
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	spawn_positions = 2
	total_positions = 0
	job_flags = (JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS)
	faction = list(FACTION_UNDEAD, FACTION_CABAL)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_END = 1,
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 2,
	)
	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE
	shows_in_list = FALSE
	can_have_apprentices = FALSE
	antag_role = /datum/antagonist/zizocultist/zizo_knight


	traits = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_DUALWIELDER)
	languages = list(/datum/language/undead)
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

/datum/job/migrant/dark_itinerant_squire/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.verbs |= /mob/living/carbon/human/proc/torture_victim

/datum/outfit/dark_itinerant_squire
	name = "Underling Squire"
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/bolts
	armor = /obj/item/clothing/armor/leather/splint
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	neck = /obj/item/clothing/neck/psycross/zizo

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
	)

/datum/outfit/zizo_remnant
	name = "Zizo Remnant"
	mask = /obj/item/clothing/face/shepherd/shadowmask
	neck = /obj/item/clothing/neck/highcollier
	backr = /obj/item/clothing/cloak/half/shadowcloak/cult
	cloak = /obj/item/clothing/shirt/undershirt/sash/colored/purple
	shoes = /obj/item/clothing/shoes/courtphysician/female
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/platelegs/blk/event
	backl = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/neck/psycross/zizo
	armor = /obj/item/clothing/armor/cuirass/iron/shadowplate
	gloves = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
	beltl = /obj/item/weapon/sword/sabre/stalker
	beltr = /obj/item/weapon/sword/sabre/stalker
	ring = /obj/item/clothing/ring/collar_detonator
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/dirk,
		/obj/item/weapon/whip/spiderwhip,
		/obj/item/reagent_containers/food/snacks/hardtack
	)

/datum/outfit/zizo_remnant/equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	H.underwear = "Femleotard"
	H.underwear_color = COLOR_SILVER

/datum/job/zizo_slave
	title = "Zizo Slave"
	tutorial = "The whipped infantry of Zizo's military. The only reason you are granted the skin which clings to your bone is that it is less convenient to remove it. \
		\n\
		You watched as your mistresses stood in horror, you watched as those above you stained the pale white snow a sanguine red, and you followed as your remaining masters fled.\
		\n\
		Despite the dire situation you still answer to them, for they have gone from your greatest threat to your only hope."
	outfit = /datum/outfit/zizo_slave
	allowed_races = list(SPEC_ID_DROW, SPEC_ID_HALF_DROW)
	allowed_ages = list(AGE_CHILD, AGE_ADULT, AGE_MIDDLEAGED)
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	spawn_positions = 4
	total_positions = 0
	job_flags = (JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS)
	faction = list(FACTION_UNDEAD, FACTION_CABAL)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_END = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = -1,
	)

	skills = list(
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/sneaking = 3,
	)
	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE
	shows_in_list = FALSE
	can_have_apprentices = FALSE
	selection_color = JCOLOR_NOBLE
	department_flag = UNDEAD

	traits = list(TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'

/datum/job/zizo_slave/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats)
	. = ..()

	var/static/list/selectable = list( \
		"Conscript" = /obj/item/weapon/mace/bludgeon/copper, \
		"Sapper" = /obj/item/restraints/legcuffs/beartrap, \
		"Chirurgeon" = /obj/item/weapon/knife/cleaver, \
	)
	var/choice = spawned.select_equippable(player_client, selectable, message = "HOW DO YOU SERVE HER WILL?", title = "SLAVE")
	if(!choice)
		return
	switch(choice)
		if("Conscript")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/bows, 3, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)
		if("Sapper")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/hammer/copper, ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/axe/iron, ITEM_SLOT_BELT_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/labor/lumberjacking, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/labor/mathematics, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/armorsmithing, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/blacksmithing, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/crafting, 2, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/carpentry, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/masonry, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/traps, 2, 1, 3, TRUE)
		if("Chirurgeon")
			spawned.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/surgbag/shit, ITEM_SLOT_BACK_R, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/combat/knives, 3, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/misc/medicine, 2, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/misc/sewing, 2, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/labor/butchering, 1, 3, TRUE)
			spawned.clamped_adjust_skillrank(/datum/skill/craft/cooking, 2, 3, TRUE)


/datum/outfit/zizo_slave
	name = "Zizo Slave"
	head = /obj/item/clothing/head/roguehood/colored/black
	neck = /obj/item/clothing/neck/gorget/explosive/zizo
	shirt = /obj/item/clothing/shirt/undershirt/lowcut/zizo
	shoes = /obj/item/clothing/shoes/gladiator
	belt = /obj/item/storage/belt/leather/rope
	pants = /obj/item/clothing/pants/loincloth/colored/black
	backl = /obj/item/storage/backpack/satchel/cloth
	wrists = /obj/item/clothing/neck/psycross/zizo
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/stale_bread
	)

/datum/migrant_wave/evil_knight
	name = "The Unknightly journey"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/evil_knight
	downgrade_wave = /datum/migrant_wave/evil_knight_down
	weight = 8
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
		/datum/migrant_role/dark_itinerant_squire = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."

/datum/migrant_wave/evil_knight_down
	name = "The Unknightly journey"
	shared_wave_type = /datum/migrant_wave/evil_knight
	can_roll = FALSE
	weight = 35
	roles = list(
		/datum/migrant_role/dark_itinerant_knight = 1,
	)
	greet_text = "These lands have insulted once more Zizo, you are here to remind them of her prowess."

/datum/job/forestguard
	title = "Forest Guard"
	tutorial = "You've been keeping the streets clean of neer-do-wells and taffers for most of your time in the garrison.\
	You've been through the wringer - alongside soldiers in the short-lived Goblin Wars. \
	The Wars were rough, the few who survived came back changed. Perhaps you'd agree. \
	\
	\n\n\
	A fellow soldier had been given the title of Forest Warden for their valorant efforts \
	and they've plucked you from one dangerous position into another. \
	Atleast with your battle-family by your side, you will never die alone."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_FORGUARD
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	min_pq = 5
	bypass_lastclass = TRUE
	selection_color = "#0d6929"

	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL, AGE_CHILD)
	allowed_races = RACES_PLAYER_GUARD
	blacklisted_species = list(SPEC_ID_HALFLING)
	give_bank_account = 30
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'

	outfit = /datum/outfit/forestguard
	advclass_cat_rolls = list(CTAG_FORGARRISON = 20)

	job_bitflag = BITFLAG_GARRISON

/datum/outfit/forestguard/pre_equip(mob/living/carbon/human/H)
	..()
	if(SSmapping.config.map_name == "Rosewood")
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
	else
		cloak = /obj/item/clothing/cloak/forrestercloak
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/fgarrison
	backl = /obj/item/storage/backpack/satchel
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

/datum/job/forestguard/after_spawn(mob/living/carbon/spawned, client/player_client)
	..()

// Ravager, whips, flails, axes and swords and shields.
/datum/job/advclass/forestguard/infantry
	title = "Forest Ravager"
	tutorial = "In the goblin wars- you alone were deployed to the front lines, caving skulls and chopping legs - saving your family-at-arms through your reckless diversions. \ With your bloodied axe and flail, every swing and crack was another hatch on your tally. Now that the War's over, even with your indomitable spirit and tireless zeal - let's see if that still rings true."
	outfit = /datum/outfit/forestguard/infantry
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)

/datum/outfit/forestguard/infantry/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	beltl = /obj/item/weapon/flail/militia
	beltr = /obj/item/weapon/axe/iron
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/weapon/shield/heater
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell


	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE) //given to every class so they can atleast repair their armor.
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_SPD, -1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC) //removed crit resistance to bring in line with reaver losing nopain, it doesn't do the most anyway, certainly not needed with more armor.

// Ranger, bows and knives
/datum/job/advclass/forestguard/ranger
	title = "Forest Ranger"
	tutorial = "In the Wars you were always one of the fastest, aswell as one of the frailest in the platoon. \ Your trusty bow has served you well- of course, none you've set your sights on have found the tongue to disagree."
	outfit = /datum/outfit/forestguard/ranger
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)

/datum/outfit/forestguard/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/highcollier
	shirt = /obj/item/clothing/armor/gambeson // rest of them get hauberks, can learn to make padded gambesons if you want more.
	beltl = /obj/item/weapon/knife/cleaver/combat
	beltr = /obj/item/ammo_holder/quiver/arrows
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.change_stat(STATKEY_STR, -3)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_PER, 3) //One more perception in exchange for 1 less str and no medium armor trait, embrace the glass cannon.
		H.change_stat(STATKEY_SPD, 3)
		ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)

// Reaver, Axes and Maces
/datum/job/advclass/forestguard/reaver
	title = "Forest Reaver"
	tutorial = "In the Wars you took an oath to never shy from a hit. Axe in hand, thirsting for blood, you simply enjoy the <i>chaos of battle...</i>"
	outfit = /datum/outfit/forestguard/reaver
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)

/datum/outfit/forestguard/reaver/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	beltl = /obj/item/weapon/mace/steel/morningstar
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	beltr = /obj/item/weapon/axe/iron
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/pouch/coins/poor)
	H.verbs |= /mob/proc/haltyell
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)

		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_SPD, 1)
		ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC) //Nopainstun was pretty insane, definitely too much while spawning with a hauberk, this should keep their vibe of angry guy that keeps running at you.
		ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)

// Hand to Hand
/datum/job/advclass/forestguard/brawler
	title = "Forest Brawler"
	tutorial = "In the goblin wars you took an oath to never wield a weapon, you just enjoy getting your hands dirty too much..."
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	jobstats = list(
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 3,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/labor/lumberjacking = 3,
		/datum/skill/craft/carpentry = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/tanning = 1,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/axesmaces = 1,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_FORAGER,
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
	outfit = /datum/outfit/forestguard/brawler

/datum/job/advclass/forestguard/brawler/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.verbs |= /mob/proc/haltyell

/datum/outfit/forestguard/brawler
	name = "Forest Brawler"
	head = /obj/item/clothing/head/helmet/medium/decorated/skullmet
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/leather/advanced/forrester
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	beltr = /obj/item/weapon/axe/iron
	beltl = /obj/item/weapon/knife/hunting
	backpack_contents = list(/obj/item/clothing/gloves/bandages/pugilist = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/pouch/coins/poor)
	scabbards = list(/obj/item/weapon/scabbard/knife)

// Ruffian, knives, bows and a lot of cooking.
/datum/job/advclass/forestguard/ruffian
	title = "Forest Ruffian"
	tutorial = "For your terrible orphan pranks and antics in the city, you were rounded up by the city's Watch and put to work in the infamous forest garrison. \n\n A ruffian by circumstance, a proven listener of war stories - you might just become more than a troublemaker."
	outfit = /datum/outfit/forestguard/ruffian
	category_tags = list(CTAG_FORGARRISON)
	allowed_ages = list(AGE_CHILD)


/datum/outfit/forestguard/ruffian/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/medium/decorated/rousskullmet //placeholder, I have to sprite something new for the Brats, like a gator skull
	neck = /obj/item/clothing/neck/highcollier
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	beltl = /obj/item/weapon/knife/dagger //just a normal iron dagger
	beltr = /obj/item/ammo_holder/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow //placeholder, going to give them a slingshot in another PR later
	armor = /obj/item/clothing/armor/leather
	backpack_contents = list(/obj/item/weapon/knife/hunting = 1, /obj/item/cooking/pan = 1, /obj/item/reagent_containers/food/snacks/egg = 1)
	H.verbs |= /mob/proc/haltyellorphan //pitch shifted for the lols

	if(H.mind) //if you want your ruffians to have combat skills, take them up as apprentices
		//otherwise, mix of orphan and ranger skills, with some labour skills to imply housework
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE) //considering master climbing, I can make another youngling subclass for such
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE) //weak fuck
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
		H.change_stat(STATKEY_STR, rand(-1,1)) //broadly conscripted street urchins, randomization keeps them from being too powerful/consistent. Moved to -1 so they can actually cut wood
		H.change_stat(STATKEY_INT, round(rand(-2,2)))
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_CON, rand(-1,1))
		H.change_stat(STATKEY_END, rand(-1,1))
		H.change_stat(STATKEY_LCK, rand(-4,4))//either really lucky or unlucky, like orphans
		ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_ORPHAN, TRAIT_GENERIC) //someone please abuse this
		ADD_TRAIT(H, TRAIT_BRUSHWALK, TRAIT_GENERIC)

/mob/proc/haltyellorphan()
	set name = "HALT!"
	set category = "Noises"
	emote("haltyellorphan")

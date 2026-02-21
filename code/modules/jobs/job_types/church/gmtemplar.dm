/datum/job/gmtemplar
	title = "Grandmaster Templar"
	tutorial = "At the upper echelon of the Templaric order sit the Grandmasters, five who sit in the Head in Kingsfield, and one appointed to each sanctified Tennite Church across the realm.\
	They are masters of Ravox's arts and beholden to no will except Justice and Astrata, the latter of which they know the overbearing presence of all too well. \
	Despite her cruel authority, the Ravoxian Grandmasters of the Order dare not rise up against the Astratan priests and their sect of guardians at the Head of the Order, lest they be excommunicated."
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_GMTEMPLAR
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_patrons = list(/datum/patron/divine/ravox)

	outfit = /datum/outfit/gmtemplar
	give_bank_account = 0

	job_bitflag = BITFLAG_CHURCH

	exp_type = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_COMBAT, EXP_TYPE_CLERIC, EXP_TYPE_LEADERSHIP)
	exp_requirements = list(
		EXP_TYPE_CHURCH = 900,
		EXP_TYPE_COMBAT = 900
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 4,
		STATKEY_END = 2,
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/swords = 4, // Its easier just to give them all three, it'd be a pain to try and manage this in the ult component
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 2,
		/datum/skill/magic/holy = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 2
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_KNOWBANDITS
	)

	languages = list(/datum/language/celestial)


/datum/job/gmtemplar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(spawned)

	var/static/list/selectableweapon = list(
		"Longsword" = /obj/item/weapon/sword/long/grandmaster,
		"Spear" = /obj/item/weapon/polearm/spear/grandmaster,
		"Axe" = /obj/item/weapon/greataxe/steel/grandmaster,
		"Mace" = /obj/item/weapon/mace/goden/steel/grandmaster,
	)

	spawned.select_equippable(player_client, selectableweapon, message = "Choose thy blade", title = "GRANDMASTER")

	var/static/list/selectablehelm = list(
		"Armet" = /obj/item/clothing/head/helmet/visored/silver/armet,
		"Bascinet" = /obj/item/clothing/head/helmet/visored/silver,
	)

	spawned.select_equippable(player_client, selectablehelm, message = "Choose thy helm", title = "GRANDMASTER")

	var/static/list/selectablecloak = list(
		"Cloak" = /obj/item/clothing/cloak/pantheon,
		"Tabard" = /obj/item/clothing/cloak/templar/undivided,
		"Jupon" = /obj/item/clothing/cloak/silktabard
	)

	spawned.select_equippable(player_client, selectablecloak, message = "Choose thy overcoat", title = "GRANDMASTER")

/datum/outfit/gmtemplar
	name = "Grandmaster Templar"
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/armor/plate/full/silver
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/platelegs/silver
	shoes = /obj/item/clothing/shoes/boots/armor/silver
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/keyring/priest = 1,  /obj/item/storage/belt/pouch/coins/rich = 1)
	belt = /obj/item/storage/belt/leather/black
	ring = /obj/item/clothing/ring/silver/rontz
	gloves = /obj/item/clothing/gloves/plate/silver
	wrists = /obj/item/clothing/neck/psycross/silver/ravox







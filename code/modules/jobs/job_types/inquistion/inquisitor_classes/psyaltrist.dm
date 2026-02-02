/datum/job/advclass/sacrestant/psyaltrist
	title = "Psyaltrist"
	tutorial = "Every inquisitor has their second. You aim to keep spirits and faith high, while handling the needs of the inquisitor. Not a glamorous role, but a vital one. “Maybe his lordship would prefer the lute, today, over the viola?”"
	category_tags = list(CTAG_INQUISITION)
	outfit = /datum/outfit/psyaltrist

	jobstats = list(
		STATKEY_END = 1,
		STATKEY_SPD = 3,
	) //4 Statline

	skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)

	languages = list(
		/datum/language/elvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/orcish
	)

	traits = list(	TRAIT_DODGEEXPERT,
		TRAIT_EMPATH,
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
		TRAIT_FOREIGNER,
		)

	spells = list(/datum/action/cooldown/spell/vicious_mockery)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

/datum/job/advclass/sacrestant/psyaltrist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", 0, "Psyaltrist")

	spawned.inspiration = new /datum/inspiration(spawned)

	var/static/list/instruments = list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola,
		"Vocal Talisman" = /obj/item/instrument/vocals,
		"Psyaltery" = /obj/item/instrument/psyaltery,
		"Flute" = /obj/item/instrument/flute,
	)

	spawned.select_equippable(player_client, instruments)

/datum/outfit/psyaltrist
	name = "Psyaltrist (Sacrestants)"
	armor = /obj/item/clothing/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/satchel/otavan
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/leather/otavan
	wrists = /obj/item/clothing/neck/psycross/silver
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/psydonboots
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltr = /obj/item/weapon/knife/dagger/silver/psydon
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/key/inquisition = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/collar_detonator = 1,
	)

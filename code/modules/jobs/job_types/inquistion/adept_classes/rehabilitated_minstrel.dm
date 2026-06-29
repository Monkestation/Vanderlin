/datum/attribute_holder/sheet/job/psyaltrist
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		STAT_SPEED = 3,
		/datum/attribute/skill/misc/music = 50,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 20
	)

/datum/job/advclass/adept/psyaltrist
	title = "Rehabilitated Minstrel"
	tutorial = "Bards make up one of the largest populations of registered adventurers in Vanderlin, mostly because they are the last ones in a party to die. \
	When word got out that you had abandoned your former party to their demise, it didn't take long before you were cast out, unwelcome. \
	You may no longer be as free as you once were, but through the generous gift of mercy bestowed upon you by the Inquisitor, perhaps you may once again put your skills to use."
	category_tags = list(CTAG_ADEPT)
	outfit = /datum/outfit/psyaltrist

	attribute_sheet = /datum/attribute_holder/sheet/job/psyaltrist

	languages = list(
		/datum/language/elvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/orcish
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_EMPATH,
		TRAIT_INQUISITION,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)

	spells = list(/datum/action/cooldown/spell/projectile/vicious_mockery)


/datum/job/advclass/adept/psyaltrist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", 0, "Psyaltrist")
	spawned.grant_inspiration()

/datum/job/advclass/adept/psyaltrist/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
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
	name = "Psyaltrist (Adept)"
	armor = /obj/item/clothing/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/satchel/otavan
	neck = /obj/item/clothing/neck/gorget/explosive
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/leather/otavan
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/psydonboots
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltr = /obj/item/weapon/knife/dagger/silver/psydon
	beltl = /obj/item/storage/belt/pouch/coins/mid
	backpack_contents = list(
		/obj/item/storage/keyring/adept = 1,
	)

/datum/attribute_holder/sheet/job/occult
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/magic/blood = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 20
	)

/datum/job/advclass/combat/occult
	title = "Occult Librarian"
	tutorial = "Professionally a historian and researcher of the arts of magic and ancient mysteries, you found a forgotten book you were never meant to see. \
	Studying from this dark grimoire you learnt the forbidden arts of Blood Magick. \
	It would be best to keep this power to yourself, no others are worthy, you alone deserve this. Open use of Blood Magic would surely see you executed."
	outfit = /datum/outfit/occult
	category_tags = list(CTAG_ADVENTURER)

	attribute_sheet = /datum/attribute_holder/sheet/job/occult
	traits = list(
		TRAIT_BLOOD_STUDENT
	)
	total_positions = 1
	roll_chance = 10

	spells = list(
		/datum/action/cooldown/spell/dark_whispers,
		/datum/action/cooldown/spell/status/blood_sight,
		/datum/action/cooldown/spell/projectile/blood_steal,
		/datum/action/cooldown/spell/diagnose/blood,
		/datum/action/cooldown/spell/blood_healing,
	)
	book_type = /obj/item/recipe_book/arcyne
	antag_job = TRUE
	antag_role = /datum/antagonist/blood_mage/occult

/datum/job/advclass/combat/occult/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.hud_used?.set_bloody_bloodpool()

/datum/outfit/occult
	name = "Occult Librarian (Adventurer)"
	shirt = /obj/item/clothing/shirt/undershirt/puritan
	armor = /obj/item/clothing/armor/leather/jacket/tailcoat
	wrists = /obj/item/weapon/scabbard/knife/hidden/steel_dagger
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/weapon/whip/steel
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/boots/darkboots
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/bloodpot = 1,
		/obj/item/book/magicaltheory = 1,
		/obj/item/recipe_book/arcyne = 1,
		/obj/item/spellbook/adept/starter/blood = 1,
	)

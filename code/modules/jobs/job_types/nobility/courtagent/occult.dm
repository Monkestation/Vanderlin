/datum/attribute_holder/sheet/job/courtagent/occult
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/magic/blood = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 50
	)

/datum/job/advclass/courtagent/occult
	title = "Occult Librarian"
	tutorial = "You are one of the Hand's loyal Agents. \
	Professionally a historian and researcher of the arts of magic and ancient mysteries, you found a forgotten book you were never meant to see. \
	Studying from this dark grimoire you learnt the forbidden arts of Blood Magick. \
	Maybe your colleagues know, maybe they don't. Honesty is your own choice, so long as the church don't find out. Open use of this power would surely see you executed."
	outfit = /datum/outfit/courtagent/occult
	category_tags = list(CTAG_COURTAGENT)
	allowed_patrons = list(/datum/patron/godless/dystheist, /datum/patron/godless/autotheist, /datum/patron/godless/godless, /datum/patron/godless/defiant, /datum/patron/godless/galadros)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/occult
	traits = list(
		TRAIT_BLOOD_STUDENT
	)
	total_positions = 1
	roll_chance = 50

	spells = list(
		/datum/action/cooldown/spell/dark_whispers,
		/datum/action/cooldown/spell/status/blood_sight,
		/datum/action/cooldown/spell/projectile/blood_steal,
		/datum/action/cooldown/spell/diagnose/blood,
		/datum/action/cooldown/spell/blood_healing,
		/datum/action/cooldown/spell/status/blood_choke,
		/datum/action/cooldown/spell/blood_poison,
	)
	book_type = /obj/item/recipe_book/arcyne

/datum/job/advclass/courtagent/occult/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.hud_used?.set_bloody_bloodpool()

/datum/outfit/courtagent/occult
	name = "Occult Librarian (Court Agent)"
	shirt = /obj/item/clothing/shirt/undershirt/puritan
	armor = /obj/item/clothing/armor/leather/jacket/tailcoat
	wrists = /obj/item/weapon/scabbard/knife/hidden/stiletto
	belt = /obj/item/storage/belt/leather/black/courtagent
	beltr = /obj/item/weapon/whip/steel
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/boots/darkboots
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/bloodpot = 1,
		/obj/item/book/magicaltheory = 1,
		/obj/item/recipe_book/arcyne = 1,
		/obj/item/key/archive = 1,
	)

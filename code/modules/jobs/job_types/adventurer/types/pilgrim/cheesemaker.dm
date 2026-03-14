/datum/attribute_holder/sheet/job/pilgrim/cheesemaker
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/labor/taming = 30,
		/datum/attribute/skill/craft/cooking = 40,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/misc/climbing = 10,
	)

/datum/job/advclass/pilgrim/cheesemaker
	title = "Cheesemaker"
	tutorial = "Some say Dendor brings bountiful harvests - this much is true, but rot brings forth life. \
	From life brings decay, and from decay brings life. Like your parents before you, you let milk rot into cheese. \
	This is your duty, this is your call."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/cheesemaker
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Cheesemaker Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/cheesemaker

/datum/job/advclass/pilgrim/cheesemaker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/animal_path = pick(/mob/living/simple_animal/hostile/retaliate/goat, /mob/living/simple_animal/hostile/retaliate/cow)
	var/mob/living/simple_animal/animal = new animal_path(get_turf(spawned))
	animal.tamed(spawned)

/datum/outfit/pilgrim/cheesemaker
	name = "Cheesemaker (Pilgrim)"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	cloak = /obj/item/clothing/cloak/apron
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin/milk
	beltl = /obj/item/weapon/knife/villager
	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/cheddar = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/book/yeoldecookingmanual = 1
	)

/datum/outfit/pilgrim/cheesemaker/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)

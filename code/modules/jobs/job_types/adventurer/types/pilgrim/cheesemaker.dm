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

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_CON = 2
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/taming = 3,
		/datum/skill/craft/cooking = 4,
		/datum/skill/labor/farming = 2,
		/datum/skill/misc/climbing = 1
	)

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

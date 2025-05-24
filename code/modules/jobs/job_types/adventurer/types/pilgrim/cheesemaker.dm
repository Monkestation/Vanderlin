/datum/advclass/pilgrim/cheesemaker
	name = "Cheesemaker"
	tutorial = "Some say Dendor brings bountiful harvests - this much is true, but rot brings forth life. \
	From life brings decay, and from decay brings life. Like your parents before you, you let milk rot into cheese. \
	This is your duty, this is your call."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/adventurer/cheesemaker

	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Cheesemaker Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/advclass/pilgrim/cheesemaker/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/animal_path = pick(/mob/living/simple_animal/hostile/retaliate/goat, /mob/living/simple_animal/hostile/retaliate/cow)
	var/mob/living/simple_animal/animal = new animal_path(get_turf(H))
	animal.tamed(H)

/datum/outfit/job/adventurer/cheesemaker/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/random
	shirt = /obj/item/clothing/shirt/shortshirt/random
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/simpleshoes
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin/milk
	beltl = /obj/item/weapon/knife/villager
	backpack_contents = list(/obj/item/reagent_containers/powder/salt = 3, /obj/item/reagent_containers/food/snacks/cheddar = 1, /obj/item/natural/cloth = 2, /obj/item/book/yeoldecookingmanual = 1)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 2) // Cheese diet.

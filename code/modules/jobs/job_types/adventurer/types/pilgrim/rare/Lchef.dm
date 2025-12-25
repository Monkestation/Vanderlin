/datum/job/advclass/pilgrim/rare/masterchef
	title = "Master Chef"
	tutorial = "A master chef is one of the best cooks to ever live. \
	You received an early education from the guild of culinary arts and have traveled across Psydonia, cooking exotic masterpieces for wealthy merchants and nobility alike. \
	Now you find yourself approaching Vanderlin... perhaps this will be a perfect location to prepare your next great feast?"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/masterchef
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	apprentice_name = "Chef Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_CON = 2
	)

	skills = list(
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/labor/farming = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/craft/crafting = 4,
		/datum/skill/labor/butchering = 4,
		/datum/skill/labor/taming = 2,
		/datum/skill/craft/cooking = 6
	)

/datum/job/advclass/pilgrim/rare/masterchef/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)

/datum/outfit/pilgrim/masterchef
	name = "Master Chef (Pilgrim)"
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	cloak = /obj/item/clothing/cloak/apron
	head = /obj/item/clothing/head/cookhat/chef
	shoes = /obj/item/clothing/shoes/shortboots
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/weapon/knife/cleaver

/datum/outfit/pilgrim/masterchef/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/packcontents = pickweight(list("Honey" = 1, "Truffles" = 1, "Bacon" = 1))
	switch(packcontents)
		if("Honey")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/spiderhoney = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/handpie = 1,
				/obj/item/recipe_book/cooking = 1
			)
		if("Truffles")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/truffles = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/handpie = 1,
				/obj/item/recipe_book/cooking = 1
			)
		if("Bacon")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/meat/fatty = 1,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/handpie = 1,
				/obj/item/recipe_book/cooking = 1
			)

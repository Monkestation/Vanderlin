/datum/attribute_holder/sheet/job/pilgrim/masterchef
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/farming = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/labor/butchering = 40,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/craft/cooking = 60
	)

/datum/attribute_holder/sheet/job/pilgrim/masterchef/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/labor/farming = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/labor/butchering = 50,
		/datum/attribute/skill/labor/taming = 20,
		/datum/attribute/skill/craft/cooking = 60
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/masterchef
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/masterchef

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

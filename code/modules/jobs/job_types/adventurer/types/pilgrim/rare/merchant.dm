/datum/attribute_holder/sheet/job/pilgrim/merchant
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/alchemy = 10,
		/datum/attribute/skill/labor/mathematics = 50,
	)

/datum/job/advclass/pilgrim/rare/merchant
	title = "Travelling Merchant"
	tutorial = "You are a travelling merchant from far away lands. \
	You've picked up many wears on your various adventures, now it's time to peddle them to these locals."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/pilgrim/merchant
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE
	var/merchant_type

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/merchant

	traits = list(
		TRAIT_NOBLE_BLOOD,//Not sure if they ought to be a noble but I'll leave it as is.
		TRAIT_NOBLE_POWER,
		TRAIT_SEEPRICES,
		TRAIT_FOREIGNER
	)

/datum/job/advclass/pilgrim/rare/merchant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/merchant_type = pickweight(list("FOOD" = 4, "HEAL" = 2, "SILK" = 1, "GEMS" = 1))
	switch(merchant_type)
		if("FOOD")
			spawned.adjust_skill_level(/datum/attribute/skill/craft/cooking, 20)
		if("HEAL")
			spawned.adjust_skill_level(/datum/attribute/skill/craft/alchemy, 20)
		if("SILK")
			spawned.adjust_skill_level(/datum/attribute/skill/misc/sewing, 20)
		if("GEMS")
			spawned.adjust_skill_level(/datum/attribute/skill/craft/blacksmithing, 10)

/datum/outfit/pilgrim/merchant
	name = "Travelling Merchant (Pilgrim)"
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/rich
	ring = /obj/item/clothing/ring/silver

/datum/outfit/pilgrim/merchant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/armor/gambeson/heavy/dress
		head = pick(/obj/item/clothing/head/fancyhat, /obj/item/clothing/head/chaperon)
		cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	if(equipped_human.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/green
		shirt = /obj/item/clothing/shirt/undershirt/colored/green
		armor = /obj/item/clothing/armor/gambeson/arming
		cloak = /obj/item/clothing/cloak/half
		head = pick(/obj/item/clothing/head/fancyhat, /obj/item/clothing/head/chaperon)

	if(equipped_human.mind?.assigned_role.type == /datum/job/advclass/pilgrim/rare/merchant)
		var/datum/job/advclass/pilgrim/rare/merchant/merchant = equipped_human.mind.assigned_role
		switch(merchant.merchant_type)
			if("FOOD")
				backpack_contents = list(
					/obj/item/reagent_containers/food/snacks/meat/salami = 1,
					/obj/item/reagent_containers/food/snacks/cooked/coppiette = 1,
					/obj/item/reagent_containers/food/snacks/cheddar = 1,
					/obj/item/reagent_containers/food/snacks/saltfish = 1,
					/obj/item/reagent_containers/food/snacks/hardtack = 1,
					/obj/item/flint = 1,
					/obj/item/weapon/knife/dagger = 1
				)
			if("HEAL")
				backpack_contents = list(
					/obj/item/reagent_containers/glass/bottle/healthpot = 1,
					/obj/item/reagent_containers/glass/bottle/healthpot = 1,
					/obj/item/reagent_containers/glass/bottle/healthpot = 1,
					/obj/item/reagent_containers/glass/bottle/manapot = 1,
					/obj/item/flint = 1,
					/obj/item/weapon/knife/dagger = 1
				)
			if("SILK")
				backpack_contents = list(
					/obj/item/natural/bundle/silk = 2,
					/obj/item/natural/fur = 1,
					/obj/item/natural/bundle/fibers = 2,
					/obj/item/clothing/shirt/dress/silkdress = 1,
					/obj/item/clothing/shirt/undershirt/puritan = 1,
					/obj/item/flint = 1,
					/obj/item/weapon/knife/dagger = 1
				)
			if("GEMS")
				backpack_contents = list(
					/obj/item/gem/yellow = 1,
					/obj/item/gem/yellow = 1,
					/obj/item/gem/green = 1,
					/obj/item/gem/green = 1,
					/obj/item/gem/violet = 1,
					/obj/item/flint = 1,
					/obj/item/weapon/knife/dagger = 1
				)

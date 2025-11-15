/datum/job/advclass/pilgrim/rare/merchant
	title = "Travelling Merchant"
	tutorial = "You are a travelling merchant from far away lands. \
	You've picked up many wears on your various adventures, now it's time to peddle them to these locals."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/merchant
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	min_pq = 0
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE


/datum/outfit/adventurer/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 5, TRUE)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 1)
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/rich
	ring = /obj/item/clothing/ring/silver
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/armor/gambeson/heavy/dress
		head = pick(/obj/item/clothing/head/fancyhat, /obj/item/clothing/head/chaperon)
		cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	if(H.gender == MALE)
		pants = /obj/item/clothing/pants/tights/colored/green
		shirt = /obj/item/clothing/shirt/undershirt/colored/green
		armor = /obj/item/clothing/armor/gambeson/arming
		cloak = /obj/item/clothing/cloak/half
		head = pick(/obj/item/clothing/head/fancyhat, /obj/item/clothing/head/chaperon)

	//For how we decide what kind of merchant they are.
	var/merchtype = pickweight(list("FOOD" = 4, "HEAL" = 2, "SILK" = 1, "GEMS" = 1))
	switch(merchtype)
		if("FOOD")		// Travelling food peddler
			backpack_contents = list(/obj/item/reagent_containers/food/snacks/meat/salami = 1, /obj/item/reagent_containers/food/snacks/cooked/coppiette = 1, /obj/item/reagent_containers/food/snacks/cheddar = 1, /obj/item/reagent_containers/food/snacks/saltfish = 1, /obj/item/reagent_containers/food/snacks/hardtack = 1, /obj/item/flint, /obj/item/weapon/knife/dagger)
			H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		if("HEAL")		// Travelling potion seller (If only we had snake oil..)
			backpack_contents = list(/obj/item/reagent_containers/glass/bottle/healthpot, /obj/item/reagent_containers/glass/bottle/healthpot, /obj/item/reagent_containers/glass/bottle/healthpot, /obj/item/reagent_containers/glass/bottle/manapot, /obj/item/flint, /obj/item/weapon/knife/dagger)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		if("SILK")		// Travelling silk trader
			backpack_contents = list(/obj/item/natural/bundle/silk = 2, /obj/item/natural/fur = 1, /obj/item/natural/bundle/fibers = 2, /obj/item/clothing/shirt/dress/silkdress, /obj/item/clothing/shirt/undershirt/puritan, /obj/item/flint, /obj/item/weapon/knife/dagger)
			H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		if("GEMS")		// Travelling high-end merchant
			backpack_contents = list(/obj/item/gem/yellow, /obj/item/gem/yellow, /obj/item/gem/green, /obj/item/gem/green, /obj/item/gem/violet, /obj/item/flint, /obj/item/weapon/knife/dagger)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)

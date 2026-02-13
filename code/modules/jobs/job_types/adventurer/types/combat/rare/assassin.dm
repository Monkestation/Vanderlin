/datum/job/advclass/combat/assassin
	title = "Assassin"
	tutorial = "From a young age you have been drawn to blood, to hurting others. Eventually you found others like you, and a god who would bless your actions. Your cursed dagger has never led you astray, and with every stab you feel a little less empty."
	allowed_sexes = list(MALE, FEMALE)
	bypass_class_cat_limits = TRUE
	category_tags = list(CTAG_PILGRIM)
	total_positions = 2
	inherit_parent_title = TRUE //this prevents advjob from being set back to "Assassin" in equipme
	antags_can_pick = FALSE //Assassins are antagonists by default, so they can't be chosen if you're already an antagonist.
	antag_role = /datum/antagonist/assassin

	pack_title = "Assassin Disguises"
	pack_message = "Choose your cover identity"
	job_packs = list(
		/datum/job_pack/assassin/assassin_bard,
		/datum/job_pack/assassin/assassin_beggar,
		/datum/job_pack/assassin/assassin_fisher,
		/datum/job_pack/assassin/assassin_hunter,
		/datum/job_pack/assassin/assassin_miner,
		/datum/job_pack/assassin/assassin_noble,
		/datum/job_pack/assassin/assassin_peasant,
		/datum/job_pack/assassin/assassin_carpenter,
		/datum/job_pack/assassin/assassin_thief,
		/datum/job_pack/assassin/assassin_ranger,
		/datum/job_pack/assassin/assassin_servant,
		/datum/job_pack/assassin/assassin_faceless,
	)

	skills = list(
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sneaking = 5,
		/datum/skill/misc/stealing = 3,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/riding = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/medicine = 2,
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/reading = 1,
	)

	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_ASSASSIN,
		TRAIT_DEADNOSE,
		TRAIT_VILLAIN,
		TRAIT_STEELHEARTED,
		TRAIT_STRONG_GRABBER,
	)

/datum/job_pack/assassin/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.job = name

/datum/job/advclass/combat/assassin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		if(spawned.gender == "male")
			spawned.dna.species.soundpack_m = new /datum/voicepack/male/assassin()
		else
			spawned.dna.species.soundpack_f = new /datum/voicepack/female/assassin()

/datum/job_pack/assassin/assassin_bard
	name = "Bard"

	pack_skills = list(
		/datum/skill/misc/music = 1,
	)

	pack_contents = list(
		/obj/item/clothing/head/bardhat = ITEM_SLOT_HEAD,
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/clothing/pants/tights/colored/random = ITEM_SLOT_PANTS,
		/obj/item/clothing/shirt/shortshirt = ITEM_SLOT_SHIRT,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/clothing/armor/leather/vest = ITEM_SLOT_ARMOR,
		/obj/item/clothing/cloak/raincloak/colored/red = ITEM_SLOT_CLOAK,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/weapon/knife/dagger/steel/stiletto = ITEM_SLOT_BELT_R,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_BELT_L,
	)

	pack_backpack_contents = list(
		/obj/item/flint = 1,
	)

/datum/job_pack/assassin/assassin_bard/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	if(picker.dna?.species)
		if(ishuman(picker))
			var/obj/item/instrument/lute/backr = new()
			picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		else if(isdwarf(picker))
			var/obj/item/instrument/accord/backr = new()
			picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		else if(iself(picker))
			var/obj/item/instrument/harp/backr = new()
			picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		else if(istiefling(picker))
			var/obj/item/instrument/guitar/backr = new()
			picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)


/datum/job_pack/assassin/assassin_beggar
	name = "Beggar"

	pack_contents = list(
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
	)

/datum/job_pack/assassin/assassin_beggar/pick_pack(mob/living/carbon/human/picker)
	. = ..()

	REMOVE_TRAIT(picker, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(picker.gender == FEMALE)
		var/obj/item/clothing/shirt/rags/armor = new()
		picker.equip_to_slot_or_del(armor, ITEM_SLOT_ARMOR, TRUE)
	else
		var/obj/item/clothing/pants/tights/colored/vagrant/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/undershirt/colored/vagrant/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)

/datum/job_pack/assassin/assassin_fisher
	name = "Fisher"

	pack_skills = list(
		/datum/skill/labor/fishing = 1,
	)

	pack_contents = list(
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/weapon/knife/hunting = ITEM_SLOT_MOUTH,
		/obj/item/clothing/armor/gambeson/light/striped = ITEM_SLOT_ARMOR,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/fishingrod = ITEM_SLOT_BACK_R,
		/obj/item/cooking/pan = ITEM_SLOT_BELT_R,
		/obj/item/flint = ITEM_SLOT_BELT_L,
	)

	pack_backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/natural/worms = 1,
		/obj/item/weapon/shovel/small = 1,
	)

/datum/job_pack/assassin/assassin_fisher/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	if(picker.gender == MALE)
		var/obj/item/clothing/pants/tights/colored/random/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/shortshirt/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/shoes/boots/leather/shoes = new()
		picker.equip_to_slot_or_del(shoes, ITEM_SLOT_SHOES, TRUE)
		var/obj/item/storage/belt/pouch/coins/poor/neck = new()
		picker.equip_to_slot_or_del(neck, ITEM_SLOT_NECK, TRUE)
		var/obj/item/clothing/head/fisherhat/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
	else
		var/obj/item/clothing/shirt/dress/gen/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/shoes/boots/leather/shoes = new()
		picker.equip_to_slot_or_del(shoes, ITEM_SLOT_SHOES, TRUE)
		var/obj/item/storage/belt/pouch/coins/poor/neck = new()
		picker.equip_to_slot_or_del(neck, ITEM_SLOT_NECK, TRUE)
		var/obj/item/clothing/head/fisherhat/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)

/datum/job_pack/assassin/assassin_hunter
	name = "Hunter"

	pack_skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = -2, // Trade-off
	)

	pack_contents = list(
		/obj/item/clothing/cloak/raincloak/furcloak/colored/brown = ITEM_SLOT_CLOAK,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_R,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow = ITEM_SLOT_BACK_L,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/ammo_holder/quiver/arrows = ITEM_SLOT_BELT_R,
		/obj/item/flashlight/flare/torch/lantern = ITEM_SLOT_BELT_L,
		/obj/item/clothing/gloves/leather = ITEM_SLOT_GLOVES,
		/obj/item/clothing/pants/tights/colored/random = ITEM_SLOT_PANTS,
		/obj/item/clothing/shirt/shortshirt/colored/random = ITEM_SLOT_SHIRT,
		/obj/item/clothing/shoes/boots/leather = ITEM_SLOT_SHOES,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_NECK,
	)

	pack_backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/bait = 1,
		/obj/item/weapon/knife/hunting = 1,
	)

/datum/job_pack/assassin/assassin_miner
	name = "Miner"

	pack_skills = list(
		/datum/skill/labor/mining = 1,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = -2, // Trade-off
	)

	pack_contents = list(
		/obj/item/clothing/head/armingcap = ITEM_SLOT_HEAD,
		/obj/item/clothing/pants/trou = ITEM_SLOT_PANTS,
		/obj/item/clothing/armor/gambeson/light/striped = ITEM_SLOT_ARMOR,
		/obj/item/clothing/shirt/undershirt/colored/random = ITEM_SLOT_SHIRT,
		/obj/item/clothing/shoes/boots/leather = ITEM_SLOT_SHOES,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_NECK,
		/obj/item/weapon/pick = ITEM_SLOT_BELT_L,
		/obj/item/weapon/shovel = ITEM_SLOT_BACK_R,
		/obj/item/storage/backpack/backpack = ITEM_SLOT_BACK_L,
	)

	pack_backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/hunting = 1,
	)

/datum/job_pack/assassin/assassin_noble
	name = "Noble"

	pack_contents = list(
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_NECK,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/clothing/ring/silver = ITEM_SLOT_RING,
	)

	pack_backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/wine = 1,
		/obj/item/reagent_containers/glass/cup/silver = 1,
	)

/datum/job_pack/assassin/assassin_noble/can_pick_pack(mob/living/carbon/human/picker, list/previous_picked_types)
	if(picker.dna?.species?.id in RACES_PLAYER_FOREIGNNOBLE)
		return TRUE
	else
		return FALSE

/datum/job_pack/assassin/assassin_noble/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	var/prev_real_name = picker.real_name
	var/prev_name = picker.name
	var/honorary = "Lord"
	if(picker.pronouns == SHE_HER)
		honorary = "Lady"
	picker.real_name = "[honorary] [prev_real_name]"
	picker.name = "[honorary] [prev_name]"

	if(picker.gender == MALE)
		picker.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)

		var/obj/item/clothing/pants/tights/colored/black/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/tunic/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/cloak/raincloak/furcloak/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
		var/obj/item/clothing/head/fancyhat/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/backr = new()
		picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		var/obj/item/weapon/sword/rapier/dec/beltr = new()
		picker.equip_to_slot_or_del(beltr, ITEM_SLOT_BELT_R, TRUE)
		var/obj/item/ammo_holder/quiver/arrows/beltl = new()
		picker.equip_to_slot_or_del(beltl, ITEM_SLOT_BELT_L, TRUE)
	else
		picker.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		picker.adjust_skillrank(/datum/skill/combat/crossbows, -1, TRUE)

		var/obj/item/clothing/shirt/dress/silkdress/colored/random/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		var/obj/item/clothing/head/fancyhat/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
		var/obj/item/clothing/cloak/raincloak/furcloak/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/backr = new()
		picker.equip_to_slot_or_del(backr, ITEM_SLOT_BACK_R, TRUE)
		var/obj/item/weapon/knife/dagger/steel/stiletto/beltr = new()
		picker.equip_to_slot_or_del(beltr, ITEM_SLOT_BELT_R, TRUE)
		var/obj/item/ammo_holder/quiver/arrows/beltl = new()
		picker.equip_to_slot_or_del(beltl, ITEM_SLOT_BELT_L, TRUE)

/datum/job_pack/assassin/assassin_peasant
	name = "Peasant"

	pack_skills = list(
		/datum/skill/labor/farming = 1,
	)

	pack_contents = list(
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/clothing/shirt/undershirt/colored/random = ITEM_SLOT_SHIRT,
		/obj/item/clothing/pants/trou = ITEM_SLOT_PANTS,
		/obj/item/clothing/head/strawhat = ITEM_SLOT_HEAD,
		/obj/item/clothing/shoes/simpleshoes = ITEM_SLOT_SHOES,
		/obj/item/clothing/wrists/bracers/leather = ITEM_SLOT_WRISTS,
		/obj/item/weapon/hoe = ITEM_SLOT_BACK_R,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_NECK,
		/obj/item/clothing/armor/gambeson/light/striped = ITEM_SLOT_ARMOR,
		/obj/item/weapon/sickle = ITEM_SLOT_BELT_L,
		/obj/item/flint = ITEM_SLOT_BELT_R,
	)

	pack_backpack_contents = list(
		/obj/item/neuFarm/seed/wheat = 1,
		/obj/item/neuFarm/seed/apple = 1,
		/obj/item/fertilizer/ash = 1,
		/obj/item/weapon/knife/villager = 1,
	)

/datum/job_pack/assassin/assassin_peasant/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	var/obj/item/weapon/pitchfork/P = new()
	picker.put_in_hands(P, forced = TRUE)

	if(picker.gender == FEMALE)
		var/obj/item/clothing/head/armingcap/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)
		var/obj/item/clothing/shirt/dress/gen/colored/random/armor = new()
		picker.equip_to_slot_or_del(armor, ITEM_SLOT_ARMOR, TRUE)
		var/obj/item/clothing/shirt/undershirt/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
		picker.equip_to_slot_or_del(null, ITEM_SLOT_PANTS, TRUE)

/datum/job_pack/assassin/assassin_carpenter
	name = "Carpenter"

	pack_skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = -2, // Trade-off
	)

	pack_contents = list(
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/clothing/shirt/undershirt/colored/random = ITEM_SLOT_SHIRT,
		/obj/item/clothing/pants/trou = ITEM_SLOT_PANTS,
		/obj/item/clothing/shoes/boots/leather = ITEM_SLOT_SHOES,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_R,
		/obj/item/clothing/neck/coif = ITEM_SLOT_NECK,
		/obj/item/clothing/wrists/bracers/leather = ITEM_SLOT_WRISTS,
		/obj/item/clothing/armor/gambeson/light/striped = ITEM_SLOT_ARMOR,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_BELT_R,
		/obj/item/weapon/hammer/steel = ITEM_SLOT_BELT_L,
		/obj/item/weapon/axe/iron = ITEM_SLOT_BACK_L,
	)

	pack_backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1,
	)

/datum/job_pack/assassin/assassin_carpenter/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	var/head_type = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
	var/obj/item/clothing/head/head = new head_type()
	picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)

/datum/job_pack/assassin/assassin_thief
	name = "Thief"

	pack_contents = list(
		/obj/item/clothing/shirt/undershirt/colored/black = ITEM_SLOT_SHIRT,
		/obj/item/clothing/gloves/fingerless = ITEM_SLOT_GLOVES,
		/obj/item/clothing/pants/trou/leather = ITEM_SLOT_PANTS,
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/weapon/mace/cudgel = ITEM_SLOT_BELT_R,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_BELT_L,
		/obj/item/clothing/cloak/raincloak/colored/mortus = ITEM_SLOT_CLOAK,
	)

/datum/job_pack/assassin/assassin_ranger
	name = "Ranger"

	pack_skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = -2, // Trade-off
	)

	pack_contents = list(
		/obj/item/clothing/wrists/bracers/leather = ITEM_SLOT_WRISTS,
		/obj/item/storage/belt/leather/assassin = ITEM_SLOT_BELT,
		/obj/item/clothing/armor/leather/hide = ITEM_SLOT_ARMOR,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow = ITEM_SLOT_BACK_R,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/flashlight/flare/torch/lantern = ITEM_SLOT_BELT_R,
		/obj/item/ammo_holder/quiver/arrows = ITEM_SLOT_BELT_L,
		/obj/item/clothing/shoes/boots/leather = ITEM_SLOT_SHOES,
	)

	pack_backpack_contents = list(
		/obj/item/bait = 1,
		/obj/item/weapon/knife/hunting = 1,
	)

/datum/job_pack/assassin/assassin_ranger/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	if(picker.gender == MALE)
		var/obj/item/clothing/pants/trou/leather/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/undershirt/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)
	else
		if(prob(50))
			var/obj/item/clothing/pants/tights/colored/black/pants = new()
			picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		else
			var/obj/item/clothing/pants/tights/pants = new()
			picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/shirt/undershirt/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)

	if(prob(23))
		var/obj/item/clothing/gloves/leather/gloves = new()
		picker.equip_to_slot_or_del(gloves, ITEM_SLOT_GLOVES, TRUE)
	else
		var/obj/item/clothing/gloves/fingerless/gloves = new()
		picker.equip_to_slot_or_del(gloves, ITEM_SLOT_GLOVES, TRUE)

	if(prob(33))
		var/obj/item/clothing/cloak/raincloak/colored/green/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
	else
		var/obj/item/clothing/cloak/raincloak/colored/brown/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)

/datum/job_pack/assassin/assassin_servant
	name = "Servant"

	pack_skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 3,
	)

	pack_contents = list(
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/weapon/knife/villager = ITEM_SLOT_BELT_R,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_BELT_L,
	)

	pack_backpack_contents = list(
		/obj/item/recipe_book/cooking = 1,
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/weapon/knife/dagger/steel/profane = 1,
		/obj/item/lockpick = 1,
	)

/datum/job_pack/assassin/assassin_servant/pick_pack(mob/living/carbon/human/picker)
	. = ..()

	REMOVE_TRAIT(picker, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(picker.gender == MALE)
		var/obj/item/clothing/shirt/undershirt/formal/shirt = new()
		picker.equip_to_slot_or_del(shirt, ITEM_SLOT_SHIRT, TRUE)

		if(picker.age == AGE_OLD)
			var/obj/item/clothing/pants/trou/formal/pants = new()
			picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		else
			var/obj/item/clothing/pants/trou/formal/shorts/pants = new()
			picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)

		var/obj/item/storage/belt/leather/suspenders/belt = new()
		picker.equip_to_slot_or_del(belt, ITEM_SLOT_BELT, TRUE)
		var/obj/item/clothing/shoes/boots/shoes = new()
		picker.equip_to_slot_or_del(shoes, ITEM_SLOT_SHOES, TRUE)
	else
		var/obj/item/clothing/shirt/dress/maid/servant/armor = new()
		picker.equip_to_slot_or_del(armor, ITEM_SLOT_ARMOR, TRUE)
		var/obj/item/clothing/shoes/simpleshoes/shoes = new()
		picker.equip_to_slot_or_del(shoes, ITEM_SLOT_SHOES, TRUE)
		var/obj/item/storage/belt/leather/cloth_belt/belt = new()
		picker.equip_to_slot_or_del(belt, ITEM_SLOT_BELT, TRUE)
		var/obj/item/clothing/pants/tights/colored/white/pants = new()
		picker.equip_to_slot_or_del(pants, ITEM_SLOT_PANTS, TRUE)
		var/obj/item/clothing/cloak/apron/maid/cloak = new()
		picker.equip_to_slot_or_del(cloak, ITEM_SLOT_CLOAK, TRUE)
		var/obj/item/clothing/head/maidband/head = new()
		picker.equip_to_slot_or_del(head, ITEM_SLOT_HEAD, TRUE)

/datum/job_pack/assassin/assassin_faceless
	name = "Faceless One"

	pack_traits = list(
		TRAIT_FACELESS
	)

	pack_contents = list(
		/obj/item/clothing/head/faceless = ITEM_SLOT_HEAD,
		/obj/item/clothing/shirt/robe/faceless = ITEM_SLOT_ARMOR,
		/obj/item/clothing/gloves/leather/black = ITEM_SLOT_GLOVES,
		/obj/item/clothing/pants/trou/leather = ITEM_SLOT_PANTS,
		/obj/item/clothing/shoes/boots = ITEM_SLOT_SHOES,
		/obj/item/storage/backpack/satchel = ITEM_SLOT_BACK_L,
		/obj/item/storage/belt/pouch/coins/poor = ITEM_SLOT_BELT_L,
		/obj/item/weapon/knife/dagger/steel/stiletto = ITEM_SLOT_BELT_R,
		/obj/item/clothing/cloak/faceless = ITEM_SLOT_CLOAK,
		/obj/item/clothing/shirt/undershirt/colored/black = ITEM_SLOT_SHIRT,
		/obj/item/clothing/face/lordmask/faceless = ITEM_SLOT_MASK,
	)

	pack_backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/weapon/knife/dagger/steel/profane = 1,
		/obj/item/lockpick = 1,
		/obj/item/storage/fancy/cigarettes/zig = 1,
		/obj/item/flint = 1,
	)

/datum/job_pack/assassin/assassin_faceless/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.real_name = get_faceless_name(picker)
	picker.name = picker.real_name

	var/list/belt_options = list("Leather Belt", "Toss Blade Belt")
	var/belt_pick = browser_input_list(picker, "Select belt.", "BELT OPTION", belt_options)
	if(!belt_pick)
		belt_pick = pick(belt_options)

	switch(belt_pick)
		if("Leather Belt")
			var/obj/item/storage/belt/leather/belt = new()
			picker.equip_to_slot_or_del(belt, ITEM_SLOT_BELT, TRUE)
		if("Toss Blade Belt")
			var/obj/item/storage/belt/leather/knifebelt/black/steel/belt = new()
			picker.equip_to_slot_or_del(belt, ITEM_SLOT_BELT, TRUE)

/datum/job_pack/assassin/assassin_faceless/proc/get_faceless_name(mob/living/carbon/human/H)
	if(is_species(H, /datum/species/rakshari) && prob(10))
		return "Furless One"
	else if(is_species(H, /datum/species/harpy) && prob(10))
		return "Featherless One"
	else if(is_species(H, /datum/species/kobold) && prob(10))
		return "Scaleless One"
	else if(prob(1))
		return pick("Friendless One", "Maidenless One", "Fatherless One", "Kinless One")
	else
		return "Faceless One"

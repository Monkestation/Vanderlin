/datum/migrant_role/heartfelt_lord
	name = "Lord of Heartfelt"
	greet_text = "You are the Lord of Heartfelt, ruler of a once-prosperous barony now in ruin. Guided by your Magos, you journey to Vanderlin, seeking aid to restore your domain to its former glory, or perhaps claim a new throne."
	migrant_job = /datum/job/migrant/heartfelt_lord

/datum/attribute_holder/sheet/job/migrant/heartfelt_lord
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 3,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 2,
		STAT_FORTUNE = 2,
		/datum/attribute/skill/craft/engineering = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/heartfelt_lord
	title = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a once-prosperous barony now in ruin. Guided by your Magos, you journey to Vanderlin, seeking aid to restore your domain to its former glory, or perhaps claim a new throne."
	outfit = /datum/outfit/heartfelt_lord
	allowed_sexes = list(MALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE
	honorary = "Baron"
	honorary_f = "Baroness"


	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/heartfelt_lord

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_NOSEGRAB,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/heartfelt_lord
	name = "Lord of Heartfelt (Migrant Wave)"
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather/black
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet
	shoes = /obj/item/clothing/shoes/nobleboot
	pants = /obj/item/clothing/pants/tights/colored/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/armor/medium/surcoat/heartfelt
	beltr = /obj/item/storage/belt/pouch/coins/rich
	ring = /obj/item/scomstone
	gloves = /obj/item/clothing/gloves/leather/black
	beltl = /obj/item/weapon/sword/long
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/waterskin/purifier)

/datum/migrant_role/heartfelt_lady
	name = "Lady of Heartfelt"
	greet_text = "You are the Lady of Heartfelt, once a respected noblewoman now struggling to survive in a desolate landscape. With your home in ruins, you look to Vanderlin, hoping to find new purpose or refuge amidst the chaos."
	migrant_job = /datum/job/migrant/heartfelt_lady

/datum/attribute_holder/sheet/job/migrant/heartfelt_lady
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		STAT_PERCEPTION = 2,
		STAT_FORTUNE = 2,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/heartfelt_lady
	title = "Lady of Heartfelt"
	tutorial = "You are the Lady of Heartfelt, once a respected noblewoman now struggling to survive in a desolate landscape. With your home in ruins, you look to Vanderlin, hoping to find new purpose or refuge amidst the chaos."
	outfit = /datum/outfit/heartfelt_lady
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE
	honorary = "Baron"
	honorary_f = "Baroness"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/heartfelt_lady

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_NUTCRACKER,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/heartfelt_lady
	name = "Lady of Heartfelt (Migrant Wave)"
	head = /obj/item/clothing/head/hennin
	neck = /obj/item/storage/belt/pouch/coins/rich
	cloak = /obj/item/clothing/cloak/heartfelt
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/ammo_holder/quiver/arrows
	beltr = /obj/item/weapon/knife/dagger/steel/special
	ring = /obj/item/clothing/ring/silver
	shoes = /obj/item/clothing/shoes/shortboots
	pants = /obj/item/clothing/pants/tights/colored/random

/datum/outfit/heartfelt_lady/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(isdwarf(equipped_human))
		armor = /obj/item/clothing/shirt/dress
	else if(prob(66))
		armor = /obj/item/clothing/armor/gambeson/heavy/dress/alt
	else
		armor = /obj/item/clothing/armor/gambeson/heavy/dress

/datum/migrant_role/heartfelt_hand
	name = "Hand of Heartfelt"
	greet_text = "You are the Hand of Heartfelt, burdened by the perception of failure in protecting your Lord's domain. Despite doubts from others, your loyalty remains steadfast as you journey to Vanderlin, determined to fulfill your duties."
	migrant_job = /datum/job/migrant/heartfelt_hand

/datum/attribute_holder/sheet/job/migrant/heartfelt_hand
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/cooking = 10,
	)


/datum/job/migrant/heartfelt_hand
	title = "Hand of Heartfelt"
	tutorial = "You are the Hand of Heartfelt, burdened by the perception of failure in protecting your Lord's domain. Despite doubts from others, your loyalty remains steadfast as you journey to Vanderlin, determined to fulfill your duties."
	outfit = /datum/outfit/heartfelt_hand
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE
	honorary = "Lord"
	honorary_f = "Lady"


	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/heartfelt_hand

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_SEEPRICES,
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg'

/datum/outfit/heartfelt_hand
	name = "Hand of Heartfelt (Migrant Wave)"
	shirt = /obj/item/clothing/shirt/undershirt
	belt = /obj/item/storage/belt/leather/black
	shoes = /obj/item/clothing/shoes/nobleboot
	pants = /obj/item/clothing/pants/tights/colored/black
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/medium/surcoat/heartfelt
	beltr = /obj/item/storage/belt/pouch/coins/rich
	gloves = /obj/item/clothing/gloves/leather/black
	beltl = /obj/item/weapon/sword/decorated
	ring = /obj/item/scomstone
	backr = /obj/item/storage/backpack/satchel
	mask = /obj/item/clothing/face/spectacles/golden

/datum/migrant_role/heartfelt_knight
	name = "Knight of Heartfelt"
	greet_text = "You are a Knight of Heartfelt, once part of a brotherhood in service to your Lord. Now, alone and committed to safeguarding what remains of your court, you ride to Vanderlin, resolved to ensure their safe arrival."
	migrant_job = /datum/job/migrant/heartfelt_knight

/datum/attribute_holder/sheet/job/migrant/heartfelt_knight
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/migrant/heartfelt_knight
	title = "Knight of Heartfelt"
	tutorial = "You are a Knight of Heartfelt, once part of a brotherhood in service to your Lord. Now, alone and committed to safeguarding what remains of your court, you ride to Vanderlin, resolved to ensure their safe arrival."
	outfit = /datum/outfit/heartfelt_knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	honorary = "Sir"
	honorary_f = "Dame"

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/heartfelt_knight

	traits = list(
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
	)

	cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
	voicepack_m = /datum/voicepack/male/knight

/datum/job/migrant/heartfelt_knight/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(istype(spawned.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
		var/obj/item/clothing/S = spawned.cloak
		var/index = findtext(spawned.real_name, " ")
		if(index)
			index = copytext(spawned.real_name, 1,index)
		if(!index)
			index = spawned.real_name
		S.name = "knight tabard ([index])"

	var/obj/item/clothing/cloak/boiler/boiler = locate() in spawned.get_all_gear()
	if(boiler)
		SEND_SIGNAL(boiler, COMSIG_ATOM_STEAM_INCREASE, rand(500, 900))

/datum/outfit/heartfelt_knight
	name = "Knight of Heartfelt (Migrant Wave)"
	backl = /obj/item/clothing/cloak/boiler
	armor = /obj/item/clothing/armor/steam
	shoes = /obj/item/clothing/shoes/boots/armor/steam
	gloves = /obj/item/clothing/gloves/plate/steam
	head = /obj/item/clothing/head/helmet/heavy/steam
	pants = /obj/item/clothing/pants/trou/artipants
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	neck = /obj/item/clothing/neck/bevor
	shirt = /obj/item/clothing/shirt/undershirt/artificer
	beltr = /obj/item/weapon/sword/long
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/leather/steel
	backr = /obj/item/storage/backpack/satchel/black

/datum/outfit/heartfelt_knight/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(50))
		r_hand = /obj/item/weapon/polearm/eaglebeak/lucerne
	else
		r_hand = /obj/item/weapon/mace/goden/steel

/datum/migrant_role/heartfelt_artificer
	name = "Supreme Artificer"
	greet_text = "You are the Supreme Artificer, the foremost expert on anything brass and steam. Your knowledge helped advance your kingdom, before ultimately leading it to ruin..."
	migrant_job = /datum/job/migrant/heartfelt_artificer

/datum/attribute_holder/sheet/job/migrant/heartfelt_artificer
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/labor/lumberjacking = 20,
		/datum/attribute/skill/craft/masonry = 30,
		/datum/attribute/skill/craft/crafting = 40,
		/datum/attribute/skill/craft/engineering = 60,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/labor/mining = 20,
		/datum/attribute/skill/craft/smelting = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/bombs= 40,
	)

/datum/job/migrant/heartfelt_artificer
	title = "Supreme Artificer"
	tutorial = "You are the Supreme Artificer, the foremost expert on anything brass and steam. Your knowledge helped advance your kingdom, before ultimately leading it to ruin..."
	outfit = /datum/outfit/heartfelt_artificer
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/heartfelt_artificer

	traits = list(TRAIT_SEEPRICES)
	cmode_music = 'sound/music/cmode/adventurer/CombatDream.ogg'

/datum/outfit/heartfelt_artificer
	name = "Supreme Artificer (Migrant Wave)"
	head = /obj/item/clothing/head/articap
	armor = /obj/item/clothing/armor/leather/jacket/artijacket
	pants = /obj/item/clothing/pants/trou/artipants
	shirt = /obj/item/clothing/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/belt/pouch/coins/mid
	mask = /obj/item/clothing/face/goggles
	backl = /obj/item/storage/backpack/backpack/artibackpack
	ring = /obj/item/clothing/ring/silver/makers_guild
	neck = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
	backpack_contents = list(
		/obj/item/weapon/hammer/steel = 1,
		/obj/item/weapon/knife/villager = 1,
		/obj/item/weapon/chisel = 1,
	)

/datum/migrant_wave/heartfelt
	name = "The Court of Heartfelt"
	max_spawns = 1
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	weight = 25
	downgrade_wave = /datum/migrant_wave/heartfelt_down
	roles = list(
		/datum/migrant_role/heartfelt_lord = 1,
		/datum/migrant_role/heartfelt_lady = 1,
		/datum/migrant_role/heartfelt_hand = 1,
		/datum/migrant_role/heartfelt_knight = 1,
		/datum/migrant_role/heartfelt_artificer = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes!"

/datum/migrant_wave/heartfelt_down
	name = "The Court of Heartfelt"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_one
	roles = list(
		/datum/migrant_role/heartfelt_lord = 1,
		/datum/migrant_role/heartfelt_lady = 1,
		/datum/migrant_role/heartfelt_hand = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Your Knight, Magos and Artificer did not make it..."

/datum/migrant_wave/heartfelt_down_one
	name = "The Court of Heartfelt"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_two
	roles = list(
		/datum/migrant_role/heartfelt_lord = 1,
		/datum/migrant_role/heartfelt_hand = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! The journey took its heavy toll. Only you two made it, the rest..."

/datum/migrant_wave/heartfelt_down_two
	name = "The Court of Heartfelt"
	shared_wave_type = list(/datum/migrant_wave/grenzelhoft_visit,/datum/migrant_wave/zalad_wave,/datum/migrant_wave/rockhill_wave,/datum/migrant_wave/heartfelt)
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/heartfelt_lord = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. But disaster followed hot on your heels, from Heartfelt to this very place! You are the last one remaining, oh how tragic!"

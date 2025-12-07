/datum/migrant_role/heartfelt_lord
	name = "Lord of Heartfelt"
	greet_text = "You are the Lord of Heartfelt, ruler of a once-prosperous barony now in ruin. Guided by your Magos, you journey to Vanderlin, seeking aid to restore your domain to its former glory, or perhaps claim a new throne."
	migrant_job = /datum/job/migrant/heartfelt_lord

/datum/job/migrant/heartfelt_lord
	title = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a once-prosperous barony now in ruin. Guided by your Magos, you journey to Vanderlin, seeking aid to restore your domain to its former glory, or perhaps claim a new throne."
	outfit = /datum/outfit/heartfelt_lord
	allowed_sexes = list(MALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_END = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
	)

	skills = list(
		/datum/skill/craft/engineering = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/riding = 3,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_NOSEGRAB,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/heartfelt_lord
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
	backl = /obj/item/storage/backpack/satchel/heartfelt
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/waterskin/purifier)

/datum/migrant_role/heartfelt_lady
	name = "Lady of Heartfelt"
	greet_text = "You are the Lady of Heartfelt, once a respected noblewoman now struggling to survive in a desolate landscape. With your home in ruins, you look to Vanderlin, hoping to find new purpose or refuge amidst the chaos."
	migrant_job = /datum/job/migrant/heartfelt_lady

/datum/job/migrant/heartfelt_lady
	title = "Lady of Heartfelt"
	tutorial = "You are the Lady of Heartfelt, once a respected noblewoman now struggling to survive in a desolate landscape. With your home in ruins, you look to Vanderlin, hoping to find new purpose or refuge amidst the chaos."
	outfit = /datum/outfit/heartfelt_lady
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_END = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
	)

	skills = list(
		/datum/skill/craft/engineering = 1,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/bows = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/medicine = 2,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_SEEPRICES,
		TRAIT_NOBLE,
		TRAIT_NUTCRACKER,
	)

	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'

/datum/outfit/heartfelt_lady
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

/datum/job/migrant/heartfelt_hand
	title = "Hand of Heartfelt"
	tutorial = "You are the Hand of Heartfelt, burdened by the perception of failure in protecting your Lord's domain. Despite doubts from others, your loyalty remains steadfast as you journey to Vanderlin, determined to fulfill your duties."
	outfit = /datum/outfit/heartfelt_hand
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
	)

	skills = list(
		/datum/skill/craft/engineering = 1,
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/craft/cooking = 1,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_SEEPRICES,
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

/datum/outfit/heartfelt_hand
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

/datum/job/migrant/heartfelt_knight
	title = "Knight of Heartfelt"
	tutorial = "You are a Knight of Heartfelt, once part of a brotherhood in service to your Lord. Now, alone and committed to safeguarding what remains of your court, you ride to Vanderlin, resolved to ensure their safe arrival."
	outfit = /datum/outfit/heartfelt_knight
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_SPD = -1,
		STATKEY_INT = 2,
	)

	skills = list(
		/datum/skill/craft/engineering = 3,
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/riding = 4,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(
		TRAIT_NOBLE,
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

	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Sir"
	if(spawned.pronouns == SHE_HER)
		honorary = "Dame"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	var/obj/item/clothing/cloak/boiler/boiler = locate() in spawned.get_all_gear()
	if(boiler)
		SEND_SIGNAL(boiler, COMSIG_ATOM_STEAM_INCREASE, rand(500, 900))

/datum/outfit/heartfelt_knight
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

/datum/migrant_role/heartfelt_magos
	name = "Magos of Heartfelt"
	greet_text = "You are the Magos of Heartfelt, renowned for your arcane knowledge yet unable to foresee the tragedy that befell your home. Drawn by a guiding star to Vanderlin, you seek answers and perhaps a new purpose in the wake of destruction."
	migrant_job = /datum/job/migrant/heartfelt_magos

/datum/job/migrant/heartfelt_magos
	title = "Magos of Heartfelt"
	tutorial = "You are the Magos of Heartfelt, renowned for your arcane knowledge yet unable to foresee the tragedy that befell your home. Drawn by a guiding star to Vanderlin, you seek answers and perhaps a new purpose in the wake of destruction."
	outfit = /datum/outfit/heartfelt_magos
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	allowed_patrons = list(/datum/patron/divine/noc)
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_CON = -1,
		STATKEY_INT = 4,
	)

	skills = list(
		/datum/skill/craft/engineering = 3,
		/datum/skill/misc/reading = 6,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/magic/arcane = 5,
		/datum/skill/misc/riding = 2,
		/datum/skill/combat/polearms = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 1,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/knives = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/medicine = 3,
	)

	spells = list(
		/datum/action/cooldown/spell/projectile/fireball/greater,
		/datum/action/cooldown/spell/projectile/lightning,
		/datum/action/cooldown/spell/projectile/fetch,
	)

	traits = list(TRAIT_SEEPRICES)
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'
	voicepack_m = /datum/voicepack/male/wizard

/datum/job/migrant/heartfelt_magos/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		var/list/old_stats = list(
			STATKEY_PER = 1,
			STATKEY_SPD = -1,
		)
		spawned.adjust_stat_modifier_list(STATMOD_JOB, old_stats)
	spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)

/datum/outfit/heartfelt_magos
	neck = /obj/item/clothing/neck/talkstone
	cloak = /obj/item/clothing/cloak/black_cloak
	armor = /obj/item/clothing/shirt/robe/colored/black
	pants = /obj/item/clothing/pants/tights/colored/random
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/book/granter/spellbook/expert
	ring = /obj/item/clothing/ring/gold
	r_hand = /obj/item/weapon/polearm/woodstaff
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/poison,
		/obj/item/reagent_containers/glass/bottle/healthpot,
	)

/datum/migrant_role/heartfelt_prior
	name = "Heartfelt Prior"
	greet_text = "You are a Prior of Heartfelt, a spiritual leader whose faith was tested when your home fell into ruin. Now journeying to Vanderlin, you seek to rebuild not just structures, but the souls of those who follow you."
	migrant_job = /datum/job/migrant/heartfelt_prior

/datum/job/migrant/heartfelt_prior
	title = "Heartfelt Prior"
	tutorial = "You are a Prior of Heartfelt, a spiritual leader whose faith was tested when your home fell into ruin. Now journeying to Vanderlin, you seek to rebuild not just structures, but the souls of those who follow you."
	outfit = /datum/outfit/heartfelt_prior
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_patrons = list(/datum/patron/divine/astrata)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_CON = -1,
		STATKEY_END = 1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/craft/engineering = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/misc/reading = 6,
		/datum/skill/craft/alchemy = 3,
		/datum/skill/misc/medicine = 4,
		/datum/skill/magic/holy = 4,
	)

	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

/datum/job/migrant/heartfelt_prior/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.virginity = TRUE

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/holy, 1)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_priest()
		devotion.grant_to(spawned)

/datum/outfit/heartfelt_prior
	neck = /obj/item/clothing/neck/psycross/silver
	shirt = /obj/item/clothing/shirt/undershirt/priest
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/shortboots
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/belt/pouch/coins/mid
	armor = /obj/item/clothing/shirt/robe/priest
	cloak = /obj/item/clothing/cloak/chasuble
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/needle/blessed = 1,
	)

/datum/migrant_role/heartfelt_artificer
	name = "Supreme Artificer"
	greet_text = "You are the Supreme Artificer, the foremost expert on anything brass and steam. Your knowledge helped advance your kingdom, before ultimately leading it to ruin..."
	migrant_job = /datum/job/migrant/heartfelt_artificer

/datum/job/migrant/heartfelt_artificer
	title = "Supreme Artificer"
	tutorial = "You are the Supreme Artificer, the foremost expert on anything brass and steam. Your knowledge helped advance your kingdom, before ultimately leading it to ruin..."
	outfit = /datum/outfit/heartfelt_artificer
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	is_recognized = TRUE

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_END = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/labor/lumberjacking = 2,
		/datum/skill/craft/masonry = 3,
		/datum/skill/craft/crafting = 4,
		/datum/skill/craft/engineering = 6,
		/datum/skill/misc/lockpicking = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 2,
		/datum/skill/labor/mining = 2,
		/datum/skill/craft/smelting = 4,
		/datum/skill/misc/reading = 2,
		/datum/skill/craft/bombs= 4,
	)

	traits = list(TRAIT_SEEPRICES)
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/heartfelt_artificer
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
		/datum/migrant_role/heartfelt_magos = 1,
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

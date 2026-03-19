/datum/job/orphan
	title = "Orphan"
	tutorial = "Before you could even form words, you were abandoned, or perhaps lost. \
	Ever since, you have lived in the Orphanage under the Matron's care. \
	Will you make something of yourself, or will you die in the streets as a nobody?"
	department_flag = YOUNGFOLK
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_ORPHAN
	faction = FACTION_TOWN
	allowed_ages = list(AGE_CHILD)
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	advclass_cat_rolls = list(CTAG_ORPHAN = 5)
	outfit = /datum/outfit/orphan

	traits = list(
		TRAIT_ORPHAN,
	)

/datum/job/orphan/New()
	. = ..()
	peopleknowme = list()

/datum/outfit/orphan
	name = "Orphan"

// BOOKISH BRAT - THE COURTLY CHILD

/datum/attribute_holder/sheet/job/advclass/bbrat
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 10

	)

/datum/job/advclass/bbrat
	title = "Bookish Brat"
	tutorial = "placeholder text for brat"
	outfit = /datum/outfit/advclass/bbrat
	allowed_ages = list(AGE_CHILD)
	category_tags = list(CTAG_ORPHAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/bbrat

/datum/job/advclass/bbrat/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 1,
			STAT_ENDURANCE = 1,
		))


/datum/outfit/advclass/bbrat/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		backr = /obj/item/storage/backpack/satchel
		backpack_contents = list(
			/obj/item/natural/feather,
			/obj/item/paper/scroll,
			/obj/item/paper,
			/obj/item/paper,
		)
		shoes = /obj/item/clothing/shoes/simpleshoes/buckle
		neck = /obj/item/storage/belt/pouch/coins/poor
		belt = /obj/item/storage/belt/leather
		if(equipped_human.gender == MALE)
			cloak = /obj/item/clothing/cloak/half
			head = pick(
				/obj/item/clothing/head/courtierhat,
				/obj/item/clothing/head/fancyhat,
			)
			shirt = /obj/item/clothing/shirt/undershirt/colored/random
			pants = /obj/item/clothing/pants/tights/colored/random
		else
			shirt = /obj/item/clothing/shirt/dress/gen/colored/random
	else
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
		backr = /obj/item/storage/backpack/satchel/cloth
		backpack_contents = list(
			/obj/item/natural/feather,
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper,
		)
		if(equipped_human.gender == MALE)
			shirt = /obj/item/clothing/shirt/undershirt/colored/random
			pants = /obj/item/clothing/pants/tights/colored/random
		else
			shirt = /obj/item/clothing/shirt/dress/gen/colored/random
			pants = /obj/item/clothing/pants/tights/colored/random
			belt = /obj/item/storage/belt/leather/rope
			shoes = /obj/item/clothing/shoes/simpleshoes

// RAMBUNCTIOUS RASCAL - THE COMBAT KID

/datum/attribute_holder/sheet/job/orphan/rrascal
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 5,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10
	)

/datum/job/advclass/rrascal
	title= "Rambunctious Rascal"
	tutorial = "placeholder text for rascal"
	outfit = /datum/outfit/orphan/rrascal
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/rrascal
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/rrascal/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_CONSTITUTION = 1,
			STAT_ENDURANCE = 1,
		))

/datum/outfit/orphan/rrascal/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		head = pick(
			/obj/item/clothing/head/helmet/kettle/iron,
			/obj/item/clothing/head/helmet/ironpot,
			/obj/item/clothing/head/helmet/winged,
			/obj/item/clothing/head/helmet/horned,
		)
		armor = /obj/item/clothing/armor/gambeson/light/striped
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/boots/leather
		beltr = /obj/item/weapon/mace/woodclub
	else
		head = pick(
			/obj/item/clothing/head/helmet/kettle/iron,
			/obj/item/clothing/head/helmet/ironpot,
			/obj/item/clothing/head/helmet/winged,
			/obj/item/clothing/head/helmet/horned,
		)
		armor = /obj/item/clothing/armor/gambeson/light/striped
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		beltr = /obj/item/weapon/mace/woodclub

// SKILLED STRAY - THE RESPONSIBLE CHILD

/datum/attribute_holder/sheet/job/orphan/sscamp
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/sscamp
	title= "Skilled Scamp"
	tutorial = "placeholder text for stray"
	outfit = /datum/outfit/orphan/sscamp
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/sscamp
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/scamp/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_CONSTITUTION = 1,
			STAT_SPEED = 1,
		))

/datum/outfit/orphan/sscamp/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		neck = /obj/item/storage/belt/pouch/coins/poor
		head = /obj/item/clothing/head/helmet/leather/headscarf
		armor = /obj/item/clothing/shirt/tunic
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather
		shoes = /obj/item/clothing/shoes/boots/leather
		beltl = /obj/item/weapon/knife/villager
	else
		armor = /obj/item/clothing/shirt/tunic
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/boots/leather
		beltl = /obj/item/weapon/knife/stone

// UNLAWFUL URCHIN - THE TROUBLEMAKER

/datum/attribute_holder/sheet/job/orphan/uurchin
	raw_attribute_list = list(
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30,
	)

/datum/job/advclass/uurchin
	title= "Unlawful Urchin"
	tutorial = "placeholder text for urchin"
	outfit = /datum/outfit/orphan/uurchin
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/uurchin
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/uurchin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_SPEED = 1,
			STAT_ENDURANCE = 1,
		))

/datum/outfit/orphan/uurchin/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		head = pick(
			/obj/item/clothing/head/knitcap,
			/obj/item/clothing/head/bardhat,
			/obj/item/clothing/head/courtierhat,
			/obj/item/clothing/head/fancyhat,
		)
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes

// WEARY WASTREL - THE USELESS ONE

/datum/attribute_holder/sheet/job/orphan/wwastrel
	raw_attribute_list = list(
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 10,
	)

/datum/job/advclass/wwastrel
	title= "Weary Wastrel"
	tutorial = "placeholder text for wastrel"
	outfit = /datum/outfit/orphan/wwastrel
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/wwastrel
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/wwastrel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 1,
		))

/datum/outfit/orphan/wwastrel/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		shirt = /obj/item/clothing/shirt/undershirt
		pants = /obj/item/clothing/pants/tights
		belt = /obj/item/storage/belt/leather/rope
	else
		pants = /obj/item/clothing/pants/tights/colored/vagrant
		shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant





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

/datum/attribute_holder/sheet/job/orphan/bbrat
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 10
	)

/datum/job/orphan/bbrat
	title = "Bookish Brat"
	tutorial = "placeholder text for brat"
	outfit = /datum/outfit/orphan/bbrat
	category_tags = list(CTAG_ORPHAN)
	allowed_ages = list(AGE_CHILD)

	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/bbrat

/datum/job/orphan/bbrat/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	//if(has_world_trait(/datum/world_trait/orphanage_renovated))
	//	orphanage_renovated = TRUE
	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 10,
		))
	else
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 20,
			STAT_ENDURANCE = 1,
		))


/datum/outfit/orphan/bbrat/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		//PUT GOOD CLOTHES HERE
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		//PUT BAD CLOTHES HERE
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes

// RAMBUNCTIOUS RASCAL - THE COMBAT KID

/datum/attribute_holder/sheet/job/orphan/rrascal
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 10,
	)

/datum/job/advclass/rrascal
	title= "Rambunctious Rascal"
	tutorial = "placeholder text for rascal"
	//outfit = /datum/outfit/orphan/rrascal
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/rrascal
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/rrascal/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = rand(-4, 4),
			STAT_FORTUNE = rand(-9, 9)
		))
	else
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 4,
			STAT_CONSTITUTION = 2,
			STAT_ENDURANCE = 2,
			STAT_FORTUNE = rand(-2, 9)
		))

/datum/outfit/orphan/rrascal/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		//PUT GOOD CLOTHES HERE
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		//PUT BAD CLOTHES HERE
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes

// SKILLED STRAY - THE RESPONSIBLE CHILD

/datum/attribute_holder/sheet/job/orphan/sstray
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 10,
	)

/datum/job/advclass/sstray
	title= "Skilled Stray"
	tutorial = "placeholder text for stray"
	//outfit = /datum/outfit/orphan/sstray
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/sstray
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/sstray/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = rand(-4, 4),
			STAT_FORTUNE = rand(-9, 9)
		))
	else
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 4,
			STAT_CONSTITUTION = 2,
			STAT_ENDURANCE = 2,
			STAT_FORTUNE = rand(-2, 9)
		))

/datum/outfit/orphan/sstray/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		//PUT GOOD CLOTHES HERE
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		//PUT BAD CLOTHES HERE
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes

// UNLAWFUL URCHIN - THE TROUBLEMAKER

/datum/attribute_holder/sheet/job/orphan/uurchin
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 10,
	)

/datum/job/advclass/uurchin
	title= "Unlawful Urchin"
	tutorial = "placeholder text for urchin"
	//outfit = /datum/outfit/orphan/uurchin
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/uurchin
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/uurchin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = rand(-4, 4),
			STAT_FORTUNE = rand(-9, 9)
		))
	else
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 4,
			STAT_CONSTITUTION = 2,
			STAT_ENDURANCE = 2,
			STAT_FORTUNE = rand(-2, 9)
		))

/datum/outfit/orphan/uurchin/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		//PUT GOOD CLOTHES HERE
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		//PUT BAD CLOTHES HERE
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes


// WEARY WASTREL - THE USELESS ONE

/datum/attribute_holder/sheet/job/orphan/wwastrel
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/shields = 10,
	)

/datum/job/advclass/wwastrel
	title= "Weary Wastrel"
	tutorial = "placeholder text for wastrel"
	//outfit = /datum/outfit/orphan/wwastrel
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphan/wwastrel
	allowed_ages = list(AGE_CHILD)

/datum/job/orphan/wwastrel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(!orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = rand(-4, 4),
			STAT_FORTUNE = rand(-9, 9)
		))
	else
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 4,
			STAT_CONSTITUTION = 2,
			STAT_ENDURANCE = 2,
			STAT_FORTUNE = rand(-2, 9)
		))

/datum/outfit/orphan/wwastrel/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE

	if(orphanage_renovated)
		//PUT GOOD CLOTHES HERE
		neck = /obj/item/storage/belt/pouch/coins/poor
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes
	else
		//PUT BAD CLOTHES HERE
		shirt = /obj/item/clothing/shirt/undershirt/colored/random
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		shoes = /obj/item/clothing/shoes/simpleshoes




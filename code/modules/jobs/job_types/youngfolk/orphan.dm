/datum/job/orphan
	title = JOB_ORPHAN
	tutorial = "Before you could even form words, you were abandoned, or perhaps lost. \
	Ever since, you have lived in the Orphanage under the Matron's care. \
	Will you make something of yourself, or will you die in the streets as a nobody?"
	department_flag = YOUNGFOLK
	job_flags = (JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK)
	display_order = JDO_ORPHAN
	faction = FACTION_TOWN
	allowed_ages = list(AGE_CHILD)
	total_positions = 12
	spawn_positions = 12
	bypass_lastclass = TRUE
	can_have_apprentices = FALSE
	can_be_apprentice = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'
	advclass_cat_rolls = list(CTAG_ORPHAN = 5)
	outfit = /datum/outfit/orphan

	spells = list(
		/datum/action/cooldown/spell/undirected/call_for_hag,
	)

	traits = list(
		TRAIT_ORPHAN,
	)

/datum/job/orphan/New()
	. = ..()
	peopleknowme = list()

/datum/outfit/orphan
	name = JOB_ORPHAN

// BOOKISH BRAT - THE COURTLY CHILD

/datum/attribute_holder/sheet/job/advclass/orphanadv/bbrat
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/labor/mathematics = 10

	)

/datum/job/advclass/orphanadv/bbrat
	title = "Bookish Brat"
	tutorial = "While the rest of the kids were off getting dirty, \
	you were reading the dusty and often-ignored books the matron had \
	spent years collecting.  With one too many hero stories under your belt, \
	your friends rely on you to solve riddles, answer their obvious questions, \
	and talk your way out of the guards bad graces.  Where would they be without you?"
	outfit = /datum/outfit/advclass/orphanadv/bbrat
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/advclass/orphanadv/bbrat
	allowed_ages = list(AGE_CHILD)
	inherit_parent_title = TRUE

/datum/job/advclass/orphanadv/bbrat/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 1,
			STAT_ENDURANCE = 1,
		))

/datum/outfit/advclass/orphanadv/bbrat/pre_equip(mob/living/carbon/human/equipped_human)
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

/datum/attribute_holder/sheet/job/orphanadv/rrascal
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

/datum/job/advclass/orphanadv/rrascal
	title= "Rambunctious Rascal"
	tutorial = "Without you to lead them, your friends \
	would spend all day holed up in workshops, the archives, or \
	the coinpurses of noble fops.  They'd be lost without you, \
	so round them up, get out there, and prove to this city \
	that you're the hero you already know you are."
	outfit = /datum/outfit/orphanadv/rrascal
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphanadv/rrascal
	allowed_ages = list(AGE_CHILD)
	inherit_parent_title = TRUE

/datum/job/orphanadv/rrascal/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_CONSTITUTION = 1,
			STAT_ENDURANCE = 1,
		))

/datum/outfit/orphanadv/rrascal/pre_equip(mob/living/carbon/human/equipped_human)
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
		armor = /obj/item/clothing/shirt/rags
		shirt = /obj/item/clothing/armor/gambeson
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
		armor = /obj/item/clothing/shirt/rags
		shirt = /obj/item/clothing/armor/gambeson/light
		pants = /obj/item/clothing/pants/tights/colored/random
		belt = /obj/item/storage/belt/leather/rope
		beltr = /obj/item/weapon/mace/woodclub

// SKILLED STRAY - THE RESPONSIBLE CHILD

/datum/attribute_holder/sheet/job/orphanadv/sscamp
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/orphanadv/sscamp
	title= "Skilled Scamp"
	tutorial = "The matron has always told you you were her smartest scone, \
	and you prove her right each day with your diligent, industrious ways.  The \
	other children may be stronger, and more well-read, but you have a knack for \
	getting tasks done that you know they envy.  With your trusty knife and your \
	freshly-washed tunic, you are ready to go out and start learning a trade that will \
	really impress everyone."
	outfit = /datum/outfit/orphanadv/sscamp
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphanadv/sscamp
	allowed_ages = list(AGE_CHILD)
	inherit_parent_title = TRUE

/datum/job/orphanadv/scamp/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_CONSTITUTION = 1,
			STAT_SPEED = 1,
		))

/datum/outfit/orphanadv/sscamp/pre_equip(mob/living/carbon/human/equipped_human)
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

/datum/attribute_holder/sheet/job/orphanadv/uurchin
	raw_attribute_list = list(
		STAT_SPEED = 1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/stealing = 30,
	)

/datum/job/advclass/orphanadv/uurchin
	title= "Unlawful Urchin"
	tutorial = "Of all the children in the orphanage, you know \
	you are the matron's favorite.  You move with the same silent, careful \
	steps, you keep an eye open, and are always on the lookout for an easy mark.  \
	Whether it's an easily-opened window, a loose coinpurse, or a few coins left on a \
	bar for too long, you have a sharp eye for profit and feet quick enough to carry you \
	to safety.  The matron is going to be very proud of you."
	outfit = /datum/outfit/orphanadv/uurchin
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphanadv/uurchin
	allowed_ages = list(AGE_CHILD)
	inherit_parent_title = TRUE

/datum/job/orphanadv/uurchin/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_SPEED = 1,
			STAT_ENDURANCE = 1,
		))

/datum/outfit/orphanadv/uurchin/pre_equip(mob/living/carbon/human/equipped_human)
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

/datum/attribute_holder/sheet/job/orphanadv/wwastrel
	raw_attribute_list = list(
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 10,
	)

/datum/job/advclass/orphanadv/wwastrel
	title= "Weary Wastrel"
	tutorial = "WARNING: THIS CLASS IS EXTREMELY DIFFICULT!  All the other \
	children may be smart, fast, strong, or useful in some way, but not you.  \
	You don't have to have a function to be the best.  You know in your heart that \
	you are destined for greatness, it's just a matter of everyone else catching up \
	with your vision."
	outfit = /datum/outfit/orphanadv/wwastrel
	category_tags = list(CTAG_ORPHAN)
	attribute_sheet = /datum/attribute_holder/sheet/job/orphanadv/wwastrel
	allowed_ages = list(AGE_CHILD)
	inherit_parent_title = TRUE

/datum/job/orphanadv/wwastrel/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/orphanage_renovated = FALSE
	if(has_world_trait(/datum/world_trait/orphanage_renovated))
		orphanage_renovated = TRUE
	if(orphanage_renovated)
		spawned.adjust_stat_modifier(STATMOD_ORPHANAGE, list(
			STAT_INTELLIGENCE = 1,
		))

/datum/outfit/orphanadv/wwastrel/pre_equip(mob/living/carbon/human/equipped_human)
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

/datum/attribute_holder/sheet/job/generic_deadite
	raw_attribute_list = list(
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/outfit/vagrant/deadite/pre_equip(mob/living/carbon/human/H)
	. = ..()
	r_hand = null
	l_hand = null

/datum/outfit/hunter/deadite
	r_hand = null
	l_hand = null
	beltl = null
	backl = null
	backr = /obj/item/storage/backpack/satchel/deadite_hunter
	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/flint = 1,
		/obj/item/bait = 1,
	)
	neck = null

/datum/outfit/forestwarden_classic/deadite
	r_hand = null
	l_hand = null
	beltl = null
	beltr = null
	backr = null
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/rope/chain = 1,
	)

/datum/outfit/adventurer/sfighter/deadite
	backpack_contents = null

/datum/outfit/adventurer/cleric/deadite
	backpack_contents = null

/datum/outfit/miner/deadite
	backpack_contents = null
	beltr = null
	backl = /obj/item/storage/backpack/satchel/cloth/undead_miner
	backr = null
	beltl = null

/mob/living/carbon/human/species/deadite
	ai_controller = /datum/ai_controller/human_deadite
	dodgetime = 30
	faction = list(FACTION_UNDEAD)
	var/static/list/possible_outfits = list(
		/datum/outfit/vagrant/deadite,
		/datum/outfit/prisoner,
		/datum/outfit/hunter/deadite,
		/datum/outfit/forestwarden_classic/deadite,
		/datum/outfit/adventurer/sfighter/deadite,
		/datum/outfit/adventurer/cleric/deadite,
		/datum/outfit/miner/deadite,
	)

/mob/living/carbon/human/species/deadite/Initialize()
	race = pick(NPC_RACES_TYPES)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 0.1 SECONDS)

/mob/living/carbon/human/species/deadite/after_creation()
	. = ..()
	mind_initialize()
	zombie_check()

	if(length(possible_outfits))
		equipOutfit(pick(possible_outfits))
	attributes?.add_sheet(/datum/attribute_holder/sheet/job/generic_deadite)

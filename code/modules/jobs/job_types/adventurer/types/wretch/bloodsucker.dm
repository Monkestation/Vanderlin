/datum/attribute_holder/sheet/job/bloodsucker
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/music = 60,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/carpentry = 30,
	)

/datum/job/advclass/wretch/bloodsucker
	title = "Bloodsucker"
	tutorial = "Abandoned by your clan or sired by some offspawn, you have found yourself a vampire... partially. While you do not burn in the sun, you are bound far more by your mortal blood."
	total_positions = 1

	pack_title = "Fledgling Origins"
	pack_message = "Choose your past"
	outfit = /datum/outfit/bloodsucker
	attribute_sheet = /datum/attribute_holder/sheet/job/bloodsucker
	traits = list(
		TRAIT_NOPAINSTUN,
		TRAIT_DODGEEXPERT
	)
	cmode_music = 'sound/music/cmode/antag/CombatBeest.ogg'

/datum/job/advclass/wretch/bloodsucker/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.mind)
		spawned.set_clan(/datum/clan/caitiff, TRUE)
		spawned.give_coven(/datum/coven/potence)

/datum/outfit/bloodsucker
	head = /obj/item/clothing/head/articap
	armor = /obj/item/clothing/armor/leather/jacket/courtphysician/drifter
	shirt = /obj/item/clothing/shirt/shortshirt/colored/grey
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	pants = /obj/item/clothing/pants/trou/leather/advanced
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/weapon/knife/cleaver/combat
	beltr = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/clothing/face/shepherd/rag = 1
	)

/datum/outfit/bloodsucker/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/list/eye_list = H.getorganslotlist(ORGAN_SLOT_EYES)
	for(var/obj/item/organ/eyes/eyes as anything in eye_list)
		eyes?.glows = TRUE
		eyes?.update_appearance(UPDATE_OVERLAYS)


/datum/attribute_holder/sheet/job/enforcer
	raw_attribute_list = list(
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/labor/mathematics = 30, //They use math to calculate the trajectory of attacks, so they can parry behind them, trust, ook told me
	)

/datum/job/advclass/mercenary/enforcer
	title = "Enforcer"
	tutorial = "You're an exiled enforcer that took refuges in the valorian regions long ago, near the beginning of Z's ascension, robed in black, and known for wild antics, loose camaraderie and a huge hatred for dark elves and the descendants of Zizo, You once used your blade to shake down anyone who hasn't paid their 'protection fees', nowadays, you will fight for anyone for the right price."
	allowed_races = list(SPEC_ID_ELF, SPEC_ID_HUMEN, SPEC_ID_HALF_ELF)
	outfit = /datum/outfit/mercenary/enforcer
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/Combat_Weird.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/enforcer

	traits = list(
		TRAIT_NOPAINSTUN,
		TRAIT_BREADY,
		TRAIT_BLINDFIGHTING,
		TRAIT_UNDODGING, //They can't dodge at all. This also mean that if they don't have anything to parry with, they're done.
	)

/datum/job/advclass/mercenary/enforcer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/enforcer
	name = "Gun-In (Mercenary)"
	var/is_leader = FALSE //does nothing except give you a cooler blade.

/datum/outfit/mercenary/enforcer/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/shirt/undershirt/easttats
	belt = /obj/item/storage/belt/leather/mercenary
	backr = /obj/item/storage/backpack/satchel
	if(H.gender == MALE)
		cloak = /obj/item/clothing/cloak/eastcloak1
		pants = /obj/item/clothing/pants/trou/leather/eastpants1
		armor = /obj/item/clothing/shirt/undershirt/eastshirt1
		gloves = /obj/item/clothing/gloves/eastgloves2
		shoes = /obj/item/clothing/shoes/boots
	else
		armor = /obj/item/clothing/armor/basiceast/captainrobe
		shoes = /obj/item/clothing/shoes/rumaclan


/datum/outfit/mercenary/enforcer/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(prob(10) && !is_leader)
		is_leader = TRUE
		var/obj/item/weapon/sword/katana/mulyeog/rumacaptain/P = new(get_turf(src))
		H.equip_to_appropriate_slot(P)
		var/obj/item/weapon/scabbard/kazengun/gold/L = new(get_turf(src))
		H.equip_to_appropriate_slot(L)
	else
		var/obj/item/weapon/sword/katana/mulyeog/rumahench/P = new(get_turf(src))
		H.equip_to_appropriate_slot(P)
		var/obj/item/weapon/scabbard/kazengun/steel/L = new(get_turf(src))
		H.equip_to_appropriate_slot(L)

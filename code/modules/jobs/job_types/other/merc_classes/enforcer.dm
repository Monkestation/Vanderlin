/datum/job/advclass/mercenary/enforcer
	title = "Enforcer"
	tutorial = "You're an exiled enforcer that took refuges in the valorian regions long ago, near the beginning of Z's ascension, robed in black, and known for wild antics, loose camaraderie and a huge hatred for dark elves and the descendants of Zizo, You once used your blade to shake down anyone who hasn't paid their 'protection fees', nowadays, you will fight for anyone for the right price."
	allowed_races = list(SPEC_ID_ELF, SPEC_ID_HUMEN, SPEC_ID_HALF_ELF)
	outfit = /datum/outfit/mercenary/enforcer
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/Combat_Weird.ogg'

	jobstats = list(
		STATKEY_CON = 3,
		STATKEY_END = 2,
		STATKEY_PER = 1,
		STATKEY_INT = -1,
		STATKEY_SPD = -2,
	) //7 - Statline - The Idea is that they're tanky and supposed to be able to block hits for a longer time, hence higher CON and END

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/medicine = 2,
		/datum/skill/labor/mathematics = 3, //They use math to calculate the trajectory of attacks, so they can parry behind them, trust, ook told me
	)

	traits = list(
		TRAIT_HARDDISMEMBER,
		TRAIT_NOPAINSTUN,
		TRAIT_BREADY,
		TRAIT_BLINDFIGHTING,
		TRAIT_UNDODGING, //They can't dodge at all. This also mean that if they don't have anything to parry with, they're done.
	)

/datum/job/advclass/mercenary/enforcer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9

/datum/outfit/mercenary/enforcer
	name = "Gun-In"
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

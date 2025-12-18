/datum/job/advclass/pilgrim/rare/crusader
	title = "Totod Order Emissary"
	tutorial = "The Crusaders are knights who have pledged their wealth and lands to the church, \
	taking up the banner of the Totod Order dedicated to retaking the Barrows against the forces of Zizo. \
	Three cults provide knights for the Order: Astrata, Necra and Ravox. \
	You were sent to Vanderlin by the Order to get any and all assistance from the faithful for the Crusade."
	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/divine/necra, /datum/patron/divine/ravox)
	outfit = /datum/outfit/adventurer/crusader
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 1
	roll_chance = 30
	is_recognized = TRUE

	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/divine/necra, /datum/patron/divine/ravox)

/datum/outfit/adventurer/crusader/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/helmet/heavy/crusader
	neck = /obj/item/clothing/neck/coif/cloth
	armor = /obj/item/clothing/armor/chainmail/hauberk
	cloak = /obj/item/clothing/cloak/cape/crusader
	gloves = /obj/item/clothing/gloves/chain
	shirt = /obj/item/clothing/shirt/tunic/colored/random
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/silver

	switch(H.patron?.name)
		if("Astrata")
			H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata // Gold for Astrata regardless of gender
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
		if("Necra")
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			wrists = /obj/item/clothing/neck/psycross/silver/necra
		else // Failsafe
			H.cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox // Gold version regardless of gender or patron
			wrists = /obj/item/clothing/neck/psycross/silver/ravox

	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_STR, 1)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	if(H.dna?.species)
		if(H.dna.species.id == SPEC_ID_HUMEN)
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	// Females are crossbow and dagger based
	if(H.gender == FEMALE)
		head = /obj/item/clothing/head/helmet/heavy/crusader/t
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		beltl = /obj/item/weapon/knife/dagger/silver
		beltr = /obj/item/ammo_holder/quiver/bolts
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		backl = /obj/item/storage/backpack/satchel/black
		backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1)
	// Males are sword and shield based
	else
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		beltr = /obj/item/storage/belt/pouch/coins/rich
	// Finally, grant us the language

	if(!H.has_language(/datum/language/oldpsydonic))
		H.grant_language(/datum/language/oldpsydonic)
		to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")

/datum/outfit/adventurer/crusader // Reminder message
	var/tutorial = "<br><br><font color='#bdc34a'><span class='bold'>You have been sent from the Totod Order on a mission to aid your struggle against the Blood Barons somehow. The details of your mission may vary, perhaps to find allies, funding, or a agent of the enemy...</span></font><br><br>"

/datum/outfit/adventurer/crusader/post_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, tutorial)


/obj/item/clothing/cloak/stabard/crusader
	name = "surcoat of the golden order"
	desc = "A surcoat drenched in charcoal water, golden thread stitched in the style of Psydon's Knights of Old Psydonia."
	icon_state = "crusader_surcoat"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/cloak/stabard/crusader/t
	name = "surcoat of the silver order"
	desc = "A surcoat drenched in charcoal water, white cotton stitched in the symbol of Psydon."
	icon_state = "crusader_surcoatt2"

/obj/item/clothing/cloak/cape/crusader
	name = "desert cape"
	desc = "Zaladin is known for its legacies in tailoring, this particular cape is interwoven with fine stained silks and leather - a sand elf design, renowned for its style and durability."
	icon_state = "crusader_cloak"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/head/helmet/heavy/crusader
	name = "bucket helm"
	desc = "Proud knights of the Totod order displays their faith and their allegiance openly."
	icon_state = "totodhelm"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/helmet/heavy/crusader/t
	desc = "A silver gilded bucket helm, inscriptions in old Psydonic are found embezeled on every inch of silver. Grenzelhoft specializes in these helmets, the Totod order has been purchasing them en-masse."
	icon_state = "crusader_helmt2"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	bloody_icon = 'icons/effects/blood.dmi'
	bloody_icon_state = "itemblood"
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/clothing/cloak/cape/crusader/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak/lord)

/obj/item/clothing/cloak/cape/crusader/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

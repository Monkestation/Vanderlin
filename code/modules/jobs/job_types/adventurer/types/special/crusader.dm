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

	jobstats = list(
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1
	)

	skills = list(
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/shields = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/sewing = 1,
		/datum/skill/craft/cooking = 1
	)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR
	)

	languages = list(/datum/language/oldpsydonic)

/datum/job/advclass/pilgrim/rare/crusader/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
		else
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	if(spawned.gender == FEMALE)
		spawned.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	else
		spawned.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)

	if(spawned.dna?.species?.id == SPEC_ID_HUMEN && spawned.gender == MALE)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	to_chat(spawned, "<br><br><font color='#bdc34a'><span class='bold'>You have been sent from the Totod Order on a mission to aid your struggle against the Blood Barons somehow. The details of your mission may vary, perhaps to find allies, funding, or a agent of the enemy...</span></font><br><br>")

/datum/outfit/adventurer/crusader
	name = "Totod Order Emissary (Adventurer)"
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

/datum/outfit/adventurer/crusader/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			wrists = /obj/item/clothing/neck/psycross/silver/necra
		else
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			wrists = /obj/item/clothing/neck/psycross/silver/ravox

	if(equipped_human.gender == FEMALE)
		head = /obj/item/clothing/head/helmet/heavy/crusader/t
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		beltl = /obj/item/weapon/knife/dagger/silver
		beltr = /obj/item/ammo_holder/quiver/bolts
		backl = /obj/item/storage/backpack/satchel/black
		backpack_contents = list(/obj/item/storage/belt/pouch/coins/rich = 1)
	else
		beltr = /obj/item/storage/belt/pouch/coins/rich

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

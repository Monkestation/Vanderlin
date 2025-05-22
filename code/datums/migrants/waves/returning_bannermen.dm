/datum/migrant_role/sergeant_at_arms
	name = "Serjeant-At-Arms"
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, you and the mens under your command have returned upon fullfiling your task."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	grant_lit_torch = TRUE
	is_foreigner = FALSE
	outfit = /datum/outfit/job/serjeant_at_arms

/datum/outfit/job/serjeant_at_arms/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/leather
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/half/vet
	shirt = /obj/item/clothing/shirt/undershirt/guardsecond
	armor = /obj/item/clothing/armor/medium/scale
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	beltl = /obj/item/storage/keyring/guard
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1, /obj/item/signal_horn = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_STR, 3)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_INT, 2)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_SPD, 1)
	else
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_INT, 2)
		H.change_stat(STATKEY_END, 2)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'
	H.verbs |= /mob/proc/haltyell

/datum/migrant_role/archer_bannerman
	name = "Bannermen Archer"
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, you and your serjeant-at-arms have returned upon fullfiling your task."
	outfit = /datum/outfit/job/archer_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	grant_lit_torch = TRUE
	is_foreigner = FALSE
/datum/outfit/job/archer_bannerman/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	shirt = /obj/item/clothing/shirt/shortshirt/merc
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/guard
	beltr = /obj/item/ammo_holder/quiver/arrows
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)
	if(prob(30))
		head = /obj/item/clothing/head/helmet/kettle
	else
		head = pick(/obj/item/clothing/head/roguehood/guard, /obj/item/clothing/head/roguehood/guardsecond)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/migrant_role/crossbow_bannerman
	name = "Bannermen Crossbowman"
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, you and your serjeant-at-arms have returned upon fullfiling your task."
	outfit = /datum/outfit/job/crossbow_bannerman
	allowed_races = list("Humen","Dwarf","Aasimar", "Half-Elf", "Elf")
	grant_lit_torch = TRUE
	is_foreigner = FALSE

/datum/outfit/job/crossbow_bannerman/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	shirt = /obj/item/clothing/shirt/shortshirt/merc
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	beltl = /obj/item/storage/keyring/guard
	beltr = /obj/item/ammo_holder/quiver/bolts
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)
	if(prob(30))
		head = /obj/item/clothing/head/helmet/kettle
	else
		head = pick(/obj/item/clothing/head/roguehood/guard, /obj/item/clothing/head/roguehood/guardsecond)

	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/migrant_role/footman_bannerman
	name = "Bannermen Footman"
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, you and your serjeant-at-arms have returned upon fullfiling your task."
	outfit = /datum/outfit/job/footman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	grant_lit_torch = TRUE
	is_foreigner = FALSE

/datum/outfit/job/footman_bannerman/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/chainmail/iron
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/nasal
	backr = /obj/item/weapon/shield/wood
	beltr = /obj/item/weapon/sword/scimitar/messer
	beltl = /obj/item/weapon/mace
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_CON, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'
	H.verbs |= /mob/proc/haltyell

/datum/migrant_role/pikeman_bannerman
	name = "Bannermen Pikeman"
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, you and your serjeant-at-arms have returned upon fullfiling your task."
	outfit = /datum/outfit/job/pikeman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	grant_lit_torch = TRUE
	is_foreigner = FALSE

/datum/outfit/job/pikeman_bannerman/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/chainmail
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/kettle
	beltr = /obj/item/weapon/sword/scimitar/messer
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather

	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_SPD, -1)
		H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

	var/weapontype = pickweight(list("Spear" = 6, "Bardiche" = 4))
	switch(weapontype)
		if("Spear")
			backr = /obj/item/weapon/polearm/spear
		if("Bardiche")
			backr = /obj/item/weapon/polearm/halberd/bardiche

/datum/migrant_wave/returning_bannermen
	name = "The Bannermen's Return"
	max_spawns = 2
	shared_wave_type = /datum/migrant_wave/knight
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down
	weight = 40
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 2,
		/datum/migrant_role/pikeman_bannerman = 2,
		/datum/migrant_role/archer_bannerman = 1,
		/datum/migrant_role/crossbow_bannerman = 1
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
		/datum/migrant_role/pikeman_bannerman = 1,
		/datum/migrant_role/archer_bannerman = 1,
		/datum/migrant_role/crossbow_bannerman = 1
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_one
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
		/datum/migrant_role/pikeman_bannerman = 1,
		/datum/migrant_role/archer_bannerman = 1,
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_two
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
		/datum/migrant_role/pikeman_bannerman = 1,
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_three
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_four
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
	)
	greet_text = "You were apart of an expedition sent by the King of Vanderlin to Kingsfield, as it is done, you now return."


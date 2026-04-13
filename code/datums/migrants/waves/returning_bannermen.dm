/datum/migrant_role/sergeant_at_arms
	name = "Serjeant-at-Arms"
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, you and those under your command have returned upon fulfilling your task."
	migrant_job = /datum/job/migrant/serjeant_at_arms

/datum/attribute_holder/sheet/job/migrant/serjeant_at_arms
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 30,
	)

/datum/attribute_holder/sheet/job/migrant/serjeant_at_arms/old
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_INTELLIGENCE = 4,
		STAT_ENDURANCE = 4,
		STAT_SPEED = 1,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 30,
	)

/datum/job/migrant/serjeant_at_arms
	title = "Serjeant-at-Arms"
	tutorial = "You were a part of an expedition sent by the Monarch to Kingsfield, you and those under your command have returned upon fulfilling your task."
	outfit = /datum/outfit/serjeant_at_arms
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/serjeant_at_arms
	attribute_sheet_old = /datum/attribute_holder/sheet/job/migrant/serjeant_at_arms/old

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/migrant/serjeant_at_arms/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/serjeant_at_arms
	name = "Serjeant-at-Arms (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/sargebarbute
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/half/vet
	shirt = /obj/item/clothing/shirt/undershirt/colored/guardsecond
	armor = /obj/item/clothing/armor/medium/scale
	neck = /obj/item/clothing/neck/gorget
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	beltl = /obj/item/storage/keyring/guard
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/signal_horn = 1,
	)

/datum/migrant_role/archer_bannerman
	name = "Bannermen Archer"
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	migrant_job = /datum/job/migrant/archer_bannerman

/datum/attribute_holder/sheet/job/migrant/archer_bannerman
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
	)

/datum/job/migrant/archer_bannerman
	title = "Bannermen Archer"
	tutorial = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	outfit = /datum/outfit/archer_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/archer_bannerman

	traits = list(
		TRAIT_DODGEEXPERT,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/outfit/archer_bannerman
	name = "Bannermen Archer (Migrant Wave)"
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/bow
	shirt = /obj/item/clothing/shirt/shortshirt/colored/merc
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/guard
	beltr = /obj/item/ammo_holder/quiver/arrows
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)

/datum/outfit/archer_bannerman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(30))
		head = /obj/item/clothing/head/helmet/townbarbute
	else
		head = pick(/obj/item/clothing/head/roguehood/colored/guard, /obj/item/clothing/head/roguehood/colored/guardsecond)

/datum/migrant_role/crossbow_bannerman
	name = "Bannermen Crossbowman"
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	migrant_job = /datum/job/migrant/crossbow_bannerman

/datum/attribute_holder/sheet/job/migrant/crossbow_bannerman
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/lockpicking = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
	)

/datum/job/migrant/crossbow_bannerman
	title = "Bannermen Crossbowman"
	tutorial = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	outfit = /datum/outfit/crossbow_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/crossbow_bannerman

	traits = list(
		TRAIT_DODGEEXPERT,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/outfit/crossbow_bannerman
	name = "Bannermen Crossbowman (Migrant Wave)"
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/bow/cross
	shirt = /obj/item/clothing/shirt/shortshirt/colored/merc
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/guard
	beltr = /obj/item/ammo_holder/quiver/bolts
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)

/datum/outfit/crossbow_bannerman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(30))
		head = /obj/item/clothing/head/helmet/townbarbute
	else
		head = pick(/obj/item/clothing/head/roguehood/colored/guard, /obj/item/clothing/head/roguehood/colored/guardsecond)

/datum/migrant_role/footman_bannerman
	name = "Bannermen Footman"
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	migrant_job = /datum/job/migrant/footman_bannerman

/datum/attribute_holder/sheet/job/migrant/footman_bannerman
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
	)


/datum/job/migrant/footman_bannerman
	title = "Bannermen Footman"
	tutorial = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	outfit = /datum/outfit/footman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/footman_bannerman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/migrant/footman_bannerman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/footman_bannerman
	name = "Bannermen Footman (Migrant Wave)"
	armor = /obj/item/clothing/armor/cuirass/iron
	shirt = /obj/item/clothing/armor/chainmail/iron
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/townbarbute
	backr = /obj/item/weapon/shield/wood
	beltr = /obj/item/weapon/sword/scimitar/messer
	beltl = /obj/item/weapon/mace
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather

/datum/migrant_role/pikeman_bannerman
	name = "Bannermen Pikeman"
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	migrant_job = /datum/job/migrant/pikeman_bannerman

/datum/attribute_holder/sheet/job/migrant/pikeman_bannerman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/migrant/pikeman_bannerman
	title = "Bannermen Pikeman"
	tutorial = "You were a part of an expedition sent by the Monarch to Kingsfield, you and your serjeant-at-arms have returned upon fulfilling your task."
	outfit = /datum/outfit/pikeman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/pikeman_bannerman

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/migrant/pikeman_bannerman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/pikeman_bannerman
	name = "Bannermen Pikeman (Migrant Wave)"
	armor = /obj/item/clothing/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/armor/gambeson
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/townbarbute
	beltr = /obj/item/weapon/sword/scimitar/messer
	pants = /obj/item/clothing/pants/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather

/datum/outfit/pikeman_bannerman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
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
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."

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
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."

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
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."

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
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_three
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
	)
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."

/datum/migrant_wave/returning_bannermen_down_four
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
	)
	greet_text = "You were a part of an expedition sent by the Monarch to Kingsfield, as it is done, you now return."


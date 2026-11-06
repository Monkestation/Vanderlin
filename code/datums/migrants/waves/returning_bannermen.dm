/datum/migrant_role/sergeant_at_arms
	name = "Bannermen Leader"
	greet_text = "You were a part of an expedition sent far away by the Monarch, you and those under your command have now returned. Now you should report how your mission went!"
	migrant_job = /datum/job/migrant/serjeant_at_arms

/datum/attribute_holder/sheet/job/migrant/serjeant_at_arms
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/swords = 35,
		/datum/attribute/skill/combat/shields = 35,
		/datum/attribute/skill/combat/wrestling = 35,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 10,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 15,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/educated/reading = 10,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/migrant/serjeant_at_arms
	title = "Bannermen Leader" // Not "Serjeant-At-Arms" to avoid them getting pay by default, so they are forced to interact with the Monarch, Captain or Steward.
	tutorial = "You were a part of an expedition sent far away by the Monarch, you and those under your command have now returned. Now you should report how your mission went!"
	outfit = /datum/outfit/serjeant_at_arms
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_GARRISON ,EXP_TYPE_COMBAT)
	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/serjeant_at_arms

	jobs_i_always_know = list(JOB_MONARCH, JOB_HAND, JOB_GUARD_CAPTAIN)
	jobs_always_know_me = list(JOB_MONARCH, JOB_HAND, JOB_GUARD_CAPTAIN)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/job/migrant/serjeant_at_arms/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/serjeant_at_arms
	name = "Serjeant-at-Arms (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/visored/sallet
	cloak = /obj/item/clothing/cloak/stabard/guard
	armor = /obj/item/clothing/armor/brigandine
	neck = /obj/item/clothing/neck/bevor
	shirt = /obj/item/clothing/armor/gambeson/arming
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/leather/advanced/watch
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/natural/cloth/bandage = 1,
		/obj/item/storage/keyring/guard = 1,
		/obj/item/signal_horn = 1
		)
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/short

/datum/migrant_role/archer_bannerman
	name = "Bannermen Archer"
	greet_text = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	migrant_job = /datum/job/migrant/archer_bannerman

/datum/attribute_holder/sheet/job/migrant/archer_bannerman
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/bows = 35,
		/datum/attribute/skill/combat/crossbows = 35,
		/datum/attribute/skill/combat/knives = 35,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/climbing = 45,
		/datum/attribute/skill/misc/swimming = 25,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/educated/reading = 10
	)

/datum/job/migrant/archer_bannerman
	title = "Bannermen Archer"
	tutorial = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	outfit = /datum/outfit/archer_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/archer_bannerman

	jobs_i_always_know = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)
	jobs_always_know_me = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)

	traits = list(
		TRAIT_DODGEEXPERT,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/outfit/archer_bannerman
	name = "Bannermen Archer (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/watchmen
	cloak = /obj/item/clothing/cloak/stabard/guard
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/shirt/guard
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/gun/ballistic/bow
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/natural/cloth/bandage = 1,
		/obj/item/storage/keyring/guard = 1
		)
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows

/datum/outfit/archer_bannerman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(30))
		head = /obj/item/clothing/head/helmet/townbarbute
	else
		head = pick(/obj/item/clothing/head/roguehood/colored/guard, /obj/item/clothing/head/roguehood/colored/guardsecond)

/datum/outfit/crossbow_bannerman/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(30))
		head = /obj/item/clothing/head/helmet/townbarbute
	else
		head = pick(/obj/item/clothing/head/roguehood/colored/guard, /obj/item/clothing/head/roguehood/colored/guardsecond)

/datum/migrant_role/footman_bannerman
	name = "Bannermen Footman"
	greet_text = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	migrant_job = /datum/job/migrant/footman_bannerman

/datum/attribute_holder/sheet/job/migrant/footman_bannerman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/combat/shields = 35,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/wrestling = 25,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/climbing = 35,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 25,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/armor_repair = 10,
		/datum/attribute/skill/craft/weapon_repair = 10,
		/datum/attribute/skill/educated/reading = 10
	)

/datum/job/migrant/footman_bannerman
	title = "Bannermen Footman"
	tutorial = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	outfit = /datum/outfit/footman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/footman_bannerman

	jobs_i_always_know = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)
	jobs_always_know_me = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)

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
	head = /obj/item/clothing/head/helmet/watchmen
	cloak = /obj/item/clothing/cloak/stabard/guard
	armor = /obj/item/clothing/armor/cuirass/iron
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/shirt/guard
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard
	pants = /obj/item/clothing/pants/guard
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/weapon/shield/wood
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/natural/cloth/bandage = 1,
		/obj/item/storage/keyring/guard = 1
		)
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/scimitar/messer

/datum/migrant_role/pikeman_bannerman
	name = "Bannermen Pikeman"
	greet_text = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	migrant_job = /datum/job/migrant/pikeman_bannerman

/datum/attribute_holder/sheet/job/migrant/pikeman_bannerman
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/polearms = 35,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/axesmaces = 25,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/climbing = 35,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 25,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/labor/lumberjacking = 10,
		/datum/attribute/skill/educated/reading = 10
	)

/datum/job/migrant/pikeman_bannerman
	title = "Bannermen Pikeman"
	tutorial = "You were a part of an expedition sent far away by the Monarch, you and your Serjeant-at-Arms have returned to report your deeds."
	outfit = /datum/outfit/pikeman_bannerman
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	is_foreigner = FALSE
	exp_types_granted  = list(EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/pikeman_bannerman

	jobs_i_always_know = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)
	jobs_always_know_me = list(JOB_GUARD_CAPTAIN, JOB_CITY_WATCH_LIEUTENANT)

	traits = list(
		TRAIT_MEDIUMARMOR,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

/datum/job/migrant/pikeman_bannerman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/proc/haltyell)

/datum/outfit/pikeman_bannerman
	name = "Bannermen Pikeman (Migrant Wave)"
	head = /obj/item/clothing/head/helmet/watchmen
	cloak = /obj/item/clothing/cloak/stabard/guard
	armor = /obj/item/clothing/armor/cuirass/fluted/iron
	neck = /obj/item/clothing/neck/gorget
	shirt = /obj/item/clothing/shirt/guard
	wrists = /obj/item/clothing/wrists/bracers/iron
	pants = /obj/item/clothing/pants/guard
	shoes = /obj/item/clothing/shoes/boots/leather
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/reagent_containers/food/snacks/hardtack = 1,
		/obj/item/reagent_containers/glass/bottle/water = 1,
		/obj/item/natural/cloth/bandage = 1,
		/obj/item/storage/keyring/guard = 1
		)
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/axe/iron

/datum/job/migrant/pikeman_bannerman/on_roundstart(mob/living/carbon/human/equipped_human, client/player_client)
	. = ..()
	var/static/list/weapons = list("Spear", "Bardiche")
	var/weapon_choice = browser_input_list(equipped_human, "CHOOSE YOUR WEAPON.", "FOR THE CROWN.", weapons)
	switch(weapon_choice)
		if("Spear")
			equipped_human.equip_to_slot_or_del(new /obj/item/weapon/polearm/spear, ITEM_SLOT_BACK_R, TRUE)
		if("Bardiche")
			equipped_human.equip_to_slot_or_del(new /obj/item/weapon/polearm/halberd/bardiche, ITEM_SLOT_BACK_R, TRUE)

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
		/datum/migrant_role/archer_bannerman = 2
	)
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."

/datum/migrant_wave/returning_bannermen_down
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
		/datum/migrant_role/pikeman_bannerman = 1,
		/datum/migrant_role/archer_bannerman = 2
	)
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."

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
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."

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
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."

/datum/migrant_wave/returning_bannermen_down_three
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	downgrade_wave = /datum/migrant_wave/returning_bannermen_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
		/datum/migrant_role/footman_bannerman = 1,
	)
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."

/datum/migrant_wave/returning_bannermen_down_four
	name = "The Bannermen's Return"
	shared_wave_type = /datum/migrant_wave/returning_bannermen
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/sergeant_at_arms = 1,
	)
	greet_text = "You were a part of an expedition sent far away by the Monarch, now you return."


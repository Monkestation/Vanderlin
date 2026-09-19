/datum/attribute_holder/sheet/job/battlemage
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/magic/arcane = 10,
		/datum/attribute/skill/craft/alchemy = 10
	)

/datum/attribute_holder/sheet/job/battlemage/axesmaces
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/axesmaces = list(30, 30)
	)

/datum/attribute_holder/sheet/job/battlemage/swords
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(30, 30)
	)

/datum/attribute_holder/sheet/job/battlemage/polearms
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(30, 30)
	)

/datum/attribute_holder/sheet/job/battlemage/shields
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/shields = list(20, 20)
	)

/datum/job/advclass/mercenary/battlemage
	title = "Battlemage"
	tutorial = "A warrior who has dabbled in the arts of magic, you blend swordplay and spellcraft to earn your keep."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/battlemage
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	magic_user = TRUE
	form_points = 3
	technique_points = 1

	traits = list(
		TRAIT_SORCERER,
	)

	attribute_sheet = /datum/attribute_holder/sheet/job/battlemage

	spells = list(
		/datum/action/cooldown/spell/undirected/touch/prestidigitation,
		/datum/action/cooldown/spell/bind_weapon,
		/datum/action/cooldown/spell/recall_weapon,
		/datum/action/cooldown/spell/empower_weapon,
		/datum/action/cooldown/spell/essence/mend/spell,
	)

/datum/job/advclass/mercenary/battlemage/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 9
	spawned.adjust_technique_mastery_points(2, FALSE, TECHNIQUE_IMBUE)

	var/obj/item/clothing/armor/brigandine/color_armor = new(get_turf(equipped_human))
	var/static/list/specials = list("Swords", "Polearms", "Maces", "Freeform")

	browser_input_list(spawned, "CHOOSE YOUR SPECIALIZATION.", "BATTLEMAGE TRAINING.", specials)
	switch(specials)
		if("Swords")
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/swords)
			var/static/list/weapons = list(
				"Arming Sword" = /obj/item/weapon/sword/arming,
				"Longsword" = /obj/item/weapon/sword/long,
				"Shortsword + Shield" = /obj/item/weapon/sword/short
			)
			var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "MAGIC ARMS.")
			switch(weapon_choice)
				if("Shortsword + Shield")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/shields)
					spawned.put_in_hands(new /obj/item/weapon/shield/heater(get_turf(spawned)), TRUE)
			color_armor.color = "#50090f"
		if("Polearms")
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/arcane_phalanx)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/projectile/pilum)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/advance)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/polearms)
			var/static/list/weapons = list(
				"Spear" = /obj/item/weapon/polearm/spear/steel,
				"Quarterstaff" = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel
			)
			var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "MAGIC ARMS.")
			color_armor.color = "#2a2459"
		if("Maces")
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/charge)
			spawned.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/axesmaces)
			var/static/list/weapons = list(
				"Mace" = /obj/item/weapon/mace/steel,
				"Warclub" = /obj/item/weapon/mace/goden/steel,
				"Warhammer + Shield" = /obj/item/weapon/mace/warhammer/steel
			)
			var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "MAGIC ARMS.")
			switch(weapon_choice)
				if("Warhammer + Shield")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/shields)
					spawned.put_in_hands(new /obj/item/weapon/shield/heater(get_turf(spawned)), TRUE)
			color_armor.color = "#517b27"
		if("Freeform")
			var/static/list/weapons = list(
				"Arming Sword" = /obj/item/weapon/sword/arming,
				"Longsword" = /obj/item/weapon/sword/long,
				"Shortsword + Shield" = /obj/item/weapon/sword/short
				"Spear" = /obj/item/weapon/polearm/spear/steel,
				"Quarterstaff" = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel
				"Mace" = /obj/item/weapon/mace/steel,
				"Warclub" = /obj/item/weapon/mace/goden/steel,
				"Warhammer + Shield" = /obj/item/weapon/mace/warhammer/steel
			)
			var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "MAGIC ARMS.")
			switch(weapon_choice)
				if("Arming Sword" || "Longsword" || "Shortsword + Shield")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/swords)
				if("Spear" || "Quarterstaff")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/polearms)
				if("Mace" || "Warclub" || "Warhammer + Shield")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/axesmaces)
				if("Shortsword + Shield" || "Warhammer + Shield")
					spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/battlemage/shields)
					spawned.put_in_hands(new /obj/item/weapon/shield/heater(get_turf(spawned)), TRUE)
			color_armor.color = "#7e632c"
		spawned.equip_to_slot(color_armor, ITEM_SLOT_ARMOR, TRUE)

/datum/outfit/mercenary/battlemage
	name = "Battlemage (Mercenary)"
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/shirt/tunic
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltl = /obj/item/storage/magebag/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/dagger = 1,
		/obj/item/reagent_containers/glass/bottle/manapot/labelled = 1,
		/obj/item/chalk = 1
	)

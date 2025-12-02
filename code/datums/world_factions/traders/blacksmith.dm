/mob/living/simple_animal/hostile/retaliate/blacksmith
	name = "Blacksmith"
	desc = "Come buy some!"
	unique_name = FALSE
	maxHealth = 200
	health = 200
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	move_resist = MOVE_FORCE_STRONG
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 0
	cmode = FALSE

	///Sound used when item sold/bought
	var/sell_sound = 'sound/blank.ogg'
	///The currency name
	var/currency_name = "zennies"
	///The spawner we use to create our look
	var/obj/effect/mob_spawn/human/spawner_path = /obj/effect/mob_spawn/human/dwarf/trader
	///Our species to create our look
	var/species_path = /datum/species/dwarf/mountain
	///Casing used to shoot during retaliation
	var/ranged_attack_casing = /obj/item/ammo_casing/caseless/arrow
	///Sound to make while doing a retalitory attack
	var/ranged_attack_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	///Weapon path, for visuals
	var/held_weapon_visual = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

	///Type path for the blacksmith datum to use for retrieving the blacksmiths wares, speech, etc
	var/trader_data_path = /datum/trader_data
	var/training_data_path = /datum/training_data/blacksmith


/mob/living/simple_animal/hostile/retaliate/blacksmith/Initialize(mapload, custom = FALSE, spawner_type, datum/weakref/_faction_ref)
	. = ..()

	apply_dynamic_human_appearance(src, species_path = species_path, mob_spawn_path = spawner_path, r_hand = held_weapon_visual)

	AddComponent(/datum/component/blacksmith, trader_data_path = trader_data_path, training_data_path = training_data_path)

	AddComponent(/datum/component/ranged_attacks, casing_type = ranged_attack_casing, projectile_sound = ranged_attack_sound, cooldown_time = 3 SECONDS)
	AddElement(/datum/element/ai_retaliate)

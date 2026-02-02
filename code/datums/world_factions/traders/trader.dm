/// Creates a human with the given parameters and returns an appearance of it
/proc/get_dynamic_human_appearance(outfit_path, species_path = /datum/species/human, mob_spawn_path, r_hand, l_hand, bloody_slots = NONE, animated = TRUE)
	if(!species_path)
		return FALSE
	if(!ispath(species_path))
		stack_trace("Attempted to call get_dynamic_human_appearance() with an instantiated species_path. Pass the species datum typepath instead.")
		return FALSE
	var/mob/living/carbon/human/dummy/dummy = new()
	dummy.set_species(species_path)
	dummy.stat = DEAD //this is to avoid side effects of mob spawners
	dummy.underwear = "Nude"
	dummy.undershirt = "Nude"
	dummy.socks = "Nude"
	if(outfit_path)
		var/datum/outfit/outfit = new outfit_path()
		dummy.equipOutfit(outfit, TRUE)
	else if(mob_spawn_path)
		var/obj/effect/mob_spawn/spawner = new mob_spawn_path(null, TRUE)
		spawner.special(dummy, dummy)
		spawner.equip(dummy)
	for(var/obj/item/carried_item in dummy)
		if(bloody_slots & carried_item.slot_flags)
			carried_item.add_mob_blood(dummy)
	var/mutable_appearance/output = dummy.appearance
	qdel(dummy)
	return output

/proc/apply_dynamic_human_appearance(atom/target, outfit_path, species_path = /datum/species/human, mob_spawn_path, r_hand, l_hand, bloody_slots = NONE)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(set_dynamic_human_appearance), args)

///This proc gets an argument of a target and runs
/proc/set_dynamic_human_appearance(list/arguments)
	var/atom/target = arguments[1] //1st argument is the target
	var/dynamic_appearance = get_dynamic_human_appearance(arglist(arguments.Copy(2))) //the rest of the arguments starting from 2 matter to the proc
	//target.icon = 'icons/mob/human/human.dmi'
	target.icon_state = ""
	target.appearance_flags |= KEEP_TOGETHER
	target.copy_overlays(dynamic_appearance, cut_old = TRUE)

/obj/effect/mob_spawn/human/rakshari
	mob_species = /datum/species/rakshari

/obj/effect/mob_spawn/human/rakshari/trader
	outfit = /datum/outfit/tailor

/mob/living/simple_animal/hostile/retaliate/trader
	name = "Trader"
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

	ai_controller = /datum/ai_controller/basic_controller/trader

	/// Reference to the faction this trader represents
	var/datum/weakref/faction_ref
	/// Whether this trader needs to return to boat
	var/returning_to_boat = FALSE
	///Sound used when item sold/bought
	var/sell_sound = 'sound/blank.ogg'
	///The currency name
	var/currency_name = "zennies"
	///The spawner we use to create our look
	var/obj/effect/mob_spawn/human/spawner_path = /obj/effect/mob_spawn/human/rakshari/trader
	///Our species to create our look
	var/species_path = /datum/species/human
	///Casing used to shoot during retaliation
	var/ranged_attack_casing = /obj/item/ammo_casing/caseless/arrow
	///Sound to make while doing a retalitory attack
	var/ranged_attack_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	///Weapon path, for visuals
	var/held_weapon_visual = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

	///Type path for the trader datum to use for retrieving the traders wares, speech, etc
	var/trader_data_path = /datum/trader_data


/mob/living/simple_animal/hostile/retaliate/trader/Initialize(mapload, custom = FALSE, spawner_type, datum/weakref/_faction_ref)
	. = ..()
	if(spawner_type)
		spawner_path = spawner_type
	var/datum/world_faction/faction = _faction_ref?.resolve()
	faction_ref = _faction_ref
	if(faction)
		name = "[faction.faction_name] Trader"
		desc = "A trader from the [faction.faction_name]."

	apply_dynamic_human_appearance(src, species_path = initial(spawner_path.mob_species), mob_spawn_path = spawner_path, r_hand = held_weapon_visual)

	if(!custom)
		var/datum/trader_data/trader_data = new trader_data_path
		AddComponent(/datum/component/trader, trader_data = trader_data)
		var/datum/action/setup_shop/setup_shop = new (src, trader_data.shop_spot_type, trader_data.sign_type, trader_data.sell_sound, trader_data.say_phrases[TRADER_SHOP_OPENING_PHRASE])
		setup_shop.Grant(src)
		ai_controller.set_blackboard_key(BB_SETUP_SHOP, setup_shop)

	AddComponent(/datum/component/ranged_attacks, casing_type = ranged_attack_casing, projectile_sound = ranged_attack_sound, cooldown_time = 3 SECONDS)
	AddElement(/datum/element/ai_retaliate)

/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/proc/set_custom_trade(datum/trader_data/trader_data)
	AddComponent(/datum/component/trader, trader_data = trader_data)
	var/datum/action/setup_shop/setup_shop = new (src, trader_data.shop_spot_type, trader_data.sign_type, trader_data.sell_sound, trader_data.say_phrases[TRADER_SHOP_OPENING_PHRASE])
	setup_shop.Grant(src)
	ai_controller.set_blackboard_key(BB_SETUP_SHOP, setup_shop)

	var/datum/world_faction/faction = faction_ref?.resolve()
	if(faction)
		name = "[faction.faction_name] [trader_data.name] Trader"
		desc = "A [lowertext(trader_data.name)] trader from the [faction.faction_name]."

/mob/living/simple_animal/hostile/retaliate/trader/proc/return_to_boat()
	returning_to_boat = TRUE
	say(pick(list("Time to head back to the ship!", "The captain calls!", "My voyage here is complete.")))
	var/obj/effect/landmark/stall/stall = ai_controller.blackboard[BB_SHOP_SPOT]
	if(istype(stall))
		stall.claimed_by_trader = FALSE

	// Set AI to move back to boat
	var/obj/structure/industrial_lift/tram/boat_platform = SSmerchant.cargo_boat?.lift_platforms?[1]
	if(boat_platform)
		ai_controller?.set_blackboard_key(BB_CURRENT_MIN_MOVE_DISTANCE, 0)
		ai_controller?.set_movement_target(src, boat_platform)

	// Clean up shop
	var/datum/action/setup_shop/shop_action = locate() in actions
	if(shop_action)
		var/obj/shop_spot = shop_action.shop_spot_ref?.resolve()
		var/obj/sign = shop_action.sign_ref?.resolve()
		qdel(shop_spot)
		qdel(sign)

/mob/living/simple_animal/hostile/retaliate/trader/Destroy()
	var/obj/effect/landmark/stall/stall = ai_controller.blackboard[BB_SHOP_SPOT]
	if(istype(stall))
		stall.claimed_by_trader = FALSE
	var/datum/action/setup_shop/shop_action = locate() in actions
	if(shop_action)
		var/obj/shop_spot = shop_action.shop_spot_ref?.resolve()
		var/obj/sign = shop_action.sign_ref?.resolve()
		qdel(shop_spot)
		qdel(sign)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/trader/death(gibbed)
	. = ..()
	var/obj/effect/landmark/stall/stall = ai_controller.blackboard[BB_SHOP_SPOT]
	if(istype(stall))
		stall.claimed_by_trader = FALSE
	var/datum/action/setup_shop/shop_action = locate() in actions
	if(shop_action)
		var/obj/shop_spot = shop_action.shop_spot_ref?.resolve()
		var/obj/sign = shop_action.sign_ref?.resolve()
		qdel(shop_spot)
		qdel(sign)

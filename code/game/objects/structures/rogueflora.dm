#define SEARCHTIME 1.2 SECONDS
#define BUSH_PRIMARY_LOOT_CHANCE 88
#define BUSH_BONUS_LOOT_CHANCE 66

// Base Flora
/obj/structure/flora
	var/num_random_icons = 0
	layer = FLORA_LAYER

/obj/structure/flora/Initialize()
	. = ..()
	if(num_random_icons)
		icon_state = "[base_icon_state][rand(1, num_random_icons)]"

//newtree
/obj/structure/flora/tree
	name = "old tree"
	desc = "An old, wicked tree that not even elves could love."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1"
	base_icon_state = "t"
	num_random_icons = 16
	opacity = TRUE
	density = TRUE
	max_integrity = 200
	blade_dulling = DULLING_CUT
	SET_BASE_PIXEL(-16, 0)
	plane = GAME_PLANE_UPPER
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 1)
	var/stump_type = /obj/structure/table/wood/treestump
	metalizer_result = /obj/machinery/light/fueledstreet
	smeltresult = /obj/item/ore/coal

/obj/structure/flora/tree/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = browser_input_list(user, "What will I take?", "STASH", user.mind.special_items)
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/flora/tree/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(atom_integrity <= 0)
		record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
		record_round_statistic(STATS_TREES_CUT)

/obj/structure/flora/tree/fire_act(added, maxstacks)
	if(added > 5)
		return ..()

/obj/structure/flora/tree/Initialize()
	. = ..()
	if(istype(loc, /turf/open/floor/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/dirt)

/obj/structure/flora/tree/atom_destruction(damage_flag)
	if(stump_type)
		new stump_type(loc)
	return ..()

/obj/structure/flora/tree/evil
	base_icon_state = "wv"
	num_random_icons = 2
	var/datum/looping_sound/boneloop/soundloop
	var/datum/vine_controller/controller

/obj/structure/flora/tree/evil/Initialize()
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()

/obj/structure/flora/tree/evil/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	if(controller)
		controller.endvines()
		controller = null
	return ..()

/obj/structure/flora/tree/wise
	name = "wise tree"
	desc = "Dendor's favored. It seems to watch you with ancient awareness."
	icon_state = "mystical"
	var/activated = FALSE
	var/cooldown = FALSE
	var/retaliation_messages = list(
		"LEAVE FOREST ALONE!",
		"DENDOR PROTECTS!",
		"NATURE'S WRATH!",
		"BEGONE, INTERLOPER!",
		"BEGONE, DESTROYER!",
		"NATURE SHALL PREVAIL!",
		"NATURE SHALL RECLAIM THE LAND!",
		"LEAVE US BE!",
		"YOU HAVE DESTROYED ENOUGH!",
		"DENDOR SMITES THE INTERLOPERS!",
		"DENDOR SMITES THE DESTROYERS!",
	)

/obj/structure/flora/tree/wise/Initialize()
	. = ..()
	for(var/obj/structure/flora/tree/normal_tree in range(5, src))
		if(normal_tree != src && !istype(normal_tree, /obj/structure/flora/tree/wise))
			RegisterSignal(normal_tree, COMSIG_ATOM_ATTACKBY, TYPE_PROC_REF(/obj/structure/flora/tree/wise, protect_nearby_trees))
			RegisterSignal(normal_tree, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/obj/structure/flora/tree/wise, cleanup_tree))
	for(var/obj/structure/flora/newtree/new_tree in range(5, src))
		if(!new_tree.burnt)
			RegisterSignal(new_tree, COMSIG_ATOM_ATTACKBY, TYPE_PROC_REF(/obj/structure/flora/tree/wise, protect_nearby_trees))
			RegisterSignal(new_tree, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/obj/structure/flora/tree/wise, cleanup_tree))

/obj/structure/flora/tree/wise/proc/cleanup_tree(datum/source)
	UnregisterSignal(source, list(COMSIG_ATOM_ATTACKBY, COMSIG_PARENT_QDELETING))

/obj/structure/flora/tree/wise/Destroy()
	for(var/obj/structure/flora/tree/normal_tree in range(5, src))
		UnregisterSignal(normal_tree, list(COMSIG_ATOM_ATTACKBY, COMSIG_PARENT_QDELETING))
	for(var/obj/structure/flora/newtree/new_tree in range(5, src))
		UnregisterSignal(new_tree, list(COMSIG_ATOM_ATTACKBY, COMSIG_PARENT_QDELETING))
	return ..()

/obj/structure/flora/tree/wise/proc/protect_nearby_trees(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(!cooldown && activated)
		var/obj/structure/flora/tree/wise/closest_wise
		var/closest_distance = INFINITY
		for(var/obj/structure/flora/tree/wise/W in range(5, source))
			var/distance = get_dist(W, source)
			if(distance < closest_distance)
				closest_distance = distance
				closest_wise = W

		if(closest_wise == src)
			closest_wise.retaliate(user, source)

/obj/structure/flora/tree/wise/proc/retaliate(mob/living/target, obj/structure/flora/attacked_tree)
	if(cooldown || !istype(target) || !activated || !attacked_tree)
		return

	cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)

	var/message = pick(retaliation_messages)
	say(span_danger("[message]"))

	var/atom/throw_target = get_edge_target_turf(attacked_tree, get_dir(attacked_tree, target))
	target.throw_at(throw_target, 4, 2)
	target.Knockdown(2 SECONDS)
	target.adjustBruteLoss(8)

/obj/structure/flora/tree/wise/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(activated && !cooldown)
		retaliate(user)

/obj/structure/flora/tree/burnt
	name = "burnt tree"
	desc = "A scorched pillar of a once living tree."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "t1"
	num_random_icons = 4
	stump_type = /obj/structure/table/wood/treestump/burnt
	SET_BASE_PIXEL(-32, 0)
	metalizer_result = /obj/machinery/anvil

/obj/structure/flora/tree/underworld
	name = "screaming tree"
	desc = "humen faces everywhere."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "screaming1"
	base_icon_state = "screaming"
	num_random_icons = 3
	resistance_flags = INDESTRUCTIBLE

/obj/structure/flora/tree/stump/pine
	name = "pine stump"
	icon_state = "dead4"
	icon = 'icons/obj/flora/pines.dmi'
	static_debris = list(/obj/item/ore/coal/charcoal = 1)
	stump_type = null
	SET_BASE_PIXEL(-32, 0)

/obj/structure/flora/tree/stump/pine/Initialize()
	. = ..()
	icon_state = "dead[rand(4,5)]"

/obj/structure/flora/tree/pine
	name = "pine tree"
	desc = ""
	icon = 'icons/obj/flora/pines.dmi'
	icon_state = "pine1"
	base_icon_state = "pine"
	num_random_icons = 4
	pixel_w = -24
	density = FALSE
	max_integrity = 100
	static_debris = list(/obj/item/grown/log/tree = 2)
	stump_type = null

/obj/structure/flora/tree/pine/burn()
	new /obj/structure/flora/tree/pine/dead(get_turf(src))
	qdel(src)

/obj/structure/flora/tree/pine/dead
	name = "burnt pine tree"
	icon_state = "dead1"
	base_icon_state = "dead"
	num_random_icons = 3
	max_integrity = 50
	static_debris = list(/obj/item/ore/coal/charcoal = 1)
	resistance_flags = FIRE_PROOF
	stump_type = /obj/structure/flora/tree/stump/pine

/*	.............  Treestump   ................ */	// Treestumps are now tables, so you can tablecraft with them and so on.
/obj/structure/table/wood/treestump
	name = "tree stump"
	desc = "Someone cut this tree down."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "stumpt1"
	max_integrity = 100
	climb_time = 0
	blade_dulling = DULLING_CUT
	debris = null
	climb_offset = 14
	metalizer_result = /obj/machinery/anvil
	var/isunburnt = TRUE // Var needed for the burnt stump
	var/stump_loot = /obj/item/grown/log/tree/small

/obj/structure/table/wood/treestump/Initialize()
	. = ..()
	icon_state = "stumpt[rand(1,4)]"

/obj/structure/table/wood/treestump/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/weapon/shovel))
		to_chat(user, "I start unearthing the stump...")
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, 5 SECONDS))
			user.visible_message(
				span_notice("[user] unearths \the [src]."),
				span_notice("I unearth \the [src].")
								)
			if(isunburnt)
				new stump_loot(loc) // Rewarded with an extra small log if done the right way.return
			atom_destruction("brute")
		return
	return ..()

/obj/structure/table/wood/treestump/burnt
	name = "tree stump"
	desc = "This stump is burnt. Maybe someone is trying to get coal the easy way."
	icon = 'icons/roguetown/misc/tree.dmi'
	icon_state = "st1"
	static_debris = list(/obj/item/ore/coal = 1)
	isunburnt = FALSE

/obj/structure/table/wood/treestump/burnt/Initialize()
	. = ..()
	icon_state = "st[rand(1,2)]"

/*	.............   Ancient log   ................ */	// Functionally a sofa, slightly better than sleeping on the ground
/obj/structure/chair/bench/ancientlog
	name = "ancient log"
	desc = "A felled piece of tree long forgotten, the poorman's sofa."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "log1"
	blade_dulling = DULLING_CUT
	static_debris = list(/obj/item/grown/log/tree = 1)
	max_integrity = 200
	sleepy = 0.2
	SET_BASE_PIXEL(-14, 7)
	pass_flags_self = PASSTABLE

/obj/structure/chair/bench/ancientlog/Initialize()
	. = ..()
	icon_state = "log[rand(1,2)]"

/obj/structure/chair/bench/ancientlog/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 5)

/obj/structure/chair/bench/ancientlog/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

//newbushes
/obj/structure/flora/grass
	name = "grass"
	desc = "The kindest blades you will ever meet in this world."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "grass1"
	base_icon_state = "grass"
	num_random_icons = 6
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	max_integrity = 5
	debris = list(/obj/item/natural/fibers = 1)
	/// base % to find any useful thing in the bush, gets modded by perception
	var/prob2findstuff
	/// for harvestable
	var/islooted = FALSE
	///	for various luck based effects
	var/luckydouble

	var/list/looty = list()
	var/res_replenish
	var/bushtype

	var/guaranteed_loot = null
	var/bonus_loot = null


/obj/structure/flora/grass/spark_act()
	fire_act()

/obj/structure/flora/grass/Initialize()
	. = ..()
	AddComponent(/datum/component/grass)

/obj/structure/flora/grass/Destroy()
	if(isliving(usr) && HAS_TRAIT(usr, TRAIT_SEED_FINDER))
		new /obj/item/neuFarm/seed/mixed_seed(get_turf(src))
	else if(prob(5))
		new /obj/item/neuFarm/seed/mixed_seed(get_turf(src))
	return ..()

// Grass procs
/obj/structure/flora/grass/proc/has_searchable_loot()
	return bushtype || guaranteed_loot || bonus_loot

/obj/structure/flora/grass/attack_hand(mob/user)
	. = ..()
	if(!isliving(user) || !has_searchable_loot())
		return
	start_search_loop(user)

/obj/structure/flora/grass/proc/grass_replenish_loot()
	if(bushtype && !(bushtype in looty))
		looty += bushtype

	if(guaranteed_loot)
		for(var/path in guaranteed_loot)
			looty += path

	if(bonus_loot && prob(BUSH_BONUS_LOOT_CHANCE))
		looty += pick(bonus_loot)

/obj/structure/flora/grass/proc/start_search_loop(mob/living/user)
	while(!QDELETED(src) && !QDELETED(user))
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src, "plantcross", 80, FALSE, -1)

		if(!length(looty))
			if(world.time > res_replenish)
				grass_replenish_loot()
			else
				to_chat(user, span_warning("Picked clean... I should try later."))
				return

		if(!do_after(user, SEARCHTIME, target = src) || QDELETED(src) || QDELETED(user))
			return

		if(!prob(50))
			user.visible_message(span_warning("[user] rummages through [src]..."))
			continue

		var/obj/item/item_path = pick_n_take(looty)
		if(!item_path)
			return

		var/obj/item/found_item = new item_path(user.loc)
		user.put_in_hands(found_item)
		user.visible_message(span_notice("[user] finds [found_item] in [src]."))

		if(!length(looty))
			res_replenish = world.time + 8 MINUTES
		return

/obj/structure/flora/grass/tundra
	name = "tundra grass"
	icon_state = "tundragrass1"
	base_icon_state = "tundragrass"

/obj/structure/flora/grass/water
	desc = "This grass is sodden and muddy."
	icon_state = "swampgrass"
	num_random_icons = 0

/obj/structure/flora/grass/water/reeds
	name = "reeds"
	desc = "This plant thrives in water, and shelters dangers."
	icon_state = "reeds"
	opacity = TRUE
	layer = ABOVE_MOB_LAYER
	max_integrity = 10

/obj/structure/flora/grass/water/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/datum/component/grass/Initialize()
	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED), PROC_REF(Crossed))

/datum/component/grass/proc/Crossed(datum/source, atom/movable/AM)
	var/atom/A = parent

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_SNEAK)
			return
		else
			playsound(A, "plantcross", 90, FALSE, -1)
			var/oldx = A.pixel_x
			animate(A, pixel_x = oldx+1, time = 0.5)
			animate(pixel_x = oldx-1, time = 0.5)
			animate(pixel_x = oldx, time = 0.5)
			L.consider_ambush()

// normal bush. Oldstyle. Kept for the managed palace hedges for now.
/obj/structure/flora/grass/bush
	name = "bush"
	desc = "A bush, a den for critters and treasures."
	icon_state = "bush"
	num_random_icons = 0
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 35
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1)

	guaranteed_loot = list(/obj/item/natural/fibers)
	bonus_loot = list(/obj/item/natural/thorn)

/obj/structure/flora/grass/bush/tundra
	name = "tundra bush"
	icon_state = "bush_tundra"

/obj/structure/flora/grass/bush/Initialize()
	. = ..()
	if(prob(BUSH_PRIMARY_LOOT_CHANCE))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry=5,
					/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison=3,
					/obj/item/reagent_containers/food/snacks/produce/westleach=2))
	grass_replenish_loot()
	pixel_x += rand(-3,3)

// bush crossing
/obj/structure/flora/grass/bush/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	L.Immobilize(1 SECONDS)

	if(L.m_intent == MOVE_INTENT_RUN)
		L.visible_message(span_warning("[L] crashes into \a [src]!"), span_danger("I run into \a [src]."))
		log_combat(L, src, "ran into")
	else if(L.atom_flags & Z_FALLING)
		L.visible_message(span_warning("[L] falls onto \a [src]!"), span_danger("I fall onto \a [src]."))
		log_combat(L, src, "ran into")
	else
		to_chat(L, span_warning("I get stuck in \a [src]."))

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/was_hard_collision = (H.m_intent == MOVE_INTENT_RUN || H.throwing || H.atom_flags & Z_FALLING)
		if(was_hard_collision)
			var/obj/item/bodypart/BP = pick(H.bodyparts)
			BP.receive_damage(10)
			to_chat(H, span_warning("A thorn [pick("slices","cuts","nicks")] my [BP.name]."))
			if((prob(20)) && !HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
				var/obj/item/natural/thorn/TH = new(src.loc)
				BP.add_embedded_object(TH, silent = TRUE)
				to_chat(H, span_danger("\A [TH] impales my [BP.name]."))
				if(!HAS_TRAIT(H, TRAIT_NOPAIN))
					H.emote("painscream")
					L.Stun(3 SECONDS) //that fucking hurt
					H.consider_ambush()

/obj/structure/flora/grass/bush/wall
	name = "great bush"
	desc = "A bush, this one's roots are too thick and block the way."
	icon_state = "bushwall1"
	base_icon_state = "bushwall"
	num_random_icons = 2
	opacity = TRUE
	density = TRUE
	max_integrity = 150
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 1)
	attacked_sound = 'sound/misc/woodhit.ogg'

/obj/structure/flora/grass/bush/wall/tundra
	name = "tundra great bush"
	icon_state = "bushwall_tundra1"
	base_icon_state = "bushwall_tundra"

/obj/structure/flora/grass/bush/wall/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(ismob(mover))
		return FALSE

/obj/structure/flora/grass/bush/wall/tall
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	desc = "A tall bush that has grown into a hedge."
	icon_state = "tallbush1"
	base_icon_state = "tallbush"
	opacity = TRUE
	SET_BASE_PIXEL(-16, 0)
	num_random_icons = 2
	debris = null
	static_debris = null

/obj/structure/flora/grass/bush/wall/tall/tundra
	name = "tundra great bush"
	icon_state = "tallbush_tundra1"
	base_icon_state = "tallbush_tundra"

/obj/structure/flora/grass/bush/wall/tall/bog
	name = "bog great bush"
	desc = "A tall bush that has grown into a hedge... but this one seems diseased."
	icon_state = "tallbush_bog1"
	base_icon_state = "tallbush_bog"

// fyrituis bush
/obj/structure/flora/grass/pyroclasticflowers
	name = "odd group of flowers"
	desc = "A cluster of dangerously combustible flowers."
	icon_state = "pyroflower1"
	base_icon_state = "pyroflower"
	num_random_icons = 3
	layer = ABOVE_ALL_MOB_LAYER
	bonus_loot = list(/obj/item/reagent_containers/food/snacks/produce/fyritius)

/obj/structure/flora/grass/pyroclasticflowers/Initialize()
	. = ..()
	if(prob(BUSH_PRIMARY_LOOT_CHANCE))
		bushtype = /obj/item/reagent_containers/food/snacks/produce/fyritius
	grass_replenish_loot()
	pixel_x += rand(-3,3)

// swarmpweed bush
/obj/structure/flora/grass/swampweed
	name = "bunch of swampweed"
	desc = "A green root, good for smoking."
	icon_state = "swampweed1"
	base_icon_state = "swampweed"
	num_random_icons = 3
	bonus_loot = list(/obj/item/reagent_containers/food/snacks/produce/swampweed)

/obj/structure/flora/grass/swampweed/Initialize()
	. = ..()
	if(prob(BUSH_PRIMARY_LOOT_CHANCE))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/produce/swampweed = 1))
	grass_replenish_loot()
	pixel_x += rand(-3,3)

/obj/structure/flora/shroom_tree
	name = "shroom"
	desc = "A ginormous mushroom, prized by dwarves for their shroomwood."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "mush1"
	base_icon_state = "mush"
	density = TRUE
	num_random_icons = 5
	max_integrity = 120
	blade_dulling = DULLING_CUT
	SET_BASE_PIXEL(-16, 0)
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	static_debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/flora/shroom_tree/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = browser_input_list(user, "What will I take?", "STASH", user.mind.special_items)
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/flora/shroom_tree/Initialize()
	. = ..()
	if(icon_state == "mush5")
		static_debris = list(/obj/item/natural/thorn=1, /obj/item/grown/log/tree/small = 1)
	pixel_x += rand(8,-8)
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/shroom_tree/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) == dir)
		return
	return TRUE

/obj/structure/flora/shroom_tree/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/flora/shroom_tree/fire_act(added, maxstacks)
	if(added > 5)
		return ..()

/obj/structure/flora/shroom_tree/atom_destruction(damage_flag)
	var/obj/structure/S = new /obj/structure/table/wood/treestump/shroomstump(loc)
	S.icon_state = "stump_[icon_state]"
	return ..()

/obj/structure/table/wood/treestump/shroomstump
	name = "shroom stump"
	desc = "It was a very happy shroom. Not anymore."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "stump_mush1"
	alpha = 255
	SET_BASE_PIXEL(-16, 0)
	climb_offset = 14
	stump_loot = /obj/item/reagent_containers/food/snacks/truffles

/obj/structure/table/wood/treestump/shroomstump/Initialize()
	. = ..()
	icon_state = "stump_mush[rand(1, 5)]"

/obj/structure/roguerock
	name = "rock"
	desc = "Stone, faithful tool, weapon and companion."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "rock1"
	max_integrity = 50
	climbable = TRUE
	climb_time = 3 SECONDS
	density = TRUE
	layer = TABLE_LAYER
	blade_dulling = DULLING_BASH
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 1)

/obj/structure/roguerock/Initialize()
	. = ..()
	icon_state = "rock[rand(1, 4)]"

/*	..................   Thorn Bush   ................... */	// Updated to use searcher perception, can yield thorns
/obj/structure/flora/grass/thorn_bush
	name = "thorn bush"
	desc = "A thorny bush, bearing a bountiful collection of razor sharp thorns!"
	icon_state = "thornbush1"
	base_icon_state = "thornbush"
	num_random_icons = 2
	layer = ABOVE_ALL_MOB_LAYER
	blade_dulling = DULLING_CUT
	max_integrity = 35
	debris = list(/obj/item/natural/thorn = 3, /obj/item/grown/log/tree/stick = 1)
	prob2findstuff = 15

/obj/structure/flora/grass/thorn_bush/attack_hand(mob/living/user)
	var/mob/living/L = user
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, "plantcross", 80, FALSE, -1)
	prob2findstuff = prob2findstuff + ( user.STAPER * 4 )
	user.visible_message(span_noticesmall("[user] searches through [src]."))

	if(do_after(L, rand(5 DECISECONDS, 2 SECONDS), src))

		if(islooted)
			to_chat(user, span_warning("Picked clean."))
			return

		if(prob(prob2findstuff))
			var/obj/item/natural/thorn/B = new
			user.put_in_hands(B)
			user.visible_message(span_notice("[user] finds [B] in [src]."))
			if(prob(20))
				islooted = TRUE

		else
			if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
				user.apply_damage(5, BRUTE)
			to_chat(user, span_warning("You cut yourself on the thorns!"))

	prob2findstuff = 15

/obj/structure/flora/grass/thorn_bush/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		L.Immobilize(10)
		if(L.m_intent == MOVE_INTENT_SNEAK)
			return
		if(L.m_intent == MOVE_INTENT_WALK)
			if(!ishuman(L))
				return
			else
				to_chat(L, span_warning("I'm scratched by the thorns."))
				L.apply_damage(5, BRUTE)
				L.Immobilize(10)

		if(L.m_intent == MOVE_INTENT_RUN)
			if(!ishuman(L))
				to_chat(L, span_warning("I'm cut on a thorn!"))
				L.apply_damage(5, BRUTE)
			else
				var/mob/living/carbon/human/H = L
				if(prob(80))
					if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
						var/obj/item/bodypart/BP = pick(H.bodyparts)
						var/obj/item/natural/thorn/TH = new(src.loc)
						BP.add_embedded_object(TH, silent = TRUE)
						BP.receive_damage(10)
						to_chat(H, span_danger("\A [TH] impales my [BP.name]!"))
						L.Paralyze(10)
				else
					var/obj/item/bodypart/BP = pick(H.bodyparts)
					to_chat(H, span_warning("A thorn [pick("slices","cuts","nicks")] my [BP.name]."))
					BP.receive_damage(10)
					L.Immobilize(10)


/*	..................   Meagre Bush   ................... */	// This works on the characters stats and doesnt have a preset vendor content. Hardmode compared to the OG one.
/obj/structure/flora/grass/bush_meagre
	name = "bush"
	desc = "Home to thorns, spiders, and maybe some berries."
	icon_state = "bush1"
	base_icon_state = "bush"
	num_random_icons = 3
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 35
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1)
	prob2findstuff = 18
	var/prob2findgoodie = 15	// base % to find good stuff in the bush, gets modded by fortune and perception
	var/silky	// just for bog bushes, its part of a whole thing, don't add bog bushes outside bog
	var/goodie
	var/trashie = /obj/item/natural/thorn

/obj/structure/flora/grass/bush_meagre/tundra
	name = "tundra bush"
	icon_state = "bush_tundra1"
	base_icon_state = "bush_tundra"

/obj/structure/flora/grass/bush_meagre/yellow
	name = "bog bush"
	icon_state = "bush_bog1"
	base_icon_state = "bush_bog"

/obj/structure/flora/grass/bush_meagre/Initialize()
	. = ..()
	if(silky)
		goodie = /obj/item/natural/worms/grub_silk
		if(prob(20))
			goodie = /obj/item/reagent_containers/food/snacks/produce/poppy
	else
		if(prob(30))
			goodie = /obj/item/reagent_containers/food/snacks/produce/westleach
		else
			if(prob(60))
				goodie = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
			else
				goodie = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	pixel_x += rand(-3,3)
	if(prob(10))
		trashie = /obj/item/natural/fibers
	if(prob(70))
		debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 1)

// bush crossing
/obj/structure/flora/grass/bush_meagre/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && !HAS_TRAIT(AM, TRAIT_BRUSHWALK))
		var/mob/living/L = AM
		if(L.pulledby)
			return
		L.Immobilize(5)
		if(L.m_intent == MOVE_INTENT_WALK)
			L.Immobilize(5)
		if(L.m_intent == MOVE_INTENT_RUN)
			if(!ishuman(L))
				to_chat(L, span_warning("I'm cut on a thorn!"))
				L.apply_damage(5, BRUTE)
				L.Immobilize(5)
			else
				var/mob/living/carbon/human/H = L
				if(prob(20))
					if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
						var/obj/item/bodypart/BP = pick(H.bodyparts)
						var/obj/item/natural/thorn/TH = new(src.loc)
						BP.add_embedded_object(TH, silent = TRUE)
						BP.receive_damage(10)
						to_chat(H, span_danger("\A [TH] impales my [BP.name]!"))
						L.Paralyze(5)
				else
					var/obj/item/bodypart/BP = pick(H.bodyparts)
					to_chat(H, span_warning("A thorn [pick("slices","cuts","nicks")] my [BP.name]."))
					BP.receive_damage(10)

/obj/structure/flora/grass/bush_meagre/attack_hand(mob/living/user)
	var/mob/living/L = user
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(src, "plantcross", 80, FALSE, -1)
	prob2findstuff = prob2findstuff + ( user.STAPER * 4 )
	prob2findgoodie = prob2findgoodie + ( user.STALUC * 2 ) + ( user.STAPER * 2 )
	luckydouble = ( user.STALUC * 2 )
	user.visible_message(span_noticesmall("[user] searches through [src]."))

	if(do_after(L, rand(5 DECISECONDS, 2 SECONDS), src))

		if(islooted)
			to_chat(user, span_warning("Picked clean."))
			return

		if(prob(prob2findstuff))

			if(prob(prob2findgoodie))
				var/obj/item/B = goodie
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user] finds [B] in [src]."))
					if(HAS_TRAIT(user, TRAIT_MIRACULOUS_FORAGING))
						if(prob(35))
							return
					if(prob(luckydouble))
						return
					else
						islooted = TRUE
					return
			else
				var/obj/item/B = trashie
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user] finds [B] in [src]."))
					if(HAS_TRAIT(user, TRAIT_MIRACULOUS_FORAGING))
						if(prob(35))
							return
					if(prob(luckydouble))
						return
					else
						islooted = TRUE
					return

		else
			to_chat(user, span_noticesmall("Didn't find anything."))
	prob2findstuff = 18
	prob2findgoodie = 15
	luckydouble	= 3

/obj/structure/flora/grass/bush_meagre/bog
	desc = "These large bushes are known to be well-liked by silkworms who make their nests in their dark depths."
	icon = 'icons/mob/creacher/trolls/troll.dmi'
	icon_state = "troll_hide"
	SET_BASE_PIXEL(-16, -1)
	num_random_icons = 0
	silky = TRUE

/obj/structure/flora/grass/mushroom
	name = "leafy mushrooms"
	desc = "A number of mushrooms, each of which surrounds a greenish sporangium with a number of leaf-like structures."
	icon_state = "l_mushroom_red1"

/obj/structure/flora/grass/mushroom/Initialize()
	. = ..()
	var/shroom_color = pick("red", "green", "blue")
	var/turf/open/floor/mushroom/turf = get_turf(src)
	if(istype(turf))
		shroom_color = turf.mushroom_color

	icon_state = "[pick(list("l", "r", "t"))]_mushroom_[shroom_color]1"

/obj/structure/flora/tree/dead_bush
	name = "dead brush"
	desc = "The blazing sun has killed this brush."
	icon_state = "deadbush_1"
	base_icon_state = "deadbush_"
	num_random_icons = 3

/obj/structure/flora/tree/dying_bush
	name = "dying brush"
	desc = "The blazing sun is killing this brush."
	icon_state = "livebush_1"
	base_icon_state = "livebush_"
	num_random_icons = 3

#undef SEARCHTIME
#undef BUSH_PRIMARY_LOOT_CHANCE
#undef BUSH_BONUS_LOOT_CHANCE

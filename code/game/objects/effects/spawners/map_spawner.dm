/obj/effect/spawner/map_spawner
	icon = 'icons/obj/structures_spawners.dmi'
	///Chance to bother spawning anything
	var/probby = 100
	/// a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect), can be weighted
	var/list/spawned
	/// how many items will be spawned, at least.
	var/lootmin = 1
	/// how many items will be spawned, at most
	var/lootmax = 1
	/// if the same item can be spawned twice
	var/lootdoubles = TRUE
	/// Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself
	var/fan_out_items = FALSE

/obj/effect/spawner/map_spawner/proc/do_spawn()
	if(prob(probby) && length(spawned))
		var/obj/new_type = pickweight(spawned)
		new new_type(get_turf(src))

/obj/effect/spawner/map_spawner/Initialize(mapload)
	. = ..()
	if(!prob(probby))
		return
	if(spawned && spawned.len > 1)
		var/turf/T = get_turf(src)
		var/loot_spawned = 0
		var/chosenamout = rand(lootmin,lootmax)
		for(var/i in 1 to chosenamout)
			if(!spawned.len)
				break
			var/lootspawn = pickweight(spawned)
			while(islist(lootspawn))
				lootspawn = pickweight(lootspawn)
			if(!lootdoubles)
				spawned.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(T)
				if (!fan_out_items)
					if (pixel_x != 0)
						spawned_loot.pixel_x = spawned_loot.base_pixel_x + pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = spawned_loot.base_pixel_y + pixel_y
				else
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.base_pixel_x + ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++
	else
		do_spawn()
	return

/obj/effect/spawner/map_spawner/pit
	icon_state = "pit"

/obj/effect/spawner/map_spawner/pit/do_spawn()
	var/turf/T = get_turf(src)
	var/turf/below = GET_TURF_BELOW(T)
	if(below)
		T.ChangeTurf(/turf/open/openspace)
		below.ChangeTurf(/turf/open/floor/dirt/road)

/obj/effect/spawner/map_spawner/tree
	icon_state = "tree"
	name = "Tree spawner"
	probby = 80
	spawned = list(/obj/structure/flora/tree)

/obj/effect/spawner/map_spawner/treeorbush
	icon_state = "Treeorbush"
	name = "Tree or bush spawner"
	probby = 50
	spawned = list(/obj/structure/flora/tree, /obj/structure/flora/grass/bush_meagre)

/obj/effect/spawner/map_spawner/treeorstump
	icon_state = "treeorstump"
	name = "Tree or stump spawner"
	probby = 50
	spawned = list(/obj/structure/flora/tree, /obj/structure/table/wood/treestump)

/obj/effect/spawner/map_spawner/stump
	icon_state = "stump"
	name = "stump spawner"
	probby = 75
	spawned = list(/obj/structure/table/wood/treestump)

/obj/effect/spawner/map_spawner/hauntpile
	icon_state = "hauntpile"
	name = "hauntpile"
	probby = 23
	spawned = list(/obj/structure/bonepile)

/obj/effect/spawner/map_spawner/beartrap
	icon_state = "beartrap"
	name = "beartrap"
	probby = 50
	spawned = list(/obj/item/restraints/legcuffs/beartrap/armed/camouflage)

/obj/effect/spawner/map_spawner/tallgrass
	icon_state = "grass"
	name = "grass tile loot spawner"
	probby = 75
	spawned = list(/obj/structure/flora/grass/bush_meagre = 10, /obj/structure/flora/grass = 60, /obj/item/natural/stone = 8, /obj/item/natural/rock = 7, /obj/item/grown/log/tree/stick = 3, /obj/structure/closet/dirthole/closed/loot=0.1)

/obj/effect/spawner/map_spawner/grass_low
	icon_state = "grass"
	name = "grass tile low loot spawner"
	probby = 50
	spawned = list(/obj/structure/flora/grass/bush_meagre = 5, /obj/structure/flora/grass = 60, /obj/item/natural/stone = 8, /obj/item/natural/rock = 4, /obj/item/grown/log/tree/stick = 2)

/*	..................   Toll randomizer (poor mans coin generator, cheaper workload is all)  ................... */
/obj/effect/spawner/map_spawner/tollrandom
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken_floor"
	probby = 25
	color = "#ff0000"
	spawned = list(
		/obj/item/underworld/coin = 1,
		)

/*	..................   Hauntz randomizer   ................... */
/obj/effect/spawner/map_spawner/hauntz_random
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "raiseskele"
	alpha = 150
	probby = 50
	spawned = list(	/obj/effect/landmark/events/haunts = 100	)

/*	..................   Loot spawners   ................... */
/obj/effect/spawner/map_spawner/loot
	icon_state = "lootblank"
	probby = 100
	var/datum/loot_table/loot_table_type

/obj/effect/spawner/map_spawner/loot/Initialize(mapload)
	. = ..()
	if(loot_table_type)
		var/datum/loot_table/table = new loot_table_type()
		// Spawn loot at this location without a specific looter
		var/list/weighted_list = table.return_list()
		var/spawn_count = rand(table.base_min, table.base_max)
		for(var/i = 1 to spawn_count)
			var/atom/spawn_path = pickweight(weighted_list)
			new spawn_path(get_turf(src))
		qdel(src)

/obj/effect/spawner/map_spawner/loot/common
	icon_state = "lootlow"
	loot_table_type = /datum/loot_table/common

/obj/effect/spawner/map_spawner/loot/medium
	icon_state = "lootmed"
	loot_table_type = /datum/loot_table/medium

/obj/effect/spawner/map_spawner/loot/rare
	icon_state = "loothigh"
	loot_table_type = /datum/loot_table/rare

/obj/effect/spawner/map_spawner/loot/magic
	icon_state = "lootmagic"
	loot_table_type = /datum/loot_table/magic

/obj/effect/spawner/map_spawner/loot/coin
	icon_state = "lootcoin"
	loot_table_type = /datum/loot_table/coin

/obj/effect/spawner/map_spawner/loot/coin/low
	icon_state = "lootcoinlow"
	loot_table_type = /datum/loot_table/coin/low

/obj/effect/spawner/map_spawner/loot/coin/med
	icon_state = "lootcoinmed"
	loot_table_type = /datum/loot_table/coin/med

/obj/effect/spawner/map_spawner/loot/coin/high
	icon_state = "lootcoinhigh"
	loot_table_type = /datum/loot_table/coin/high

/obj/effect/spawner/map_spawner/loot/coin/absurd
	icon_state = "lootcoinabsurd"
	loot_table_type = /datum/loot_table/coin/absurd

/obj/effect/spawner/map_spawner/loot/weapon
	icon_state = "lootweapon"
	loot_table_type = /datum/loot_table/weapon

/obj/effect/spawner/map_spawner/loot/armor
	icon_state = "lootarmor"
	loot_table_type = /datum/loot_table/armor

/obj/effect/spawner/map_spawner/loot/food
	icon_state = "lootfood"
	loot_table_type = /datum/loot_table/food

/obj/effect/spawner/map_spawner/loot/potion_vitals
	icon_state = "lootpotion"
	loot_table_type = /datum/loot_table/potion_vitals

/obj/effect/spawner/map_spawner/loot/potion_poisons
	icon_state = "lootpoison"
	loot_table_type = /datum/loot_table/potion_poisons

/obj/effect/spawner/map_spawner/loot/potion_ingredient
	icon_state = "lootpotioning"
	loot_table_type = /datum/loot_table/potion_ingredient

/obj/effect/spawner/map_spawner/loot/potion_ingredient/herb
	icon_state = "lootpotionherb"
	loot_table_type = /datum/loot_table/potion_ingredient/herb

/obj/effect/spawner/map_spawner/loot/potion_stats
	icon_state = "lootstatpot"
	loot_table_type = /datum/loot_table/potion_stats

/obj/effect/spawner/map_spawner/sewerencounter
	icon_state = "srat"
	icon = 'icons/roguetown/mob/monster/rat.dmi'
	probby = 50
	color = "#ff0000"
	spawned = list(
		/obj/item/reagent_containers/food/snacks/smallrat = 30,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 10,
		/obj/item/organ/guts = 5,
		/obj/item/coin/copper = 5,
		/obj/effect/gibspawner/generic = 5,
		/obj/effect/decal/remains/bigrat = 5,
		/mob/living/simple_animal/hostile/retaliate/bigrat = 1,
		)

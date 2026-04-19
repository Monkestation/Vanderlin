#define STABLE 0 //The tile is stable and won't collapse/sink when crossed.
#define COLLAPSE_ON_CROSS 1 //The tile is unstable and will temporary become unusable when crossed.
#define DESTROY_ON_CROSS 2 //The tile is nearly broken and will permanently become unusable when crossed.
#define UNIQUE_EFFECT 3 //The tile has some sort of unique effect when crossed.
//stone tiles for boss arenas
/obj/structure/stone_tile
	name = "stone tile"
	icon = 'icons/turf/boss_floors.dmi'
	icon_state = "pristine_tile1"
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/tile_key = "pristine_tile"
	var/tile_random_sprite_max = 24
	var/fall_on_cross = STABLE //If the tile has some sort of effect when crossed
	var/fallen = FALSE //If the tile is unusable
	var/falling = FALSE //If the tile is falling

/obj/structure/stone_tile/Initialize(mapload)
	. = ..()
	icon_state = "[tile_key][rand(1, tile_random_sprite_max)]"

/obj/structure/stone_tile/Destroy(force)
	if(force || fallen)
		. = ..()
	else
		return QDEL_HINT_LETMELIVE

/obj/structure/stone_tile/Crossed(atom/movable/AM)
	if(falling || fallen)
		return

	if(!fall_on_cross)
		return

	var/turf/T = get_turf(src)
	if(!islava(T)) //nothing to sink or fall into
		return

	if(fall_on_cross == UNIQUE_EFFECT)
		crossed_effect(AM)
		return

	// COLLAPSE_ON_CROSS or DESTROY_ON_CROSS implied

	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		if(I.w_class >= WEIGHT_CLASS_BULKY)
			start_collapse()

	if(isliving(AM))
		var/mob/living/L = AM
		if(!(L.movement_type & MOVETYPES_NOT_TOUCHING_GROUND) && L.mob_size >= MOB_SIZE_HUMAN)
			start_collapse()

/obj/structure/stone_tile/proc/start_collapse()
	falling = TRUE
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	Shake(-1, -1, 25)
	addtimer(CALLBACK(src, PROC_REF(collapse)), 0.5 SECONDS)

/obj/structure/stone_tile/proc/collapse()
	var/break_that_sucker = fall_on_cross == DESTROY_ON_CROSS
	if(break_that_sucker)
		playsound(src, 'sound/blank.ogg', 50, TRUE)
	else
		playsound(src, 'sound/blank.ogg', 50, TRUE)

	animate(src, alpha = 0, pixel_y = pixel_y - 3, time = 5)
	fallen = TRUE

	if(break_that_sucker)
		QDEL_IN(src, 10)
	else
		addtimer(CALLBACK(src, PROC_REF(rebuild)), 55)

/obj/structure/stone_tile/proc/rebuild()
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y - 5
	animate(src, alpha = initial(alpha), pixel_x = base_pixel_x, pixel_y = base_pixel_y, time = 30)
	sleep(30)
	falling = FALSE
	fallen = FALSE

/obj/structure/stone_tile/proc/crossed_effect(atom/movable/AM)
	return

/obj/structure/stone_tile/block
	name = "stone block"
	icon_state = "pristine_block1"
	tile_key = "pristine_block"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/slab
	name = "stone slab"
	icon_state = "pristine_slab1"
	tile_key = "pristine_slab"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/center
	name = "stone center tile"
	icon_state = "pristine_center1"
	tile_key = "pristine_center"
	tile_random_sprite_max = 4

/obj/structure/stone_tile/surrounding
	name = "stone surrounding slab"
	icon_state = "pristine_surrounding1"
	tile_key = "pristine_surrounding"
	tile_random_sprite_max = 2

/obj/structure/stone_tile/surrounding_tile
	name = "stone surrounding tile"
	icon_state = "pristine_surrounding_tile1"
	tile_key = "pristine_surrounding_tile"
	tile_random_sprite_max = 2

//cracked stone tiles
/obj/structure/stone_tile/cracked
	name = "cracked stone tile"
	icon_state = "cracked_tile1"
	tile_key = "cracked_tile"

/obj/structure/stone_tile/block/cracked
	name = "cracked stone block"
	icon_state = "cracked_block1"
	tile_key = "cracked_block"

/obj/structure/stone_tile/slab/cracked
	name = "cracked stone slab"
	icon_state = "cracked_slab1"
	tile_key = "cracked_slab"
	tile_random_sprite_max = 1

/obj/structure/stone_tile/center/cracked
	name = "cracked stone center tile"
	icon_state = "cracked_center1"
	tile_key = "cracked_center"

/obj/structure/stone_tile/surrounding/cracked
	name = "cracked stone surrounding slab"
	icon_state = "cracked_surrounding1"
	tile_key = "cracked_surrounding"
	tile_random_sprite_max = 1

/obj/structure/stone_tile/surrounding_tile/cracked
	name = "cracked stone surrounding tile"
	icon_state = "cracked_surrounding_tile1"
	tile_key = "cracked_surrounding_tile"

//burnt stone tiles
/obj/structure/stone_tile/burnt
	name = "burnt stone tile"
	icon_state = "burnt_tile1"
	tile_key = "burnt_tile"

/obj/structure/stone_tile/block/burnt
	name = "burnt stone block"
	icon_state = "burnt_block1"
	tile_key = "burnt_block"

/obj/structure/stone_tile/slab/burnt
	name = "burnt stone slab"
	icon_state = "burnt_slab1"
	tile_key = "burnt_slab"

/obj/structure/stone_tile/center/burnt
	name = "burnt stone center tile"
	icon_state = "burnt_center1"
	tile_key = "burnt_center"

/obj/structure/stone_tile/surrounding/burnt
	name = "burnt stone surrounding slab"
	icon_state = "burnt_surrounding1"
	tile_key = "burnt_surrounding"

/obj/structure/stone_tile/surrounding_tile/burnt
	name = "burnt stone surrounding tile"
	icon_state = "burnt_surrounding_tile1"
	tile_key = "burnt_surrounding_tile"

#undef STABLE
#undef COLLAPSE_ON_CROSS
#undef DESTROY_ON_CROSS
#undef UNIQUE_EFFECT
